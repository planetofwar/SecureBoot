// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Spurious write-enable checker for autogenerated CSR node.
// This module has additional simulation features for error injection testing.

`include "prim_assert.sv"

module prim_reg_we_check #(
  parameter int unsigned AddrWidth    = 5,
  // The onehot width can be <= 2**AddrWidth and does not have to be a power of two.
  parameter int unsigned OneHotWidth  = 2**AddrWidth
) (
  // The module is combinational - the clock and reset are only used for assertions.
  input                          clk_i,
  input                          rst_ni,

  input  logic [OneHotWidth-1:0] oh_i,
  input  logic [AddrWidth-1:0]   addr_i,
  input  logic                   en_i,

  output logic                   err_o
);

  // Prevent optimization of the onehot input buffer.
  logic [OneHotWidth-1:0] oh_buf;
  prim_buf #(
    .Width(OneHotWidth)
  ) u_prim_buf (
    .in_i(oh_i),
    .out_o(oh_buf)
  );

  prim_onehot_check #(
    .OneHotWidth(OneHotWidth),
    .AddrWidth  (prim_util_pkg::vbits(OneHotWidth)),
    .EnableCheck(1),
    // Due to REGWEN masking of write enable strobes,
    // we do not perform strict checks. I.e., we allow cases
    // where en_i is set to 1, but the oh_i vector is all-zeroes.
    .StrictCheck(0)
  ) u_prim_onehot_check (
    .clk_i,
    .rst_ni,
    .oh_i(oh_buf),
    .addr_i('0),
    .en_i,
    .err_o
  );

  // TODO(#12113): add SVAs and other DV code for error injection testing.

endmodule : prim_reg_we_check
