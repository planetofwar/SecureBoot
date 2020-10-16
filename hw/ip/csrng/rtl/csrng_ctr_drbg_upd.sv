// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: csrng ctr_drbg_update module
//
// implementation using security_strength = 256

module csrng_ctr_drbg_upd #(
  parameter int unsigned Cmd = 3,
  parameter int unsigned StateId = 4,
  parameter int unsigned BlkLen = 128,
  parameter int unsigned KeyLen = 256,
  parameter int unsigned SeedLen = 384,
  parameter int unsigned CtrLen  = 32
) (
  input logic                clk_i,
  input logic                rst_ni,

   // update interface
  input logic                ctr_drbg_upd_enable_i,
  input logic                ctr_drbg_upd_req_i,
  output logic               ctr_drbg_upd_rdy_o, // ready to process the req above
  input logic [Cmd-1:0]      ctr_drbg_upd_ccmd_i,
  input logic [StateId-1:0]  ctr_drbg_upd_inst_id_i, // instantance id
  input logic [SeedLen-1:0]  ctr_drbg_upd_pdata_i, // provided_data
  input logic [KeyLen-1:0]   ctr_drbg_upd_key_i,
  input logic [BlkLen-1:0]   ctr_drbg_upd_v_i,
  output logic [Cmd-1:0]     ctr_drbg_upd_ccmd_o,
  output logic [StateId-1:0] ctr_drbg_upd_inst_id_o,
  output logic [KeyLen-1:0]  ctr_drbg_upd_key_o,
  output logic [BlkLen-1:0]  ctr_drbg_upd_v_o,
  output logic               ctr_drbg_upd_ack_o, // final ack when update process has been completed
  input logic                ctr_drbg_upd_rdy_i, // readu to process the ack above
   // block encrypt interface
  output logic               block_encrypt_req_o,
  input logic                block_encrypt_rdy_i,
  output logic [Cmd-1:0]     block_encrypt_ccmd_o,
  output logic [StateId-1:0] block_encrypt_inst_id_o,
  output logic [KeyLen-1:0]  block_encrypt_key_o,
  output logic [BlkLen-1:0]  block_encrypt_v_o,
  input logic                block_encrypt_ack_i,
  output logic               block_encrypt_rdy_o,
  input logic [Cmd-1:0]      block_encrypt_ccmd_i,
  input logic [StateId-1:0]  block_encrypt_inst_id_i,
  input logic [BlkLen-1:0]   block_encrypt_v_i,
  output logic [2:0]         ctr_drbg_upd_sfifo_updreq_err_o,
  output logic [2:0]         ctr_drbg_upd_sfifo_bencreq_err_o,
  output logic [2:0]         ctr_drbg_upd_sfifo_bencack_err_o,
  output logic [2:0]         ctr_drbg_upd_sfifo_pdata_err_o,
  output logic [2:0]         ctr_drbg_upd_sfifo_final_err_o
);

  localparam UpdReqFifoDepth = 1;
  localparam UpdReqFifoWidth = KeyLen+BlkLen+SeedLen+StateId+Cmd;
  localparam BlkEncReqFifoDepth = 1;
  localparam BlkEncReqFifoWidth = KeyLen+BlkLen+StateId+Cmd;
  localparam BlkEncAckFifoDepth = 1;
  localparam BlkEncAckFifoWidth = BlkLen+StateId+Cmd;
  localparam PDataFifoDepth = 1;
  localparam PDataFifoWidth = SeedLen;
  localparam FinalFifoDepth = 1;
  localparam FinalFifoWidth = KeyLen+BlkLen+StateId+Cmd;

  // signals
  logic [SeedLen-1:0] updated_key_and_v;
  logic [CtrLen-1:0]  v_inc;
  logic [BlkLen-1:0]  v_first;
  logic [BlkLen-1:0]  v_sized;

  // upd_req fifo
  logic [UpdReqFifoWidth-1:0] sfifo_updreq_rdata;
  logic                       sfifo_updreq_push;
  logic [UpdReqFifoWidth-1:0] sfifo_updreq_wdata;
  logic                       sfifo_updreq_pop;
  logic                       sfifo_updreq_not_full;
  logic                       sfifo_updreq_not_empty;
  // breakout
  logic [Cmd-1:0]             sfifo_updreq_ccmd;
  logic [StateId-1:0]         sfifo_updreq_inst_id;
  logic [SeedLen-1:0]         sfifo_updreq_pdata;
  logic [KeyLen-1:0]          sfifo_updreq_key;
  logic [BlkLen-1:0]          sfifo_updreq_v;

  // blk_encrypt_req fifo
  logic [BlkEncReqFifoWidth-1:0] sfifo_bencreq_rdata;
  logic                       sfifo_bencreq_push;
  logic [BlkEncReqFifoWidth-1:0] sfifo_bencreq_wdata;
  logic                       sfifo_bencreq_pop;
  logic                       sfifo_bencreq_not_full;
  logic                       sfifo_bencreq_not_empty;
  // breakout
  logic [Cmd-1:0]             sfifo_bencreq_ccmd;
  logic [StateId-1:0]         sfifo_bencreq_inst_id;
  logic [KeyLen-1:0]          sfifo_bencreq_key;
  logic [BlkLen-1:0]          sfifo_bencreq_v;

  // blk_encrypt_ack fifo
  logic [BlkEncAckFifoWidth-1:0] sfifo_bencack_rdata;
  logic                       sfifo_bencack_push;
  logic [BlkEncAckFifoWidth-1:0] sfifo_bencack_wdata;
  logic                       sfifo_bencack_pop;
  logic                       sfifo_bencack_not_full;
  logic                       sfifo_bencack_not_empty;
  // breakout
  logic [Cmd-1:0]             sfifo_bencack_ccmd;
  logic [StateId-1:0]         sfifo_bencack_inst_id;
  logic [BlkLen-1:0]          sfifo_bencack_v;

  // pdata_stage fifo
  logic [PDataFifoWidth-1:0]  sfifo_pdata_rdata;
  logic                       sfifo_pdata_push;
  logic [PDataFifoWidth-1:0]  sfifo_pdata_wdata;
  logic                       sfifo_pdata_pop;
  logic                       sfifo_pdata_not_full;
  logic                       sfifo_pdata_not_empty;
  logic [SeedLen-1:0]         sfifo_pdata_v;

  // key_v fifo
  logic [FinalFifoWidth-1:0]  sfifo_final_rdata;
  logic                       sfifo_final_push;
  logic [FinalFifoWidth-1:0]  sfifo_final_wdata;
  logic                       sfifo_final_pop;
  logic                       sfifo_final_not_full;
  logic                       sfifo_final_not_empty;
  // breakout
  logic [Cmd-1:0]             sfifo_final_ccmd;
  logic [StateId-1:0]         sfifo_final_inst_id;
  logic [KeyLen-1:0]          sfifo_final_key;
  logic [BlkLen-1:0]          sfifo_final_v;

  logic               v_ctr_load;
  logic               v_ctr_inc;
  logic               interate_ctr_done;
  logic               interate_ctr_inc;
  logic               concat_outblk_shift;
  logic               concat_ctr_done;
  logic               concat_ctr_inc;
  logic [SeedLen+BlkLen-1:0] concat_outblk_shifted_value; // ri lint_check_waive NOT_READ

  // flops
  logic [CtrLen-1:0]  v_ctr_q, v_ctr_d;
  logic [1:0]         interate_ctr_q, interate_ctr_d;
  logic [1:0]         concat_ctr_q, concat_ctr_d;
