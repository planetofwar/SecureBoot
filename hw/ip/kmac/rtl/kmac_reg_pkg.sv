// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package kmac_reg_pkg;

  // Param list
  parameter int NumWordsKey = 16;
  parameter int NumWordsPrefix = 11;
  parameter int unsigned HashCntW = 10;
  parameter int NumAlerts = 2;

  // Address widths within the block
  parameter int BlockAw = 12;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } kmac_done;
    struct packed {
      logic        q;
    } fifo_empty;
    struct packed {
      logic        q;
    } kmac_err;
  } kmac_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } kmac_done;
    struct packed {
      logic        q;
    } fifo_empty;
    struct packed {
      logic        q;
    } kmac_err;
  } kmac_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } kmac_done;
    struct packed {
      logic        q;
      logic        qe;
    } fifo_empty;
    struct packed {
      logic        q;
      logic        qe;
    } kmac_err;
  } kmac_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } fatal_fault_err;
    struct packed {
      logic        q;
      logic        qe;
    } recov_operation_err;
  } kmac_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } kmac_en;
    struct packed {
      logic [2:0]  q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } kstrength;
    struct packed {
      logic [1:0]  q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } mode;
    struct packed {
      logic        q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } msg_endianness;
    struct packed {
      logic        q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } state_endianness;
    struct packed {
      logic        q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } sideload;
    struct packed {
      logic [1:0]  q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } entropy_mode;
    struct packed {
      logic        q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } entropy_fast_process;
    struct packed {
      logic        q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } entropy_ready;
    struct packed {
      logic        q;
      logic        qe;
      logic        err_update;
      logic        err_storage;
    } err_processed;
  } kmac_reg2hw_cfg_shadowed_reg_t;

  typedef struct packed {
    struct packed {
      logic [3:0]  q;
      logic        qe;
    } cmd;
    struct packed {
      logic        q;
      logic        qe;
    } entropy_req;
    struct packed {
      logic        q;
      logic        qe;
    } hash_cnt_clr;
  } kmac_reg2hw_cmd_reg_t;

  typedef struct packed {
    struct packed {
      logic [9:0] q;
    } prescaler;
    struct packed {
      logic [15:0] q;
    } wait_timer;
  } kmac_reg2hw_entropy_period_reg_t;

  typedef struct packed {
    struct packed {
      logic [9:0] q;
    } threshold;
  } kmac_reg2hw_entropy_refresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } kmac_reg2hw_entropy_seed_lower_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } kmac_reg2hw_entropy_seed_upper_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } kmac_reg2hw_key_share0_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } kmac_reg2hw_key_share1_mreg_t;

  typedef struct packed {
    logic [2:0]  q;
  } kmac_reg2hw_key_len_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } kmac_reg2hw_prefix_mreg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } kmac_done;
    struct packed {
      logic        d;
      logic        de;
    } fifo_empty;
    struct packed {
      logic        d;
      logic        de;
    } kmac_err;
  } kmac_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
  } kmac_hw2reg_cfg_regwen_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } sha3_idle;
    struct packed {
      logic        d;
    } sha3_absorb;
    struct packed {
      logic        d;
    } sha3_squeeze;
    struct packed {
      logic [4:0]  d;
    } fifo_depth;
    struct packed {
      logic        d;
    } fifo_empty;
    struct packed {
      logic        d;
    } fifo_full;
  } kmac_hw2reg_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [9:0] d;
      logic        de;
    } hash_cnt;
  } kmac_hw2reg_entropy_refresh_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } kmac_hw2reg_err_code_reg_t;

  // Register -> HW type
  typedef struct packed {
    kmac_reg2hw_intr_state_reg_t intr_state; // [1561:1559]
    kmac_reg2hw_intr_enable_reg_t intr_enable; // [1558:1556]
    kmac_reg2hw_intr_test_reg_t intr_test; // [1555:1550]
    kmac_reg2hw_alert_test_reg_t alert_test; // [1549:1546]
    kmac_reg2hw_cfg_shadowed_reg_t cfg_shadowed; // [1545:1522]
    kmac_reg2hw_cmd_reg_t cmd; // [1521:1513]
    kmac_reg2hw_entropy_period_reg_t entropy_period; // [1512:1487]
    kmac_reg2hw_entropy_refresh_reg_t entropy_refresh; // [1486:1477]
    kmac_reg2hw_entropy_seed_lower_reg_t entropy_seed_lower; // [1476:1444]
    kmac_reg2hw_entropy_seed_upper_reg_t entropy_seed_upper; // [1443:1411]
    kmac_reg2hw_key_share0_mreg_t [15:0] key_share0; // [1410:883]
    kmac_reg2hw_key_share1_mreg_t [15:0] key_share1; // [882:355]
    kmac_reg2hw_key_len_reg_t key_len; // [354:352]
    kmac_reg2hw_prefix_mreg_t [10:0] prefix; // [351:0]
  } kmac_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    kmac_hw2reg_intr_state_reg_t intr_state; // [60:55]
    kmac_hw2reg_cfg_regwen_reg_t cfg_regwen; // [54:54]
    kmac_hw2reg_status_reg_t status; // [53:44]
    kmac_hw2reg_entropy_refresh_reg_t entropy_refresh; // [43:33]
    kmac_hw2reg_err_code_reg_t err_code; // [32:0]
  } kmac_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] KMAC_INTR_STATE_OFFSET = 12'h 0;
  parameter logic [BlockAw-1:0] KMAC_INTR_ENABLE_OFFSET = 12'h 4;
  parameter logic [BlockAw-1:0] KMAC_INTR_TEST_OFFSET = 12'h 8;
  parameter logic [BlockAw-1:0] KMAC_ALERT_TEST_OFFSET = 12'h c;
  parameter logic [BlockAw-1:0] KMAC_CFG_REGWEN_OFFSET = 12'h 10;
  parameter logic [BlockAw-1:0] KMAC_CFG_SHADOWED_OFFSET = 12'h 14;
  parameter logic [BlockAw-1:0] KMAC_CMD_OFFSET = 12'h 18;
  parameter logic [BlockAw-1:0] KMAC_STATUS_OFFSET = 12'h 1c;
  parameter logic [BlockAw-1:0] KMAC_ENTROPY_PERIOD_OFFSET = 12'h 20;
  parameter logic [BlockAw-1:0] KMAC_ENTROPY_REFRESH_OFFSET = 12'h 24;
  parameter logic [BlockAw-1:0] KMAC_ENTROPY_SEED_LOWER_OFFSET = 12'h 28;
  parameter logic [BlockAw-1:0] KMAC_ENTROPY_SEED_UPPER_OFFSET = 12'h 2c;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_0_OFFSET = 12'h 30;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_1_OFFSET = 12'h 34;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_2_OFFSET = 12'h 38;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_3_OFFSET = 12'h 3c;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_4_OFFSET = 12'h 40;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_5_OFFSET = 12'h 44;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_6_OFFSET = 12'h 48;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_7_OFFSET = 12'h 4c;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_8_OFFSET = 12'h 50;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_9_OFFSET = 12'h 54;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_10_OFFSET = 12'h 58;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_11_OFFSET = 12'h 5c;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_12_OFFSET = 12'h 60;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_13_OFFSET = 12'h 64;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_14_OFFSET = 12'h 68;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE0_15_OFFSET = 12'h 6c;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_0_OFFSET = 12'h 70;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_1_OFFSET = 12'h 74;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_2_OFFSET = 12'h 78;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_3_OFFSET = 12'h 7c;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_4_OFFSET = 12'h 80;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_5_OFFSET = 12'h 84;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_6_OFFSET = 12'h 88;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_7_OFFSET = 12'h 8c;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_8_OFFSET = 12'h 90;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_9_OFFSET = 12'h 94;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_10_OFFSET = 12'h 98;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_11_OFFSET = 12'h 9c;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_12_OFFSET = 12'h a0;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_13_OFFSET = 12'h a4;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_14_OFFSET = 12'h a8;
  parameter logic [BlockAw-1:0] KMAC_KEY_SHARE1_15_OFFSET = 12'h ac;
  parameter logic [BlockAw-1:0] KMAC_KEY_LEN_OFFSET = 12'h b0;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_0_OFFSET = 12'h b4;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_1_OFFSET = 12'h b8;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_2_OFFSET = 12'h bc;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_3_OFFSET = 12'h c0;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_4_OFFSET = 12'h c4;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_5_OFFSET = 12'h c8;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_6_OFFSET = 12'h cc;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_7_OFFSET = 12'h d0;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_8_OFFSET = 12'h d4;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_9_OFFSET = 12'h d8;
  parameter logic [BlockAw-1:0] KMAC_PREFIX_10_OFFSET = 12'h dc;
  parameter logic [BlockAw-1:0] KMAC_ERR_CODE_OFFSET = 12'h e0;

  // Reset values for hwext registers and their fields
  parameter logic [2:0] KMAC_INTR_TEST_RESVAL = 3'h 0;
  parameter logic [0:0] KMAC_INTR_TEST_KMAC_DONE_RESVAL = 1'h 0;
  parameter logic [0:0] KMAC_INTR_TEST_FIFO_EMPTY_RESVAL = 1'h 0;
  parameter logic [0:0] KMAC_INTR_TEST_KMAC_ERR_RESVAL = 1'h 0;
  parameter logic [1:0] KMAC_ALERT_TEST_RESVAL = 2'h 0;
  parameter logic [0:0] KMAC_ALERT_TEST_FATAL_FAULT_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] KMAC_ALERT_TEST_RECOV_OPERATION_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] KMAC_CFG_REGWEN_RESVAL = 1'h 1;
  parameter logic [0:0] KMAC_CFG_REGWEN_EN_RESVAL = 1'h 1;
  parameter logic [9:0] KMAC_CMD_RESVAL = 10'h 0;
  parameter logic [15:0] KMAC_STATUS_RESVAL = 16'h 4001;
  parameter logic [0:0] KMAC_STATUS_SHA3_IDLE_RESVAL = 1'h 1;
  parameter logic [0:0] KMAC_STATUS_FIFO_EMPTY_RESVAL = 1'h 1;
  parameter logic [31:0] KMAC_KEY_SHARE0_0_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_1_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_2_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_3_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_4_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_5_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_6_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_7_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_8_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_9_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_10_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_11_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_12_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_13_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_14_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE0_15_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_0_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_1_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_2_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_3_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_4_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_5_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_6_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_7_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_8_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_9_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_10_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_11_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_12_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_13_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_14_RESVAL = 32'h 0;
  parameter logic [31:0] KMAC_KEY_SHARE1_15_RESVAL = 32'h 0;

  // Window parameters
  parameter logic [BlockAw-1:0] KMAC_STATE_OFFSET = 12'h 400;
  parameter int unsigned        KMAC_STATE_SIZE   = 'h 200;
  parameter logic [BlockAw-1:0] KMAC_MSG_FIFO_OFFSET = 12'h 800;
  parameter int unsigned        KMAC_MSG_FIFO_SIZE   = 'h 800;

  // Register index
  typedef enum int {
    KMAC_INTR_STATE,
    KMAC_INTR_ENABLE,
    KMAC_INTR_TEST,
    KMAC_ALERT_TEST,
    KMAC_CFG_REGWEN,
    KMAC_CFG_SHADOWED,
    KMAC_CMD,
    KMAC_STATUS,
    KMAC_ENTROPY_PERIOD,
    KMAC_ENTROPY_REFRESH,
    KMAC_ENTROPY_SEED_LOWER,
    KMAC_ENTROPY_SEED_UPPER,
    KMAC_KEY_SHARE0_0,
    KMAC_KEY_SHARE0_1,
    KMAC_KEY_SHARE0_2,
    KMAC_KEY_SHARE0_3,
    KMAC_KEY_SHARE0_4,
    KMAC_KEY_SHARE0_5,
    KMAC_KEY_SHARE0_6,
    KMAC_KEY_SHARE0_7,
    KMAC_KEY_SHARE0_8,
    KMAC_KEY_SHARE0_9,
    KMAC_KEY_SHARE0_10,
    KMAC_KEY_SHARE0_11,
    KMAC_KEY_SHARE0_12,
    KMAC_KEY_SHARE0_13,
    KMAC_KEY_SHARE0_14,
    KMAC_KEY_SHARE0_15,
    KMAC_KEY_SHARE1_0,
    KMAC_KEY_SHARE1_1,
    KMAC_KEY_SHARE1_2,
    KMAC_KEY_SHARE1_3,
    KMAC_KEY_SHARE1_4,
    KMAC_KEY_SHARE1_5,
    KMAC_KEY_SHARE1_6,
    KMAC_KEY_SHARE1_7,
    KMAC_KEY_SHARE1_8,
    KMAC_KEY_SHARE1_9,
    KMAC_KEY_SHARE1_10,
    KMAC_KEY_SHARE1_11,
    KMAC_KEY_SHARE1_12,
    KMAC_KEY_SHARE1_13,
    KMAC_KEY_SHARE1_14,
    KMAC_KEY_SHARE1_15,
    KMAC_KEY_LEN,
    KMAC_PREFIX_0,
    KMAC_PREFIX_1,
    KMAC_PREFIX_2,
    KMAC_PREFIX_3,
    KMAC_PREFIX_4,
    KMAC_PREFIX_5,
    KMAC_PREFIX_6,
    KMAC_PREFIX_7,
    KMAC_PREFIX_8,
    KMAC_PREFIX_9,
    KMAC_PREFIX_10,
    KMAC_ERR_CODE
  } kmac_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] KMAC_PERMIT [57] = '{
    4'b 0001, // index[ 0] KMAC_INTR_STATE
    4'b 0001, // index[ 1] KMAC_INTR_ENABLE
    4'b 0001, // index[ 2] KMAC_INTR_TEST
    4'b 0001, // index[ 3] KMAC_ALERT_TEST
    4'b 0001, // index[ 4] KMAC_CFG_REGWEN
    4'b 1111, // index[ 5] KMAC_CFG_SHADOWED
    4'b 0011, // index[ 6] KMAC_CMD
    4'b 0011, // index[ 7] KMAC_STATUS
    4'b 1111, // index[ 8] KMAC_ENTROPY_PERIOD
    4'b 1111, // index[ 9] KMAC_ENTROPY_REFRESH
    4'b 1111, // index[10] KMAC_ENTROPY_SEED_LOWER
    4'b 1111, // index[11] KMAC_ENTROPY_SEED_UPPER
    4'b 1111, // index[12] KMAC_KEY_SHARE0_0
    4'b 1111, // index[13] KMAC_KEY_SHARE0_1
    4'b 1111, // index[14] KMAC_KEY_SHARE0_2
    4'b 1111, // index[15] KMAC_KEY_SHARE0_3
    4'b 1111, // index[16] KMAC_KEY_SHARE0_4
    4'b 1111, // index[17] KMAC_KEY_SHARE0_5
    4'b 1111, // index[18] KMAC_KEY_SHARE0_6
    4'b 1111, // index[19] KMAC_KEY_SHARE0_7
    4'b 1111, // index[20] KMAC_KEY_SHARE0_8
    4'b 1111, // index[21] KMAC_KEY_SHARE0_9
    4'b 1111, // index[22] KMAC_KEY_SHARE0_10
    4'b 1111, // index[23] KMAC_KEY_SHARE0_11
    4'b 1111, // index[24] KMAC_KEY_SHARE0_12
    4'b 1111, // index[25] KMAC_KEY_SHARE0_13
    4'b 1111, // index[26] KMAC_KEY_SHARE0_14
    4'b 1111, // index[27] KMAC_KEY_SHARE0_15
    4'b 1111, // index[28] KMAC_KEY_SHARE1_0
    4'b 1111, // index[29] KMAC_KEY_SHARE1_1
    4'b 1111, // index[30] KMAC_KEY_SHARE1_2
    4'b 1111, // index[31] KMAC_KEY_SHARE1_3
    4'b 1111, // index[32] KMAC_KEY_SHARE1_4
    4'b 1111, // index[33] KMAC_KEY_SHARE1_5
    4'b 1111, // index[34] KMAC_KEY_SHARE1_6
    4'b 1111, // index[35] KMAC_KEY_SHARE1_7
    4'b 1111, // index[36] KMAC_KEY_SHARE1_8
    4'b 1111, // index[37] KMAC_KEY_SHARE1_9
    4'b 1111, // index[38] KMAC_KEY_SHARE1_10
    4'b 1111, // index[39] KMAC_KEY_SHARE1_11
    4'b 1111, // index[40] KMAC_KEY_SHARE1_12
    4'b 1111, // index[41] KMAC_KEY_SHARE1_13
    4'b 1111, // index[42] KMAC_KEY_SHARE1_14
    4'b 1111, // index[43] KMAC_KEY_SHARE1_15
    4'b 0001, // index[44] KMAC_KEY_LEN
    4'b 1111, // index[45] KMAC_PREFIX_0
    4'b 1111, // index[46] KMAC_PREFIX_1
    4'b 1111, // index[47] KMAC_PREFIX_2
    4'b 1111, // index[48] KMAC_PREFIX_3
    4'b 1111, // index[49] KMAC_PREFIX_4
    4'b 1111, // index[50] KMAC_PREFIX_5
    4'b 1111, // index[51] KMAC_PREFIX_6
    4'b 1111, // index[52] KMAC_PREFIX_7
    4'b 1111, // index[53] KMAC_PREFIX_8
    4'b 1111, // index[54] KMAC_PREFIX_9
    4'b 1111, // index[55] KMAC_PREFIX_10
    4'b 1111  // index[56] KMAC_ERR_CODE
  };

endpackage

