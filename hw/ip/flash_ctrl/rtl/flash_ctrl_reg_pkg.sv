// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package flash_ctrl_reg_pkg;

// Register to internal design logic
typedef struct packed {

  struct packed {
    struct packed {
      logic q; // [295]
    } prog_empty;
    struct packed {
      logic q; // [294]
    } prog_lvl;
    struct packed {
      logic q; // [293]
    } rd_full;
    struct packed {
      logic q; // [292]
    } rd_lvl;
    struct packed {
      logic q; // [291]
    } op_done;
    struct packed {
      logic q; // [290]
    } op_error;
  } intr_state;
  struct packed {
    struct packed {
      logic q; // [289]
    } prog_empty;
    struct packed {
      logic q; // [288]
    } prog_lvl;
    struct packed {
      logic q; // [287]
    } rd_full;
    struct packed {
      logic q; // [286]
    } rd_lvl;
    struct packed {
      logic q; // [285]
    } op_done;
    struct packed {
      logic q; // [284]
    } op_error;
  } intr_enable;
  struct packed {
    struct packed {
      logic q; // [283]
      logic qe; // [282]
    } prog_empty;
    struct packed {
      logic q; // [281]
      logic qe; // [280]
    } prog_lvl;
    struct packed {
      logic q; // [279]
      logic qe; // [278]
    } rd_full;
    struct packed {
      logic q; // [277]
      logic qe; // [276]
    } rd_lvl;
    struct packed {
      logic q; // [275]
      logic qe; // [274]
    } op_done;
    struct packed {
      logic q; // [273]
      logic qe; // [272]
    } op_error;
  } intr_test;
  struct packed {
    struct packed {
      logic q; // [271]
    } start;
    struct packed {
      logic [1:0] q; // [270:269]
    } op;
    struct packed {
      logic q; // [268]
    } erase_sel;
    struct packed {
      logic q; // [267]
    } fifo_rst;
    struct packed {
      logic [11:0] q; // [266:255]
    } num;
  } control;
  struct packed {
    logic [31:0] q; // [254:223]
  } addr;
  struct packed {
    struct packed {
      logic q; // [222]
    } en0;
    struct packed {
      logic q; // [221]
    } rd_en0;
    struct packed {
      logic q; // [220]
    } prog_en0;
    struct packed {
      logic q; // [219]
    } erase_en0;
    struct packed {
      logic [8:0] q; // [218:210]
    } base0;
    struct packed {
      logic [8:0] q; // [209:201]
    } size0;
  } mp_region_cfg0;
  struct packed {
    struct packed {
      logic q; // [200]
    } en1;
    struct packed {
      logic q; // [199]
    } rd_en1;
    struct packed {
      logic q; // [198]
    } prog_en1;
    struct packed {
      logic q; // [197]
    } erase_en1;
    struct packed {
      logic [8:0] q; // [196:188]
    } base1;
    struct packed {
      logic [8:0] q; // [187:179]
    } size1;
  } mp_region_cfg1;
  struct packed {
    struct packed {
      logic q; // [178]
    } en2;
    struct packed {
      logic q; // [177]
    } rd_en2;
    struct packed {
      logic q; // [176]
    } prog_en2;
    struct packed {
      logic q; // [175]
    } erase_en2;
    struct packed {
      logic [8:0] q; // [174:166]
    } base2;
    struct packed {
      logic [8:0] q; // [165:157]
    } size2;
  } mp_region_cfg2;
  struct packed {
    struct packed {
      logic q; // [156]
    } en3;
    struct packed {
      logic q; // [155]
    } rd_en3;
    struct packed {
      logic q; // [154]
    } prog_en3;
    struct packed {
      logic q; // [153]
    } erase_en3;
    struct packed {
      logic [8:0] q; // [152:144]
    } base3;
    struct packed {
      logic [8:0] q; // [143:135]
    } size3;
  } mp_region_cfg3;
  struct packed {
    struct packed {
      logic q; // [134]
    } en4;
    struct packed {
      logic q; // [133]
    } rd_en4;
    struct packed {
      logic q; // [132]
    } prog_en4;
    struct packed {
      logic q; // [131]
    } erase_en4;
    struct packed {
      logic [8:0] q; // [130:122]
    } base4;
    struct packed {
      logic [8:0] q; // [121:113]
    } size4;
  } mp_region_cfg4;
  struct packed {
    struct packed {
      logic q; // [112]
    } en5;
    struct packed {
      logic q; // [111]
    } rd_en5;
    struct packed {
      logic q; // [110]
    } prog_en5;
    struct packed {
      logic q; // [109]
    } erase_en5;
    struct packed {
      logic [8:0] q; // [108:100]
    } base5;
    struct packed {
      logic [8:0] q; // [99:91]
    } size5;
  } mp_region_cfg5;
  struct packed {
    struct packed {
      logic q; // [90]
    } en6;
    struct packed {
      logic q; // [89]
    } rd_en6;
    struct packed {
      logic q; // [88]
    } prog_en6;
    struct packed {
      logic q; // [87]
    } erase_en6;
    struct packed {
      logic [8:0] q; // [86:78]
    } base6;
    struct packed {
      logic [8:0] q; // [77:69]
    } size6;
  } mp_region_cfg6;
  struct packed {
    struct packed {
      logic q; // [68]
    } en7;
    struct packed {
      logic q; // [67]
    } rd_en7;
    struct packed {
      logic q; // [66]
    } prog_en7;
    struct packed {
      logic q; // [65]
    } erase_en7;
    struct packed {
      logic [8:0] q; // [64:56]
    } base7;
    struct packed {
      logic [8:0] q; // [55:47]
    } size7;
  } mp_region_cfg7;
  struct packed {
    struct packed {
      logic q; // [46]
    } rd_en;
    struct packed {
      logic q; // [45]
    } prog_en;
    struct packed {
      logic q; // [44]
    } erase_en;
  } default_region;
  struct packed {
    struct packed {
      logic q; // [43]
    } erase_en0;
    struct packed {
      logic q; // [42]
    } erase_en1;
  } mp_bank_cfg;
  struct packed {
    logic [31:0] q; // [41:10]
  } scratch;
  struct packed {
    struct packed {
      logic [4:0] q; // [9:5]
    } prog;
    struct packed {
      logic [4:0] q; // [4:0]
    } rd;
  } fifo_lvl;
} flash_ctrl_reg2hw_t;

