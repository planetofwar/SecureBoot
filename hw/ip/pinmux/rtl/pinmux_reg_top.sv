// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

module pinmux_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output pinmux_reg_pkg::pinmux_reg2hw_t reg2hw, // Write

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import pinmux_reg_pkg::* ;

  localparam AW = 4;
  localparam DW = 32;
  localparam DBW = DW/8;                    // Byte Width

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

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;

  assign tl_reg_h2d = tl_i;
  assign tl_o       = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW)
  ) u_reg_if (
    .clk_i,
    .rst_ni,

    .tl_i (tl_reg_h2d),
    .tl_o (tl_reg_d2h),

    .we_o    (reg_we),
    .re_o    (reg_re),
    .addr_o  (reg_addr),
    .wdata_o (reg_wdata),
    .be_o    (reg_be),
    .rdata_i (reg_rdata),
    .error_i (reg_error)
  );

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = (devmode_i & addrmiss) | wr_err ;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic regen_qs;
  logic regen_wd;
  logic regen_we;
  logic [2:0] periph_insel_in0_qs;
  logic [2:0] periph_insel_in0_wd;
  logic periph_insel_in0_we;
  logic [2:0] periph_insel_in1_qs;
  logic [2:0] periph_insel_in1_wd;
  logic periph_insel_in1_we;
  logic [2:0] periph_insel_in2_qs;
  logic [2:0] periph_insel_in2_wd;
  logic periph_insel_in2_we;
  logic [2:0] periph_insel_in3_qs;
  logic [2:0] periph_insel_in3_wd;
  logic periph_insel_in3_we;
  logic [2:0] periph_insel_in4_qs;
  logic [2:0] periph_insel_in4_wd;
  logic periph_insel_in4_we;
  logic [2:0] periph_insel_in5_qs;
  logic [2:0] periph_insel_in5_wd;
  logic periph_insel_in5_we;
  logic [2:0] periph_insel_in6_qs;
  logic [2:0] periph_insel_in6_wd;
  logic periph_insel_in6_we;
  logic [2:0] periph_insel_in7_qs;
  logic [2:0] periph_insel_in7_wd;
  logic periph_insel_in7_we;
  logic [3:0] mio_outsel_out0_qs;
  logic [3:0] mio_outsel_out0_wd;
  logic mio_outsel_out0_we;
  logic [3:0] mio_outsel_out1_qs;
  logic [3:0] mio_outsel_out1_wd;
  logic mio_outsel_out1_we;
  logic [3:0] mio_outsel_out2_qs;
  logic [3:0] mio_outsel_out2_wd;
  logic mio_outsel_out2_we;
  logic [3:0] mio_outsel_out3_qs;
  logic [3:0] mio_outsel_out3_wd;
  logic mio_outsel_out3_we;

  // Register instances
  // R[regen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h1)
  ) u_regen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (regen_we),
    .wd     (regen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (regen_qs)
  );



  // Subregister 0 of Multireg periph_insel
  // R[periph_insel]: V(False)

  // F[in0]: 2:0
  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_periph_insel_in0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel_in0_we & regen_qs),
    .wd     (periph_insel_in0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[0].q ),

    // to register interface (read)
    .qs     (periph_insel_in0_qs)
  );


  // F[in1]: 5:3
  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_periph_insel_in1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel_in1_we & regen_qs),
    .wd     (periph_insel_in1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[1].q ),

    // to register interface (read)
    .qs     (periph_insel_in1_qs)
  );


  // F[in2]: 8:6
  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_periph_insel_in2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel_in2_we & regen_qs),
    .wd     (periph_insel_in2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[2].q ),

    // to register interface (read)
    .qs     (periph_insel_in2_qs)
  );


  // F[in3]: 11:9
  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_periph_insel_in3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel_in3_we & regen_qs),
    .wd     (periph_insel_in3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[3].q ),

    // to register interface (read)
    .qs     (periph_insel_in3_qs)
  );


  // F[in4]: 14:12
  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_periph_insel_in4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel_in4_we & regen_qs),
    .wd     (periph_insel_in4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[4].q ),

    // to register interface (read)
    .qs     (periph_insel_in4_qs)
  );


  // F[in5]: 17:15
  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_periph_insel_in5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel_in5_we & regen_qs),
    .wd     (periph_insel_in5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[5].q ),

    // to register interface (read)
    .qs     (periph_insel_in5_qs)
  );


  // F[in6]: 20:18
  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_periph_insel_in6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel_in6_we & regen_qs),
    .wd     (periph_insel_in6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[6].q ),

    // to register interface (read)
    .qs     (periph_insel_in6_qs)
  );


  // F[in7]: 23:21
  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_periph_insel_in7 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel_in7_we & regen_qs),
    .wd     (periph_insel_in7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[7].q ),

    // to register interface (read)
    .qs     (periph_insel_in7_qs)
  );




  // Subregister 0 of Multireg mio_outsel
  // R[mio_outsel]: V(False)

  // F[out0]: 3:0
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_mio_outsel_out0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel_out0_we & regen_qs),
    .wd     (mio_outsel_out0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[0].q ),

    // to register interface (read)
    .qs     (mio_outsel_out0_qs)
  );


  // F[out1]: 7:4
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_mio_outsel_out1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel_out1_we & regen_qs),
    .wd     (mio_outsel_out1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[1].q ),

    // to register interface (read)
    .qs     (mio_outsel_out1_qs)
  );


  // F[out2]: 11:8
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_mio_outsel_out2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel_out2_we & regen_qs),
    .wd     (mio_outsel_out2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[2].q ),

    // to register interface (read)
    .qs     (mio_outsel_out2_qs)
  );


  // F[out3]: 15:12
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_mio_outsel_out3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel_out3_we & regen_qs),
    .wd     (mio_outsel_out3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[3].q ),

    // to register interface (read)
    .qs     (mio_outsel_out3_qs)
  );





  logic [2:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == PINMUX_REGEN_OFFSET);
    addr_hit[1] = (reg_addr == PINMUX_PERIPH_INSEL_OFFSET);
    addr_hit[2] = (reg_addr == PINMUX_MIO_OUTSEL_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (PINMUX_PERMIT[0] != (PINMUX_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (PINMUX_PERMIT[1] != (PINMUX_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[2] && reg_we && (PINMUX_PERMIT[2] != (PINMUX_PERMIT[2] & reg_be))) wr_err = 1'b1 ;
  end

  assign regen_we = addr_hit[0] & reg_we & ~wr_err;
  assign regen_wd = reg_wdata[0];

  assign periph_insel_in0_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel_in0_wd = reg_wdata[2:0];

  assign periph_insel_in1_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel_in1_wd = reg_wdata[5:3];

  assign periph_insel_in2_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel_in2_wd = reg_wdata[8:6];

  assign periph_insel_in3_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel_in3_wd = reg_wdata[11:9];

  assign periph_insel_in4_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel_in4_wd = reg_wdata[14:12];

  assign periph_insel_in5_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel_in5_wd = reg_wdata[17:15];

  assign periph_insel_in6_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel_in6_wd = reg_wdata[20:18];

  assign periph_insel_in7_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel_in7_wd = reg_wdata[23:21];

  assign mio_outsel_out0_we = addr_hit[2] & reg_we & ~wr_err;
  assign mio_outsel_out0_wd = reg_wdata[3:0];

  assign mio_outsel_out1_we = addr_hit[2] & reg_we & ~wr_err;
  assign mio_outsel_out1_wd = reg_wdata[7:4];

  assign mio_outsel_out2_we = addr_hit[2] & reg_we & ~wr_err;
  assign mio_outsel_out2_wd = reg_wdata[11:8];

  assign mio_outsel_out3_we = addr_hit[2] & reg_we & ~wr_err;
  assign mio_outsel_out3_wd = reg_wdata[15:12];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = regen_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[2:0] = periph_insel_in0_qs;
        reg_rdata_next[5:3] = periph_insel_in1_qs;
        reg_rdata_next[8:6] = periph_insel_in2_qs;
        reg_rdata_next[11:9] = periph_insel_in3_qs;
        reg_rdata_next[14:12] = periph_insel_in4_qs;
        reg_rdata_next[17:15] = periph_insel_in5_qs;
        reg_rdata_next[20:18] = periph_insel_in6_qs;
        reg_rdata_next[23:21] = periph_insel_in7_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[3:0] = mio_outsel_out0_qs;
        reg_rdata_next[7:4] = mio_outsel_out1_qs;
        reg_rdata_next[11:8] = mio_outsel_out2_qs;
        reg_rdata_next[15:12] = mio_outsel_out3_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we, clk_i, !rst_ni)
  `ASSERT_PULSE(rePulse, reg_re, clk_i, !rst_ni)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid, clk_i, !rst_ni)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit), clk_i, !rst_ni)

  `ASSERT(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.parity_en == 1'b0, clk_i, !rst_ni)

endmodule
