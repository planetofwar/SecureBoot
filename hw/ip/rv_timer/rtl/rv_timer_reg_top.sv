// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`


module rv_timer_reg_top #(
  parameter logic LifeCycle = 1'b0 // If 0b, assume devmode 1b always
) (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output rv_timer_reg_pkg::rv_timer_reg2hw_t reg2hw, // Write
  input  rv_timer_reg_pkg::rv_timer_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import rv_timer_reg_pkg::* ;

  localparam AW = 9;
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

  // Ignore devmode_i if this register module isn't used in LifeCycle managed IP
  // And mandate to return error for address miss

  logic  devmode ;
  assign devmode = LifeCycle ? devmode_i : 1'b1;

  assign reg_error = (devmode & addrmiss) | wr_err ;

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

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic ctrl_qs;
  logic ctrl_wd;
  logic ctrl_we;
  logic [11:0] cfg0_prescale_qs;
  logic [11:0] cfg0_prescale_wd;
  logic cfg0_prescale_we;
  logic [7:0] cfg0_step_qs;
  logic [7:0] cfg0_step_wd;
  logic cfg0_step_we;
  logic [31:0] timer_v_lower0_qs;
  logic [31:0] timer_v_lower0_wd;
  logic timer_v_lower0_we;
  logic [31:0] timer_v_upper0_qs;
  logic [31:0] timer_v_upper0_wd;
  logic timer_v_upper0_we;
  logic [31:0] compare_lower0_0_qs;
  logic [31:0] compare_lower0_0_wd;
  logic compare_lower0_0_we;
  logic [31:0] compare_upper0_0_qs;
  logic [31:0] compare_upper0_0_wd;
  logic compare_upper0_0_we;
  logic intr_enable0_qs;
  logic intr_enable0_wd;
  logic intr_enable0_we;
  logic intr_state0_qs;
  logic intr_state0_wd;
  logic intr_state0_we;
  logic intr_test0_wd;
  logic intr_test0_we;

  // Register instances
  // R[ctrl]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_ctrl (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.q ),

    // to register interface (read)
    .qs     (ctrl_qs)
  );


  // R[cfg0]: V(False)

  //   F[prescale]: 11:0
  prim_subreg #(
    .DW      (12),
    .SWACCESS("RW"),
    .RESVAL  (12'h0)
  ) u_cfg0_prescale (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (cfg0_prescale_we),
    .wd     (cfg0_prescale_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cfg0.prescale.q ),

    // to register interface (read)
    .qs     (cfg0_prescale_qs)
  );


  //   F[step]: 23:16
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RW"),
    .RESVAL  (8'h1)
  ) u_cfg0_step (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (cfg0_step_we),
    .wd     (cfg0_step_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cfg0.step.q ),

    // to register interface (read)
    .qs     (cfg0_step_qs)
  );


  // R[timer_v_lower0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_timer_v_lower0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (timer_v_lower0_we),
    .wd     (timer_v_lower0_wd),

    // from internal hardware
    .de     (hw2reg.timer_v_lower0.de),
    .d      (hw2reg.timer_v_lower0.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timer_v_lower0.q ),

    // to register interface (read)
    .qs     (timer_v_lower0_qs)
  );


  // R[timer_v_upper0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_timer_v_upper0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (timer_v_upper0_we),
    .wd     (timer_v_upper0_wd),

    // from internal hardware
    .de     (hw2reg.timer_v_upper0.de),
    .d      (hw2reg.timer_v_upper0.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timer_v_upper0.q ),

    // to register interface (read)
    .qs     (timer_v_upper0_qs)
  );


  // R[compare_lower0_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'hffffffff)
  ) u_compare_lower0_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (compare_lower0_0_we),
    .wd     (compare_lower0_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.compare_lower0_0.q ),

    // to register interface (read)
    .qs     (compare_lower0_0_qs)
  );


  // R[compare_upper0_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'hffffffff)
  ) u_compare_upper0_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (compare_upper0_0_we),
    .wd     (compare_upper0_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.compare_upper0_0.q ),

    // to register interface (read)
    .qs     (compare_upper0_0_qs)
  );


  // R[intr_enable0]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable0_we),
    .wd     (intr_enable0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable0.q ),

    // to register interface (read)
    .qs     (intr_enable0_qs)
  );


  // R[intr_state0]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state0_we),
    .wd     (intr_state0_wd),

    // from internal hardware
    .de     (hw2reg.intr_state0.de),
    .d      (hw2reg.intr_state0.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state0.q ),

    // to register interface (read)
    .qs     (intr_state0_qs)
  );


  // R[intr_test0]: V(True)

  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test0 (
    .re     (1'b0),
    .we     (intr_test0_we),
    .wd     (intr_test0_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test0.qe),
    .q      (reg2hw.intr_test0.q ),
    .qs     ()
  );



  logic [8:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == RV_TIMER_CTRL_OFFSET);
    addr_hit[1] = (reg_addr == RV_TIMER_CFG0_OFFSET);
    addr_hit[2] = (reg_addr == RV_TIMER_TIMER_V_LOWER0_OFFSET);
    addr_hit[3] = (reg_addr == RV_TIMER_TIMER_V_UPPER0_OFFSET);
    addr_hit[4] = (reg_addr == RV_TIMER_COMPARE_LOWER0_0_OFFSET);
    addr_hit[5] = (reg_addr == RV_TIMER_COMPARE_UPPER0_0_OFFSET);
    addr_hit[6] = (reg_addr == RV_TIMER_INTR_ENABLE0_OFFSET);
    addr_hit[7] = (reg_addr == RV_TIMER_INTR_STATE0_OFFSET);
    addr_hit[8] = (reg_addr == RV_TIMER_INTR_TEST0_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (RV_TIMER_PERMIT[0] != (RV_TIMER_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (RV_TIMER_PERMIT[1] != (RV_TIMER_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[2] && reg_we && (RV_TIMER_PERMIT[2] != (RV_TIMER_PERMIT[2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[3] && reg_we && (RV_TIMER_PERMIT[3] != (RV_TIMER_PERMIT[3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[4] && reg_we && (RV_TIMER_PERMIT[4] != (RV_TIMER_PERMIT[4] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[5] && reg_we && (RV_TIMER_PERMIT[5] != (RV_TIMER_PERMIT[5] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[6] && reg_we && (RV_TIMER_PERMIT[6] != (RV_TIMER_PERMIT[6] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[7] && reg_we && (RV_TIMER_PERMIT[7] != (RV_TIMER_PERMIT[7] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[8] && reg_we && (RV_TIMER_PERMIT[8] != (RV_TIMER_PERMIT[8] & reg_be))) wr_err = 1'b1 ;
  end

  assign ctrl_we = addr_hit[0] & reg_we & ~wr_err;
  assign ctrl_wd = reg_wdata[0];

  assign cfg0_prescale_we = addr_hit[1] & reg_we & ~wr_err;
  assign cfg0_prescale_wd = reg_wdata[11:0];

  assign cfg0_step_we = addr_hit[1] & reg_we & ~wr_err;
  assign cfg0_step_wd = reg_wdata[23:16];

  assign timer_v_lower0_we = addr_hit[2] & reg_we & ~wr_err;
  assign timer_v_lower0_wd = reg_wdata[31:0];

  assign timer_v_upper0_we = addr_hit[3] & reg_we & ~wr_err;
  assign timer_v_upper0_wd = reg_wdata[31:0];

  assign compare_lower0_0_we = addr_hit[4] & reg_we & ~wr_err;
  assign compare_lower0_0_wd = reg_wdata[31:0];

  assign compare_upper0_0_we = addr_hit[5] & reg_we & ~wr_err;
  assign compare_upper0_0_wd = reg_wdata[31:0];

  assign intr_enable0_we = addr_hit[6] & reg_we & ~wr_err;
  assign intr_enable0_wd = reg_wdata[0];

  assign intr_state0_we = addr_hit[7] & reg_we & ~wr_err;
  assign intr_state0_wd = reg_wdata[0];

  assign intr_test0_we = addr_hit[8] & reg_we & ~wr_err;
  assign intr_test0_wd = reg_wdata[0];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = ctrl_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[11:0] = cfg0_prescale_qs;
        reg_rdata_next[23:16] = cfg0_step_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[31:0] = timer_v_lower0_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[31:0] = timer_v_upper0_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[31:0] = compare_lower0_0_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[31:0] = compare_upper0_0_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = intr_enable0_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[0] = intr_state0_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = '0;
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
