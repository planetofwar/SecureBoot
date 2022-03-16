// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Drive random traffic out the SBA TL interface. Scoreboard checks the packet integrity.
class rv_dm_sba_tl_access_vseq extends rv_dm_base_vseq;
  `uvm_object_utils(rv_dm_sba_tl_access_vseq)
  `uvm_object_new

  rand int min_rsp_delay;
  rand int max_rsp_delay;
  rand int d_error_pct;
  rand int d_chan_intg_err_pct;

  rand int num_times;
  rand sba_access_item req;

  // To generate reads to the same addr followed by previous writes.
  rand bit read_addr_after_write;
  bus_op_e bus_op_prev;
  bit [BUS_AW-1:0] addr_prev;

  constraint min_rsp_delay_c {
    cfg.zero_delays -> min_rsp_delay == 0;
    min_rsp_delay inside {[0:10]};
  }

  constraint max_rsp_delay_c {
    solve min_rsp_delay before max_rsp_delay;
    cfg.zero_delays -> max_rsp_delay == 0;
    max_rsp_delay >= min_rsp_delay;
    max_rsp_delay inside {[min_rsp_delay:min_rsp_delay+100]};
  }

  constraint d_error_pct_c {
    d_error_pct inside {[0:100]};
    d_error_pct dist { 0 :/ 6, [1:20] :/ 2, [21:99] :/ 1, 100 :/ 1};
  }

  constraint d_chan_intg_err_pct_c {
    d_chan_intg_err_pct inside {[0:100]};
    d_chan_intg_err_pct dist { 0 :/ 7, [1:20] :/ 2, [21:100] :/ 1};
  }

  // TODO: Randomize these controls every num_times iteration.
  constraint lc_hw_debug_en_c {
    lc_hw_debug_en == lc_ctrl_pkg::On;
  }
  constraint scanmode_c {
    scanmode == prim_mubi_pkg::MuBi4False;
  }
  constraint unavailable_c {
    unavailable == 0;
  }

  constraint num_trans_c {
    num_trans inside {[20:50]};
  }

  constraint num_times_c {
    num_times inside {[1:5]};
  }

  constraint read_addr_after_write_c {
    read_addr_after_write dist {0 :/ 7, 1 :/ 3};
  }

  task body();
    num_times.rand_mode(0);

    // TODO: Fix and invoke sba_tl_device_seq_disable_tlul_assert_host_sba_resp_svas() instead.
    cfg.rv_dm_vif.disable_tlul_assert_host_sba_resp_svas = 1'b1;

    sba_tl_device_seq_stop();
    for (int i = 1; i <= num_times; i++) begin
      `uvm_info(`gfn, $sformatf("Starting iteration %0d/%0d", i, num_times), UVM_MEDIUM)
      `DV_CHECK_MEMBER_RANDOMIZE_FATAL(num_trans)
      `DV_CHECK_MEMBER_RANDOMIZE_FATAL(min_rsp_delay)
      `DV_CHECK_MEMBER_RANDOMIZE_FATAL(max_rsp_delay)
      `DV_CHECK_MEMBER_RANDOMIZE_FATAL(d_error_pct)
      `DV_CHECK_MEMBER_RANDOMIZE_FATAL(d_chan_intg_err_pct)
      sba_tl_device_seq_start(.min_rsp_delay(min_rsp_delay),
                              .max_rsp_delay(max_rsp_delay),
                              .d_error_pct(d_error_pct),
                              .d_chan_intg_err_pct(d_chan_intg_err_pct));
      num_trans.rand_mode(0);
      for (int j = 1; j <= num_trans; j++) begin
        req = sba_access_item::type_id::create("req");
        randomize_req(req);
        `uvm_info(`gfn, $sformatf("Starting transaction %0d/%0d: %0s",
                                  j, num_trans, req.sprint(uvm_default_line_printer)), UVM_MEDIUM)
        sba_access(.jtag_dmi_ral(jtag_dmi_ral), .cfg(cfg.m_jtag_agent_cfg), .req(req));
        `DV_CHECK(!req.is_err)
        `DV_CHECK(!req.is_busy_err)
        `DV_CHECK(!req.timed_out)
      end
      sba_tl_device_seq_stop();
    end
  endtask : body

  // Randomizes legal, valid requests.
  virtual function void randomize_req(sba_access_item req);
    req.disable_rsp_randomization();
    `DV_CHECK_RANDOMIZE_WITH_FATAL(req,
        // TODO: remove this later.
        autoincrement == 0;
        // TODO: remove this constraint.
        size == 2;
    )
    override_req_to_read_addr_after_write(req);
  endfunction

  // Overrides the req after randomization, to read the previously written address.
  virtual function void override_req_to_read_addr_after_write(sba_access_item req);
    if (read_addr_after_write && bus_op_prev == BusOpWrite) begin
      req.bus_op = BusOpRead;
      req.addr = addr_prev;
    end
    bus_op_prev = req.bus_op;
    addr_prev = req.addr;
  endfunction

endclass
