// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This interface collect the broadcast output data from OTP,
// and drive input requests coming into OTP.
interface otp_ctrl_if(input clk_i, input rst_ni);
  import otp_ctrl_pkg::*;
  import otp_ctrl_reg_pkg::*;
  import otp_ctrl_part_pkg::*;

  // output from DUT
  otp_hw_cfg_t         otp_hw_cfg_o;
  otp_keymgr_key_t     keymgr_key_o;
  otp_lc_data_t        lc_data_o;
  logic                pwr_otp_done_o, pwr_otp_idle_o;

  // inputs to DUT
  logic                pwr_otp_init_i;
  lc_ctrl_pkg::lc_tx_e lc_dft_en_i, lc_escalate_en_i, lc_check_byp_en_i,
                       lc_creator_seed_sw_rw_en_i, lc_seed_hw_rd_en_i;

  // TODO: for lc_tx, except esc_en signal, all value different from On is treated as Off,
  // technically we can randomize values here once scb supports
  task automatic init();
    lc_creator_seed_sw_rw_en_i = lc_ctrl_pkg::On;
    lc_seed_hw_rd_en_i         = lc_ctrl_pkg::Off;
    lc_dft_en_i                = lc_ctrl_pkg::Off;
    lc_escalate_en_i           = lc_ctrl_pkg::Off;
    lc_check_byp_en_i          = lc_ctrl_pkg::Off;
    pwr_otp_init_i             = 0;
  endtask

  task automatic drive_pwr_otp_init(logic val);
    pwr_otp_init_i = val;
  endtask

  task automatic drive_lc_dft_en(lc_ctrl_pkg::lc_tx_e val);
    lc_dft_en_i = val;
  endtask

  // If pwr_otp_idle is set only if pwr_otp init is done
  `ASSERT(OtpPwrDoneWhenIdle_A, pwr_otp_idle_o |-> pwr_otp_done_o)

  // otp_hw_cfg_o is valid only when otp init is done
  `ASSERT(OtpHwCfgValidOn_A, pwr_otp_done_o |-> otp_hw_cfg_o.valid == lc_ctrl_pkg::On)
  // if otp_hw_cfg is Off, then hw partition is not finished calculation, then otp init is not done
  `ASSERT(OtpHwCfgValidOff_A, otp_hw_cfg_o.valid == lc_ctrl_pkg::Off |-> pwr_otp_done_o == 0)
  // Once OTP init is done, hw_cfg_o output value stays stable until next power cycle
  `ASSERT(OtpHwCfgStable_A, otp_hw_cfg_o.valid == lc_ctrl_pkg::On |=> $stable(otp_hw_cfg_o))

endinterface
