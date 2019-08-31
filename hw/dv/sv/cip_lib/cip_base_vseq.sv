// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class cip_base_vseq #(type RAL_T               = dv_base_reg_block,
                      type CFG_T               = cip_base_env_cfg,
                      type COV_T               = cip_base_env_cov,
                      type VIRTUAL_SEQUENCER_T = cip_base_virtual_sequencer)
                      extends dv_base_vseq #(RAL_T, CFG_T, COV_T, VIRTUAL_SEQUENCER_T);
  `uvm_object_param_utils(cip_base_vseq #(RAL_T, CFG_T, COV_T, VIRTUAL_SEQUENCER_T))

  `uvm_object_new

  task pre_start();
    super.pre_start();
  endtask

  task body();
    `uvm_fatal(`gtn, "Need to override this when you extend from this class!")
  endtask : body

  task post_start();
    super.post_start();
  endtask

  // tl_access task: does a single TL_W-bit write or read transaction to the specified address
  // note that this task does not update ral model; optionally also checks for error response
  // TODO: add additional args? non-blocking? respose data check? timeout? spinwait?
  virtual task tl_access(input bit [TL_AW-1:0]  addr,
                         input bit              write,
                         inout bit [TL_DW-1:0]  data,
                         input bit [TL_DBW-1:0] mask = '1,
                         input bit [TL_SZW-1:0] size = 2,
                         input bit              check_rsp = 1'b1,
                         input bit              exp_err_rsp = 1'b0);
    tl_host_single_seq  tl_seq;
    `uvm_create_on(tl_seq, p_sequencer.tl_sequencer_h)
    if (cfg.zero_delays) begin
      tl_seq.min_req_delay = 0;
      tl_seq.max_req_delay = 0;
    end
    `DV_CHECK_RANDOMIZE_WITH_FATAL(tl_seq,
        addr      == local::addr;
        size      == local::size;
        mask      == local::mask;
        if (write) {
          opcode  == ((size == 2) ? tlul_pkg::PutFullData : tlul_pkg::PutPartialData);
          data    == local::data;
        } else {
          opcode  == tlul_pkg::Get;
        })
    `uvm_send(tl_seq)
    if (!write) data = tl_seq.rsp.d_data;
    if (check_rsp) begin
      `DV_CHECK_EQ(tl_seq.rsp.d_error, exp_err_rsp, "unexpected error response")
    end
  endtask

  // CIP spec indicates all comportable IPs will have the same standardized interrupt csrs. We can
  // leverage that to create a common set of tasks that all IP environments can reuse. The following
  // are descriptions of some of the args:

  // interrupts: bit vector indicating which interrupts to process
  // suffix: if there are more than TL_DW interrupts, then add suffix 'hi' or 'lo' to the interrupt
  // TODO add support for suffix
  // csr to configure the right one (ex: intr_enable_hi, intr_enable_lo, etc)
  // indices[$]: registers could be indexed (example, rv_timer) in which case, push as many desired
  // index values as required by the design to the queue
  // scope: for top level, specify which ip / sub module's interrupt to clear

  // common task
  local function uvm_reg get_interrupt_csr(string csr_name,
                                           string suffix = "",
                                           int indices[$] = {},
                                           uvm_reg_block scope = null);
    if (indices.size() != 0) begin
      foreach (indices[i]) begin
        suffix = {suffix, (i == 0) ? "" : "_", $sformatf("%0d", i)};
      end
      csr_name = {csr_name, suffix};
    end
    // check within scope first, if supplied
    if (scope != null)  begin
      get_interrupt_csr = scope.get_reg_by_name(csr_name);
    end else begin
      get_interrupt_csr = ral.get_reg_by_name(csr_name);
    end
    `DV_CHECK_NE_FATAL(get_interrupt_csr, null)
  endfunction

  // task to enable multiple interrupts
  // enable: if set, then selected unterrupts are enabled, else disabled
  // see description above for other args
  virtual task cfg_interrupts(bit [TL_DW-1:0] interrupts,
                              bit enable = 1'b1,
                              string suffix = "",
                              int indices[$] = {},
                              uvm_reg_block scope = null);

    uvm_reg         csr;
    bit [TL_DW-1:0] data;

    csr = get_interrupt_csr("intr_enable", "", indices, scope);
    data = csr.get_mirrored_value();
    if (enable) data |= interrupts;
    else        data &= ~interrupts;
    csr.set(data);
    csr_update(.csr(csr));
  endtask

  // generic task to check if given interrupt bits & status are set
  // check_set: check if interrupts are set (1) or unset (0)
  // clear: bit vector indicating which interrupt bit to clear
  // see description above for other args
  virtual task check_interrupts(bit [TL_DW-1:0] interrupts,
                                bit check_set,
                                string suffix = "",
                                int indices[$] = {},
                                uvm_reg_block scope = null,
                                bit [TL_DW-1:0] clear = '1);
    uvm_reg         csr;
    bit [TL_DW-1:0] act_pins;
    bit [TL_DW-1:0] exp_pins;
    bit [TL_DW-1:0] exp_intr_state;

    act_pins = cfg.intr_vif.sample() & interrupts;
    if (check_set) begin
      exp_pins = interrupts;
      exp_intr_state = interrupts;
    end else begin
      exp_pins = '0;
      exp_intr_state = ~interrupts;
    end
    `DV_CHECK_EQ(act_pins, exp_pins)
    csr = get_interrupt_csr("intr_state", "", indices, scope);
    csr_rd_check(.ptr(csr), .compare_value(exp_intr_state), .compare_mask(interrupts));
    if (check_set && |(interrupts & clear)) begin
      csr_wr(.csr(csr), .value(interrupts & clear));
    end
  endtask

  // TODO add test sequence for intr_test

endclass
