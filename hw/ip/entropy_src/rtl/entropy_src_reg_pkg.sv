// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package entropy_src_reg_pkg;

  // Param list
  parameter int NumAlerts = 2;

  // Address widths within the block
  parameter int BlockAw = 8;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } es_entropy_valid;
    struct packed {
      logic        q;
    } es_health_test_failed;
    struct packed {
      logic        q;
    } es_observe_fifo_ready;
    struct packed {
      logic        q;
    } es_fatal_err;
  } entropy_src_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } es_entropy_valid;
    struct packed {
      logic        q;
    } es_health_test_failed;
    struct packed {
      logic        q;
    } es_observe_fifo_ready;
    struct packed {
      logic        q;
    } es_fatal_err;
  } entropy_src_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } es_entropy_valid;
    struct packed {
      logic        q;
      logic        qe;
    } es_health_test_failed;
    struct packed {
      logic        q;
      logic        qe;
    } es_observe_fifo_ready;
    struct packed {
      logic        q;
      logic        qe;
    } es_fatal_err;
  } entropy_src_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } recov_alert;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_alert;
  } entropy_src_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic        q;
  } entropy_src_reg2hw_sw_regupd_reg_t;

  typedef struct packed {
    logic [3:0]  q;
  } entropy_src_reg2hw_module_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic [3:0]  q;
    } fips_enable;
    struct packed {
      logic [3:0]  q;
    } entropy_data_reg_enable;
    struct packed {
      logic [3:0]  q;
    } threshold_scope;
    struct packed {
      logic [3:0]  q;
    } rng_bit_enable;
    struct packed {
      logic [1:0]  q;
    } rng_bit_sel;
  } entropy_src_reg2hw_conf_reg_t;

  typedef struct packed {
    struct packed {
      logic [3:0]  q;
    } es_route;
    struct packed {
      logic [3:0]  q;
    } es_type;
  } entropy_src_reg2hw_entropy_control_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        re;
  } entropy_src_reg2hw_entropy_data_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } fips_window;
    struct packed {
      logic [15:0] q;
    } bypass_window;
  } entropy_src_reg2hw_health_test_windows_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_repcnt_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_repcnts_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_adaptp_hi_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_adaptp_lo_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_bucket_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_markov_hi_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_markov_lo_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_extht_hi_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } fips_thresh;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } bypass_thresh;
  } entropy_src_reg2hw_extht_lo_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } alert_threshold;
    struct packed {
      logic [15:0] q;
    } alert_threshold_inv;
  } entropy_src_reg2hw_alert_threshold_reg_t;

  typedef struct packed {
    struct packed {
      logic [3:0]  q;
    } fw_ov_mode;
    struct packed {
      logic [3:0]  q;
    } fw_ov_entropy_insert;
  } entropy_src_reg2hw_fw_ov_control_reg_t;

  typedef struct packed {
    logic [3:0]  q;
  } entropy_src_reg2hw_fw_ov_sha3_start_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        re;
  } entropy_src_reg2hw_fw_ov_rd_data_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } entropy_src_reg2hw_fw_ov_wr_data_reg_t;

  typedef struct packed {
    logic [6:0]  q;
  } entropy_src_reg2hw_observe_fifo_thresh_reg_t;

  typedef struct packed {
    logic [4:0]  q;
    logic        qe;
  } entropy_src_reg2hw_err_code_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } es_entropy_valid;
    struct packed {
      logic        d;
      logic        de;
    } es_health_test_failed;
    struct packed {
      logic        d;
      logic        de;
    } es_observe_fifo_ready;
    struct packed {
      logic        d;
      logic        de;
    } es_fatal_err;
  } entropy_src_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } entropy_src_hw2reg_regwen_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_entropy_data_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_repcnt_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_repcnts_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_adaptp_hi_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_adaptp_lo_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_bucket_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_markov_hi_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_markov_lo_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_extht_hi_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_thresh;
    struct packed {
      logic [15:0] d;
    } bypass_thresh;
  } entropy_src_hw2reg_extht_lo_thresholds_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_repcnt_hi_watermarks_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_repcnts_hi_watermarks_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_adaptp_hi_watermarks_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_adaptp_lo_watermarks_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_extht_hi_watermarks_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_extht_lo_watermarks_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_bucket_hi_watermarks_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_markov_hi_watermarks_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } fips_watermark;
    struct packed {
      logic [15:0] d;
    } bypass_watermark;
  } entropy_src_hw2reg_markov_lo_watermarks_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_repcnt_total_fails_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_repcnts_total_fails_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_adaptp_hi_total_fails_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_adaptp_lo_total_fails_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_bucket_total_fails_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_markov_hi_total_fails_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_markov_lo_total_fails_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_extht_hi_total_fails_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_extht_lo_total_fails_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } entropy_src_hw2reg_alert_summary_fail_counts_reg_t;

  typedef struct packed {
    struct packed {
      logic [3:0]  d;
    } repcnt_fail_count;
    struct packed {
      logic [3:0]  d;
    } adaptp_hi_fail_count;
    struct packed {
      logic [3:0]  d;
    } adaptp_lo_fail_count;
    struct packed {
      logic [3:0]  d;
    } bucket_fail_count;
    struct packed {
      logic [3:0]  d;
    } markov_hi_fail_count;
    struct packed {
      logic [3:0]  d;
    } markov_lo_fail_count;
    struct packed {
      logic [3:0]  d;
    } repcnts_fail_count;
  } entropy_src_hw2reg_alert_fail_counts_reg_t;

  typedef struct packed {
    struct packed {
      logic [3:0]  d;
    } extht_hi_fail_count;
    struct packed {
      logic [3:0]  d;
    } extht_lo_fail_count;
  } entropy_src_hw2reg_extht_fail_counts_reg_t;

  typedef struct packed {
    logic        d;
  } entropy_src_hw2reg_fw_ov_wr_fifo_full_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } entropy_src_hw2reg_fw_ov_rd_fifo_overflow_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } entropy_src_hw2reg_fw_ov_rd_data_reg_t;

  typedef struct packed {
    logic [6:0]  d;
  } entropy_src_hw2reg_observe_fifo_depth_reg_t;

  typedef struct packed {
    struct packed {
      logic [2:0]  d;
    } entropy_fifo_depth;
    struct packed {
      logic [2:0]  d;
    } sha3_fsm;
    struct packed {
      logic        d;
    } sha3_block_pr;
    struct packed {
      logic        d;
    } sha3_squeezing;
    struct packed {
      logic        d;
    } sha3_absorbed;
    struct packed {
      logic        d;
    } sha3_err;
    struct packed {
      logic        d;
    } main_sm_idle;
    struct packed {
      logic        d;
    } main_sm_boot_done;
  } entropy_src_hw2reg_debug_status_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } fips_enable_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } entropy_data_reg_en_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } module_enable_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } threshold_scope_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } rng_bit_enable_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } fw_ov_sha3_start_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } fw_ov_mode_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } fw_ov_entropy_insert_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } es_route_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } es_type_field_alert;
    struct packed {
      logic        d;
      logic        de;
    } es_main_sm_alert;
    struct packed {
      logic        d;
      logic        de;
    } es_bus_cmp_alert;
    struct packed {
      logic        d;
      logic        de;
    } es_thresh_cfg_alert;
  } entropy_src_hw2reg_recov_alert_sts_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } sfifo_esrng_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_observe_err;
    struct packed {
      logic        d;
      logic        de;
    } sfifo_esfinal_err;
    struct packed {
      logic        d;
      logic        de;
    } es_ack_sm_err;
    struct packed {
      logic        d;
      logic        de;
    } es_main_sm_err;
    struct packed {
      logic        d;
      logic        de;
    } es_cntr_err;
    struct packed {
      logic        d;
      logic        de;
    } fifo_write_err;
    struct packed {
      logic        d;
      logic        de;
    } fifo_read_err;
    struct packed {
      logic        d;
      logic        de;
    } fifo_state_err;
  } entropy_src_hw2reg_err_code_reg_t;

  typedef struct packed {
    logic [8:0]  d;
    logic        de;
  } entropy_src_hw2reg_main_sm_state_reg_t;

  // Register -> HW type
  typedef struct packed {
    entropy_src_reg2hw_intr_state_reg_t intr_state; // [544:541]
    entropy_src_reg2hw_intr_enable_reg_t intr_enable; // [540:537]
    entropy_src_reg2hw_intr_test_reg_t intr_test; // [536:529]
    entropy_src_reg2hw_alert_test_reg_t alert_test; // [528:525]
    entropy_src_reg2hw_sw_regupd_reg_t sw_regupd; // [524:524]
    entropy_src_reg2hw_module_enable_reg_t module_enable; // [523:520]
    entropy_src_reg2hw_conf_reg_t conf; // [519:502]
    entropy_src_reg2hw_entropy_control_reg_t entropy_control; // [501:494]
    entropy_src_reg2hw_entropy_data_reg_t entropy_data; // [493:461]
    entropy_src_reg2hw_health_test_windows_reg_t health_test_windows; // [460:429]
    entropy_src_reg2hw_repcnt_thresholds_reg_t repcnt_thresholds; // [428:395]
    entropy_src_reg2hw_repcnts_thresholds_reg_t repcnts_thresholds; // [394:361]
    entropy_src_reg2hw_adaptp_hi_thresholds_reg_t adaptp_hi_thresholds; // [360:327]
    entropy_src_reg2hw_adaptp_lo_thresholds_reg_t adaptp_lo_thresholds; // [326:293]
    entropy_src_reg2hw_bucket_thresholds_reg_t bucket_thresholds; // [292:259]
    entropy_src_reg2hw_markov_hi_thresholds_reg_t markov_hi_thresholds; // [258:225]
    entropy_src_reg2hw_markov_lo_thresholds_reg_t markov_lo_thresholds; // [224:191]
    entropy_src_reg2hw_extht_hi_thresholds_reg_t extht_hi_thresholds; // [190:157]
    entropy_src_reg2hw_extht_lo_thresholds_reg_t extht_lo_thresholds; // [156:123]
    entropy_src_reg2hw_alert_threshold_reg_t alert_threshold; // [122:91]
    entropy_src_reg2hw_fw_ov_control_reg_t fw_ov_control; // [90:83]
    entropy_src_reg2hw_fw_ov_sha3_start_reg_t fw_ov_sha3_start; // [82:79]
    entropy_src_reg2hw_fw_ov_rd_data_reg_t fw_ov_rd_data; // [78:46]
    entropy_src_reg2hw_fw_ov_wr_data_reg_t fw_ov_wr_data; // [45:13]
    entropy_src_reg2hw_observe_fifo_thresh_reg_t observe_fifo_thresh; // [12:6]
    entropy_src_reg2hw_err_code_test_reg_t err_code_test; // [5:0]
  } entropy_src_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    entropy_src_hw2reg_intr_state_reg_t intr_state; // [1065:1058]
    entropy_src_hw2reg_regwen_reg_t regwen; // [1057:1056]
    entropy_src_hw2reg_entropy_data_reg_t entropy_data; // [1055:1024]
    entropy_src_hw2reg_repcnt_thresholds_reg_t repcnt_thresholds; // [1023:992]
    entropy_src_hw2reg_repcnts_thresholds_reg_t repcnts_thresholds; // [991:960]
    entropy_src_hw2reg_adaptp_hi_thresholds_reg_t adaptp_hi_thresholds; // [959:928]
    entropy_src_hw2reg_adaptp_lo_thresholds_reg_t adaptp_lo_thresholds; // [927:896]
    entropy_src_hw2reg_bucket_thresholds_reg_t bucket_thresholds; // [895:864]
    entropy_src_hw2reg_markov_hi_thresholds_reg_t markov_hi_thresholds; // [863:832]
    entropy_src_hw2reg_markov_lo_thresholds_reg_t markov_lo_thresholds; // [831:800]
    entropy_src_hw2reg_extht_hi_thresholds_reg_t extht_hi_thresholds; // [799:768]
    entropy_src_hw2reg_extht_lo_thresholds_reg_t extht_lo_thresholds; // [767:736]
    entropy_src_hw2reg_repcnt_hi_watermarks_reg_t repcnt_hi_watermarks; // [735:704]
    entropy_src_hw2reg_repcnts_hi_watermarks_reg_t repcnts_hi_watermarks; // [703:672]
    entropy_src_hw2reg_adaptp_hi_watermarks_reg_t adaptp_hi_watermarks; // [671:640]
    entropy_src_hw2reg_adaptp_lo_watermarks_reg_t adaptp_lo_watermarks; // [639:608]
    entropy_src_hw2reg_extht_hi_watermarks_reg_t extht_hi_watermarks; // [607:576]
    entropy_src_hw2reg_extht_lo_watermarks_reg_t extht_lo_watermarks; // [575:544]
    entropy_src_hw2reg_bucket_hi_watermarks_reg_t bucket_hi_watermarks; // [543:512]
    entropy_src_hw2reg_markov_hi_watermarks_reg_t markov_hi_watermarks; // [511:480]
    entropy_src_hw2reg_markov_lo_watermarks_reg_t markov_lo_watermarks; // [479:448]
    entropy_src_hw2reg_repcnt_total_fails_reg_t repcnt_total_fails; // [447:416]
    entropy_src_hw2reg_repcnts_total_fails_reg_t repcnts_total_fails; // [415:384]
    entropy_src_hw2reg_adaptp_hi_total_fails_reg_t adaptp_hi_total_fails; // [383:352]
    entropy_src_hw2reg_adaptp_lo_total_fails_reg_t adaptp_lo_total_fails; // [351:320]
    entropy_src_hw2reg_bucket_total_fails_reg_t bucket_total_fails; // [319:288]
    entropy_src_hw2reg_markov_hi_total_fails_reg_t markov_hi_total_fails; // [287:256]
    entropy_src_hw2reg_markov_lo_total_fails_reg_t markov_lo_total_fails; // [255:224]
    entropy_src_hw2reg_extht_hi_total_fails_reg_t extht_hi_total_fails; // [223:192]
    entropy_src_hw2reg_extht_lo_total_fails_reg_t extht_lo_total_fails; // [191:160]
    entropy_src_hw2reg_alert_summary_fail_counts_reg_t alert_summary_fail_counts; // [159:144]
    entropy_src_hw2reg_alert_fail_counts_reg_t alert_fail_counts; // [143:116]
    entropy_src_hw2reg_extht_fail_counts_reg_t extht_fail_counts; // [115:108]
    entropy_src_hw2reg_fw_ov_wr_fifo_full_reg_t fw_ov_wr_fifo_full; // [107:107]
    entropy_src_hw2reg_fw_ov_rd_fifo_overflow_reg_t fw_ov_rd_fifo_overflow; // [106:105]
    entropy_src_hw2reg_fw_ov_rd_data_reg_t fw_ov_rd_data; // [104:73]
    entropy_src_hw2reg_observe_fifo_depth_reg_t observe_fifo_depth; // [72:66]
    entropy_src_hw2reg_debug_status_reg_t debug_status; // [65:54]
    entropy_src_hw2reg_recov_alert_sts_reg_t recov_alert_sts; // [53:28]
    entropy_src_hw2reg_err_code_reg_t err_code; // [27:10]
    entropy_src_hw2reg_main_sm_state_reg_t main_sm_state; // [9:0]
  } entropy_src_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] ENTROPY_SRC_INTR_STATE_OFFSET = 8'h 0;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_INTR_ENABLE_OFFSET = 8'h 4;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_INTR_TEST_OFFSET = 8'h 8;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ALERT_TEST_OFFSET = 8'h c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ME_REGWEN_OFFSET = 8'h 10;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_SW_REGUPD_OFFSET = 8'h 14;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_REGWEN_OFFSET = 8'h 18;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_REV_OFFSET = 8'h 1c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_MODULE_ENABLE_OFFSET = 8'h 20;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_CONF_OFFSET = 8'h 24;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ENTROPY_CONTROL_OFFSET = 8'h 28;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ENTROPY_DATA_OFFSET = 8'h 2c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_HEALTH_TEST_WINDOWS_OFFSET = 8'h 30;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_REPCNT_THRESHOLDS_OFFSET = 8'h 34;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_REPCNTS_THRESHOLDS_OFFSET = 8'h 38;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ADAPTP_HI_THRESHOLDS_OFFSET = 8'h 3c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ADAPTP_LO_THRESHOLDS_OFFSET = 8'h 40;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_BUCKET_THRESHOLDS_OFFSET = 8'h 44;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_MARKOV_HI_THRESHOLDS_OFFSET = 8'h 48;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_MARKOV_LO_THRESHOLDS_OFFSET = 8'h 4c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_EXTHT_HI_THRESHOLDS_OFFSET = 8'h 50;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_EXTHT_LO_THRESHOLDS_OFFSET = 8'h 54;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_REPCNT_HI_WATERMARKS_OFFSET = 8'h 58;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_REPCNTS_HI_WATERMARKS_OFFSET = 8'h 5c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ADAPTP_HI_WATERMARKS_OFFSET = 8'h 60;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ADAPTP_LO_WATERMARKS_OFFSET = 8'h 64;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_EXTHT_HI_WATERMARKS_OFFSET = 8'h 68;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_EXTHT_LO_WATERMARKS_OFFSET = 8'h 6c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_BUCKET_HI_WATERMARKS_OFFSET = 8'h 70;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_MARKOV_HI_WATERMARKS_OFFSET = 8'h 74;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_MARKOV_LO_WATERMARKS_OFFSET = 8'h 78;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_REPCNT_TOTAL_FAILS_OFFSET = 8'h 7c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_REPCNTS_TOTAL_FAILS_OFFSET = 8'h 80;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ADAPTP_HI_TOTAL_FAILS_OFFSET = 8'h 84;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ADAPTP_LO_TOTAL_FAILS_OFFSET = 8'h 88;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_BUCKET_TOTAL_FAILS_OFFSET = 8'h 8c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_MARKOV_HI_TOTAL_FAILS_OFFSET = 8'h 90;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_MARKOV_LO_TOTAL_FAILS_OFFSET = 8'h 94;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_EXTHT_HI_TOTAL_FAILS_OFFSET = 8'h 98;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_EXTHT_LO_TOTAL_FAILS_OFFSET = 8'h 9c;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ALERT_THRESHOLD_OFFSET = 8'h a0;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ALERT_SUMMARY_FAIL_COUNTS_OFFSET = 8'h a4;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ALERT_FAIL_COUNTS_OFFSET = 8'h a8;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_EXTHT_FAIL_COUNTS_OFFSET = 8'h ac;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_FW_OV_CONTROL_OFFSET = 8'h b0;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_FW_OV_SHA3_START_OFFSET = 8'h b4;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_FW_OV_WR_FIFO_FULL_OFFSET = 8'h b8;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_FW_OV_RD_FIFO_OVERFLOW_OFFSET = 8'h bc;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_FW_OV_RD_DATA_OFFSET = 8'h c0;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_FW_OV_WR_DATA_OFFSET = 8'h c4;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_OBSERVE_FIFO_THRESH_OFFSET = 8'h c8;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_OBSERVE_FIFO_DEPTH_OFFSET = 8'h cc;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_DEBUG_STATUS_OFFSET = 8'h d0;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_RECOV_ALERT_STS_OFFSET = 8'h d4;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ERR_CODE_OFFSET = 8'h d8;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_ERR_CODE_TEST_OFFSET = 8'h dc;
  parameter logic [BlockAw-1:0] ENTROPY_SRC_MAIN_SM_STATE_OFFSET = 8'h e0;

  // Reset values for hwext registers and their fields
  parameter logic [3:0] ENTROPY_SRC_INTR_TEST_RESVAL = 4'h 0;
  parameter logic [0:0] ENTROPY_SRC_INTR_TEST_ES_ENTROPY_VALID_RESVAL = 1'h 0;
  parameter logic [0:0] ENTROPY_SRC_INTR_TEST_ES_HEALTH_TEST_FAILED_RESVAL = 1'h 0;
  parameter logic [0:0] ENTROPY_SRC_INTR_TEST_ES_OBSERVE_FIFO_READY_RESVAL = 1'h 0;
  parameter logic [0:0] ENTROPY_SRC_INTR_TEST_ES_FATAL_ERR_RESVAL = 1'h 0;
  parameter logic [1:0] ENTROPY_SRC_ALERT_TEST_RESVAL = 2'h 0;
  parameter logic [0:0] ENTROPY_SRC_ALERT_TEST_RECOV_ALERT_RESVAL = 1'h 0;
  parameter logic [0:0] ENTROPY_SRC_ALERT_TEST_FATAL_ALERT_RESVAL = 1'h 0;
  parameter logic [31:0] ENTROPY_SRC_ENTROPY_DATA_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_REPCNT_THRESHOLDS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_REPCNT_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_REPCNT_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_REPCNTS_THRESHOLDS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_REPCNTS_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_REPCNTS_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_ADAPTP_HI_THRESHOLDS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_ADAPTP_HI_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_ADAPTP_HI_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_ADAPTP_LO_THRESHOLDS_RESVAL = 32'h 0;
  parameter logic [15:0] ENTROPY_SRC_ADAPTP_LO_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h 0;
  parameter logic [15:0] ENTROPY_SRC_ADAPTP_LO_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h 0;
  parameter logic [31:0] ENTROPY_SRC_BUCKET_THRESHOLDS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_BUCKET_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_BUCKET_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_MARKOV_HI_THRESHOLDS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_MARKOV_HI_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_MARKOV_HI_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_MARKOV_LO_THRESHOLDS_RESVAL = 32'h 0;
  parameter logic [15:0] ENTROPY_SRC_MARKOV_LO_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h 0;
  parameter logic [15:0] ENTROPY_SRC_MARKOV_LO_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h 0;
  parameter logic [31:0] ENTROPY_SRC_EXTHT_HI_THRESHOLDS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_EXTHT_HI_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_EXTHT_HI_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_EXTHT_LO_THRESHOLDS_RESVAL = 32'h 0;
  parameter logic [15:0] ENTROPY_SRC_EXTHT_LO_THRESHOLDS_FIPS_THRESH_RESVAL = 16'h 0;
  parameter logic [15:0] ENTROPY_SRC_EXTHT_LO_THRESHOLDS_BYPASS_THRESH_RESVAL = 16'h 0;
  parameter logic [31:0] ENTROPY_SRC_REPCNT_HI_WATERMARKS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_REPCNTS_HI_WATERMARKS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_ADAPTP_HI_WATERMARKS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_ADAPTP_LO_WATERMARKS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_ADAPTP_LO_WATERMARKS_FIPS_WATERMARK_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_ADAPTP_LO_WATERMARKS_BYPASS_WATERMARK_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_EXTHT_HI_WATERMARKS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_EXTHT_LO_WATERMARKS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_EXTHT_LO_WATERMARKS_FIPS_WATERMARK_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_EXTHT_LO_WATERMARKS_BYPASS_WATERMARK_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_BUCKET_HI_WATERMARKS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_MARKOV_HI_WATERMARKS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_MARKOV_LO_WATERMARKS_RESVAL = 32'h ffffffff;
  parameter logic [15:0] ENTROPY_SRC_MARKOV_LO_WATERMARKS_FIPS_WATERMARK_RESVAL = 16'h ffff;
  parameter logic [15:0] ENTROPY_SRC_MARKOV_LO_WATERMARKS_BYPASS_WATERMARK_RESVAL = 16'h ffff;
  parameter logic [31:0] ENTROPY_SRC_REPCNT_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_REPCNTS_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_ADAPTP_HI_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_ADAPTP_LO_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_BUCKET_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_MARKOV_HI_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_MARKOV_LO_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_EXTHT_HI_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_EXTHT_LO_TOTAL_FAILS_RESVAL = 32'h 0;
  parameter logic [15:0] ENTROPY_SRC_ALERT_SUMMARY_FAIL_COUNTS_RESVAL = 16'h 0;
  parameter logic [31:0] ENTROPY_SRC_ALERT_FAIL_COUNTS_RESVAL = 32'h 0;
  parameter logic [7:0] ENTROPY_SRC_EXTHT_FAIL_COUNTS_RESVAL = 8'h 0;
  parameter logic [0:0] ENTROPY_SRC_FW_OV_WR_FIFO_FULL_RESVAL = 1'h 0;
  parameter logic [31:0] ENTROPY_SRC_FW_OV_RD_DATA_RESVAL = 32'h 0;
  parameter logic [31:0] ENTROPY_SRC_FW_OV_WR_DATA_RESVAL = 32'h 0;
  parameter logic [6:0] ENTROPY_SRC_OBSERVE_FIFO_DEPTH_RESVAL = 7'h 0;
  parameter logic [17:0] ENTROPY_SRC_DEBUG_STATUS_RESVAL = 18'h 0;

  // Register index
  typedef enum int {
    ENTROPY_SRC_INTR_STATE,
    ENTROPY_SRC_INTR_ENABLE,
    ENTROPY_SRC_INTR_TEST,
    ENTROPY_SRC_ALERT_TEST,
    ENTROPY_SRC_ME_REGWEN,
    ENTROPY_SRC_SW_REGUPD,
    ENTROPY_SRC_REGWEN,
    ENTROPY_SRC_REV,
    ENTROPY_SRC_MODULE_ENABLE,
    ENTROPY_SRC_CONF,
    ENTROPY_SRC_ENTROPY_CONTROL,
    ENTROPY_SRC_ENTROPY_DATA,
    ENTROPY_SRC_HEALTH_TEST_WINDOWS,
    ENTROPY_SRC_REPCNT_THRESHOLDS,
    ENTROPY_SRC_REPCNTS_THRESHOLDS,
    ENTROPY_SRC_ADAPTP_HI_THRESHOLDS,
    ENTROPY_SRC_ADAPTP_LO_THRESHOLDS,
    ENTROPY_SRC_BUCKET_THRESHOLDS,
    ENTROPY_SRC_MARKOV_HI_THRESHOLDS,
    ENTROPY_SRC_MARKOV_LO_THRESHOLDS,
    ENTROPY_SRC_EXTHT_HI_THRESHOLDS,
    ENTROPY_SRC_EXTHT_LO_THRESHOLDS,
    ENTROPY_SRC_REPCNT_HI_WATERMARKS,
    ENTROPY_SRC_REPCNTS_HI_WATERMARKS,
    ENTROPY_SRC_ADAPTP_HI_WATERMARKS,
    ENTROPY_SRC_ADAPTP_LO_WATERMARKS,
    ENTROPY_SRC_EXTHT_HI_WATERMARKS,
    ENTROPY_SRC_EXTHT_LO_WATERMARKS,
    ENTROPY_SRC_BUCKET_HI_WATERMARKS,
    ENTROPY_SRC_MARKOV_HI_WATERMARKS,
    ENTROPY_SRC_MARKOV_LO_WATERMARKS,
    ENTROPY_SRC_REPCNT_TOTAL_FAILS,
    ENTROPY_SRC_REPCNTS_TOTAL_FAILS,
    ENTROPY_SRC_ADAPTP_HI_TOTAL_FAILS,
    ENTROPY_SRC_ADAPTP_LO_TOTAL_FAILS,
    ENTROPY_SRC_BUCKET_TOTAL_FAILS,
    ENTROPY_SRC_MARKOV_HI_TOTAL_FAILS,
    ENTROPY_SRC_MARKOV_LO_TOTAL_FAILS,
    ENTROPY_SRC_EXTHT_HI_TOTAL_FAILS,
    ENTROPY_SRC_EXTHT_LO_TOTAL_FAILS,
    ENTROPY_SRC_ALERT_THRESHOLD,
    ENTROPY_SRC_ALERT_SUMMARY_FAIL_COUNTS,
    ENTROPY_SRC_ALERT_FAIL_COUNTS,
    ENTROPY_SRC_EXTHT_FAIL_COUNTS,
    ENTROPY_SRC_FW_OV_CONTROL,
    ENTROPY_SRC_FW_OV_SHA3_START,
    ENTROPY_SRC_FW_OV_WR_FIFO_FULL,
    ENTROPY_SRC_FW_OV_RD_FIFO_OVERFLOW,
    ENTROPY_SRC_FW_OV_RD_DATA,
    ENTROPY_SRC_FW_OV_WR_DATA,
    ENTROPY_SRC_OBSERVE_FIFO_THRESH,
    ENTROPY_SRC_OBSERVE_FIFO_DEPTH,
    ENTROPY_SRC_DEBUG_STATUS,
    ENTROPY_SRC_RECOV_ALERT_STS,
    ENTROPY_SRC_ERR_CODE,
    ENTROPY_SRC_ERR_CODE_TEST,
    ENTROPY_SRC_MAIN_SM_STATE
  } entropy_src_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] ENTROPY_SRC_PERMIT [57] = '{
    4'b 0001, // index[ 0] ENTROPY_SRC_INTR_STATE
    4'b 0001, // index[ 1] ENTROPY_SRC_INTR_ENABLE
    4'b 0001, // index[ 2] ENTROPY_SRC_INTR_TEST
    4'b 0001, // index[ 3] ENTROPY_SRC_ALERT_TEST
    4'b 0001, // index[ 4] ENTROPY_SRC_ME_REGWEN
    4'b 0001, // index[ 5] ENTROPY_SRC_SW_REGUPD
    4'b 0001, // index[ 6] ENTROPY_SRC_REGWEN
    4'b 0111, // index[ 7] ENTROPY_SRC_REV
    4'b 0001, // index[ 8] ENTROPY_SRC_MODULE_ENABLE
    4'b 1111, // index[ 9] ENTROPY_SRC_CONF
    4'b 0001, // index[10] ENTROPY_SRC_ENTROPY_CONTROL
    4'b 1111, // index[11] ENTROPY_SRC_ENTROPY_DATA
    4'b 1111, // index[12] ENTROPY_SRC_HEALTH_TEST_WINDOWS
    4'b 1111, // index[13] ENTROPY_SRC_REPCNT_THRESHOLDS
    4'b 1111, // index[14] ENTROPY_SRC_REPCNTS_THRESHOLDS
    4'b 1111, // index[15] ENTROPY_SRC_ADAPTP_HI_THRESHOLDS
    4'b 1111, // index[16] ENTROPY_SRC_ADAPTP_LO_THRESHOLDS
    4'b 1111, // index[17] ENTROPY_SRC_BUCKET_THRESHOLDS
    4'b 1111, // index[18] ENTROPY_SRC_MARKOV_HI_THRESHOLDS
    4'b 1111, // index[19] ENTROPY_SRC_MARKOV_LO_THRESHOLDS
    4'b 1111, // index[20] ENTROPY_SRC_EXTHT_HI_THRESHOLDS
    4'b 1111, // index[21] ENTROPY_SRC_EXTHT_LO_THRESHOLDS
    4'b 1111, // index[22] ENTROPY_SRC_REPCNT_HI_WATERMARKS
    4'b 1111, // index[23] ENTROPY_SRC_REPCNTS_HI_WATERMARKS
    4'b 1111, // index[24] ENTROPY_SRC_ADAPTP_HI_WATERMARKS
    4'b 1111, // index[25] ENTROPY_SRC_ADAPTP_LO_WATERMARKS
    4'b 1111, // index[26] ENTROPY_SRC_EXTHT_HI_WATERMARKS
    4'b 1111, // index[27] ENTROPY_SRC_EXTHT_LO_WATERMARKS
    4'b 1111, // index[28] ENTROPY_SRC_BUCKET_HI_WATERMARKS
    4'b 1111, // index[29] ENTROPY_SRC_MARKOV_HI_WATERMARKS
    4'b 1111, // index[30] ENTROPY_SRC_MARKOV_LO_WATERMARKS
    4'b 1111, // index[31] ENTROPY_SRC_REPCNT_TOTAL_FAILS
    4'b 1111, // index[32] ENTROPY_SRC_REPCNTS_TOTAL_FAILS
    4'b 1111, // index[33] ENTROPY_SRC_ADAPTP_HI_TOTAL_FAILS
    4'b 1111, // index[34] ENTROPY_SRC_ADAPTP_LO_TOTAL_FAILS
    4'b 1111, // index[35] ENTROPY_SRC_BUCKET_TOTAL_FAILS
    4'b 1111, // index[36] ENTROPY_SRC_MARKOV_HI_TOTAL_FAILS
    4'b 1111, // index[37] ENTROPY_SRC_MARKOV_LO_TOTAL_FAILS
    4'b 1111, // index[38] ENTROPY_SRC_EXTHT_HI_TOTAL_FAILS
    4'b 1111, // index[39] ENTROPY_SRC_EXTHT_LO_TOTAL_FAILS
    4'b 1111, // index[40] ENTROPY_SRC_ALERT_THRESHOLD
    4'b 0011, // index[41] ENTROPY_SRC_ALERT_SUMMARY_FAIL_COUNTS
    4'b 1111, // index[42] ENTROPY_SRC_ALERT_FAIL_COUNTS
    4'b 0001, // index[43] ENTROPY_SRC_EXTHT_FAIL_COUNTS
    4'b 0001, // index[44] ENTROPY_SRC_FW_OV_CONTROL
    4'b 0001, // index[45] ENTROPY_SRC_FW_OV_SHA3_START
    4'b 0001, // index[46] ENTROPY_SRC_FW_OV_WR_FIFO_FULL
    4'b 0001, // index[47] ENTROPY_SRC_FW_OV_RD_FIFO_OVERFLOW
    4'b 1111, // index[48] ENTROPY_SRC_FW_OV_RD_DATA
    4'b 1111, // index[49] ENTROPY_SRC_FW_OV_WR_DATA
    4'b 0001, // index[50] ENTROPY_SRC_OBSERVE_FIFO_THRESH
    4'b 0001, // index[51] ENTROPY_SRC_OBSERVE_FIFO_DEPTH
    4'b 0111, // index[52] ENTROPY_SRC_DEBUG_STATUS
    4'b 0011, // index[53] ENTROPY_SRC_RECOV_ALERT_STS
    4'b 1111, // index[54] ENTROPY_SRC_ERR_CODE
    4'b 0001, // index[55] ENTROPY_SRC_ERR_CODE_TEST
    4'b 0011  // index[56] ENTROPY_SRC_MAIN_SM_STATE
  };

endpackage