//  logic [1:0]         ctr_drbg_upd_sts_q, ctr_drbg_upd_sts_d;
  logic [SeedLen-1:0] concat_outblk_q, concat_outblk_d;
  logic [Cmd-1:0]     concat_ccmd_q, concat_ccmd_d;
  logic [StateId-1:0] concat_inst_id_q, concat_inst_id_d;

  // Encoding generated with ./sparse-fsm-encode.py -d 3 -m 2 -n 4 -s 2483430365
  // Hamming distance histogram:
  //
  // 0: --
  // 1: --
  // 2: --
  // 3: |||||||||||||||||||| (100.00%)
  // 4: --
  //
  // Minimum Hamming distance: 3
  // Maximum Hamming distance: 3
  //

  localparam int BlkEncStateWidth = 4;
  typedef enum logic [BlkEncStateWidth-1:0] {
    ReqIdle = 4'b0001,
    ReqSend = 4'b0110
  } blk_enc_state_e;

  blk_enc_state_e blk_enc_state_d;

  logic [BlkEncStateWidth-1:0] blk_enc_state_q;

  // This primitive is used to place a size-only constraint on the
  // flops in order to prevent FSM state encoding optimizations.
  prim_flop #(
    .Width(BlkEncStateWidth),
    .ResetValue(BlkEncStateWidth'(ReqIdle))
  ) u_blk_enc_state_regs (
    .clk_i,
    .rst_ni,
    .d_i ( blk_enc_state_d ),
    .q_o ( blk_enc_state_q )
  );

  // Encoding generated with ./sparse-fsm-encode.py -d 3 -m 3 -n 6 -s 4062121537
  // Hamming distance histogram:
  //
  // 0: --
  // 1: --
  // 2: --
  // 3: |||||||||||||||||||| (66.67%)
  // 4: |||||||||| (33.33%)
  // 5: --
  // 6: --
  //
  // Minimum Hamming distance: 3
  // Maximum Hamming distance: 4
  //

  localparam int OutBlkStateWidth = 6;
  typedef enum logic [OutBlkStateWidth-1:0] {
    AckIdle = 6'b111001,
    Load    = 6'b011100,
    Shift   = 6'b110010
  } outblk_state_e;

  outblk_state_e outblk_state_d;

  logic [OutBlkStateWidth-1:0] outblk_state_q;

  // This primitive is used to place a size-only constraint on the
  // flops in order to prevent FSM state encoding optimizations.
  prim_flop #(
    .Width(OutBlkStateWidth),
    .ResetValue(OutBlkStateWidth'(AckIdle))
  ) u_outblk_state_regs (
    .clk_i,
    .rst_ni,
    .d_i ( outblk_state_d ),
    .q_o ( outblk_state_q )
  );

  always_ff @(posedge clk_i or negedge rst_ni)
    if (!rst_ni) begin
      v_ctr_q            <= '0;
      interate_ctr_q     <= '0;
      concat_ctr_q       <= '0;
      concat_outblk_q    <= '0;
      concat_ccmd_q      <= '0;
      concat_inst_id_q   <= '0;
    end else begin
      v_ctr_q            <= v_ctr_d;
      interate_ctr_q     <= interate_ctr_d;
      concat_ctr_q       <= concat_ctr_d;
      concat_outblk_q    <= concat_outblk_d;
      concat_ccmd_q      <= concat_ccmd_d;
      concat_inst_id_q   <= concat_inst_id_d;
    end // else: !if(!rst_ni)


  //--------------------------------------------
  // input request fifo for staging update requests
  //--------------------------------------------

  prim_fifo_sync #(
    .Width(UpdReqFifoWidth),
    .Pass(0),
    .Depth(UpdReqFifoDepth)
  ) u_prim_fifo_sync_updreq (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .clr_i    (!ctr_drbg_upd_enable_i),
    .wvalid_i (sfifo_updreq_push),
    .wready_o (sfifo_updreq_not_full),
    .wdata_i  (sfifo_updreq_wdata),
    .rvalid_o (sfifo_updreq_not_empty),
    .rready_i (sfifo_updreq_pop),
    .rdata_o  (sfifo_updreq_rdata),
    .depth_o  ()
  );

  assign sfifo_updreq_push = sfifo_updreq_not_full && ctr_drbg_upd_req_i;
  assign sfifo_updreq_wdata = {ctr_drbg_upd_key_i,ctr_drbg_upd_v_i,ctr_drbg_upd_pdata_i,
                               ctr_drbg_upd_inst_id_i,ctr_drbg_upd_ccmd_i};
  assign ctr_drbg_upd_rdy_o = sfifo_updreq_not_full;

  assign {sfifo_updreq_key,sfifo_updreq_v,sfifo_updreq_pdata,
          sfifo_updreq_inst_id,sfifo_updreq_ccmd} = sfifo_updreq_rdata;

  assign ctr_drbg_upd_sfifo_updreq_err_o =
         {(sfifo_updreq_push && !sfifo_updreq_not_full),
         (sfifo_updreq_pop && !sfifo_updreq_not_empty),
         (!sfifo_updreq_not_full && !sfifo_updreq_not_empty)};

  //--------------------------------------------
  // prepare value for block_encrypt step
  //--------------------------------------------

  if (CtrLen < BlkLen) begin : g_ctrlen_sm
    // for ctr_len < blocklen
    assign v_inc = sfifo_updreq_v[CtrLen-1:0] + 1;
    assign v_first = {sfifo_updreq_v[BlkLen-1:CtrLen],v_inc};
  end else begin : g_ctrlen_lg
    assign v_first = sfifo_updreq_v + 1;
  end

  assign v_ctr_d = v_ctr_load ? v_first[CtrLen-1:0] :
                   v_ctr_inc  ? (v_ctr_q + 1) :
                   v_ctr_q;

  assign     v_sized = {v_first[BlkLen-1:CtrLen],v_ctr_q};

  // interation counter
  assign     interate_ctr_d =
             interate_ctr_done ? '0 :
             interate_ctr_inc ? (interate_ctr_q + 1) :
             interate_ctr_q;

  assign interate_ctr_done = (interate_ctr_q >= (SeedLen/BlkLen));

  //--------------------------------------------
  // state machine to send values to block_encrypt
  //--------------------------------------------

  always_comb begin
    blk_enc_state_d = blk_enc_state_e'(blk_enc_state_q);
    v_ctr_load = 1'b0;
    v_ctr_inc  = 1'b0;
    interate_ctr_inc  = 1'b0;
    sfifo_pdata_push = 1'b0;
    sfifo_bencreq_push = 1'b0;
    sfifo_updreq_pop = 1'b0;
    unique case (blk_enc_state_q)
      // ReqIdle: increment v this cycle, push in next
      ReqIdle:
        if (sfifo_updreq_not_empty && sfifo_bencreq_not_full && sfifo_pdata_not_full) begin
          v_ctr_load = 1'b1;
          sfifo_pdata_push = 1'b1;
          blk_enc_state_d = ReqSend;
        end
      ReqSend:
        if (!interate_ctr_done) begin
          if (sfifo_bencreq_not_full) begin
            v_ctr_inc  = 1'b1;
            interate_ctr_inc  = 1'b1;
            sfifo_bencreq_push = 1'b1;
          end
        end else begin
          sfifo_updreq_pop = 1'b1;
          blk_enc_state_d = ReqIdle;
        end
      default: blk_enc_state_d = ReqIdle;
    endcase // case (blk_enc_state_q)
  end

  //--------------------------------------------
  // block_encrypt request fifo for staging aes requests
  //--------------------------------------------

  prim_fifo_sync #(
    .Width(BlkEncReqFifoWidth),
    .Pass(0),
    .Depth(BlkEncReqFifoDepth)
  ) u_prim_fifo_sync_bencreq (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .clr_i    (!ctr_drbg_upd_enable_i),
    .wvalid_i (sfifo_bencreq_push),
    .wready_o (sfifo_bencreq_not_full),
    .wdata_i  (sfifo_bencreq_wdata),
    .rvalid_o (sfifo_bencreq_not_empty),
    .rready_i (sfifo_bencreq_pop),
    .rdata_o  (sfifo_bencreq_rdata),
    .depth_o  ()
  );

  assign sfifo_bencreq_pop = block_encrypt_req_o && block_encrypt_rdy_i;
  assign block_encrypt_req_o = sfifo_bencreq_not_empty;

  assign sfifo_bencreq_wdata = {sfifo_updreq_key,v_sized,sfifo_updreq_inst_id,sfifo_updreq_ccmd};

  assign {sfifo_bencreq_key,sfifo_bencreq_v,sfifo_bencreq_inst_id,
          sfifo_bencreq_ccmd} = sfifo_bencreq_rdata;

  // set outputs
  assign block_encrypt_key_o = sfifo_bencreq_key;
  assign block_encrypt_v_o = sfifo_bencreq_v;
  assign block_encrypt_inst_id_o = sfifo_bencreq_inst_id;
  assign block_encrypt_ccmd_o = sfifo_bencreq_ccmd;

  assign ctr_drbg_upd_sfifo_bencreq_err_o =
         {(sfifo_bencreq_push && !sfifo_bencreq_not_full),
          (sfifo_bencreq_pop && !sfifo_bencreq_not_empty),
          (!sfifo_bencreq_not_full && !sfifo_bencreq_not_empty)};

  //--------------------------------------------
  // block_encrypt response fifo from block encrypt
  //--------------------------------------------

  prim_fifo_sync #(
    .Width(BlkEncAckFifoWidth),
    .Pass(0),
    .Depth(BlkEncAckFifoDepth)
  ) u_prim_fifo_sync_bencack (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .clr_i    (!ctr_drbg_upd_enable_i),
    .wvalid_i (sfifo_bencack_push),
    .wready_o (sfifo_bencack_not_full),
    .wdata_i  (sfifo_bencack_wdata),
    .rvalid_o (sfifo_bencack_not_empty),
    .rready_i (sfifo_bencack_pop),
    .rdata_o  (sfifo_bencack_rdata),
    .depth_o  ()
  );

  assign sfifo_bencack_push = sfifo_bencack_not_full && block_encrypt_ack_i;
  assign sfifo_bencack_wdata = {block_encrypt_v_i,block_encrypt_inst_id_i,block_encrypt_ccmd_i};
  assign block_encrypt_rdy_o = sfifo_bencack_not_full;

  assign {sfifo_bencack_v,sfifo_bencack_inst_id,sfifo_bencack_ccmd} = sfifo_bencack_rdata;

  assign ctr_drbg_upd_sfifo_bencack_err_o =
         {(sfifo_bencack_push && !sfifo_bencack_not_full),
          (sfifo_bencack_pop && !sfifo_bencack_not_empty),
          (!sfifo_bencack_not_full && !sfifo_bencack_not_empty)};

  //--------------------------------------------
  // fifo to stage provided_data, waiting for blk_encrypt to ack
  //--------------------------------------------

  prim_fifo_sync #(
    .Width(PDataFifoWidth),
    .Pass(0),
    .Depth(PDataFifoDepth)
  ) u_prim_fifo_sync_pdata (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .clr_i    (!ctr_drbg_upd_enable_i),
    .wvalid_i (sfifo_pdata_push),
    .wready_o (sfifo_pdata_not_full),
    .wdata_i  (sfifo_pdata_wdata),
    .rvalid_o (sfifo_pdata_not_empty),
    .rready_i (sfifo_pdata_pop),
    .rdata_o  (sfifo_pdata_rdata),
    .depth_o  ()
  );

  assign sfifo_pdata_wdata = sfifo_updreq_pdata;

  assign sfifo_pdata_v = sfifo_pdata_rdata;

  assign ctr_drbg_upd_sfifo_pdata_err_o =
         {(sfifo_pdata_push && !sfifo_pdata_not_full),
          (sfifo_pdata_pop && !sfifo_pdata_not_empty),
          (!sfifo_pdata_not_full && !sfifo_pdata_not_empty)};

  //--------------------------------------------
  // shifting logic to receive values from block_encrypt
  //--------------------------------------------

  assign concat_outblk_shifted_value = (concat_outblk_q << BlkLen);

  assign concat_outblk_d =
         sfifo_bencack_pop ? {concat_outblk_q[SeedLen-1:BlkLen],sfifo_bencack_v} :
         concat_outblk_shift ? concat_outblk_shifted_value[SeedLen-1:0] :
         concat_outblk_q;

  // concatination counter
  assign concat_ctr_d =
         concat_ctr_done ? '0 :
         concat_ctr_inc ? (concat_ctr_q + 1) :
         concat_ctr_q;

  assign concat_ctr_done = (concat_ctr_q >= (SeedLen/BlkLen));

  assign concat_inst_id_d = sfifo_bencack_pop ? sfifo_bencack_inst_id : concat_inst_id_q;
  assign concat_ccmd_d = sfifo_bencack_pop ? sfifo_bencack_ccmd : concat_ccmd_q;

  //--------------------------------------------
  // state machine to receive values from block_encrypt
  //--------------------------------------------

  always_comb begin
    outblk_state_d = outblk_state_e'(outblk_state_q);
    concat_ctr_inc  = 1'b0;
    concat_outblk_shift = 1'b0;
    sfifo_pdata_pop = 1'b0;
    sfifo_bencack_pop = 1'b0;
    sfifo_final_push = 1'b0;
    unique case (outblk_state_q)
      // AckIdle: increment v this cycle, push in next
      AckIdle:
        if (sfifo_bencack_not_empty && sfifo_pdata_not_empty && sfifo_final_not_full) begin
          outblk_state_d = Load;
        end
      Load:
        if (sfifo_bencack_not_empty) begin
          concat_ctr_inc  = 1'b1;
          sfifo_bencack_pop = 1'b1;
          outblk_state_d = Shift;
        end
      Shift:
        if (concat_ctr_done) begin
          sfifo_pdata_pop = 1'b1;
          sfifo_final_push = 1'b1;
          outblk_state_d = AckIdle;
        end else begin
          concat_outblk_shift = 1'b1;
          outblk_state_d = Load;
        end
      default: outblk_state_d = AckIdle;
    endcase
  end


  //--------------------------------------------
  // final update processing
  //--------------------------------------------

  // XOR the additional data with the new key and value from block encryption
  assign updated_key_and_v = concat_outblk_q ^ sfifo_pdata_v;

  prim_fifo_sync #(
    .Width(FinalFifoWidth),
    .Pass(0),
    .Depth(FinalFifoDepth)
  ) u_prim_fifo_sync_final (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .clr_i    (!ctr_drbg_upd_enable_i),
    .wvalid_i (sfifo_final_push),
    .wready_o (sfifo_final_not_full),
    .wdata_i  (sfifo_final_wdata),
    .rvalid_o (sfifo_final_not_empty),
    .rready_i (sfifo_final_pop),
    .rdata_o  (sfifo_final_rdata),
    .depth_o  ()
  );

  assign sfifo_final_wdata = {updated_key_and_v,concat_inst_id_q,concat_ccmd_q};

  assign {sfifo_final_key,sfifo_final_v,sfifo_final_inst_id,sfifo_final_ccmd} = sfifo_final_rdata;

  assign sfifo_final_pop = ctr_drbg_upd_rdy_i && sfifo_final_not_empty;
  assign ctr_drbg_upd_ack_o = sfifo_final_pop;
  assign ctr_drbg_upd_ccmd_o = sfifo_final_ccmd;
  assign ctr_drbg_upd_inst_id_o = sfifo_final_inst_id;
  assign ctr_drbg_upd_key_o = sfifo_final_key;
  assign ctr_drbg_upd_v_o = sfifo_final_v;

  assign ctr_drbg_upd_sfifo_final_err_o =
         {(sfifo_final_push && !sfifo_final_not_full),
          (sfifo_final_pop && !sfifo_final_not_empty),
          (!sfifo_final_not_full && !sfifo_final_not_empty)};


endmodule
