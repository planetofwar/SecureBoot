// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// rv_core_ibex package
//

package rv_core_ibex_pkg;
  import prim_mubi_pkg::mubi4_t; 
  typedef struct packed {
    logic en;
    logic [31:0] matching_region;
    logic [31:0] remap_addr;
  } region_cfg_t;

  typedef struct packed {
    // previous valid is true only during double fault
    logic prev_valid;
    logic [31:0] prev_exception_pc;
    logic [31:0] prev_exception_addr;
    ibex_pkg::crash_dump_t current;
  } cpu_crash_dump_t;

  typedef struct packed {
    logic instr_req;
    logic [31:0] instr_addr;
    logic data_req;
    logic data_we;
    logic [3:0]  data_be;
    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    logic [6:0]  data_wdata_intg;
    ibex_pkg::crash_dump_t crash_dump;
    logic key_req;
    logic double_fault;
    logic alert_minor;
    logic alert_major_internal;
    logic alert_major_bus;
    logic core_sleep;
  } core_outputs_t;

  typedef struct packed {
    logic ibex_top_clk_i;
    prim_mubi_pkg::mubi4_t scanmode_i;
    logic instr_gnt;
    logic instr_rvalid;
    logic [31:0] instr_rdata;
    logic [6:0]  instr_rdata_intg;
    logic instr_err;
    logic data_gnt;
    logic data_rvalid;
    logic [31:0] data_rdata;
    logic [6:0]  data_rdata_intg;
    logic data_err;
    logic irq_software;
    logic irq_timer;
    logic irq_external;
    logic irq_nm;
    logic key_ack;
    logic [ibex_pkg::SCRAMBLE_KEY_W-1:0] key;
    logic [ibex_pkg::SCRAMBLE_NONCE_W-1:0] nonce;
    lc_ctrl_pkg::lc_tx_t fetch_enable;   
  } core_inputs_t;
endpackage // rv_core_ibex_pkg
