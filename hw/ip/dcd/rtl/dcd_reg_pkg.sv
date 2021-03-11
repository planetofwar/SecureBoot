// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package dcd_reg_pkg;

  // Param list
  parameter int NumAdcFilter = 8;
  parameter int NumAdcChannel = 2;

  // Address widths within the block
  parameter int BlockAw = 7;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    logic        q;
  } dcd_reg2hw_intr_state_reg_t;

  typedef struct packed {
    logic        q;
  } dcd_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } dcd_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } adc_enable;
    struct packed {
      logic        q;
    } oneshot_mode;
  } dcd_reg2hw_adc_en_ctl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } lp_mode;
    struct packed {
      logic [3:0]  q;
      logic        qe;
    } pwrup_time;
    struct packed {
      logic [23:0] q;
      logic        qe;
    } wakeup_time;
  } dcd_reg2hw_adc_pd_ctl_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
  } dcd_reg2hw_adc_lp_sample_ctl_reg_t;

  typedef struct packed {
    logic [15:0] q;
    logic        qe;
  } dcd_reg2hw_adc_sample_ctl_reg_t;

  typedef struct packed {
    logic        q;
  } dcd_reg2hw_adc_fsm_rst_reg_t;

  typedef struct packed {
    struct packed {
      logic [9:0] q;
      logic        qe;
    } min_v;
    struct packed {
      logic        q;
      logic        qe;
    } cond;
    struct packed {
      logic [9:0] q;
      logic        qe;
    } max_v;
  } dcd_reg2hw_adc_chn0_filter_ctl_mreg_t;

  typedef struct packed {
    struct packed {
      logic [9:0] q;
      logic        qe;
    } min_v;
    struct packed {
      logic        q;
      logic        qe;
    } cond;
    struct packed {
      logic [9:0] q;
      logic        qe;
    } max_v;
  } dcd_reg2hw_adc_chn1_filter_ctl_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } chn0_1_filter0_en;
    struct packed {
      logic        q;
    } chn0_1_filter1_en;
    struct packed {
      logic        q;
    } chn0_1_filter2_en;
    struct packed {
      logic        q;
    } chn0_1_filter3_en;
    struct packed {
      logic        q;
    } chn0_1_filter4_en;
    struct packed {
      logic        q;
    } chn0_1_filter5_en;
    struct packed {
      logic        q;
    } chn0_1_filter6_en;
    struct packed {
      logic        q;
    } chn0_1_filter7_en;
  } dcd_reg2hw_adc_wakeup_ctl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } chn0_1_filter0_en;
    struct packed {
      logic        q;
    } chn0_1_filter1_en;
    struct packed {
      logic        q;
    } chn0_1_filter2_en;
    struct packed {
      logic        q;
    } chn0_1_filter3_en;
    struct packed {
      logic        q;
    } chn0_1_filter4_en;
    struct packed {
      logic        q;
    } chn0_1_filter5_en;
    struct packed {
      logic        q;
    } chn0_1_filter6_en;
    struct packed {
      logic        q;
    } chn0_1_filter7_en;
    struct packed {
      logic        q;
    } oneshot_intr_en;
  } dcd_reg2hw_adc_intr_ctl_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } dcd_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic [1:0]  d;
      logic        de;
    } adc_chn_value_ext;
    struct packed {
      logic [9:0] d;
      logic        de;
    } adc_chn_value;
    struct packed {
      logic [1:0]  d;
      logic        de;
    } adc_chn_value_intr_ext;
    struct packed {
      logic [9:0] d;
      logic        de;
    } adc_chn_value_intr;
  } dcd_hw2reg_adc_chn_val_mreg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } cc_sink_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_1a5_sink_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_3a0_sink_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_src_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_1a5_src_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_src_det_flip;
    struct packed {
      logic        d;
      logic        de;
    } cc_1a5_src_det_flip;
    struct packed {
      logic        d;
      logic        de;
    } cc_discon;
  } dcd_hw2reg_adc_wakeup_status_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } cc_sink_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_1a5_sink_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_3a0_sink_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_src_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_1a5_src_det;
    struct packed {
      logic        d;
      logic        de;
    } cc_src_det_flip;
    struct packed {
      logic        d;
      logic        de;
    } cc_1a5_src_det_flip;
    struct packed {
      logic        d;
      logic        de;
    } cc_discon;
    struct packed {
      logic        d;
      logic        de;
    } oneshot;
  } dcd_hw2reg_adc_intr_status_reg_t;

  // Register -> HW type
  typedef struct packed {
    dcd_reg2hw_intr_state_reg_t intr_state; // [465:465]
    dcd_reg2hw_intr_enable_reg_t intr_enable; // [464:464]
    dcd_reg2hw_intr_test_reg_t intr_test; // [463:462]
    dcd_reg2hw_adc_en_ctl_reg_t adc_en_ctl; // [461:460]
    dcd_reg2hw_adc_pd_ctl_reg_t adc_pd_ctl; // [459:428]
    dcd_reg2hw_adc_lp_sample_ctl_reg_t adc_lp_sample_ctl; // [427:419]
    dcd_reg2hw_adc_sample_ctl_reg_t adc_sample_ctl; // [418:402]
    dcd_reg2hw_adc_fsm_rst_reg_t adc_fsm_rst; // [401:401]
    dcd_reg2hw_adc_chn0_filter_ctl_mreg_t [7:0] adc_chn0_filter_ctl; // [400:209]
    dcd_reg2hw_adc_chn1_filter_ctl_mreg_t [7:0] adc_chn1_filter_ctl; // [208:17]
    dcd_reg2hw_adc_wakeup_ctl_reg_t adc_wakeup_ctl; // [16:9]
    dcd_reg2hw_adc_intr_ctl_reg_t adc_intr_ctl; // [8:0]
  } dcd_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    dcd_hw2reg_intr_state_reg_t intr_state; // [91:90]
    dcd_hw2reg_adc_chn_val_mreg_t [1:0] adc_chn_val; // [89:34]
    dcd_hw2reg_adc_wakeup_status_reg_t adc_wakeup_status; // [33:18]
    dcd_hw2reg_adc_intr_status_reg_t adc_intr_status; // [17:0]
  } dcd_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] DCD_INTR_STATE_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] DCD_INTR_ENABLE_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] DCD_INTR_TEST_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] DCD_ADC_EN_CTL_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] DCD_ADC_PD_CTL_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] DCD_ADC_LP_SAMPLE_CTL_OFFSET = 7'h 14;
  parameter logic [BlockAw-1:0] DCD_ADC_SAMPLE_CTL_OFFSET = 7'h 18;
  parameter logic [BlockAw-1:0] DCD_ADC_FSM_RST_OFFSET = 7'h 1c;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN0_FILTER_CTL_0_OFFSET = 7'h 20;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN0_FILTER_CTL_1_OFFSET = 7'h 24;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN0_FILTER_CTL_2_OFFSET = 7'h 28;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN0_FILTER_CTL_3_OFFSET = 7'h 2c;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN0_FILTER_CTL_4_OFFSET = 7'h 30;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN0_FILTER_CTL_5_OFFSET = 7'h 34;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN0_FILTER_CTL_6_OFFSET = 7'h 38;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN0_FILTER_CTL_7_OFFSET = 7'h 3c;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN1_FILTER_CTL_0_OFFSET = 7'h 40;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN1_FILTER_CTL_1_OFFSET = 7'h 44;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN1_FILTER_CTL_2_OFFSET = 7'h 48;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN1_FILTER_CTL_3_OFFSET = 7'h 4c;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN1_FILTER_CTL_4_OFFSET = 7'h 50;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN1_FILTER_CTL_5_OFFSET = 7'h 54;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN1_FILTER_CTL_6_OFFSET = 7'h 58;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN1_FILTER_CTL_7_OFFSET = 7'h 5c;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN_VAL_0_OFFSET = 7'h 60;
  parameter logic [BlockAw-1:0] DCD_ADC_CHN_VAL_1_OFFSET = 7'h 64;
  parameter logic [BlockAw-1:0] DCD_ADC_WAKEUP_CTL_OFFSET = 7'h 68;
  parameter logic [BlockAw-1:0] DCD_ADC_WAKEUP_STATUS_OFFSET = 7'h 6c;
  parameter logic [BlockAw-1:0] DCD_ADC_INTR_CTL_OFFSET = 7'h 70;
  parameter logic [BlockAw-1:0] DCD_ADC_INTR_STATUS_OFFSET = 7'h 74;

  // Reset values for hwext registers and their fields
  parameter logic [0:0] DCD_INTR_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] DCD_INTR_TEST_DEBUG_CABLE_RESVAL = 1'h 0;

  // Register index
  typedef enum int {
    DCD_INTR_STATE,
    DCD_INTR_ENABLE,
    DCD_INTR_TEST,
    DCD_ADC_EN_CTL,
    DCD_ADC_PD_CTL,
    DCD_ADC_LP_SAMPLE_CTL,
    DCD_ADC_SAMPLE_CTL,
    DCD_ADC_FSM_RST,
    DCD_ADC_CHN0_FILTER_CTL_0,
    DCD_ADC_CHN0_FILTER_CTL_1,
    DCD_ADC_CHN0_FILTER_CTL_2,
    DCD_ADC_CHN0_FILTER_CTL_3,
    DCD_ADC_CHN0_FILTER_CTL_4,
    DCD_ADC_CHN0_FILTER_CTL_5,
    DCD_ADC_CHN0_FILTER_CTL_6,
    DCD_ADC_CHN0_FILTER_CTL_7,
    DCD_ADC_CHN1_FILTER_CTL_0,
    DCD_ADC_CHN1_FILTER_CTL_1,
    DCD_ADC_CHN1_FILTER_CTL_2,
    DCD_ADC_CHN1_FILTER_CTL_3,
    DCD_ADC_CHN1_FILTER_CTL_4,
    DCD_ADC_CHN1_FILTER_CTL_5,
    DCD_ADC_CHN1_FILTER_CTL_6,
    DCD_ADC_CHN1_FILTER_CTL_7,
    DCD_ADC_CHN_VAL_0,
    DCD_ADC_CHN_VAL_1,
    DCD_ADC_WAKEUP_CTL,
    DCD_ADC_WAKEUP_STATUS,
    DCD_ADC_INTR_CTL,
    DCD_ADC_INTR_STATUS
  } dcd_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] DCD_PERMIT [30] = '{
    4'b 0001, // index[ 0] DCD_INTR_STATE
    4'b 0001, // index[ 1] DCD_INTR_ENABLE
    4'b 0001, // index[ 2] DCD_INTR_TEST
    4'b 0001, // index[ 3] DCD_ADC_EN_CTL
    4'b 1111, // index[ 4] DCD_ADC_PD_CTL
    4'b 0001, // index[ 5] DCD_ADC_LP_SAMPLE_CTL
    4'b 0011, // index[ 6] DCD_ADC_SAMPLE_CTL
    4'b 0001, // index[ 7] DCD_ADC_FSM_RST
    4'b 1111, // index[ 8] DCD_ADC_CHN0_FILTER_CTL_0
    4'b 1111, // index[ 9] DCD_ADC_CHN0_FILTER_CTL_1
    4'b 1111, // index[10] DCD_ADC_CHN0_FILTER_CTL_2
    4'b 1111, // index[11] DCD_ADC_CHN0_FILTER_CTL_3
    4'b 1111, // index[12] DCD_ADC_CHN0_FILTER_CTL_4
    4'b 1111, // index[13] DCD_ADC_CHN0_FILTER_CTL_5
    4'b 1111, // index[14] DCD_ADC_CHN0_FILTER_CTL_6
    4'b 1111, // index[15] DCD_ADC_CHN0_FILTER_CTL_7
    4'b 1111, // index[16] DCD_ADC_CHN1_FILTER_CTL_0
    4'b 1111, // index[17] DCD_ADC_CHN1_FILTER_CTL_1
    4'b 1111, // index[18] DCD_ADC_CHN1_FILTER_CTL_2
    4'b 1111, // index[19] DCD_ADC_CHN1_FILTER_CTL_3
    4'b 1111, // index[20] DCD_ADC_CHN1_FILTER_CTL_4
    4'b 1111, // index[21] DCD_ADC_CHN1_FILTER_CTL_5
    4'b 1111, // index[22] DCD_ADC_CHN1_FILTER_CTL_6
    4'b 1111, // index[23] DCD_ADC_CHN1_FILTER_CTL_7
    4'b 1111, // index[24] DCD_ADC_CHN_VAL_0
    4'b 1111, // index[25] DCD_ADC_CHN_VAL_1
    4'b 0001, // index[26] DCD_ADC_WAKEUP_CTL
    4'b 0001, // index[27] DCD_ADC_WAKEUP_STATUS
    4'b 0011, // index[28] DCD_ADC_INTR_CTL
    4'b 0011  // index[29] DCD_ADC_INTR_STATUS
  };

endpackage

