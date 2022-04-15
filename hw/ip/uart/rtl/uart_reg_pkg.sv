// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package uart_reg_pkg;

  // Param list
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 6;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } tx_watermark;
    struct packed {
      logic        q;
    } rx_watermark;
    struct packed {
      logic        q;
    } tx_empty;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } rx_frame_err;
    struct packed {
      logic        q;
    } rx_break_err;
    struct packed {
      logic        q;
    } rx_timeout;
    struct packed {
      logic        q;
    } rx_parity_err;
  } uart_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } tx_watermark;
    struct packed {
      logic        q;
    } rx_watermark;
    struct packed {
      logic        q;
    } tx_empty;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } rx_frame_err;
    struct packed {
      logic        q;
    } rx_break_err;
    struct packed {
      logic        q;
    } rx_timeout;
    struct packed {
      logic        q;
    } rx_parity_err;
  } uart_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } tx_watermark;
    struct packed {
      logic        q;
      logic        qe;
    } rx_watermark;
    struct packed {
      logic        q;
      logic        qe;
    } tx_empty;
    struct packed {
      logic        q;
      logic        qe;
    } rx_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } rx_frame_err;
    struct packed {
      logic        q;
      logic        qe;
    } rx_break_err;
    struct packed {
      logic        q;
      logic        qe;
    } rx_timeout;
    struct packed {
      logic        q;
      logic        qe;
    } rx_parity_err;
  } uart_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } uart_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } tx;
    struct packed {
      logic        q;
    } rx;
    struct packed {
      logic        q;
    } nf;
    struct packed {
      logic        q;
    } slpbk;
    struct packed {
      logic        q;
    } llpbk;
    struct packed {
      logic        q;
    } parity_en;
    struct packed {
      logic        q;
    } parity_odd;
    struct packed {
      logic [1:0]  q;
    } rxblvl;
    struct packed {
      logic [15:0] q;
    } nco;
  } uart_reg2hw_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        re;
    } txfull;
    struct packed {
      logic        q;
      logic        re;
    } rxfull;
    struct packed {
      logic        q;
      logic        re;
    } txempty;
    struct packed {
      logic        q;
      logic        re;
    } txidle;
    struct packed {
      logic        q;
      logic        re;
    } rxidle;
    struct packed {
      logic        q;
      logic        re;
    } rxempty;
  } uart_reg2hw_status_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        re;
  } uart_reg2hw_rdata_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
  } uart_reg2hw_wdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } rxrst;
    struct packed {
      logic        q;
      logic        qe;
    } txrst;
    struct packed {
      logic [2:0]  q;
      logic        qe;
    } rxilvl;
    struct packed {
      logic [1:0]  q;
      logic        qe;
    } txilvl;
  } uart_reg2hw_fifo_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } txen;
    struct packed {
      logic        q;
    } txval;
  } uart_reg2hw_ovrd_reg_t;

  typedef struct packed {
    struct packed {
      logic [23:0] q;
    } val;
    struct packed {
      logic        q;
    } en;
  } uart_reg2hw_timeout_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } tx_watermark;
    struct packed {
      logic        d;
      logic        de;
    } rx_watermark;
    struct packed {
      logic        d;
      logic        de;
    } tx_empty;
    struct packed {
      logic        d;
      logic        de;
    } rx_overflow;
    struct packed {
      logic        d;
      logic        de;
    } rx_frame_err;
    struct packed {
      logic        d;
      logic        de;
    } rx_break_err;
    struct packed {
      logic        d;
      logic        de;
    } rx_timeout;
    struct packed {
      logic        d;
      logic        de;
    } rx_parity_err;
  } uart_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } txfull;
    struct packed {
      logic        d;
    } rxfull;
    struct packed {
      logic        d;
    } txempty;
    struct packed {
      logic        d;
    } txidle;
    struct packed {
      logic        d;
    } rxidle;
    struct packed {
      logic        d;
    } rxempty;
  } uart_hw2reg_status_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } uart_hw2reg_rdata_reg_t;

  typedef struct packed {
    struct packed {
      logic [2:0]  d;
      logic        de;
    } rxilvl;
    struct packed {
      logic [1:0]  d;
      logic        de;
    } txilvl;
  } uart_hw2reg_fifo_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic [5:0]  d;
    } txlvl;
    struct packed {
      logic [5:0]  d;
    } rxlvl;
  } uart_hw2reg_fifo_status_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } uart_hw2reg_val_reg_t;

  // Register -> HW type
  typedef struct packed {
    uart_reg2hw_intr_state_reg_t intr_state; // [126:119]
    uart_reg2hw_intr_enable_reg_t intr_enable; // [118:111]
    uart_reg2hw_intr_test_reg_t intr_test; // [110:95]
    uart_reg2hw_alert_test_reg_t alert_test; // [94:93]
    uart_reg2hw_ctrl_reg_t ctrl; // [92:68]
    uart_reg2hw_status_reg_t status; // [67:56]
    uart_reg2hw_rdata_reg_t rdata; // [55:47]
    uart_reg2hw_wdata_reg_t wdata; // [46:38]
    uart_reg2hw_fifo_ctrl_reg_t fifo_ctrl; // [37:27]
    uart_reg2hw_ovrd_reg_t ovrd; // [26:25]
    uart_reg2hw_timeout_ctrl_reg_t timeout_ctrl; // [24:0]
  } uart_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    uart_hw2reg_intr_state_reg_t intr_state; // [64:49]
    uart_hw2reg_status_reg_t status; // [48:43]
    uart_hw2reg_rdata_reg_t rdata; // [42:35]
    uart_hw2reg_fifo_ctrl_reg_t fifo_ctrl; // [34:28]
    uart_hw2reg_fifo_status_reg_t fifo_status; // [27:16]
    uart_hw2reg_val_reg_t val; // [15:0]
  } uart_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] UART_INTR_STATE_OFFSET = 6'h 0;
  parameter logic [BlockAw-1:0] UART_INTR_ENABLE_OFFSET = 6'h 4;
  parameter logic [BlockAw-1:0] UART_INTR_TEST_OFFSET = 6'h 8;
  parameter logic [BlockAw-1:0] UART_ALERT_TEST_OFFSET = 6'h c;
  parameter logic [BlockAw-1:0] UART_CTRL_OFFSET = 6'h 10;
  parameter logic [BlockAw-1:0] UART_STATUS_OFFSET = 6'h 14;
  parameter logic [BlockAw-1:0] UART_RDATA_OFFSET = 6'h 18;
  parameter logic [BlockAw-1:0] UART_WDATA_OFFSET = 6'h 1c;
  parameter logic [BlockAw-1:0] UART_FIFO_CTRL_OFFSET = 6'h 20;
  parameter logic [BlockAw-1:0] UART_FIFO_STATUS_OFFSET = 6'h 24;
  parameter logic [BlockAw-1:0] UART_OVRD_OFFSET = 6'h 28;
  parameter logic [BlockAw-1:0] UART_VAL_OFFSET = 6'h 2c;
  parameter logic [BlockAw-1:0] UART_TIMEOUT_CTRL_OFFSET = 6'h 30;

  // Reset values for hwext registers and their fields
  parameter logic [7:0] UART_INTR_TEST_RESVAL = 8'h 0;
  parameter logic [0:0] UART_INTR_TEST_TX_WATERMARK_RESVAL = 1'h 0;
  parameter logic [0:0] UART_INTR_TEST_RX_WATERMARK_RESVAL = 1'h 0;
  parameter logic [0:0] UART_INTR_TEST_TX_EMPTY_RESVAL = 1'h 0;
  parameter logic [0:0] UART_INTR_TEST_RX_OVERFLOW_RESVAL = 1'h 0;
  parameter logic [0:0] UART_INTR_TEST_RX_FRAME_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] UART_INTR_TEST_RX_BREAK_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] UART_INTR_TEST_RX_TIMEOUT_RESVAL = 1'h 0;
  parameter logic [0:0] UART_INTR_TEST_RX_PARITY_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] UART_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] UART_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;
  parameter logic [5:0] UART_STATUS_RESVAL = 6'h 3c;
  parameter logic [0:0] UART_STATUS_TXEMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] UART_STATUS_TXIDLE_RESVAL = 1'h 1;
  parameter logic [0:0] UART_STATUS_RXIDLE_RESVAL = 1'h 1;
  parameter logic [0:0] UART_STATUS_RXEMPTY_RESVAL = 1'h 1;
  parameter logic [7:0] UART_RDATA_RESVAL = 8'h 0;
  parameter logic [21:0] UART_FIFO_STATUS_RESVAL = 22'h 0;
  parameter logic [15:0] UART_VAL_RESVAL = 16'h 0;

  // Register index
  typedef enum int {
    UART_INTR_STATE,
    UART_INTR_ENABLE,
    UART_INTR_TEST,
    UART_ALERT_TEST,
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
  parameter logic [3:0] UART_PERMIT [13] = '{
    4'b 0001, // index[ 0] UART_INTR_STATE
    4'b 0001, // index[ 1] UART_INTR_ENABLE
    4'b 0001, // index[ 2] UART_INTR_TEST
    4'b 0001, // index[ 3] UART_ALERT_TEST
    4'b 1111, // index[ 4] UART_CTRL
    4'b 0001, // index[ 5] UART_STATUS
    4'b 0001, // index[ 6] UART_RDATA
    4'b 0001, // index[ 7] UART_WDATA
    4'b 0001, // index[ 8] UART_FIFO_CTRL
    4'b 0111, // index[ 9] UART_FIFO_STATUS
    4'b 0001, // index[10] UART_OVRD
    4'b 0011, // index[11] UART_VAL
    4'b 1111  // index[12] UART_TIMEOUT_CTRL
  };

endpackage
