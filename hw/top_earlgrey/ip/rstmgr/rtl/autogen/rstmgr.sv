// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This module is the overall reset manager wrapper

`include "prim_assert.sv"

// This top level controller is fairly hardcoded right now, but will be switched to a template
module rstmgr
  import rstmgr_pkg::*;
  import rstmgr_reg_pkg::*;
  import prim_mubi_pkg::mubi4_t;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}}
) (
  // Primary module clocks
  input clk_i,
  input rst_ni,
  input clk_aon_i,
  input clk_io_div4_i,
  input clk_main_i,
  input clk_io_i,
  input clk_io_div2_i,
  input clk_usb_i,

  // POR input
  input [PowerDomains-1:0] por_n_i,

  // Bus Interface
  input tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Alerts
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  // pwrmgr interface
  input pwrmgr_pkg::pwr_rst_req_t pwr_i,
  output pwrmgr_pkg::pwr_rst_rsp_t pwr_o,

  // software initiated reset request
  output mubi4_t sw_rst_req_o,

  // cpu related inputs
  input logic rst_cpu_n_i,
  input logic ndmreset_req_i,

  // Interface to alert handler
  input alert_pkg::alert_crashdump_t alert_dump_i,

  // Interface to cpu crash dump
  input ibex_pkg::crash_dump_t cpu_dump_i,

  // dft bypass
  input scan_rst_ni,
  input prim_mubi_pkg::mubi4_t scanmode_i,

  // Reset asserted indications going to alert handler
  output rstmgr_rst_en_t rst_en_o,

  // reset outputs
  output rstmgr_out_t resets_o

);

  import prim_mubi_pkg::MuBi4False;
  import prim_mubi_pkg::MuBi4True;

  // receive POR and stretch
  // The por is at first stretched and synced on clk_aon
  // The rst_ni and pok_i input will be changed once AST is integrated
  logic [PowerDomains-1:0] rst_por_aon_n;

  for (genvar i = 0; i < PowerDomains; i++) begin : gen_rst_por_aon

      // Declared as size 1 packed array to avoid FPV warning.
      prim_mubi_pkg::mubi4_t [0:0] por_scanmode;
      prim_mubi4_sync #(
        .NumCopies(1),
        .AsyncOn(0)
      ) u_por_scanmode_sync (
        .clk_i(1'b0),  // unused clock
        .rst_ni(1'b1), // unused reset
        .mubi_i(scanmode_i),
        .mubi_o(por_scanmode)
      );

    if (i == DomainAonSel) begin : gen_rst_por_aon_normal
      rstmgr_por u_rst_por_aon (
        .clk_i(clk_aon_i),
        .rst_ni(por_n_i[i]),
        .scan_rst_ni,
        .scanmode_i(prim_mubi_pkg::mubi4_test_true_strict(por_scanmode[0])),
        .rst_no(rst_por_aon_n[i])
      );

      // reset asserted indication for alert handler
      prim_mubi4_sender #(
        .ResetValue(MuBi4True)
      ) u_prim_mubi4_sender (
        .clk_i(clk_aon_i),
        .rst_ni(rst_por_aon_n[i]),
        .mubi_i(MuBi4False),
        .mubi_o(rst_en_o.por_aon[i])
      );
    end else begin : gen_rst_por_domain
      logic rst_por_aon_premux;
      prim_flop_2sync #(
        .Width(1),
        .ResetValue('0)
      ) u_por_domain_sync (
        .clk_i(clk_aon_i),
        // do not release from reset if aon has not
        .rst_ni(rst_por_aon_n[DomainAonSel] & por_n_i[i]),
        .d_i(1'b1),
        .q_o(rst_por_aon_premux)
      );

      prim_clock_mux2 #(
        .NoFpgaBufG(1'b1)
      ) u_por_domain_mux (
        .clk0_i(rst_por_aon_premux),
        .clk1_i(scan_rst_ni),
        .sel_i(prim_mubi_pkg::mubi4_test_true_strict(por_scanmode[0])),
        .clk_o(rst_por_aon_n[i])
      );

      // reset asserted indication for alert handler
      prim_mubi4_sender #(
        .ResetValue(MuBi4True)
      ) u_prim_mubi4_sender (
        .clk_i(clk_aon_i),
        .rst_ni(rst_por_aon_n[i]),
        .mubi_i(MuBi4False),
        .mubi_o(rst_en_o.por_aon[i])
      );
    end
  end
  assign resets_o.rst_por_aon_n = rst_por_aon_n;

  ////////////////////////////////////////////////////
  // Register Interface                             //
  ////////////////////////////////////////////////////

  rstmgr_reg_pkg::rstmgr_reg2hw_t reg2hw;
  rstmgr_reg_pkg::rstmgr_hw2reg_t hw2reg;

  logic reg_intg_err;
  rstmgr_reg_top u_reg (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .reg2hw,
    .hw2reg,
    .intg_err_o(reg_intg_err),
    .devmode_i(1'b1)
  );


  ////////////////////////////////////////////////////
  // Errors                                         //
  ////////////////////////////////////////////////////

  // consistency check errors
  logic [18:0][PowerDomains-1:0] cnsty_chk_errs;
  logic [18:0][PowerDomains-1:0] shadow_cnsty_chk_errs;

  assign hw2reg.err_code.reg_intg_err.d  = 1'b1;
  assign hw2reg.err_code.reg_intg_err.de = reg_intg_err;
  assign hw2reg.err_code.reset_consistency_err.d  = 1'b1;
  assign hw2reg.err_code.reset_consistency_err.de = |cnsty_chk_errs |
                                                    |shadow_cnsty_chk_errs;

  ////////////////////////////////////////////////////
  // Alerts                                         //
  ////////////////////////////////////////////////////
  logic [NumAlerts-1:0] alert_test, alerts;

  // All of these are fatal alerts
  assign alerts[0] = reg_intg_err |
                     |cnsty_chk_errs |
                     |shadow_cnsty_chk_errs;

  assign alert_test = {
    reg2hw.alert_test.q &
    reg2hw.alert_test.qe
  };

  for (genvar i = 0; i < NumAlerts; i++) begin : gen_alert_tx
    prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .IsFatal(1'b1)
    ) u_prim_alert_sender (
      .clk_i,
      .rst_ni,
      .alert_test_i  ( alert_test[i] ),
      .alert_req_i   ( alerts[0]     ),
      .alert_ack_o   (               ),
      .alert_state_o (               ),
      .alert_rx_i    ( alert_rx_i[i] ),
      .alert_tx_o    ( alert_tx_o[i] )
    );
  end

  ////////////////////////////////////////////////////
  // Input handling                                 //
  ////////////////////////////////////////////////////

  logic ndmreset_req_q;
  logic ndm_req_valid;

  prim_flop_2sync #(
    .Width(1),
    .ResetValue('0)
  ) u_ndm_sync (
    .clk_i,
    .rst_ni,
    .d_i(ndmreset_req_i),
    .q_o(ndmreset_req_q)
  );

  assign ndm_req_valid = ndmreset_req_q & (pwr_i.reset_cause == pwrmgr_pkg::ResetNone);

  ////////////////////////////////////////////////////
  // Source resets in the system                    //
  // These are hardcoded and not directly used.     //
  // Instead they act as async reset roots.         //
  ////////////////////////////////////////////////////

  // The two source reset modules are chained together.  The output of one is fed into the
  // the second.  This ensures that if upstream resets for any reason, the associated downstream
  // reset will also reset.

  logic [PowerDomains-1:0] rst_lc_src_n;
  logic [PowerDomains-1:0] rst_sys_src_n;

  // Declared as size 1 packed array to avoid FPV warning.
  prim_mubi_pkg::mubi4_t [0:0] rst_ctrl_scanmode;
  prim_mubi4_sync #(
    .NumCopies(1),
    .AsyncOn(0)
  ) u_ctrl_scanmode_sync (
    .clk_i(1'b0),  // unused clock
    .rst_ni(1'b1), // unused reset
    .mubi_i(scanmode_i),
    .mubi_o(rst_ctrl_scanmode)
  );

  // lc reset sources
  rstmgr_ctrl u_lc_src (
    .clk_i,
    .scanmode_i(prim_mubi_pkg::mubi4_test_true_strict(rst_ctrl_scanmode[0])),
    .scan_rst_ni,
    .rst_ni,
    .rst_req_i(pwr_i.rst_lc_req),
    .rst_parent_ni({PowerDomains{1'b1}}),
    .rst_no(rst_lc_src_n)
  );

  // sys reset sources
  rstmgr_ctrl u_sys_src (
    .clk_i,
    .scanmode_i(prim_mubi_pkg::mubi4_test_true_strict(rst_ctrl_scanmode[0])),
    .scan_rst_ni,
    .rst_ni,
    .rst_req_i(pwr_i.rst_sys_req | {PowerDomains{ndm_req_valid}}),
    .rst_parent_ni(rst_lc_src_n),
    .rst_no(rst_sys_src_n)
  );

  assign pwr_o.rst_lc_src_n = rst_lc_src_n;
  assign pwr_o.rst_sys_src_n = rst_sys_src_n;


  ////////////////////////////////////////////////////
  // Software reset controls external reg           //
  ////////////////////////////////////////////////////
  logic [NumSwResets-1:0] sw_rst_ctrl_n;

  for (genvar i=0; i < NumSwResets; i++) begin : gen_sw_rst_ext_regs
    prim_subreg #(
      .DW(1),
      .SwAccess(prim_subreg_pkg::SwAccessRW),
      .RESVAL(1)
    ) u_rst_sw_ctrl_reg (
      .clk_i,
      .rst_ni,
      .we(reg2hw.sw_rst_ctrl_n[i].qe & reg2hw.sw_rst_regwen[i]),
      .wd(reg2hw.sw_rst_ctrl_n[i].q),
      .de('0),
      .d('0),
      .qe(),
      .q(sw_rst_ctrl_n[i]),
      .qs(hw2reg.sw_rst_ctrl_n[i].d)
    );
  end

  ////////////////////////////////////////////////////
  // leaf reset in the system                       //
  // These should all be generated                  //
  ////////////////////////////////////////////////////
  // To simplify generation, each reset generates all associated power domain outputs.
  // If a reset does not support a particular power domain, that reset is always hard-wired to 0.

  prim_mubi_pkg::mubi4_t [18:0] leaf_rst_scanmode;
  prim_mubi4_sync #(
    .NumCopies(19),
    .AsyncOn(0)
    ) u_leaf_rst_scanmode_sync  (
    .clk_i(1'b0),  // unused clock
    .rst_ni(1'b1), // unused reset
    .mubi_i(scanmode_i),
    .mubi_o(leaf_rst_scanmode)
 );

  // Generating resets for por
  // Power Domains: ['Aon']
  // Shadowed: False
  rstmgr_leaf_rst u_daon_por (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_main_i),
    .parent_rst_ni(rst_por_aon_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[0])),
    .rst_en_o(rst_en_o.por[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_por_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[0][DomainAonSel])
  );
  assign resets_o.rst_por_n[Domain0Sel] = '0;
  assign cnsty_chk_errs[0][Domain0Sel] = '0;
  assign rst_en_o.por[Domain0Sel] = MuBi4True;
  assign shadow_cnsty_chk_errs[0] = '0;

  // Generating resets for por_io
  // Power Domains: ['Aon']
  // Shadowed: False
  rstmgr_leaf_rst u_daon_por_io (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_i),
    .parent_rst_ni(rst_por_aon_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[1])),
    .rst_en_o(rst_en_o.por_io[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_por_io_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[1][DomainAonSel])
  );
  assign resets_o.rst_por_io_n[Domain0Sel] = '0;
  assign cnsty_chk_errs[1][Domain0Sel] = '0;
  assign rst_en_o.por_io[Domain0Sel] = MuBi4True;
  assign shadow_cnsty_chk_errs[1] = '0;

  // Generating resets for por_io_div2
  // Power Domains: ['Aon']
  // Shadowed: False
  rstmgr_leaf_rst u_daon_por_io_div2 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div2_i),
    .parent_rst_ni(rst_por_aon_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[2])),
    .rst_en_o(rst_en_o.por_io_div2[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_por_io_div2_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[2][DomainAonSel])
  );
  assign resets_o.rst_por_io_div2_n[Domain0Sel] = '0;
  assign cnsty_chk_errs[2][Domain0Sel] = '0;
  assign rst_en_o.por_io_div2[Domain0Sel] = MuBi4True;
  assign shadow_cnsty_chk_errs[2] = '0;

  // Generating resets for por_io_div4
  // Power Domains: ['Aon']
  // Shadowed: False
  rstmgr_leaf_rst u_daon_por_io_div4 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_por_aon_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[3])),
    .rst_en_o(rst_en_o.por_io_div4[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_por_io_div4_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[3][DomainAonSel])
  );
  assign resets_o.rst_por_io_div4_n[Domain0Sel] = '0;
  assign cnsty_chk_errs[3][Domain0Sel] = '0;
  assign rst_en_o.por_io_div4[Domain0Sel] = MuBi4True;
  assign shadow_cnsty_chk_errs[3] = '0;

  // Generating resets for por_usb
  // Power Domains: ['Aon']
  // Shadowed: False
  rstmgr_leaf_rst u_daon_por_usb (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_usb_i),
    .parent_rst_ni(rst_por_aon_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[4])),
    .rst_en_o(rst_en_o.por_usb[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_por_usb_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[4][DomainAonSel])
  );
  assign resets_o.rst_por_usb_n[Domain0Sel] = '0;
  assign cnsty_chk_errs[4][Domain0Sel] = '0;
  assign rst_en_o.por_usb[Domain0Sel] = MuBi4True;
  assign shadow_cnsty_chk_errs[4] = '0;

  // Generating resets for lc
  // Power Domains: ['0']
  // Shadowed: True
  assign resets_o.rst_lc_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[5][DomainAonSel] = '0;
  assign rst_en_o.lc[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_lc (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_main_i),
    .parent_rst_ni(rst_lc_src_n[Domain0Sel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[5])),
    .rst_en_o(rst_en_o.lc[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_lc_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[5][Domain0Sel])
  );
  assign resets_o.rst_lc_shadowed_n[DomainAonSel] = '0;
  assign shadow_cnsty_chk_errs[5][DomainAonSel] = '0;
  assign rst_en_o.lc_shadowed[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_lc_shadowed (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_main_i),
    .parent_rst_ni(rst_lc_src_n[Domain0Sel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[5])),
    .rst_en_o(rst_en_o.lc_shadowed[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_lc_shadowed_n[Domain0Sel]),
    .err_o(shadow_cnsty_chk_errs[5][Domain0Sel])
  );

  // Generating resets for lc_io_div4
  // Power Domains: ['0', 'Aon']
  // Shadowed: True
  rstmgr_leaf_rst u_daon_lc_io_div4 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_lc_src_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[6])),
    .rst_en_o(rst_en_o.lc_io_div4[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_lc_io_div4_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[6][DomainAonSel])
  );
  rstmgr_leaf_rst u_d0_lc_io_div4 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_lc_src_n[Domain0Sel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[6])),
    .rst_en_o(rst_en_o.lc_io_div4[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_lc_io_div4_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[6][Domain0Sel])
  );
  rstmgr_leaf_rst u_daon_lc_io_div4_shadowed (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_lc_src_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[6])),
    .rst_en_o(rst_en_o.lc_io_div4_shadowed[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_lc_io_div4_shadowed_n[DomainAonSel]),
    .err_o(shadow_cnsty_chk_errs[6][DomainAonSel])
  );
  rstmgr_leaf_rst u_d0_lc_io_div4_shadowed (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_lc_src_n[Domain0Sel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[6])),
    .rst_en_o(rst_en_o.lc_io_div4_shadowed[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_lc_io_div4_shadowed_n[Domain0Sel]),
    .err_o(shadow_cnsty_chk_errs[6][Domain0Sel])
  );

  // Generating resets for lc_aon
  // Power Domains: ['Aon']
  // Shadowed: False
  rstmgr_leaf_rst u_daon_lc_aon (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_aon_i),
    .parent_rst_ni(rst_lc_src_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[7])),
    .rst_en_o(rst_en_o.lc_aon[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_lc_aon_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[7][DomainAonSel])
  );
  assign resets_o.rst_lc_aon_n[Domain0Sel] = '0;
  assign cnsty_chk_errs[7][Domain0Sel] = '0;
  assign rst_en_o.lc_aon[Domain0Sel] = MuBi4True;
  assign shadow_cnsty_chk_errs[7] = '0;

  // Generating resets for sys
  // Power Domains: ['0']
  // Shadowed: True
  assign resets_o.rst_sys_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[8][DomainAonSel] = '0;
  assign rst_en_o.sys[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_sys (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_main_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[8])),
    .rst_en_o(rst_en_o.sys[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_sys_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[8][Domain0Sel])
  );
  assign resets_o.rst_sys_shadowed_n[DomainAonSel] = '0;
  assign shadow_cnsty_chk_errs[8][DomainAonSel] = '0;
  assign rst_en_o.sys_shadowed[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_sys_shadowed (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_main_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[8])),
    .rst_en_o(rst_en_o.sys_shadowed[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_sys_shadowed_n[Domain0Sel]),
    .err_o(shadow_cnsty_chk_errs[8][Domain0Sel])
  );

  // Generating resets for sys_io_div4
  // Power Domains: ['0', 'Aon']
  // Shadowed: False
  rstmgr_leaf_rst u_daon_sys_io_div4 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_sys_src_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[9])),
    .rst_en_o(rst_en_o.sys_io_div4[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_sys_io_div4_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[9][DomainAonSel])
  );
  rstmgr_leaf_rst u_d0_sys_io_div4 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[9])),
    .rst_en_o(rst_en_o.sys_io_div4[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_sys_io_div4_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[9][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[9] = '0;

  // Generating resets for sys_aon
  // Power Domains: ['0', 'Aon']
  // Shadowed: False
  rstmgr_leaf_rst u_daon_sys_aon (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_aon_i),
    .parent_rst_ni(rst_sys_src_n[DomainAonSel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[10])),
    .rst_en_o(rst_en_o.sys_aon[DomainAonSel]),
    .leaf_rst_o(resets_o.rst_sys_aon_n[DomainAonSel]),
    .err_o(cnsty_chk_errs[10][DomainAonSel])
  );
  rstmgr_leaf_rst u_d0_sys_aon (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_aon_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(1'b1),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[10])),
    .rst_en_o(rst_en_o.sys_aon[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_sys_aon_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[10][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[10] = '0;

  // Generating resets for spi_device
  // Power Domains: ['0']
  // Shadowed: False
  assign resets_o.rst_spi_device_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[11][DomainAonSel] = '0;
  assign rst_en_o.spi_device[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_spi_device (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(sw_rst_ctrl_n[SPI_DEVICE]),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[11])),
    .rst_en_o(rst_en_o.spi_device[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_spi_device_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[11][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[11] = '0;

  // Generating resets for spi_host0
  // Power Domains: ['0']
  // Shadowed: False
  assign resets_o.rst_spi_host0_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[12][DomainAonSel] = '0;
  assign rst_en_o.spi_host0[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_spi_host0 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(sw_rst_ctrl_n[SPI_HOST0]),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[12])),
    .rst_en_o(rst_en_o.spi_host0[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_spi_host0_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[12][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[12] = '0;

  // Generating resets for spi_host1
  // Power Domains: ['0']
  // Shadowed: False
  assign resets_o.rst_spi_host1_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[13][DomainAonSel] = '0;
  assign rst_en_o.spi_host1[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_spi_host1 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div2_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(sw_rst_ctrl_n[SPI_HOST1]),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[13])),
    .rst_en_o(rst_en_o.spi_host1[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_spi_host1_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[13][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[13] = '0;

  // Generating resets for usb
  // Power Domains: ['0']
  // Shadowed: False
  assign resets_o.rst_usb_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[14][DomainAonSel] = '0;
  assign rst_en_o.usb[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_usb (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(sw_rst_ctrl_n[USB]),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[14])),
    .rst_en_o(rst_en_o.usb[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_usb_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[14][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[14] = '0;

  // Generating resets for usbif
  // Power Domains: ['0']
  // Shadowed: False
  assign resets_o.rst_usbif_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[15][DomainAonSel] = '0;
  assign rst_en_o.usbif[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_usbif (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_usb_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(sw_rst_ctrl_n[USBIF]),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[15])),
    .rst_en_o(rst_en_o.usbif[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_usbif_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[15][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[15] = '0;

  // Generating resets for i2c0
  // Power Domains: ['0']
  // Shadowed: False
  assign resets_o.rst_i2c0_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[16][DomainAonSel] = '0;
  assign rst_en_o.i2c0[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_i2c0 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(sw_rst_ctrl_n[I2C0]),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[16])),
    .rst_en_o(rst_en_o.i2c0[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_i2c0_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[16][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[16] = '0;

  // Generating resets for i2c1
  // Power Domains: ['0']
  // Shadowed: False
  assign resets_o.rst_i2c1_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[17][DomainAonSel] = '0;
  assign rst_en_o.i2c1[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_i2c1 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(sw_rst_ctrl_n[I2C1]),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[17])),
    .rst_en_o(rst_en_o.i2c1[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_i2c1_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[17][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[17] = '0;

  // Generating resets for i2c2
  // Power Domains: ['0']
  // Shadowed: False
  assign resets_o.rst_i2c2_n[DomainAonSel] = '0;
  assign cnsty_chk_errs[18][DomainAonSel] = '0;
  assign rst_en_o.i2c2[DomainAonSel] = MuBi4True;
  rstmgr_leaf_rst u_d0_i2c2 (
    .clk_i,
    .rst_ni,
    .leaf_clk_i(clk_io_div4_i),
    .parent_rst_ni(rst_sys_src_n[Domain0Sel]),
    .sw_rst_req_ni(sw_rst_ctrl_n[I2C2]),
    .scan_rst_ni,
    .scan_sel(prim_mubi_pkg::mubi4_test_true_strict(leaf_rst_scanmode[18])),
    .rst_en_o(rst_en_o.i2c2[Domain0Sel]),
    .leaf_rst_o(resets_o.rst_i2c2_n[Domain0Sel]),
    .err_o(cnsty_chk_errs[18][Domain0Sel])
  );
  assign shadow_cnsty_chk_errs[18] = '0;


  ////////////////////////////////////////////////////
  // Reset info construction                        //
  ////////////////////////////////////////////////////

  logic rst_hw_req;
  logic rst_low_power;
  logic rst_ndm;
  logic rst_cpu_nq;
  logic first_reset;
  logic pwrmgr_rst_req;

  // there is a valid reset request from pwrmgr
  assign pwrmgr_rst_req = |pwr_i.rst_lc_req | |pwr_i.rst_sys_req;

  // The qualification of first reset below could technically be POR as well.
  // However, that would enforce software to clear POR upon cold power up.  While that is
  // the most likely outcome anyways, hardware should not require that.
  assign rst_hw_req    = ~first_reset & pwrmgr_rst_req &
                         (pwr_i.reset_cause == pwrmgr_pkg::HwReq);
  assign rst_ndm       = ~first_reset & ndm_req_valid;
  assign rst_low_power = ~first_reset & pwrmgr_rst_req &
                         (pwr_i.reset_cause == pwrmgr_pkg::LowPwrEntry);

  // software initiated reset request
  assign sw_rst_req_o = prim_mubi_pkg::mubi4_e'(reg2hw.reset_req.q);

  // when pwrmgr reset request is received (reset is imminent), clear software
  // request so we are not in an infinite reset loop.
  assign hw2reg.reset_req.de = pwrmgr_rst_req;
  assign hw2reg.reset_req.d  = prim_mubi_pkg::MuBi4False;

  prim_flop_2sync #(
    .Width(1),
    .ResetValue('0)
  ) u_cpu_reset_synced (
    .clk_i,
    .rst_ni,
    .d_i(rst_cpu_n_i),
    .q_o(rst_cpu_nq)
  );

  // first reset is a flag that blocks reset recording until first de-assertion
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      first_reset <= 1'b1;
    end else if (rst_cpu_nq) begin
      first_reset <= 1'b0;
    end
  end

  // Only sw is allowed to clear a reset reason, hw is only allowed to set it.
  assign hw2reg.reset_info.low_power_exit.d  = 1'b1;
  assign hw2reg.reset_info.low_power_exit.de = rst_low_power;

  assign hw2reg.reset_info.ndm_reset.d  = 1'b1;
  assign hw2reg.reset_info.ndm_reset.de = rst_ndm;

  // software issued request triggers the same response as hardware, although it is
  // accounted for differently.
  assign hw2reg.reset_info.sw_reset.d = prim_mubi_pkg::mubi4_test_true_strict(sw_rst_req_o) |
                                        reg2hw.reset_info.sw_reset.q;
  assign hw2reg.reset_info.sw_reset.de = rst_hw_req;

  // HW reset requests most likely will be multi-bit, so OR in whatever reasons
  // that are already set.
  assign hw2reg.reset_info.hw_req.d  = pwr_i.rstreqs[pwrmgr_pkg::HwResetWidth-1:0] |
                                       reg2hw.reset_info.hw_req.q;
  assign hw2reg.reset_info.hw_req.de = rst_hw_req;

  ////////////////////////////////////////////////////
  // Crash info capture                             //
  ////////////////////////////////////////////////////

  logic dump_capture;
  assign dump_capture =  rst_hw_req | rst_ndm | rst_low_power;

  // halt dump capture once we hit particular conditions
  logic dump_capture_halt;
  assign dump_capture_halt = rst_hw_req;

  rstmgr_crash_info #(
    .CrashDumpWidth($bits(alert_pkg::alert_crashdump_t))
  ) u_alert_info (
    .clk_i,
    .rst_ni,
    .dump_i(alert_dump_i),
    .dump_capture_i(dump_capture & reg2hw.alert_info_ctrl.en.q),
    .slot_sel_i(reg2hw.alert_info_ctrl.index.q),
    .slots_cnt_o(hw2reg.alert_info_attr.d),
    .slot_o(hw2reg.alert_info.d)
  );

  rstmgr_crash_info #(
    .CrashDumpWidth($bits(ibex_pkg::crash_dump_t))
  ) u_cpu_info (
    .clk_i,
    .rst_ni,
    .dump_i(cpu_dump_i),
    .dump_capture_i(dump_capture & reg2hw.cpu_info_ctrl.en.q),
    .slot_sel_i(reg2hw.cpu_info_ctrl.index.q),
    .slots_cnt_o(hw2reg.cpu_info_attr.d),
    .slot_o(hw2reg.cpu_info.d)
  );

  // once dump is captured, no more information is captured until
  // re-eanbled by software.
  assign hw2reg.alert_info_ctrl.en.d  = 1'b0;
  assign hw2reg.alert_info_ctrl.en.de = dump_capture_halt;
  assign hw2reg.cpu_info_ctrl.en.d  = 1'b0;
  assign hw2reg.cpu_info_ctrl.en.de = dump_capture_halt;

  ////////////////////////////////////////////////////
  // Exported resets                                //
  ////////////////////////////////////////////////////




  ////////////////////////////////////////////////////
  // Assertions                                     //
  ////////////////////////////////////////////////////

  `ASSERT_INIT(ParameterMatch_A, NumHwResets == pwrmgr_pkg::HwResetWidth)

  // when upstream resets, downstream must also reset

  // output known asserts
  `ASSERT_KNOWN(TlDValidKnownO_A,    tl_o.d_valid  )
  `ASSERT_KNOWN(TlAReadyKnownO_A,    tl_o.a_ready  )
  `ASSERT_KNOWN(AlertsKnownO_A,      alert_tx_o    )
  `ASSERT_KNOWN(PwrKnownO_A,         pwr_o         )
  `ASSERT_KNOWN(ResetsKnownO_A,      resets_o      )
  `ASSERT_KNOWN(RstEnKnownO_A,       rst_en_o      )

endmodule // rstmgr