// Internal design logic to register
typedef struct packed {

  struct packed {
    struct packed {
      logic d;  // [32]
      logic de; // [31]
    } prog_empty;
    struct packed {
      logic d;  // [30]
      logic de; // [29]
    } prog_lvl;
    struct packed {
      logic d;  // [28]
      logic de; // [27]
    } rd_full;
    struct packed {
      logic d;  // [26]
      logic de; // [25]
    } rd_lvl;
    struct packed {
      logic d;  // [24]
      logic de; // [23]
    } op_done;
    struct packed {
      logic d;  // [22]
      logic de; // [21]
    } op_error;
  } intr_state;
  struct packed {
    struct packed {
      logic d;  // [20]
      logic de; // [19]
    } start;
  } control;
  struct packed {
    struct packed {
      logic d;  // [18]
      logic de; // [17]
    } done;
    struct packed {
      logic d;  // [16]
      logic de; // [15]
    } err;
  } op_status;
  struct packed {
    struct packed {
      logic d;  // [14]
    } rd_full;
    struct packed {
      logic d;  // [13]
    } rd_empty;
    struct packed {
      logic d;  // [12]
    } prog_full;
    struct packed {
      logic d;  // [11]
    } prog_empty;
    struct packed {
      logic d;  // [10]
    } init_wip;
    struct packed {
      logic [8:0] d; // [9:1]
    } error_page;
    struct packed {
      logic d;  // [0]
    } error_bank;
  } status;
} flash_ctrl_hw2reg_t;

  // Register Address
  parameter FLASH_CTRL_INTR_STATE_OFFSET = 7'h 0;
  parameter FLASH_CTRL_INTR_ENABLE_OFFSET = 7'h 4;
  parameter FLASH_CTRL_INTR_TEST_OFFSET = 7'h 8;
  parameter FLASH_CTRL_CONTROL_OFFSET = 7'h c;
  parameter FLASH_CTRL_ADDR_OFFSET = 7'h 10;
  parameter FLASH_CTRL_MP_REGION_CFG0_OFFSET = 7'h 14;
  parameter FLASH_CTRL_MP_REGION_CFG1_OFFSET = 7'h 18;
  parameter FLASH_CTRL_MP_REGION_CFG2_OFFSET = 7'h 1c;
  parameter FLASH_CTRL_MP_REGION_CFG3_OFFSET = 7'h 20;
  parameter FLASH_CTRL_MP_REGION_CFG4_OFFSET = 7'h 24;
  parameter FLASH_CTRL_MP_REGION_CFG5_OFFSET = 7'h 28;
  parameter FLASH_CTRL_MP_REGION_CFG6_OFFSET = 7'h 2c;
  parameter FLASH_CTRL_MP_REGION_CFG7_OFFSET = 7'h 30;
  parameter FLASH_CTRL_DEFAULT_REGION_OFFSET = 7'h 34;
  parameter FLASH_CTRL_MP_BANK_CFG_OFFSET = 7'h 38;
  parameter FLASH_CTRL_OP_STATUS_OFFSET = 7'h 3c;
  parameter FLASH_CTRL_STATUS_OFFSET = 7'h 40;
  parameter FLASH_CTRL_SCRATCH_OFFSET = 7'h 44;
  parameter FLASH_CTRL_FIFO_LVL_OFFSET = 7'h 48;

  // Window parameter
  parameter FLASH_CTRL_PROG_FIFO_OFFSET = 7'h 4c;
  parameter FLASH_CTRL_PROG_FIFO_SIZE   = 7'h 4;
  parameter FLASH_CTRL_RD_FIFO_OFFSET = 7'h 50;
  parameter FLASH_CTRL_RD_FIFO_SIZE   = 7'h 4;

  // Register Index
  typedef enum int {
    FLASH_CTRL_INTR_STATE,
    FLASH_CTRL_INTR_ENABLE,
    FLASH_CTRL_INTR_TEST,
    FLASH_CTRL_CONTROL,
    FLASH_CTRL_ADDR,
    FLASH_CTRL_MP_REGION_CFG0,
    FLASH_CTRL_MP_REGION_CFG1,
    FLASH_CTRL_MP_REGION_CFG2,
    FLASH_CTRL_MP_REGION_CFG3,
    FLASH_CTRL_MP_REGION_CFG4,
    FLASH_CTRL_MP_REGION_CFG5,
    FLASH_CTRL_MP_REGION_CFG6,
    FLASH_CTRL_MP_REGION_CFG7,
    FLASH_CTRL_DEFAULT_REGION,
    FLASH_CTRL_MP_BANK_CFG,
    FLASH_CTRL_OP_STATUS,
    FLASH_CTRL_STATUS,
    FLASH_CTRL_SCRATCH,
    FLASH_CTRL_FIFO_LVL
  } flash_ctrl_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] FLASH_CTRL_PERMIT [19] = '{
    4'b 0001, // index[ 0] FLASH_CTRL_INTR_STATE
    4'b 0001, // index[ 1] FLASH_CTRL_INTR_ENABLE
    4'b 0001, // index[ 2] FLASH_CTRL_INTR_TEST
    4'b 1111, // index[ 3] FLASH_CTRL_CONTROL
    4'b 1111, // index[ 4] FLASH_CTRL_ADDR
    4'b 1111, // index[ 5] FLASH_CTRL_MP_REGION_CFG0
    4'b 1111, // index[ 6] FLASH_CTRL_MP_REGION_CFG1
    4'b 1111, // index[ 7] FLASH_CTRL_MP_REGION_CFG2
    4'b 1111, // index[ 8] FLASH_CTRL_MP_REGION_CFG3
    4'b 1111, // index[ 9] FLASH_CTRL_MP_REGION_CFG4
    4'b 1111, // index[10] FLASH_CTRL_MP_REGION_CFG5
    4'b 1111, // index[11] FLASH_CTRL_MP_REGION_CFG6
    4'b 1111, // index[12] FLASH_CTRL_MP_REGION_CFG7
    4'b 0001, // index[13] FLASH_CTRL_DEFAULT_REGION
    4'b 0001, // index[14] FLASH_CTRL_MP_BANK_CFG
    4'b 0001, // index[15] FLASH_CTRL_OP_STATUS
    4'b 1111, // index[16] FLASH_CTRL_STATUS
    4'b 1111, // index[17] FLASH_CTRL_SCRATCH
    4'b 0011  // index[18] FLASH_CTRL_FIFO_LVL
  };
endpackage

