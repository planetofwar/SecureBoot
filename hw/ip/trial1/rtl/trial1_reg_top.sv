// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module trial1_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output trial1_reg_pkg::trial1_reg2hw_t reg2hw, // Write
  input  trial1_reg_pkg::trial1_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import trial1_reg_pkg::* ;

  localparam int AW = 10;
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

  // also check for spurious write enables
  logic reg_we_err;
  logic [19:0] reg_we_check;
  prim_reg_we_check #(
    .OneHotWidth(20)
  ) u_prim_reg_we_check (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .oh_i  (reg_we_check),
    .en_i  (reg_we && !addrmiss),
    .err_o (reg_we_err)
  );

  logic err_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_q <= '0;
    end else if (intg_err || reg_we_err) begin
      err_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // register errors are transactional
  assign intg_err_o = err_q | intg_err | reg_we_err;

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
  logic rwtype0_we;
  logic [31:0] rwtype0_qs;
  logic [31:0] rwtype0_wd;
  logic rwtype1_we;
  logic rwtype1_field0_qs;
  logic rwtype1_field0_wd;
  logic rwtype1_field1_qs;
  logic rwtype1_field1_wd;
  logic rwtype1_field4_qs;
  logic rwtype1_field4_wd;
  logic [7:0] rwtype1_field15_8_qs;
  logic [7:0] rwtype1_field15_8_wd;
  logic rwtype2_we;
  logic [31:0] rwtype2_qs;
  logic [31:0] rwtype2_wd;
  logic rwtype3_we;
  logic [15:0] rwtype3_field0_qs;
  logic [15:0] rwtype3_field0_wd;
  logic [15:0] rwtype3_field1_qs;
  logic [15:0] rwtype3_field1_wd;
  logic rwtype4_we;
  logic [15:0] rwtype4_field0_qs;
  logic [15:0] rwtype4_field0_wd;
  logic [15:0] rwtype4_field1_qs;
  logic [15:0] rwtype4_field1_wd;
  logic [31:0] rotype0_qs;
  logic w1ctype0_we;
  logic [31:0] w1ctype0_qs;
  logic [31:0] w1ctype0_wd;
  logic w1ctype1_we;
  logic [15:0] w1ctype1_field0_qs;
  logic [15:0] w1ctype1_field0_wd;
  logic [15:0] w1ctype1_field1_qs;
  logic [15:0] w1ctype1_field1_wd;
  logic w1ctype2_we;
  logic [31:0] w1ctype2_qs;
  logic [31:0] w1ctype2_wd;
  logic w1stype2_we;
  logic [31:0] w1stype2_qs;
  logic [31:0] w1stype2_wd;
  logic w0ctype2_we;
  logic [31:0] w0ctype2_qs;
  logic [31:0] w0ctype2_wd;
  logic r0w1ctype2_we;
  logic [31:0] r0w1ctype2_wd;
  logic rctype0_re;
  logic [31:0] rctype0_qs;
  logic [31:0] rctype0_wd;
  logic wotype0_we;
  logic [31:0] wotype0_wd;
  logic mixtype0_we;
  logic [3:0] mixtype0_field0_qs;
  logic [3:0] mixtype0_field0_wd;
  logic [3:0] mixtype0_field1_qs;
  logic [3:0] mixtype0_field1_wd;
  logic [3:0] mixtype0_field2_qs;
  logic [3:0] mixtype0_field3_qs;
  logic [3:0] mixtype0_field4_qs;
  logic [3:0] mixtype0_field4_wd;
  logic [3:0] mixtype0_field5_qs;
  logic [3:0] mixtype0_field5_wd;
  logic [3:0] mixtype0_field6_qs;
  logic [3:0] mixtype0_field6_wd;
  logic [3:0] mixtype0_field7_wd;
  logic rwtype5_we;
  logic [31:0] rwtype5_qs;
  logic [31:0] rwtype5_wd;
  logic rwtype6_re;
  logic rwtype6_we;
  logic [31:0] rwtype6_qs;
  logic [31:0] rwtype6_wd;
  logic rotype1_re;
  logic [31:0] rotype1_qs;
  logic [7:0] rotype2_field0_qs;
  logic [7:0] rotype2_field1_qs;
  logic [11:0] rotype2_field2_qs;
  logic rwtype7_we;
  logic [31:0] rwtype7_qs;
  logic [31:0] rwtype7_wd;

  // Register instances
  // R[rwtype0]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'hbc614e)
  ) u_rwtype0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype0_we),
    .wd     (rwtype0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype0.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype0_qs)
  );


  // R[rwtype1]: V(False)
  //   F[field0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1)
  ) u_rwtype1_field0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype1_we),
    .wd     (rwtype1_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field0.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype1_field0_qs)
  );

  //   F[field1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_rwtype1_field1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype1_we),
    .wd     (rwtype1_field1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field1.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype1_field1_qs)
  );

  //   F[field4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1)
  ) u_rwtype1_field4 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype1_we),
    .wd     (rwtype1_field4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field4.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype1_field4_qs)
  );

  //   F[field15_8]: 15:8
  prim_subreg #(
    .DW      (8),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (8'h64)
  ) u_rwtype1_field15_8 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype1_we),
    .wd     (rwtype1_field15_8_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field15_8.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype1_field15_8_qs)
  );


  // R[rwtype2]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h4000400)
  ) u_rwtype2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype2_we),
    .wd     (rwtype2_wd),

    // from internal hardware
    .de     (hw2reg.rwtype2.de),
    .d      (hw2reg.rwtype2.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype2.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype2_qs)
  );


  // R[rwtype3]: V(False)
  //   F[field0]: 15:0
  prim_subreg #(
    .DW      (16),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (16'hcc55)
  ) u_rwtype3_field0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype3_we),
    .wd     (rwtype3_field0_wd),

    // from internal hardware
    .de     (hw2reg.rwtype3.field0.de),
    .d      (hw2reg.rwtype3.field0.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype3.field0.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype3_field0_qs)
  );

  //   F[field1]: 31:16
  prim_subreg #(
    .DW      (16),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (16'hee66)
  ) u_rwtype3_field1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype3_we),
    .wd     (rwtype3_field1_wd),

    // from internal hardware
    .de     (hw2reg.rwtype3.field1.de),
    .d      (hw2reg.rwtype3.field1.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype3.field1.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype3_field1_qs)
  );


  // R[rwtype4]: V(False)
  //   F[field0]: 15:0
  prim_subreg #(
    .DW      (16),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (16'h4000)
  ) u_rwtype4_field0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype4_we),
    .wd     (rwtype4_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype4.field0.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype4_field0_qs)
  );

  //   F[field1]: 31:16
  prim_subreg #(
    .DW      (16),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (16'h8000)
  ) u_rwtype4_field1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype4_we),
    .wd     (rwtype4_field1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype4.field1.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype4_field1_qs)
  );


  // R[rotype0]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (32'h11111111)
  ) u_rotype0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.rotype0.de),
    .d      (hw2reg.rotype0.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rotype0.q),
    .ds     (),

    // to register interface (read)
    .qs     (rotype0_qs)
  );


  // R[w1ctype0]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (32'hbbccddee)
  ) u_w1ctype0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (w1ctype0_we),
    .wd     (w1ctype0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1ctype0.q),
    .ds     (),

    // to register interface (read)
    .qs     (w1ctype0_qs)
  );


  // R[w1ctype1]: V(False)
  //   F[field0]: 15:0
  prim_subreg #(
    .DW      (16),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (16'heeee)
  ) u_w1ctype1_field0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (w1ctype1_we),
    .wd     (w1ctype1_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1ctype1.field0.q),
    .ds     (),

    // to register interface (read)
    .qs     (w1ctype1_field0_qs)
  );

  //   F[field1]: 31:16
  prim_subreg #(
    .DW      (16),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (16'h7777)
  ) u_w1ctype1_field1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (w1ctype1_we),
    .wd     (w1ctype1_field1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1ctype1.field1.q),
    .ds     (),

    // to register interface (read)
    .qs     (w1ctype1_field1_qs)
  );


  // R[w1ctype2]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (32'haa775566)
  ) u_w1ctype2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (w1ctype2_we),
    .wd     (w1ctype2_wd),

    // from internal hardware
    .de     (hw2reg.w1ctype2.de),
    .d      (hw2reg.w1ctype2.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1ctype2.q),
    .ds     (),

    // to register interface (read)
    .qs     (w1ctype2_qs)
  );


  // R[w1stype2]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessW1S),
    .RESVAL  (32'h11224488)
  ) u_w1stype2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (w1stype2_we),
    .wd     (w1stype2_wd),

    // from internal hardware
    .de     (hw2reg.w1stype2.de),
    .d      (hw2reg.w1stype2.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1stype2.q),
    .ds     (),

    // to register interface (read)
    .qs     (w1stype2_qs)
  );


  // R[w0ctype2]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (32'hfec8137f)
  ) u_w0ctype2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (w0ctype2_we),
    .wd     (w0ctype2_wd),

    // from internal hardware
    .de     (hw2reg.w0ctype2.de),
    .d      (hw2reg.w0ctype2.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w0ctype2.q),
    .ds     (),

    // to register interface (read)
    .qs     (w0ctype2_qs)
  );


  // R[r0w1ctype2]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (32'haa775566)
  ) u_r0w1ctype2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (r0w1ctype2_we),
    .wd     (r0w1ctype2_wd),

    // from internal hardware
    .de     (hw2reg.r0w1ctype2.de),
    .d      (hw2reg.r0w1ctype2.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.r0w1ctype2.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );


  // R[rctype0]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRC),
    .RESVAL  (32'h77443399)
  ) u_rctype0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rctype0_re),
    .wd     (rctype0_wd),

    // from internal hardware
    .de     (hw2reg.rctype0.de),
    .d      (hw2reg.rctype0.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rctype0.q),
    .ds     (),

    // to register interface (read)
    .qs     (rctype0_qs)
  );


  // R[wotype0]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (32'h11223344)
  ) u_wotype0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wotype0_we),
    .wd     (wotype0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wotype0.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );


  // R[mixtype0]: V(False)
  //   F[field0]: 3:0
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h1)
  ) u_mixtype0_field0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (mixtype0_we),
    .wd     (mixtype0_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field0.q),
    .ds     (),

    // to register interface (read)
    .qs     (mixtype0_field0_qs)
  );

  //   F[field1]: 7:4
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h2)
  ) u_mixtype0_field1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (mixtype0_we),
    .wd     (mixtype0_field1_wd),

    // from internal hardware
    .de     (hw2reg.mixtype0.field1.de),
    .d      (hw2reg.mixtype0.field1.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field1.q),
    .ds     (),

    // to register interface (read)
    .qs     (mixtype0_field1_qs)
  );

  //   F[field2]: 11:8
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (4'h3)
  ) u_mixtype0_field2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field2.q),
    .ds     (),

    // to register interface (read)
    .qs     (mixtype0_field2_qs)
  );

  //   F[field3]: 15:12
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (4'h4)
  ) u_mixtype0_field3 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.mixtype0.field3.de),
    .d      (hw2reg.mixtype0.field3.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field3.q),
    .ds     (),

    // to register interface (read)
    .qs     (mixtype0_field3_qs)
  );

  //   F[field4]: 19:16
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (4'h5)
  ) u_mixtype0_field4 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (mixtype0_we),
    .wd     (mixtype0_field4_wd),

    // from internal hardware
    .de     (hw2reg.mixtype0.field4.de),
    .d      (hw2reg.mixtype0.field4.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field4.q),
    .ds     (),

    // to register interface (read)
    .qs     (mixtype0_field4_qs)
  );

  //   F[field5]: 23:20
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessW1S),
    .RESVAL  (4'h6)
  ) u_mixtype0_field5 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (mixtype0_we),
    .wd     (mixtype0_field5_wd),

    // from internal hardware
    .de     (hw2reg.mixtype0.field5.de),
    .d      (hw2reg.mixtype0.field5.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field5.q),
    .ds     (),

    // to register interface (read)
    .qs     (mixtype0_field5_qs)
  );

  //   F[field6]: 27:24
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h7)
  ) u_mixtype0_field6 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (mixtype0_we),
    .wd     (mixtype0_field6_wd),

    // from internal hardware
    .de     (hw2reg.mixtype0.field6.de),
    .d      (hw2reg.mixtype0.field6.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field6.q),
    .ds     (),

    // to register interface (read)
    .qs     (mixtype0_field6_qs)
  );

  //   F[field7]: 31:28
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (4'h8)
  ) u_mixtype0_field7 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (mixtype0_we),
    .wd     (mixtype0_field7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field7.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );


  // R[rwtype5]: V(False)
  logic rwtype5_qe;
  logic [0:0] rwtype5_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_rwtype50_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&rwtype5_flds_we),
    .q_o(rwtype5_qe)
  );
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'hbabababa)
  ) u_rwtype5 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype5_we),
    .wd     (rwtype5_wd),

    // from internal hardware
    .de     (hw2reg.rwtype5.de),
    .d      (hw2reg.rwtype5.d),

    // to internal hardware
    .qe     (rwtype5_flds_we[0]),
    .q      (reg2hw.rwtype5.q),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype5_qs)
  );
  assign reg2hw.rwtype5.qe = rwtype5_qe;


  // R[rwtype6]: V(True)
  logic rwtype6_qe;
  logic [0:0] rwtype6_flds_we;
  assign rwtype6_qe = &rwtype6_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_rwtype6 (
    .re     (rwtype6_re),
    .we     (rwtype6_we),
    .wd     (rwtype6_wd),
    .d      (hw2reg.rwtype6.d),
    .qre    (),
    .qe     (rwtype6_flds_we[0]),
    .q      (reg2hw.rwtype6.q),
    .ds     (),
    .qs     (rwtype6_qs)
  );
  assign reg2hw.rwtype6.qe = rwtype6_qe;


  // R[rotype1]: V(True)
  prim_subreg_ext #(
    .DW    (32)
  ) u_rotype1 (
    .re     (rotype1_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.rotype1.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.rotype1.q),
    .ds     (),
    .qs     (rotype1_qs)
  );


  // R[rotype2]: V(False)
  //   F[field0]: 7:0
  // constant-only read
  assign rotype2_field0_qs = 8'h79;

  //   F[field1]: 15:8
  // constant-only read
  assign rotype2_field1_qs = 8'h8a;

  //   F[field2]: 31:20
  // constant-only read
  assign rotype2_field2_qs = 12'h9b9;


  // R[rwtype7]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'hf6f6f6f6)
  ) u_rwtype7 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (rwtype7_we),
    .wd     (rwtype7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (rwtype7_qs)
  );



  logic [19:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == TRIAL1_RWTYPE0_OFFSET);
    addr_hit[ 1] = (reg_addr == TRIAL1_RWTYPE1_OFFSET);
    addr_hit[ 2] = (reg_addr == TRIAL1_RWTYPE2_OFFSET);
    addr_hit[ 3] = (reg_addr == TRIAL1_RWTYPE3_OFFSET);
    addr_hit[ 4] = (reg_addr == TRIAL1_RWTYPE4_OFFSET);
    addr_hit[ 5] = (reg_addr == TRIAL1_ROTYPE0_OFFSET);
    addr_hit[ 6] = (reg_addr == TRIAL1_W1CTYPE0_OFFSET);
    addr_hit[ 7] = (reg_addr == TRIAL1_W1CTYPE1_OFFSET);
    addr_hit[ 8] = (reg_addr == TRIAL1_W1CTYPE2_OFFSET);
    addr_hit[ 9] = (reg_addr == TRIAL1_W1STYPE2_OFFSET);
    addr_hit[10] = (reg_addr == TRIAL1_W0CTYPE2_OFFSET);
    addr_hit[11] = (reg_addr == TRIAL1_R0W1CTYPE2_OFFSET);
    addr_hit[12] = (reg_addr == TRIAL1_RCTYPE0_OFFSET);
    addr_hit[13] = (reg_addr == TRIAL1_WOTYPE0_OFFSET);
    addr_hit[14] = (reg_addr == TRIAL1_MIXTYPE0_OFFSET);
    addr_hit[15] = (reg_addr == TRIAL1_RWTYPE5_OFFSET);
    addr_hit[16] = (reg_addr == TRIAL1_RWTYPE6_OFFSET);
    addr_hit[17] = (reg_addr == TRIAL1_ROTYPE1_OFFSET);
    addr_hit[18] = (reg_addr == TRIAL1_ROTYPE2_OFFSET);
    addr_hit[19] = (reg_addr == TRIAL1_RWTYPE7_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(TRIAL1_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(TRIAL1_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(TRIAL1_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(TRIAL1_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(TRIAL1_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(TRIAL1_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(TRIAL1_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(TRIAL1_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(TRIAL1_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(TRIAL1_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(TRIAL1_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(TRIAL1_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(TRIAL1_PERMIT[12] & ~reg_be))) |
               (addr_hit[13] & (|(TRIAL1_PERMIT[13] & ~reg_be))) |
               (addr_hit[14] & (|(TRIAL1_PERMIT[14] & ~reg_be))) |
               (addr_hit[15] & (|(TRIAL1_PERMIT[15] & ~reg_be))) |
               (addr_hit[16] & (|(TRIAL1_PERMIT[16] & ~reg_be))) |
               (addr_hit[17] & (|(TRIAL1_PERMIT[17] & ~reg_be))) |
               (addr_hit[18] & (|(TRIAL1_PERMIT[18] & ~reg_be))) |
               (addr_hit[19] & (|(TRIAL1_PERMIT[19] & ~reg_be)))));
  end

  // Generate write-enables
  assign rwtype0_we = addr_hit[0] & reg_we & !reg_error;

  assign rwtype0_wd = reg_wdata[31:0];
  assign rwtype1_we = addr_hit[1] & reg_we & !reg_error;

  assign rwtype1_field0_wd = reg_wdata[0];

  assign rwtype1_field1_wd = reg_wdata[1];

  assign rwtype1_field4_wd = reg_wdata[4];

  assign rwtype1_field15_8_wd = reg_wdata[15:8];
  assign rwtype2_we = addr_hit[2] & reg_we & !reg_error;

  assign rwtype2_wd = reg_wdata[31:0];
  assign rwtype3_we = addr_hit[3] & reg_we & !reg_error;

  assign rwtype3_field0_wd = reg_wdata[15:0];

  assign rwtype3_field1_wd = reg_wdata[31:16];
  assign rwtype4_we = addr_hit[4] & reg_we & !reg_error;

  assign rwtype4_field0_wd = reg_wdata[15:0];

  assign rwtype4_field1_wd = reg_wdata[31:16];
  assign w1ctype0_we = addr_hit[6] & reg_we & !reg_error;

  assign w1ctype0_wd = reg_wdata[31:0];
  assign w1ctype1_we = addr_hit[7] & reg_we & !reg_error;

  assign w1ctype1_field0_wd = reg_wdata[15:0];

  assign w1ctype1_field1_wd = reg_wdata[31:16];
  assign w1ctype2_we = addr_hit[8] & reg_we & !reg_error;

  assign w1ctype2_wd = reg_wdata[31:0];
  assign w1stype2_we = addr_hit[9] & reg_we & !reg_error;

  assign w1stype2_wd = reg_wdata[31:0];
  assign w0ctype2_we = addr_hit[10] & reg_we & !reg_error;

  assign w0ctype2_wd = reg_wdata[31:0];
  assign r0w1ctype2_we = addr_hit[11] & reg_we & !reg_error;

  assign r0w1ctype2_wd = reg_wdata[31:0];
  assign rctype0_re = addr_hit[12] & reg_re & !reg_error;

  assign rctype0_wd = '1;
  assign wotype0_we = addr_hit[13] & reg_we & !reg_error;

  assign wotype0_wd = reg_wdata[31:0];
  assign mixtype0_we = addr_hit[14] & reg_we & !reg_error;

  assign mixtype0_field0_wd = reg_wdata[3:0];

  assign mixtype0_field1_wd = reg_wdata[7:4];

  assign mixtype0_field4_wd = reg_wdata[19:16];

  assign mixtype0_field5_wd = reg_wdata[23:20];

  assign mixtype0_field6_wd = reg_wdata[27:24];

  assign mixtype0_field7_wd = reg_wdata[31:28];
  assign rwtype5_we = addr_hit[15] & reg_we & !reg_error;

  assign rwtype5_wd = reg_wdata[31:0];
  assign rwtype6_re = addr_hit[16] & reg_re & !reg_error;
  assign rwtype6_we = addr_hit[16] & reg_we & !reg_error;

  assign rwtype6_wd = reg_wdata[31:0];
  assign rotype1_re = addr_hit[17] & reg_re & !reg_error;
  assign rwtype7_we = addr_hit[19] & reg_we & !reg_error;

  assign rwtype7_wd = reg_wdata[31:0];

  // Assign write-enables to checker logic vector.
  always_comb begin
    reg_we_check = '0;
    reg_we_check[0] = rwtype0_we;
    reg_we_check[1] = rwtype1_we;
    reg_we_check[2] = rwtype2_we;
    reg_we_check[3] = rwtype3_we;
    reg_we_check[4] = rwtype4_we;
    reg_we_check[5] = 1'b0;
    reg_we_check[6] = w1ctype0_we;
    reg_we_check[7] = w1ctype1_we;
    reg_we_check[8] = w1ctype2_we;
    reg_we_check[9] = w1stype2_we;
    reg_we_check[10] = w0ctype2_we;
    reg_we_check[11] = r0w1ctype2_we;
    reg_we_check[12] = 1'b0;
    reg_we_check[13] = wotype0_we;
    reg_we_check[14] = mixtype0_we;
    reg_we_check[15] = rwtype5_we;
    reg_we_check[16] = rwtype6_we;
    reg_we_check[17] = 1'b0;
    reg_we_check[18] = 1'b0;
    reg_we_check[19] = rwtype7_we;
  end

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[31:0] = rwtype0_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = rwtype1_field0_qs;
        reg_rdata_next[1] = rwtype1_field1_qs;
        reg_rdata_next[4] = rwtype1_field4_qs;
        reg_rdata_next[15:8] = rwtype1_field15_8_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[31:0] = rwtype2_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[15:0] = rwtype3_field0_qs;
        reg_rdata_next[31:16] = rwtype3_field1_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[15:0] = rwtype4_field0_qs;
        reg_rdata_next[31:16] = rwtype4_field1_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[31:0] = rotype0_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = w1ctype0_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[15:0] = w1ctype1_field0_qs;
        reg_rdata_next[31:16] = w1ctype1_field1_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = w1ctype2_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = w1stype2_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = w0ctype2_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[12]: begin
        reg_rdata_next[31:0] = rctype0_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[14]: begin
        reg_rdata_next[3:0] = mixtype0_field0_qs;
        reg_rdata_next[7:4] = mixtype0_field1_qs;
        reg_rdata_next[11:8] = mixtype0_field2_qs;
        reg_rdata_next[15:12] = mixtype0_field3_qs;
        reg_rdata_next[19:16] = mixtype0_field4_qs;
        reg_rdata_next[23:20] = mixtype0_field5_qs;
        reg_rdata_next[27:24] = mixtype0_field6_qs;
        reg_rdata_next[31:28] = '0;
      end

      addr_hit[15]: begin
        reg_rdata_next[31:0] = rwtype5_qs;
      end

      addr_hit[16]: begin
        reg_rdata_next[31:0] = rwtype6_qs;
      end

      addr_hit[17]: begin
        reg_rdata_next[31:0] = rotype1_qs;
      end

      addr_hit[18]: begin
        reg_rdata_next[7:0] = rotype2_field0_qs;
        reg_rdata_next[15:8] = rotype2_field1_qs;
        reg_rdata_next[31:20] = rotype2_field2_qs;
      end

      addr_hit[19]: begin
        reg_rdata_next[31:0] = rwtype7_qs;
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
  assign reg_busy = shadow_busy;

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
