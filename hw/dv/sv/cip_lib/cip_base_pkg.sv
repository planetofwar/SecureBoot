// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package cip_base_pkg;
  // dep packages
  import uvm_pkg::*;
  import bus_params_pkg::*;
  import dv_utils_pkg::*;
  import csr_utils_pkg::*;
  import dv_lib_pkg::*;
  import dv_base_reg_pkg::*;
  import tl_agent_pkg::*;
  import alert_esc_agent_pkg::*;
  import push_pull_agent_pkg::*;
  import mem_model_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // package variables
  string msg_id = "cip_base_pkg";
  parameter uint EDN_BUS_WIDTH = 32;
  parameter uint EDN_DATA_WIDTH = EDN_BUS_WIDTH + 1; // 32 bits bus data, 1 bit fips

  typedef enum {
    err_update,
    err_storage
  } shadow_reg_alert_e;

  // functions
  function automatic void split_all_csrs_by_shadowed(input  dv_base_reg_block ral,
                                                     output dv_base_reg shadowed_csrs[$],
                                                     output dv_base_reg non_shadowed_csrs[$]);
    dv_base_reg all_csrs[$];
    ral.get_dv_base_regs(all_csrs);
    foreach (all_csrs[i]) begin
      if (all_csrs[i].get_is_shadowed()) shadowed_csrs.push_back(all_csrs[i]);
      else non_shadowed_csrs.push_back(all_csrs[i]);
    end
  endfunction

  // package sources
  // base env
  `include "cip_base_env_cfg.sv"
  `include "cip_base_env_cov.sv"
  `include "cip_base_virtual_sequencer.sv"
  `include "cip_base_scoreboard.sv"
  `include "cip_base_env.sv"

  // sequences
  `include "cip_base_vseq.sv"

  // tests
  `include "cip_base_test.sv"

endpackage
