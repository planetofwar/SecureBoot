// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package otp_ctrl_reg_pkg;

  // Param list
  parameter int OtpByteAddrWidth = 11;
  parameter int NumErrorEntries = 9;
  parameter int NumDaiWords = 2;
  parameter int NumDigestWords = 2;
  parameter int NumLcHalfwords = 12;
  parameter int NumCreatorSwCfgWindowWords = 256;
  parameter int NumOwnerSwCfgWindowWords = 256;
  parameter int NumDebugWindowWords = 512;
  parameter int NumAlerts = 2;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } otp_operation_done;
    struct packed {
      logic        q;
    } otp_error;
  } otp_ctrl_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } otp_operation_done;
    struct packed {
      logic        q;
    } otp_error;
  } otp_ctrl_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } otp_operation_done;
    struct packed {
      logic        q;
      logic        qe;
    } otp_error;
  } otp_ctrl_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } read;
    struct packed {
      logic        q;
      logic        qe;
    } write;
    struct packed {
      logic        q;
      logic        qe;
    } digest;
  } otp_ctrl_reg2hw_direct_access_cmd_reg_t;

  typedef struct packed {
    logic [10:0] q;
  } otp_ctrl_reg2hw_direct_access_address_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otp_ctrl_reg2hw_direct_access_wdata_mreg_t;

  typedef struct packed {
    logic        q;
  } otp_ctrl_reg2hw_check_trigger_regwen_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } integrity;
    struct packed {
      logic        q;
      logic        qe;
    } consistency;
  } otp_ctrl_reg2hw_check_trigger_reg_t;

  typedef struct packed {
    logic        q;
  } otp_ctrl_reg2hw_check_regwen_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otp_ctrl_reg2hw_check_timeout_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otp_ctrl_reg2hw_integrity_check_period_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otp_ctrl_reg2hw_consistency_check_period_reg_t;

  typedef struct packed {
    logic        q;
  } otp_ctrl_reg2hw_creator_sw_cfg_read_lock_reg_t;

  typedef struct packed {
    logic        q;
  } otp_ctrl_reg2hw_owner_sw_cfg_read_lock_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } otp_operation_done;
    struct packed {
      logic        d;
      logic        de;
    } otp_error;
  } otp_ctrl_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } creator_sw_cfg_error;
    struct packed {
      logic        d;
    } owner_sw_cfg_error;
    struct packed {
      logic        d;
    } hw_cfg_error;
    struct packed {
      logic        d;
    } secret0_error;
    struct packed {
      logic        d;
    } secret1_error;
    struct packed {
      logic        d;
    } secret2_error;
    struct packed {
      logic        d;
    } life_cycle_error;
    struct packed {
      logic        d;
    } dai_error;
    struct packed {
      logic        d;
    } lci_error;
    struct packed {
      logic        d;
    } timeout_error;
    struct packed {
      logic        d;
    } dai_idle;
    struct packed {
      logic        d;
    } check_pending;
  } otp_ctrl_hw2reg_status_reg_t;

  typedef struct packed {
    logic [3:0]  d;
  } otp_ctrl_hw2reg_err_code_mreg_t;

  typedef struct packed {
    logic        d;
  } otp_ctrl_hw2reg_direct_access_regwen_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_direct_access_rdata_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_creator_sw_cfg_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_owner_sw_cfg_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_hw_cfg_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_secret0_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_secret1_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_secret2_digest_mreg_t;

  typedef struct packed {
    logic [15:0] d;
    logic        de;
  } otp_ctrl_hw2reg_lc_state_mreg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } otp_ctrl_hw2reg_lc_transition_cnt_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    otp_ctrl_reg2hw_intr_state_reg_t intr_state; // [192:191]
    otp_ctrl_reg2hw_intr_enable_reg_t intr_enable; // [190:189]
    otp_ctrl_reg2hw_intr_test_reg_t intr_test; // [188:185]
    otp_ctrl_reg2hw_direct_access_cmd_reg_t direct_access_cmd; // [184:179]
    otp_ctrl_reg2hw_direct_access_address_reg_t direct_access_address; // [178:168]
    otp_ctrl_reg2hw_direct_access_wdata_mreg_t [1:0] direct_access_wdata; // [167:104]
    otp_ctrl_reg2hw_check_trigger_regwen_reg_t check_trigger_regwen; // [103:103]
    otp_ctrl_reg2hw_check_trigger_reg_t check_trigger; // [102:99]
    otp_ctrl_reg2hw_check_regwen_reg_t check_regwen; // [98:98]
    otp_ctrl_reg2hw_check_timeout_reg_t check_timeout; // [97:66]
    otp_ctrl_reg2hw_integrity_check_period_reg_t integrity_check_period; // [65:34]
    otp_ctrl_reg2hw_consistency_check_period_reg_t consistency_check_period; // [33:2]
    otp_ctrl_reg2hw_creator_sw_cfg_read_lock_reg_t creator_sw_cfg_read_lock; // [1:1]
    otp_ctrl_reg2hw_owner_sw_cfg_read_lock_reg_t owner_sw_cfg_read_lock; // [0:0]
  } otp_ctrl_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    otp_ctrl_hw2reg_intr_state_reg_t intr_state; // [737:736]
    otp_ctrl_hw2reg_status_reg_t status; // [735:736]
    otp_ctrl_hw2reg_err_code_mreg_t [8:0] err_code; // [735:700]
    otp_ctrl_hw2reg_direct_access_regwen_reg_t direct_access_regwen; // [699:700]
    otp_ctrl_hw2reg_direct_access_rdata_mreg_t [1:0] direct_access_rdata; // [699:636]
    otp_ctrl_hw2reg_creator_sw_cfg_digest_mreg_t [1:0] creator_sw_cfg_digest; // [635:572]
    otp_ctrl_hw2reg_owner_sw_cfg_digest_mreg_t [1:0] owner_sw_cfg_digest; // [571:508]
    otp_ctrl_hw2reg_hw_cfg_digest_mreg_t [1:0] hw_cfg_digest; // [507:444]
    otp_ctrl_hw2reg_secret0_digest_mreg_t [1:0] secret0_digest; // [443:380]
    otp_ctrl_hw2reg_secret1_digest_mreg_t [1:0] secret1_digest; // [379:316]
    otp_ctrl_hw2reg_secret2_digest_mreg_t [1:0] secret2_digest; // [315:252]
    otp_ctrl_hw2reg_lc_state_mreg_t [11:0] lc_state; // [251:48]
    otp_ctrl_hw2reg_lc_transition_cnt_reg_t lc_transition_cnt; // [47:48]
  } otp_ctrl_hw2reg_t;

  // Register Address
  parameter logic [12:0] OTP_CTRL_INTR_STATE_OFFSET = 13'h 0;
  parameter logic [12:0] OTP_CTRL_INTR_ENABLE_OFFSET = 13'h 4;
  parameter logic [12:0] OTP_CTRL_INTR_TEST_OFFSET = 13'h 8;
  parameter logic [12:0] OTP_CTRL_STATUS_OFFSET = 13'h c;
  parameter logic [12:0] OTP_CTRL_ERR_CODE_0_OFFSET = 13'h 10;
  parameter logic [12:0] OTP_CTRL_ERR_CODE_1_OFFSET = 13'h 14;
  parameter logic [12:0] OTP_CTRL_DIRECT_ACCESS_REGWEN_OFFSET = 13'h 18;
  parameter logic [12:0] OTP_CTRL_DIRECT_ACCESS_CMD_OFFSET = 13'h 1c;
  parameter logic [12:0] OTP_CTRL_DIRECT_ACCESS_ADDRESS_OFFSET = 13'h 20;
  parameter logic [12:0] OTP_CTRL_DIRECT_ACCESS_WDATA_0_OFFSET = 13'h 24;
  parameter logic [12:0] OTP_CTRL_DIRECT_ACCESS_WDATA_1_OFFSET = 13'h 28;
  parameter logic [12:0] OTP_CTRL_DIRECT_ACCESS_RDATA_0_OFFSET = 13'h 2c;
  parameter logic [12:0] OTP_CTRL_DIRECT_ACCESS_RDATA_1_OFFSET = 13'h 30;
  parameter logic [12:0] OTP_CTRL_CHECK_TRIGGER_REGWEN_OFFSET = 13'h 34;
  parameter logic [12:0] OTP_CTRL_CHECK_TRIGGER_OFFSET = 13'h 38;
  parameter logic [12:0] OTP_CTRL_CHECK_REGWEN_OFFSET = 13'h 3c;
  parameter logic [12:0] OTP_CTRL_CHECK_TIMEOUT_OFFSET = 13'h 40;
  parameter logic [12:0] OTP_CTRL_INTEGRITY_CHECK_PERIOD_OFFSET = 13'h 44;
  parameter logic [12:0] OTP_CTRL_CONSISTENCY_CHECK_PERIOD_OFFSET = 13'h 48;
  parameter logic [12:0] OTP_CTRL_CREATOR_SW_CFG_READ_LOCK_OFFSET = 13'h 4c;
  parameter logic [12:0] OTP_CTRL_OWNER_SW_CFG_READ_LOCK_OFFSET = 13'h 50;
  parameter logic [12:0] OTP_CTRL_CREATOR_SW_CFG_DIGEST_0_OFFSET = 13'h 54;
  parameter logic [12:0] OTP_CTRL_CREATOR_SW_CFG_DIGEST_1_OFFSET = 13'h 58;
  parameter logic [12:0] OTP_CTRL_OWNER_SW_CFG_DIGEST_0_OFFSET = 13'h 5c;
  parameter logic [12:0] OTP_CTRL_OWNER_SW_CFG_DIGEST_1_OFFSET = 13'h 60;
  parameter logic [12:0] OTP_CTRL_HW_CFG_DIGEST_0_OFFSET = 13'h 64;
  parameter logic [12:0] OTP_CTRL_HW_CFG_DIGEST_1_OFFSET = 13'h 68;
  parameter logic [12:0] OTP_CTRL_SECRET0_DIGEST_0_OFFSET = 13'h 6c;
  parameter logic [12:0] OTP_CTRL_SECRET0_DIGEST_1_OFFSET = 13'h 70;
  parameter logic [12:0] OTP_CTRL_SECRET1_DIGEST_0_OFFSET = 13'h 74;
  parameter logic [12:0] OTP_CTRL_SECRET1_DIGEST_1_OFFSET = 13'h 78;
  parameter logic [12:0] OTP_CTRL_SECRET2_DIGEST_0_OFFSET = 13'h 7c;
  parameter logic [12:0] OTP_CTRL_SECRET2_DIGEST_1_OFFSET = 13'h 80;
  parameter logic [12:0] OTP_CTRL_LC_STATE_0_OFFSET = 13'h 84;
  parameter logic [12:0] OTP_CTRL_LC_STATE_1_OFFSET = 13'h 88;
  parameter logic [12:0] OTP_CTRL_LC_STATE_2_OFFSET = 13'h 8c;
  parameter logic [12:0] OTP_CTRL_LC_STATE_3_OFFSET = 13'h 90;
  parameter logic [12:0] OTP_CTRL_LC_STATE_4_OFFSET = 13'h 94;
  parameter logic [12:0] OTP_CTRL_LC_STATE_5_OFFSET = 13'h 98;
  parameter logic [12:0] OTP_CTRL_LC_TRANSITION_CNT_OFFSET = 13'h 9c;

  // Window parameter
  parameter logic [12:0] OTP_CTRL_CREATOR_SW_CFG_OFFSET = 13'h 400;
  parameter logic [12:0] OTP_CTRL_CREATOR_SW_CFG_SIZE   = 13'h 400;
  parameter logic [12:0] OTP_CTRL_OWNER_SW_CFG_OFFSET = 13'h 800;
  parameter logic [12:0] OTP_CTRL_OWNER_SW_CFG_SIZE   = 13'h 400;
  parameter logic [12:0] OTP_CTRL_TEST_ACCESS_OFFSET = 13'h 1000;
  parameter logic [12:0] OTP_CTRL_TEST_ACCESS_SIZE   = 13'h 800;

  // Register Index
  typedef enum int {
    OTP_CTRL_INTR_STATE,
    OTP_CTRL_INTR_ENABLE,
    OTP_CTRL_INTR_TEST,
    OTP_CTRL_STATUS,
    OTP_CTRL_ERR_CODE_0,
    OTP_CTRL_ERR_CODE_1,
    OTP_CTRL_DIRECT_ACCESS_REGWEN,
    OTP_CTRL_DIRECT_ACCESS_CMD,
    OTP_CTRL_DIRECT_ACCESS_ADDRESS,
    OTP_CTRL_DIRECT_ACCESS_WDATA_0,
    OTP_CTRL_DIRECT_ACCESS_WDATA_1,
    OTP_CTRL_DIRECT_ACCESS_RDATA_0,
    OTP_CTRL_DIRECT_ACCESS_RDATA_1,
    OTP_CTRL_CHECK_TRIGGER_REGWEN,
    OTP_CTRL_CHECK_TRIGGER,
    OTP_CTRL_CHECK_REGWEN,
    OTP_CTRL_CHECK_TIMEOUT,
    OTP_CTRL_INTEGRITY_CHECK_PERIOD,
    OTP_CTRL_CONSISTENCY_CHECK_PERIOD,
    OTP_CTRL_CREATOR_SW_CFG_READ_LOCK,
    OTP_CTRL_OWNER_SW_CFG_READ_LOCK,
    OTP_CTRL_CREATOR_SW_CFG_DIGEST_0,
    OTP_CTRL_CREATOR_SW_CFG_DIGEST_1,
    OTP_CTRL_OWNER_SW_CFG_DIGEST_0,
    OTP_CTRL_OWNER_SW_CFG_DIGEST_1,
    OTP_CTRL_HW_CFG_DIGEST_0,
    OTP_CTRL_HW_CFG_DIGEST_1,
    OTP_CTRL_SECRET0_DIGEST_0,
    OTP_CTRL_SECRET0_DIGEST_1,
    OTP_CTRL_SECRET1_DIGEST_0,
    OTP_CTRL_SECRET1_DIGEST_1,
    OTP_CTRL_SECRET2_DIGEST_0,
    OTP_CTRL_SECRET2_DIGEST_1,
    OTP_CTRL_LC_STATE_0,
    OTP_CTRL_LC_STATE_1,
    OTP_CTRL_LC_STATE_2,
    OTP_CTRL_LC_STATE_3,
    OTP_CTRL_LC_STATE_4,
    OTP_CTRL_LC_STATE_5,
    OTP_CTRL_LC_TRANSITION_CNT
  } otp_ctrl_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] OTP_CTRL_PERMIT [40] = '{
    4'b 0001, // index[ 0] OTP_CTRL_INTR_STATE
    4'b 0001, // index[ 1] OTP_CTRL_INTR_ENABLE
    4'b 0001, // index[ 2] OTP_CTRL_INTR_TEST
    4'b 0011, // index[ 3] OTP_CTRL_STATUS
    4'b 1111, // index[ 4] OTP_CTRL_ERR_CODE_0
    4'b 0001, // index[ 5] OTP_CTRL_ERR_CODE_1
    4'b 0001, // index[ 6] OTP_CTRL_DIRECT_ACCESS_REGWEN
    4'b 0001, // index[ 7] OTP_CTRL_DIRECT_ACCESS_CMD
    4'b 0011, // index[ 8] OTP_CTRL_DIRECT_ACCESS_ADDRESS
    4'b 1111, // index[ 9] OTP_CTRL_DIRECT_ACCESS_WDATA_0
    4'b 1111, // index[10] OTP_CTRL_DIRECT_ACCESS_WDATA_1
    4'b 1111, // index[11] OTP_CTRL_DIRECT_ACCESS_RDATA_0
    4'b 1111, // index[12] OTP_CTRL_DIRECT_ACCESS_RDATA_1
    4'b 0001, // index[13] OTP_CTRL_CHECK_TRIGGER_REGWEN
    4'b 0001, // index[14] OTP_CTRL_CHECK_TRIGGER
    4'b 0001, // index[15] OTP_CTRL_CHECK_REGWEN
    4'b 1111, // index[16] OTP_CTRL_CHECK_TIMEOUT
    4'b 1111, // index[17] OTP_CTRL_INTEGRITY_CHECK_PERIOD
    4'b 1111, // index[18] OTP_CTRL_CONSISTENCY_CHECK_PERIOD
    4'b 0001, // index[19] OTP_CTRL_CREATOR_SW_CFG_READ_LOCK
    4'b 0001, // index[20] OTP_CTRL_OWNER_SW_CFG_READ_LOCK
    4'b 1111, // index[21] OTP_CTRL_CREATOR_SW_CFG_DIGEST_0
    4'b 1111, // index[22] OTP_CTRL_CREATOR_SW_CFG_DIGEST_1
    4'b 1111, // index[23] OTP_CTRL_OWNER_SW_CFG_DIGEST_0
    4'b 1111, // index[24] OTP_CTRL_OWNER_SW_CFG_DIGEST_1
    4'b 1111, // index[25] OTP_CTRL_HW_CFG_DIGEST_0
    4'b 1111, // index[26] OTP_CTRL_HW_CFG_DIGEST_1
    4'b 1111, // index[27] OTP_CTRL_SECRET0_DIGEST_0
    4'b 1111, // index[28] OTP_CTRL_SECRET0_DIGEST_1
    4'b 1111, // index[29] OTP_CTRL_SECRET1_DIGEST_0
    4'b 1111, // index[30] OTP_CTRL_SECRET1_DIGEST_1
    4'b 1111, // index[31] OTP_CTRL_SECRET2_DIGEST_0
    4'b 1111, // index[32] OTP_CTRL_SECRET2_DIGEST_1
    4'b 1111, // index[33] OTP_CTRL_LC_STATE_0
    4'b 1111, // index[34] OTP_CTRL_LC_STATE_1
    4'b 1111, // index[35] OTP_CTRL_LC_STATE_2
    4'b 1111, // index[36] OTP_CTRL_LC_STATE_3
    4'b 1111, // index[37] OTP_CTRL_LC_STATE_4
    4'b 1111, // index[38] OTP_CTRL_LC_STATE_5
    4'b 1111  // index[39] OTP_CTRL_LC_TRANSITION_CNT
  };
endpackage

