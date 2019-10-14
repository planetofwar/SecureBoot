// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
module tb;
  // dep packages
  import uvm_pkg::*;
  import dv_utils_pkg::*;
  import i2c_env_pkg::*;
  import i2c_test_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  wire clk, rst_n;
  wire devmode;
  wire intr_fmt_watermark;
  wire intr_rx_watermark;
  wire intr_fmt_overflow;
  wire intr_rx_overflow;
  wire intr_nak;
  wire intr_scl_interference;
  wire intr_sda_interference;
  wire intr_stretch_timeout;
  wire intr_sda_unstable;
  wire [NUM_MAX_INTERRUPTS-1:0] interrupts;
  wire [NUM_MAX_ALERTS-1:0] alerts;

  // interfaces
  clk_rst_if clk_rst_if(.clk(clk), .rst_n(rst_n));
  pins_if #(NUM_MAX_INTERRUPTS) intr_if(interrupts);
  pins_if #(NUM_MAX_ALERTS) alerts_if(alerts);
  pins_if #(1) devmode_if(devmode);
  tl_if tl_if(.clk(clk), .rst_n(rst_n));
  i2c_if i2c_if();

  // dut
  i2c dut (
    .clk_i                   (clk        ),
    .rst_ni                  (rst_n      ),

    .tl_i                    (tl_if.h2d  ),
    .tl_o                    (tl_if.d2h  ),

    .cio_scl_i               (i2c_if.scl_i          ),
    .cio_scl_o               (i2c_if.scl_o          ),
    .cio_scl_en_o            (i2c_if.scl_en_o       ),
    .cio_sda_i               (i2c_if.sda_i          ),
    .cio_sda_o               (i2c_if.sda_o          ),
    .cio_sda_en_o            (i2c_if.sda_en_o       ),

    .intr_fmt_watermark_o    (intr_fmt_watermark    ),
    .intr_rx_watermark_o     (intr_rx_watermark     ),
    .intr_fmt_overflow_o     (intr_fmt_overflow     ),
    .intr_rx_overflow_o      (intr_rx_overflow      ),
    .intr_nak_o              (intr_nak              ),
    .intr_scl_interference_o (intr_scl_interference ),
    .intr_sda_interference_o (intr_sda_interference ),
    .intr_stretch_timeout_o  (intr_stretch_timeout  ),
    .intr_sda_unstable_o     (intr_sda_unstable     )
  );


  assign interrupts[FmtWatermark]   = intr_fmt_watermark;
  assign interrupts[RxWatermark]    = intr_rx_watermark;
  assign interrupts[FmtOverflow]    = intr_fmt_overflow;
  assign interrupts[RxOverflow]     = intr_rx_overflow;
  assign interrupts[Nak]            = intr_nak;
  assign interrupts[SclInference]   = intr_scl_interference;
  assign interrupts[SdaInference]   = intr_sda_interference;
  assign interrupts[StretchTimeout] = intr_stretch_timeout;
  assign interrupts[SdaUnstable]    = intr_sda_unstable;

  initial begin
    // drive clk and rst_n from clk_if
    clk_rst_if.set_active();
    uvm_config_db#(virtual clk_rst_if)::set(null, "*.env", "clk_rst_vif", clk_rst_if);
    uvm_config_db#(intr_vif)::set(null, "*.env", "intr_vif", intr_if);
    uvm_config_db#(alerts_vif)::set(null, "*.env", "alerts_vif", alerts_if);
    uvm_config_db#(devmode_vif)::set(null, "*.env", "devmode_vif", devmode_if);
    uvm_config_db#(tlul_assert_vif)::set(null, "*.env", "tlul_assert_vif",
                                         tb.dut.tlul_assert_host);
    uvm_config_db#(virtual tl_if)::set(null, "*.env.m_tl_agent*", "vif", tl_if);
    uvm_config_db#(virtual i2c_if)::set(null, "*.env.m_i2c_agent*", "vif", i2c_if);
    $timeformat(-12, 0, " ps", 12);
    run_test();
  end

endmodule
