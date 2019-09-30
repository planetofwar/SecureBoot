// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rv_plic_reg_pkg;

  // Param list
  localparam int NumSrc = 32;
  localparam int NumTarget = 1;

/////////////////////////////////////////////////////////////////////
// Typedefs for multiregs
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  logic [0:0] q;
} rv_plic_reg2hw_le_mreg_t;
typedef struct packed {
  logic [0:0] q;
} rv_plic_reg2hw_ie0_mreg_t;

typedef struct packed {
  logic [0:0] d;
  logic de;
} rv_plic_hw2reg_ip_mreg_t;

/////////////////////////////////////////////////////////////////////
// Register to internal design logic
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  rv_plic_reg2hw_le_mreg_t [31:0] le; // [171:140]
  struct packed {
    logic [2:0] q; // [139:137]
  } prio0;
  struct packed {
    logic [2:0] q; // [136:134]
  } prio1;
  struct packed {
    logic [2:0] q; // [133:131]
  } prio2;
  struct packed {
    logic [2:0] q; // [130:128]
  } prio3;
  struct packed {
    logic [2:0] q; // [127:125]
  } prio4;
  struct packed {
    logic [2:0] q; // [124:122]
  } prio5;
  struct packed {
    logic [2:0] q; // [121:119]
  } prio6;
  struct packed {
    logic [2:0] q; // [118:116]
  } prio7;
  struct packed {
    logic [2:0] q; // [115:113]
  } prio8;
  struct packed {
    logic [2:0] q; // [112:110]
  } prio9;
  struct packed {
    logic [2:0] q; // [109:107]
  } prio10;
  struct packed {
    logic [2:0] q; // [106:104]
  } prio11;
  struct packed {
    logic [2:0] q; // [103:101]
  } prio12;
  struct packed {
    logic [2:0] q; // [100:98]
  } prio13;
  struct packed {
    logic [2:0] q; // [97:95]
  } prio14;
  struct packed {
    logic [2:0] q; // [94:92]
  } prio15;
  struct packed {
    logic [2:0] q; // [91:89]
  } prio16;
  struct packed {
    logic [2:0] q; // [88:86]
  } prio17;
  struct packed {
    logic [2:0] q; // [85:83]
  } prio18;
  struct packed {
    logic [2:0] q; // [82:80]
  } prio19;
  struct packed {
    logic [2:0] q; // [79:77]
  } prio20;
  struct packed {
    logic [2:0] q; // [76:74]
  } prio21;
  struct packed {
    logic [2:0] q; // [73:71]
  } prio22;
  struct packed {
    logic [2:0] q; // [70:68]
  } prio23;
  struct packed {
    logic [2:0] q; // [67:65]
  } prio24;
  struct packed {
    logic [2:0] q; // [64:62]
  } prio25;
  struct packed {
    logic [2:0] q; // [61:59]
  } prio26;
  struct packed {
    logic [2:0] q; // [58:56]
  } prio27;
  struct packed {
    logic [2:0] q; // [55:53]
  } prio28;
  struct packed {
    logic [2:0] q; // [52:50]
  } prio29;
  struct packed {
    logic [2:0] q; // [49:47]
  } prio30;
  struct packed {
    logic [2:0] q; // [46:44]
  } prio31;
  rv_plic_reg2hw_ie0_mreg_t [31:0] ie0; // [43:12]
  struct packed {
    logic [2:0] q; // [11:9]
  } threshold0;
  struct packed {
    logic [5:0] q; // [8:3]
    logic qe; // [2]
    logic re; // [1]
  } cc0;
  struct packed {
    logic [0:0] q; // [0:0]
  } msip0;
} rv_plic_reg2hw_t;

