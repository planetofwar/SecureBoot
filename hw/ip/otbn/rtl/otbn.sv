// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "prim_assert.sv"

/**
 * OpenTitan Big Number Accelerator (OTBN)
 */
module otbn
  import prim_alert_pkg::*;
  import otbn_pkg::*;
  import otbn_reg_pkg::*;
#(
  parameter bit                   Stub         = 1'b0,
  parameter regfile_e             RegFile      = RegFileFF,
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},

  // Default seed for URND PRNG
  parameter urnd_prng_seed_t       RndCnstUrndPrngSeed      = RndCnstUrndPrngSeedDefault,

  // Enable internal secure wipe
  parameter bit SecWipeEn  = 1'b0,

  // Default seed and nonce for scrambling
  parameter otp_ctrl_pkg::otbn_key_t   RndCnstOtbnKey   = RndCnstOtbnKeyDefault,
  parameter otp_ctrl_pkg::otbn_nonce_t RndCnstOtbnNonce = RndCnstOtbnNonceDefault
) (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Inter-module signals
  output prim_mubi_pkg::mubi4_t idle_o,

  // Interrupts
  output logic intr_done_o,

  // Alerts
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  // Lifecycle interface
  input lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,

  // Memory configuration
  input prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg_i,

  // EDN clock and interface
  input                     clk_edn_i,
  input                     rst_edn_ni,
  output edn_pkg::edn_req_t edn_rnd_o,
  input  edn_pkg::edn_rsp_t edn_rnd_i,

  output edn_pkg::edn_req_t edn_urnd_o,
  input  edn_pkg::edn_rsp_t edn_urnd_i,

  // Key request to OTP (running on clk_fixed)
  input                                   clk_otp_i,
  input                                   rst_otp_ni,
  output otp_ctrl_pkg::otbn_otp_key_req_t otbn_otp_key_o,
  input  otp_ctrl_pkg::otbn_otp_key_rsp_t otbn_otp_key_i,

  input keymgr_pkg::otbn_key_req_t keymgr_key_i
);

  import prim_mubi_pkg::*;
  import prim_util_pkg::vbits;

  logic rst_n;

  // hold module in reset permanently when stubbing
  if (Stub) begin : gen_stub_otbn
    assign rst_n = 1'b0;
  end else begin : gen_real_otbn
    assign rst_n = rst_ni;
  end

  // The OTBN_*_SIZE parameters are auto-generated by regtool and come from the bus window sizes;
  // they are given in bytes and must be powers of two.
  //
  // Note that DMEM is actually twice as big as is accessible from the register interface, so we
  // have to double the apparent size here.
  localparam int ImemSizeByte = int'(otbn_reg_pkg::OTBN_IMEM_SIZE);
  localparam int DmemSizeByte = int'(2 * otbn_reg_pkg::OTBN_DMEM_SIZE);

  localparam int ImemAddrWidth = vbits(ImemSizeByte);
  localparam int DmemAddrWidth = vbits(DmemSizeByte);

  `ASSERT_INIT(ImemSizePowerOfTwo, 2 ** ImemAddrWidth == ImemSizeByte)
  `ASSERT_INIT(DmemSizePowerOfTwo, 2 ** DmemAddrWidth == DmemSizeByte)

  logic start_d, start_q;
  logic busy_execute_d, busy_execute_q;
  logic done, done_core, locked, idle;
  logic illegal_bus_access_d, illegal_bus_access_q;
  logic dmem_sec_wipe;
  logic imem_sec_wipe;
  logic mems_sec_wipe;
  logic req_sec_wipe_urnd_keys;
  logic [127:0] dmem_sec_wipe_urnd_key, imem_sec_wipe_urnd_key;

  logic core_recoverable_err, recoverable_err_d, recoverable_err_q;
  mubi4_t core_escalate_en;
  core_err_bits_t core_err_bits;
  err_bits_t err_bits, err_bits_d, err_bits_q;
  logic err_bits_en;

  // ERR_BITS register should be cleared due to a write request from the host processor
  // when OTBN is not running.
  logic err_bits_clear;

  logic software_errs_fatal_q, software_errs_fatal_d;

  otbn_reg2hw_t reg2hw;
  otbn_hw2reg_t hw2reg;
  logic [7:0]   hw2reg_status_d;

  // Bus device windows, as specified in otbn.hjson
  typedef enum logic {
    TlWinImem = 1'b0,
    TlWinDmem = 1'b1
  } tl_win_e;

  tlul_pkg::tl_h2d_t tl_win_h2d[2];
  tlul_pkg::tl_d2h_t tl_win_d2h[2];

  // The clock can be gated and some registers can be updated as long as OTBN isn't currently
  // running. Other registers can only be updated when OTBN is in the Idle state (which also implies
  // !locked).
  logic is_not_running, is_not_running_r;
  logic otbn_dmem_scramble_key_req_busy, otbn_imem_scramble_key_req_busy;

  assign is_not_running =
    ~(busy_execute_q | otbn_dmem_scramble_key_req_busy | otbn_imem_scramble_key_req_busy);

  // Add a register stage so we have an `is_not_running_r` which changes with the same timing as
  // `status.q`. Without this `idle_o` will be asserted a cycle before `status.q` changes resulting
  // in bad interrupt timing where the interrupt is seen the cycle after `idle_o`.
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
      is_not_running_r <= 1'b1;
    end else begin
      is_not_running_r <= is_not_running;
    end
  end

  // Inter-module signals ======================================================

  // Note: This is not the same thing as STATUS == IDLE. For example, we want to allow clock gating
  // when locked.
  assign idle_o = mubi4_bool_to_mubi(is_not_running_r);

  // Lifecycle ==================================================================

  localparam int unsigned LcEscalateCopies = 2;
  lc_ctrl_pkg::lc_tx_t [LcEscalateCopies-1:0] lc_escalate_en;
  prim_lc_sync #(
    .NumCopies(LcEscalateCopies)
  ) u_lc_escalate_en_sync (
    .clk_i,
    .rst_ni,
    .lc_en_i(lc_escalate_en_i),
    .lc_en_o(lc_escalate_en)
  );

  // Interrupts ================================================================

  assign done = is_busy_status(status_e'(reg2hw.status.q)) &
    !is_busy_status(status_e'(hw2reg_status_d));

  prim_intr_hw #(
    .Width(1),
    .FlopOutput(0)
  ) u_intr_hw_done (
    .clk_i,
    .rst_ni                (rst_n),
    .event_intr_i          (done),
    .reg2hw_intr_enable_q_i(reg2hw.intr_enable.q),
    .reg2hw_intr_test_q_i  (reg2hw.intr_test.q),
    .reg2hw_intr_test_qe_i (reg2hw.intr_test.qe),
    .reg2hw_intr_state_q_i (reg2hw.intr_state.q),
    .hw2reg_intr_state_de_o(hw2reg.intr_state.de),
    .hw2reg_intr_state_d_o (hw2reg.intr_state.d),
    .intr_o                (intr_done_o)
  );

  // Instruction Memory (IMEM) =================================================

  localparam int ImemSizeWords = ImemSizeByte / 4;
  localparam int ImemIndexWidth = vbits(ImemSizeWords);

  // Access select to IMEM: core (1), or bus (0)
  logic imem_access_core;

  logic imem_req;
  logic imem_write;
  logic [ImemIndexWidth-1:0] imem_index;
  logic [38:0] imem_wdata;
  logic [38:0] imem_wmask;
  logic [38:0] imem_rdata;
  logic imem_rvalid;
  logic imem_illegal_bus_access;

  logic imem_req_core;
  logic imem_write_core;
  logic [ImemIndexWidth-1:0] imem_index_core;
  logic [38:0] imem_rdata_core;
  logic imem_rvalid_core;

  logic imem_req_bus;
  logic imem_dummy_response_q, imem_dummy_response_d;
  logic imem_write_bus;
  logic [ImemIndexWidth-1:0] imem_index_bus;
  logic [38:0] imem_wdata_bus;
  logic [38:0] imem_wmask_bus;
  logic [38:0] imem_rdata_bus;
  logic [top_pkg::TL_DBW-1:0] imem_byte_mask_bus;
  logic imem_rvalid_bus;
  logic [1:0] imem_rerror_bus;

  logic imem_bus_intg_violation;

  typedef struct packed {
    logic        imem;
    logic [14:0] index;
    logic [31:0] wr_data;
  } mem_crc_data_in_t;

  logic             mem_crc_data_in_valid;
  mem_crc_data_in_t mem_crc_data_in;
  logic             set_crc;
  logic [31:0]      crc_in, crc_out;

  logic [ImemAddrWidth-1:0] imem_addr_core;
  assign imem_index_core = imem_addr_core[ImemAddrWidth-1:2];

  logic [1:0] unused_imem_addr_core_wordbits;
  assign unused_imem_addr_core_wordbits = imem_addr_core[1:0];

  otp_ctrl_pkg::otbn_key_t otbn_imem_scramble_key;
  otbn_imem_nonce_t        otbn_imem_scramble_nonce;
  logic                    otbn_imem_scramble_valid;
  logic                    unused_otbn_imem_scramble_key_seed_valid;

  otp_ctrl_pkg::otbn_key_t otbn_dmem_scramble_key;
  otbn_dmem_nonce_t        otbn_dmem_scramble_nonce;
  logic                    otbn_dmem_scramble_valid;
  logic                    unused_otbn_dmem_scramble_key_seed_valid;


  logic otbn_scramble_state_error;

  otbn_scramble_ctrl #(
    .RndCnstOtbnKey  (RndCnstOtbnKey),
    .RndCnstOtbnNonce(RndCnstOtbnNonce)
  ) u_otbn_scramble_ctrl (
    .clk_i,
    .rst_ni,

    .clk_otp_i,
    .rst_otp_ni,

    .otbn_otp_key_o,
    .otbn_otp_key_i,

    .otbn_dmem_scramble_key_o           (otbn_dmem_scramble_key),
    .otbn_dmem_scramble_nonce_o         (otbn_dmem_scramble_nonce),
    .otbn_dmem_scramble_valid_o         (otbn_dmem_scramble_valid),
    .otbn_dmem_scramble_key_seed_valid_o(unused_otbn_dmem_scramble_key_seed_valid),

    .otbn_imem_scramble_key_o           (otbn_imem_scramble_key),
    .otbn_imem_scramble_nonce_o         (otbn_imem_scramble_nonce),
    .otbn_imem_scramble_valid_o         (otbn_imem_scramble_valid),
    .otbn_imem_scramble_key_seed_valid_o(unused_otbn_imem_scramble_key_seed_valid),

    .otbn_dmem_scramble_sec_wipe_i    (dmem_sec_wipe),
    .otbn_dmem_scramble_sec_wipe_key_i(dmem_sec_wipe_urnd_key),
    .otbn_imem_scramble_sec_wipe_i    (imem_sec_wipe),
    .otbn_imem_scramble_sec_wipe_key_i(imem_sec_wipe_urnd_key),

    .otbn_dmem_scramble_key_req_busy_o(otbn_dmem_scramble_key_req_busy),
    .otbn_imem_scramble_key_req_busy_o(otbn_imem_scramble_key_req_busy),

    .state_error_o(otbn_scramble_state_error)
  );

  prim_ram_1p_scr #(
    .Width          (39),
    .Depth          (ImemSizeWords),
    .DataBitsPerMask(39),
    .EnableParity   (0),
    .DiffWidth      (39)
  ) u_imem (
    .clk_i,
    .rst_ni(rst_n),

    .key_valid_i(otbn_imem_scramble_valid),
    .key_i      (otbn_imem_scramble_key),
    .nonce_i    (otbn_imem_scramble_nonce),

    .req_i       (imem_req),
    // TODO: OTBN should always get grant when active, wire up grant and add check it occurs,
    // trigger fatal alert if it doesn't.
    .gnt_o       (),
    .write_i     (imem_write),
    .addr_i      (imem_index),
    .wdata_i     (imem_wdata),
    .wmask_i     (imem_wmask),
    .intg_error_i(locked),

    .rdata_o (imem_rdata),
    .rvalid_o(imem_rvalid),
    .raddr_o (),
    .rerror_o(),
    .cfg_i   (ram_cfg_i)
  );

  // IMEM access from main TL-UL bus
  logic imem_gnt_bus;
  // Always grant to bus accesses, when OTBN is running a dummy response is returned
  assign imem_gnt_bus = imem_req_bus;

  tlul_adapter_sram #(
    .SramAw          (ImemIndexWidth),
    .SramDw          (32),
    .Outstanding     (1),
    .ByteAccess      (0),
    .ErrOnRead       (0),
    .EnableDataIntgPt(1)
  ) u_tlul_adapter_sram_imem (
    .clk_i,
    .rst_ni      (rst_n),
    .tl_i        (tl_win_h2d[TlWinImem]),
    .tl_o        (tl_win_d2h[TlWinImem]),
    .en_ifetch_i (MuBi4False),
    .req_o       (imem_req_bus),
    .req_type_o  (),
    .gnt_i       (imem_gnt_bus),
    .we_o        (imem_write_bus),
    .addr_o      (imem_index_bus),
    .wdata_o     (imem_wdata_bus),
    .wmask_o     (imem_wmask_bus),
    .intg_error_o(imem_bus_intg_violation),
    .rdata_i     (imem_rdata_bus),
    .rvalid_i    (imem_rvalid_bus),
    .rerror_i    (imem_rerror_bus)
  );


  // Mux core and bus access into IMEM
  assign imem_access_core = busy_execute_q | start_q;

  assign imem_req   = imem_access_core ? imem_req_core        : imem_req_bus;
  assign imem_write = imem_access_core ? imem_write_core      : imem_write_bus;
  assign imem_index = imem_access_core ? imem_index_core      : imem_index_bus;
  assign imem_wdata = imem_access_core ? '0                   : imem_wdata_bus;

  assign imem_illegal_bus_access = imem_req_bus & imem_access_core;

  assign imem_dummy_response_d = imem_illegal_bus_access;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      imem_dummy_response_q <= 1'b0;
    end else begin
      imem_dummy_response_q <= imem_dummy_response_d;
    end
  end

  // The instruction memory only supports 32b word writes, so we hardcode its
  // wmask here.
  //
  // Since this could cause confusion if the bus tried to do a partial write
  // (which wasn't caught in the TLUL adapter for some reason), we assert that
  // the wmask signal from the bus is indeed '1 when it requests a write. We
  // don't have the corresponding check for writes from the core because the
  // core cannot perform writes (and has no imem_wmask_o port).
  assign imem_wmask = imem_access_core ? '1 : imem_wmask_bus;
  `ASSERT(ImemWmaskBusIsFullWord_A, imem_req_bus && imem_write_bus |-> imem_wmask_bus == '1)

  // Explicitly tie off bus interface during core operation to avoid leaking
  // the currently executed instruction from IMEM through the bus
  // unintentionally.
  assign imem_rdata_bus = !imem_access_core && !illegal_bus_access_q ? imem_rdata : 39'b0;
  assign imem_rdata_core = imem_rdata;

  // When an illegal bus access is seen, always return a dummy response the follow cycle.
  assign imem_rvalid_bus = (~imem_access_core & imem_rvalid) | imem_dummy_response_q;
  assign imem_rvalid_core = imem_access_core ? imem_rvalid : 1'b0;

  assign imem_byte_mask_bus = tl_win_h2d[TlWinImem].a_mask;

  // No imem errors reported for bus reads. Integrity is carried through on the bus so integrity
  // checking on TL responses will pick up any errors.
  assign imem_rerror_bus = 2'b00;

  // Data Memory (DMEM) ========================================================

  localparam int DmemSizeWords = DmemSizeByte / (WLEN / 8);
  localparam int DmemIndexWidth = vbits(DmemSizeWords);

  // Access select to DMEM: core (1), or bus (0)
  logic dmem_access_core;

  logic dmem_req;
  logic dmem_write;
  logic [DmemIndexWidth-1:0] dmem_index;
  logic [ExtWLEN-1:0] dmem_wdata;
  logic [ExtWLEN-1:0] dmem_wmask;
  logic [ExtWLEN-1:0] dmem_rdata;
  logic dmem_rvalid;
  logic [BaseWordsPerWLEN*2-1:0] dmem_rerror_vec;
  logic dmem_rerror;
  logic dmem_illegal_bus_access;

  logic dmem_req_core;
  logic dmem_write_core;
  logic [DmemIndexWidth-1:0] dmem_index_core;
  logic [ExtWLEN-1:0] dmem_wdata_core;
  logic [ExtWLEN-1:0] dmem_wmask_core;
  logic [BaseWordsPerWLEN-1:0] dmem_rmask_core_q, dmem_rmask_core_d;
  logic [ExtWLEN-1:0] dmem_rdata_core;
  logic dmem_rvalid_core;
  logic dmem_rerror_core;

  logic dmem_req_bus;
  logic dmem_dummy_response_q, dmem_dummy_response_d;
  logic dmem_write_bus;
  logic [DmemIndexWidth-2:0] dmem_index_bus;
  logic [ExtWLEN-1:0] dmem_wdata_bus;
  logic [ExtWLEN-1:0] dmem_wmask_bus;
  logic [ExtWLEN-1:0] dmem_rdata_bus;
  logic [DmemAddrWidth-1:0] dmem_addr_bus;
  logic unused_dmem_addr_bus;
  logic [31:0] dmem_wdata_narrow_bus;
  logic [top_pkg::TL_DBW-1:0] dmem_byte_mask_bus;
  logic dmem_rvalid_bus;
  logic [1:0] dmem_rerror_bus;

  logic dmem_bus_intg_violation;

  logic [DmemAddrWidth-1:0] dmem_addr_core;
  assign dmem_index_core = dmem_addr_core[DmemAddrWidth-1:DmemAddrWidth-DmemIndexWidth];

  logic unused_dmem_addr_core_wordbits;
  assign unused_dmem_addr_core_wordbits = ^dmem_addr_core[DmemAddrWidth-DmemIndexWidth-1:0];

  prim_ram_1p_scr #(
    .Width             (ExtWLEN),
    .Depth             (DmemSizeWords),
    .DataBitsPerMask   (39),
    .EnableParity      (0),
    .DiffWidth         (39),
    .ReplicateKeyStream(1)
  ) u_dmem (
    .clk_i,
    .rst_ni(rst_n),

    .key_valid_i(otbn_dmem_scramble_valid),
    .key_i      (otbn_dmem_scramble_key),
    .nonce_i    (otbn_dmem_scramble_nonce),

    .req_i       (dmem_req),
    // TODO: OTBN should always get grant when active, wire up grant and add check it occurs,
    // trigger fatal alert if it doesn't.
    .gnt_o       (),
    .write_i     (dmem_write),
    .addr_i      (dmem_index),
    .wdata_i     (dmem_wdata),
    .wmask_i     (dmem_wmask),
    .intg_error_i(locked),

    .rdata_o (dmem_rdata),
    .rvalid_o(dmem_rvalid),
    .raddr_o (),
    .rerror_o(),
    .cfg_i   (ram_cfg_i)
  );

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      dmem_rmask_core_q <= '0;
    end else begin
      if (dmem_req_core) begin
        dmem_rmask_core_q <= dmem_rmask_core_d;
      end
    end
  end

  for (genvar i_word = 0; i_word < BaseWordsPerWLEN; ++i_word) begin : g_dmem_intg_check
    logic [1:0] dmem_rerror_raw;

    // Separate check for dmem read data integrity outside of `u_dmem` as `prim_ram_1p_adv` doesn't
    // have functionality for only integrity checking, just fully integrated ECC. Integrity bits are
    // implemented on a 32-bit granule so separate checks are required for each.
    prim_secded_inv_39_32_dec u_dmem_intg_check (
      .data_i    (dmem_rdata[i_word*39+:39]),
      .data_o    (),
      .syndrome_o(),
      .err_o     (dmem_rerror_raw)
    );

    // Only report an error where the word was actually accessed. Otherwise uninitialised memory
    // that OTBN isn't using will cause false errors. dmem_rerror is only reported for reads from
    // OTBN. For Ibex reads integrity checking on TL responses will serve the same purpose.
    assign dmem_rerror_vec[i_word*2 +: 2] = dmem_rerror_raw &
        {2{dmem_rmask_core_q[i_word] & dmem_rvalid & dmem_access_core}};
  end

  // dmem_rerror_vec is 2 bits wide and is used to report ECC errors. Bit 1 is set if there's an
  // uncorrectable error and bit 0 is set if there's a correctable error. However, we're treating
  // all errors as fatal, so OR the two signals together.
  assign dmem_rerror = |dmem_rerror_vec;

  // DMEM access from main TL-UL bus
  logic dmem_gnt_bus;
  // Always grant to bus accesses, when OTBN is running a dummy response is returned
  assign dmem_gnt_bus = dmem_req_bus;

  tlul_adapter_sram #(
    .SramAw          (DmemIndexWidth - 1),
    .SramDw          (WLEN),
    .Outstanding     (1),
    .ByteAccess      (0),
    .ErrOnRead       (0),
    .EnableDataIntgPt(1)
  ) u_tlul_adapter_sram_dmem (
    .clk_i,
    .rst_ni      (rst_n),
    .tl_i        (tl_win_h2d[TlWinDmem]),
    .tl_o        (tl_win_d2h[TlWinDmem]),
    .en_ifetch_i (MuBi4False),
    .req_o       (dmem_req_bus),
    .req_type_o  (),
    .gnt_i       (dmem_gnt_bus),
    .we_o        (dmem_write_bus),
    .addr_o      (dmem_index_bus),
    .wdata_o     (dmem_wdata_bus),
    .wmask_o     (dmem_wmask_bus),
    .intg_error_o(dmem_bus_intg_violation),
    .rdata_i     (dmem_rdata_bus),
    .rvalid_i    (dmem_rvalid_bus),
    .rerror_i    (dmem_rerror_bus)
  );

  // Mux core and bus access into dmem
  assign dmem_access_core = busy_execute_q;

  assign dmem_req = dmem_access_core ? dmem_req_core : dmem_req_bus;
  assign dmem_write = dmem_access_core ? dmem_write_core : dmem_write_bus;
  assign dmem_wmask = dmem_access_core ? dmem_wmask_core : dmem_wmask_bus;
  assign dmem_index = dmem_access_core ? dmem_index_core : {1'b0, dmem_index_bus};
  assign dmem_wdata = dmem_access_core ? dmem_wdata_core : dmem_wdata_bus;

  assign dmem_illegal_bus_access = dmem_req_bus & dmem_access_core;

  assign dmem_dummy_response_d = dmem_illegal_bus_access;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      dmem_dummy_response_q <= 1'b0;
    end else begin
      dmem_dummy_response_q <= dmem_dummy_response_d;
    end
  end

  // Explicitly tie off bus interface during core operation to avoid leaking
  // DMEM data through the bus unintentionally. Once an illegal bus access is seen always return
  // 0 data.
  assign dmem_rdata_bus  = !dmem_access_core && !illegal_bus_access_q ? dmem_rdata : '0;
  assign dmem_rdata_core = dmem_rdata;

  // When an illegal bus access is seen, always return a dummy response the follow cycle.
  assign dmem_rvalid_bus  = (~dmem_access_core & dmem_rvalid) | dmem_dummy_response_q;
  assign dmem_rvalid_core = dmem_access_core ? dmem_rvalid : 1'b0;

  // No dmem errors reported for bus reads. Integrity is carried through on the bus so integrity
  // checking on TL responses will pick up any errors.
  assign dmem_rerror_bus  = 2'b00;
  assign dmem_rerror_core = dmem_rerror;

  assign dmem_addr_bus = tl_win_h2d[TlWinDmem].a_address[DmemAddrWidth-1:0];
  assign dmem_wdata_narrow_bus = tl_win_h2d[TlWinDmem].a_data[31:0];
  assign dmem_byte_mask_bus = tl_win_h2d[TlWinDmem].a_mask;

  // Memory Load Integrity =====================================================
  // CRC logic below assumes a incoming data bus width of 32 bits
  `ASSERT_INIT(TLDWIs32Bit_A, top_pkg::TL_DW == 32)

  // Only advance CRC calculation on full 32-bit writes;
  assign mem_crc_data_in_valid   = ~(dmem_access_core | imem_access_core) &
      ((imem_req_bus & (imem_byte_mask_bus == 4'hf)) |
       (dmem_req_bus & (dmem_byte_mask_bus == 4'hf)));

  assign mem_crc_data_in.wr_data = imem_req_bus ? imem_wdata_bus[31:0] :
                                                  dmem_wdata_narrow_bus[31:0];
  assign mem_crc_data_in.index   = imem_req_bus ? {{15 - ImemIndexWidth{1'b0}}, imem_index_bus} :
                                                   {{15 - (DmemAddrWidth - 2){1'b0}},
                                                    dmem_addr_bus[DmemAddrWidth-1:2]};
  assign mem_crc_data_in.imem    = imem_req_bus;

  // Only the bits that factor into the dmem index and dmem word enables are required
  assign unused_dmem_addr_bus = ^{dmem_addr_bus[DmemAddrWidth-1:DmemIndexWidth],
                                  dmem_addr_bus[1:0]};

  prim_crc32 #(
    .BytesPerWord(6)
  ) u_mem_load_crc32 (
    .clk_i (clk_i),
    .rst_ni(rst_ni),

    .set_crc_i(set_crc),
    .crc_in_i (crc_in),

    .data_valid_i(mem_crc_data_in_valid),
    .data_i      (mem_crc_data_in),
    .crc_out_o   (crc_out)
  );

  assign set_crc = reg2hw.load_checksum.qe;
  assign crc_in = reg2hw.load_checksum.q;
  assign hw2reg.load_checksum.d = crc_out;

  // Registers =================================================================

  logic reg_bus_intg_violation;

  otbn_reg_top u_reg (
    .clk_i,
    .rst_ni  (rst_n),
    .tl_i,
    .tl_o,
    .tl_win_o(tl_win_h2d),
    .tl_win_i(tl_win_d2h),

    .reg2hw,
    .hw2reg,

    .intg_err_o(reg_bus_intg_violation),
    .devmode_i (1'b1)
  );

  logic bus_intg_violation;
  assign bus_intg_violation = (imem_bus_intg_violation | dmem_bus_intg_violation |
                               reg_bus_intg_violation);

  // CMD register
  always_comb begin
    // start is flopped to avoid long timing paths from the TL fabric into OTBN internals.
    start_d       = 1'b0;
    dmem_sec_wipe = 1'b0;
    imem_sec_wipe = 1'b0;

    // Can only start a new command when idle.
    if (idle) begin
      if (reg2hw.cmd.qe) begin
        unique case (reg2hw.cmd.q)
          CmdExecute:     start_d       = 1'b1;
          CmdSecWipeDmem: dmem_sec_wipe = 1'b1;
          CmdSecWipeImem: imem_sec_wipe = 1'b1;
          default: ;
        endcase
      end
    end else if (busy_execute_q) begin
      // OTBN can command a secure wipe of IMEM and DMEM. This occurs when OTBN encounters a fatal
      // error.
      if (mems_sec_wipe) begin
        dmem_sec_wipe = 1'b1;
        imem_sec_wipe = 1'b1;
      end
    end
  end

  assign req_sec_wipe_urnd_keys = dmem_sec_wipe | imem_sec_wipe;

  assign illegal_bus_access_d = dmem_illegal_bus_access | imem_illegal_bus_access;

  // Flop `illegal_bus_access_q` so we know an illegal bus access has happened and to break a timing
  // path from the TL interface into the OTBN core.
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      start_q              <= 1'b0;
      illegal_bus_access_q <= 1'b0;
    end else begin
      start_q              <= start_d;
      illegal_bus_access_q <= illegal_bus_access_d;
    end
  end

  // STATUS register
  // imem/dmem scramble req can be busy when locked, so use a priority selection so locked status
  // always takes priority.
  assign hw2reg_status_d = locked                          ? StatusLocked          :
                           busy_execute_q                  ? StatusBusyExecute     :
                           otbn_dmem_scramble_key_req_busy ? StatusBusySecWipeDmem :
                           otbn_imem_scramble_key_req_busy ? StatusBusySecWipeImem :
                           idle                            ? StatusIdle            :
                                                             StatusLocked;

  assign hw2reg.status.d = hw2reg_status_d;
  assign hw2reg.status.de = 1'b1;

  `ASSERT(OtbnStateDefined, |{locked,
                              busy_execute_q,
                              otbn_dmem_scramble_key_req_busy,
                              otbn_imem_scramble_key_req_busy,
                              idle})

  `ASSERT(OtbnOnlyIdleIfNoActivity, idle |-> ~|{locked,
                                                busy_execute_q,
                                                otbn_dmem_scramble_key_req_busy,
                                                otbn_imem_scramble_key_req_busy})

  // CTRL register
  assign software_errs_fatal_d =
    reg2hw.ctrl.qe && idle ? reg2hw.ctrl.q :
                             software_errs_fatal_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      software_errs_fatal_q <= 1'b0;
    end else begin
      software_errs_fatal_q <= software_errs_fatal_d;
    end
  end

  assign hw2reg.ctrl.d = software_errs_fatal_q;

  // ERR_BITS register
  // The error bits for an OTBN operation get stored on the cycle that done is
  // asserted. Software is expected to read them out before starting the next operation.

  assign hw2reg.err_bits.bad_data_addr.d = err_bits_q.bad_data_addr;
  assign hw2reg.err_bits.bad_insn_addr.d = err_bits_q.bad_insn_addr;
  assign hw2reg.err_bits.call_stack.d = err_bits_q.call_stack;
  assign hw2reg.err_bits.illegal_insn.d = err_bits_q.illegal_insn;
  assign hw2reg.err_bits.loop.d = err_bits_q.loop;
  assign hw2reg.err_bits.key_invalid.d = err_bits_q.key_invalid;
  assign hw2reg.err_bits.imem_intg_violation.d = err_bits_q.imem_intg_violation;
  assign hw2reg.err_bits.dmem_intg_violation.d = err_bits_q.dmem_intg_violation;
  assign hw2reg.err_bits.reg_intg_violation.d = err_bits_q.reg_intg_violation;
  assign hw2reg.err_bits.bus_intg_violation.d = err_bits_q.bus_intg_violation;
  assign hw2reg.err_bits.bad_internal_state.d = err_bits_q.bad_internal_state;
  assign hw2reg.err_bits.illegal_bus_access.d = err_bits_q.illegal_bus_access;
  assign hw2reg.err_bits.lifecycle_escalation.d = err_bits_q.lifecycle_escalation;
  assign hw2reg.err_bits.fatal_software.d = err_bits_q.fatal_software;

  assign err_bits_clear = reg2hw.err_bits.bad_data_addr.qe & is_not_running;
  assign err_bits_d = err_bits_clear ? '0 : err_bits;
  assign err_bits_en = err_bits_clear | done_core;

  logic unused_reg2hw_err_bits;

  // Majority of reg2hw.err_bits is unused as write values are ignored, all writes clear the
  // register to 0.
  assign unused_reg2hw_err_bits = ^{reg2hw.err_bits.bad_data_addr.q,
                                    reg2hw.err_bits.bad_insn_addr,
                                    reg2hw.err_bits.call_stack,
                                    reg2hw.err_bits.illegal_insn,
                                    reg2hw.err_bits.loop,
                                    reg2hw.err_bits.key_invalid,
                                    reg2hw.err_bits.imem_intg_violation,
                                    reg2hw.err_bits.dmem_intg_violation,
                                    reg2hw.err_bits.reg_intg_violation,
                                    reg2hw.err_bits.bus_intg_violation,
                                    reg2hw.err_bits.bad_internal_state,
                                    reg2hw.err_bits.illegal_bus_access,
                                    reg2hw.err_bits.lifecycle_escalation,
                                    reg2hw.err_bits.fatal_software};

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_bits_q <= '0;
    end else if (err_bits_en) begin
      err_bits_q <= err_bits_d;
    end
  end

  // Latch the recoverable error signal from the core. This will be generated as a pulse some time
  // during the run (and before secure wipe finishes). Collect up this bit, clearing on the start or
  // end of an operation (start_q / done_core, respectively)
  assign recoverable_err_d = (recoverable_err_q | core_recoverable_err) & ~(start_q | done_core);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      recoverable_err_q <= '0;
    end else begin
      recoverable_err_q <= recoverable_err_d;
    end
  end

  // FATAL_ALERT_CAUSE register. The .de and .d values are equal for each bit, so that it can only
  // be set, not cleared.
`define DEF_FAC_BIT(NAME)                                         \
  assign hw2reg.fatal_alert_cause.``NAME``.d = 1'b1;              \
  assign hw2reg.fatal_alert_cause.``NAME``.de = err_bits.``NAME;

  `DEF_FAC_BIT(fatal_software)
  `DEF_FAC_BIT(lifecycle_escalation)
  `DEF_FAC_BIT(illegal_bus_access)
  `DEF_FAC_BIT(bad_internal_state)
  `DEF_FAC_BIT(bus_intg_violation)
  `DEF_FAC_BIT(reg_intg_violation)
  `DEF_FAC_BIT(dmem_intg_violation)
  `DEF_FAC_BIT(imem_intg_violation)

`undef DEF_FAC_BIT

  // INSN_CNT register
  logic [31:0] insn_cnt;
  logic        insn_cnt_clear;
  logic        unused_insn_cnt_q;
  assign hw2reg.insn_cnt.d = insn_cnt;
  assign insn_cnt_clear = reg2hw.insn_cnt.qe & is_not_running;
  // Ignore all write data to insn_cnt. All writes zero the register.
  assign unused_insn_cnt_q = ^reg2hw.insn_cnt.q;

  // Alerts ====================================================================

  logic [NumAlerts-1:0] alert_test;
  assign alert_test[AlertFatal] = reg2hw.alert_test.fatal.q & reg2hw.alert_test.fatal.qe;
  assign alert_test[AlertRecov] = reg2hw.alert_test.recov.q & reg2hw.alert_test.recov.qe;

  logic [NumAlerts-1:0] alerts;
  assign alerts[AlertFatal] = |{err_bits_q.fatal_software,
                                err_bits_q.lifecycle_escalation,
                                err_bits_q.illegal_bus_access,
                                err_bits_q.bad_internal_state,
                                err_bits_q.bus_intg_violation,
                                err_bits_q.reg_intg_violation,
                                err_bits_q.dmem_intg_violation,
                                err_bits_q.imem_intg_violation};

  assign alerts[AlertRecov] = (core_recoverable_err | recoverable_err_q) & done_core;

  for (genvar i = 0; i < NumAlerts; i++) begin : gen_alert_tx
    prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .IsFatal(i == AlertFatal)
    ) u_prim_alert_sender (
      .clk_i,
      .rst_ni       (rst_n),
      .alert_test_i (alert_test[i]),
      .alert_req_i  (alerts[i]),
      .alert_ack_o  (),
      .alert_state_o(),
      .alert_rx_i   (alert_rx_i[i]),
      .alert_tx_o   (alert_tx_o[i])
    );
  end


  // EDN Connections ============================================================
  logic edn_rnd_req, edn_rnd_ack;
  logic [EdnDataWidth-1:0] edn_rnd_data;

  logic edn_urnd_req, edn_urnd_ack;
  logic [EdnDataWidth-1:0] edn_urnd_data;

  // These synchronize the data coming from EDN and stack the 32 bit EDN words to achieve an
  // internal entropy width of 256 bit.

  prim_edn_req #(
    .OutWidth(EdnDataWidth),
    .RepCheck(1'b1)
  ) u_prim_edn_rnd_req (
    .clk_i,
    .rst_ni     ( rst_n        ),
    .req_chk_i  ( 1'b1         ),
    .req_i      ( edn_rnd_req  ),
    .ack_o      ( edn_rnd_ack  ),
    .data_o     ( edn_rnd_data ),
    .fips_o     (              ), // unused
    .err_o      (              ),
    .clk_edn_i,
    .rst_edn_ni,
    .edn_o      ( edn_rnd_o ),
    .edn_i      ( edn_rnd_i )
  );

  prim_edn_req #(
    .OutWidth(EdnDataWidth)
  ) u_prim_edn_urnd_req (
    .clk_i,
    .rst_ni     ( rst_n         ),
    .req_chk_i  ( 1'b1          ),
    .req_i      ( edn_urnd_req  ),
    .ack_o      ( edn_urnd_ack  ),
    .data_o     ( edn_urnd_data ),
    .fips_o     (               ), // unused
    .err_o      (               ), // unused
    .clk_edn_i,
    .rst_edn_ni,
    .edn_o      ( edn_urnd_o    ),
    .edn_i      ( edn_urnd_i    )
  );


  // OTBN Core =================================================================

  always_ff @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
      busy_execute_q <= 1'b0;
    end else begin
      busy_execute_q <= busy_execute_d;
    end
  end
  assign busy_execute_d = (busy_execute_q | start_d) & ~done_core;

  otbn_core #(
    .RegFile(RegFile),
    .DmemSizeByte(DmemSizeByte),
    .ImemSizeByte(ImemSizeByte),
    .SecWipeEn(SecWipeEn),
    .RndCnstUrndPrngSeed(RndCnstUrndPrngSeed)
  ) u_otbn_core (
    .clk_i,
    .rst_ni                      (rst_n),

    .start_i                     (start_q),
    .done_o                      (done_core),
    .locked_o                    (locked),

    .err_bits_o                  (core_err_bits),
    .recoverable_err_o           (core_recoverable_err),

    .imem_req_o                  (imem_req_core),
    .imem_addr_o                 (imem_addr_core),
    .imem_rdata_i                (imem_rdata_core),
    .imem_rvalid_i               (imem_rvalid_core),

    .dmem_req_o                  (dmem_req_core),
    .dmem_write_o                (dmem_write_core),
    .dmem_addr_o                 (dmem_addr_core),
    .dmem_wdata_o                (dmem_wdata_core),
    .dmem_wmask_o                (dmem_wmask_core),
    .dmem_rmask_o                (dmem_rmask_core_d),
    .dmem_rdata_i                (dmem_rdata_core),
    .dmem_rvalid_i               (dmem_rvalid_core),
    .dmem_rerror_i               (dmem_rerror_core),

    .edn_rnd_req_o               (edn_rnd_req),
    .edn_rnd_ack_i               (edn_rnd_ack),
    .edn_rnd_data_i              (edn_rnd_data),

    .edn_urnd_req_o              (edn_urnd_req),
    .edn_urnd_ack_i              (edn_urnd_ack),
    .edn_urnd_data_i             (edn_urnd_data),

    .insn_cnt_o                  (insn_cnt),
    .insn_cnt_clear_i            (insn_cnt_clear),

    .mems_sec_wipe_o             (mems_sec_wipe),
    .dmem_sec_wipe_urnd_key_o    (dmem_sec_wipe_urnd_key),
    .imem_sec_wipe_urnd_key_o    (imem_sec_wipe_urnd_key),
    .req_sec_wipe_urnd_keys_i    (req_sec_wipe_urnd_keys),

    .escalate_en_i               (core_escalate_en),

    .software_errs_fatal_i       (software_errs_fatal_q),

    .sideload_key_shares_i       (keymgr_key_i.key),
    .sideload_key_shares_valid_i ({2{keymgr_key_i.valid}})
  );

  // Construct a full set of error bits from the core output
  assign err_bits = '{
    fatal_software:       core_err_bits.fatal_software,
    lifecycle_escalation: lc_escalate_en[0] != lc_ctrl_pkg::Off,
    illegal_bus_access:   illegal_bus_access_q,
    bad_internal_state:   |{core_err_bits.bad_internal_state,
                            otbn_scramble_state_error},
    bus_intg_violation:   bus_intg_violation,
    reg_intg_violation:   core_err_bits.reg_intg_violation,
    dmem_intg_violation:  core_err_bits.dmem_intg_violation,
    imem_intg_violation:  core_err_bits.imem_intg_violation,
    key_invalid:          core_err_bits.key_invalid,
    loop:                 core_err_bits.loop,
    illegal_insn:         core_err_bits.illegal_insn,
    call_stack:           core_err_bits.call_stack,
    bad_insn_addr:        core_err_bits.bad_insn_addr,
    bad_data_addr:        core_err_bits.bad_data_addr
  };

  // An error signal going down into the core to show that it should locally escalate
  assign core_escalate_en = mubi4_or_hi(
      mubi4_bool_to_mubi(|{illegal_bus_access_q, otbn_scramble_state_error, bus_intg_violation}),
      lc_ctrl_pkg::lc_to_mubi4(lc_escalate_en[1])
  );

  // We're idle if we're neither busy executing something nor locked
  assign idle = ~(busy_execute_q | locked | otbn_dmem_scramble_key_req_busy |
                  otbn_imem_scramble_key_req_busy);

  // The core can never signal a write to IMEM
  assign imem_write_core = 1'b0;


  // Asserts ===================================================================

  // All outputs should be known value after reset
  `ASSERT_KNOWN(TlODValidKnown_A, tl_o.d_valid)
  `ASSERT_KNOWN(TlOAReadyKnown_A, tl_o.a_ready)
  `ASSERT_KNOWN(IdleOKnown_A, idle_o)
  `ASSERT_KNOWN(IntrDoneOKnown_A, intr_done_o)
  `ASSERT_KNOWN(AlertTxOKnown_A, alert_tx_o)
  `ASSERT_KNOWN(EdnRndOKnown_A, edn_rnd_o, clk_edn_i, !rst_edn_ni)
  `ASSERT_KNOWN(EdnUrndOKnown_A, edn_urnd_o, clk_edn_i, !rst_edn_ni)
  `ASSERT_KNOWN(OtbnOtpKeyO_A, otbn_otp_key_o, clk_otp_i, !rst_otp_ni)

  // Incoming key must be valid (other inputs go via prim modules that handle the X checks).
  `ASSERT_KNOWN(KeyMgrKeyValid_A, keymgr_key_i.valid)

  // In locked state, the readable registers INSN_CNT, IMEM, and DMEM are expected to always read 0
  // when accessed from the bus. For INSN_CNT, we use "|=>" so that the assertion lines up with
  // "status.q" (a signal that isn't directly accessible here).
  `ASSERT(LockedInsnCntReadsZero_A, (hw2reg.status.d == StatusLocked) |=> insn_cnt == 'd0)
  `ASSERT(NonIdleImemReadsZero_A,
          (hw2reg.status.d != StatusIdle) & imem_rvalid_bus |-> imem_rdata_bus == 'd0)
  `ASSERT(NonIdleDmemReadsZero_A,
          (hw2reg.status.d != StatusIdle) & dmem_rvalid_bus |-> dmem_rdata_bus == 'd0)

  // Error handling: if we pass an error signal down to the core then we should also be setting an
  // error flag.
  `ASSERT(ErrBitIfEscalate_A, mubi4_test_true_loose(core_escalate_en) |=> |err_bits_q)

  // Constraint from package, check here as we cannot have `ASSERT_INIT in package
  `ASSERT_INIT(WsrESizeMatchesParameter_A, $bits(wsr_e) == WsrNumWidth)

  `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(OtbnStartStopFsmCheck_A,
    u_otbn_core.u_otbn_start_stop_control.u_state_regs, alert_tx_o[1])
  `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(OtbnControllerFsmCheck_A,
    u_otbn_core.u_otbn_controller.u_state_regs, alert_tx_o[1])
  `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(OtbnScrambleCtrlFsmCheck_A,
    u_otbn_scramble_ctrl.u_state_regs, alert_tx_o[1])

endmodule
