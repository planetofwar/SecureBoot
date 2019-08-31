// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`


module trial1_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output trial1_reg_pkg::trial1_reg2hw_t reg2hw, // Write
  input  trial1_reg_pkg::trial1_hw2reg_t hw2reg  // Read
);

  import trial1_reg_pkg::* ;

  localparam AW = 10;
  localparam IW = $bits(tl_i.a_source);
  localparam DW = 32;
  localparam DBW = DW/8;                    // Byte Width
  localparam logic [$clog2($clog2(DBW)+1)-1:0] FSZ = $clog2(DBW); // Full Size 2^(FSZ) = DBW;

  // register signals
  logic          reg_we;
  logic          reg_re;
  logic [AW-1:0] reg_addr;
  logic [DW-1:0] reg_wdata;
  logic          reg_valid;
  logic [DW-1:0] reg_rdata;
  logic          tl_malformed, tl_addrmiss;

  // Bus signals
  tlul_pkg::tl_d_op_e rsp_opcode; // AccessAck or AccessAckData
  logic          reqready;
  logic [IW-1:0] reqid;
  logic [IW-1:0] rspid;

  logic          outstanding;

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;

  assign tl_reg_h2d = tl_i;
  assign tl_o       = tl_reg_d2h;

  // TODO(eunchan): Fix it after bus interface is finalized
  assign reg_we = tl_reg_h2d.a_valid && tl_reg_d2h.a_ready &&
                  ((tl_reg_h2d.a_opcode == tlul_pkg::PutFullData) ||
                   (tl_reg_h2d.a_opcode == tlul_pkg::PutPartialData));
  assign reg_re = tl_reg_h2d.a_valid && tl_reg_d2h.a_ready &&
                  (tl_reg_h2d.a_opcode == tlul_pkg::Get);
  assign reg_addr = tl_reg_h2d.a_address[AW-1:0];
  assign reg_wdata = tl_reg_h2d.a_data;

  assign tl_reg_d2h.d_valid  = reg_valid;
  assign tl_reg_d2h.d_opcode = rsp_opcode;
  assign tl_reg_d2h.d_param  = '0;
  assign tl_reg_d2h.d_size   = FSZ;         // always Full Size
  assign tl_reg_d2h.d_source = rspid;
  assign tl_reg_d2h.d_sink   = '0;          // Used in TL-C
  assign tl_reg_d2h.d_data   = reg_rdata;
  assign tl_reg_d2h.d_user   = '0;          // Doesn't allow additional features yet
  assign tl_reg_d2h.d_error  = tl_malformed | tl_addrmiss;

  assign tl_reg_d2h.a_ready  = reqready;

  assign reqid     = tl_reg_h2d.a_source;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      tl_malformed <= 1'b1;
    end else if (tl_reg_h2d.a_valid && tl_reg_d2h.a_ready) begin
      if ((tl_reg_h2d.a_opcode != tlul_pkg::Get) &&
          (tl_reg_h2d.a_opcode != tlul_pkg::PutFullData) &&
          (tl_reg_h2d.a_opcode != tlul_pkg::PutPartialData)) begin
        tl_malformed <= 1'b1;
      // Only allow Full Write with full mask
      end else if (tl_reg_h2d.a_size != FSZ || tl_reg_h2d.a_mask != {DBW{1'b1}}) begin
        tl_malformed <= 1'b1;
      end else if (tl_reg_h2d.a_user.parity_en == 1'b1) begin
        tl_malformed <= 1'b1;
      end else begin
        tl_malformed <= 1'b0;
      end
    end
  end
  // TODO(eunchan): Revise Register Interface logic after REG INTF finalized
  // TODO(eunchan): Make concrete scenario
  //    1. Write: No response, so that it can guarantee a request completes a clock after we
  //              It means, bus_reg_ready doesn't have to be lowered.
  //    2. Read: response. So bus_reg_ready should assert after reg_bus_valid & reg_bus_ready
  //               _____         _____
  // a_valid _____/     \_______/     \______
  //         ___________         _____
  // a_ready            \_______/     \______ <- ERR though no logic malfunction
  //                     _____________
  // d_valid ___________/             \______
  //                             _____
  // d_ready ___________________/     \______
  //
  // Above example is fine but if r.b.r doesn't assert within two cycle, then it can be wrong.
  always_ff @(posedge clk_i or negedge rst_ni) begin
    // Not to accept new request when a request is handling
    //   #Outstanding := 1
    if (!rst_ni) begin
      reqready <= 1'b0;
    end else if (reg_we || reg_re) begin
      reqready <= 1'b0;
    end else if (outstanding == 1'b0) begin
      reqready <= 1'b1;
    end
  end

  // Request/ Response ID
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rspid <= '0;
    end else if (reg_we || reg_re) begin
      rspid <= reqid;
    end
  end

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic [31:0] rwtype0_qs;
  logic [31:0] rwtype0_wd;
  logic rwtype0_we;
  logic rwtype1_field0_qs;
  logic rwtype1_field0_wd;
  logic rwtype1_field0_we;
  logic rwtype1_field1_qs;
  logic rwtype1_field1_wd;
  logic rwtype1_field1_we;
  logic rwtype1_field4_qs;
  logic rwtype1_field4_wd;
  logic rwtype1_field4_we;
  logic [7:0] rwtype1_field15_8_qs;
  logic [7:0] rwtype1_field15_8_wd;
  logic rwtype1_field15_8_we;
  logic [31:0] rwtype2_qs;
  logic [31:0] rwtype2_wd;
  logic rwtype2_we;
  logic [15:0] rwtype3_field0_qs;
  logic [15:0] rwtype3_field0_wd;
  logic rwtype3_field0_we;
  logic [15:0] rwtype3_field1_qs;
  logic [15:0] rwtype3_field1_wd;
  logic rwtype3_field1_we;
  logic [15:0] rwtype4_field0_qs;
  logic [15:0] rwtype4_field0_wd;
  logic rwtype4_field0_we;
  logic [15:0] rwtype4_field1_qs;
  logic [15:0] rwtype4_field1_wd;
  logic rwtype4_field1_we;
  logic [31:0] rotype0_qs;
  logic [31:0] w1ctype0_qs;
  logic [31:0] w1ctype0_wd;
  logic w1ctype0_we;
  logic [15:0] w1ctype1_field0_qs;
  logic [15:0] w1ctype1_field0_wd;
  logic w1ctype1_field0_we;
  logic [15:0] w1ctype1_field1_qs;
  logic [15:0] w1ctype1_field1_wd;
  logic w1ctype1_field1_we;
  logic [31:0] w1ctype2_qs;
  logic [31:0] w1ctype2_wd;
  logic w1ctype2_we;
  logic [31:0] w1stype2_qs;
  logic [31:0] w1stype2_wd;
  logic w1stype2_we;
  logic [31:0] w0ctype2_qs;
  logic [31:0] w0ctype2_wd;
  logic w0ctype2_we;
  logic [31:0] r0w1ctype2_wd;
  logic r0w1ctype2_we;
  logic [31:0] rctype0_qs;
  logic [31:0] rctype0_wd;
  logic rctype0_we;
  logic [31:0] wotype0_wd;
  logic wotype0_we;
  logic [3:0] mixtype0_field0_qs;
  logic [3:0] mixtype0_field0_wd;
  logic mixtype0_field0_we;
  logic [3:0] mixtype0_field1_qs;
  logic [3:0] mixtype0_field1_wd;
  logic mixtype0_field1_we;
  logic [3:0] mixtype0_field2_qs;
  logic [3:0] mixtype0_field3_qs;
  logic [3:0] mixtype0_field4_qs;
  logic [3:0] mixtype0_field4_wd;
  logic mixtype0_field4_we;
  logic [3:0] mixtype0_field5_qs;
  logic [3:0] mixtype0_field5_wd;
  logic mixtype0_field5_we;
  logic [3:0] mixtype0_field6_qs;
  logic [3:0] mixtype0_field6_wd;
  logic mixtype0_field6_we;
  logic [3:0] mixtype0_field7_wd;
  logic mixtype0_field7_we;
  logic [31:0] rwtype5_qs;
  logic [31:0] rwtype5_wd;
  logic rwtype5_we;
  logic [31:0] rwtype6_qs;
  logic [31:0] rwtype6_wd;
  logic rwtype6_we;
  logic rwtype6_re;
  logic [31:0] rotype1_qs;
  logic rotype1_re;
  logic [7:0] rotype2_field0_qs;
  logic [7:0] rotype2_field1_qs;
  logic [11:0] rotype2_field2_qs;
  logic [31:0] rwtype7_qs;
  logic [31:0] rwtype7_wd;
  logic rwtype7_we;

  // Register instances
  // R[rwtype0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'hbc614e)
  ) u_rwtype0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype0_we),
    .wd     (rwtype0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype0.q ),

    // to register interface (read)
    .qs     (rwtype0_qs)
  );


  // R[rwtype1]: V(False)

  //   F[field0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h1)
  ) u_rwtype1_field0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype1_field0_we),
    .wd     (rwtype1_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field0.q ),

    // to register interface (read)
    .qs     (rwtype1_field0_qs)
  );


  //   F[field1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_rwtype1_field1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype1_field1_we),
    .wd     (rwtype1_field1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field1.q ),

    // to register interface (read)
    .qs     (rwtype1_field1_qs)
  );


  //   F[field4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h1)
  ) u_rwtype1_field4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype1_field4_we),
    .wd     (rwtype1_field4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field4.q ),

    // to register interface (read)
    .qs     (rwtype1_field4_qs)
  );


  //   F[field15_8]: 15:8
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RW"),
    .RESVAL  (8'h64)
  ) u_rwtype1_field15_8 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype1_field15_8_we),
    .wd     (rwtype1_field15_8_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field15_8.q ),

    // to register interface (read)
    .qs     (rwtype1_field15_8_qs)
  );


  // R[rwtype2]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h4000400)
  ) u_rwtype2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype2_we),
    .wd     (rwtype2_wd),

    // from internal hardware
    .de     (hw2reg.rwtype2.de),
    .d      (hw2reg.rwtype2.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype2.q ),

    // to register interface (read)
    .qs     (rwtype2_qs)
  );


  // R[rwtype3]: V(False)

  //   F[field0]: 15:0
  prim_subreg #(
    .DW      (16),
    .SWACCESS("RW"),
    .RESVAL  (16'hcc55)
  ) u_rwtype3_field0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype3_field0_we),
    .wd     (rwtype3_field0_wd),

    // from internal hardware
    .de     (hw2reg.rwtype3.field0.de),
    .d      (hw2reg.rwtype3.field0.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype3.field0.q ),

    // to register interface (read)
    .qs     (rwtype3_field0_qs)
  );


  //   F[field1]: 31:16
  prim_subreg #(
    .DW      (16),
    .SWACCESS("RW"),
    .RESVAL  (16'hee66)
  ) u_rwtype3_field1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype3_field1_we),
    .wd     (rwtype3_field1_wd),

    // from internal hardware
    .de     (hw2reg.rwtype3.field1.de),
    .d      (hw2reg.rwtype3.field1.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype3.field1.q ),

    // to register interface (read)
    .qs     (rwtype3_field1_qs)
  );


  // R[rwtype4]: V(False)

  //   F[field0]: 15:0
  prim_subreg #(
    .DW      (16),
    .SWACCESS("RW"),
    .RESVAL  (16'h4000)
  ) u_rwtype4_field0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype4_field0_we),
    .wd     (rwtype4_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype4.field0.q ),

    // to register interface (read)
    .qs     (rwtype4_field0_qs)
  );


  //   F[field1]: 31:16
  prim_subreg #(
    .DW      (16),
    .SWACCESS("RW"),
    .RESVAL  (16'h8000)
  ) u_rwtype4_field1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype4_field1_we),
    .wd     (rwtype4_field1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype4.field1.q ),

    // to register interface (read)
    .qs     (rwtype4_field1_qs)
  );


  // R[rotype0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RO"),
    .RESVAL  (32'h11111111)
  ) u_rotype0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.rotype0.de),
    .d      (hw2reg.rotype0.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rotype0.q ),

    // to register interface (read)
    .qs     (rotype0_qs)
  );


  // R[w1ctype0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("W1C"),
    .RESVAL  (32'hbbccddee)
  ) u_w1ctype0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (w1ctype0_we),
    .wd     (w1ctype0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1ctype0.q ),

    // to register interface (read)
    .qs     (w1ctype0_qs)
  );


  // R[w1ctype1]: V(False)

  //   F[field0]: 15:0
  prim_subreg #(
    .DW      (16),
    .SWACCESS("W1C"),
    .RESVAL  (16'heeee)
  ) u_w1ctype1_field0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (w1ctype1_field0_we),
    .wd     (w1ctype1_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1ctype1.field0.q ),

    // to register interface (read)
    .qs     (w1ctype1_field0_qs)
  );


  //   F[field1]: 31:16
  prim_subreg #(
    .DW      (16),
    .SWACCESS("W1C"),
    .RESVAL  (16'h7777)
  ) u_w1ctype1_field1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (w1ctype1_field1_we),
    .wd     (w1ctype1_field1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1ctype1.field1.q ),

    // to register interface (read)
    .qs     (w1ctype1_field1_qs)
  );


  // R[w1ctype2]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("W1C"),
    .RESVAL  (32'haa775566)
  ) u_w1ctype2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (w1ctype2_we),
    .wd     (w1ctype2_wd),

    // from internal hardware
    .de     (hw2reg.w1ctype2.de),
    .d      (hw2reg.w1ctype2.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1ctype2.q ),

    // to register interface (read)
    .qs     (w1ctype2_qs)
  );


  // R[w1stype2]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("W1S"),
    .RESVAL  (32'h11224488)
  ) u_w1stype2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (w1stype2_we),
    .wd     (w1stype2_wd),

    // from internal hardware
    .de     (hw2reg.w1stype2.de),
    .d      (hw2reg.w1stype2.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w1stype2.q ),

    // to register interface (read)
    .qs     (w1stype2_qs)
  );


  // R[w0ctype2]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("W0C"),
    .RESVAL  (32'hfec8137f)
  ) u_w0ctype2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (w0ctype2_we),
    .wd     (w0ctype2_wd),

    // from internal hardware
    .de     (hw2reg.w0ctype2.de),
    .d      (hw2reg.w0ctype2.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.w0ctype2.q ),

    // to register interface (read)
    .qs     (w0ctype2_qs)
  );


  // R[r0w1ctype2]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("W1C"),
    .RESVAL  (32'haa775566)
  ) u_r0w1ctype2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (r0w1ctype2_we),
    .wd     (r0w1ctype2_wd),

    // from internal hardware
    .de     (hw2reg.r0w1ctype2.de),
    .d      (hw2reg.r0w1ctype2.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.r0w1ctype2.q ),

    .qs     ()
  );


  // R[rctype0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RC"),
    .RESVAL  (32'h77443399)
  ) u_rctype0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rctype0_we),
    .wd     (rctype0_wd),

    // from internal hardware
    .de     (hw2reg.rctype0.de),
    .d      (hw2reg.rctype0.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rctype0.q ),

    // to register interface (read)
    .qs     (rctype0_qs)
  );


  // R[wotype0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h11223344)
  ) u_wotype0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wotype0_we),
    .wd     (wotype0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wotype0.q ),

    .qs     ()
  );


  // R[mixtype0]: V(False)

  //   F[field0]: 3:0
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h1)
  ) u_mixtype0_field0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (mixtype0_field0_we),
    .wd     (mixtype0_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field0.q ),

    // to register interface (read)
    .qs     (mixtype0_field0_qs)
  );


  //   F[field1]: 7:4
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h2)
  ) u_mixtype0_field1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (mixtype0_field1_we),
    .wd     (mixtype0_field1_wd),

    // from internal hardware
    .de     (hw2reg.mixtype0.field1.de),
    .d      (hw2reg.mixtype0.field1.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field1.q ),

    // to register interface (read)
    .qs     (mixtype0_field1_qs)
  );


  //   F[field2]: 11:8
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RO"),
    .RESVAL  (4'h3)
  ) u_mixtype0_field2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field2.q ),

    // to register interface (read)
    .qs     (mixtype0_field2_qs)
  );


  //   F[field3]: 15:12
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RO"),
    .RESVAL  (4'h4)
  ) u_mixtype0_field3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.mixtype0.field3.de),
    .d      (hw2reg.mixtype0.field3.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field3.q ),

    // to register interface (read)
    .qs     (mixtype0_field3_qs)
  );


  //   F[field4]: 19:16
  prim_subreg #(
    .DW      (4),
    .SWACCESS("W1C"),
    .RESVAL  (4'h5)
  ) u_mixtype0_field4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (mixtype0_field4_we),
    .wd     (mixtype0_field4_wd),

    // from internal hardware
    .de     (hw2reg.mixtype0.field4.de),
    .d      (hw2reg.mixtype0.field4.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field4.q ),

    // to register interface (read)
    .qs     (mixtype0_field4_qs)
  );


  //   F[field5]: 23:20
  prim_subreg #(
    .DW      (4),
    .SWACCESS("W1S"),
    .RESVAL  (4'h6)
  ) u_mixtype0_field5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (mixtype0_field5_we),
    .wd     (mixtype0_field5_wd),

    // from internal hardware
    .de     (hw2reg.mixtype0.field5.de),
    .d      (hw2reg.mixtype0.field5.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field5.q ),

    // to register interface (read)
    .qs     (mixtype0_field5_qs)
  );


  //   F[field6]: 27:24
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RC"),
    .RESVAL  (4'h7)
  ) u_mixtype0_field6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (mixtype0_field6_we),
    .wd     (mixtype0_field6_wd),

    // from internal hardware
    .de     (hw2reg.mixtype0.field6.de),
    .d      (hw2reg.mixtype0.field6.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field6.q ),

    // to register interface (read)
    .qs     (mixtype0_field6_qs)
  );


  //   F[field7]: 31:28
  prim_subreg #(
    .DW      (4),
    .SWACCESS("WO"),
    .RESVAL  (4'h8)
  ) u_mixtype0_field7 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (mixtype0_field7_we),
    .wd     (mixtype0_field7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mixtype0.field7.q ),

    .qs     ()
  );


  // R[rwtype5]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'hbabababa)
  ) u_rwtype5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype5_we),
    .wd     (rwtype5_wd),

    // from internal hardware
    .de     (hw2reg.rwtype5.de),
    .d      (hw2reg.rwtype5.d ),

    // to internal hardware
    .qe     (reg2hw.rwtype5.qe),
    .q      (reg2hw.rwtype5.q ),

    // to register interface (read)
    .qs     (rwtype5_qs)
  );


  // R[rwtype6]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_rwtype6 (
    .re     (rwtype6_re),
    .we     (rwtype6_we),
    .wd     (rwtype6_wd),
    .d      (hw2reg.rwtype6.d),
    .qre    (),
    .qe     (reg2hw.rwtype6.qe),
    .q      (reg2hw.rwtype6.q ),
    .qs     (rwtype6_qs)
  );


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
    .q      (reg2hw.rotype1.q ),
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
    .SWACCESS("RW"),
    .RESVAL  (32'hf6f6f6f6)
  ) u_rwtype7 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype7_we),
    .wd     (rwtype7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (rwtype7_qs)
  );



  logic [19:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == TRIAL1_RWTYPE0_OFFSET);
    addr_hit[1] = (reg_addr == TRIAL1_RWTYPE1_OFFSET);
    addr_hit[2] = (reg_addr == TRIAL1_RWTYPE2_OFFSET);
    addr_hit[3] = (reg_addr == TRIAL1_RWTYPE3_OFFSET);
    addr_hit[4] = (reg_addr == TRIAL1_RWTYPE4_OFFSET);
    addr_hit[5] = (reg_addr == TRIAL1_ROTYPE0_OFFSET);
    addr_hit[6] = (reg_addr == TRIAL1_W1CTYPE0_OFFSET);
    addr_hit[7] = (reg_addr == TRIAL1_W1CTYPE1_OFFSET);
    addr_hit[8] = (reg_addr == TRIAL1_W1CTYPE2_OFFSET);
    addr_hit[9] = (reg_addr == TRIAL1_W1STYPE2_OFFSET);
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

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      tl_addrmiss <= 1'b0;
    end else if (reg_re || reg_we) begin
      tl_addrmiss <= ~|addr_hit;
    end
  end

  // Write Enable signal

  assign rwtype0_we = addr_hit[0] && reg_we;
  assign rwtype0_wd = reg_wdata[31:0];

  assign rwtype1_field0_we = addr_hit[1] && reg_we;
  assign rwtype1_field0_wd = reg_wdata[0];

  assign rwtype1_field1_we = addr_hit[1] && reg_we;
  assign rwtype1_field1_wd = reg_wdata[1];

  assign rwtype1_field4_we = addr_hit[1] && reg_we;
  assign rwtype1_field4_wd = reg_wdata[4];

  assign rwtype1_field15_8_we = addr_hit[1] && reg_we;
  assign rwtype1_field15_8_wd = reg_wdata[15:8];

  assign rwtype2_we = addr_hit[2] && reg_we;
  assign rwtype2_wd = reg_wdata[31:0];

  assign rwtype3_field0_we = addr_hit[3] && reg_we;
  assign rwtype3_field0_wd = reg_wdata[15:0];

  assign rwtype3_field1_we = addr_hit[3] && reg_we;
  assign rwtype3_field1_wd = reg_wdata[31:16];

  assign rwtype4_field0_we = addr_hit[4] && reg_we;
  assign rwtype4_field0_wd = reg_wdata[15:0];

  assign rwtype4_field1_we = addr_hit[4] && reg_we;
  assign rwtype4_field1_wd = reg_wdata[31:16];


  assign w1ctype0_we = addr_hit[6] && reg_we;
  assign w1ctype0_wd = reg_wdata[31:0];

  assign w1ctype1_field0_we = addr_hit[7] && reg_we;
  assign w1ctype1_field0_wd = reg_wdata[15:0];

  assign w1ctype1_field1_we = addr_hit[7] && reg_we;
  assign w1ctype1_field1_wd = reg_wdata[31:16];

  assign w1ctype2_we = addr_hit[8] && reg_we;
  assign w1ctype2_wd = reg_wdata[31:0];

  assign w1stype2_we = addr_hit[9] && reg_we;
  assign w1stype2_wd = reg_wdata[31:0];

  assign w0ctype2_we = addr_hit[10] && reg_we;
  assign w0ctype2_wd = reg_wdata[31:0];

  assign r0w1ctype2_we = addr_hit[11] && reg_we;
  assign r0w1ctype2_wd = reg_wdata[31:0];

  assign rctype0_we = addr_hit[12] && reg_re;
  assign rctype0_wd = '1;

  assign wotype0_we = addr_hit[13] && reg_we;
  assign wotype0_wd = reg_wdata[31:0];

  assign mixtype0_field0_we = addr_hit[14] && reg_we;
  assign mixtype0_field0_wd = reg_wdata[3:0];

  assign mixtype0_field1_we = addr_hit[14] && reg_we;
  assign mixtype0_field1_wd = reg_wdata[7:4];



  assign mixtype0_field4_we = addr_hit[14] && reg_we;
  assign mixtype0_field4_wd = reg_wdata[19:16];

  assign mixtype0_field5_we = addr_hit[14] && reg_we;
  assign mixtype0_field5_wd = reg_wdata[23:20];

  assign mixtype0_field6_we = addr_hit[14] && reg_re;
  assign mixtype0_field6_wd = '1;

  assign mixtype0_field7_we = addr_hit[14] && reg_we;
  assign mixtype0_field7_wd = reg_wdata[31:28];

  assign rwtype5_we = addr_hit[15] && reg_we;
  assign rwtype5_wd = reg_wdata[31:0];

  assign rwtype6_we = addr_hit[16] && reg_we;
  assign rwtype6_wd = reg_wdata[31:0];
  assign rwtype6_re = addr_hit[16] && reg_re;

  assign rotype1_re = addr_hit[17] && reg_re;




  assign rwtype7_we = addr_hit[19] && reg_we;
  assign rwtype7_wd = reg_wdata[31:0];

  // Read data return
  logic [DW-1:0] reg_rdata_next;
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

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      reg_valid <= 1'b0;
      reg_rdata <= '0;
      rsp_opcode <= tlul_pkg::AccessAck;
    end else if (reg_re || reg_we) begin
      // Guarantee to return data in a cycle
      reg_valid <= 1'b1;
      if (reg_re) begin
        reg_rdata <= reg_rdata_next;
        rsp_opcode <= tlul_pkg::AccessAckData;
      end else begin
        rsp_opcode <= tlul_pkg::AccessAck;
      end
    end else if (tl_reg_h2d.d_ready) begin
      reg_valid <= 1'b0;
    end
  end

  // Outstanding: 1 outstanding at a time. Identical to `reg_valid`
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      outstanding <= 1'b0;
    end else if (tl_reg_h2d.a_valid && tl_reg_d2h.a_ready) begin
      outstanding <= 1'b1;
    end else if (tl_reg_d2h.d_valid && tl_reg_h2d.d_ready) begin
      outstanding <= 1'b0;
    end
  end

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we, clk_i, !rst_ni)
  `ASSERT_PULSE(rePulse, reg_re, clk_i, !rst_ni)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> reg_valid, clk_i, !rst_ni)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit), clk_i, !rst_ni)

  `ASSERT(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.parity_en == 1'b0, clk_i, !rst_ni)

endmodule
