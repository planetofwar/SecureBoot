// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`define PUSH_DRIVER_CB cfg.vif.host_push_cb
`define PULL_DRIVER_CB cfg.vif.host_pull_cb

class push_pull_host_driver #(parameter int HostDataWidth = 32,
                              parameter int DeviceDataWidth = HostDataWidth)
  extends push_pull_driver #(HostDataWidth, DeviceDataWidth);

  `uvm_component_param_utils(push_pull_host_driver#(HostDataWidth, DeviceDataWidth))

  // the base class provides the following handles for use:
  // push_pull_agent_cfg: cfg

  `uvm_component_new

  virtual task do_reset();
    if (cfg.agent_type == PushAgent) begin
      cfg.vif.valid_int <= '0;
    end else begin
      cfg.vif.req_int   <= '0;
    end
    cfg.vif.h_data_int <= 'x;
  endtask

  // drive trans received from sequencer
  virtual task get_and_drive();
    // wait for the initial reset to pass
    @(posedge cfg.vif.rst_n);
    // TODO: Is this really needed?
    cfg.vif.wait_clks(1);
    forever begin
      seq_item_port.try_next_item(req);
      if (req != null) begin
        `uvm_info(`gfn, $sformatf("Driver rcvd item:\n%0s", req.convert2string()), UVM_HIGH)
        if (!in_reset) begin
          if (cfg.agent_type == PushAgent) begin
            drive_push();
          end else if (cfg.agent_type == PullAgent) begin
            drive_pull();
          end else begin
            `uvm_fatal(`gfn, $sformatf("%0s is an invalid driver protocol!", cfg.agent_type))
          end
        end
        seq_item_port.item_done(req);
      end else begin
        cfg.vif.wait_clks(1);
      end
    end
  endtask

  // Drives host side of ready/valid protocol
  virtual task drive_push();
    `DV_SPINWAIT_EXIT(
        repeat (req.host_delay) @(`PUSH_DRIVER_CB);
        `PUSH_DRIVER_CB.valid_int  <= 1'b1;
        `PUSH_DRIVER_CB.h_data_int <= req.h_data;
        do begin
          @(`PUSH_DRIVER_CB);
        end while (!`PUSH_DRIVER_CB.ready);
        `PUSH_DRIVER_CB.valid_int <= 1'b0;
        if (!cfg.hold_h_data_until_next_req) `PUSH_DRIVER_CB.h_data_int <= 'x;,
        wait(in_reset);)
  endtask

  // Drives host side of req/ack protocol
  virtual task drive_pull();
    `DV_SPINWAIT_EXIT(
        repeat (req.host_delay) @(`PULL_DRIVER_CB);
        `PULL_DRIVER_CB.req_int    <= 1'b1;
        `PULL_DRIVER_CB.h_data_int <= req.h_data;
        do begin
          @(`PULL_DRIVER_CB);
        end while (!`PULL_DRIVER_CB.ack);
        `PULL_DRIVER_CB.req_int <= 1'b0;
        if (!cfg.hold_h_data_until_next_req) `PULL_DRIVER_CB.h_data_int <= 'x;,
        wait(in_reset);)
  endtask

endclass

`undef PULL_DRIVER_CB
`undef PUSH_DRIVER_CB
