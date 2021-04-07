// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class kmac_scoreboard extends cip_base_scoreboard #(
    .CFG_T(kmac_env_cfg),
    .RAL_T(kmac_reg_block),
    .COV_T(kmac_env_cov)
  );
  `uvm_component_utils(kmac_scoreboard)

  // local variables

  // this bit goes high when KMAC has finished processing the
  // prefix and the secret keys (only in KMAC mode)
  bit prefix_and_keys_done = 0;

  // this bit tracks the beginning and end of a KDF operation
  bit in_kdf;

  // this bit goes high for a cycle when a manual squeezing is requested
  bit req_manual_squeeze = 0;

  // this bit goes high a small delay after CmdProcess is requested,
  // used by fifo flushing logic to handle an edge case
  bit req_cmd_process_dly = 0;

  // This bit goes high if the fifo write pointer is incremented on the same cycle that
  // a CmdProcess is detected internally and the fifo starts to flush its contents
  bit incr_fifo_wr_in_process = 0;

  // This bit indicates that a CmdProcess has been seen while the KMAC is still processing
  // the prefix and secret keys (only used in KMAC mode)
  bit cmd_process_in_header = 0;

  // This bit indicates that the last block of a KDF request transaction has been sent
  // while the KMAC is still processing the prefix and secret keys
  bit kdf_last_in_header = 0;

  // This bit is toggled for half a clock cycle every time a new block of data
  // is transmitted via KDF app interface and received
  bit got_data_from_kdf = 0;

  // CFG fields
  bit kmac_en;
  sha3_pkg::sha3_mode_e hash_mode;
  sha3_pkg::keccak_strength_e strength;
  entropy_mode_e entropy_mode = EntropyModeNone;
  bit entropy_fast_process;
  bit entropy_ready;

  // CMD fields
  kmac_cmd_e kmac_cmd = CmdNone;

  bit msg_digest_done;

  // SHA3 status bits
  bit sha3_idle;
  bit sha3_absorb;
  bit sha3_squeeze;

  // FIFO model variables
  bit [4:0] fifo_depth;
  bit fifo_empty;
  bit fifo_full;

  bit intr_kmac_done;
  bit intr_fifo_empty;
  bit intr_kmac_err;

  // Variables to track the internal write/read pointers.
  //
  // One major difference between these and standard fifo pointers is that these
  // values will not loop back to 0 after hitting the max fifo depth.
  // These values will keep incrementing to keep some scoreboard logic simpler.
  int fifo_wr_ptr;
  int fifo_rd_ptr;

  // key length enum
  key_len_e key_len;

  // error reporting
  bit kmac_err;

  keymgr_pkg::hw_key_req_t sideload_key;

  bit [keymgr_pkg::KmacDataIfWidth-1:0]   kdf_block_data;
  bit [keymgr_pkg::KmacDataIfWidth/8-1:0] kdf_block_strb;
  int kdf_block_strb_size = 0;
  bit kdf_last;

  // secret keys
  //
  // max key size is 512-bits
  bit [KMAC_NUM_SHARES-1:0][KMAC_NUM_KEYS_PER_SHARE-1:0][31:0] keys;
  bit [KMAC_NUM_SHARES-1:0][KMAC_NUM_KEYS_PER_SHARE-1:0][31:0] keymgr_keys;

  // prefix words
  bit [31:0] prefix[KMAC_NUM_PREFIX_WORDS];

  // input message
  bit [7:0] msg[$];

  // input message from keymgr
  byte kdf_msg[$];

  // output digest from KDF (256 bits each)
  bit [keymgr_pkg::KeyWidth-1:0] kdf_digest_share0;
  bit [keymgr_pkg::KeyWidth-1:0] kdf_digest_share1;

  // output digests
  bit [7:0] digest_share0[];
  bit [7:0] digest_share1[];

  // This mask is used to mask reads from the state windows.
  // We need to make this a class variable as we set the mask value
  // during the address read phase, but then need its value to persist
  // through the data read phase.
  bit [TL_DBW-1:0] state_mask;

  // TLM fifos
  uvm_tlm_analysis_fifo #(keymgr_kmac_item) kdf_rsp_fifo;
  uvm_tlm_analysis_fifo #(push_pull_agent_pkg::push_pull_item #(
    .HostDataWidth(keymgr_kmac_agent_pkg::KMAC_REQ_DATA_WIDTH))) kdf_req_fifo;

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    kdf_req_fifo        = new("kdf_req_fifo", this);
    kdf_rsp_fifo        = new("kdf_rsp_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      detect_kdf_start();
      process_prefix_and_keys();
      process_msgfifo_write();
      process_msgfifo_status();
      process_sha3_idle();
      process_sha3_absorb();
      process_sha3_squeeze();
      process_initial_digest();
      process_manual_digest_squeeze();
      process_intr_kmac_done();
      process_kdf_req_fifo();
      process_kdf_rsp_fifo();
      process_sideload_key();
    join_none
  endtask

  // This task will check for any sideload keys that have been provided
  virtual task process_sideload_key();
    forever begin
      // Wait for a valid sideloaded key
      cfg.sideload_vif.wait_valid(logic'(1'b1));

      // Once valid sideload keys have been seen, update scoreboard state.
      //
      // Note: max size of sideloaded key is keymgr_pkg::KeyWidth

      sideload_key = cfg.sideload_vif.sideload_key;

      `uvm_info(`gfn, $sformatf("detected valid sideload_key: %0p", sideload_key), UVM_HIGH)

      for (int i = 0; i < keymgr_pkg::KeyWidth / 32; i++) begin
        keymgr_keys[0][i] = sideload_key.key_share0[i*32 +: 32];
        keymgr_keys[1][i] = sideload_key.key_share1[i*32 +: 32];
      end

      // Sequence will drop the sideloaded key after scb can process the digest
      cfg.sideload_vif.wait_valid(logic'(1'b0));
    end
  endtask

  // This task checks for the start of a KDF operation and updates scoreboard state accordingly.
  //
  // `process_kdf_req_fifo()` cannot be used for this purpose because the scb will only receive
  // a kdf_req item once the full request has been completed, which can consist of many
  // different request transactions.
  virtual task detect_kdf_start();
    forever begin
      // If we are not in KDF mode, the next time we see valid is the start
      // of a KDF operation
      //
      //wait (!in_kdf && cfg.m_kdf_agent_cfg.vif.kmac_data_req.valid);
      wait(!in_kdf &&
           cfg.m_kdf_agent_cfg.vif.req_data_if.valid &&
           cfg.m_kdf_agent_cfg.vif.req_data_if.ready);
      in_kdf = 1;
      `uvm_info(`gfn, "raised in_kdf", UVM_HIGH)
    end
  endtask

  // This task continuously checks the analysis_port of the push_pull_agent
  // in the keymgr_kmac_agent, as we need to know every time a data block is sent
  // over the KDF interface.
  virtual task process_kdf_req_fifo();
    push_pull_agent_pkg::push_pull_item#(
      .HostDataWidth(keymgr_kmac_agent_pkg::KMAC_REQ_DATA_WIDTH)) kdf_block_item;
    forever begin
        wait(!cfg.under_reset);
        @(posedge in_kdf);
        `DV_SPINWAIT_EXIT(
            forever begin
              kdf_req_fifo.get(kdf_block_item);
              `uvm_info(`gfn, $sformatf("Detected KDF data transfer:\n%0s", kdf_block_item.sprint()), UVM_HIGH)
              {kdf_block_data, kdf_block_strb, kdf_last} = kdf_block_item.h_data;
              kdf_block_strb_size = $countones(kdf_block_strb);
              got_data_from_kdf = 1;
              while (kdf_block_strb > 0) begin
                if (kdf_block_strb[0]) begin
                  kdf_msg.push_back(kdf_block_data[7:0]);
                end
                kdf_block_data = kdf_block_data >> 8;
                kdf_block_strb = kdf_block_strb >> 1;
              end
              `uvm_info(`gfn, $sformatf("kdf_msg: %0p", kdf_msg), UVM_HIGH)
              // drop `got_data_from_kdf` before the next cycle to avoid repeating
              // unnecessary state updates elsewhere in the scb
              cfg.clk_rst_vif.wait_n_clks(1);
              got_data_from_kdf = 0;
            end
            ,
            wait(cfg.under_reset || !in_kdf);
        )
    end
  endtask

  // This task processes the `kdf_rsp_fifo`.
  //
  // This fifo is populated once the KMAC has sent the response digest to
  // complete the KDF request.
  // As such, `in_kdf` must always be 1 when a response item is seen, otherwise
  // something has gone horribly wrong.
  //
  // It is important to note that when in KDF mode, any messages/keys/commands sent
  // to the CSRs will not be considered as valid, so this task needs to take care of checking
  // the KDF digest and clearing internal state for the next hash operation.
  virtual task process_kdf_rsp_fifo();
    keymgr_kmac_item kdf_rsp;
    forever begin
      kdf_rsp_fifo.get(kdf_rsp);
      `uvm_info(`gfn, $sformatf("Detected a KDF response:\n%0s", kdf_rsp.sprint()), UVM_HIGH)

      // safety check that things are working properly and no random KDF operations are seen
      `DV_CHECK_FATAL(in_kdf == 1, "in_kdf is not set, scoreboard has not picked up KDF request")

      // TODO error checks

      // assign digest values
      kdf_digest_share0 = kdf_rsp.rsp_digest_share0;
      kdf_digest_share1 = kdf_rsp.rsp_digest_share1;

      check_digest();

      in_kdf = 0;
      `uvm_info(`gfn, "dropped in_kdf", UVM_HIGH)

      clear_state();
    end
  endtask

  // This task updates the internal sha3_idle status field
  virtual task process_sha3_idle();
    forever begin
      // sha3_idle drops when CmdStart command is sent or a KDF op is detected
      @(posedge in_kdf or kmac_cmd == CmdStart);
      sha3_idle = 0;
      `uvm_info(`gfn, "dropped sha3_idle", UVM_HIGH)

      // sha3_idle goes high when either KDF op is complete or CmdDone command is sent by SW
      @(negedge in_kdf or kmac_cmd == CmdDone);
      sha3_idle = 1;
      `uvm_info(`gfn, "raised sha3_idle", UVM_HIGH)
    end
  endtask

  // This task updates the internal sha3_absorb status field
  virtual task process_sha3_absorb();
    forever begin
      // sha3_absorb should go high when CmdStart is written or
      // when KDF op is started
      @(posedge in_kdf or kmac_cmd == CmdStart);
      sha3_absorb = 1;
      `uvm_info(`gfn, "raised sha3_absorb", UVM_HIGH)

      // sha3_absorb should go low one cycle after KMAC has finished calculating digest
      @(posedge msg_digest_done);
      cfg.clk_rst_vif.wait_clks(1);
      sha3_absorb = 0;
      `uvm_info(`gfn, "dropped sha3_absorb", UVM_HIGH)
    end
  endtask

  // This task updates the internal sha3_squeeze status field
  virtual task process_sha3_squeeze();
    bit is_kdf_op;
    forever begin
      @(negedge sha3_idle);
      `DV_SPINWAIT_EXIT(
          forever begin
            // sha3_squeeze goes high one cycle after KMAC has finished calculating digest,
            @(posedge msg_digest_done);
            // latch whether we are doing a KDF op to accurate determine when to raise sha3_squeeze
            is_kdf_op = in_kdf;
            // don't have to wait if manually squezing, squeeze status goes high immediately
            // since immediate transition back into processing state
            if (kmac_cmd != CmdManualRun) begin
              cfg.clk_rst_vif.wait_clks(1);
            end
            sha3_squeeze = 1;
            `uvm_info(`gfn, "raised sha3_squeeze", UVM_HIGH)

            // sha3_squeeze goes low in one of three cases:
            // - manual squeezing is requested
            // - KDF operation finishes
            // - CmdDone is written
            `DV_SPINWAIT_EXIT(
                @(posedge req_manual_squeeze);
                ,
                wait(kmac_cmd == CmdDone || (is_kdf_op && !in_kdf));
            )
            sha3_squeeze = 0;
            `uvm_info(`gfn, "dropped sha3_squeeze", UVM_HIGH)
          end
          ,
          @(posedge sha3_idle or posedge cfg.under_reset);
      )
    end
  endtask

  // This task handles asserting the `kmac_done` interrupt bit
  virtual task process_intr_kmac_done();
    forever begin
      @(negedge sha3_idle);
      `DV_SPINWAIT_EXIT(
          wait(sha3_squeeze);
          // interrupt goes high 2 cycles after internal status is updated
          cfg.clk_rst_vif.wait_clks(2);
          // only assert kmac_done intr when not in KDF mode
          if (!in_kdf) intr_kmac_done = 1;
          `uvm_info(`gfn, "raised intr_kmac_done", UVM_HIGH)
          ,
          // we stop processing the kmac_done interrupt when either:
          // - a reset occurs
          // - a KDF operation finishes
          // - more digest is manually squeezed
          // - CmdDone command is written
          @(posedge cfg.under_reset or negedge in_kdf or
            kmac_cmd == CmdManualRun or kmac_cmd == CmdDone);
      )
    end
  endtask

  // This task implements a timing model to track processing of the KMAC header
  // (consisting of the prefix and secret keys), and asserts `prefix_and_keys_done` once
  // the processing is complete.
  // Naturally this only applies if KMAC mode is enabled.
  virtual task process_prefix_and_keys();
    forever begin
      wait(!cfg.under_reset);
      // Wait for KMAC to move out of IDLE state, meaning that:
      // - CmdStart has been issued
      // - KDF op has been started
      `DV_SPINWAIT_EXIT(
          @(negedge sha3_idle);
          ,
          wait(in_kdf == 1);
      )
      `uvm_info(`gfn, $sformatf("detected in_kdf: %0d", in_kdf), UVM_HIGH)

      // Disregard prefix/key processing if not using KMAC mode
      if (kmac_en) begin
        fork
          if (!in_kdf) begin : wait_cmd_process_header
            // We need to be able to detect if a CmdProcess is asserted in the middle of
            // processing the prefix and keys, as this changes the timing of how msgfifo
            // is flushed
            wait(kmac_cmd == CmdProcess);
            cmd_process_in_header = 1;
            `uvm_info(`gfn, "seen CmdProcess during prefix and key processing", UVM_HIGH)
          end : wait_cmd_process_header
          if (in_kdf) begin : wait_kdf_last_header
            // We need to be able to detect if the last block of a KDF request is sent
            // during processing of the prefix and secret keys, as this changes the timing
            wait(kdf_last == 1);
            kdf_last_in_header = 1;
            `uvm_info(`gfn, "seen kdf_last during prefix and key processing", UVM_HIGH)
          end
          begin : wait_process_header
            // If KMAC mode enabled, wait for the prefix and keys to be absorbed by keccak.
            //
            // Note that both absorptions will take the same number of cycles
            `uvm_info(`gfn, "starting to wait for prefix and key to be processed", UVM_HIGH)

            // if in_kdf is detected, we have sampled it right before the rising clock edge
            // in the same simulation timestep, need to synchronize to this clock edge
            // to avoid having it be caught when we're waiting for sha3pad to process everything
            if (in_kdf) begin
              cfg.clk_rst_vif.wait_clks(1);
            end

            repeat (2) begin
              // wait either 21 or 17 cycles for sha3pad logic to send the prefix/key
              // to the keccak_round logic (this is the keccak rate)
              cfg.clk_rst_vif.wait_clks(sha3_pkg::KeccakRate[strength]);
              `uvm_info(`gfn, "finished waiting for sha3pad process", UVM_HIGH)

              // Keccak logic needs 1 cycle to latch internal control signal
              // after sha3pad finishes transmitting prefix/key data blocks
              cfg.clk_rst_vif.wait_clks(1);

              // wait for the keccak logic to perform KECCAK_NUM_ROUNDS rounds
              wait_keccak_rounds();

            end
            prefix_and_keys_done = 1;
            `uvm_info(`gfn, "finished processing prefix and keys", UVM_HIGH)
            // Ensure that we can correctly capture scenario where CmdProcess is seen on
            // final cycle of prefix/key processing
            #0;
            disable wait_cmd_process_header;
            disable wait_kdf_last_header;
          end : wait_process_header
        join
      end
      @(posedge sha3_idle);
    end
  endtask

  // This task waits for the keccak logic to complete a full KECCAK_NUM_ROUNDS rounds
  //
  // This task must only be called after sha3pad logic has transmitted all KeccakRate
  // blocks to keccak logic
  virtual task wait_keccak_rounds();
    int unsigned total_cycles = 0;
    if (cfg.enable_masking) begin
      // If masking is enabled then entropy is used,
      // timing is more complex because of the various entropy features
      //
      // TODO: entropy_fast_process is currently disabled,
      //       need to support when enabled in sequence

      if (entropy_mode == EntropyModeSw) begin
        // All rounds will take SW_ENTROPY_ROUND_CYCLES_NO_FAST cycles each, except the first one.
        //
        // Without fast entropy, the internal 320-bit entropy state needs to be "refilled" for
        // each round, adding a 5-cycle latency per round (64 bits "filled" at a time).
        //
        // However, by the time `run_i` is asserted to keccak logic, the entropy state will
        // already be "filled up" in the time it takes for sha3pad to transmit data.
        //
        // So, latency of first round will be 3 cycles, one for the entropy FSM to transition and
        // start entropy expansion and 2 for keccak logic to latch this entropy.
        total_cycles = 3 + (SW_ENTROPY_ROUND_CYCLES_NO_FAST * (KECCAK_NUM_ROUNDS - 1));
      end else if (entropy_mode == EntropyModeEdn) begin
        // TODO: EDN entropy isn't supported in sequences yet
      end else begin
        // TODO: to uvm_fatal or not to uvm_fatal?
      end

    end else begin
      // If masking is disabled then no entropy is used,
      // so just wait KECCAK_NUM_ROUNDS cycles
      total_cycles = KECCAK_NUM_ROUNDS;
    end

    `uvm_info(`gfn, "starting to wait for keccak", UVM_HIGH)
    cfg.clk_rst_vif.wait_clks(total_cycles);
    // need to wait for one final cycle for sha3 wrapper logic to latch Keccak `complete` signal
    cfg.clk_rst_vif.wait_clks(1);
    `uvm_info(`gfn, "finished waiting for keccak", UVM_HIGH)
  endtask

  // This task implements a timing model to correctly assert the `msg_digest_done`signal,
  // and also tracks the read interface to the msgfifo, as both are linked.
  virtual task process_initial_digest();
    bit do_increment;
    bit cmd_process_in_keccak_and_blocks_left;
    bit kdf_last_in_keccak;
    bit run_final_keccak;

    int num_blocks_filled = 0;

    forever begin
      wait(!cfg.under_reset);
      `DV_SPINWAIT_EXIT(
          wait(sha3_idle == 0);
          ,
          wait(in_kdf == 1);
      )

      // reset internal task state on each iteration
      do_increment = 0;
      cmd_process_in_keccak_and_blocks_left = 0;
      kdf_last_in_keccak = 0;

      // If KMAC mode enabled, the msgfifo will only be read from once
      // the prefix and keys have been processed.
      //
      // This is guaranteed to happen after sha3_idle goes low, as the prefix and keys only start
      // being processed once the DUT receives CmdStart command.
      if (kmac_en) begin
        @(posedge prefix_and_keys_done);

        // KDF mode will instantly start transmitting data to the msgfifo without a delay
        if (!in_kdf) begin
          cfg.clk_rst_vif.wait_clks(1);

          // There is a particularly tricky edge case where addr_phase_write of a CmdProcess command
          // is detected one cycle after KMAC finishes processing the prefix and secret keys.
          //
          // If this happens we need to directly increment fifo_rd_ptr and num_blocks_filled,
          // since we can only detect this scenario at the very end of the simulation timestep.
          //
          // Set `cmd_process_in_header` upon detecting this case so that we carry out
          // proper timing behavior.
          #0;
          if (kmac_cmd == CmdProcess && !cmd_process_in_header) begin
            `uvm_info(`gfn, "detected CmdProcess 1 cycle after process prefix/key", UVM_HIGH)
            fifo_rd_ptr++;
            num_blocks_filled++;
            cmd_process_in_header = 1;
            cfg.clk_rst_vif.wait_clks(1);
          end
        end
        `uvm_info(`gfn, "finished waiting for prefix/key processing", UVM_HIGH)
      end

      `uvm_info(`gfn, "starting to handle msgfifo writes", UVM_HIGH)

      `DV_SPINWAIT_EXIT(
          fork
            // This subprocess handles the control logic for when we are allowed
            // to increment the fifo_rd_ptr
            begin : process_msg_block
              // Starting immediately after either:
              //
              // - prefix and keys have been processed in KMAC mode,
              // - message has started being sent into the msgfifo
              //
              // Once we have a full set of blocks (21 or 17 blocks of 64-bits) of input message,
              // we must wait for this data to be process via a full keccak round before we can start
              // reading more data from the msgfifo
              forever begin
                do_increment = 0;
                run_final_keccak = 0;
                if (num_blocks_filled < sha3_pkg::KeccakRate[strength]) begin
                  `uvm_info(`gfn,
                      $sformatf("not enough blocks filled yet %0d/%0d",
                                num_blocks_filled, sha3_pkg::KeccakRate[strength]),
                      UVM_HIGH)
                  if ((!in_kdf && kmac_cmd == CmdProcess) || (in_kdf && kdf_last)) begin
                    `uvm_info(`gfn, "detected CmdProcess", UVM_HIGH)

                    `uvm_info(`gfn, $sformatf("fifo_rd_ptr: %0d", fifo_rd_ptr), UVM_HIGH)
                    `uvm_info(`gfn, $sformatf("fifo_wr_ptr: %0d", fifo_wr_ptr), UVM_HIGH)
                    `uvm_info(`gfn, $sformatf("msg.size() : %0d", msg.size()), UVM_HIGH)

                    // On a size 0 input message, simply wait 2 cycles for flushing and then
                    // wait for keccak rounds to run
                    //
                    // Note that when using the KDF application interface the message
                    // cannot have size 0 so we can skip this condition entirely
                    if (!in_kdf && msg.size() == 0) begin
                      `uvm_info(`gfn, "zero size message", UVM_HIGH)
                      cfg.clk_rst_vif.wait_clks(2);
                      run_final_keccak = 1;
                    end else begin
                      // If we get here it means that we don't have a full set of blocks ready for
                      // the keccak logic.
                      // As a result, we must now wait until the fifo has been completely flushed
                      // and is completely empty.

                      // This bit is used to detect scenario when a new block is written to msgfifo
                      // during the 2 cycle flushing process, timing needs to change accordingly
                      bit incr_fifo_wr_in_flush = 0;

                      // Never enter this condition in KDF mode unless
                      // one of the following edge cases are seen:
                      // - kdf_last is seen during keccak hashing of full dadta block
                      // - kdf_last is seen during processing of the prefix and secret key
                      if (!in_kdf || kdf_last_in_keccak || kdf_last_in_header) begin
                        // If both of the following two conditions are NOT true:
                        //  - we've seen CmdProcess during an earlier keccak run and still have
                        //    some data left in msgfifo/sha3pad
                        //  - we've seen CmdProcess while processing prefix and secret keys
                        //    (only in KMAC mode)
                        // Wait for the msgfifo to be flushed, while simultaneously detecting
                        // for a msgfifo write during the flushing process
                        if (!in_kdf && !cmd_process_in_keccak_and_blocks_left &&
                            !cmd_process_in_header) begin
                          // If fifo_wr_ptr increments on the same cycle that we start flushing,
                          // need to immediately increment fifo_rd_ptr to match.
                          if (incr_fifo_wr_in_process) begin
                            do_increment = 1;
                            num_blocks_filled++;
                            cfg.clk_rst_vif.wait_n_clks(1);
                            do_increment = 0;
                          end
                          // This section waits several cycles for the flushing process to
                          // be completed, while also checking for an edge case where a fifo write
                          // goes through on the same cycle as the flush
                          fork
                            begin : wait_fifo_wr_in_flush
                              // If the fifo write pointer is incremented while we are flushing,
                              // we need to wait for another 2 cycles for the data to be correctly
                              // latched by the flushing logic.
                              // We can also increment the fifo_rd_ptr and increment
                              // num_blocks_filled as a result.
                              @(fifo_wr_ptr);
                              incr_fifo_wr_in_flush = 1;
                              do_increment = 1;
                              num_blocks_filled++;
                              `uvm_info(`gfn, "seen fifo_wr_ptr increment during flushing", UVM_HIGH)
                            end : wait_fifo_wr_in_flush
                            begin : wait_flush_cycles
                              // wait 2 cycles for the flushing process
                              `uvm_info(`gfn, "waiting 2 cycles for flushing", UVM_HIGH)
                              cfg.clk_rst_vif.wait_clks(2);
                              disable wait_fifo_wr_in_flush;
                            end : wait_flush_cycles
                          join

                          if (incr_fifo_wr_in_flush || incr_fifo_wr_in_process) begin
                            cfg.clk_rst_vif.wait_clks(2);
                          end
                        end

                        // Wait for all remaining blocks in msgfifo to flush out to sha3pad
                        while (!fifo_empty) begin
                          do_increment = 1;
                          num_blocks_filled++;

                          `uvm_info(`gfn, $sformatf("increment num_blocks_filled: %0d", num_blocks_filled), UVM_HIGH)
                          `uvm_info(`gfn, $sformatf("fifo_rd_ptr: %0d", fifo_rd_ptr), UVM_HIGH)
                          `uvm_info(`gfn, $sformatf("fifo_wr_ptr: %0d", fifo_wr_ptr), UVM_HIGH)

                          // wait until next timestep to ensure all state updates have settled
                          #1;
                          if (fifo_empty) begin
                            `uvm_info(`gfn, "fifo is empty, exiting while loop", UVM_HIGH)
                            // If any of the following conditions are true:
                            //
                            //  - we've seen CmdProcess during an earlier keccak run and still have
                            //    some data left in msgfifo/sha3pad
                            //  - we've seen CmdProcess while processing prefix and secret keys
                            //    (only in KMAC mode)
                            //  - we are in KDF mode (meaning that kdf_last was seen during
                            //    prefix/key processing or during a keccak data hashing round)
                            //
                            // Wait for the fifo to correctly transition through flush states,
                            // waiting an extra cycle delay if the `incr_fifo_wr_in_process` condition
                            // was met.
                            if (in_kdf || cmd_process_in_keccak_and_blocks_left ||
                                cmd_process_in_header) begin
                              cfg.clk_rst_vif.wait_clks(3);
                              if (incr_fifo_wr_in_process) begin
                                cfg.clk_rst_vif.wait_clks(1);
                              end
                              num_blocks_filled++;
                            end
                            break;
                          end else begin
                            // unset `do_increment` on the negedge to avoid infinite increments
                            cfg.clk_rst_vif.wait_n_clks(1);
                            do_increment = 0;
                          end
                          // If all blocks get filled up while we're flushing the fifo,
                          // run full keccak rounds on these blocks
                          if (num_blocks_filled == sha3_pkg::KeccakRate[strength]) begin
                            `uvm_info(`gfn, "all blocks full while flushing fifo, running keccak rounds", UVM_HIGH)
                            cfg.clk_rst_vif.wait_clks(1);
                            wait_keccak_rounds();
                            continue;
                          end
                          cfg.clk_rst_vif.wait_clks(1);
                        end
                      end else begin
                        // if we get here it is guaranteed that kdf_last has been set
                        //
                        // usually we will wait 4 cycles for a KDF op to finish flushing out the
                        // fifo and start runnning the rest of sha3pad process, with exception of
                        // some edge cases.
                        // use this bit to indicate when we should wait for these cycles.
                        bit wait_kdf_flush = 1;

                        // Similar timing logic as in `process_msgfifo_write()`
                        if (kdf_block_strb_size == keymgr_pkg::KmacDataIfWidth/8) begin
                          do_increment = 1;
                          num_blocks_filled++;
                          cfg.clk_rst_vif.wait_n_clks(1);
                          do_increment = 0;
                          if (num_blocks_filled == sha3_pkg::KeccakRate[strength]) begin
                            `uvm_info(`gfn, "filled up blocks while processing full kdf_last block", UVM_HIGH)
                            cfg.clk_rst_vif.wait_clks(1);
                            wait_keccak_rounds();
                            num_blocks_filled = 0;
                            // if need to run keccak rounds, fifo_rd_ptr increments one cycle later
                            // to transmit encoded output length to sha3pad
                            cfg.clk_rst_vif.wait_clks(1);
                          end else begin
                            // in the normal scenario, fifo_rd_ptr will increment 2 cycles later
                            // to transmit encoded output length to sha3pad logic
                            cfg.clk_rst_vif.wait_clks(2);
                          end
                          // increment fifo_rd_ptr to account for the block of encoded output length
                          do_increment = 1;
                          cfg.clk_rst_vif.wait_n_clks(1);
                          do_increment = 0;
                        end else if (kdf_block_strb_size + 3 < keymgr_pkg::KmacDataIfWidth/8) begin
                          cfg.clk_rst_vif.wait_clks(2);
                          do_increment = 1;
                          cfg.clk_rst_vif.wait_n_clks(1);
                          do_increment = 0;
                        end else if (kdf_block_strb_size + 3 >= keymgr_pkg::KmacDataIfWidth/8) begin
                          cfg.clk_rst_vif.wait_clks(1);
                          do_increment = 1;
                          num_blocks_filled++;
                          cfg.clk_rst_vif.wait_n_clks(1);
                          do_increment = 0;
                          if (kdf_block_strb_size + 3 > keymgr_pkg::KmacDataIfWidth/8) begin
                            cfg.clk_rst_vif.wait_clks(1);
                            do_increment = 1;
                            cfg.clk_rst_vif.wait_n_clks(1);
                            do_increment = 0;
                          end
                          if (num_blocks_filled == sha3_pkg::KeccakRate[strength]) begin
                            wait_kdf_flush = 0;
                            `uvm_info(`gfn, "filled up blocks while processing overflow kdf_last block", UVM_HIGH)
                            cfg.clk_rst_vif.wait_clks(1);
                            wait_keccak_rounds();
                            num_blocks_filled = 0;
                            cfg.clk_rst_vif.wait_clks(2);
                            num_blocks_filled++;
                          end
                        end
                        // wait the 4 cycles for KDF flushing to finish
                        if (wait_kdf_flush) begin
                          cfg.clk_rst_vif.wait_clks(4);
                          num_blocks_filled++;
                        end
                      end

                      run_final_keccak = 1;
                    end

                    if (run_final_keccak) begin
                      `uvm_info(`gfn,
                          $sformatf("waiting %0d cycles for sha3pad",
                                    sha3_pkg::KeccakRate[strength] - num_blocks_filled),
                          UVM_HIGH)
                      cfg.clk_rst_vif.wait_clks(sha3_pkg::KeccakRate[strength] - num_blocks_filled);

                      // wait one more cycle for keccak to latch sha3pad control signal
                      cfg.clk_rst_vif.wait_clks(1);

                      wait_keccak_rounds();

                      num_blocks_filled = 0;

                      // signal that the initial hash round has been completed
                      `uvm_info(`gfn, "raising msg_digest_done", UVM_HIGH)
                      msg_digest_done = 1;
                    end

                  end else begin
                    // we still don't have a full set of blocks to send to keccak yet.
                    //
                    // at this point, one of two things can happen:
                    //  1) more message can be written into the fifo, in which case we keep tracking
                    //  2) CmdProcess is written, meaning that we execute an earlier block of code
                    //     on the next cycle and flush out the remaining data to the keccak logic
                    //
                    // if another full block is written, increment the `num_blocks_filled` tracker
                    // and continue to the next cycle.
                    //
                    // Add a zero delay here to ensure all fifo-related state is correctly updated
                    #0;
                    `uvm_info(`gfn, "don't have a full set of blocks yet", UVM_HIGH)
                    `uvm_info(`gfn, $sformatf("num_blocks_filled: %0d", num_blocks_filled), UVM_HIGH)
                    `uvm_info(`gfn, $sformatf("fifo_wr_ptr: %0d", fifo_wr_ptr), UVM_HIGH)
                    `uvm_info(`gfn, $sformatf("fifo_rd_ptr: %0d", fifo_rd_ptr), UVM_HIGH)
                    if (fifo_wr_ptr > fifo_rd_ptr) begin
                      `uvm_info(`gfn, "have enough to fill another block", UVM_HIGH)
                      num_blocks_filled++;
                      `uvm_info(`gfn, $sformatf("increment num_blocks_filled: %0d", num_blocks_filled), UVM_HIGH)
                      do_increment = 1;
                    end

                    // Unset do_increment to avoid infinitely incrementing it
                    cfg.clk_rst_vif.wait_n_clks(1);
                    do_increment = 0;
                  end
                end else if (num_blocks_filled == sha3_pkg::KeccakRate[strength]) begin
                  // If we have filled up an entire set of blocks, we must immediately send it off
                  // to the keccak logic for hashing to be performed.
                  //
                  // During the time that keccak logic is active, need to detect an incoming
                  // CmdProcess request (only if not in KDF mode).
                  // If we see a CmdProcess be written, we can assert `msg_digest_done` after the current
                  // hash is complete.

                  bit sw_process_seen_in_keccak = 0;

                  `uvm_info(`gfn, "filled up keccak input blocks, sending to keccak to process", UVM_HIGH)

                  fork
                    begin : wait_for_cmd_process
                      wait(kmac_cmd == CmdProcess);
                      sw_process_seen_in_keccak = 1;
                    end : wait_for_cmd_process

                    begin : wait_for_kdf_last
                      wait(kdf_last == 1);
                      kdf_last_in_keccak = 1;
                    end : wait_for_kdf_last

                    begin : keccak_process_blocks
                      do_increment = 0;
                      num_blocks_filled = 0;
                      wait_keccak_rounds();

                      disable wait_for_cmd_process;
                      disable wait_for_kdf_last;
                    end : keccak_process_blocks
                  join

                  if (sw_process_seen_in_keccak) begin
                     `uvm_info(`gfn, "detected sw_cmd_process during keccak operation", UVM_HIGH)
                    if (fifo_empty) begin
                      // we have seen CmdProcess be written during operation of the keccak logic,
                      // meaning that the message byte length is an exact multiple of the keccak
                      // block size.
                      //
                      // as a result, there will be one more round of sha3pad data transfer and keccak
                      // logic after this to account for the `pad10*1()` bytes.
                      //
                      // Wait 1 cycle for flushing
                      cfg.clk_rst_vif.wait_clks(1);
                      // Wait for sha3pad to transmit all blocks to the keccak logic
                      cfg.clk_rst_vif.wait_clks(sha3_pkg::KeccakRate[strength]);
                      // Wait 1 more cycle for sha3pad control signal to be latched by keccak
                      cfg.clk_rst_vif.wait_clks(1);
                      wait_keccak_rounds();
                      // signal that the initial hash round has been completed
                      `uvm_info(`gfn, "raising msg_digest_done", UVM_HIGH)
                      msg_digest_done = 1;
                    end else begin
                      // If CmdProcess has been issued during keccak processing but we still have
                      // data left in the fifo, blocks will continue being sent to the
                      // sha3pad on the next cycle until the msgfifo is empty.
                      cmd_process_in_keccak_and_blocks_left = 1;
                      `uvm_info(`gfn, "we still have blocks left to process", UVM_HIGH)
                    end
                  end else if (kdf_last_in_keccak) begin
                    `uvm_info(`gfn, "detected kdf_last during keccak operation", UVM_HIGH)
                  end else begin
                    `uvm_info(`gfn, "did not detect sw_cmd_process during keccak operation, continue normal operation", UVM_HIGH)
                  end

                end else begin
                  `uvm_fatal(`gfn,
                      $sformatf("num_blocks_filled[%0d] > KeccakRate[strength][%0d]",
                                num_blocks_filled, sha3_pkg::KeccakRate[strength]))
                end
                cfg.clk_rst_vif.wait_clks(1);
              end

            end : process_msg_block

            // This subprocess handles the actual incrementation of fifo_rd_ptr
            begin : increment_fifo_rd_ptr
              forever begin
                wait((fifo_wr_ptr > fifo_rd_ptr) && do_increment);

                fifo_rd_ptr++;
                `uvm_info(`gfn, $sformatf("incremented fifo_rd_ptr: %0d", fifo_rd_ptr), UVM_HIGH)
                cfg.clk_rst_vif.wait_clks(1);
              end
            end : increment_fifo_rd_ptr
          join
          ,
          wait(cfg.under_reset || msg_digest_done);
      )
      wait(sha3_idle == 1);
    end
  endtask

  // This task handles updating the `msg_digest_done` value during any requested message squeezing,
  // not handled in `process_initial_digest()` as that is designed to just handle the initial
  // digest calculations and update the fifo pointers accordingly
  //
  // Note that squeezing more output can never happen during KDF operation
  virtual task process_manual_digest_squeeze();
    forever begin
      wait(!cfg.under_reset);
      @(negedge sha3_idle);
      `DV_SPINWAIT_EXIT(
          forever begin
            @(posedge req_manual_squeeze);
            msg_digest_done = 0;
            `uvm_info(`gfn, "dropping msg_digest_done", UVM_HIGH)

            wait_keccak_rounds();
            msg_digest_done = 1;
            `uvm_info(`gfn, "raising msg_digest_done", UVM_HIGH)
          end
          ,
          wait(cfg.under_reset);
      )
    end
  endtask

  // This task implements a timing model for the write interface to the msgfifo
  virtual task process_msgfifo_write();
    // This bit is used for in-process synchronization to indicate whether we have seen a CmdProcess
    // being issued and still more message remains in the FIFO
    bit cmd_process_write = 0;
    bit do_increment = 0;
    forever begin
      wait (!cfg.under_reset);
      `DV_SPINWAIT_EXIT(
          wait(sha3_idle == 0);
          ,
          wait(in_kdf == 1);
      )
      `DV_SPINWAIT_EXIT(
          forever begin
            // increment the write pointer by default
            do_increment = 1;

            if (in_kdf) begin
              // If executing a KDF op, the FIFO write pointer should increment every time
              // a new request item is sent from the application Host (otp_ctrl/rom_ctrl/keymgr),
              // as the app interfae mandates that each data transfer be at a 64-bit granularity.
              //
              // Note that we can still safely increment the fifo_wr_ptr on the KDF input
              // transaction where the `last` bit is set, as no more data will be sent until
              // either a reset is detected or until after the current transaction finishes.
              wait(got_data_from_kdf == 1);
              `uvm_info(`gfn, "got data from kdf", UVM_HIGH)
              // Note that when using the app interface, 0x2_0001 is appended to the last msgfifo
              // block to be filled (the encoded output length - output fixed at 256b), so we need
              // to account for this when incrementing the fifo_wr_ptr.
              //
              // As a result, 4 scenarios can happen when last data beat sent on the KDF interface:
              //
              // - A full data block is sent as the last data beat.
              //   When this happens, fifo_wr_ptr is incremented after one cycle as normal,
              //   but then needs to be incremented again after 2 more cycles to account for
              //   the encoded output length (0x2_0001).
              // - Second scenario occurs when the final data block appended to encoded output
              //   length is < 64bits.
              //   In this case, wait 1 cycle for appending the output length, then 2 cycles later
              //   fifo_wr_ptr is incremented.
              // - Third scenario occurs when final data block appended to encoded output length
              //   is exactly 64 bits.
              //   In this case, wait 1 cycle to append the output length, then 1 cyle later
              //   fifo_wwr_ptr is incremented.
              // - Final case is when the final data block appended to encoded output length is
              //   >64bits.
              //   In this case, wait 1 cycle for appending the output length, then fifo_wr_ptr is
              //   incremented twice in a row on 2 consecutive cycles to account for the overflow.
              //
              // Note that since the encoded output length is 0x2_0001, the mask size necessary for
              // just this segment is 3.
              if (kdf_last) begin
                `uvm_info(`gfn, $sformatf("kdf_block_strb_size: %0d", kdf_block_strb_size), UVM_HIGH)
                `uvm_info(`gfn, "kdf_last detected", UVM_HIGH)
                if (kdf_block_strb_size == keymgr_pkg::KmacDataIfWidth/8) begin
                  cfg.clk_rst_vif.wait_clks(1);
                  wait(fifo_wr_ptr - fifo_rd_ptr < KMAC_FIFO_DEPTH);
                  fifo_wr_ptr++;
                  cfg.clk_rst_vif.wait_clks(1);
                end else if (kdf_block_strb_size + 3 < keymgr_pkg::KmacDataIfWidth/8) begin
                  cfg.clk_rst_vif.wait_clks(2);
                end else if (kdf_block_strb_size + 3 == keymgr_pkg::KmacDataIfWidth/8) begin
                  cfg.clk_rst_vif.wait_clks(1);
                end else if (kdf_block_strb_size + 3 > keymgr_pkg::KmacDataIfWidth/8) begin
                  cfg.clk_rst_vif.wait_clks(2);
                  wait(fifo_wr_ptr - fifo_rd_ptr < KMAC_FIFO_DEPTH);
                  fifo_wr_ptr++;
                end
              end
            end else begin
              // If not executing a KDF op, the FIFO write pointer increments in two cases:
              // 1) When KMAC_FIFO_BYTES_PER_ENTRY bytes have been written to msgfifo.
              // 2) when CmdProcess is triggered and there is a non-zero amount of bytes in the msg,
              //    as CmdProcess signals the msg has finished, so need to account for remaining
              //    bytes.
              `uvm_info(`gfn, $sformatf("fifo_wr_ptr: %0d", fifo_wr_ptr), UVM_HIGH)
              wait((msg.size() >= ((fifo_wr_ptr + 1) * KMAC_FIFO_BYTES_PER_ENTRY)) ||
                   (kmac_cmd == CmdProcess && msg.size % KMAC_FIFO_BYTES_PER_ENTRY > 0));

              // If CmdProcess is written, no more message will be written to the fifo,
              // so we should only increment the write pointer if some bytes still have not been
              // processed (up to 1 word.
              //
              // e.g. if we are only able to write 3 bytes into a "fresh" fifo entry before writing
              //      CmdProcess, we should not increment the fifo write pointer as the entry is not
              //      overflowing.
              cmd_process_write = (kmac_cmd == CmdProcess && msg.size() > 0);
              if (cmd_process_write) begin
                do_increment = (msg.size() < fifo_wr_ptr * KMAC_FIFO_BYTES_PER_ENTRY) ? 0 : 1;
              end
            end

            if (do_increment) begin
              // If fifo is full, wait until it isn't
              if (fifo_wr_ptr - fifo_rd_ptr == KMAC_FIFO_DEPTH) begin
                wait (fifo_wr_ptr - fifo_rd_ptr < KMAC_FIFO_DEPTH);
              end

              // update the fifo_wr_ptr
              cfg.clk_rst_vif.wait_clks(1);
              fifo_wr_ptr++;
              `uvm_info(`gfn, $sformatf("incremented fifo_wr_ptr: %0d", fifo_wr_ptr), UVM_HIGH)

              incr_fifo_wr_in_process = req_cmd_process_dly;
              `uvm_info(`gfn,
                        $sformatf("seen fifo_wr_ptr increment during CmdProcess: %0d",
                                  incr_fifo_wr_in_process),
                        UVM_HIGH)

            end
            cfg.clk_rst_vif.wait_clks(1);
          end
          ,
          wait(cfg.under_reset || msg_digest_done);
      )
      wait(sha3_idle == 1);
    end
  endtask

  // This task implements a timing model to update fifo_empty, fifo_depth, fifo_full status
  virtual task process_msgfifo_status();
    forever begin
      wait(!cfg.under_reset);
      `DV_SPINWAIT_EXIT(
          fork
            forever begin : update_fifo_state
              @(fifo_wr_ptr, fifo_rd_ptr);

              // update the general fifo status fields
              fifo_depth = fifo_wr_ptr - fifo_rd_ptr;
              fifo_empty = (fifo_depth == 0);
              fifo_full  = fifo_depth == KMAC_FIFO_DEPTH;

              `uvm_info(`gfn, $sformatf("fifo_depth: %0d", fifo_depth), UVM_HIGH)
              `uvm_info(`gfn, $sformatf("fifo_empty: %0d", fifo_empty), UVM_HIGH)
              `uvm_info(`gfn, $sformatf("fifo_full: %0d", fifo_full), UVM_HIGH)
            end : update_fifo_state

            forever begin : update_fifo_intr

              // fifo_empty interrupt will only be asserted if the fifo becomes empty
              // after its depth has been greater than 0 to prevent random assertions
              @(fifo_wr_ptr, fifo_rd_ptr);
              #1;
              if (fifo_wr_ptr > fifo_rd_ptr) begin
                `uvm_info(`gfn, "fifo_wr_ptr is greater than fifo_rd_ptr", UVM_HIGH)
                while (fifo_wr_ptr != fifo_rd_ptr) begin
                  cfg.clk_rst_vif.wait_clks(1);
                  #1;
                end
                `uvm_info(`gfn, "fifo pointers are now equal", UVM_HIGH)
                cfg.clk_rst_vif.wait_clks(2);
                if (!intr_fifo_empty) intr_fifo_empty = 1;
                `uvm_info(`gfn, "raised intr_fifo_empty", UVM_HIGH)
              end else begin
                continue;
              end
            end : update_fifo_intr
          join
          ,
          @(posedge sha3_idle or posedge cfg.under_reset);
      )
    end
  endtask

  virtual task process_tl_access(tl_seq_item item, tl_channels_e channel, string ral_name);
    uvm_reg csr;
    dv_base_reg check_locked_reg;

    string csr_name = "";

    bit msgfifo_access;
    bit share0_access;
    bit share1_access;

    bit     do_read_check         = 1'b1;
    bit     write                 = item.is_write();
    uvm_reg_addr_t csr_addr       = ral.get_word_aligned_addr(item.a_addr);
    bit [TL_AW-1:0] csr_addr_mask = ral.get_addr_mask();

    bit addr_phase_read   = (!write && channel == AddrChannel);
    bit addr_phase_write  = (write && channel == AddrChannel);
    bit data_phase_read   = (!write && channel == DataChannel);
    bit data_phase_write  = (write && channel == DataChannel);

    // if access was to a valid csr, get the csr handle
    if (csr_addr inside {cfg.csr_addrs}) begin
      csr = ral.default_map.get_reg_by_offset(csr_addr);
      `DV_CHECK_NE_FATAL(csr, null)
      `downcast(check_locked_reg, csr)

      csr_name = csr.get_name();

      // if incoming access is a write to valid csr, immediately make updates
      if (addr_phase_write) begin

        // following csrs are locked by CFG_REGWEN:
        // - cfg
        // - entropy_period
        // - entropy_seed_lower
        // - entropy_seed_upper
        // - key_len
        // if writes to these csrs are seen, must check that they are not locked first.
        if (ral.cfg_regwen.locks_reg_or_fld(check_locked_reg) &&
            `gmv(ral.cfg_regwen) == 0) return;

        void'(csr.predict(.value(item.a_data), .kind(UVM_PREDICT_WRITE), .be(item.a_mask)));
      end
    end else if ((csr_addr & csr_addr_mask) inside {[KMAC_FIFO_BASE:KMAC_FIFO_END]}) begin
      // msgfifo window
      msgfifo_access = 1;
    end else if ((csr_addr & csr_addr_mask) inside {[KMAC_STATE_SHARE0_BASE:KMAC_STATE_SHARE0_END]}) begin
      // state window 0
      share0_access = 1;
    end else if ((csr_addr & csr_addr_mask) inside {[KMAC_STATE_SHARE1_BASE:KMAC_STATE_SHARE1_END]}) begin
      // state window 1
      share1_access = 1;
    end else begin
      `uvm_fatal(`gfn, $sformatf("Access unexpected addr 0x%0h", csr_addr))
    end

    // process the csr req
    // for write, update local variable and fifo at address phase
    // for read, update predication at address phase and compare at data phase
    case (csr_name)
      // add individual case item for each csr
      "intr_state": begin
        if (data_phase_write) begin
          // clear internal state on a write
          if (item.a_data[KmacDone])      intr_kmac_done = 0;
          if (item.a_data[KmacFifoEmpty]) intr_fifo_empty = 0;
          if (item.a_data[KmacErr])       intr_kmac_err = 0;
        end else if (addr_phase_read) begin

          void'(ral.intr_state.kmac_done.predict(
              .value(intr_kmac_done), .kind(UVM_PREDICT_READ)));
          void'(ral.intr_state.kmac_err.predict(
              .value(intr_kmac_err), .kind(UVM_PREDICT_READ)));
          void'(ral.intr_state.fifo_empty.predict(
              .value(intr_fifo_empty), .kind(UVM_PREDICT_READ)));

        end
      end
      "intr_enable": begin
        // no need to do anything here, functionality is tested in the automated intr tests,
        // and any issues here will become known if any checks on `intr_state` fail
      end
      "intr_test": begin
        if (addr_phase_write) begin
          bit [TL_DW-1:0] intr_en = `gmv(ral.intr_enable);
          bit [KmacNumIntrs-1:0] intr_exp = item.a_data | `gmv(ral.intr_state);

          void'(ral.intr_state.predict(.value(intr_exp), .kind(UVM_PREDICT_DIRECT)));

          // sample coverage
          if (cfg.en_cov) begin
            foreach (intr_exp[i]) begin
              cov.intr_test_cg.sample(i, item.a_data[i], intr_en[i], intr_exp[i]);
            end
          end
        end
      end
      "cfg_regwen": begin
        // do nothing
      end
      "cfg": begin
        if (addr_phase_write) begin
          // don't continue if the KMAC is currently operating
          //
          // TODO this is an error case that needs to be handled
          if (!(kmac_cmd inside {CmdNone, CmdDone})) begin
            return;
          end

          kmac_en              = item.a_data[KmacEn];
          entropy_fast_process = item.a_data[KmacFastEntropy];
          entropy_ready        = item.a_data[KmacEntropyReady];

          hash_mode = sha3_pkg::sha3_mode_e'(item.a_data[KmacModeMSB:KmacModeLSB]);

          strength = sha3_pkg::keccak_strength_e'(item.a_data[KmacStrengthMSB:KmacStrengthLSB]);

          entropy_mode = entropy_mode_e'(item.a_data[KmacEntropyModeMSB:KmacEntropyModeLSB]);

          // TODO - sample coverage
        end
      end
      "cmd": begin
        // Writing to CMD will always result in the KMAC doing something
        //
        // TODO - handle error cases
        if (addr_phase_write) begin
          case (kmac_cmd_e'(item.a_data))
            CmdStart: begin
              // msgfifo will now be written
              kmac_cmd = CmdStart;
            end
            CmdProcess: begin
              // kmac will now compute the digest
              kmac_cmd = CmdProcess;

              // Raise this bit after a small delay to handle an edge case where
              // fifo_wr_ptr and fifo_rd_ptr both increment on same cycle that CmdProcess
              // is latched by internal scoreboard logic
              #1 req_cmd_process_dly = 1;
              `uvm_info(`gfn, "raised req_cmd_process_dly", UVM_HIGH)
            end
            CmdManualRun: begin
              // kmac will now squeeze more output data
              kmac_cmd = CmdManualRun;
              req_manual_squeeze = 1;
              `uvm_info(`gfn, "raised req_manual_squeeze", UVM_HIGH)
            end
            CmdDone: begin
              kmac_cmd = CmdDone;

              // Calculate the digest using DPI and check for correctness
              check_digest();

              // Flush all scoreboard state to prepare for the next hash operation
              clear_state();

              // IDLE should go high one cycle after issuing Done cmd
              cfg.clk_rst_vif.wait_clks(1);
              sha3_idle = 1;
            end
            CmdNone: begin
              // RTL internal value, doesn't actually do anything
            end
            default: begin
              `uvm_fatal(`gfn, $sformatf("%0d is an illegal CMD value", item.a_data))
            end
          endcase
        end else begin
          // this bit will be set to 0 during the data phase of the write,
          // providing better detection of when exactly a manual squeeze command
          // has been requested
          req_manual_squeeze = 0;
          `uvm_info(`gfn, "dropped req_manual_squeeze", UVM_HIGH)

          #1 req_cmd_process_dly = 0;
          `uvm_info(`gfn, "dropped req_cmd_process_dly", UVM_HIGH)
        end
      end
      "status": begin

        // TODO - in data_phase_read sample coverage

        if (addr_phase_read) begin
          bit [TL_DW-1:0] exp_status;

          exp_status[KmacStatusSha3Idle]    = sha3_idle;
          exp_status[KmacStatusSha3Absorb]  = sha3_absorb;
          exp_status[KmacStatusSha3Squeeze] = sha3_squeeze;

          exp_status[KmacStatusFifoDepthMSB : KmacStatusFifoDepthLSB] = fifo_depth;

          exp_status[KmacStatusFifoEmpty] = fifo_empty;
          exp_status[KmacStatusFifoFull]  = fifo_full;

          void'(ral.status.predict(.value(exp_status), .kind(UVM_PREDICT_READ)));

        end
      end
      "key_len": begin
        // TODO need to do error checking
        if (addr_phase_write) begin
          key_len = key_len_e'(item.a_data);
        end
      end
      "err_code": begin
        // TODO don't do anything rn, need implement the error checking
      end
      // TODO - entropy csrs
      default: begin
        // regex match the key_share csrs
        string full_idx;
        string split_idx[$];
        string key_share;
        string key_idx;

        // KEY_SHARE csrs
        if (!uvm_re_match("key_share*", csr_name)) begin
          full_idx = csr_name.substr(9, csr_name.len()-1);
          str_utils_pkg::str_split(full_idx, split_idx, "_");
          // safety check that the regex is working correctly
          `DV_CHECK_FATAL(split_idx.size() == 2,
              $sformatf("%0s does not contain a correct key index!", full_idx))
          key_share = split_idx.pop_front();
          key_idx = split_idx.pop_front();

          // If keys are being written, update the scoreboard state
          if (addr_phase_write) begin
            keys[key_share.atoi()][key_idx.atoi()] = item.a_data;
          end
        // PREFIX csrs
        end else if (!uvm_re_match("prefix_*", csr_name)) begin
          str_utils_pkg::str_split(csr_name, split_idx, "_");
          full_idx = split_idx.pop_back();

          if (addr_phase_write) begin
            prefix[full_idx.atoi()] = item.a_data;
          end
        end
      end
    endcase

    ////////////////////////////////////////////
    // Process incoming writes to the msgfifo //
    ////////////////////////////////////////////
    //
    // One problem with the scoreboard only having access to the data written to the msgfifo
    // is that the message is post-fixed with the encoded output length if KMAC mode is used.
    //
    // However there is no way to access it other than to calculate the length of the seen digest.
    // Even though it is somewhat hacky, this is the approach we'll take.
    // If the length of the calculated output is incorrect for whatever reason (scoreboard error
    // or RTL error), then passing this value into the DPI model will result in an incorrect
    // digest comparison.
    if (msgfifo_access) begin
      if (addr_phase_write) begin
        if (kmac_cmd != CmdStart) begin
          // TODO
          //
          // If we get here we are writing to the msgfifo in an invalid state.
          // Implement error checking here.
        end else if (!cfg.under_reset) begin
          bit [7:0] full_data[4];
          bit [7:0] masked_data[];

          {<< byte {full_data}} = item.a_data;

          `uvm_info(`gfn, $sformatf("item.a_data: 0x%0x", item.a_data), UVM_HIGH)
          `uvm_info(`gfn, $sformatf("item.a_mask: 0b%0b", item.a_mask), UVM_HIGH)
          `uvm_info(`gfn, $sformatf("full_data: %0p", full_data), UVM_HIGH)

          // All writes in big-endian order will be full-word,
          // so we can generalize this to a for-loop that reverses the byte order of each word.
          // This way we can also preserve little-endian ordering.
          for (int i = 0; i < TL_DBW; i++) begin
            if (item.a_mask[i]) begin
              masked_data = `gmv(ral.cfg.msg_endianness) ? {full_data[i], masked_data} :
                                                           {masked_data, full_data[i]};
            end
          end
          msg = {msg, masked_data};

          `uvm_info(`gfn, $sformatf("masked_data: %0p", masked_data), UVM_HIGH)
          `uvm_info(`gfn, $sformatf("msg: %0p", msg), UVM_HIGH)
        end
      end
      // indicate that the msgfifo access is now over
      msgfifo_access = 0;
    end

    ///////////////////////////////////////////////////
    // Process incoming reads from the digest window //
    ///////////////////////////////////////////////////

    if (share0_access || share1_access) begin
      bit [TL_DW-1:0] digest_word;
      bit [7:0] digest_byte;
      bit  [TL_DBW-1:0] state_mask;

      `uvm_info(`gfn, $sformatf("share0: %0d", share0_access), UVM_HIGH)
      `uvm_info(`gfn, $sformatf("share1: %0d", share1_access), UVM_HIGH)

      if (data_phase_read) begin
        state_mask = item.a_mask;
        digest_word = item.d_data;

        `uvm_info(`gfn, $sformatf("state read mask: 0b%0b", state_mask), UVM_HIGH)
        `uvm_info(`gfn, $sformatf("digest_word: 0x%0x", digest_word), UVM_HIGH)

        if (`gmv(ral.cfg.state_endianness)) begin
          digest_word = {<< byte {digest_word}};
          state_mask = {<< bit {state_mask}};

          `uvm_info(`gfn, $sformatf("endian-swapped digest word: 0x%0x", digest_word), UVM_HIGH)
          `uvm_info(`gfn, $sformatf("endian-swapped read mask: 0b%0b", state_mask), UVM_HIGH)
        end
        for (int i = 0; i < TL_DBW; i++) begin
          if (state_mask[i]) begin
            digest_byte = digest_word[i*8 +: 8];
            `uvm_info(`gfn, $sformatf("digest_byte: 0x%0x", digest_byte), UVM_HIGH)

            if (share0_access) begin
              digest_share0 = {digest_share0, digest_byte};
              `uvm_info(`gfn, $sformatf("intermediate digest_share0: %0p", digest_share0), UVM_HIGH)
            end else if (share1_access) begin
              digest_share1 = {digest_share1, digest_byte};
              `uvm_info(`gfn, $sformatf("intermediate digest_share1: %0p", digest_share1), UVM_HIGH)
            end
          end
        end
      end

      // If we read the state digest in either CmdStart or CmdDone states,
      // we should read back all zeroes.
      // Check immediately and clear the digest arrays.
      if (kmac_cmd inside {CmdNone, CmdStart, CmdDone}) begin
        foreach (digest_share0[i]) begin
          `DV_CHECK_EQ_FATAL(digest_share0[i], '0,
              $sformatf("Share 0 should be zero in state %0s", kmac_cmd.name()))
          digest_share0 = {};
        end
        foreach (digest_share1[i]) begin
          `DV_CHECK_EQ_FATAL(digest_share1[i], '0,
              $sformatf("Share 1 should be zero in state %0s", kmac_cmd.name()))
          digest_share1 = {};
        end
      end
      share0_access = 0;
      share1_access = 0;
    end

    // On reads, if do_read_check, is set, then check mirrored_value against item.d_data
    if (data_phase_read && csr_name != "") begin
      if (do_read_check) begin
        `DV_CHECK_EQ(csr.get_mirrored_value(), item.d_data,
                     $sformatf("reg name: %0s", csr.get_full_name()))
      end
      void'(csr.predict(.value(item.d_data), .kind(UVM_PREDICT_READ)));
    end
  endtask : process_tl_access

  virtual function void reset(string kind = "HARD");
    super.reset(kind);
    clear_state();

    // status tracking bits
    sha3_idle     = ral.status.sha3_idle.get_reset();
    sha3_absorb   = ral.status.sha3_absorb.get_reset();
    sha3_squeeze  = ral.status.sha3_squeeze.get_reset();
    fifo_depth    = ral.status.fifo_depth.get_reset();
    fifo_empty    = ral.status.fifo_empty.get_reset();
    fifo_full     = ral.status.fifo_full.get_reset();
  endfunction

  // This function should be called to reset internal state to prepare for a new hash operation
  virtual function void clear_state();
    `uvm_info(`gfn, "clearing scoreboard state", UVM_HIGH)

    msg.delete();
    kdf_msg.delete();

    kdf_block_data      = '0;
    kdf_block_strb      = '0;
    kdf_block_strb_size = 0;
    kdf_last            = 0;
    got_data_from_kdf   = 0;

    prefix_and_keys_done  = 0;
    req_manual_squeeze    = 0;
    cmd_process_in_header = 0;
    kdf_last_in_header    = 0;
    msg_digest_done       = 0;
    fifo_rd_ptr           = 0;
    fifo_wr_ptr           = 0;

    keys              = '0;
    keymgr_keys       = '0;
    sideload_key      = '0;
    prefix            = '{default:0};
    digest_share0     = {};
    digest_share1     = {};
    kdf_digest_share0 = '0;
    kdf_digest_share1 = '0;
  endfunction

  // This function is called whenever a CmdDone command is issued to KMAC,
  // and will compare the seen digest against the digest calculated from the DPI model.
  //
  // Though we don't have direct access to the specified output length for XOF functions,
  // the last byte written to the msgfifo (only for XOFs) will be the number of preceding bytes
  // that encode the requested output length.
  // From this we can decode what the initially requested output length is.
  //
  // We also need to decode what the prefix is (only for KMAC), as only the encoded values
  // are written to the CSRs.  virtual function void check_digest();
  virtual function void check_digest();

    // Cast to an array so we can pass this into the DPI functions
    bit [7:0] msg_arr[];

    // Determines which kmac variant to use
    bit xof_en;

    // Set this to the calculated output length for XOFs
    int output_len_bytes;

    // Array to hold the digest read from the state windows
    bit [7:0] unmasked_digest[];

    // Array to hold the expected digest calculated by DPI model
    bit [7:0] dpi_digest[];

    // Function name and customization strings for KMAC operations
    string fname;
    string custom_str;

    // Use this to store the correct set of keys (SW-provided or sideloaded)
    bit [KMAC_NUM_SHARES-1:0][KMAC_NUM_KEYS_PER_SHARE-1:0][31:0] exp_keys;

    // The actual key used for KMAC operations
    bit [31:0] unmasked_key[$];

    // key byte-stream for the DPI model
    bit [7:0] dpi_key_arr[];

    // Intermediate array for streaming `unmasked_key` into `dpi_key_arr`
    bit [7:0] unmasked_key_bytes[];

    int key_word_len = get_key_size_words(key_len);
    int key_byte_len = get_key_size_bytes(key_len);

    `uvm_info(`gfn, $sformatf("key_word_len: %0d", key_word_len), UVM_HIGH)
    `uvm_info(`gfn, $sformatf("key_byte_len: %0d", key_byte_len), UVM_HIGH)

    // Calculate:
    // - the expected output length in bytes
    // - if we are using the xof version of kmac
    if (in_kdf) begin
      // KDF output will always be 256 bits (32 bytes)
      output_len_bytes = 32;

      // xof_en is 1 when the padded output length is 0,
      // but this will never happen in KDF
      xof_en = 0;
    end else begin
      get_digest_len_and_xof(output_len_bytes, xof_en, msg);

      // quick check that the calculated output length is the same
      // as the number of bytes read from the digest window
      `DV_CHECK_EQ_FATAL(digest_share0.size(), output_len_bytes,
          $sformatf("Calculated output length doesn't match actual output length!"))
    end

    `uvm_info(`gfn, $sformatf("output_len_bytes: %0d", output_len_bytes), UVM_HIGH)
    `uvm_info(`gfn, $sformatf("xof_en: %0d", xof_en), UVM_HIGH)

    // initialize arrays
    dpi_digest = new[output_len_bytes];
    unmasked_digest = new[output_len_bytes];

    /////////////////////////////////
    // Calculate the actual digest //
    /////////////////////////////////
    if (cfg.enable_masking) begin
      if (in_kdf) begin
        unmasked_digest = {<< byte {kdf_digest_share0 ^ kdf_digest_share1}};
      end else begin
        foreach (unmasked_digest[i]) begin
          unmasked_digest[i] = digest_share0[i] ^ digest_share1[i];
        end
      end
    end else begin
      if (in_kdf) begin
        unmasked_digest = {<< byte {kdf_digest_share0}};
      end else begin
        unmasked_digest = digest_share0;
      end
    end
    `uvm_info(`gfn, $sformatf("unmasked_digest: %0p", unmasked_digest), UVM_HIGH)

    ///////////////////////////////////////////////////////////
    // Calculate the expected digest using the DPI-C++ model //
    ///////////////////////////////////////////////////////////
    if (in_kdf) begin
      // kdf message is a byte array, cast to bit[7:0]
      msg_arr = new[kdf_msg.size()];
      foreach (kdf_msg[i]) begin
        msg_arr[i] = kdf_msg[i];
      end
    end else begin
      msg_arr = msg;
    end
    `uvm_info(`gfn, $sformatf("msg_arr for DPI mode: %0p", msg_arr), UVM_HIGH)

    case (hash_mode)
      ///////////
      // SHA-3 //
      ///////////
      sha3_pkg::Sha3: begin
        case (strength)
          sha3_pkg::L224: begin
            digestpp_dpi_pkg::c_dpi_sha3_224(msg_arr, msg_arr.size(), dpi_digest);
          end
          sha3_pkg::L256: begin
            digestpp_dpi_pkg::c_dpi_sha3_256(msg_arr, msg_arr.size(), dpi_digest);
          end
          sha3_pkg::L384: begin
            digestpp_dpi_pkg::c_dpi_sha3_384(msg_arr, msg_arr.size(), dpi_digest);
          end
          sha3_pkg::L512: begin
            digestpp_dpi_pkg::c_dpi_sha3_512(msg_arr, msg_arr.size(), dpi_digest);
          end
          default: begin
            `uvm_fatal(`gfn, $sformatf("strength[%0s] is not allowed for sha3", strength.name()))
          end
        endcase
      end
      ///////////
      // SHAKE //
      ///////////
      sha3_pkg::Shake: begin
        case (strength)
          sha3_pkg::L128: begin
            digestpp_dpi_pkg::c_dpi_shake128(msg_arr, msg_arr.size(), output_len_bytes, dpi_digest);
          end
          sha3_pkg::L256: begin
            digestpp_dpi_pkg::c_dpi_shake256(msg_arr, msg_arr.size(), output_len_bytes, dpi_digest);
          end
          default: begin
            `uvm_fatal(`gfn, $sformatf("strength[%0s] is not allowed for shake", strength.name()))
          end
        endcase
      end
      ////////////
      // CSHAKE //
      ////////////
      sha3_pkg::CShake: begin
        if (kmac_en) begin
          // Get the fname and custom_str string values from the writes to PREFIX csrs
          get_fname_and_custom_str(fname, custom_str);

          // Calculate the unmasked key
          exp_keys = `gmv(ral.cfg.sideload) ? keymgr_keys : keys;
          for (int i = 0; i < key_word_len; i++) begin
            // Sideloaded keys are treated as two-share masked form by default, need to xor them
            if (cfg.enable_masking || `gmv(ral.cfg.sideload)) begin
              unmasked_key.push_back(exp_keys[0][i] ^ exp_keys[1][i]);
            end else begin
              unmasked_key.push_back(exp_keys[0][i]);
            end
            `uvm_info(`gfn, $sformatf("unmasked_key[%0d] = 0x%0x", i, unmasked_key[i]), UVM_HIGH)
          end

          // Convert the key array into a byte array for the DPI model
          unmasked_key_bytes = {<< 32 {unmasked_key}};
          dpi_key_arr = {<< byte {unmasked_key_bytes}};
          `uvm_info(`gfn, $sformatf("dpi_key_arr.size(): %0d", dpi_key_arr.size()), UVM_HIGH)
          `uvm_info(`gfn, $sformatf("dpi_key_arr: %0p", dpi_key_arr), UVM_HIGH)

          case (strength)
            sha3_pkg::L128: begin
              if (xof_en) begin
                digestpp_dpi_pkg::c_dpi_kmac128_xof(msg_arr, msg_arr.size(),
                                                    dpi_key_arr, dpi_key_arr.size(),
                                                    custom_str,
                                                    output_len_bytes, dpi_digest);
              end else begin
                digestpp_dpi_pkg::c_dpi_kmac128(msg_arr, msg_arr.size(),
                                                dpi_key_arr, dpi_key_arr.size(),
                                                custom_str,
                                                output_len_bytes, dpi_digest);
              end
            end
            sha3_pkg::L256: begin
              if (xof_en) begin
                digestpp_dpi_pkg::c_dpi_kmac256_xof(msg_arr, msg_arr.size(),
                                                    dpi_key_arr, dpi_key_arr.size(),
                                                    custom_str,
                                                    output_len_bytes, dpi_digest);
              end else begin
                digestpp_dpi_pkg::c_dpi_kmac256(msg_arr, msg_arr.size(),
                                                dpi_key_arr, dpi_key_arr.size(),
                                                custom_str,
                                                output_len_bytes, dpi_digest);
              end
            end
            default: begin
              `uvm_fatal(`gfn, $sformatf("strength[%0s] is now allowed for kmac", strength.name()))
            end
          endcase
        end else begin
          // regular cshake
          // TODO - leave this section empty for now, we don't use plain cshake functionality
          case (strength)
            sha3_pkg::L128: begin
            end
            sha3_pkg::L256: begin
            end
            default: begin
              `uvm_fatal(`gfn, $sformatf("strength[%0s] is now allowed for cshake", strength.name()))
            end
          endcase
        end
      end
    endcase

    `uvm_info(`gfn, $sformatf("dpi_digest: %0p", dpi_digest), UVM_HIGH)

    /////////////////////////////////////////
    // Compare actual and expected digests //
    /////////////////////////////////////////
    for (int i = 0; i < output_len_bytes; i++) begin
      `DV_CHECK_EQ_FATAL(unmasked_digest[i], dpi_digest[i],
          $sformatf("Mismatch between unmasked_digest[%0d] and dpi_digest[%0d]", i, i))
    end

  endfunction

  // This function is used to calculate the requested digest length
  virtual function void get_digest_len_and_xof(ref int output_len, ref bit xof_en,
                                               ref bit [7:0] msg[$]);
    xof_en = 0;
    case (hash_mode)
      // For SHA3 hashes, the output length is the same as the security strength.
      sha3_pkg::Sha3: begin
        case (strength)
          sha3_pkg::L224: begin
            output_len = 224 / 8; // 28
          end
          sha3_pkg::L256: begin
            output_len = 256 / 8; // 32
          end
          sha3_pkg::L384: begin
            output_len = 384 / 8; // 48
          end
          sha3_pkg::L512: begin
            output_len = 512 / 8; // 64
          end
          default: begin
            `uvm_fatal(`gfn, $sformatf("strength[%0s] is not allowed for sha3", strength.name()))
          end
        endcase
      end
      // For Shake hashes, the output length isn't encoded anywhere,
      // so we just return the length of the state digest array.
      sha3_pkg::Shake: begin
        output_len = digest_share0.size();
      end
      // CShake is where things get more interesting.
      // We need to essentially decode the encoded output length that is
      // written to the msgfifo as a post-fix to the actual message.
      sha3_pkg::CShake: begin
        bit [MAX_ENCODE_WIDTH-1:0] full_len = '0;
        // the very last byte written to msgfifo is the number of bytes that
        // when put together represent the encoded output length.
        bit [7:0] num_encoded_byte = msg.pop_back();

        for (int i = 0; i < num_encoded_byte; i++) begin
          full_len[i*8 +: 8] = msg.pop_back();
        end

        // We should set xof_en if `right_encode(0)` was written to the msgfifo after the message.
        // right_encode(0) = '{'h0, 'h1}
        if (num_encoded_byte == 1 && full_len == 0) begin
          xof_en = 1;
          // can't set  the output length to 0, so we fall back to the Shake behavior here
          output_len = digest_share0.size();
        end else begin
          output_len = full_len / 8;
        end
      end
    endcase
  endfunction

  // This function is used to calculate the fname and custom_str string values
  // from the data written to the PREFIX csrs
  //
  // Strings are encoded as:
  //  `encode_string(S) = left_encode(len(S)) || S`
  virtual function void get_fname_and_custom_str(ref string fname, ref string custom_str);
    bit [7:0] prefix_bytes[$];
    // The very first byte of each encoded string represents the number of bytes
    // that make up the encoded string's length.
    bit [7:0] num_enc_bytes_of_str_len;

    bit [16:0] str_len;

    byte fname_arr[];
    byte custom_str_arr[];

    prefix_bytes = {<< 32 {prefix}};
    prefix_bytes = {<< byte {prefix_bytes}};

    `uvm_info(`gfn, $sformatf("prefix: %0p", prefix), UVM_HIGH)
    `uvm_info(`gfn, $sformatf("prefix_bytes: %0p", prefix_bytes), UVM_HIGH)

    // fname comes first in the PREFIX registers

    // This value should be 1
    num_enc_bytes_of_str_len = prefix_bytes.pop_front();
    `DV_CHECK_EQ(num_enc_bytes_of_str_len, 1,
        $sformatf("Only one byte should be used to encode len(fname)"))

    // The string length is always in terms of bits, need to convert to byte length
    str_len = prefix_bytes.pop_front() / 8;

    fname_arr  = new[str_len];
    for (int i = 0; i < str_len; i++) begin
      fname_arr[i] = byte'(prefix_bytes.pop_front());
    end

    // custom_str is next

    num_enc_bytes_of_str_len = prefix_bytes.pop_front();

    // convert string length to length in bytes
    for (int i = 0; i < num_enc_bytes_of_str_len; i++) begin
      str_len[(num_enc_bytes_of_str_len  - i - 1)*8 +: 8] = prefix_bytes.pop_front();
    end
    str_len /= 8;

    custom_str_arr = new[str_len];
    for (int i = 0; i < str_len; i++) begin
      custom_str_arr[i] = byte'(prefix_bytes.pop_front());
    end

    // Convert the byte arrays into strings
    fname = str_utils_pkg::bytes_to_str(fname_arr);
    custom_str = str_utils_pkg::bytes_to_str(custom_str_arr);

    `uvm_info(`gfn, $sformatf("decoded fname: %0s", fname), UVM_HIGH)
    `uvm_info(`gfn, $sformatf("decoded custom_str: %0s", custom_str), UVM_HIGH)
  endfunction

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    // post test checks - ensure that all local fifos and queues are empty
  endfunction

endclass
