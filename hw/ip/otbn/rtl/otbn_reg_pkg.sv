// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package otbn_reg_pkg;

  // Param list
  parameter int NumAlerts = 2;

  // Address width within the block
  parameter int BlockAw = 16;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic        q;
  } otbn_reg2hw_intr_state_reg_t;

  typedef struct packed {
    logic        q;
  } otbn_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } otbn_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } fatal;
    struct packed {
      logic        q;
      logic        qe;
    } recov;
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
    logic        d;
    logic        de;
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
    struct packed {
      logic        d;
      logic        de;
    } bad_data_addr;
    struct packed {
      logic        d;
      logic        de;
    } bad_insn_addr;
    struct packed {
      logic        d;
      logic        de;
    } call_stack;
    struct packed {
      logic        d;
      logic        de;
    } illegal_insn;
    struct packed {
      logic        d;
      logic        de;
    } loop;
    struct packed {
      logic        d;
      logic        de;
    } fatal_imem;
    struct packed {
      logic        d;
      logic        de;
    } fatal_dmem;
    struct packed {
      logic        d;
      logic        de;
    } fatal_reg;
  } otbn_hw2reg_err_bits_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } imem_error;
    struct packed {
      logic        d;
      logic        de;
    } dmem_error;
    struct packed {
      logic        d;
      logic        de;
    } reg_error;
  } otbn_hw2reg_fatal_alert_cause_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    otbn_reg2hw_intr_state_reg_t intr_state; // [43:43]
    otbn_reg2hw_intr_enable_reg_t intr_enable; // [42:42]
    otbn_reg2hw_intr_test_reg_t intr_test; // [41:40]
    otbn_reg2hw_alert_test_reg_t alert_test; // [39:36]
    otbn_reg2hw_cmd_reg_t cmd; // [35:32]
    otbn_reg2hw_start_addr_reg_t start_addr; // [31:0]
  } otbn_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    otbn_hw2reg_intr_state_reg_t intr_state; // [25:24]
    otbn_hw2reg_status_reg_t status; // [23:22]
    otbn_hw2reg_err_bits_reg_t err_bits; // [21:6]
    otbn_hw2reg_fatal_alert_cause_reg_t fatal_alert_cause; // [5:0]
  } otbn_hw2reg_t;

  // Register Address
  parameter logic [BlockAw-1:0] OTBN_INTR_STATE_OFFSET = 16'h 0;
  parameter logic [BlockAw-1:0] OTBN_INTR_ENABLE_OFFSET = 16'h 4;
  parameter logic [BlockAw-1:0] OTBN_INTR_TEST_OFFSET = 16'h 8;
  parameter logic [BlockAw-1:0] OTBN_ALERT_TEST_OFFSET = 16'h c;
  parameter logic [BlockAw-1:0] OTBN_CMD_OFFSET = 16'h 10;
  parameter logic [BlockAw-1:0] OTBN_STATUS_OFFSET = 16'h 14;
  parameter logic [BlockAw-1:0] OTBN_ERR_BITS_OFFSET = 16'h 18;
  parameter logic [BlockAw-1:0] OTBN_START_ADDR_OFFSET = 16'h 1c;
  parameter logic [BlockAw-1:0] OTBN_FATAL_ALERT_CAUSE_OFFSET = 16'h 20;

  // Window parameter
  parameter logic [BlockAw-1:0] OTBN_IMEM_OFFSET = 16'h 4000;
  parameter logic [BlockAw-1:0] OTBN_IMEM_SIZE   = 16'h 1000;
  parameter logic [BlockAw-1:0] OTBN_DMEM_OFFSET = 16'h 8000;
  parameter logic [BlockAw-1:0] OTBN_DMEM_SIZE   = 16'h 1000;

  // Register Index
  typedef enum int {
    OTBN_INTR_STATE,
    OTBN_INTR_ENABLE,
    OTBN_INTR_TEST,
    OTBN_ALERT_TEST,
    OTBN_CMD,
    OTBN_STATUS,
    OTBN_ERR_BITS,
    OTBN_START_ADDR,
    OTBN_FATAL_ALERT_CAUSE
  } otbn_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] OTBN_PERMIT [9] = '{
    4'b 0001, // index[0] OTBN_INTR_STATE
    4'b 0001, // index[1] OTBN_INTR_ENABLE
    4'b 0001, // index[2] OTBN_INTR_TEST
    4'b 0001, // index[3] OTBN_ALERT_TEST
    4'b 0001, // index[4] OTBN_CMD
    4'b 0001, // index[5] OTBN_STATUS
    4'b 0001, // index[6] OTBN_ERR_BITS
    4'b 1111, // index[7] OTBN_START_ADDR
    4'b 0001  // index[8] OTBN_FATAL_ALERT_CAUSE
  };
endpackage

