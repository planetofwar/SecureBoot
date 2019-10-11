// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// ---------------------------------------------
// Xbar environment class
// ---------------------------------------------
class xbar_env extends dv_base_env#(.CFG_T              (xbar_env_cfg),
                                    .VIRTUAL_SEQUENCER_T(xbar_virtual_sequencer),
                                    .SCOREBOARD_T       (xbar_scoreboard),
                                    .COV_T              (xbar_env_cov));

  tl_agent          host_agent[];
  tl_agent          device_agent[];

  `uvm_component_utils(xbar_env)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Connect TileLink host and device agents
    host_agent = new[cfg.num_of_hosts];
    foreach (host_agent[i]) begin
      host_agent[i] = tl_agent::type_id::create(
                      $sformatf("%0s_agent", xbar_hosts[i].host_name), this);
      uvm_config_db#(tl_agent_cfg)::set(this,
        $sformatf("*%0s*", xbar_hosts[i].host_name),"cfg", cfg.host_agent_cfg[i]);
    end
    device_agent = new[cfg.num_of_devices];
    foreach (device_agent[i]) begin
      device_agent[i] = tl_agent::type_id::create(
                      $sformatf("%0s_agent", xbar_devices[i].device_name), this);
      uvm_config_db#(tl_agent_cfg)::set(this,
        $sformatf("*%0s*", xbar_devices[i].device_name), "cfg", cfg.device_agent_cfg[i]);
    end

    // create analysis_fifos and scoreboard_queue
    foreach (xbar_hosts[i]) begin
      scoreboard.add_item_port({"a_chan_", xbar_hosts[i].host_name}, scoreboard_pkg::kSrcPort);
      scoreboard.add_item_port({"d_chan_", xbar_hosts[i].host_name}, scoreboard_pkg::kDstPort);
    end
    foreach (xbar_devices[i]) begin
      scoreboard.add_item_port({"a_chan_", xbar_devices[i].device_name}, scoreboard_pkg::kDstPort);
      scoreboard.add_item_port({"d_chan_", xbar_devices[i].device_name}, scoreboard_pkg::kSrcPort);

      scoreboard.add_item_queue({"a_chan_", xbar_devices[i].device_name},
                         scoreboard_pkg::kOutOfOrderCheck);
    end
    // TODO should be same structure as a_chan
    // all the d_channals share one queue as we can't know which host to return from device side
    scoreboard.add_item_queue(D_CHAN_QUEUE_NAME, scoreboard_pkg::kOutOfOrderCheck);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Connect virtual sequencer
    if (cfg.is_active) begin
      virtual_sequencer.host_seqr = new[cfg.num_of_hosts];
      virtual_sequencer.device_seqr = new[cfg.num_of_devices];
      foreach (host_agent[i]) begin
        virtual_sequencer.host_seqr[i] = host_agent[i].seqr;
      end
      foreach (device_agent[i]) begin
        virtual_sequencer.device_seqr[i] = device_agent[i].seqr;
      end
    end
    // Connect scoreboard
    foreach (host_agent[i]) begin
      host_agent[i].mon.a_chan_port.connect(
          scoreboard.item_fifos[{"a_chan_", xbar_hosts[i].host_name}].analysis_export);
      host_agent[i].mon.d_chan_port.connect(
          scoreboard.item_fifos[{"d_chan_", xbar_hosts[i].host_name}].analysis_export);
    end
    foreach (device_agent[i]) begin
      device_agent[i].mon.a_chan_port.connect(
          scoreboard.item_fifos[{"a_chan_", xbar_devices[i].device_name}].analysis_export);
      device_agent[i].mon.d_chan_port.connect(
          scoreboard.item_fifos[{"d_chan_", xbar_devices[i].device_name}].analysis_export);
    end
  endfunction : connect_phase

endclass
