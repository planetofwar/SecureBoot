// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class clkmgr_base_vseq extends cip_base_vseq #(
  .RAL_T              (clkmgr_reg_block),
  .CFG_T              (clkmgr_env_cfg),
  .COV_T              (clkmgr_env_cov),
  .VIRTUAL_SEQUENCER_T(clkmgr_virtual_sequencer)
);

  `uvm_object_utils(clkmgr_base_vseq)
  `uvm_object_new

  // The extra cycles to wait after reset before starting any test, required so some CSRs (notably
  // hints_status) are properly set when inputs go through synchronizers.
  localparam int POST_APPLY_RESET_CYCLES = 10;

  // This delay is needed to allow updates to the idle inputs to go through synchronizers and
  // counters.
  localparam int IDLE_SYNC_CYCLES = 20;

  // This is the timeout for the various clk status outputs to react to their inputs.
  localparam int CLK_STATUS_TIMEOUT_NS = 100_000;

  rand bit              io_ip_clk_en;
  rand bit              main_ip_clk_en;
  rand bit              usb_ip_clk_en;

  rand mubi_hintables_t idle;

  // Override this from cip_base_vseq, since clkmgr tests are relatively short.
  constraint rand_reset_delay_c {
    rand_reset_delay dist {
      [1 : 1000]            :/ 1,
      [1001 : 100_000]      :/ 2,
      [100_001 : 1_000_000] :/ 6
    };
  }

  mubi4_t       scanmode;
  int           scanmode_on_weight          = 8;

  mubi4_t       extclk_ctrl_high_speed_sel;
  mubi4_t       extclk_ctrl_sel;
  clkmgr_mubi_e mubi_mode;

  virtual function void set_scanmode_on_low_weight();
    scanmode_on_weight = 2;
  endfunction

  function void post_randomize();
    extclk_ctrl_high_speed_sel = get_rand_mubi4_val(6, 2, 2);
    extclk_ctrl_sel = get_rand_mubi4_val(4, 2, 2);
    scanmode = get_rand_mubi4_val(scanmode_on_weight, 4, 4);
    `uvm_info(`gfn, $sformatf(
              "randomize: extclk_ctrl_sel=0x%x, extclk_ctrl_high_speed_sel=0x%x, scanmode=0x%x",
              extclk_ctrl_sel,
              extclk_ctrl_high_speed_sel,
              scanmode
              ), UVM_MEDIUM)
    super.post_randomize();
  endfunction

  virtual task initialize_on_start();
    `uvm_info(`gfn, "In clkmgr_if initialize_on_start", UVM_MEDIUM)
    idle = {NUM_TRANS{MuBi4True}};
    scanmode = MuBi4False;
    cfg.clkmgr_vif.init(.idle(idle), .scanmode(scanmode), .lc_debug_en(Off));
    io_ip_clk_en   = 1'b1;
    main_ip_clk_en = 1'b1;
    usb_ip_clk_en  = 1'b1;
    start_ip_clocks();
  endtask

  // Converts to bool with strict true.
  protected function hintables_t mubi_hintables_to_hintables(mubi_hintables_t mubi_hints);
    hintables_t ret;
    foreach (mubi_hints[i]) ret[i] = prim_mubi_pkg::mubi4_test_true_strict(mubi_hints[i]);
    return ret;
  endfunction

  local function void disable_unnecessary_exclusions();
    ral.get_excl_item().enable_excl("clkmgr_reg_block.clk_enables", 0);
    ral.get_excl_item().enable_excl("clkmgr_reg_block.clk_hints", 0);
    `uvm_info(`gfn, "Adjusted exclusions", UVM_MEDIUM)
    ral.get_excl_item().print_exclusions(UVM_MEDIUM);
  endfunction

  task pre_start();
    mubi_mode = ClkmgrMubiNone;
    `DV_GET_ENUM_PLUSARG(clkmgr_mubi_e, mubi_mode, clkmgr_mubi_mode)
    `uvm_info(`gfn, $sformatf("mubi_mode = %s", mubi_mode.name), UVM_MEDIUM)
    // Disable the assertions requiring strict mubi4 and lc_tx_t to test non-strict-true values.
    $assertoff(0, "prim_mubi4_sync");
    $assertoff(0, "prim_lc_sync");
    cfg.clkmgr_vif.init(.idle({NUM_TRANS{MuBi4True}}), .scanmode(scanmode), .lc_debug_en(Off));
    cfg.clkmgr_vif.update_io_ip_clk_en(1'b1);
    cfg.clkmgr_vif.update_main_ip_clk_en(1'b1);
    cfg.clkmgr_vif.update_usb_ip_clk_en(1'b1);
    cfg.clkmgr_vif.update_all_clk_byp_ack(MuBi4False);
    cfg.clkmgr_vif.update_div_step_down_req(MuBi4False);
    cfg.clkmgr_vif.update_io_clk_byp_ack(MuBi4False);

    disable_unnecessary_exclusions();
    clkmgr_init();
    super.pre_start();
    if (common_seq_type inside {"shadow_reg_errors", "shadow_reg_errors_with_csr_rw"}) begin
      expect_fatal_alerts = 1;
    end

  endtask

  virtual task dut_init(string reset_kind = "HARD");
    super.dut_init(reset_kind);
  endtask

  virtual task dut_shutdown();
    // check for pending clkmgr operations and wait for them to complete
  endtask

  task start_aon_clk();
    // This makes it so the aon clock starts without waiting for its reset,
    // and we won't need to call apply_reset for it.
    #1ps;
    cfg.aon_clk_rst_vif.drive_rst_pin(1'b0);
  endtask

  // This turns on the actual input clocks, as the pwrmgr would.
  task start_ip_clocks();
    fork
      start_io_ip_clock();
      start_main_ip_clock();
      start_usb_ip_clock();
    join
  endtask

  task start_io_ip_clock();
    `uvm_info(`gfn, $sformatf(
              "starting io clk_en with current status %b", cfg.clkmgr_vif.pwr_o.io_status),
              UVM_MEDIUM)
    cfg.io_clk_rst_vif.start_clk();
    cfg.clkmgr_vif.pwr_i.io_ip_clk_en = io_ip_clk_en;
    `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.io_status == 1'b1);,
                 "timeout waiting for io_status to raise", CLK_STATUS_TIMEOUT_NS)
    `uvm_info(`gfn, "starting io clock done", UVM_MEDIUM)
  endtask

  task start_main_ip_clock();
    `uvm_info(`gfn, $sformatf(
              "starting main clk_en with current status %b", cfg.clkmgr_vif.pwr_o.main_status),
              UVM_MEDIUM)
    cfg.main_clk_rst_vif.start_clk();
    cfg.clkmgr_vif.pwr_i.main_ip_clk_en = main_ip_clk_en;
    `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.main_status == 1'b1);,
                 "timeout waiting for main_status to raise", CLK_STATUS_TIMEOUT_NS)
    `uvm_info(`gfn, "starting main clock done", UVM_MEDIUM)
  endtask

  task start_usb_ip_clock();
    `uvm_info(`gfn, $sformatf(
              "starting usb clk_en with current status %b", cfg.clkmgr_vif.pwr_o.usb_status),
              UVM_MEDIUM)
    cfg.usb_clk_rst_vif.start_clk();
    cfg.clkmgr_vif.pwr_i.usb_ip_clk_en = usb_ip_clk_en;
    `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.usb_status == 1'b1);,
                 "timeout waiting for usb_status to raise", CLK_STATUS_TIMEOUT_NS)
    `uvm_info(`gfn, "starting usb clock done", UVM_MEDIUM)
  endtask

  // This turns on or off the actual input clocks, as the pwrmgr would.
  task control_ip_clocks();
    fork
      control_io_ip_clock();
      control_main_ip_clock();
      control_usb_ip_clock();
    join
  endtask

  task control_io_ip_clock();
    // Do nothing if nothing interesting changed.
    if (cfg.clkmgr_vif.pwr_i.io_ip_clk_en == io_ip_clk_en) return;
    `uvm_info(`gfn, $sformatf(
              "controlling io clk_en from %b to %b with current status %b",
              cfg.clkmgr_vif.pwr_i.io_ip_clk_en,
              io_ip_clk_en,
              cfg.clkmgr_vif.pwr_o.io_status
              ), UVM_MEDIUM)
    if (!io_ip_clk_en) begin
      cfg.clkmgr_vif.pwr_i.io_ip_clk_en = io_ip_clk_en;
      `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.io_status == 1'b0);,
                   "timeout waiting for io_status to fall", CLK_STATUS_TIMEOUT_NS)
      cfg.io_clk_rst_vif.stop_clk();
    end else begin
      cfg.io_clk_rst_vif.start_clk();
      cfg.clkmgr_vif.pwr_i.io_ip_clk_en = io_ip_clk_en;
      `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.io_status == 1'b1);,
                   "timeout waiting for io_status to raise", CLK_STATUS_TIMEOUT_NS)
    end
    `uvm_info(`gfn, "controlling io clock done", UVM_MEDIUM)
  endtask

  task control_main_ip_clock();
    // Do nothing if nothing interesting changed.
    if (cfg.clkmgr_vif.pwr_i.main_ip_clk_en == main_ip_clk_en) return;
    `uvm_info(`gfn, $sformatf(
              "controlling main clk_en from %b to %b with current status %b",
              cfg.clkmgr_vif.pwr_i.main_ip_clk_en,
              main_ip_clk_en,
              cfg.clkmgr_vif.pwr_o.main_status
              ), UVM_MEDIUM)
    if (!main_ip_clk_en) begin
      cfg.clkmgr_vif.pwr_i.main_ip_clk_en = main_ip_clk_en;
      `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.main_status == 1'b0);,
                   "timeout waiting for main_status to fall", CLK_STATUS_TIMEOUT_NS)
      cfg.main_clk_rst_vif.stop_clk();
    end else begin
      cfg.main_clk_rst_vif.start_clk();
      cfg.clkmgr_vif.pwr_i.main_ip_clk_en = main_ip_clk_en;
      `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.main_status == 1'b1);,
                   "timeout waiting for main_status to raise", CLK_STATUS_TIMEOUT_NS)
    end
    `uvm_info(`gfn, "controlling main clock done", UVM_MEDIUM)
  endtask

  task control_usb_ip_clock();
    // Do nothing if nothing interesting changed.
    if (cfg.clkmgr_vif.pwr_i.usb_ip_clk_en == usb_ip_clk_en) return;
    `uvm_info(`gfn, $sformatf(
              "controlling usb clk_en from %b to %b with current status %b",
              cfg.clkmgr_vif.pwr_i.usb_ip_clk_en,
              usb_ip_clk_en,
              cfg.clkmgr_vif.pwr_o.usb_status
              ), UVM_MEDIUM)
    if (!usb_ip_clk_en) begin
      cfg.clkmgr_vif.pwr_i.usb_ip_clk_en = usb_ip_clk_en;
      `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.usb_status == 1'b0);,
                   "timeout waiting for usb_status to fall", CLK_STATUS_TIMEOUT_NS)
      cfg.usb_clk_rst_vif.stop_clk();
    end else begin
      cfg.usb_clk_rst_vif.start_clk();
      cfg.clkmgr_vif.pwr_i.usb_ip_clk_en = usb_ip_clk_en;
      `DV_SPINWAIT(wait(cfg.clkmgr_vif.pwr_o.usb_status == 1'b1);,
                   "timeout waiting for usb_status to raise", CLK_STATUS_TIMEOUT_NS)
    end
    `uvm_info(`gfn, "controlling usb clock done", UVM_MEDIUM)
  endtask

  task disable_frequency_measurement(clk_mesr_e which);
    `uvm_info(`gfn, $sformatf("Disabling frequency measurement for %0s", which.name), UVM_MEDIUM)
    case (which)
      ClkMesrIo: begin
        csr_wr(.ptr(ral.io_meas_ctrl_en.en), .value(MuBi4False));
      end
      ClkMesrIoDiv2: begin
        csr_wr(.ptr(ral.io_div2_meas_ctrl_en.en), .value(MuBi4False));
      end
      ClkMesrIoDiv4: begin
        csr_wr(.ptr(ral.io_div4_meas_ctrl_en.en), .value(MuBi4False));
      end
      ClkMesrMain: begin
        csr_wr(.ptr(ral.main_meas_ctrl_en.en), .value(MuBi4False));
      end
      ClkMesrUsb: begin
        csr_wr(.ptr(ral.usb_meas_ctrl_en.en), .value(MuBi4False));
      end
      default: ;
    endcase
  endtask

  task enable_frequency_measurement(clk_mesr_e which, int min_threshold, int max_threshold);
    `uvm_info(`gfn, $sformatf(
              "Enabling frequency measurement for %0s, min=%0d, max=%0d, expected=%0d",
              which.name,
              min_threshold,
              max_threshold,
              ExpectedCounts[which]
              ), UVM_MEDIUM)
    case (which)
      ClkMesrIo: begin
        ral.io_meas_ctrl_shadowed.lo.set(min_threshold);
        ral.io_meas_ctrl_shadowed.hi.set(max_threshold);
        csr_update(.csr(ral.io_meas_ctrl_shadowed));
        ral.io_meas_ctrl_en.en.set(MuBi4True);
        csr_update(.csr(ral.io_meas_ctrl_en));
      end
      ClkMesrIoDiv2: begin
        ral.io_div2_meas_ctrl_shadowed.lo.set(min_threshold);
        ral.io_div2_meas_ctrl_shadowed.hi.set(max_threshold);
        csr_update(.csr(ral.io_div2_meas_ctrl_shadowed));
        ral.io_div2_meas_ctrl_en.en.set(MuBi4True);
        csr_update(.csr(ral.io_div2_meas_ctrl_en));
      end
      ClkMesrIoDiv4: begin
        ral.io_div4_meas_ctrl_shadowed.lo.set(min_threshold);
        ral.io_div4_meas_ctrl_shadowed.hi.set(max_threshold);
        csr_update(.csr(ral.io_div4_meas_ctrl_shadowed));
        ral.io_div4_meas_ctrl_en.en.set(MuBi4True);
        csr_update(.csr(ral.io_div4_meas_ctrl_en));
      end
      ClkMesrMain: begin
        ral.main_meas_ctrl_shadowed.lo.set(min_threshold);
        ral.main_meas_ctrl_shadowed.hi.set(max_threshold);
        csr_update(.csr(ral.main_meas_ctrl_shadowed));
        ral.main_meas_ctrl_en.en.set(MuBi4True);
        csr_update(.csr(ral.main_meas_ctrl_en));
      end
      ClkMesrUsb: begin
        ral.usb_meas_ctrl_shadowed.lo.set(min_threshold);
        ral.usb_meas_ctrl_shadowed.hi.set(max_threshold);
        csr_update(.csr(ral.usb_meas_ctrl_shadowed));
        ral.usb_meas_ctrl_en.en.set(MuBi4True);
        csr_update(.csr(ral.usb_meas_ctrl_en));
      end
      default: ;
    endcase
  endtask

  local function void control_sync_pulse_assert(clk_mesr_e clk, bit enable);
    case (clk)
      ClkMesrIo: begin
        if (enable) $asserton(0, "tb.dut.u_io_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
        else $assertoff(0, "tb.dut.u_io_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
      end
      ClkMesrIoDiv2: begin
        if (enable) $asserton(0, "tb.dut.u_io_div2_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
        else $assertoff(0, "tb.dut.u_io_div2_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
      end
      ClkMesrIoDiv4: begin
        if (enable) $asserton(0, "tb.dut.u_io_div4_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
        else $assertoff(0, "tb.dut.u_io_div4_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
      end
      ClkMesrMain: begin
        if (enable) $asserton(0, "tb.dut.u_main_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
        else $assertoff(0, "tb.dut.u_main_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
      end
      ClkMesrUsb: begin
        if (enable) $asserton(0, "tb.dut.u_usb_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
        else $assertoff(0, "tb.dut.u_usb_meas.u_meas.u_sync_ref.SrcPulseCheck_M");
      end
      default: `uvm_error(`gfn, $sformatf("unexpected clock index '%0d'", clk))
    endcase
  endfunction

  // This turns off/on some clocks being measured to trigger a measurement timeout.
  // A side-effect is that some RTL assertions will fire, so they are corresponsdingly controlled.
  task disturb_measured_clock(clk_mesr_e clk, bit enable);
    case (clk)
      ClkMesrIo, ClkMesrIoDiv2, ClkMesrIoDiv4: begin
        if (enable) cfg.io_clk_rst_vif.start_clk();
        else cfg.io_clk_rst_vif.stop_clk();
        control_sync_pulse_assert(.clk(ClkMesrIo), .enable(enable));
        control_sync_pulse_assert(.clk(ClkMesrIoDiv2), .enable(enable));
        control_sync_pulse_assert(.clk(ClkMesrIoDiv4), .enable(enable));
      end
      ClkMesrMain: begin
        if (enable) cfg.main_clk_rst_vif.start_clk();
        else cfg.main_clk_rst_vif.stop_clk();
        control_sync_pulse_assert(.clk(clk), .enable(enable));
      end
      ClkMesrUsb: begin
        if (enable) cfg.usb_clk_rst_vif.start_clk();
        else cfg.usb_clk_rst_vif.stop_clk();
        control_sync_pulse_assert(.clk(clk), .enable(enable));
      end
      default: `uvm_fatal(`gfn, $sformatf("Unexpected clk '%0d'", clk))
    endcase
  endtask

  function void report_recov_error_mismatch(string error_type, recov_bits_t expected,
                                            recov_bits_t actual);
    recov_bits_t mismatch = actual ^ expected;
    foreach (mismatch[clk]) begin
      clk_mesr_e clk_mesr = clk_mesr_e'(clk);
      if (mismatch[clk]) begin
        `uvm_info(`gfn, $sformatf(
                  "Mismatch %0s for %0s, expected %b, actual %b",
                  error_type,
                  clk_mesr.name,
                  expected[clk],
                  actual[clk]
                  ), UVM_LOW)
      end
    end
    `uvm_error(`gfn, $sformatf(
               "Mismatch for %0s recoverable error, expected 0b%b, got 0b%b",
               error_type,
               expected,
               actual
               ))
  endfunction

  virtual task apply_reset(string kind = "HARD");
    fork
      super.apply_reset(kind);
      if (kind == "HARD")
        fork
          cfg.aon_clk_rst_vif.apply_reset();
          cfg.main_clk_rst_vif.apply_reset();
          cfg.io_clk_rst_vif.apply_reset();
          cfg.usb_clk_rst_vif.apply_reset();
        join
    join
    initialize_on_start();
  endtask

  virtual task apply_resets_concurrently(int reset_duration_ps = 0);
    int clk_periods_q[$] = {
      reset_duration_ps,
      cfg.main_clk_rst_vif.clk_period_ps,
      cfg.io_clk_rst_vif.clk_period_ps,
      cfg.usb_clk_rst_vif.clk_period_ps
    };
    reset_duration_ps = max(clk_periods_q);

    cfg.main_clk_rst_vif.drive_rst_pin(0);
    cfg.io_clk_rst_vif.drive_rst_pin(0);
    cfg.usb_clk_rst_vif.drive_rst_pin(0);

    super.apply_resets_concurrently(reset_duration_ps);

    cfg.main_clk_rst_vif.drive_rst_pin(1);
    cfg.io_clk_rst_vif.drive_rst_pin(1);
    cfg.usb_clk_rst_vif.drive_rst_pin(1);
    initialize_on_start();
  endtask

  task post_apply_reset(string reset_kind = "HARD");
    super.post_apply_reset(reset_kind);
    cfg.io_clk_rst_vif.wait_clks(POST_APPLY_RESET_CYCLES);
  endtask

  // setup basic clkmgr features
  virtual task clkmgr_init();
    // Initialize input clock frequencies.
    cfg.main_clk_rst_vif.set_freq_mhz((1.0 * MainClkHz) / 1_000_000);
    cfg.io_clk_rst_vif.set_freq_mhz((1.0 * IoClkHz) / 1_000_000);
    cfg.usb_clk_rst_vif.set_freq_mhz((1.0 * UsbClkHz) / 1_000_000);
    // The real clock rate for aon is 200kHz, but that can slow testing down.
    // Increasing its frequency improves DV efficiency without compromising quality.
    cfg.aon_clk_rst_vif.set_freq_mhz((1.0 * FakeAonClkHz) / 1_000_000);
  endtask
endclass : clkmgr_base_vseq
