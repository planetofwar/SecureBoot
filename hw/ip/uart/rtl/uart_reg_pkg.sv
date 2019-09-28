// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package uart_reg_pkg;

/////////////////////////////////////////////////////////////////////
// Register to internal design logic
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  struct packed {
    struct packed {
      logic q; // [124]
    } tx_watermark;
    struct packed {
      logic q; // [123]
    } rx_watermark;
    struct packed {
      logic q; // [122]
    } tx_overflow;
    struct packed {
      logic q; // [121]
    } rx_overflow;
    struct packed {
      logic q; // [120]
    } rx_frame_err;
    struct packed {
      logic q; // [119]
    } rx_break_err;
    struct packed {
      logic q; // [118]
    } rx_timeout;
    struct packed {
      logic q; // [117]
    } rx_parity_err;
  } intr_state;
  struct packed {
    struct packed {
      logic q; // [116]
    } tx_watermark;
    struct packed {
      logic q; // [115]
    } rx_watermark;
    struct packed {
      logic q; // [114]
    } tx_overflow;
    struct packed {
      logic q; // [113]
    } rx_overflow;
    struct packed {
      logic q; // [112]
    } rx_frame_err;
    struct packed {
      logic q; // [111]
    } rx_break_err;
    struct packed {
      logic q; // [110]
    } rx_timeout;
    struct packed {
      logic q; // [109]
    } rx_parity_err;
  } intr_enable;
  struct packed {
    struct packed {
      logic q; // [108]
      logic qe; // [107]
    } tx_watermark;
    struct packed {
      logic q; // [106]
      logic qe; // [105]
    } rx_watermark;
    struct packed {
      logic q; // [104]
      logic qe; // [103]
    } tx_overflow;
    struct packed {
      logic q; // [102]
      logic qe; // [101]
    } rx_overflow;
    struct packed {
      logic q; // [100]
      logic qe; // [99]
    } rx_frame_err;
    struct packed {
      logic q; // [98]
      logic qe; // [97]
    } rx_break_err;
    struct packed {
      logic q; // [96]
      logic qe; // [95]
    } rx_timeout;
    struct packed {
      logic q; // [94]
      logic qe; // [93]
    } rx_parity_err;
  } intr_test;
  struct packed {
    struct packed {
      logic q; // [92]
    } tx;
    struct packed {
      logic q; // [91]
    } rx;
    struct packed {
      logic q; // [90]
    } nf;
    struct packed {
      logic q; // [89]
    } slpbk;
    struct packed {
      logic q; // [88]
    } llpbk;
    struct packed {
      logic q; // [87]
    } parity_en;
    struct packed {
      logic q; // [86]
    } parity_odd;
    struct packed {
      logic [1:0] q; // [85:84]
    } rxblvl;
    struct packed {
      logic [15:0] q; // [83:68]
    } nco;
  } ctrl;
  struct packed {
    struct packed {
      logic q; // [67]
      logic re; // [66]
    } txfull;
    struct packed {
      logic q; // [65]
      logic re; // [64]
    } rxfull;
    struct packed {
      logic q; // [63]
      logic re; // [62]
    } txempty;
    struct packed {
      logic q; // [61]
      logic re; // [60]
    } txidle;
    struct packed {
      logic q; // [59]
      logic re; // [58]
    } rxidle;
    struct packed {
      logic q; // [57]
      logic re; // [56]
    } rxempty;
  } status;
  struct packed {
    logic [7:0] q; // [55:48]
    logic re; // [47]
  } rdata;
  struct packed {
    logic [7:0] q; // [46:39]
    logic qe; // [38]
  } wdata;
  struct packed {
    struct packed {
      logic q; // [37]
      logic qe; // [36]
    } rxrst;
    struct packed {
      logic q; // [35]
      logic qe; // [34]
    } txrst;
    struct packed {
      logic [2:0] q; // [33:31]
      logic qe; // [30]
    } rxilvl;
    struct packed {
      logic [1:0] q; // [29:28]
      logic qe; // [27]
    } txilvl;
  } fifo_ctrl;
  struct packed {
    struct packed {
      logic q; // [26]
    } txen;
    struct packed {
      logic q; // [25]
    } txval;
  } ovrd;
  struct packed {
    struct packed {
      logic [23:0] q; // [24:1]
    } val;
    struct packed {
      logic q; // [0]
    } en;
  } timeout_ctrl;
} uart_reg2hw_t;

