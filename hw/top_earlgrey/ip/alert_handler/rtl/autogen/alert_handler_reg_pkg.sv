// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package alert_handler_reg_pkg;

  // Param list
  parameter int NAlerts = 29;
  parameter int EscCntDw = 32;
  parameter int AccuCntDw = 16;
  parameter logic [NAlerts-1:0] AsyncOn = 29'b11111111111111110000000000000;
  parameter int N_CLASSES = 4;
  parameter int N_ESC_SEV = 4;
  parameter int N_PHASES = 4;
  parameter int N_LOC_ALERT = 4;
  parameter int PING_CNT_DW = 24;
  parameter int PHASE_DW = 2;
  parameter int CLASS_DW = 2;

  // Address widths within the block
  parameter int BlockAw = 10;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } classa;
    struct packed {
      logic        q;
    } classb;
    struct packed {
      logic        q;
    } classc;
    struct packed {
      logic        q;
    } classd;
  } alert_handler_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } classa;
    struct packed {
      logic        q;
    } classb;
    struct packed {
      logic        q;
    } classc;
    struct packed {
      logic        q;
    } classd;
  } alert_handler_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } classa;
    struct packed {
      logic        q;
      logic        qe;
    } classb;
    struct packed {
      logic        q;
      logic        qe;
    } classc;
    struct packed {
      logic        q;
      logic        qe;
    } classd;
  } alert_handler_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_regwen_reg_t;

  typedef struct packed {
    logic [23:0] q;
  } alert_handler_reg2hw_ping_timeout_cyc_reg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_alert_en_mreg_t;

  typedef struct packed {
    logic [1:0]  q;
  } alert_handler_reg2hw_alert_class_mreg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_alert_cause_mreg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_loc_alert_en_mreg_t;

  typedef struct packed {
    logic [1:0]  q;
  } alert_handler_reg2hw_loc_alert_class_mreg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_loc_alert_cause_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } lock;
    struct packed {
      logic        q;
    } en_e0;
    struct packed {
      logic        q;
    } en_e1;
    struct packed {
      logic        q;
    } en_e2;
    struct packed {
      logic        q;
    } en_e3;
    struct packed {
      logic [1:0]  q;
    } map_e0;
    struct packed {
      logic [1:0]  q;
    } map_e1;
    struct packed {
      logic [1:0]  q;
    } map_e2;
    struct packed {
      logic [1:0]  q;
    } map_e3;
  } alert_handler_reg2hw_classa_ctrl_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } alert_handler_reg2hw_classa_clr_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_classa_accum_thresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_timeout_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_phase0_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_phase1_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_phase2_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_phase3_cyc_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } lock;
    struct packed {
      logic        q;
    } en_e0;
    struct packed {
      logic        q;
    } en_e1;
    struct packed {
      logic        q;
    } en_e2;
    struct packed {
      logic        q;
    } en_e3;
    struct packed {
      logic [1:0]  q;
    } map_e0;
    struct packed {
      logic [1:0]  q;
    } map_e1;
    struct packed {
      logic [1:0]  q;
    } map_e2;
    struct packed {
      logic [1:0]  q;
    } map_e3;
  } alert_handler_reg2hw_classb_ctrl_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } alert_handler_reg2hw_classb_clr_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_classb_accum_thresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_timeout_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_phase0_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_phase1_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_phase2_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_phase3_cyc_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } lock;
    struct packed {
      logic        q;
    } en_e0;
    struct packed {
      logic        q;
    } en_e1;
    struct packed {
      logic        q;
    } en_e2;
    struct packed {
      logic        q;
    } en_e3;
    struct packed {
      logic [1:0]  q;
    } map_e0;
    struct packed {
      logic [1:0]  q;
    } map_e1;
    struct packed {
      logic [1:0]  q;
    } map_e2;
    struct packed {
      logic [1:0]  q;
    } map_e3;
  } alert_handler_reg2hw_classc_ctrl_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } alert_handler_reg2hw_classc_clr_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_classc_accum_thresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_timeout_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_phase0_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_phase1_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_phase2_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_phase3_cyc_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } lock;
    struct packed {
      logic        q;
    } en_e0;
    struct packed {
      logic        q;
    } en_e1;
    struct packed {
      logic        q;
    } en_e2;
    struct packed {
      logic        q;
    } en_e3;
    struct packed {
      logic [1:0]  q;
    } map_e0;
    struct packed {
      logic [1:0]  q;
    } map_e1;
    struct packed {
      logic [1:0]  q;
    } map_e2;
    struct packed {
      logic [1:0]  q;
    } map_e3;
  } alert_handler_reg2hw_classd_ctrl_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } alert_handler_reg2hw_classd_clr_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_classd_accum_thresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_timeout_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_phase0_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_phase1_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_phase2_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_phase3_cyc_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } classa;
    struct packed {
      logic        d;
      logic        de;
    } classb;
    struct packed {
      logic        d;
      logic        de;
    } classc;
    struct packed {
      logic        d;
      logic        de;
    } classd;
  } alert_handler_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_alert_cause_mreg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_loc_alert_cause_mreg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_classa_regwen_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } alert_handler_hw2reg_classa_accum_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } alert_handler_hw2reg_classa_esc_cnt_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } alert_handler_hw2reg_classa_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_classb_regwen_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } alert_handler_hw2reg_classb_accum_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } alert_handler_hw2reg_classb_esc_cnt_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } alert_handler_hw2reg_classb_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_classc_regwen_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } alert_handler_hw2reg_classc_accum_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } alert_handler_hw2reg_classc_esc_cnt_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } alert_handler_hw2reg_classc_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_classd_regwen_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } alert_handler_hw2reg_classd_accum_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } alert_handler_hw2reg_classd_esc_cnt_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } alert_handler_hw2reg_classd_state_reg_t;

  // Register -> HW type
  typedef struct packed {
    alert_handler_reg2hw_intr_state_reg_t intr_state; // [940:937]
    alert_handler_reg2hw_intr_enable_reg_t intr_enable; // [936:933]
    alert_handler_reg2hw_intr_test_reg_t intr_test; // [932:925]
    alert_handler_reg2hw_regwen_reg_t regwen; // [924:924]
    alert_handler_reg2hw_ping_timeout_cyc_reg_t ping_timeout_cyc; // [923:900]
    alert_handler_reg2hw_alert_en_mreg_t [28:0] alert_en; // [899:871]
    alert_handler_reg2hw_alert_class_mreg_t [28:0] alert_class; // [870:813]
    alert_handler_reg2hw_alert_cause_mreg_t [28:0] alert_cause; // [812:784]
    alert_handler_reg2hw_loc_alert_en_mreg_t [3:0] loc_alert_en; // [783:780]
    alert_handler_reg2hw_loc_alert_class_mreg_t [3:0] loc_alert_class; // [779:772]
    alert_handler_reg2hw_loc_alert_cause_mreg_t [3:0] loc_alert_cause; // [771:768]
    alert_handler_reg2hw_classa_ctrl_reg_t classa_ctrl; // [767:754]
    alert_handler_reg2hw_classa_clr_reg_t classa_clr; // [753:752]
    alert_handler_reg2hw_classa_accum_thresh_reg_t classa_accum_thresh; // [751:736]
    alert_handler_reg2hw_classa_timeout_cyc_reg_t classa_timeout_cyc; // [735:704]
    alert_handler_reg2hw_classa_phase0_cyc_reg_t classa_phase0_cyc; // [703:672]
    alert_handler_reg2hw_classa_phase1_cyc_reg_t classa_phase1_cyc; // [671:640]
    alert_handler_reg2hw_classa_phase2_cyc_reg_t classa_phase2_cyc; // [639:608]
    alert_handler_reg2hw_classa_phase3_cyc_reg_t classa_phase3_cyc; // [607:576]
    alert_handler_reg2hw_classb_ctrl_reg_t classb_ctrl; // [575:562]
    alert_handler_reg2hw_classb_clr_reg_t classb_clr; // [561:560]
    alert_handler_reg2hw_classb_accum_thresh_reg_t classb_accum_thresh; // [559:544]
    alert_handler_reg2hw_classb_timeout_cyc_reg_t classb_timeout_cyc; // [543:512]
    alert_handler_reg2hw_classb_phase0_cyc_reg_t classb_phase0_cyc; // [511:480]
    alert_handler_reg2hw_classb_phase1_cyc_reg_t classb_phase1_cyc; // [479:448]
    alert_handler_reg2hw_classb_phase2_cyc_reg_t classb_phase2_cyc; // [447:416]
    alert_handler_reg2hw_classb_phase3_cyc_reg_t classb_phase3_cyc; // [415:384]
    alert_handler_reg2hw_classc_ctrl_reg_t classc_ctrl; // [383:370]
    alert_handler_reg2hw_classc_clr_reg_t classc_clr; // [369:368]
    alert_handler_reg2hw_classc_accum_thresh_reg_t classc_accum_thresh; // [367:352]
    alert_handler_reg2hw_classc_timeout_cyc_reg_t classc_timeout_cyc; // [351:320]
    alert_handler_reg2hw_classc_phase0_cyc_reg_t classc_phase0_cyc; // [319:288]
    alert_handler_reg2hw_classc_phase1_cyc_reg_t classc_phase1_cyc; // [287:256]
    alert_handler_reg2hw_classc_phase2_cyc_reg_t classc_phase2_cyc; // [255:224]
    alert_handler_reg2hw_classc_phase3_cyc_reg_t classc_phase3_cyc; // [223:192]
    alert_handler_reg2hw_classd_ctrl_reg_t classd_ctrl; // [191:178]
    alert_handler_reg2hw_classd_clr_reg_t classd_clr; // [177:176]
    alert_handler_reg2hw_classd_accum_thresh_reg_t classd_accum_thresh; // [175:160]
    alert_handler_reg2hw_classd_timeout_cyc_reg_t classd_timeout_cyc; // [159:128]
    alert_handler_reg2hw_classd_phase0_cyc_reg_t classd_phase0_cyc; // [127:96]
    alert_handler_reg2hw_classd_phase1_cyc_reg_t classd_phase1_cyc; // [95:64]
    alert_handler_reg2hw_classd_phase2_cyc_reg_t classd_phase2_cyc; // [63:32]
    alert_handler_reg2hw_classd_phase3_cyc_reg_t classd_phase3_cyc; // [31:0]
  } alert_handler_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    alert_handler_hw2reg_intr_state_reg_t intr_state; // [285:278]
    alert_handler_hw2reg_alert_cause_mreg_t [28:0] alert_cause; // [277:220]
    alert_handler_hw2reg_loc_alert_cause_mreg_t [3:0] loc_alert_cause; // [219:212]
    alert_handler_hw2reg_classa_regwen_reg_t classa_regwen; // [211:210]
    alert_handler_hw2reg_classa_accum_cnt_reg_t classa_accum_cnt; // [209:194]
    alert_handler_hw2reg_classa_esc_cnt_reg_t classa_esc_cnt; // [193:162]
    alert_handler_hw2reg_classa_state_reg_t classa_state; // [161:159]
    alert_handler_hw2reg_classb_regwen_reg_t classb_regwen; // [158:157]
    alert_handler_hw2reg_classb_accum_cnt_reg_t classb_accum_cnt; // [156:141]
    alert_handler_hw2reg_classb_esc_cnt_reg_t classb_esc_cnt; // [140:109]
    alert_handler_hw2reg_classb_state_reg_t classb_state; // [108:106]
    alert_handler_hw2reg_classc_regwen_reg_t classc_regwen; // [105:104]
    alert_handler_hw2reg_classc_accum_cnt_reg_t classc_accum_cnt; // [103:88]
    alert_handler_hw2reg_classc_esc_cnt_reg_t classc_esc_cnt; // [87:56]
    alert_handler_hw2reg_classc_state_reg_t classc_state; // [55:53]
    alert_handler_hw2reg_classd_regwen_reg_t classd_regwen; // [52:51]
    alert_handler_hw2reg_classd_accum_cnt_reg_t classd_accum_cnt; // [50:35]
    alert_handler_hw2reg_classd_esc_cnt_reg_t classd_esc_cnt; // [34:3]
    alert_handler_hw2reg_classd_state_reg_t classd_state; // [2:0]
  } alert_handler_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] ALERT_HANDLER_INTR_STATE_OFFSET = 10'h 0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_INTR_ENABLE_OFFSET = 10'h 4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_INTR_TEST_OFFSET = 10'h 8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_REGWEN_OFFSET = 10'h c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_PING_TIMEOUT_CYC_OFFSET = 10'h 10;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_EN_OFFSET = 10'h 20;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CLASS_0_OFFSET = 10'h 120;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CLASS_1_OFFSET = 10'h 124;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CAUSE_OFFSET = 10'h 220;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_EN_OFFSET = 10'h 320;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CLASS_OFFSET = 10'h 324;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CAUSE_OFFSET = 10'h 328;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_CTRL_OFFSET = 10'h 32c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_REGWEN_OFFSET = 10'h 330;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_CLR_OFFSET = 10'h 334;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_ACCUM_CNT_OFFSET = 10'h 338;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_ACCUM_THRESH_OFFSET = 10'h 33c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_TIMEOUT_CYC_OFFSET = 10'h 340;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_PHASE0_CYC_OFFSET = 10'h 344;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_PHASE1_CYC_OFFSET = 10'h 348;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_PHASE2_CYC_OFFSET = 10'h 34c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_PHASE3_CYC_OFFSET = 10'h 350;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_ESC_CNT_OFFSET = 10'h 354;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_STATE_OFFSET = 10'h 358;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_CTRL_OFFSET = 10'h 35c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_REGWEN_OFFSET = 10'h 360;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_CLR_OFFSET = 10'h 364;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_ACCUM_CNT_OFFSET = 10'h 368;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_ACCUM_THRESH_OFFSET = 10'h 36c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_TIMEOUT_CYC_OFFSET = 10'h 370;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_PHASE0_CYC_OFFSET = 10'h 374;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_PHASE1_CYC_OFFSET = 10'h 378;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_PHASE2_CYC_OFFSET = 10'h 37c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_PHASE3_CYC_OFFSET = 10'h 380;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_ESC_CNT_OFFSET = 10'h 384;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_STATE_OFFSET = 10'h 388;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_CTRL_OFFSET = 10'h 38c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_REGWEN_OFFSET = 10'h 390;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_CLR_OFFSET = 10'h 394;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_ACCUM_CNT_OFFSET = 10'h 398;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_ACCUM_THRESH_OFFSET = 10'h 39c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_TIMEOUT_CYC_OFFSET = 10'h 3a0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_PHASE0_CYC_OFFSET = 10'h 3a4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_PHASE1_CYC_OFFSET = 10'h 3a8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_PHASE2_CYC_OFFSET = 10'h 3ac;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_PHASE3_CYC_OFFSET = 10'h 3b0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_ESC_CNT_OFFSET = 10'h 3b4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_STATE_OFFSET = 10'h 3b8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_CTRL_OFFSET = 10'h 3bc;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_REGWEN_OFFSET = 10'h 3c0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_CLR_OFFSET = 10'h 3c4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_ACCUM_CNT_OFFSET = 10'h 3c8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_ACCUM_THRESH_OFFSET = 10'h 3cc;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_TIMEOUT_CYC_OFFSET = 10'h 3d0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_PHASE0_CYC_OFFSET = 10'h 3d4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_PHASE1_CYC_OFFSET = 10'h 3d8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_PHASE2_CYC_OFFSET = 10'h 3dc;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_PHASE3_CYC_OFFSET = 10'h 3e0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_ESC_CNT_OFFSET = 10'h 3e4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_STATE_OFFSET = 10'h 3e8;

  // Reset values for hwext registers and their fields
  parameter logic [3:0] ALERT_HANDLER_INTR_TEST_RESVAL = 4'h 0;
  parameter logic [0:0] ALERT_HANDLER_INTR_TEST_CLASSA_RESVAL = 1'h 0;
  parameter logic [0:0] ALERT_HANDLER_INTR_TEST_CLASSB_RESVAL = 1'h 0;
  parameter logic [0:0] ALERT_HANDLER_INTR_TEST_CLASSC_RESVAL = 1'h 0;
  parameter logic [0:0] ALERT_HANDLER_INTR_TEST_CLASSD_RESVAL = 1'h 0;
  parameter logic [15:0] ALERT_HANDLER_CLASSA_ACCUM_CNT_RESVAL = 16'h 0;
  parameter logic [31:0] ALERT_HANDLER_CLASSA_ESC_CNT_RESVAL = 32'h 0;
  parameter logic [2:0] ALERT_HANDLER_CLASSA_STATE_RESVAL = 3'h 0;
  parameter logic [15:0] ALERT_HANDLER_CLASSB_ACCUM_CNT_RESVAL = 16'h 0;
  parameter logic [31:0] ALERT_HANDLER_CLASSB_ESC_CNT_RESVAL = 32'h 0;
  parameter logic [2:0] ALERT_HANDLER_CLASSB_STATE_RESVAL = 3'h 0;
  parameter logic [15:0] ALERT_HANDLER_CLASSC_ACCUM_CNT_RESVAL = 16'h 0;
  parameter logic [31:0] ALERT_HANDLER_CLASSC_ESC_CNT_RESVAL = 32'h 0;
  parameter logic [2:0] ALERT_HANDLER_CLASSC_STATE_RESVAL = 3'h 0;
  parameter logic [15:0] ALERT_HANDLER_CLASSD_ACCUM_CNT_RESVAL = 16'h 0;
  parameter logic [31:0] ALERT_HANDLER_CLASSD_ESC_CNT_RESVAL = 32'h 0;
  parameter logic [2:0] ALERT_HANDLER_CLASSD_STATE_RESVAL = 3'h 0;

  // Register index
  typedef enum int {
    ALERT_HANDLER_INTR_STATE,
    ALERT_HANDLER_INTR_ENABLE,
    ALERT_HANDLER_INTR_TEST,
    ALERT_HANDLER_REGWEN,
    ALERT_HANDLER_PING_TIMEOUT_CYC,
    ALERT_HANDLER_ALERT_EN,
    ALERT_HANDLER_ALERT_CLASS_0,
    ALERT_HANDLER_ALERT_CLASS_1,
    ALERT_HANDLER_ALERT_CAUSE,
    ALERT_HANDLER_LOC_ALERT_EN,
    ALERT_HANDLER_LOC_ALERT_CLASS,
    ALERT_HANDLER_LOC_ALERT_CAUSE,
    ALERT_HANDLER_CLASSA_CTRL,
    ALERT_HANDLER_CLASSA_REGWEN,
    ALERT_HANDLER_CLASSA_CLR,
    ALERT_HANDLER_CLASSA_ACCUM_CNT,
    ALERT_HANDLER_CLASSA_ACCUM_THRESH,
    ALERT_HANDLER_CLASSA_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSA_PHASE0_CYC,
    ALERT_HANDLER_CLASSA_PHASE1_CYC,
    ALERT_HANDLER_CLASSA_PHASE2_CYC,
    ALERT_HANDLER_CLASSA_PHASE3_CYC,
    ALERT_HANDLER_CLASSA_ESC_CNT,
    ALERT_HANDLER_CLASSA_STATE,
    ALERT_HANDLER_CLASSB_CTRL,
    ALERT_HANDLER_CLASSB_REGWEN,
    ALERT_HANDLER_CLASSB_CLR,
    ALERT_HANDLER_CLASSB_ACCUM_CNT,
    ALERT_HANDLER_CLASSB_ACCUM_THRESH,
    ALERT_HANDLER_CLASSB_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSB_PHASE0_CYC,
    ALERT_HANDLER_CLASSB_PHASE1_CYC,
    ALERT_HANDLER_CLASSB_PHASE2_CYC,
    ALERT_HANDLER_CLASSB_PHASE3_CYC,
    ALERT_HANDLER_CLASSB_ESC_CNT,
    ALERT_HANDLER_CLASSB_STATE,
    ALERT_HANDLER_CLASSC_CTRL,
    ALERT_HANDLER_CLASSC_REGWEN,
    ALERT_HANDLER_CLASSC_CLR,
    ALERT_HANDLER_CLASSC_ACCUM_CNT,
    ALERT_HANDLER_CLASSC_ACCUM_THRESH,
    ALERT_HANDLER_CLASSC_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSC_PHASE0_CYC,
    ALERT_HANDLER_CLASSC_PHASE1_CYC,
    ALERT_HANDLER_CLASSC_PHASE2_CYC,
    ALERT_HANDLER_CLASSC_PHASE3_CYC,
    ALERT_HANDLER_CLASSC_ESC_CNT,
    ALERT_HANDLER_CLASSC_STATE,
    ALERT_HANDLER_CLASSD_CTRL,
    ALERT_HANDLER_CLASSD_REGWEN,
    ALERT_HANDLER_CLASSD_CLR,
    ALERT_HANDLER_CLASSD_ACCUM_CNT,
    ALERT_HANDLER_CLASSD_ACCUM_THRESH,
    ALERT_HANDLER_CLASSD_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSD_PHASE0_CYC,
    ALERT_HANDLER_CLASSD_PHASE1_CYC,
    ALERT_HANDLER_CLASSD_PHASE2_CYC,
    ALERT_HANDLER_CLASSD_PHASE3_CYC,
    ALERT_HANDLER_CLASSD_ESC_CNT,
    ALERT_HANDLER_CLASSD_STATE
  } alert_handler_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] ALERT_HANDLER_PERMIT [60] = '{
    4'b 0001, // index[ 0] ALERT_HANDLER_INTR_STATE
    4'b 0001, // index[ 1] ALERT_HANDLER_INTR_ENABLE
    4'b 0001, // index[ 2] ALERT_HANDLER_INTR_TEST
    4'b 0001, // index[ 3] ALERT_HANDLER_REGWEN
    4'b 0111, // index[ 4] ALERT_HANDLER_PING_TIMEOUT_CYC
    4'b 1111, // index[ 5] ALERT_HANDLER_ALERT_EN
    4'b 1111, // index[ 6] ALERT_HANDLER_ALERT_CLASS_0
    4'b 1111, // index[ 7] ALERT_HANDLER_ALERT_CLASS_1
    4'b 1111, // index[ 8] ALERT_HANDLER_ALERT_CAUSE
    4'b 0001, // index[ 9] ALERT_HANDLER_LOC_ALERT_EN
    4'b 0001, // index[10] ALERT_HANDLER_LOC_ALERT_CLASS
    4'b 0001, // index[11] ALERT_HANDLER_LOC_ALERT_CAUSE
    4'b 0011, // index[12] ALERT_HANDLER_CLASSA_CTRL
    4'b 0001, // index[13] ALERT_HANDLER_CLASSA_REGWEN
    4'b 0001, // index[14] ALERT_HANDLER_CLASSA_CLR
    4'b 0011, // index[15] ALERT_HANDLER_CLASSA_ACCUM_CNT
    4'b 0011, // index[16] ALERT_HANDLER_CLASSA_ACCUM_THRESH
    4'b 1111, // index[17] ALERT_HANDLER_CLASSA_TIMEOUT_CYC
    4'b 1111, // index[18] ALERT_HANDLER_CLASSA_PHASE0_CYC
    4'b 1111, // index[19] ALERT_HANDLER_CLASSA_PHASE1_CYC
    4'b 1111, // index[20] ALERT_HANDLER_CLASSA_PHASE2_CYC
    4'b 1111, // index[21] ALERT_HANDLER_CLASSA_PHASE3_CYC
    4'b 1111, // index[22] ALERT_HANDLER_CLASSA_ESC_CNT
    4'b 0001, // index[23] ALERT_HANDLER_CLASSA_STATE
    4'b 0011, // index[24] ALERT_HANDLER_CLASSB_CTRL
    4'b 0001, // index[25] ALERT_HANDLER_CLASSB_REGWEN
    4'b 0001, // index[26] ALERT_HANDLER_CLASSB_CLR
    4'b 0011, // index[27] ALERT_HANDLER_CLASSB_ACCUM_CNT
    4'b 0011, // index[28] ALERT_HANDLER_CLASSB_ACCUM_THRESH
    4'b 1111, // index[29] ALERT_HANDLER_CLASSB_TIMEOUT_CYC
    4'b 1111, // index[30] ALERT_HANDLER_CLASSB_PHASE0_CYC
    4'b 1111, // index[31] ALERT_HANDLER_CLASSB_PHASE1_CYC
    4'b 1111, // index[32] ALERT_HANDLER_CLASSB_PHASE2_CYC
    4'b 1111, // index[33] ALERT_HANDLER_CLASSB_PHASE3_CYC
    4'b 1111, // index[34] ALERT_HANDLER_CLASSB_ESC_CNT
    4'b 0001, // index[35] ALERT_HANDLER_CLASSB_STATE
    4'b 0011, // index[36] ALERT_HANDLER_CLASSC_CTRL
    4'b 0001, // index[37] ALERT_HANDLER_CLASSC_REGWEN
    4'b 0001, // index[38] ALERT_HANDLER_CLASSC_CLR
    4'b 0011, // index[39] ALERT_HANDLER_CLASSC_ACCUM_CNT
    4'b 0011, // index[40] ALERT_HANDLER_CLASSC_ACCUM_THRESH
    4'b 1111, // index[41] ALERT_HANDLER_CLASSC_TIMEOUT_CYC
    4'b 1111, // index[42] ALERT_HANDLER_CLASSC_PHASE0_CYC
    4'b 1111, // index[43] ALERT_HANDLER_CLASSC_PHASE1_CYC
    4'b 1111, // index[44] ALERT_HANDLER_CLASSC_PHASE2_CYC
    4'b 1111, // index[45] ALERT_HANDLER_CLASSC_PHASE3_CYC
    4'b 1111, // index[46] ALERT_HANDLER_CLASSC_ESC_CNT
    4'b 0001, // index[47] ALERT_HANDLER_CLASSC_STATE
    4'b 0011, // index[48] ALERT_HANDLER_CLASSD_CTRL
    4'b 0001, // index[49] ALERT_HANDLER_CLASSD_REGWEN
    4'b 0001, // index[50] ALERT_HANDLER_CLASSD_CLR
    4'b 0011, // index[51] ALERT_HANDLER_CLASSD_ACCUM_CNT
    4'b 0011, // index[52] ALERT_HANDLER_CLASSD_ACCUM_THRESH
    4'b 1111, // index[53] ALERT_HANDLER_CLASSD_TIMEOUT_CYC
    4'b 1111, // index[54] ALERT_HANDLER_CLASSD_PHASE0_CYC
    4'b 1111, // index[55] ALERT_HANDLER_CLASSD_PHASE1_CYC
    4'b 1111, // index[56] ALERT_HANDLER_CLASSD_PHASE2_CYC
    4'b 1111, // index[57] ALERT_HANDLER_CLASSD_PHASE3_CYC
    4'b 1111, // index[58] ALERT_HANDLER_CLASSD_ESC_CNT
    4'b 0001  // index[59] ALERT_HANDLER_CLASSD_STATE
  };

endpackage

