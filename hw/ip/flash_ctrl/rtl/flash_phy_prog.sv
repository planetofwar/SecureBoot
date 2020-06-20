// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Flash Phy Prog Module
//
// This module implements the flash phy program operation
//
// The flash phy prog module is mainly responsible for packing incoming data
// transactions into appropriate flash word sizes.
//
// This is done primarily for two reasons
// - Reduce program stress on the flash
//   Flash modules usually have a limit to how many times adjacent words can be programmed.
//   If a programming beat is longer than a flash word, it would be best to compact those
//   beats into multiples of the flash word size to improve performance and reduce
//   unecessary programmings
//
// - Observe minimum block cipher sizes for scrambling / descrambling and ECC.
//   Scrambling algorithms and ECC work on a specific chunk of data.  When these features
//   are enabled, the phy controller needs to ensure there is enough data to satisfy that
//   request - TBD: This should be checked with software.  Hardware could also always behave
//   as it does in the point above and rely on software to correctly compact the data.

module flash_phy_prog import flash_phy_pkg::*; (
  input clk_i,
  input rst_ni,
  input req_i,
  input [WordSelW-1:0] sel_i,
  input [BusWidth-1:0] data_i,
  input last_i,
  input ack_i,
  output logic req_o,
  output logic ack_o,
  output logic [DataWidth-1:0] data_o
);

  typedef enum logic [2:0] {
    StIdle,
    StPrePack,
    StPackData,
    StPostPack,
    StWaitFlash
  } prog_state_e;

  typedef enum logic [1:0] {
    Filler,
    Actual
  } data_sel_e;

  prog_state_e state_d, state_q;

  // The currently observed data beat
  logic [WordSelW-1:0] idx;
  logic pack_valid;
  logic [BusWidth-1:0] pack_data;
  logic align_next;
  data_sel_e data_sel;

  logic [WidthMultiple-1:0][BusWidth-1:0] packed_data;

  // selects empty data or real data
  assign pack_data  = (data_sel == Actual) ? data_i : {BusWidth{1'b1}};

  // next idx will be aligned
  assign align_next = (idx > '0) ? (idx - 1'b1) == sel_i : 1'b0;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      idx <= '0;
    end else if (pack_valid && idx == (WidthMultiple-1)) begin
      // when a flash word is packed full, return index to 0
      idx <= '0;
    end else if (pack_valid) begin
      // increment otherwise
      idx <= idx + 1'b1;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q <= StIdle;
    end else begin
      state_q <= state_d;
    end
  end

  // If the first beat of an incoming transaction is not aligned to word boundary (for example
  // if each flash word is 4 bus words wide, and the first word to program starts at index 1),
  // the fsm pre-packs the flash word with empty words until the supplied index.
  // Once at the index, real data supplied from the flash controller is packed until the last
  // beat of data.  At the last beat of data, if it is not also aligned (index 3 in this example),
  // more empty words are packed at the end to fill out the word.
  //
  always_comb begin
    state_d = state_q;

    pack_valid = 1'b0;
    data_sel = Filler;
    req_o = 1'b0;
    ack_o = 1'b0;

    unique case (state_q)
      StIdle: begin
        // if first beat of a transaction is not aligned, prepack with empty bits
        if (req_i && |sel_i) begin
          state_d = StPrePack;
        end else if (req_i) begin
          state_d = StPackData;
        end
      end

      StPrePack: begin
        // pack until currently supplied data
        pack_valid = (idx < sel_i);
        if (idx == align_next) begin
          state_d = StPackData;
        end
      end

      StPackData: begin
        pack_valid = req_i;
        data_sel = Actual;

        if (req_i && idx == (WidthMultiple-1)) begin
          // last beat of a flash word
          state_d = StWaitFlash;
        end else if (req_i && last_i) begin
          // last beat is not aligned with the last entry of flash word
          state_d = StPostPack;
        end else if (req_i) begin
          ack_o = 1'b1;
        end
      end

      StPostPack: begin
        // supply filler data
        pack_valid = 1'b1;
        data_sel = Filler;

        // finish packing remaining entries
        if (idx == (WidthMultiple-1)) begin
          state_d = StWaitFlash;
        end
      end

      StWaitFlash: begin
        req_o = 1'b1;

        if (ack_i) begin
          ack_o = 1'b1;
          state_d = StIdle;
        end
      end

      default:;
    endcase // unique case (state_q)
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      packed_data <= '0;
    end else if (req_o && ack_i) begin
      packed_data <= '0;
    end else if (pack_valid) begin
      packed_data[idx] <= pack_data;
    end
  end

  assign data_o = packed_data;


  /////////////////////////////////
  // Assertions
  /////////////////////////////////

  // Prepack state can only pack up to WidthMultiple - 1
  `ASSERT(PrePackRule_A, state_q == StPrePack && pack_valid |-> idx < (WidthMultiple - 1))

  // Postpack states should never pack the first index (as it would be aligned in that case)
  `ASSERT(PostPackRule_A, state_q == StPostPack && pack_valid |-> idx != '0)

endmodule // flash_phy_prog
