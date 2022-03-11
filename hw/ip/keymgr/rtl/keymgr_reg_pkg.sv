// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package keymgr_reg_pkg;

  // Param list
  parameter int NumSaltReg = 8;
  parameter int NumSwBindingReg = 8;
  parameter int NumOutReg = 8;
  parameter int NumKeyVersion = 1;
  parameter int NumAlerts = 2;

  // Address widths within the block
  parameter int BlockAw = 8;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    logic        q;
  } keymgr_reg2hw_intr_state_reg_t;

  typedef struct packed {
    logic        q;
  } keymgr_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } keymgr_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } recov_operation_err;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_fault_err;
  } keymgr_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic        q;
  } keymgr_reg2hw_start_reg_t;

  typedef struct packed {
    struct packed {
      logic [2:0]  q;
      logic        err_update;
      logic        err_storage;
    } operation;
    struct packed {
      logic        q;
      logic        err_update;
      logic        err_storage;
    } cdi_sel;
    struct packed {
      logic [2:0]  q;
      logic        err_update;
      logic        err_storage;
    } dest_sel;
  } keymgr_reg2hw_control_shadowed_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } keymgr_reg2hw_sideload_clear_reg_t;

  typedef struct packed {
    logic [15:0] q;
    logic        err_update;
    logic        err_storage;
  } keymgr_reg2hw_reseed_interval_shadowed_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } keymgr_reg2hw_sw_binding_regwen_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } keymgr_reg2hw_sealing_sw_binding_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } keymgr_reg2hw_attest_sw_binding_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } keymgr_reg2hw_salt_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } keymgr_reg2hw_key_version_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        err_update;
    logic        err_storage;
  } keymgr_reg2hw_max_creator_key_ver_shadowed_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        err_update;
    logic        err_storage;
  } keymgr_reg2hw_max_owner_int_key_ver_shadowed_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        err_update;
    logic        err_storage;
  } keymgr_reg2hw_max_owner_key_ver_shadowed_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } cmd;
    struct packed {
      logic        q;
    } kmac_fsm;
    struct packed {
      logic        q;
    } kmac_done;
    struct packed {
      logic        q;
    } kmac_op;
    struct packed {
      logic        q;
    } kmac_out;
    struct packed {
      logic        q;
    } regfile_intg;
    struct packed {
      logic        q;
    } shadow;
    struct packed {
      logic        q;
    } ctrl_fsm_intg;
    struct packed {
      logic        q;
    } ctrl_fsm_cnt;
    struct packed {
      logic        q;
    } reseed_cnt;
    struct packed {
      logic        q;
    } side_ctrl_fsm;
  } keymgr_reg2hw_fault_status_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } keymgr_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
  } keymgr_hw2reg_cfg_regwen_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } keymgr_hw2reg_start_reg_t;

  typedef struct packed {
    logic        d;
  } keymgr_hw2reg_sw_binding_regwen_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } keymgr_hw2reg_sw_share0_output_mreg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } keymgr_hw2reg_sw_share1_output_mreg_t;

  typedef struct packed {
    logic [2:0]  d;
    logic        de;
  } keymgr_hw2reg_working_state_reg_t;

  typedef struct packed {
    logic [1:0]  d;
    logic        de;
  } keymgr_hw2reg_op_status_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } invalid_op;
    struct packed {
      logic        d;
      logic        de;
    } invalid_kmac_input;
    struct packed {
      logic        d;
      logic        de;
    } invalid_shadow_update;
  } keymgr_hw2reg_err_code_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } cmd;
    struct packed {
      logic        d;
      logic        de;
    } kmac_fsm;
    struct packed {
      logic        d;
      logic        de;
    } kmac_done;
    struct packed {
      logic        d;
      logic        de;
    } kmac_op;
    struct packed {
      logic        d;
      logic        de;
    } kmac_out;
    struct packed {
      logic        d;
      logic        de;
    } regfile_intg;
    struct packed {
      logic        d;
      logic        de;
    } shadow;
    struct packed {
      logic        d;
      logic        de;
    } ctrl_fsm_intg;
    struct packed {
      logic        d;
      logic        de;
    } ctrl_fsm_cnt;
    struct packed {
      logic        d;
      logic        de;
    } reseed_cnt;
    struct packed {
      logic        d;
      logic        de;
    } side_ctrl_fsm;
  } keymgr_hw2reg_fault_status_reg_t;

  // Register -> HW type
  typedef struct packed {
    keymgr_reg2hw_intr_state_reg_t intr_state; // [943:943]
    keymgr_reg2hw_intr_enable_reg_t intr_enable; // [942:942]
    keymgr_reg2hw_intr_test_reg_t intr_test; // [941:940]
    keymgr_reg2hw_alert_test_reg_t alert_test; // [939:936]
    keymgr_reg2hw_start_reg_t start; // [935:935]
    keymgr_reg2hw_control_shadowed_reg_t control_shadowed; // [934:928]
    keymgr_reg2hw_sideload_clear_reg_t sideload_clear; // [927:925]
    keymgr_reg2hw_reseed_interval_shadowed_reg_t reseed_interval_shadowed; // [924:909]
    keymgr_reg2hw_sw_binding_regwen_reg_t sw_binding_regwen; // [908:907]
    keymgr_reg2hw_sealing_sw_binding_mreg_t [7:0] sealing_sw_binding; // [906:651]
    keymgr_reg2hw_attest_sw_binding_mreg_t [7:0] attest_sw_binding; // [650:395]
    keymgr_reg2hw_salt_mreg_t [7:0] salt; // [394:139]
    keymgr_reg2hw_key_version_mreg_t [0:0] key_version; // [138:107]
    keymgr_reg2hw_max_creator_key_ver_shadowed_reg_t max_creator_key_ver_shadowed; // [106:75]
    keymgr_reg2hw_max_owner_int_key_ver_shadowed_reg_t max_owner_int_key_ver_shadowed; // [74:43]
    keymgr_reg2hw_max_owner_key_ver_shadowed_reg_t max_owner_key_ver_shadowed; // [42:11]
    keymgr_reg2hw_fault_status_reg_t fault_status; // [10:0]
  } keymgr_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    keymgr_hw2reg_intr_state_reg_t intr_state; // [568:567]
    keymgr_hw2reg_cfg_regwen_reg_t cfg_regwen; // [566:566]
    keymgr_hw2reg_start_reg_t start; // [565:564]
    keymgr_hw2reg_sw_binding_regwen_reg_t sw_binding_regwen; // [563:563]
    keymgr_hw2reg_sw_share0_output_mreg_t [7:0] sw_share0_output; // [562:299]
    keymgr_hw2reg_sw_share1_output_mreg_t [7:0] sw_share1_output; // [298:35]
    keymgr_hw2reg_working_state_reg_t working_state; // [34:31]
    keymgr_hw2reg_op_status_reg_t op_status; // [30:28]
    keymgr_hw2reg_err_code_reg_t err_code; // [27:22]
    keymgr_hw2reg_fault_status_reg_t fault_status; // [21:0]
  } keymgr_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] KEYMGR_INTR_STATE_OFFSET = 8'h 0;
  parameter logic [BlockAw-1:0] KEYMGR_INTR_ENABLE_OFFSET = 8'h 4;
  parameter logic [BlockAw-1:0] KEYMGR_INTR_TEST_OFFSET = 8'h 8;
  parameter logic [BlockAw-1:0] KEYMGR_ALERT_TEST_OFFSET = 8'h c;
  parameter logic [BlockAw-1:0] KEYMGR_CFG_REGWEN_OFFSET = 8'h 10;
  parameter logic [BlockAw-1:0] KEYMGR_START_OFFSET = 8'h 14;
  parameter logic [BlockAw-1:0] KEYMGR_CONTROL_SHADOWED_OFFSET = 8'h 18;
  parameter logic [BlockAw-1:0] KEYMGR_SIDELOAD_CLEAR_OFFSET = 8'h 1c;
  parameter logic [BlockAw-1:0] KEYMGR_RESEED_INTERVAL_REGWEN_OFFSET = 8'h 20;
  parameter logic [BlockAw-1:0] KEYMGR_RESEED_INTERVAL_SHADOWED_OFFSET = 8'h 24;
  parameter logic [BlockAw-1:0] KEYMGR_SW_BINDING_REGWEN_OFFSET = 8'h 28;
  parameter logic [BlockAw-1:0] KEYMGR_SEALING_SW_BINDING_0_OFFSET = 8'h 2c;
  parameter logic [BlockAw-1:0] KEYMGR_SEALING_SW_BINDING_1_OFFSET = 8'h 30;
  parameter logic [BlockAw-1:0] KEYMGR_SEALING_SW_BINDING_2_OFFSET = 8'h 34;
  parameter logic [BlockAw-1:0] KEYMGR_SEALING_SW_BINDING_3_OFFSET = 8'h 38;
  parameter logic [BlockAw-1:0] KEYMGR_SEALING_SW_BINDING_4_OFFSET = 8'h 3c;
  parameter logic [BlockAw-1:0] KEYMGR_SEALING_SW_BINDING_5_OFFSET = 8'h 40;
  parameter logic [BlockAw-1:0] KEYMGR_SEALING_SW_BINDING_6_OFFSET = 8'h 44;
  parameter logic [BlockAw-1:0] KEYMGR_SEALING_SW_BINDING_7_OFFSET = 8'h 48;
  parameter logic [BlockAw-1:0] KEYMGR_ATTEST_SW_BINDING_0_OFFSET = 8'h 4c;
  parameter logic [BlockAw-1:0] KEYMGR_ATTEST_SW_BINDING_1_OFFSET = 8'h 50;
  parameter logic [BlockAw-1:0] KEYMGR_ATTEST_SW_BINDING_2_OFFSET = 8'h 54;
  parameter logic [BlockAw-1:0] KEYMGR_ATTEST_SW_BINDING_3_OFFSET = 8'h 58;
  parameter logic [BlockAw-1:0] KEYMGR_ATTEST_SW_BINDING_4_OFFSET = 8'h 5c;
  parameter logic [BlockAw-1:0] KEYMGR_ATTEST_SW_BINDING_5_OFFSET = 8'h 60;
  parameter logic [BlockAw-1:0] KEYMGR_ATTEST_SW_BINDING_6_OFFSET = 8'h 64;
  parameter logic [BlockAw-1:0] KEYMGR_ATTEST_SW_BINDING_7_OFFSET = 8'h 68;
  parameter logic [BlockAw-1:0] KEYMGR_SALT_0_OFFSET = 8'h 6c;
  parameter logic [BlockAw-1:0] KEYMGR_SALT_1_OFFSET = 8'h 70;
  parameter logic [BlockAw-1:0] KEYMGR_SALT_2_OFFSET = 8'h 74;
  parameter logic [BlockAw-1:0] KEYMGR_SALT_3_OFFSET = 8'h 78;
  parameter logic [BlockAw-1:0] KEYMGR_SALT_4_OFFSET = 8'h 7c;
  parameter logic [BlockAw-1:0] KEYMGR_SALT_5_OFFSET = 8'h 80;
  parameter logic [BlockAw-1:0] KEYMGR_SALT_6_OFFSET = 8'h 84;
  parameter logic [BlockAw-1:0] KEYMGR_SALT_7_OFFSET = 8'h 88;
  parameter logic [BlockAw-1:0] KEYMGR_KEY_VERSION_OFFSET = 8'h 8c;
  parameter logic [BlockAw-1:0] KEYMGR_MAX_CREATOR_KEY_VER_REGWEN_OFFSET = 8'h 90;
  parameter logic [BlockAw-1:0] KEYMGR_MAX_CREATOR_KEY_VER_SHADOWED_OFFSET = 8'h 94;
  parameter logic [BlockAw-1:0] KEYMGR_MAX_OWNER_INT_KEY_VER_REGWEN_OFFSET = 8'h 98;
  parameter logic [BlockAw-1:0] KEYMGR_MAX_OWNER_INT_KEY_VER_SHADOWED_OFFSET = 8'h 9c;
  parameter logic [BlockAw-1:0] KEYMGR_MAX_OWNER_KEY_VER_REGWEN_OFFSET = 8'h a0;
  parameter logic [BlockAw-1:0] KEYMGR_MAX_OWNER_KEY_VER_SHADOWED_OFFSET = 8'h a4;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE0_OUTPUT_0_OFFSET = 8'h a8;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE0_OUTPUT_1_OFFSET = 8'h ac;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE0_OUTPUT_2_OFFSET = 8'h b0;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE0_OUTPUT_3_OFFSET = 8'h b4;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE0_OUTPUT_4_OFFSET = 8'h b8;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE0_OUTPUT_5_OFFSET = 8'h bc;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE0_OUTPUT_6_OFFSET = 8'h c0;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE0_OUTPUT_7_OFFSET = 8'h c4;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE1_OUTPUT_0_OFFSET = 8'h c8;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE1_OUTPUT_1_OFFSET = 8'h cc;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE1_OUTPUT_2_OFFSET = 8'h d0;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE1_OUTPUT_3_OFFSET = 8'h d4;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE1_OUTPUT_4_OFFSET = 8'h d8;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE1_OUTPUT_5_OFFSET = 8'h dc;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE1_OUTPUT_6_OFFSET = 8'h e0;
  parameter logic [BlockAw-1:0] KEYMGR_SW_SHARE1_OUTPUT_7_OFFSET = 8'h e4;
  parameter logic [BlockAw-1:0] KEYMGR_WORKING_STATE_OFFSET = 8'h e8;
  parameter logic [BlockAw-1:0] KEYMGR_OP_STATUS_OFFSET = 8'h ec;
  parameter logic [BlockAw-1:0] KEYMGR_ERR_CODE_OFFSET = 8'h f0;
  parameter logic [BlockAw-1:0] KEYMGR_FAULT_STATUS_OFFSET = 8'h f4;

  // Reset values for hwext registers and their fields
  parameter logic [0:0] KEYMGR_INTR_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] KEYMGR_INTR_TEST_OP_DONE_RESVAL = 1'h 0;
  parameter logic [1:0] KEYMGR_ALERT_TEST_RESVAL = 2'h 0;
  parameter logic [0:0] KEYMGR_ALERT_TEST_RECOV_OPERATION_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] KEYMGR_ALERT_TEST_FATAL_FAULT_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] KEYMGR_CFG_REGWEN_RESVAL = 1'h 1;
  parameter logic [0:0] KEYMGR_CFG_REGWEN_EN_RESVAL = 1'h 1;
  parameter logic [0:0] KEYMGR_SW_BINDING_REGWEN_RESVAL = 1'h 1;
  parameter logic [0:0] KEYMGR_SW_BINDING_REGWEN_EN_RESVAL = 1'h 1;

  // Register index
  typedef enum int {
    KEYMGR_INTR_STATE,
    KEYMGR_INTR_ENABLE,
    KEYMGR_INTR_TEST,
    KEYMGR_ALERT_TEST,
    KEYMGR_CFG_REGWEN,
    KEYMGR_START,
    KEYMGR_CONTROL_SHADOWED,
    KEYMGR_SIDELOAD_CLEAR,
    KEYMGR_RESEED_INTERVAL_REGWEN,
    KEYMGR_RESEED_INTERVAL_SHADOWED,
    KEYMGR_SW_BINDING_REGWEN,
    KEYMGR_SEALING_SW_BINDING_0,
    KEYMGR_SEALING_SW_BINDING_1,
    KEYMGR_SEALING_SW_BINDING_2,
    KEYMGR_SEALING_SW_BINDING_3,
    KEYMGR_SEALING_SW_BINDING_4,
    KEYMGR_SEALING_SW_BINDING_5,
    KEYMGR_SEALING_SW_BINDING_6,
    KEYMGR_SEALING_SW_BINDING_7,
    KEYMGR_ATTEST_SW_BINDING_0,
    KEYMGR_ATTEST_SW_BINDING_1,
    KEYMGR_ATTEST_SW_BINDING_2,
    KEYMGR_ATTEST_SW_BINDING_3,
    KEYMGR_ATTEST_SW_BINDING_4,
    KEYMGR_ATTEST_SW_BINDING_5,
    KEYMGR_ATTEST_SW_BINDING_6,
    KEYMGR_ATTEST_SW_BINDING_7,
    KEYMGR_SALT_0,
    KEYMGR_SALT_1,
    KEYMGR_SALT_2,
    KEYMGR_SALT_3,
    KEYMGR_SALT_4,
    KEYMGR_SALT_5,
    KEYMGR_SALT_6,
    KEYMGR_SALT_7,
    KEYMGR_KEY_VERSION,
    KEYMGR_MAX_CREATOR_KEY_VER_REGWEN,
    KEYMGR_MAX_CREATOR_KEY_VER_SHADOWED,
    KEYMGR_MAX_OWNER_INT_KEY_VER_REGWEN,
    KEYMGR_MAX_OWNER_INT_KEY_VER_SHADOWED,
    KEYMGR_MAX_OWNER_KEY_VER_REGWEN,
    KEYMGR_MAX_OWNER_KEY_VER_SHADOWED,
    KEYMGR_SW_SHARE0_OUTPUT_0,
    KEYMGR_SW_SHARE0_OUTPUT_1,
    KEYMGR_SW_SHARE0_OUTPUT_2,
    KEYMGR_SW_SHARE0_OUTPUT_3,
    KEYMGR_SW_SHARE0_OUTPUT_4,
    KEYMGR_SW_SHARE0_OUTPUT_5,
    KEYMGR_SW_SHARE0_OUTPUT_6,
    KEYMGR_SW_SHARE0_OUTPUT_7,
    KEYMGR_SW_SHARE1_OUTPUT_0,
    KEYMGR_SW_SHARE1_OUTPUT_1,
    KEYMGR_SW_SHARE1_OUTPUT_2,
    KEYMGR_SW_SHARE1_OUTPUT_3,
    KEYMGR_SW_SHARE1_OUTPUT_4,
    KEYMGR_SW_SHARE1_OUTPUT_5,
    KEYMGR_SW_SHARE1_OUTPUT_6,
    KEYMGR_SW_SHARE1_OUTPUT_7,
    KEYMGR_WORKING_STATE,
    KEYMGR_OP_STATUS,
    KEYMGR_ERR_CODE,
    KEYMGR_FAULT_STATUS
  } keymgr_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] KEYMGR_PERMIT [62] = '{
    4'b 0001, // index[ 0] KEYMGR_INTR_STATE
    4'b 0001, // index[ 1] KEYMGR_INTR_ENABLE
    4'b 0001, // index[ 2] KEYMGR_INTR_TEST
    4'b 0001, // index[ 3] KEYMGR_ALERT_TEST
    4'b 0001, // index[ 4] KEYMGR_CFG_REGWEN
    4'b 0001, // index[ 5] KEYMGR_START
    4'b 0011, // index[ 6] KEYMGR_CONTROL_SHADOWED
    4'b 0001, // index[ 7] KEYMGR_SIDELOAD_CLEAR
    4'b 0001, // index[ 8] KEYMGR_RESEED_INTERVAL_REGWEN
    4'b 0011, // index[ 9] KEYMGR_RESEED_INTERVAL_SHADOWED
    4'b 0001, // index[10] KEYMGR_SW_BINDING_REGWEN
    4'b 1111, // index[11] KEYMGR_SEALING_SW_BINDING_0
    4'b 1111, // index[12] KEYMGR_SEALING_SW_BINDING_1
    4'b 1111, // index[13] KEYMGR_SEALING_SW_BINDING_2
    4'b 1111, // index[14] KEYMGR_SEALING_SW_BINDING_3
    4'b 1111, // index[15] KEYMGR_SEALING_SW_BINDING_4
    4'b 1111, // index[16] KEYMGR_SEALING_SW_BINDING_5
    4'b 1111, // index[17] KEYMGR_SEALING_SW_BINDING_6
    4'b 1111, // index[18] KEYMGR_SEALING_SW_BINDING_7
    4'b 1111, // index[19] KEYMGR_ATTEST_SW_BINDING_0
    4'b 1111, // index[20] KEYMGR_ATTEST_SW_BINDING_1
    4'b 1111, // index[21] KEYMGR_ATTEST_SW_BINDING_2
    4'b 1111, // index[22] KEYMGR_ATTEST_SW_BINDING_3
    4'b 1111, // index[23] KEYMGR_ATTEST_SW_BINDING_4
    4'b 1111, // index[24] KEYMGR_ATTEST_SW_BINDING_5
    4'b 1111, // index[25] KEYMGR_ATTEST_SW_BINDING_6
    4'b 1111, // index[26] KEYMGR_ATTEST_SW_BINDING_7
    4'b 1111, // index[27] KEYMGR_SALT_0
    4'b 1111, // index[28] KEYMGR_SALT_1
    4'b 1111, // index[29] KEYMGR_SALT_2
    4'b 1111, // index[30] KEYMGR_SALT_3
    4'b 1111, // index[31] KEYMGR_SALT_4
    4'b 1111, // index[32] KEYMGR_SALT_5
    4'b 1111, // index[33] KEYMGR_SALT_6
    4'b 1111, // index[34] KEYMGR_SALT_7
    4'b 1111, // index[35] KEYMGR_KEY_VERSION
    4'b 0001, // index[36] KEYMGR_MAX_CREATOR_KEY_VER_REGWEN
    4'b 1111, // index[37] KEYMGR_MAX_CREATOR_KEY_VER_SHADOWED
    4'b 0001, // index[38] KEYMGR_MAX_OWNER_INT_KEY_VER_REGWEN
    4'b 1111, // index[39] KEYMGR_MAX_OWNER_INT_KEY_VER_SHADOWED
    4'b 0001, // index[40] KEYMGR_MAX_OWNER_KEY_VER_REGWEN
    4'b 1111, // index[41] KEYMGR_MAX_OWNER_KEY_VER_SHADOWED
    4'b 1111, // index[42] KEYMGR_SW_SHARE0_OUTPUT_0
    4'b 1111, // index[43] KEYMGR_SW_SHARE0_OUTPUT_1
    4'b 1111, // index[44] KEYMGR_SW_SHARE0_OUTPUT_2
    4'b 1111, // index[45] KEYMGR_SW_SHARE0_OUTPUT_3
    4'b 1111, // index[46] KEYMGR_SW_SHARE0_OUTPUT_4
    4'b 1111, // index[47] KEYMGR_SW_SHARE0_OUTPUT_5
    4'b 1111, // index[48] KEYMGR_SW_SHARE0_OUTPUT_6
    4'b 1111, // index[49] KEYMGR_SW_SHARE0_OUTPUT_7
    4'b 1111, // index[50] KEYMGR_SW_SHARE1_OUTPUT_0
    4'b 1111, // index[51] KEYMGR_SW_SHARE1_OUTPUT_1
    4'b 1111, // index[52] KEYMGR_SW_SHARE1_OUTPUT_2
    4'b 1111, // index[53] KEYMGR_SW_SHARE1_OUTPUT_3
    4'b 1111, // index[54] KEYMGR_SW_SHARE1_OUTPUT_4
    4'b 1111, // index[55] KEYMGR_SW_SHARE1_OUTPUT_5
    4'b 1111, // index[56] KEYMGR_SW_SHARE1_OUTPUT_6
    4'b 1111, // index[57] KEYMGR_SW_SHARE1_OUTPUT_7
    4'b 0001, // index[58] KEYMGR_WORKING_STATE
    4'b 0001, // index[59] KEYMGR_OP_STATUS
    4'b 0001, // index[60] KEYMGR_ERR_CODE
    4'b 0011  // index[61] KEYMGR_FAULT_STATUS
  };

endpackage

