// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module rstmgr_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output rstmgr_reg_pkg::rstmgr_reg2hw_t reg2hw, // Write
  input  rstmgr_reg_pkg::rstmgr_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import rstmgr_reg_pkg::* ;

  localparam int AW = 5;
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
  logic [4:0] reset_info_qs;
  logic [4:0] reset_info_wd;
  logic reset_info_we;
  logic reset_info_re;
  logic spi_device_regen_qs;
  logic spi_device_regen_wd;
  logic spi_device_regen_we;
  logic rst_spi_device_n_qs;
  logic rst_spi_device_n_wd;
  logic rst_spi_device_n_we;
  logic usb_regen_qs;
  logic usb_regen_wd;
  logic usb_regen_we;
  logic rst_usb_n_qs;
  logic rst_usb_n_wd;
  logic rst_usb_n_we;

  // Register instances
  // R[reset_info]: V(True)

  prim_subreg_ext #(
    .DW    (5)
  ) u_reset_info (
    .re     (reset_info_re),
    .we     (reset_info_we),
    .wd     (reset_info_wd),
    .d      (hw2reg.reset_info.d),
    .qre    (),
    .qe     (reg2hw.reset_info.qe),
    .q      (reg2hw.reset_info.q ),
    .qs     (reset_info_qs)
  );


  // R[spi_device_regen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h1)
  ) u_spi_device_regen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (spi_device_regen_we),
    .wd     (spi_device_regen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (spi_device_regen_qs)
  );


  // R[rst_spi_device_n]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h1)
  ) u_rst_spi_device_n (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (rst_spi_device_n_we & spi_device_regen_qs),
    .wd     (rst_spi_device_n_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rst_spi_device_n.q ),

    // to register interface (read)
    .qs     (rst_spi_device_n_qs)
  );


  // R[usb_regen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h1)
  ) u_usb_regen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (usb_regen_we),
    .wd     (usb_regen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (usb_regen_qs)
  );


  // R[rst_usb_n]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h1)
  ) u_rst_usb_n (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (rst_usb_n_we & usb_regen_qs),
    .wd     (rst_usb_n_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rst_usb_n.q ),

    // to register interface (read)
    .qs     (rst_usb_n_qs)
  );




  logic [4:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == RSTMGR_RESET_INFO_OFFSET);
    addr_hit[1] = (reg_addr == RSTMGR_SPI_DEVICE_REGEN_OFFSET);
    addr_hit[2] = (reg_addr == RSTMGR_RST_SPI_DEVICE_N_OFFSET);
    addr_hit[3] = (reg_addr == RSTMGR_USB_REGEN_OFFSET);
    addr_hit[4] = (reg_addr == RSTMGR_RST_USB_N_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (RSTMGR_PERMIT[0] != (RSTMGR_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (RSTMGR_PERMIT[1] != (RSTMGR_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[2] && reg_we && (RSTMGR_PERMIT[2] != (RSTMGR_PERMIT[2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[3] && reg_we && (RSTMGR_PERMIT[3] != (RSTMGR_PERMIT[3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[4] && reg_we && (RSTMGR_PERMIT[4] != (RSTMGR_PERMIT[4] & reg_be))) wr_err = 1'b1 ;
  end

  assign reset_info_we = addr_hit[0] & reg_we & ~wr_err;
  assign reset_info_wd = reg_wdata[4:0];
  assign reset_info_re = addr_hit[0] && reg_re;

  assign spi_device_regen_we = addr_hit[1] & reg_we & ~wr_err;
  assign spi_device_regen_wd = reg_wdata[0];

  assign rst_spi_device_n_we = addr_hit[2] & reg_we & ~wr_err;
  assign rst_spi_device_n_wd = reg_wdata[0];

  assign usb_regen_we = addr_hit[3] & reg_we & ~wr_err;
  assign usb_regen_wd = reg_wdata[0];

  assign rst_usb_n_we = addr_hit[4] & reg_we & ~wr_err;
  assign rst_usb_n_wd = reg_wdata[0];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[4:0] = reset_info_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = spi_device_regen_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = rst_spi_device_n_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = usb_regen_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = rst_usb_n_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we)
  `ASSERT_PULSE(rePulse, reg_re)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  `ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.parity_en == 1'b0)

endmodule
