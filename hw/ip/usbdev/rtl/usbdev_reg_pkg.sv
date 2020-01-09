// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package usbdev_reg_pkg;

  // Param list
  localparam int NEndpoints = 12;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } pkt_received;
    struct packed {
      logic        q;
    } pkt_sent;
    struct packed {
      logic        q;
    } disconnected;
    struct packed {
      logic        q;
    } host_lost;
    struct packed {
      logic        q;
    } link_reset;
    struct packed {
      logic        q;
    } link_suspend;
    struct packed {
      logic        q;
    } link_resume;
    struct packed {
      logic        q;
    } av_empty;
    struct packed {
      logic        q;
    } rx_full;
    struct packed {
      logic        q;
    } av_overflow;
    struct packed {
      logic        q;
    } link_in_err;
    struct packed {
      logic        q;
    } rx_crc_err;
    struct packed {
      logic        q;
    } rx_pid_err;
    struct packed {
      logic        q;
    } rx_bitstuff_err;
    struct packed {
      logic        q;
    } frame;
    struct packed {
      logic        q;
    } connected;
  } usbdev_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } pkt_received;
    struct packed {
      logic        q;
    } pkt_sent;
    struct packed {
      logic        q;
    } disconnected;
    struct packed {
      logic        q;
    } host_lost;
    struct packed {
      logic        q;
    } link_reset;
    struct packed {
      logic        q;
    } link_suspend;
    struct packed {
      logic        q;
    } link_resume;
    struct packed {
      logic        q;
    } av_empty;
    struct packed {
      logic        q;
    } rx_full;
    struct packed {
      logic        q;
    } av_overflow;
    struct packed {
      logic        q;
    } link_in_err;
    struct packed {
      logic        q;
    } rx_crc_err;
    struct packed {
      logic        q;
    } rx_pid_err;
    struct packed {
      logic        q;
    } rx_bitstuff_err;
    struct packed {
      logic        q;
    } frame;
    struct packed {
      logic        q;
    } connected;
  } usbdev_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } pkt_received;
    struct packed {
      logic        q;
      logic        qe;
    } pkt_sent;
    struct packed {
      logic        q;
      logic        qe;
    } disconnected;
    struct packed {
      logic        q;
      logic        qe;
    } host_lost;
    struct packed {
      logic        q;
      logic        qe;
    } link_reset;
    struct packed {
      logic        q;
      logic        qe;
    } link_suspend;
    struct packed {
      logic        q;
      logic        qe;
    } link_resume;
    struct packed {
      logic        q;
      logic        qe;
    } av_empty;
    struct packed {
      logic        q;
      logic        qe;
    } rx_full;
    struct packed {
      logic        q;
      logic        qe;
    } av_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } link_in_err;
    struct packed {
      logic        q;
      logic        qe;
    } rx_crc_err;
    struct packed {
      logic        q;
      logic        qe;
    } rx_pid_err;
    struct packed {
      logic        q;
      logic        qe;
    } rx_bitstuff_err;
    struct packed {
      logic        q;
      logic        qe;
    } frame;
    struct packed {
      logic        q;
      logic        qe;
    } connected;
  } usbdev_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } enable;
    struct packed {
      logic [6:0]  q;
    } device_address;
  } usbdev_reg2hw_usbctrl_reg_t;

  typedef struct packed {
    logic [4:0]  q;
    logic        qe;
  } usbdev_reg2hw_avbuffer_reg_t;

  typedef struct packed {
    struct packed {
      logic [4:0]  q;
      logic        re;
    } buffer;
    struct packed {
      logic [6:0]  q;
      logic        re;
    } size;
    struct packed {
      logic        q;
      logic        re;
    } setup;
    struct packed {
      logic [3:0]  q;
      logic        re;
    } ep;
  } usbdev_reg2hw_rxfifo_reg_t;

  typedef struct packed {
    logic        q;
  } usbdev_reg2hw_rxenable_setup_mreg_t;

  typedef struct packed {
    logic        q;
  } usbdev_reg2hw_rxenable_out_mreg_t;

  typedef struct packed {
    logic        q;
  } usbdev_reg2hw_stall_mreg_t;

  typedef struct packed {
    struct packed {
      logic [4:0]  q;
    } buffer;
    struct packed {
      logic [6:0]  q;
    } size;
    struct packed {
      logic        q;
    } pend;
    struct packed {
      logic        q;
    } rdy;
  } usbdev_reg2hw_configin_mreg_t;

  typedef struct packed {
    logic        q;
  } usbdev_reg2hw_iso_mreg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } usbdev_reg2hw_data_toggle_clear_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } rx_differential_mode;
    struct packed {
      logic        q;
    } tx_differential_mode;
    struct packed {
      logic        q;
    } eop_single_bit;
    struct packed {
      logic        q;
    } override_pwr_sense_en;
    struct packed {
      logic        q;
    } override_pwr_sense_val;
  } usbdev_reg2hw_phy_config_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } pkt_received;
    struct packed {
      logic        d;
      logic        de;
    } pkt_sent;
    struct packed {
      logic        d;
      logic        de;
    } disconnected;
    struct packed {
      logic        d;
      logic        de;
    } host_lost;
    struct packed {
      logic        d;
      logic        de;
    } link_reset;
    struct packed {
      logic        d;
      logic        de;
    } link_suspend;
    struct packed {
      logic        d;
      logic        de;
    } link_resume;
    struct packed {
      logic        d;
      logic        de;
    } av_empty;
    struct packed {
      logic        d;
      logic        de;
    } rx_full;
    struct packed {
      logic        d;
      logic        de;
    } av_overflow;
    struct packed {
      logic        d;
      logic        de;
    } link_in_err;
    struct packed {
      logic        d;
      logic        de;
    } rx_crc_err;
    struct packed {
      logic        d;
      logic        de;
    } rx_pid_err;
    struct packed {
      logic        d;
      logic        de;
    } rx_bitstuff_err;
    struct packed {
      logic        d;
      logic        de;
    } frame;
    struct packed {
      logic        d;
      logic        de;
    } connected;
  } usbdev_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic [6:0]  d;
      logic        de;
    } device_address;
  } usbdev_hw2reg_usbctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic [10:0] d;
    } frame;
    struct packed {
      logic        d;
    } host_lost;
    struct packed {
      logic [2:0]  d;
    } link_state;
    struct packed {
      logic        d;
    } usb_sense;
    struct packed {
      logic [2:0]  d;
    } av_depth;
    struct packed {
      logic        d;
    } av_full;
    struct packed {
      logic [2:0]  d;
    } rx_depth;
    struct packed {
      logic        d;
    } rx_empty;
  } usbdev_hw2reg_usbstat_reg_t;

  typedef struct packed {
    struct packed {
      logic [4:0]  d;
    } buffer;
    struct packed {
      logic [6:0]  d;
    } size;
    struct packed {
      logic        d;
    } setup;
    struct packed {
      logic [3:0]  d;
    } ep;
  } usbdev_hw2reg_rxfifo_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } usbdev_hw2reg_in_sent_mreg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } usbdev_hw2reg_stall_mreg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } pend;
    struct packed {
      logic        d;
      logic        de;
    } rdy;
  } usbdev_hw2reg_configin_mreg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    usbdev_reg2hw_intr_state_reg_t intr_state; // [343:328]
    usbdev_reg2hw_intr_enable_reg_t intr_enable; // [327:312]
    usbdev_reg2hw_intr_test_reg_t intr_test; // [311:280]
    usbdev_reg2hw_usbctrl_reg_t usbctrl; // [279:272]
    usbdev_reg2hw_avbuffer_reg_t avbuffer; // [271:266]
    usbdev_reg2hw_rxfifo_reg_t rxfifo; // [265:245]
    usbdev_reg2hw_rxenable_setup_mreg_t [11:0] rxenable_setup; // [244:233]
    usbdev_reg2hw_rxenable_out_mreg_t [11:0] rxenable_out; // [232:221]
    usbdev_reg2hw_stall_mreg_t [11:0] stall; // [220:209]
    usbdev_reg2hw_configin_mreg_t [11:0] configin; // [208:41]
    usbdev_reg2hw_iso_mreg_t [11:0] iso; // [40:29]
    usbdev_reg2hw_data_toggle_clear_mreg_t [11:0] data_toggle_clear; // [28:5]
    usbdev_reg2hw_phy_config_reg_t phy_config; // [4:0]
  } usbdev_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    usbdev_hw2reg_intr_state_reg_t intr_state; // [176:161]
    usbdev_hw2reg_usbctrl_reg_t usbctrl; // [160:153]
    usbdev_hw2reg_usbstat_reg_t usbstat; // [152:153]
    usbdev_hw2reg_rxfifo_reg_t rxfifo; // [152:132]
    usbdev_hw2reg_in_sent_mreg_t [11:0] in_sent; // [131:108]
    usbdev_hw2reg_stall_mreg_t [11:0] stall; // [107:84]
    usbdev_hw2reg_configin_mreg_t [11:0] configin; // [83:36]
  } usbdev_hw2reg_t;

  // Register Address
  parameter USBDEV_INTR_STATE_OFFSET = 12'h 0;
  parameter USBDEV_INTR_ENABLE_OFFSET = 12'h 4;
  parameter USBDEV_INTR_TEST_OFFSET = 12'h 8;
  parameter USBDEV_USBCTRL_OFFSET = 12'h c;
  parameter USBDEV_USBSTAT_OFFSET = 12'h 10;
  parameter USBDEV_AVBUFFER_OFFSET = 12'h 14;
  parameter USBDEV_RXFIFO_OFFSET = 12'h 18;
  parameter USBDEV_RXENABLE_SETUP_OFFSET = 12'h 1c;
  parameter USBDEV_RXENABLE_OUT_OFFSET = 12'h 20;
  parameter USBDEV_IN_SENT_OFFSET = 12'h 24;
  parameter USBDEV_STALL_OFFSET = 12'h 28;
  parameter USBDEV_CONFIGIN0_OFFSET = 12'h 2c;
  parameter USBDEV_CONFIGIN1_OFFSET = 12'h 30;
  parameter USBDEV_CONFIGIN2_OFFSET = 12'h 34;
  parameter USBDEV_CONFIGIN3_OFFSET = 12'h 38;
  parameter USBDEV_CONFIGIN4_OFFSET = 12'h 3c;
  parameter USBDEV_CONFIGIN5_OFFSET = 12'h 40;
  parameter USBDEV_CONFIGIN6_OFFSET = 12'h 44;
  parameter USBDEV_CONFIGIN7_OFFSET = 12'h 48;
  parameter USBDEV_CONFIGIN8_OFFSET = 12'h 4c;
  parameter USBDEV_CONFIGIN9_OFFSET = 12'h 50;
  parameter USBDEV_CONFIGIN10_OFFSET = 12'h 54;
  parameter USBDEV_CONFIGIN11_OFFSET = 12'h 58;
  parameter USBDEV_ISO_OFFSET = 12'h 5c;
  parameter USBDEV_DATA_TOGGLE_CLEAR_OFFSET = 12'h 60;
  parameter USBDEV_PHY_CONFIG_OFFSET = 12'h 64;

  // Window parameter
  parameter USBDEV_BUFFER_OFFSET = 12'h 800;
  parameter USBDEV_BUFFER_SIZE   = 12'h 800;

  // Register Index
  typedef enum int {
    USBDEV_INTR_STATE,
    USBDEV_INTR_ENABLE,
    USBDEV_INTR_TEST,
    USBDEV_USBCTRL,
    USBDEV_USBSTAT,
    USBDEV_AVBUFFER,
    USBDEV_RXFIFO,
    USBDEV_RXENABLE_SETUP,
    USBDEV_RXENABLE_OUT,
    USBDEV_IN_SENT,
    USBDEV_STALL,
    USBDEV_CONFIGIN0,
    USBDEV_CONFIGIN1,
    USBDEV_CONFIGIN2,
    USBDEV_CONFIGIN3,
    USBDEV_CONFIGIN4,
    USBDEV_CONFIGIN5,
    USBDEV_CONFIGIN6,
    USBDEV_CONFIGIN7,
    USBDEV_CONFIGIN8,
    USBDEV_CONFIGIN9,
    USBDEV_CONFIGIN10,
    USBDEV_CONFIGIN11,
    USBDEV_ISO,
    USBDEV_DATA_TOGGLE_CLEAR,
    USBDEV_PHY_CONFIG
  } usbdev_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] USBDEV_PERMIT [26] = '{
    4'b 0011, // index[ 0] USBDEV_INTR_STATE
    4'b 0011, // index[ 1] USBDEV_INTR_ENABLE
    4'b 0011, // index[ 2] USBDEV_INTR_TEST
    4'b 0111, // index[ 3] USBDEV_USBCTRL
    4'b 1111, // index[ 4] USBDEV_USBSTAT
    4'b 0001, // index[ 5] USBDEV_AVBUFFER
    4'b 0111, // index[ 6] USBDEV_RXFIFO
    4'b 0011, // index[ 7] USBDEV_RXENABLE_SETUP
    4'b 0011, // index[ 8] USBDEV_RXENABLE_OUT
    4'b 0011, // index[ 9] USBDEV_IN_SENT
    4'b 0011, // index[10] USBDEV_STALL
    4'b 1111, // index[11] USBDEV_CONFIGIN0
    4'b 1111, // index[12] USBDEV_CONFIGIN1
    4'b 1111, // index[13] USBDEV_CONFIGIN2
    4'b 1111, // index[14] USBDEV_CONFIGIN3
    4'b 1111, // index[15] USBDEV_CONFIGIN4
    4'b 1111, // index[16] USBDEV_CONFIGIN5
    4'b 1111, // index[17] USBDEV_CONFIGIN6
    4'b 1111, // index[18] USBDEV_CONFIGIN7
    4'b 1111, // index[19] USBDEV_CONFIGIN8
    4'b 1111, // index[20] USBDEV_CONFIGIN9
    4'b 1111, // index[21] USBDEV_CONFIGIN10
    4'b 1111, // index[22] USBDEV_CONFIGIN11
    4'b 0011, // index[23] USBDEV_ISO
    4'b 0011, // index[24] USBDEV_DATA_TOGGLE_CLEAR
    4'b 0001  // index[25] USBDEV_PHY_CONFIG
  };
endpackage

