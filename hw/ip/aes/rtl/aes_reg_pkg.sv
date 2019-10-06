// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package aes_reg_pkg;

  // Param list
  localparam int KEY = 8;
  localparam int DATA_IN = 4;
  localparam int DATA_OUT = 4;

/////////////////////////////////////////////////////////////////////
// Typedefs for multiregs
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  logic [31:0] q;
  logic qe;
} aes_reg2hw_key_mreg_t;
typedef struct packed {
  logic [31:0] q;
  logic qe;
} aes_reg2hw_data_in_mreg_t;
typedef struct packed {
  logic [31:0] q;
  logic re;
} aes_reg2hw_data_out_mreg_t;

typedef struct packed {
  logic [31:0] d;
} aes_hw2reg_data_out_mreg_t;

/////////////////////////////////////////////////////////////////////
// Register to internal design logic
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  aes_reg2hw_key_mreg_t [7:0] key; // [540:277]
  aes_reg2hw_data_in_mreg_t [3:0] data_in; // [276:145]
  aes_reg2hw_data_out_mreg_t [3:0] data_out; // [144:13]
  struct packed {
    struct packed {
      logic q; // [12]
      logic qe; // [11]
    } mode;
    struct packed {
      logic [2:0] q; // [10:8]
      logic qe; // [7]
    } key_len;
    struct packed {
      logic q; // [6]
      logic qe; // [5]
    } manual_start_trigger;
    struct packed {
      logic q; // [4]
      logic qe; // [3]
    } force_data_overwrite;
  } ctrl;
  struct packed {
    struct packed {
      logic q; // [2]
    } start;
    struct packed {
      logic q; // [1]
    } key_clear;
    struct packed {
      logic q; // [0]
    } data_out_clear;
  } trigger;
} aes_reg2hw_t;

/////////////////////////////////////////////////////////////////////
// Internal design logic to register
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  aes_hw2reg_data_out_mreg_t [3:0] data_out; // [145:18]
  struct packed {
    struct packed {
      logic [2:0] d; // [17:15]
      logic de; // [14]
    } key_len;
  } ctrl;
  struct packed {
    struct packed {
      logic d; // [13]
      logic de; // [12]
    } start;
    struct packed {
      logic d; // [11]
      logic de; // [10]
    } key_clear;
    struct packed {
      logic d; // [9]
      logic de; // [8]
    } data_out_clear;
  } trigger;
  struct packed {
    struct packed {
      logic d; // [7]
      logic de; // [6]
    } idle;
    struct packed {
      logic d; // [5]
      logic de; // [4]
    } stall;
    struct packed {
      logic d; // [3]
      logic de; // [2]
    } output_valid;
    struct packed {
      logic d; // [1]
      logic de; // [0]
    } input_ready;
  } status;
} aes_hw2reg_t;

  // Register Address
  parameter AES_KEY0_OFFSET = 7'h 0;
  parameter AES_KEY1_OFFSET = 7'h 4;
  parameter AES_KEY2_OFFSET = 7'h 8;
  parameter AES_KEY3_OFFSET = 7'h c;
  parameter AES_KEY4_OFFSET = 7'h 10;
  parameter AES_KEY5_OFFSET = 7'h 14;
  parameter AES_KEY6_OFFSET = 7'h 18;
  parameter AES_KEY7_OFFSET = 7'h 1c;
  parameter AES_DATA_IN0_OFFSET = 7'h 20;
  parameter AES_DATA_IN1_OFFSET = 7'h 24;
  parameter AES_DATA_IN2_OFFSET = 7'h 28;
  parameter AES_DATA_IN3_OFFSET = 7'h 2c;
  parameter AES_DATA_OUT0_OFFSET = 7'h 30;
  parameter AES_DATA_OUT1_OFFSET = 7'h 34;
  parameter AES_DATA_OUT2_OFFSET = 7'h 38;
  parameter AES_DATA_OUT3_OFFSET = 7'h 3c;
  parameter AES_CTRL_OFFSET = 7'h 40;
  parameter AES_TRIGGER_OFFSET = 7'h 44;
  parameter AES_STATUS_OFFSET = 7'h 48;


  // Register Index
  typedef enum int {
    AES_KEY0,
    AES_KEY1,
    AES_KEY2,
    AES_KEY3,
    AES_KEY4,
    AES_KEY5,
    AES_KEY6,
    AES_KEY7,
    AES_DATA_IN0,
    AES_DATA_IN1,
    AES_DATA_IN2,
    AES_DATA_IN3,
    AES_DATA_OUT0,
    AES_DATA_OUT1,
    AES_DATA_OUT2,
    AES_DATA_OUT3,
    AES_CTRL,
    AES_TRIGGER,
    AES_STATUS
  } aes_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] AES_PERMIT [19] = '{
    4'b 1111, // index[ 0] AES_KEY0
    4'b 1111, // index[ 1] AES_KEY1
    4'b 1111, // index[ 2] AES_KEY2
    4'b 1111, // index[ 3] AES_KEY3
    4'b 1111, // index[ 4] AES_KEY4
    4'b 1111, // index[ 5] AES_KEY5
    4'b 1111, // index[ 6] AES_KEY6
    4'b 1111, // index[ 7] AES_KEY7
    4'b 1111, // index[ 8] AES_DATA_IN0
    4'b 1111, // index[ 9] AES_DATA_IN1
    4'b 1111, // index[10] AES_DATA_IN2
    4'b 1111, // index[11] AES_DATA_IN3
    4'b 1111, // index[12] AES_DATA_OUT0
    4'b 1111, // index[13] AES_DATA_OUT1
    4'b 1111, // index[14] AES_DATA_OUT2
    4'b 1111, // index[15] AES_DATA_OUT3
    4'b 0001, // index[16] AES_CTRL
    4'b 0001, // index[17] AES_TRIGGER
    4'b 0001  // index[18] AES_STATUS
  };
endpackage

