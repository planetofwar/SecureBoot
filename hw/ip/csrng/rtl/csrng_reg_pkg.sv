// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package csrng_reg_pkg;

  // Param list
  parameter int NHwApps = 2;
  parameter int NumAlerts = 1;

  // Address width within the block
  parameter int BlockAw = 6;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } cs_cmd_req_done;
    struct packed {
      logic        q;
    } cs_entropy_req;
    struct packed {
      logic        q;
    } cs_hw_inst_exc;
    struct packed {
      logic        q;
    } cs_fatal_err;
  } csrng_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } cs_cmd_req_done;
    struct packed {
      logic        q;
    } cs_entropy_req;
    struct packed {
      logic        q;
    } cs_hw_inst_exc;
    struct packed {
      logic        q;
    } cs_fatal_err;
  } csrng_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } cs_cmd_req_done;
    struct packed {
      logic        q;
      logic        qe;
    } cs_entropy_req;
    struct packed {
      logic        q;
      logic        qe;
    } cs_hw_inst_exc;
    struct packed {
      logic        q;
      logic        qe;
    } cs_fatal_err;
  } csrng_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } csrng_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic        q;
  } csrng_reg2hw_regwen_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } enable;
    struct packed {
      logic        q;
    } aes_cipher_disable;
    struct packed {
      logic [3:0]  q;
    } fifo_depth_sts_sel;
  } csrng_reg2hw_ctrl_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } csrng_reg2hw_cmd_req_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        re;
  } csrng_reg2hw_genbits_reg_t;

  typedef struct packed {
    logic [3:0]  q;
    logic        qe;
  } csrng_reg2hw_int_state_num_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        re;
  } csrng_reg2hw_int_state_val_reg_t;

  typedef struct packed {
    logic [4:0]  q;
    logic        qe;
  } csrng_reg2hw_err_code_test_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } cs_cmd_req_done;
    struct packed {
      logic        d;
      logic        de;
    } cs_entropy_req;
    struct packed {
      logic        d;
      logic        de;
    } cs_hw_inst_exc;
    struct packed {
      logic        d;
      logic        de;
    } cs_fatal_err;
  } csrng_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic [23:0] d;
      logic        de;
    } fifo_depth_sts;
    struct packed {
      logic        d;
      logic        de;
    } diag;
  } csrng_hw2reg_sum_sts_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } cmd_rdy;
    struct packed {
      logic        d;
      logic        de;
    } cmd_sts;
  } csrng_hw2reg_sw_cmd_sts_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } genbits_vld;
    struct packed {
      logic        d;
    } genbits_fips;
  } csrng_hw2reg_genbits_vld_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } csrng_hw2reg_genbits_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } csrng_hw2reg_int_state_val_reg_t;

  typedef struct packed {
    logic [14:0] d;
    logic        de;
  } csrng_hw2reg_hw_exc_sts_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } sfifo_cmd_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_genbits_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_cmdreq_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_rcstage_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_keyvrc_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_updreq_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_bencreq_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_bencack_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_pdata_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_final_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_gbencack_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_grcstage_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_ggenreq_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_gadstage_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_ggenbits_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_blkenc_err;
    struct packed {
      logic        d;
      logic        de;
    } cmd_stage_sm_err;
    struct packed {
      logic        d;
      logic        de;
    } main_sm_err;
    struct packed {
      logic        d;
      logic        de;
    } drbg_gen_sm_err;
    struct packed {
      logic        d;
      logic        de;
    } drbg_updbe_sm_err;
    struct packed {
      logic        d;
      logic        de;
    } drbg_updob_sm_err;
    struct packed {
      logic        d;
      logic        de;
    } aes_cipher_sm_err;
    struct packed {
      logic        d;
      logic        de;
    } fifo_write_err;
    struct packed {
      logic        d;
      logic        de;
    } fifo_read_err;
    struct packed {
      logic        d;
      logic        de;
    } fifo_state_err;
  } csrng_hw2reg_err_code_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    csrng_reg2hw_intr_state_reg_t intr_state; // [134:131]
    csrng_reg2hw_intr_enable_reg_t intr_enable; // [130:127]
    csrng_reg2hw_intr_test_reg_t intr_test; // [126:119]
    csrng_reg2hw_alert_test_reg_t alert_test; // [118:117]
    csrng_reg2hw_regwen_reg_t regwen; // [116:116]
    csrng_reg2hw_ctrl_reg_t ctrl; // [115:110]
    csrng_reg2hw_cmd_req_reg_t cmd_req; // [109:77]
    csrng_reg2hw_genbits_reg_t genbits; // [76:44]
    csrng_reg2hw_int_state_num_reg_t int_state_num; // [43:39]
    csrng_reg2hw_int_state_val_reg_t int_state_val; // [38:6]
    csrng_reg2hw_err_code_test_reg_t err_code_test; // [5:0]
  } csrng_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    csrng_hw2reg_intr_state_reg_t intr_state; // [170:163]
    csrng_hw2reg_sum_sts_reg_t sum_sts; // [162:136]
    csrng_hw2reg_sw_cmd_sts_reg_t sw_cmd_sts; // [135:132]
    csrng_hw2reg_genbits_vld_reg_t genbits_vld; // [131:130]
    csrng_hw2reg_genbits_reg_t genbits; // [129:98]
    csrng_hw2reg_int_state_val_reg_t int_state_val; // [97:66]
    csrng_hw2reg_hw_exc_sts_reg_t hw_exc_sts; // [65:50]
    csrng_hw2reg_err_code_reg_t err_code; // [49:0]
  } csrng_hw2reg_t;

  // Register Address
  parameter logic [BlockAw-1:0] CSRNG_INTR_STATE_OFFSET = 6'h 0;
  parameter logic [BlockAw-1:0] CSRNG_INTR_ENABLE_OFFSET = 6'h 4;
  parameter logic [BlockAw-1:0] CSRNG_INTR_TEST_OFFSET = 6'h 8;
  parameter logic [BlockAw-1:0] CSRNG_ALERT_TEST_OFFSET = 6'h c;
  parameter logic [BlockAw-1:0] CSRNG_REGWEN_OFFSET = 6'h 10;
  parameter logic [BlockAw-1:0] CSRNG_CTRL_OFFSET = 6'h 14;
  parameter logic [BlockAw-1:0] CSRNG_SUM_STS_OFFSET = 6'h 18;
  parameter logic [BlockAw-1:0] CSRNG_CMD_REQ_OFFSET = 6'h 1c;
  parameter logic [BlockAw-1:0] CSRNG_SW_CMD_STS_OFFSET = 6'h 20;
  parameter logic [BlockAw-1:0] CSRNG_GENBITS_VLD_OFFSET = 6'h 24;
  parameter logic [BlockAw-1:0] CSRNG_GENBITS_OFFSET = 6'h 28;
  parameter logic [BlockAw-1:0] CSRNG_INT_STATE_NUM_OFFSET = 6'h 2c;
  parameter logic [BlockAw-1:0] CSRNG_INT_STATE_VAL_OFFSET = 6'h 30;
  parameter logic [BlockAw-1:0] CSRNG_HW_EXC_STS_OFFSET = 6'h 34;
  parameter logic [BlockAw-1:0] CSRNG_ERR_CODE_OFFSET = 6'h 38;
  parameter logic [BlockAw-1:0] CSRNG_ERR_CODE_TEST_OFFSET = 6'h 3c;

  // Reset values for hwext registers and their fields
  parameter logic [3:0] CSRNG_INTR_TEST_RESVAL = 4'h 0;
  parameter logic [0:0] CSRNG_INTR_TEST_CS_CMD_REQ_DONE_RESVAL = 1'h 0;
  parameter logic [0:0] CSRNG_INTR_TEST_CS_ENTROPY_REQ_RESVAL = 1'h 0;
  parameter logic [0:0] CSRNG_INTR_TEST_CS_HW_INST_EXC_RESVAL = 1'h 0;
  parameter logic [0:0] CSRNG_INTR_TEST_CS_FATAL_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] CSRNG_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] CSRNG_ALERT_TEST_FATAL_ALERT_RESVAL = 1'h 0;
  parameter logic [1:0] CSRNG_GENBITS_VLD_RESVAL = 2'h 0;
  parameter logic [31:0] CSRNG_GENBITS_RESVAL = 32'h 0;
  parameter logic [31:0] CSRNG_INT_STATE_VAL_RESVAL = 32'h 0;

  // Register Index
  typedef enum int {
    CSRNG_INTR_STATE,
    CSRNG_INTR_ENABLE,
    CSRNG_INTR_TEST,
    CSRNG_ALERT_TEST,
    CSRNG_REGWEN,
    CSRNG_CTRL,
    CSRNG_SUM_STS,
    CSRNG_CMD_REQ,
    CSRNG_SW_CMD_STS,
    CSRNG_GENBITS_VLD,
    CSRNG_GENBITS,
    CSRNG_INT_STATE_NUM,
    CSRNG_INT_STATE_VAL,
    CSRNG_HW_EXC_STS,
    CSRNG_ERR_CODE,
    CSRNG_ERR_CODE_TEST
  } csrng_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] CSRNG_PERMIT [16] = '{
    4'b 0001, // index[ 0] CSRNG_INTR_STATE
    4'b 0001, // index[ 1] CSRNG_INTR_ENABLE
    4'b 0001, // index[ 2] CSRNG_INTR_TEST
    4'b 0001, // index[ 3] CSRNG_ALERT_TEST
    4'b 0001, // index[ 4] CSRNG_REGWEN
    4'b 0111, // index[ 5] CSRNG_CTRL
    4'b 1111, // index[ 6] CSRNG_SUM_STS
    4'b 1111, // index[ 7] CSRNG_CMD_REQ
    4'b 0001, // index[ 8] CSRNG_SW_CMD_STS
    4'b 0001, // index[ 9] CSRNG_GENBITS_VLD
    4'b 1111, // index[10] CSRNG_GENBITS
    4'b 0001, // index[11] CSRNG_INT_STATE_NUM
    4'b 1111, // index[12] CSRNG_INT_STATE_VAL
    4'b 0011, // index[13] CSRNG_HW_EXC_STS
    4'b 1111, // index[14] CSRNG_ERR_CODE
    4'b 0001  // index[15] CSRNG_ERR_CODE_TEST
  };
endpackage

