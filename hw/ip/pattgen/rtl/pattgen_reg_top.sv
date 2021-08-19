// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module pattgen_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output pattgen_reg_pkg::pattgen_reg2hw_t reg2hw, // Write
  input  pattgen_reg_pkg::pattgen_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import pattgen_reg_pkg::* ;

  localparam int AW = 6;
  localparam int DW = 32;
  localparam int DBW = DW/8;                    // Byte Width

  // register signals
  logic           reg_we;
  logic           reg_re;
  logic [AW-1:0]  reg_addr;
  logic [DW-1:0]  reg_wdata;
  logic [DBW-1:0] reg_be;
  logic [DW-1:0]  reg_rdata;
  logic           reg_error;

  logic          addrmiss, wr_err;

  logic [DW-1:0] reg_rdata_next;
  logic reg_busy;

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;


  // incoming payload check
  logic intg_err;
  tlul_cmd_intg_chk u_chk (
    .tl_i(tl_i),
    .err_o(intg_err)
  );

  logic intg_err_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      intg_err_q <= '0;
    end else if (intg_err) begin
      intg_err_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // register errors are transactional
  assign intg_err_o = intg_err_q | intg_err;

  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o(tl_o)
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(0)
  ) u_reg_if (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),

    .tl_i (tl_reg_h2d),
    .tl_o (tl_reg_d2h),

    .we_o    (reg_we),
    .re_o    (reg_re),
    .addr_o  (reg_addr),
    .wdata_o (reg_wdata),
    .be_o    (reg_be),
    .busy_i  (reg_busy),
    .rdata_i (reg_rdata),
    .error_i (reg_error)
  );

  // cdc oversampling signals

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = (devmode_i & addrmiss) | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic intr_state_we;
  logic intr_state_done_ch0_qs;
  logic intr_state_done_ch0_wd;
  logic intr_state_done_ch1_qs;
  logic intr_state_done_ch1_wd;
  logic intr_enable_we;
  logic intr_enable_done_ch0_qs;
  logic intr_enable_done_ch0_wd;
  logic intr_enable_done_ch1_qs;
  logic intr_enable_done_ch1_wd;
  logic intr_test_we;
  logic intr_test_done_ch0_wd;
  logic intr_test_done_ch1_wd;
  logic alert_test_we;
  logic alert_test_wd;
  logic ctrl_we;
  logic ctrl_enable_ch0_qs;
  logic ctrl_enable_ch0_wd;
  logic ctrl_enable_ch1_qs;
  logic ctrl_enable_ch1_wd;
  logic ctrl_polarity_ch0_qs;
  logic ctrl_polarity_ch0_wd;
  logic ctrl_polarity_ch1_qs;
  logic ctrl_polarity_ch1_wd;
  logic prediv_ch0_we;
  logic [31:0] prediv_ch0_qs;
  logic [31:0] prediv_ch0_wd;
  logic prediv_ch1_we;
  logic [31:0] prediv_ch1_qs;
  logic [31:0] prediv_ch1_wd;
  logic data_ch0_0_we;
  logic [31:0] data_ch0_0_qs;
  logic [31:0] data_ch0_0_wd;
  logic data_ch0_1_we;
  logic [31:0] data_ch0_1_qs;
  logic [31:0] data_ch0_1_wd;
  logic data_ch1_0_we;
  logic [31:0] data_ch1_0_qs;
  logic [31:0] data_ch1_0_wd;
  logic data_ch1_1_we;
  logic [31:0] data_ch1_1_qs;
  logic [31:0] data_ch1_1_wd;
  logic size_we;
  logic [5:0] size_len_ch0_qs;
  logic [5:0] size_len_ch0_wd;
  logic [9:0] size_reps_ch0_qs;
  logic [9:0] size_reps_ch0_wd;
  logic [5:0] size_len_ch1_qs;
  logic [5:0] size_len_ch1_wd;
  logic [9:0] size_reps_ch1_qs;
  logic [9:0] size_reps_ch1_wd;

  // Register instances
  // R[intr_state]: V(False)

  //   F[done_ch0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_done_ch0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_done_ch0_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.done_ch0.de),
    .d      (hw2reg.intr_state.done_ch0.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.done_ch0.q),

    // to register interface (read)
    .qs     (intr_state_done_ch0_qs)
  );


  //   F[done_ch1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_done_ch1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_done_ch1_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.done_ch1.de),
    .d      (hw2reg.intr_state.done_ch1.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.done_ch1.q),

    // to register interface (read)
    .qs     (intr_state_done_ch1_qs)
  );


  // R[intr_enable]: V(False)

  //   F[done_ch0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_done_ch0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_done_ch0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.done_ch0.q),

    // to register interface (read)
    .qs     (intr_enable_done_ch0_qs)
  );


  //   F[done_ch1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_done_ch1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_done_ch1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.done_ch1.q),

    // to register interface (read)
    .qs     (intr_enable_done_ch1_qs)
  );


  // R[intr_test]: V(True)

  //   F[done_ch0]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_done_ch0 (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_done_ch0_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.done_ch0.qe),
    .q      (reg2hw.intr_test.done_ch0.q),
    .qs     ()
  );


  //   F[done_ch1]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_done_ch1 (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_done_ch1_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.done_ch1.qe),
    .q      (reg2hw.intr_test.done_ch1.q),
    .qs     ()
  );


  // R[alert_test]: V(True)

  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.qe),
    .q      (reg2hw.alert_test.q),
    .qs     ()
  );


  // R[ctrl]: V(False)

  //   F[enable_ch0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_enable_ch0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_enable_ch0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.enable_ch0.q),

    // to register interface (read)
    .qs     (ctrl_enable_ch0_qs)
  );


  //   F[enable_ch1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_enable_ch1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_enable_ch1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.enable_ch1.q),

    // to register interface (read)
    .qs     (ctrl_enable_ch1_qs)
  );


  //   F[polarity_ch0]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_polarity_ch0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_polarity_ch0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.polarity_ch0.q),

    // to register interface (read)
    .qs     (ctrl_polarity_ch0_qs)
  );


  //   F[polarity_ch1]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_polarity_ch1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_polarity_ch1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.polarity_ch1.q),

    // to register interface (read)
    .qs     (ctrl_polarity_ch1_qs)
  );


  // R[prediv_ch0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_prediv_ch0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (prediv_ch0_we),
    .wd     (prediv_ch0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.prediv_ch0.q),

    // to register interface (read)
    .qs     (prediv_ch0_qs)
  );


  // R[prediv_ch1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_prediv_ch1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (prediv_ch1_we),
    .wd     (prediv_ch1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.prediv_ch1.q),

    // to register interface (read)
    .qs     (prediv_ch1_qs)
  );



  // Subregister 0 of Multireg data_ch0
  // R[data_ch0_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_data_ch0_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (data_ch0_0_we),
    .wd     (data_ch0_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.data_ch0[0].q),

    // to register interface (read)
    .qs     (data_ch0_0_qs)
  );

  // Subregister 1 of Multireg data_ch0
  // R[data_ch0_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_data_ch0_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (data_ch0_1_we),
    .wd     (data_ch0_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.data_ch0[1].q),

    // to register interface (read)
    .qs     (data_ch0_1_qs)
  );



  // Subregister 0 of Multireg data_ch1
  // R[data_ch1_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_data_ch1_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (data_ch1_0_we),
    .wd     (data_ch1_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.data_ch1[0].q),

    // to register interface (read)
    .qs     (data_ch1_0_qs)
  );

  // Subregister 1 of Multireg data_ch1
  // R[data_ch1_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_data_ch1_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (data_ch1_1_we),
    .wd     (data_ch1_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.data_ch1[1].q),

    // to register interface (read)
    .qs     (data_ch1_1_qs)
  );


  // R[size]: V(False)

  //   F[len_ch0]: 5:0
  prim_subreg #(
    .DW      (6),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (6'h0)
  ) u_size_len_ch0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (size_we),
    .wd     (size_len_ch0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.size.len_ch0.q),

    // to register interface (read)
    .qs     (size_len_ch0_qs)
  );


  //   F[reps_ch0]: 15:6
  prim_subreg #(
    .DW      (10),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (10'h0)
  ) u_size_reps_ch0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (size_we),
    .wd     (size_reps_ch0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.size.reps_ch0.q),

    // to register interface (read)
    .qs     (size_reps_ch0_qs)
  );


  //   F[len_ch1]: 21:16
  prim_subreg #(
    .DW      (6),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (6'h0)
  ) u_size_len_ch1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (size_we),
    .wd     (size_len_ch1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.size.len_ch1.q),

    // to register interface (read)
    .qs     (size_len_ch1_qs)
  );


  //   F[reps_ch1]: 31:22
  prim_subreg #(
    .DW      (10),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (10'h0)
  ) u_size_reps_ch1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (size_we),
    .wd     (size_reps_ch1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.size.reps_ch1.q),

    // to register interface (read)
    .qs     (size_reps_ch1_qs)
  );




  logic [11:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == PATTGEN_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == PATTGEN_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == PATTGEN_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == PATTGEN_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == PATTGEN_CTRL_OFFSET);
    addr_hit[ 5] = (reg_addr == PATTGEN_PREDIV_CH0_OFFSET);
    addr_hit[ 6] = (reg_addr == PATTGEN_PREDIV_CH1_OFFSET);
    addr_hit[ 7] = (reg_addr == PATTGEN_DATA_CH0_0_OFFSET);
    addr_hit[ 8] = (reg_addr == PATTGEN_DATA_CH0_1_OFFSET);
    addr_hit[ 9] = (reg_addr == PATTGEN_DATA_CH1_0_OFFSET);
    addr_hit[10] = (reg_addr == PATTGEN_DATA_CH1_1_OFFSET);
    addr_hit[11] = (reg_addr == PATTGEN_SIZE_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(PATTGEN_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(PATTGEN_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(PATTGEN_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(PATTGEN_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(PATTGEN_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(PATTGEN_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(PATTGEN_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(PATTGEN_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(PATTGEN_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(PATTGEN_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(PATTGEN_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(PATTGEN_PERMIT[11] & ~reg_be)))));
  end
  assign intr_state_we = addr_hit[0] & reg_we & !reg_error;

  assign intr_state_done_ch0_wd = reg_wdata[0];

  assign intr_state_done_ch1_wd = reg_wdata[1];
  assign intr_enable_we = addr_hit[1] & reg_we & !reg_error;

  assign intr_enable_done_ch0_wd = reg_wdata[0];

  assign intr_enable_done_ch1_wd = reg_wdata[1];
  assign intr_test_we = addr_hit[2] & reg_we & !reg_error;

  assign intr_test_done_ch0_wd = reg_wdata[0];

  assign intr_test_done_ch1_wd = reg_wdata[1];
  assign alert_test_we = addr_hit[3] & reg_we & !reg_error;

  assign alert_test_wd = reg_wdata[0];
  assign ctrl_we = addr_hit[4] & reg_we & !reg_error;

  assign ctrl_enable_ch0_wd = reg_wdata[0];

  assign ctrl_enable_ch1_wd = reg_wdata[1];

  assign ctrl_polarity_ch0_wd = reg_wdata[2];

  assign ctrl_polarity_ch1_wd = reg_wdata[3];
  assign prediv_ch0_we = addr_hit[5] & reg_we & !reg_error;

  assign prediv_ch0_wd = reg_wdata[31:0];
  assign prediv_ch1_we = addr_hit[6] & reg_we & !reg_error;

  assign prediv_ch1_wd = reg_wdata[31:0];
  assign data_ch0_0_we = addr_hit[7] & reg_we & !reg_error;

  assign data_ch0_0_wd = reg_wdata[31:0];
  assign data_ch0_1_we = addr_hit[8] & reg_we & !reg_error;

  assign data_ch0_1_wd = reg_wdata[31:0];
  assign data_ch1_0_we = addr_hit[9] & reg_we & !reg_error;

  assign data_ch1_0_wd = reg_wdata[31:0];
  assign data_ch1_1_we = addr_hit[10] & reg_we & !reg_error;

  assign data_ch1_1_wd = reg_wdata[31:0];
  assign size_we = addr_hit[11] & reg_we & !reg_error;

  assign size_len_ch0_wd = reg_wdata[5:0];

  assign size_reps_ch0_wd = reg_wdata[15:6];

  assign size_len_ch1_wd = reg_wdata[21:16];

  assign size_reps_ch1_wd = reg_wdata[31:22];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_done_ch0_qs;
        reg_rdata_next[1] = intr_state_done_ch1_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_done_ch0_qs;
        reg_rdata_next[1] = intr_enable_done_ch1_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = ctrl_enable_ch0_qs;
        reg_rdata_next[1] = ctrl_enable_ch1_qs;
        reg_rdata_next[2] = ctrl_polarity_ch0_qs;
        reg_rdata_next[3] = ctrl_polarity_ch1_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[31:0] = prediv_ch0_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = prediv_ch1_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = data_ch0_0_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = data_ch0_1_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = data_ch1_0_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = data_ch1_1_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[5:0] = size_len_ch0_qs;
        reg_rdata_next[15:6] = size_reps_ch0_qs;
        reg_rdata_next[21:16] = size_len_ch1_qs;
        reg_rdata_next[31:22] = size_reps_ch1_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // shadow busy
  logic shadow_busy;
  assign shadow_busy = 1'b0;

  // register busy
  logic reg_busy_sel;
  assign reg_busy = reg_busy_sel | shadow_busy;
  always_comb begin
    reg_busy_sel = '0;
    unique case (1'b1)
      default: begin
        reg_busy_sel  = '0;
      end
    endcase
  end


  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we, clk_i, !rst_ni)
  `ASSERT_PULSE(rePulse, reg_re, clk_i, !rst_ni)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o_pre.d_valid, clk_i, !rst_ni)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit), clk_i, !rst_ni)

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