/////////////////////////////////////////////////////////////////////
// Internal design logic to register
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  rv_plic_hw2reg_ip_mreg_t [31:0] ip; // [69:6]
  struct packed {
    logic [5:0] d; // [5:0]
  } cc0;
} rv_plic_hw2reg_t;

  // Register Address
  parameter RV_PLIC_IP_OFFSET = 9'h 0;
  parameter RV_PLIC_LE_OFFSET = 9'h 4;
  parameter RV_PLIC_PRIO0_OFFSET = 9'h 8;
  parameter RV_PLIC_PRIO1_OFFSET = 9'h c;
  parameter RV_PLIC_PRIO2_OFFSET = 9'h 10;
  parameter RV_PLIC_PRIO3_OFFSET = 9'h 14;
  parameter RV_PLIC_PRIO4_OFFSET = 9'h 18;
  parameter RV_PLIC_PRIO5_OFFSET = 9'h 1c;
  parameter RV_PLIC_PRIO6_OFFSET = 9'h 20;
  parameter RV_PLIC_PRIO7_OFFSET = 9'h 24;
  parameter RV_PLIC_PRIO8_OFFSET = 9'h 28;
  parameter RV_PLIC_PRIO9_OFFSET = 9'h 2c;
  parameter RV_PLIC_PRIO10_OFFSET = 9'h 30;
  parameter RV_PLIC_PRIO11_OFFSET = 9'h 34;
  parameter RV_PLIC_PRIO12_OFFSET = 9'h 38;
  parameter RV_PLIC_PRIO13_OFFSET = 9'h 3c;
  parameter RV_PLIC_PRIO14_OFFSET = 9'h 40;
  parameter RV_PLIC_PRIO15_OFFSET = 9'h 44;
  parameter RV_PLIC_PRIO16_OFFSET = 9'h 48;
  parameter RV_PLIC_PRIO17_OFFSET = 9'h 4c;
  parameter RV_PLIC_PRIO18_OFFSET = 9'h 50;
  parameter RV_PLIC_PRIO19_OFFSET = 9'h 54;
  parameter RV_PLIC_PRIO20_OFFSET = 9'h 58;
  parameter RV_PLIC_PRIO21_OFFSET = 9'h 5c;
  parameter RV_PLIC_PRIO22_OFFSET = 9'h 60;
  parameter RV_PLIC_PRIO23_OFFSET = 9'h 64;
  parameter RV_PLIC_PRIO24_OFFSET = 9'h 68;
  parameter RV_PLIC_PRIO25_OFFSET = 9'h 6c;
  parameter RV_PLIC_PRIO26_OFFSET = 9'h 70;
  parameter RV_PLIC_PRIO27_OFFSET = 9'h 74;
  parameter RV_PLIC_PRIO28_OFFSET = 9'h 78;
  parameter RV_PLIC_PRIO29_OFFSET = 9'h 7c;
  parameter RV_PLIC_PRIO30_OFFSET = 9'h 80;
  parameter RV_PLIC_PRIO31_OFFSET = 9'h 84;
  parameter RV_PLIC_IE0_OFFSET = 9'h 100;
  parameter RV_PLIC_THRESHOLD0_OFFSET = 9'h 104;
  parameter RV_PLIC_CC0_OFFSET = 9'h 108;
  parameter RV_PLIC_MSIP0_OFFSET = 9'h 10c;


  // Register Index
  typedef enum int {
    RV_PLIC_IP,
    RV_PLIC_LE,
    RV_PLIC_PRIO0,
    RV_PLIC_PRIO1,
    RV_PLIC_PRIO2,
    RV_PLIC_PRIO3,
    RV_PLIC_PRIO4,
    RV_PLIC_PRIO5,
    RV_PLIC_PRIO6,
    RV_PLIC_PRIO7,
    RV_PLIC_PRIO8,
    RV_PLIC_PRIO9,
    RV_PLIC_PRIO10,
    RV_PLIC_PRIO11,
    RV_PLIC_PRIO12,
    RV_PLIC_PRIO13,
    RV_PLIC_PRIO14,
    RV_PLIC_PRIO15,
    RV_PLIC_PRIO16,
    RV_PLIC_PRIO17,
    RV_PLIC_PRIO18,
    RV_PLIC_PRIO19,
    RV_PLIC_PRIO20,
    RV_PLIC_PRIO21,
    RV_PLIC_PRIO22,
    RV_PLIC_PRIO23,
    RV_PLIC_PRIO24,
    RV_PLIC_PRIO25,
    RV_PLIC_PRIO26,
    RV_PLIC_PRIO27,
    RV_PLIC_PRIO28,
    RV_PLIC_PRIO29,
    RV_PLIC_PRIO30,
    RV_PLIC_PRIO31,
    RV_PLIC_IE0,
    RV_PLIC_THRESHOLD0,
    RV_PLIC_CC0,
    RV_PLIC_MSIP0
  } rv_plic_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] RV_PLIC_PERMIT [38] = '{
    4'b 1111, // index[ 0] RV_PLIC_IP
    4'b 1111, // index[ 1] RV_PLIC_LE
    4'b 0001, // index[ 2] RV_PLIC_PRIO0
    4'b 0001, // index[ 3] RV_PLIC_PRIO1
    4'b 0001, // index[ 4] RV_PLIC_PRIO2
    4'b 0001, // index[ 5] RV_PLIC_PRIO3
    4'b 0001, // index[ 6] RV_PLIC_PRIO4
    4'b 0001, // index[ 7] RV_PLIC_PRIO5
    4'b 0001, // index[ 8] RV_PLIC_PRIO6
    4'b 0001, // index[ 9] RV_PLIC_PRIO7
    4'b 0001, // index[10] RV_PLIC_PRIO8
    4'b 0001, // index[11] RV_PLIC_PRIO9
    4'b 0001, // index[12] RV_PLIC_PRIO10
    4'b 0001, // index[13] RV_PLIC_PRIO11
    4'b 0001, // index[14] RV_PLIC_PRIO12
    4'b 0001, // index[15] RV_PLIC_PRIO13
    4'b 0001, // index[16] RV_PLIC_PRIO14
    4'b 0001, // index[17] RV_PLIC_PRIO15
    4'b 0001, // index[18] RV_PLIC_PRIO16
    4'b 0001, // index[19] RV_PLIC_PRIO17
    4'b 0001, // index[20] RV_PLIC_PRIO18
    4'b 0001, // index[21] RV_PLIC_PRIO19
    4'b 0001, // index[22] RV_PLIC_PRIO20
    4'b 0001, // index[23] RV_PLIC_PRIO21
    4'b 0001, // index[24] RV_PLIC_PRIO22
    4'b 0001, // index[25] RV_PLIC_PRIO23
    4'b 0001, // index[26] RV_PLIC_PRIO24
    4'b 0001, // index[27] RV_PLIC_PRIO25
    4'b 0001, // index[28] RV_PLIC_PRIO26
    4'b 0001, // index[29] RV_PLIC_PRIO27
    4'b 0001, // index[30] RV_PLIC_PRIO28
    4'b 0001, // index[31] RV_PLIC_PRIO29
    4'b 0001, // index[32] RV_PLIC_PRIO30
    4'b 0001, // index[33] RV_PLIC_PRIO31
    4'b 1111, // index[34] RV_PLIC_IE0
    4'b 0001, // index[35] RV_PLIC_THRESHOLD0
    4'b 0001, // index[36] RV_PLIC_CC0
    4'b 0001  // index[37] RV_PLIC_MSIP0
  };
endpackage

