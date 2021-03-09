// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package spi_device_reg_pkg;

  // Param list
  parameter int unsigned SramDepth = 1024;

  // Address width within the block
  parameter int BlockAw = 13;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } rxf;
    struct packed {
      logic        q;
    } rxlvl;
    struct packed {
      logic        q;
    } txlvl;
    struct packed {
      logic        q;
    } rxerr;
    struct packed {
      logic        q;
    } rxoverflow;
    struct packed {
      logic        q;
    } txunderflow;
  } spi_device_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } rxf;
    struct packed {
      logic        q;
    } rxlvl;
    struct packed {
      logic        q;
    } txlvl;
    struct packed {
      logic        q;
    } rxerr;
    struct packed {
      logic        q;
    } rxoverflow;
    struct packed {
      logic        q;
    } txunderflow;
  } spi_device_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } rxf;
    struct packed {
      logic        q;
      logic        qe;
    } rxlvl;
    struct packed {
      logic        q;
      logic        qe;
    } txlvl;
    struct packed {
      logic        q;
      logic        qe;
    } rxerr;
    struct packed {
      logic        q;
      logic        qe;
    } rxoverflow;
    struct packed {
      logic        q;
      logic        qe;
    } txunderflow;
  } spi_device_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } abort;
    struct packed {
      logic [1:0]  q;
    } mode;
    struct packed {
      logic        q;
    } rst_txfifo;
    struct packed {
      logic        q;
    } rst_rxfifo;
  } spi_device_reg2hw_control_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } cpol;
    struct packed {
      logic        q;
    } cpha;
    struct packed {
      logic        q;
    } tx_order;
    struct packed {
      logic        q;
    } rx_order;
    struct packed {
      logic [7:0]  q;
    } timer_v;
  } spi_device_reg2hw_cfg_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } rxlvl;
    struct packed {
      logic [15:0] q;
    } txlvl;
  } spi_device_reg2hw_fifo_level_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } rptr;
  } spi_device_reg2hw_rxf_ptr_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } wptr;
  } spi_device_reg2hw_txf_ptr_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } base;
    struct packed {
      logic [15:0] q;
    } limit;
  } spi_device_reg2hw_rxf_addr_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } base;
    struct packed {
      logic [15:0] q;
    } limit;
  } spi_device_reg2hw_txf_addr_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } rxf;
    struct packed {
      logic        d;
      logic        de;
    } rxlvl;
    struct packed {
      logic        d;
      logic        de;
    } txlvl;
    struct packed {
      logic        d;
      logic        de;
    } rxerr;
    struct packed {
      logic        d;
      logic        de;
    } rxoverflow;
    struct packed {
      logic        d;
      logic        de;
    } txunderflow;
  } spi_device_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  d;
    } rxlvl;
    struct packed {
      logic [7:0]  d;
    } txlvl;
  } spi_device_hw2reg_async_fifo_level_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } rxf_full;
    struct packed {
      logic        d;
    } rxf_empty;
    struct packed {
      logic        d;
    } txf_full;
    struct packed {
      logic        d;
    } txf_empty;
    struct packed {
      logic        d;
    } abort_done;
    struct packed {
      logic        d;
    } csb;
  } spi_device_hw2reg_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
      logic        de;
    } wptr;
  } spi_device_hw2reg_rxf_ptr_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
      logic        de;
    } rptr;
  } spi_device_hw2reg_txf_ptr_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    spi_device_reg2hw_intr_state_reg_t intr_state; // [168:163]
    spi_device_reg2hw_intr_enable_reg_t intr_enable; // [162:157]
    spi_device_reg2hw_intr_test_reg_t intr_test; // [156:145]
    spi_device_reg2hw_control_reg_t control; // [144:140]
    spi_device_reg2hw_cfg_reg_t cfg; // [139:128]
    spi_device_reg2hw_fifo_level_reg_t fifo_level; // [127:96]
    spi_device_reg2hw_rxf_ptr_reg_t rxf_ptr; // [95:80]
    spi_device_reg2hw_txf_ptr_reg_t txf_ptr; // [79:64]
    spi_device_reg2hw_rxf_addr_reg_t rxf_addr; // [63:32]
    spi_device_reg2hw_txf_addr_reg_t txf_addr; // [31:0]
  } spi_device_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    spi_device_hw2reg_intr_state_reg_t intr_state; // [67:56]
    spi_device_hw2reg_async_fifo_level_reg_t async_fifo_level; // [55:40]
    spi_device_hw2reg_status_reg_t status; // [39:34]
    spi_device_hw2reg_rxf_ptr_reg_t rxf_ptr; // [33:17]
    spi_device_hw2reg_txf_ptr_reg_t txf_ptr; // [16:0]
  } spi_device_hw2reg_t;

  // Register Address
  parameter logic [BlockAw-1:0] SPI_DEVICE_INTR_STATE_OFFSET = 13'h 0;
  parameter logic [BlockAw-1:0] SPI_DEVICE_INTR_ENABLE_OFFSET = 13'h 4;
  parameter logic [BlockAw-1:0] SPI_DEVICE_INTR_TEST_OFFSET = 13'h 8;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CONTROL_OFFSET = 13'h c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_CFG_OFFSET = 13'h 10;
  parameter logic [BlockAw-1:0] SPI_DEVICE_FIFO_LEVEL_OFFSET = 13'h 14;
  parameter logic [BlockAw-1:0] SPI_DEVICE_ASYNC_FIFO_LEVEL_OFFSET = 13'h 18;
  parameter logic [BlockAw-1:0] SPI_DEVICE_STATUS_OFFSET = 13'h 1c;
  parameter logic [BlockAw-1:0] SPI_DEVICE_RXF_PTR_OFFSET = 13'h 20;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TXF_PTR_OFFSET = 13'h 24;
  parameter logic [BlockAw-1:0] SPI_DEVICE_RXF_ADDR_OFFSET = 13'h 28;
  parameter logic [BlockAw-1:0] SPI_DEVICE_TXF_ADDR_OFFSET = 13'h 2c;

  // Reset values for hwext registers and their fields
  parameter logic [5:0] SPI_DEVICE_INTR_TEST_RESVAL = 6'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_RXF_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_RXLVL_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_TXLVL_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_RXERR_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_RXOVERFLOW_RESVAL = 1'h 0;
  parameter logic [0:0] SPI_DEVICE_INTR_TEST_TXUNDERFLOW_RESVAL = 1'h 0;
  parameter logic [23:0] SPI_DEVICE_ASYNC_FIFO_LEVEL_RESVAL = 24'h 0;
  parameter logic [5:0] SPI_DEVICE_STATUS_RESVAL = 6'h 3a;
  parameter logic [0:0] SPI_DEVICE_STATUS_RXF_EMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] SPI_DEVICE_STATUS_TXF_EMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] SPI_DEVICE_STATUS_ABORT_DONE_RESVAL = 1'h 1;
  parameter logic [0:0] SPI_DEVICE_STATUS_CSB_RESVAL = 1'h 1;

  // Window parameter
  parameter logic [BlockAw-1:0] SPI_DEVICE_BUFFER_OFFSET = 13'h 1000;
  parameter int unsigned        SPI_DEVICE_BUFFER_SIZE   = 'h 1000;

  // Register Index
  typedef enum int {
    SPI_DEVICE_INTR_STATE,
    SPI_DEVICE_INTR_ENABLE,
    SPI_DEVICE_INTR_TEST,
    SPI_DEVICE_CONTROL,
    SPI_DEVICE_CFG,
    SPI_DEVICE_FIFO_LEVEL,
    SPI_DEVICE_ASYNC_FIFO_LEVEL,
    SPI_DEVICE_STATUS,
    SPI_DEVICE_RXF_PTR,
    SPI_DEVICE_TXF_PTR,
    SPI_DEVICE_RXF_ADDR,
    SPI_DEVICE_TXF_ADDR
  } spi_device_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] SPI_DEVICE_PERMIT [12] = '{
    4'b 0001, // index[ 0] SPI_DEVICE_INTR_STATE
    4'b 0001, // index[ 1] SPI_DEVICE_INTR_ENABLE
    4'b 0001, // index[ 2] SPI_DEVICE_INTR_TEST
    4'b 0111, // index[ 3] SPI_DEVICE_CONTROL
    4'b 0011, // index[ 4] SPI_DEVICE_CFG
    4'b 1111, // index[ 5] SPI_DEVICE_FIFO_LEVEL
    4'b 0111, // index[ 6] SPI_DEVICE_ASYNC_FIFO_LEVEL
    4'b 0001, // index[ 7] SPI_DEVICE_STATUS
    4'b 1111, // index[ 8] SPI_DEVICE_RXF_PTR
    4'b 1111, // index[ 9] SPI_DEVICE_TXF_PTR
    4'b 1111, // index[10] SPI_DEVICE_RXF_ADDR
    4'b 1111  // index[11] SPI_DEVICE_TXF_ADDR
  };
endpackage

