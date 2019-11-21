// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package aes_reg_pkg;

  // Param list
  localparam int NumRegsKey = 8;
  localparam int NumRegsData = 4;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } aes_reg2hw_key_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } aes_reg2hw_data_in_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        re;
  } aes_reg2hw_data_out_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } mode;
    struct packed {
      logic [2:0]  q;
      logic        qe;
    } key_len;
    struct packed {
      logic        q;
      logic        qe;
    } manual_start_trigger;
    struct packed {
      logic        q;
      logic        qe;
    } force_data_overwrite;
  } aes_reg2hw_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } start;
    struct packed {
      logic        q;
    } key_clear;
    struct packed {
      logic        q;
    } data_in_clear;
    struct packed {
      logic        q;
    } data_out_clear;
  } aes_reg2hw_trigger_reg_t;


  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } aes_hw2reg_key_mreg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } aes_hw2reg_data_in_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } aes_hw2reg_data_out_mreg_t;

  typedef struct packed {
    struct packed {
      logic [2:0]  d;
      logic        de;
    } key_len;
  } aes_hw2reg_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } start;
    struct packed {
      logic        d;
      logic        de;
    } key_clear;
    struct packed {
      logic        d;
      logic        de;
    } data_in_clear;
    struct packed {
      logic        d;
      logic        de;
    } data_out_clear;
  } aes_hw2reg_trigger_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } idle;
    struct packed {
      logic        d;
      logic        de;
    } stall;
    struct packed {
      logic        d;
      logic        de;
    } output_valid;
    struct packed {
      logic        d;
      logic        de;
    } input_ready;
  } aes_hw2reg_status_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    aes_reg2hw_key_mreg_t [7:0] key; // [541:278]
    aes_reg2hw_data_in_mreg_t [3:0] data_in; // [277:146]
    aes_reg2hw_data_out_mreg_t [3:0] data_out; // [145:14]
    aes_reg2hw_ctrl_reg_t ctrl; // [13:4]
    aes_reg2hw_trigger_reg_t trigger; // [3:0]
  } aes_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    aes_hw2reg_key_mreg_t [7:0] key; // [543:280]
    aes_hw2reg_data_in_mreg_t [3:0] data_in; // [279:148]
    aes_hw2reg_data_out_mreg_t [3:0] data_out; // [147:20]
    aes_hw2reg_ctrl_reg_t ctrl; // [19:10]
    aes_hw2reg_trigger_reg_t trigger; // [9:6]
    aes_hw2reg_status_reg_t status; // [5:6]
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

