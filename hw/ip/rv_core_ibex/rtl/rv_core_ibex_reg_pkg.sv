// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rv_core_ibex_reg_pkg;

  // Param list
  parameter int NumSwAlerts = 2;
  parameter int NumRegions = 2;
  parameter int NumAlerts = 4;

  // Address widths within the block
  parameter int CfgAw = 7;

  //////////////////////////////////////////////
  // Typedefs for registers for cfg interface //
  //////////////////////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } fatal_sw_err;
    struct packed {
      logic        q;
      logic        qe;
    } recov_sw_err;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_hw_err;
    struct packed {
      logic        q;
      logic        qe;
    } recov_hw_err;
  } rv_core_ibex_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_core_ibex_reg2hw_sw_alert_mreg_t;

  typedef struct packed {
    logic        q;
  } rv_core_ibex_reg2hw_ibus_addr_en_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } rv_core_ibex_reg2hw_ibus_addr_matching_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } rv_core_ibex_reg2hw_ibus_remap_addr_mreg_t;

  typedef struct packed {
    logic        q;
  } rv_core_ibex_reg2hw_dbus_addr_en_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } rv_core_ibex_reg2hw_dbus_addr_matching_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } rv_core_ibex_reg2hw_dbus_remap_addr_mreg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } reg_intg_err;
    struct packed {
      logic        d;
      logic        de;
    } fatal_intg_err;
    struct packed {
      logic        d;
      logic        de;
    } fatal_core_err;
    struct packed {
      logic        d;
      logic        de;
    } recov_core_err;
  } rv_core_ibex_hw2reg_err_status_reg_t;

  // Register -> HW type for cfg interface
  typedef struct packed {
    rv_core_ibex_reg2hw_alert_test_reg_t alert_test; // [271:264]
    rv_core_ibex_reg2hw_sw_alert_mreg_t [1:0] sw_alert; // [263:260]
    rv_core_ibex_reg2hw_ibus_addr_en_mreg_t [1:0] ibus_addr_en; // [259:258]
    rv_core_ibex_reg2hw_ibus_addr_matching_mreg_t [1:0] ibus_addr_matching; // [257:194]
    rv_core_ibex_reg2hw_ibus_remap_addr_mreg_t [1:0] ibus_remap_addr; // [193:130]
    rv_core_ibex_reg2hw_dbus_addr_en_mreg_t [1:0] dbus_addr_en; // [129:128]
    rv_core_ibex_reg2hw_dbus_addr_matching_mreg_t [1:0] dbus_addr_matching; // [127:64]
    rv_core_ibex_reg2hw_dbus_remap_addr_mreg_t [1:0] dbus_remap_addr; // [63:0]
  } rv_core_ibex_cfg_reg2hw_t;

  // HW -> register type for cfg interface
  typedef struct packed {
    rv_core_ibex_hw2reg_err_status_reg_t err_status; // [7:0]
  } rv_core_ibex_cfg_hw2reg_t;

  // Register offsets for cfg interface
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_ALERT_TEST_OFFSET = 7'h 0;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_SW_ALERT_REGWEN_0_OFFSET = 7'h 4;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_SW_ALERT_REGWEN_1_OFFSET = 7'h 8;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_SW_ALERT_0_OFFSET = 7'h c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_SW_ALERT_1_OFFSET = 7'h 10;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_REGWEN_0_OFFSET = 7'h 14;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_REGWEN_1_OFFSET = 7'h 18;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_ADDR_EN_0_OFFSET = 7'h 1c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_ADDR_EN_1_OFFSET = 7'h 20;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_ADDR_MATCHING_0_OFFSET = 7'h 24;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_ADDR_MATCHING_1_OFFSET = 7'h 28;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_REMAP_ADDR_0_OFFSET = 7'h 2c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_REMAP_ADDR_1_OFFSET = 7'h 30;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_REGWEN_0_OFFSET = 7'h 34;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_REGWEN_1_OFFSET = 7'h 38;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_ADDR_EN_0_OFFSET = 7'h 3c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_ADDR_EN_1_OFFSET = 7'h 40;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_ADDR_MATCHING_0_OFFSET = 7'h 44;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_ADDR_MATCHING_1_OFFSET = 7'h 48;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_REMAP_ADDR_0_OFFSET = 7'h 4c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_REMAP_ADDR_1_OFFSET = 7'h 50;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_ERR_STATUS_OFFSET = 7'h 54;

  // Reset values for hwext registers and their fields for cfg interface
  parameter logic [3:0] RV_CORE_IBEX_ALERT_TEST_RESVAL = 4'h 0;
  parameter logic [0:0] RV_CORE_IBEX_ALERT_TEST_FATAL_SW_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] RV_CORE_IBEX_ALERT_TEST_RECOV_SW_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] RV_CORE_IBEX_ALERT_TEST_FATAL_HW_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] RV_CORE_IBEX_ALERT_TEST_RECOV_HW_ERR_RESVAL = 1'h 0;

  // Register index for cfg interface
  typedef enum int {
    RV_CORE_IBEX_ALERT_TEST,
    RV_CORE_IBEX_SW_ALERT_REGWEN_0,
    RV_CORE_IBEX_SW_ALERT_REGWEN_1,
    RV_CORE_IBEX_SW_ALERT_0,
    RV_CORE_IBEX_SW_ALERT_1,
    RV_CORE_IBEX_IBUS_REGWEN_0,
    RV_CORE_IBEX_IBUS_REGWEN_1,
    RV_CORE_IBEX_IBUS_ADDR_EN_0,
    RV_CORE_IBEX_IBUS_ADDR_EN_1,
    RV_CORE_IBEX_IBUS_ADDR_MATCHING_0,
    RV_CORE_IBEX_IBUS_ADDR_MATCHING_1,
    RV_CORE_IBEX_IBUS_REMAP_ADDR_0,
    RV_CORE_IBEX_IBUS_REMAP_ADDR_1,
    RV_CORE_IBEX_DBUS_REGWEN_0,
    RV_CORE_IBEX_DBUS_REGWEN_1,
    RV_CORE_IBEX_DBUS_ADDR_EN_0,
    RV_CORE_IBEX_DBUS_ADDR_EN_1,
    RV_CORE_IBEX_DBUS_ADDR_MATCHING_0,
    RV_CORE_IBEX_DBUS_ADDR_MATCHING_1,
    RV_CORE_IBEX_DBUS_REMAP_ADDR_0,
    RV_CORE_IBEX_DBUS_REMAP_ADDR_1,
    RV_CORE_IBEX_ERR_STATUS
  } rv_core_ibex_cfg_id_e;

  // Register width information to check illegal writes for cfg interface
  parameter logic [3:0] RV_CORE_IBEX_CFG_PERMIT [22] = '{
    4'b 0001, // index[ 0] RV_CORE_IBEX_ALERT_TEST
    4'b 0001, // index[ 1] RV_CORE_IBEX_SW_ALERT_REGWEN_0
    4'b 0001, // index[ 2] RV_CORE_IBEX_SW_ALERT_REGWEN_1
    4'b 0001, // index[ 3] RV_CORE_IBEX_SW_ALERT_0
    4'b 0001, // index[ 4] RV_CORE_IBEX_SW_ALERT_1
    4'b 0001, // index[ 5] RV_CORE_IBEX_IBUS_REGWEN_0
    4'b 0001, // index[ 6] RV_CORE_IBEX_IBUS_REGWEN_1
    4'b 0001, // index[ 7] RV_CORE_IBEX_IBUS_ADDR_EN_0
    4'b 0001, // index[ 8] RV_CORE_IBEX_IBUS_ADDR_EN_1
    4'b 1111, // index[ 9] RV_CORE_IBEX_IBUS_ADDR_MATCHING_0
    4'b 1111, // index[10] RV_CORE_IBEX_IBUS_ADDR_MATCHING_1
    4'b 1111, // index[11] RV_CORE_IBEX_IBUS_REMAP_ADDR_0
    4'b 1111, // index[12] RV_CORE_IBEX_IBUS_REMAP_ADDR_1
    4'b 0001, // index[13] RV_CORE_IBEX_DBUS_REGWEN_0
    4'b 0001, // index[14] RV_CORE_IBEX_DBUS_REGWEN_1
    4'b 0001, // index[15] RV_CORE_IBEX_DBUS_ADDR_EN_0
    4'b 0001, // index[16] RV_CORE_IBEX_DBUS_ADDR_EN_1
    4'b 1111, // index[17] RV_CORE_IBEX_DBUS_ADDR_MATCHING_0
    4'b 1111, // index[18] RV_CORE_IBEX_DBUS_ADDR_MATCHING_1
    4'b 1111, // index[19] RV_CORE_IBEX_DBUS_REMAP_ADDR_0
    4'b 1111, // index[20] RV_CORE_IBEX_DBUS_REMAP_ADDR_1
    4'b 0011  // index[21] RV_CORE_IBEX_ERR_STATUS
  };

endpackage