/////////////////////////////////////////////////////////////////////
// Internal design logic to register
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  struct packed {
    struct packed {
      logic d; // [64]
      logic de; // [63]
    } tx_watermark;
    struct packed {
      logic d; // [62]
      logic de; // [61]
    } rx_watermark;
    struct packed {
      logic d; // [60]
      logic de; // [59]
    } tx_overflow;
    struct packed {
      logic d; // [58]
      logic de; // [57]
    } rx_overflow;
    struct packed {
      logic d; // [56]
      logic de; // [55]
    } rx_frame_err;
    struct packed {
      logic d; // [54]
      logic de; // [53]
    } rx_break_err;
    struct packed {
      logic d; // [52]
      logic de; // [51]
    } rx_timeout;
    struct packed {
      logic d; // [50]
      logic de; // [49]
    } rx_parity_err;
  } intr_state;
  struct packed {
    struct packed {
      logic d; // [48]
    } txfull;
    struct packed {
      logic d; // [47]
    } rxfull;
    struct packed {
      logic d; // [46]
    } txempty;
    struct packed {
      logic d; // [45]
    } txidle;
    struct packed {
      logic d; // [44]
    } rxidle;
    struct packed {
      logic d; // [43]
    } rxempty;
  } status;
  struct packed {
    logic [7:0] d; // [42:35]
  } rdata;
  struct packed {
    struct packed {
      logic [2:0] d; // [34:32]
      logic de; // [31]
    } rxilvl;
    struct packed {
      logic [1:0] d; // [30:29]
      logic de; // [28]
    } txilvl;
  } fifo_ctrl;
  struct packed {
    struct packed {
      logic [5:0] d; // [27:22]
    } txlvl;
    struct packed {
      logic [5:0] d; // [21:16]
    } rxlvl;
  } fifo_status;
  struct packed {
    logic [15:0] d; // [15:0]
  } val;
} uart_hw2reg_t;

  // Register Address
  parameter UART_INTR_STATE_OFFSET = 6'h 0;
  parameter UART_INTR_ENABLE_OFFSET = 6'h 4;
  parameter UART_INTR_TEST_OFFSET = 6'h 8;
  parameter UART_CTRL_OFFSET = 6'h c;
  parameter UART_STATUS_OFFSET = 6'h 10;
  parameter UART_RDATA_OFFSET = 6'h 14;
  parameter UART_WDATA_OFFSET = 6'h 18;
  parameter UART_FIFO_CTRL_OFFSET = 6'h 1c;
  parameter UART_FIFO_STATUS_OFFSET = 6'h 20;
  parameter UART_OVRD_OFFSET = 6'h 24;
  parameter UART_VAL_OFFSET = 6'h 28;
  parameter UART_TIMEOUT_CTRL_OFFSET = 6'h 2c;


  // Register Index
  typedef enum int {
    UART_INTR_STATE,
    UART_INTR_ENABLE,
    UART_INTR_TEST,
    UART_CTRL,
    UART_STATUS,
    UART_RDATA,
    UART_WDATA,
    UART_FIFO_CTRL,
    UART_FIFO_STATUS,
    UART_OVRD,
    UART_VAL,
    UART_TIMEOUT_CTRL
  } uart_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] UART_PERMIT [12] = '{
    4'b 0001, // index[ 0] UART_INTR_STATE
    4'b 0001, // index[ 1] UART_INTR_ENABLE
    4'b 0001, // index[ 2] UART_INTR_TEST
    4'b 1111, // index[ 3] UART_CTRL
    4'b 0001, // index[ 4] UART_STATUS
    4'b 0001, // index[ 5] UART_RDATA
    4'b 0001, // index[ 6] UART_WDATA
    4'b 0001, // index[ 7] UART_FIFO_CTRL
    4'b 1111, // index[ 8] UART_FIFO_STATUS
    4'b 0001, // index[ 9] UART_OVRD
    4'b 0011, // index[10] UART_VAL
    4'b 1111  // index[11] UART_TIMEOUT_CTRL
  };
endpackage

