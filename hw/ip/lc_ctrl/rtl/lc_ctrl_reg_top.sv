// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module lc_ctrl_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output lc_ctrl_reg_pkg::lc_ctrl_reg2hw_t reg2hw, // Write
  input  lc_ctrl_reg_pkg::lc_ctrl_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import lc_ctrl_reg_pkg::* ;

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
  logic alert_test_lc_programming_failure_wd;
  logic alert_test_lc_programming_failure_we;
  logic alert_test_lc_state_failure_wd;
  logic alert_test_lc_state_failure_we;
  logic status_ready_qs;
  logic status_ready_re;
  logic status_transition_successful_qs;
  logic status_transition_successful_re;
  logic status_transition_error_qs;
  logic status_transition_error_re;
  logic status_token_error_qs;
  logic status_token_error_re;
  logic status_otp_error_qs;
  logic status_otp_error_re;
  logic status_state_error_qs;
  logic status_state_error_re;
  logic claim_transition_if_qs;
  logic claim_transition_if_wd;
  logic claim_transition_if_we;
  logic claim_transition_if_re;
  logic transition_regwen_qs;
  logic transition_cmd_wd;
  logic transition_cmd_we;
  logic [31:0] transition_token_0_qs;
  logic [31:0] transition_token_0_wd;
  logic transition_token_0_we;
  logic transition_token_0_re;
  logic [31:0] transition_token_1_qs;
  logic [31:0] transition_token_1_wd;
  logic transition_token_1_we;
  logic transition_token_1_re;
  logic [31:0] transition_token_2_qs;
  logic [31:0] transition_token_2_wd;
  logic transition_token_2_we;
  logic transition_token_2_re;
  logic [31:0] transition_token_3_qs;
  logic [31:0] transition_token_3_wd;
  logic transition_token_3_we;
  logic transition_token_3_re;
  logic [3:0] transition_target_qs;
  logic [3:0] transition_target_wd;
  logic transition_target_we;
  logic transition_target_re;
  logic [3:0] lc_state_qs;
  logic lc_state_re;
  logic [4:0] lc_transition_cnt_qs;
  logic lc_transition_cnt_re;
  logic [1:0] lc_id_state_qs;
  logic lc_id_state_re;

  // Register instances
  // R[alert_test]: V(True)

  //   F[lc_programming_failure]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_lc_programming_failure (
    .re     (1'b0),
    .we     (alert_test_lc_programming_failure_we),
    .wd     (alert_test_lc_programming_failure_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.lc_programming_failure.qe),
    .q      (reg2hw.alert_test.lc_programming_failure.q ),
    .qs     ()
  );


  //   F[lc_state_failure]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_lc_state_failure (
    .re     (1'b0),
    .we     (alert_test_lc_state_failure_we),
    .wd     (alert_test_lc_state_failure_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.lc_state_failure.qe),
    .q      (reg2hw.alert_test.lc_state_failure.q ),
    .qs     ()
  );


  // R[status]: V(True)

  //   F[ready]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_ready (
    .re     (status_ready_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.ready.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.status.ready.q ),
    .qs     (status_ready_qs)
  );


  //   F[transition_successful]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_transition_successful (
    .re     (status_transition_successful_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.transition_successful.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.status.transition_successful.q ),
    .qs     (status_transition_successful_qs)
  );


  //   F[transition_error]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_transition_error (
    .re     (status_transition_error_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.transition_error.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.status.transition_error.q ),
    .qs     (status_transition_error_qs)
  );


  //   F[token_error]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_token_error (
    .re     (status_token_error_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.token_error.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.status.token_error.q ),
    .qs     (status_token_error_qs)
  );


  //   F[otp_error]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_otp_error (
    .re     (status_otp_error_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.otp_error.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.status.otp_error.q ),
    .qs     (status_otp_error_qs)
  );


  //   F[state_error]: 5:5
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_state_error (
    .re     (status_state_error_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.state_error.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.status.state_error.q ),
    .qs     (status_state_error_qs)
  );


  // R[claim_transition_if]: V(True)

  prim_subreg_ext #(
    .DW    (1)
  ) u_claim_transition_if (
    .re     (claim_transition_if_re),
    .we     (claim_transition_if_we),
    .wd     (claim_transition_if_wd),
    .d      (hw2reg.claim_transition_if.d),
    .qre    (),
    .qe     (reg2hw.claim_transition_if.qe),
    .q      (reg2hw.claim_transition_if.q ),
    .qs     (claim_transition_if_qs)
  );


  // R[transition_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h1)
  ) u_transition_regwen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.transition_regwen.de),
    .d      (hw2reg.transition_regwen.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (transition_regwen_qs)
  );


  // R[transition_cmd]: V(True)

  prim_subreg_ext #(
    .DW    (1)
  ) u_transition_cmd (
    .re     (1'b0),
    // qualified with register enable
    .we     (transition_cmd_we & transition_regwen_qs),
    .wd     (transition_cmd_wd),
    .d      (hw2reg.transition_cmd.d),
    .qre    (),
    .qe     (reg2hw.transition_cmd.qe),
    .q      (reg2hw.transition_cmd.q ),
    .qs     ()
  );



  // Subregister 0 of Multireg transition_token
  // R[transition_token_0]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_transition_token_0 (
    .re     (transition_token_0_re),
    // qualified with register enable
    .we     (transition_token_0_we & transition_regwen_qs),
    .wd     (transition_token_0_wd),
    .d      (hw2reg.transition_token[0].d),
    .qre    (),
    .qe     (reg2hw.transition_token[0].qe),
    .q      (reg2hw.transition_token[0].q ),
    .qs     (transition_token_0_qs)
  );

  // Subregister 1 of Multireg transition_token
  // R[transition_token_1]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_transition_token_1 (
    .re     (transition_token_1_re),
    // qualified with register enable
    .we     (transition_token_1_we & transition_regwen_qs),
    .wd     (transition_token_1_wd),
    .d      (hw2reg.transition_token[1].d),
    .qre    (),
    .qe     (reg2hw.transition_token[1].qe),
    .q      (reg2hw.transition_token[1].q ),
    .qs     (transition_token_1_qs)
  );

  // Subregister 2 of Multireg transition_token
  // R[transition_token_2]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_transition_token_2 (
    .re     (transition_token_2_re),
    // qualified with register enable
    .we     (transition_token_2_we & transition_regwen_qs),
    .wd     (transition_token_2_wd),
    .d      (hw2reg.transition_token[2].d),
    .qre    (),
    .qe     (reg2hw.transition_token[2].qe),
    .q      (reg2hw.transition_token[2].q ),
    .qs     (transition_token_2_qs)
  );

  // Subregister 3 of Multireg transition_token
  // R[transition_token_3]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_transition_token_3 (
    .re     (transition_token_3_re),
    // qualified with register enable
    .we     (transition_token_3_we & transition_regwen_qs),
    .wd     (transition_token_3_wd),
    .d      (hw2reg.transition_token[3].d),
    .qre    (),
    .qe     (reg2hw.transition_token[3].qe),
    .q      (reg2hw.transition_token[3].q ),
    .qs     (transition_token_3_qs)
  );


  // R[transition_target]: V(True)

  prim_subreg_ext #(
    .DW    (4)
  ) u_transition_target (
    .re     (transition_target_re),
    // qualified with register enable
    .we     (transition_target_we & transition_regwen_qs),
    .wd     (transition_target_wd),
    .d      (hw2reg.transition_target.d),
    .qre    (),
    .qe     (reg2hw.transition_target.qe),
    .q      (reg2hw.transition_target.q ),
    .qs     (transition_target_qs)
  );


  // R[lc_state]: V(True)

  prim_subreg_ext #(
    .DW    (4)
  ) u_lc_state (
    .re     (lc_state_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.lc_state.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.lc_state.q ),
    .qs     (lc_state_qs)
  );


  // R[lc_transition_cnt]: V(True)

  prim_subreg_ext #(
    .DW    (5)
  ) u_lc_transition_cnt (
    .re     (lc_transition_cnt_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.lc_transition_cnt.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.lc_transition_cnt.q ),
    .qs     (lc_transition_cnt_qs)
  );


  // R[lc_id_state]: V(True)

  prim_subreg_ext #(
    .DW    (2)
  ) u_lc_id_state (
    .re     (lc_id_state_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.lc_id_state.d),
    .qre    (),
    .qe     (),
    .q      (reg2hw.lc_id_state.q ),
    .qs     (lc_id_state_qs)
  );




  logic [12:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == LC_CTRL_ALERT_TEST_OFFSET);
    addr_hit[ 1] = (reg_addr == LC_CTRL_STATUS_OFFSET);
    addr_hit[ 2] = (reg_addr == LC_CTRL_CLAIM_TRANSITION_IF_OFFSET);
    addr_hit[ 3] = (reg_addr == LC_CTRL_TRANSITION_REGWEN_OFFSET);
    addr_hit[ 4] = (reg_addr == LC_CTRL_TRANSITION_CMD_OFFSET);
    addr_hit[ 5] = (reg_addr == LC_CTRL_TRANSITION_TOKEN_0_OFFSET);
    addr_hit[ 6] = (reg_addr == LC_CTRL_TRANSITION_TOKEN_1_OFFSET);
    addr_hit[ 7] = (reg_addr == LC_CTRL_TRANSITION_TOKEN_2_OFFSET);
    addr_hit[ 8] = (reg_addr == LC_CTRL_TRANSITION_TOKEN_3_OFFSET);
    addr_hit[ 9] = (reg_addr == LC_CTRL_TRANSITION_TARGET_OFFSET);
    addr_hit[10] = (reg_addr == LC_CTRL_LC_STATE_OFFSET);
    addr_hit[11] = (reg_addr == LC_CTRL_LC_TRANSITION_CNT_OFFSET);
    addr_hit[12] = (reg_addr == LC_CTRL_LC_ID_STATE_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[ 0] && reg_we && (LC_CTRL_PERMIT[ 0] != (LC_CTRL_PERMIT[ 0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 1] && reg_we && (LC_CTRL_PERMIT[ 1] != (LC_CTRL_PERMIT[ 1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 2] && reg_we && (LC_CTRL_PERMIT[ 2] != (LC_CTRL_PERMIT[ 2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 3] && reg_we && (LC_CTRL_PERMIT[ 3] != (LC_CTRL_PERMIT[ 3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 4] && reg_we && (LC_CTRL_PERMIT[ 4] != (LC_CTRL_PERMIT[ 4] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 5] && reg_we && (LC_CTRL_PERMIT[ 5] != (LC_CTRL_PERMIT[ 5] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 6] && reg_we && (LC_CTRL_PERMIT[ 6] != (LC_CTRL_PERMIT[ 6] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 7] && reg_we && (LC_CTRL_PERMIT[ 7] != (LC_CTRL_PERMIT[ 7] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 8] && reg_we && (LC_CTRL_PERMIT[ 8] != (LC_CTRL_PERMIT[ 8] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 9] && reg_we && (LC_CTRL_PERMIT[ 9] != (LC_CTRL_PERMIT[ 9] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[10] && reg_we && (LC_CTRL_PERMIT[10] != (LC_CTRL_PERMIT[10] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[11] && reg_we && (LC_CTRL_PERMIT[11] != (LC_CTRL_PERMIT[11] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[12] && reg_we && (LC_CTRL_PERMIT[12] != (LC_CTRL_PERMIT[12] & reg_be))) wr_err = 1'b1 ;
  end

  assign alert_test_lc_programming_failure_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_lc_programming_failure_wd = reg_wdata[0];

  assign alert_test_lc_state_failure_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_lc_state_failure_wd = reg_wdata[1];

  assign status_ready_re = addr_hit[1] && reg_re;

  assign status_transition_successful_re = addr_hit[1] && reg_re;

  assign status_transition_error_re = addr_hit[1] && reg_re;

  assign status_token_error_re = addr_hit[1] && reg_re;

  assign status_otp_error_re = addr_hit[1] && reg_re;

  assign status_state_error_re = addr_hit[1] && reg_re;

  assign claim_transition_if_we = addr_hit[2] & reg_we & ~wr_err;
  assign claim_transition_if_wd = reg_wdata[0];
  assign claim_transition_if_re = addr_hit[2] && reg_re;


  assign transition_cmd_we = addr_hit[4] & reg_we & ~wr_err;
  assign transition_cmd_wd = reg_wdata[0];

  assign transition_token_0_we = addr_hit[5] & reg_we & ~wr_err;
  assign transition_token_0_wd = reg_wdata[31:0];
  assign transition_token_0_re = addr_hit[5] && reg_re;

  assign transition_token_1_we = addr_hit[6] & reg_we & ~wr_err;
  assign transition_token_1_wd = reg_wdata[31:0];
  assign transition_token_1_re = addr_hit[6] && reg_re;

  assign transition_token_2_we = addr_hit[7] & reg_we & ~wr_err;
  assign transition_token_2_wd = reg_wdata[31:0];
  assign transition_token_2_re = addr_hit[7] && reg_re;

  assign transition_token_3_we = addr_hit[8] & reg_we & ~wr_err;
  assign transition_token_3_wd = reg_wdata[31:0];
  assign transition_token_3_re = addr_hit[8] && reg_re;

  assign transition_target_we = addr_hit[9] & reg_we & ~wr_err;
  assign transition_target_wd = reg_wdata[3:0];
  assign transition_target_re = addr_hit[9] && reg_re;

  assign lc_state_re = addr_hit[10] && reg_re;

  assign lc_transition_cnt_re = addr_hit[11] && reg_re;

  assign lc_id_state_re = addr_hit[12] && reg_re;

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = status_ready_qs;
        reg_rdata_next[1] = status_transition_successful_qs;
        reg_rdata_next[2] = status_transition_error_qs;
        reg_rdata_next[3] = status_token_error_qs;
        reg_rdata_next[4] = status_otp_error_qs;
        reg_rdata_next[5] = status_state_error_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = claim_transition_if_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = transition_regwen_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[5]: begin
        reg_rdata_next[31:0] = transition_token_0_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = transition_token_1_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = transition_token_2_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = transition_token_3_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[3:0] = transition_target_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[3:0] = lc_state_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[4:0] = lc_transition_cnt_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[1:0] = lc_id_state_qs;
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
