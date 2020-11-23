// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package otbn_reg_pkg;

  // Param list
  parameter int NumAlerts = 3;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } done;
    struct packed {
      logic        q;
    } err;
  } otbn_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } done;
    struct packed {
      logic        q;
    } err;
  } otbn_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } done;
    struct packed {
      logic        q;
      logic        qe;
    } err;
  } otbn_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } imem_uncorrectable;
    struct packed {
      logic        q;
      logic        qe;
    } dmem_uncorrectable;
    struct packed {
      logic        q;
      logic        qe;
    } reg_uncorrectable;
  } otbn_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } start;
    struct packed {
      logic        q;
      logic        qe;
    } dummy;
  } otbn_reg2hw_cmd_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otbn_reg2hw_start_addr_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } done;
    struct packed {
      logic        d;
      logic        de;
    } err;
  } otbn_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } busy;
    struct packed {
      logic        d;
    } dummy;
  } otbn_hw2reg_status_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } otbn_hw2reg_err_code_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    otbn_reg2hw_intr_state_reg_t intr_state; // [49:48]
    otbn_reg2hw_intr_enable_reg_t intr_enable; // [47:46]
    otbn_reg2hw_intr_test_reg_t intr_test; // [45:42]
    otbn_reg2hw_alert_test_reg_t alert_test; // [41:36]
    otbn_reg2hw_cmd_reg_t cmd; // [35:32]
    otbn_reg2hw_start_addr_reg_t start_addr; // [31:0]
  } otbn_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    otbn_hw2reg_intr_state_reg_t intr_state; // [38:37]
    otbn_hw2reg_status_reg_t status; // [36:37]
    otbn_hw2reg_err_code_reg_t err_code; // [36:37]
  } otbn_hw2reg_t;

  // Register Address
  parameter logic [15:0] OTBN_INTR_STATE_OFFSET = 16'h 0;
  parameter logic [15:0] OTBN_INTR_ENABLE_OFFSET = 16'h 4;
  parameter logic [15:0] OTBN_INTR_TEST_OFFSET = 16'h 8;
  parameter logic [15:0] OTBN_ALERT_TEST_OFFSET = 16'h c;
  parameter logic [15:0] OTBN_CMD_OFFSET = 16'h 10;
  parameter logic [15:0] OTBN_STATUS_OFFSET = 16'h 14;
  parameter logic [15:0] OTBN_ERR_CODE_OFFSET = 16'h 18;
  parameter logic [15:0] OTBN_START_ADDR_OFFSET = 16'h 1c;

  // Window parameter
  parameter logic [15:0] OTBN_IMEM_OFFSET = 16'h 4000;
  parameter logic [15:0] OTBN_IMEM_SIZE   = 16'h 1000;
  parameter logic [15:0] OTBN_DMEM_OFFSET = 16'h 8000;
  parameter logic [15:0] OTBN_DMEM_SIZE   = 16'h 1000;

  // Register Index
  typedef enum int {
    OTBN_INTR_STATE,
    OTBN_INTR_ENABLE,
    OTBN_INTR_TEST,
    OTBN_ALERT_TEST,
    OTBN_CMD,
    OTBN_STATUS,
    OTBN_ERR_CODE,
    OTBN_START_ADDR
  } otbn_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] OTBN_PERMIT [8] = '{
    4'b 0001, // index[0] OTBN_INTR_STATE
    4'b 0001, // index[1] OTBN_INTR_ENABLE
    4'b 0001, // index[2] OTBN_INTR_TEST
    4'b 0001, // index[3] OTBN_ALERT_TEST
    4'b 0001, // index[4] OTBN_CMD
    4'b 0001, // index[5] OTBN_STATUS
    4'b 1111, // index[6] OTBN_ERR_CODE
    4'b 1111  // index[7] OTBN_START_ADDR
  };
endpackage

