// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This has assertions that check the reset outputs of rstmgr cascade properly.
// This means higher level resets always cause the lower level ones to assert.
// The hierarchy is
//   por > lc > sys > specific peripherals
// In addition, a scan reset is at the same level as por.
//
// Local terminology: A cascading relationship is between an "above" and a "below" reset.
//
// Some individual reset outputs will always be off. Allowing for this in general would
// weaken the property that some resets MUST rise following other rise.
interface rstmgr_cascading_sva_if (
  input logic clk_i,
  input logic clk_aon_i,
  input logic clk_io_div2_i,
  input logic clk_io_div4_i,
  input logic clk_io_i,
  input logic clk_main_i,
  input logic clk_usb_i,
  input [rstmgr_pkg::PowerDomains-1:0] por_n_i,
  input rstmgr_pkg::rstmgr_out_t resets_o,
  input [rstmgr_pkg::PowerDomains-1:0] rst_lc_req,
  input [rstmgr_pkg::PowerDomains-1:0] rst_sys_req,
  input [rstmgr_pkg::PowerDomains-1:0] rst_lc_src_n,
  input [rstmgr_pkg::PowerDomains-1:0] rst_sys_src_n,
  input logic scan_rst_ni,
  input lc_ctrl_pkg::lc_tx_t scanmode_i
);

  // The min and max bounds on the number of cycles for an edge to occur.
  typedef struct {
    int min;
    int max;
  } bounds_t;

  // The bounds for a fall and rise edge to occur.
  typedef struct {
    bounds_t fall;
    bounds_t rise;
  } edge_bounds_t;

  // This is used to check por_n_i active high leads to a rising edge of rst_por_aon_n[0].
  // The number of cycles with por_n_i stable is 32 plus synchronizers and some filter stages.
  localparam edge_bounds_t PorCycles = '{fall: '{min: 0, max: 4}, rise: '{min: 35, max: 40}};

  // This is used to check for regular synchronizing delay. Reset falls asynchronously so the
  // fall min cycles is zero.
  localparam edge_bounds_t SyncCycles = '{fall: '{min: 0, max: 3}, rise: '{min: 1, max: 3}};

  // Cycles are counted from the output rst_por_aon_n or scan reset edges. The rise times can be
  // higher since in the chip the aon reset goes through the pwrmgr slow fsm where it causes an
  // lc rise request and there may be multiple synchronizers in the path.
  localparam edge_bounds_t LcCycles = '{fall: '{min: 0, max: 4}, rise: '{min: 1, max: 4}};

  // In the real system the rise of rst_lc_src_n is triggered by the pwr_i.rst_lc_req input,
  // which can take a few cycles since it comes from the pwrmgr after it gets reset,
  // is generated with the aon clock, and gets synchronized before it triggers
  // a rise in rst_lc_src_n. There is an SVA for the rise in pwrmgr_rstmgr_sva_if.

  // The cycles are counted from Lc edges.
  localparam edge_bounds_t SysCycles = '{fall: '{min: 0, max: 2}, rise: '{min: 1, max: 5}};

  // The different peripheral edges are synchronized to their respective clocks,
  // so these counts assume synchronization and are triggered on the correct clock.
  localparam edge_bounds_t PeriCycles = '{fall: '{min: 0, max: 4}, rise: '{min: 2, max: 8}};

  bit disable_sva;

  // Macros to avoid excessive boiler-plate code below.
  `define FALL_ASSERT(_name, _from, _to, _cycles, _clk) \
    `ASSERT(_name``AboveFallBelowHigh_A, \
            $fell(_from) && _to |-> ##[_cycles.fall.min:_cycles.fall.max] $fell(_to), _clk, \
            disable_sva)

  `define RISE_ASSERTS(_name, _from, _to, _cycles, _clk) \
    `ASSERT(_name``AboveRise_A, \
            $rose(_from) |-> ##[_cycles.rise.min:_cycles.rise.max] (!_from || $rose(_to)), _clk, \
            disable_sva) \
    `ASSERT(_name``BelowRise_A, $rose(_to) |-> _from == 1'b1, _clk, disable_sva)

  `define CASCADED_ASSERTS(_name, _from, _to, _cycles, _clk) \
      `FALL_ASSERT(_name, _from, _to, _cycles, _clk) \
      `RISE_ASSERTS(_name, _from, _to, _cycles, _clk)

  // A fall in por_n_i leads to a fall in rst_por_aon_n[0].
  `FALL_ASSERT(CascadePorToAon, por_n_i[rstmgr_pkg::DomainAonSel],
               resets_o.rst_por_aon_n[rstmgr_pkg::DomainAonSel], PorCycles, clk_aon_i)

  // A number of consecutive cycles with por_n_i inactive (high) should cause the aon resets to
  // become inactive. This checks POR stretching.

  // The antecedent: por_n_i rising and being active for enough cycles.
  sequence PorStable_S;
    $rose(
        por_n_i[rstmgr_pkg::DomainAonSel]
    ) ##1 (por_n_i[rstmgr_pkg::DomainAonSel] [* PorCycles.rise.max]);
  endsequence

  // The reset stretching assertion.
  `ASSERT(StablePorToAonRise_A, PorStable_S |-> resets_o.rst_por_aon_n[0], clk_aon_i, disable_sva)

  logic scan_reset_n;
  always_comb scan_reset_n = scan_rst_ni || (scanmode_i != lc_ctrl_pkg::On);

  logic [rstmgr_pkg::PowerDomains-1:0] effective_aon_rst;
  always_comb effective_aon_rst = resets_o.rst_por_aon_n & {rstmgr_pkg::PowerDomains{scan_reset_n}};

  // The internal reset is triggered by one of the generated reset outputs.
  logic [rstmgr_pkg::PowerDomains-1:0] local_rst_n;
  always_comb
    local_rst_n = {rstmgr_pkg::PowerDomains{resets_o.rst_por_io_div4_n[rstmgr_pkg::DomainAonSel]}};

  for (genvar pd = 0; pd < rstmgr_pkg::PowerDomains; ++pd) begin : g_power_domains
    // The AON reset triggers the various POR reset for the different clock domains through
    // synchronizers.
    `CASCADED_ASSERTS(CascadeEffAonToRstPorIoDiv4, effective_aon_rst[pd],
                      resets_o.rst_por_io_div4_n[pd], SyncCycles, clk_io_div4_i)

    // The root lc reset is triggered either by the internal reset, or by the pwr_i.rst_lc_req
    // input. The latter is checked independently in pwrmgr_rstmgr_sva_if.
    `CASCADED_ASSERTS(CascadeLocalRstToLc, local_rst_n[pd] && !rst_lc_req[pd], rst_lc_src_n[pd],
                      LcCycles, clk_i)

    // The root sys reset is triggered by the lc reset, or independently by external requests.
    // The latter is checked independently in pwrmgr_rstmgr_sva_if.
    `CASCADED_ASSERTS(CascadeLcToSys, rst_lc_src_n[pd] && !rst_sys_req[pd], rst_sys_src_n[pd],
                      SysCycles, clk_i)

    // Controlled by rst_lc_src_n.
    `CASCADED_ASSERTS(CascadeLcToLcIoDiv4, rst_lc_src_n[pd], resets_o.rst_lc_io_div4_n[pd],
                      SysCycles, clk_io_div4_i)
    `CASCADED_ASSERTS(CascadeLcToLcIoDiv4Shadowed, rst_lc_src_n[pd],
                      resets_o.rst_lc_io_div4_shadowed_n[pd], SysCycles, clk_io_div4_i)

    // Controlled by rst_sys_src_n.
    `CASCADED_ASSERTS(CascadeSysToSysAon, rst_sys_src_n[pd], resets_o.rst_sys_aon_n[pd], SysCycles,
                      clk_aon_i)
    `CASCADED_ASSERTS(CascadeSysToSysIoDiv4, rst_sys_src_n[pd], resets_o.rst_sys_io_div4_n[pd],
                      SysCycles, clk_io_div4_i)
  end

  // Aon to POR
  `CASCADED_ASSERTS(CascadeEffAonToRstPor, effective_aon_rst[rstmgr_pkg::DomainAonSel],
                    resets_o.rst_por_n[rstmgr_pkg::DomainAonSel], SyncCycles, clk_main_i)
  `CASCADED_ASSERTS(CascadeEffAonToRstPorIo, effective_aon_rst[rstmgr_pkg::DomainAonSel],
                    resets_o.rst_por_io_n[rstmgr_pkg::DomainAonSel], SyncCycles, clk_io_i)
  `CASCADED_ASSERTS(CascadeEffAonToRstPorIoDiv2, effective_aon_rst[rstmgr_pkg::DomainAonSel],
                    resets_o.rst_por_io_div2_n[rstmgr_pkg::DomainAonSel], SyncCycles, clk_io_div2_i)
  `CASCADED_ASSERTS(CascadeEffAonToRstPorUcb, effective_aon_rst[rstmgr_pkg::DomainAonSel],
                    resets_o.rst_por_usb_n[rstmgr_pkg::DomainAonSel], SyncCycles, clk_usb_i)

  // Controlled by rst_lc_src_n.
  `CASCADED_ASSERTS(CascadeLcToLcAon, rst_lc_src_n[rstmgr_pkg::DomainAonSel],
                    resets_o.rst_lc_aon_n[rstmgr_pkg::DomainAonSel], SysCycles, clk_aon_i)
  `CASCADED_ASSERTS(CascadeLcToLc, rst_lc_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_lc_n[rstmgr_pkg::Domain0Sel], SysCycles, clk_main_i)

  // Controlled by rst_sys_src_n.
  `CASCADED_ASSERTS(CascadeSysToSys, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_sys_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_main_i)
  `CASCADED_ASSERTS(CascadeSysToSysShadowed, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_sys_shadowed_n[rstmgr_pkg::Domain0Sel], SysCycles, clk_main_i)

  // Peripheral resets cascade from sys.
  // We only care for power domain 1 for peripherals.
  `CASCADED_ASSERTS(CascadeSysToSpiDevice, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_spi_device_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_div4_i)
  `CASCADED_ASSERTS(CascadeSysToSpiHost0, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_spi_host0_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_div4_i)
  `CASCADED_ASSERTS(CascadeSysToSpiHost0Core, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_spi_host0_core_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_i)
  `CASCADED_ASSERTS(CascadeSysToSpiHost1, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_spi_host1_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_div4_i)
  `CASCADED_ASSERTS(CascadeSysToSpiHost1Core, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_spi_host1_core_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_i)
  `CASCADED_ASSERTS(CascadeSysToUsb, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_usb_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_div4_i)
  `CASCADED_ASSERTS(CascadeSysToUsbIf, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_usbif_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_usb_i)
  `CASCADED_ASSERTS(CascadeSysToI2C0, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_i2c0_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_div4_i)
  `CASCADED_ASSERTS(CascadeSysToI2C1, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_i2c1_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_div4_i)
  `CASCADED_ASSERTS(CascadeSysToI2C2, rst_sys_src_n[rstmgr_pkg::Domain0Sel],
                    resets_o.rst_i2c2_n[rstmgr_pkg::Domain0Sel], PeriCycles, clk_io_div4_i)
  `undef FALL_ASSERT
  `undef RISE_ASSERTS
  `undef CASCADED_ASSERTS
endinterface
