// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES S-Box with First-Order Domain-Oriented Masking
//
// This is the unpipelined version using DOM-dep multipliers. It has a latency of 5 clock cycles
// and requires 28 bits of pseudo-random data per evaluation. Pipelining would only be beneficial
// when using
// - either a cipher core architecture with a data path smaller than 128 bit, i.e., where the
//   individual S-Boxes are evaluated more than once per round, or
// - a fully unrolled cipher core architecture for maximum throughput.
//
// Note: The DOM AES S-Box is built on top of the Canright masked S-Box without mask re-use.
//
// For details, see the following papers and reports:
// [1] Gross, "Domain-Oriented Masking: Compact Masked Hardware Implementations with Arbitrary
//     Protection Order" available at https://eprint.iacr.org/2016/486.pdf
// [2] Canright, "A very compact 'perfectly masked' S-box for AES (corrected)" available at
//     https://eprint.iacr.org/2009/011.pdf
// [3] Canright, "A very compact Rijndael S-box" available at https://hdl.handle.net/10945/25608

///////////////////////////////////////////////////////////////////////////////////////////////////
// IMPORTANT NOTE:                                                                               //
//                            DO NOT USE THIS FOR SYNTHESIS BLINDLY!                             //
//                                                                                               //
// This implementation targets primarily Xilinx Vivado synthesis as well as RTL simulation. It   //
// contains synthesis attributes specific to Xilinx Vivado to prevent the synthesis tool from    //
// optimizing away registers and to enforce the correct ordering of operations. Other synthesis  //
// tools might still heavily optimize the design. The result is likely insecure. Use with care.  //
///////////////////////////////////////////////////////////////////////////////////////////////////

`include "prim_assert.sv"

// DOM-indep GF(2^N) multiplier, unpipelined, first-order masked.
// Computes (a_q ^ b_q) = (a_x ^ b_x) * (a_y ^ b_y), i.e. q = x * y using first-order
// domain-oriented masking. The sharings of x and y are required to be uniformly random and
// independent from each other.
// See Fig. 2 in [1].
module aes_dom_indep_mul_gf2pn #(
  parameter int unsigned NPower = 4
) (
  input  logic              clk_i,
  input  logic              rst_ni,
  input  logic [NPower-1:0] a_x,    // Share a of x
  input  logic [NPower-1:0] a_y,    // Share a of y
  input  logic [NPower-1:0] b_x,    // Share b of x
  input  logic [NPower-1:0] b_y,    // Share b of y
  input  logic [NPower-1:0] z_0,    // Randomness for resharing
  output logic [NPower-1:0] a_q,    // Share a of q
  output logic [NPower-1:0] b_q     // Share b of q
);

  import aes_sbox_canright_pkg::*;

  /////////////////
  // Calculation //
  /////////////////
  // Inner-domain terms
  (* keep = "true" *) logic [NPower-1:0] mul_ax_ay, mul_bx_by;
  if (NPower == 4) begin : gen_inner_mul_gf2p4
    assign mul_ax_ay = aes_mul_gf2p4(a_x, a_y);
    assign mul_bx_by = aes_mul_gf2p4(b_x, b_y);

  end else begin : gen_inner_mul_gf2p2
    assign mul_ax_ay = aes_mul_gf2p2(a_x, a_y);
    assign mul_bx_by = aes_mul_gf2p2(b_x, b_y);
  end

  // Cross-domain terms
  logic [NPower-1:0] mul_ax_by, mul_ay_bx;
  if (NPower == 4) begin : gen_cross_mul_gf2p4
    assign mul_ax_by = aes_mul_gf2p4(a_x, b_y);
    assign mul_ay_bx = aes_mul_gf2p4(a_y, b_x);

  end else begin : gen_cross_mul_gf2p2
    assign mul_ax_by = aes_mul_gf2p2(a_x, b_y);
    assign mul_ay_bx = aes_mul_gf2p2(a_y, b_x);
  end

  ///////////////
  // Resharing //
  ///////////////
  // Resharing of cross-domain terms
  (* keep = "true" *) logic [NPower-1:0] aq_z0_d, aq_z0_q;
  (* keep = "true" *) logic [NPower-1:0] bq_z0_d, bq_z0_q;
  assign aq_z0_d = z_0 ^ mul_ax_by;
  assign bq_z0_d = z_0 ^ mul_ay_bx;

  // Registers
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      aq_z0_q <= '0;
      bq_z0_q <= '0;
    end else begin
      aq_z0_q <= aq_z0_d;
      bq_z0_q <= bq_z0_d;
    end
  end

  /////////////////
  // Integration //
  /////////////////
  assign a_q = mul_ax_ay ^ aq_z0_q;
  assign b_q = mul_bx_by ^ bq_z0_q;

  // Only GF(2^4) and GF(2^2) is supported.
  `ASSERT_INIT(AesDomIndepMulPower, NPower == 4 || NPower == 2)

endmodule

// DOM-dep GF(2^N) multiplier, unpipelined, first-order masked.
// Computes (a_q ^ b_q) = (a_x ^ b_x) * (a_y ^ b_y), i.e. q = x * y using first-order
// domain-oriented masking. The sharings of x and y are NOT required to be independent from each
// other. This is the un-optimized version consuming 3 times N bits of randomness for blinding and
// resharing. It is not used in the design but we keep it for reference.
// See Fig. 4 and Formulas 8 - 11 in [1].
module aes_dom_dep_mul_gf2pn_unopt #(
  parameter int unsigned NPower = 4
) (
  input  logic              clk_i,
  input  logic              rst_ni,
  input  logic [NPower-1:0] a_x,    // Share a of x
  input  logic [NPower-1:0] a_y,    // Share a of y
  input  logic [NPower-1:0] b_x,    // Share b of x
  input  logic [NPower-1:0] b_y,    // Share b of y
  input  logic [NPower-1:0] a_z,    // Randomness for blinding
  input  logic [NPower-1:0] b_z,    // Randomness for blinding
  input  logic [NPower-1:0] z_0,    // Randomness for resharing
  output logic [NPower-1:0] a_q,    // Share a of q
  output logic [NPower-1:0] b_q     // Share b of q
);

  import aes_sbox_canright_pkg::*;

  //////////////
  // Blinding //
  //////////////
  // Blinding of y by z.
  (* keep = "true" *) logic [NPower-1:0] a_yz_d, a_yz_q;
  (* keep = "true" *) logic [NPower-1:0] b_yz_d, b_yz_q;
  assign a_yz_d = a_y ^ a_z;
  assign b_yz_d = b_y ^ b_z;

  // Registers
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      a_yz_q <= '0;
      b_yz_q <= '0;
    end else begin
      a_yz_q <= a_yz_d;
      b_yz_q <= b_yz_d;
    end
  end

  ////////////////
  // Correction //
  ////////////////
  logic [NPower-1:0] a_mul_x_z, b_mul_x_z;
  aes_dom_indep_mul_gf2pn #(
    .NPower ( NPower )
  ) aes_dom_indep_mul_gf2pn (
    .clk_i  ( clk_i     ),
    .rst_ni ( rst_ni    ),
    .a_x    ( a_x       ), // Share a of x
    .a_y    ( a_z       ), // Share a of z
    .b_x    ( b_x       ), // Share b of x
    .b_y    ( b_z       ), // Share b of z
    .z_0    ( z_0       ), // Randomness for resharing
    .a_q    ( a_mul_x_z ), // Share a of x * z
    .b_q    ( b_mul_x_z )  // Share b of x * z
  );

  /////////////////
  // Calculation //
  /////////////////
  // Combine shares of blinded y to obtain b.
  logic [NPower-1:0] b;
  assign b = a_yz_q ^ b_yz_q;

  logic [NPower-1:0] a_mul_ax_b, b_mul_bx_b;
  if (NPower == 4) begin : gen_mul_gf2p4
    assign a_mul_ax_b = aes_mul_gf2p4(a_x, b);
    assign b_mul_bx_b = aes_mul_gf2p4(b_x, b);

  end else begin : gen_mul_gf2p2
    assign a_mul_ax_b = aes_mul_gf2p2(a_x, b);
    assign b_mul_bx_b = aes_mul_gf2p2(b_x, b);
  end

  /////////////////
  // Integration //
  /////////////////
  assign a_q = a_mul_x_z ^ a_mul_ax_b;
  assign b_q = b_mul_x_z ^ b_mul_bx_b;

  // Only GF(2^4) and GF(2^2) is supported.
  `ASSERT_INIT(AesDomDepMulUnoptPower, NPower == 4 || NPower == 2)

endmodule

// DOM-dep GF(2^N) multiplier, unpipelined, first-order masked.
// Computes (a_q ^ b_q) = (a_x ^ b_x) * (a_y ^ b_y), i.e. q = x * y using first-order
// domain-oriented masking. The sharings of x and y are NOT required to be independent from each
// other. This is the optimized version consuming 2 instead of 3 times N bits of randomness for
// blinding and resharing.
// See Formula 12 in [1].
module aes_dom_dep_mul_gf2pn #(
  parameter int unsigned NPower      = 4,
  parameter bit          PreDOMIndep = 1'b0 // 1'b0: Not followed by a DOM-indep multiplier, this
                                            //       enables additional area optimizations
                                            // 1'b1: Directly followed by a DOM-indep multiplier,
                                            //       this is the version discussed in [1].
) (
  input  logic              clk_i,
  input  logic              rst_ni,
  input  logic [NPower-1:0] a_x,    // Share a of x
  input  logic [NPower-1:0] a_y,    // Share a of y
  input  logic [NPower-1:0] b_x,    // Share b of x
  input  logic [NPower-1:0] b_y,    // Share b of y
  input  logic [NPower-1:0] z_0,    // Randomness for blinding
  input  logic [NPower-1:0] z_1,    // Randomness for resharing
  output logic [NPower-1:0] a_q,    // Share a of q
  output logic [NPower-1:0] b_q     // Share b of q
);

  import aes_sbox_canright_pkg::*;

  //////////////
  // Blinding //
  //////////////
  // Blinding of y by z_0.
  (* keep = "true" *) logic [NPower-1:0] a_yz0_d, a_yz0_q;
  (* keep = "true" *) logic [NPower-1:0] b_yz0_d, b_yz0_q;
  assign a_yz0_d = a_y ^ z_0;
  assign b_yz0_d = b_y ^ z_0;

  // Registers
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      a_yz0_q <= '0;
      b_yz0_q <= '0;
    end else begin
      a_yz0_q <= a_yz0_d;
      b_yz0_q <= b_yz0_d;
    end
  end

  ////////////////
  // Correction //
  ////////////////
  // Basically, this a DOM-indep multiplier with:
  // - a_x = a_x, b_x = b_x, and
  // - a_y = z_0, b_y = 0 (constant),
  // which allows for further optimizations.

  // Calculation
  (* keep = "true" *) logic [NPower-1:0] mul_ax_z0, mul_bx_z0;
  if (NPower == 4) begin : gen_corr_mul_gf2p4
    assign mul_ax_z0 = aes_mul_gf2p4(a_x, z_0);
    assign mul_bx_z0 = aes_mul_gf2p4(b_x, z_0);

  end else begin : gen_corr_mul_gf2p2
    assign mul_ax_z0 = aes_mul_gf2p2(a_x, z_0);
    assign mul_bx_z0 = aes_mul_gf2p2(b_x, z_0);
  end

  // Resharing
  (* keep = "true" *) logic [NPower-1:0] axz0_z1_d, axz0_z1_q;
  (* keep = "true" *) logic [NPower-1:0] bxz0_z1_d, bxz0_z1_q;
  assign axz0_z1_d = mul_ax_z0 ^ z_1;
  assign bxz0_z1_d = mul_bx_z0 ^ z_1;

  // Registers
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      axz0_z1_q <= '0;
      bxz0_z1_q <= '0;
    end else begin
      axz0_z1_q <= axz0_z1_d;
      bxz0_z1_q <= bxz0_z1_d;
    end
  end

  ///////////////////////////////
  // Calculation & Integration //
  ///////////////////////////////
  // Compute b. Note that unlike for the unoptimized implementation, we don't combine the blinded
  // shares of y to obtain a single b value. Intstead, every domain d gets its own version of b:
  //
  //   d_b = d_y ^ _D_y_z0
  //
  // where _D_y_z0 corresponds to the sum of all domains of y except for domain d, each
  // individually blinded by z0 (needs to happen before the register bank). This optimization
  // is only suitable for first-order masking.
  // See Formula 12 in [1].

  if (PreDOMIndep == 1'b1) begin : gen_pre_dom_indep
    // This DOM-dep multiplier is directly followed by a DOM-indep multiplier without an additional
    // pipeline stage in between. To prevent SCA leakage in the DOM-indep multiplier, the d_y and
    // _D_y_z0 parts of d_b need to be individually multiplied with input x and then the results
    // need to be integrated (summed up) on a per-domain basis.

    // d_y part: Inner-domain terms of x * y
    (* keep = "true" *) logic [NPower-1:0] mul_ax_ay_d, mul_ax_ay_q;
    (* keep = "true" *) logic [NPower-1:0] mul_bx_by_d, mul_bx_by_q;
    if (NPower == 4) begin : gen_inner_mul_gf2p4
      assign mul_ax_ay_d = aes_mul_gf2p4(a_x, a_y);
      assign mul_bx_by_d = aes_mul_gf2p4(b_x, b_y);

    end else begin : gen_inner_mul_gf2p2
      assign mul_ax_ay_d = aes_mul_gf2p2(a_x, a_y);
      assign mul_bx_by_d = aes_mul_gf2p2(b_x, b_y);
    end

    // Registers
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        mul_ax_ay_q <= '0;
        mul_bx_by_q <= '0;
      end else begin
        mul_ax_ay_q <= mul_ax_ay_d;
        mul_bx_by_q <= mul_bx_by_d;
      end
    end

    // Input Registers
    (* keep = "true" *) logic [NPower-1:0] a_x_q;
    (* keep = "true" *) logic [NPower-1:0] b_x_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        a_x_q <= '0;
        b_x_q <= '0;
      end else begin
        a_x_q <= a_x;
        b_x_q <= b_x;
      end
    end

    // _D_y_z0 part: Cross-domain terms: d_x * _D_y_z0
    // Need to use registered version of input x.
    (* keep = "true" *) logic [NPower-1:0] mul_ax_byz0, mul_bx_ayz0;
    if (NPower == 4) begin : gen_cross_mul_gf2p4
      assign mul_ax_byz0 = aes_mul_gf2p4(a_x_q, b_yz0_q);
      assign mul_bx_ayz0 = aes_mul_gf2p4(b_x_q, a_yz0_q);

    end else begin : gen_cross_mul_gf2p2
      assign mul_ax_byz0 = aes_mul_gf2p2(a_x_q, b_yz0_q);
      assign mul_bx_ayz0 = aes_mul_gf2p2(b_x_q, a_yz0_q);
    end

    // Integration
    assign a_q = axz0_z1_q ^ mul_ax_ay_q ^ mul_ax_byz0;
    assign b_q = bxz0_z1_q ^ mul_bx_by_q ^ mul_bx_ayz0;

  end else begin : gen_not_pre_dom_indep
    // This DOM-dep multiplier is not directly followed by a DOM-indep multiplier. As a result,
    // the the d_y and _D_y_z0 parts of d_b can be summed up prior to the multiplication with input
    // x which helps saving 2 GF multipliers and 4 registers (NPower flops each).

    // Sum up d_y and _D_y_z0.
    (* keep = "true" *) logic [NPower-1:0] a_b, b_b;
    assign a_b = a_y ^ b_yz0_q;
    assign b_b = b_y ^ a_yz0_q;

    // GF multiplications
    (* keep = "true" *) logic [NPower-1:0] a_mul_ax_b, b_mul_bx_b;
    if (NPower == 4) begin : gen_mul_gf2p4
      assign a_mul_ax_b = aes_mul_gf2p4(a_x, a_b);
      assign b_mul_bx_b = aes_mul_gf2p4(b_x, b_b);
    end else begin : gen_mul_gf2p2
      assign a_mul_ax_b = aes_mul_gf2p2(a_x, a_b);
      assign b_mul_bx_b = aes_mul_gf2p2(b_x, b_b);
    end

    // Integration
    assign a_q = axz0_z1_q ^ a_mul_ax_b;
    assign b_q = bxz0_z1_q ^ b_mul_bx_b;
  end

  // Only GF(2^4) and GF(2^2) is supported.
  `ASSERT_INIT(AesDomDepMulPower, NPower == 4 || NPower == 2)

endmodule

// Inverse in GF(2^4) using first-order domain-oriented masking and normal basis [z^4, z].
// See Fig. 6 in [2] (grey block, Stages 2 and 3) and Formulas 6, 13, 14, 15, 16, 17 in [2].
module aes_dom_inverse_gf2p4 (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic  [3:0] a_gamma,
  input  logic  [3:0] b_gamma,
  input  logic [11:0] prd,
  output logic  [3:0] a_gamma_inv,
  output logic  [3:0] b_gamma_inv
);

  import aes_sbox_canright_pkg::*;

  // Distribute the randomness for the various multiplers.
  logic [3:0] z_2;
  logic [3:0] z_3_1;
  logic [3:0] z_3_0;
  assign z_2   = prd[3:0];
  assign z_3_0 = prd[7:4];
  assign z_3_1 = prd[11:8];

  /////////////
  // Stage 2 //
  /////////////
  // Formula 13 in [2].

  logic [1:0] a_gamma1, a_gamma0, b_gamma1, b_gamma0, a_gamma1_gamma0, b_gamma1_gamma0;
  (* keep = "true" *) logic [1:0] a_gamma_ss, b_gamma_ss;
  assign a_gamma1 = a_gamma[3:2];
  assign a_gamma0 = a_gamma[1:0];
  assign b_gamma1 = b_gamma[3:2];
  assign b_gamma0 = b_gamma[1:0];

  assign a_gamma_ss = aes_scale_omega2_gf2p2(aes_square_gf2p2(a_gamma1 ^ a_gamma0));
  assign b_gamma_ss = aes_scale_omega2_gf2p2(aes_square_gf2p2(b_gamma1 ^ b_gamma0));

  aes_dom_dep_mul_gf2pn #(
    .NPower      ( 2    ),
    .PreDOMIndep ( 1'b0 )
  ) aes_dom_mul_gamma1_gamma0 (
    .clk_i  ( clk_i           ),
    .rst_ni ( rst_ni          ),
    .a_x    ( a_gamma1        ), // Share a of x
    .a_y    ( a_gamma0        ), // Share a of y
    .b_x    ( b_gamma1        ), // Share b of x
    .b_y    ( b_gamma0        ), // Share b of y
    .z_0    ( z_2[1:0]        ), // Randomness for blinding
    .z_1    ( z_2[3:2]        ), // Randomness for resharing
    .a_q    ( a_gamma1_gamma0 ), // Share a of q
    .b_q    ( b_gamma1_gamma0 )  // Share b of q
  );

  /////////////
  // Stage 3 //
  /////////////

  // Formulas 14 and 15 in [2].
  (* keep = "true" *) logic [1:0] a_omega, b_omega;
  assign a_omega = aes_square_gf2p2(a_gamma1_gamma0 ^ a_gamma_ss);
  assign b_omega = aes_square_gf2p2(b_gamma1_gamma0 ^ b_gamma_ss);

  // Formulas 16 and 17 in [2].

  aes_dom_dep_mul_gf2pn #(
    .NPower      ( 2    ),
    .PreDOMIndep ( 1'b1 )
  ) aes_dom_mul_omega_gamma1 (
    .clk_i  ( clk_i            ),
    .rst_ni ( rst_ni           ),
    .a_x    ( a_gamma1         ), // Share a of x
    .a_y    ( a_omega          ), // Share a of y
    .b_x    ( b_gamma1         ), // Share b of x
    .b_y    ( b_omega          ), // Share b of y
    .z_0    ( z_3_1[1:0]       ), // Randomness for blinding
    .z_1    ( z_3_1[3:2]       ), // Randomness for resharing
    .a_q    ( a_gamma_inv[1:0] ), // Share a of q
    .b_q    ( b_gamma_inv[1:0] )  // Share b of q
  );

  aes_dom_dep_mul_gf2pn #(
    .NPower      ( 2    ),
    .PreDOMIndep ( 1'b1 )
  ) aes_dom_mul_omega_gamma0 (
    .clk_i  ( clk_i            ),
    .rst_ni ( rst_ni           ),
    .a_x    ( a_omega          ), // Share a of x
    .a_y    ( a_gamma0         ), // Share a of y
    .b_x    ( b_omega          ), // Share b of x
    .b_y    ( b_gamma0         ), // Share b of y
    .z_0    ( z_3_0[1:0]       ), // Randomness for blinding
    .z_1    ( z_3_0[3:2]       ), // Randomness for resharing
    .a_q    ( a_gamma_inv[3:2] ), // Share a of q
    .b_q    ( b_gamma_inv[3:2] )  // Share b of q
  );

endmodule

// Inverse in GF(2^8) using first-order domain-oriented masking and normal basis [y^16, y].
// See Fig. 6 in [1] and Formulas 3, 12, 18 and 19 in [2].
module aes_dom_inverse_gf2p8 (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic  [7:0] a_y,     // input data masked by b_y
  input  logic  [7:0] b_y,     // input mask
  input  logic [27:0] prd,     // pseudo-random data, e.g. for intermediate masks
  output logic  [7:0] a_y_inv, // output data masked by b_y_inv
  output logic  [7:0] b_y_inv  // output mask
);

  import aes_sbox_canright_pkg::*;

  // Distribute the randomness for the various stages.
  logic  [7:0] z_1;
  logic [11:0] z_23;
  logic  [3:0] z_4_0;
  logic  [3:0] z_4_1;
  assign z_1   = prd[7:0];
  assign z_23  = prd[19:8];
  assign z_4_0 = prd[23:20];
  assign z_4_1 = prd[27:24];

  /////////////
  // Stage 1 //
  /////////////
  // Formula 12 in [2].

  logic [3:0] a_y1, a_y0, b_y1, b_y0, a_y1_y0, b_y1_y0;
  (* keep = "true" *) logic [3:0] a_y_ss, b_y_ss, a_gamma, b_gamma;
  assign a_y1 = a_y[7:4];
  assign a_y0 = a_y[3:0];
  assign b_y1 = b_y[7:4];
  assign b_y0 = b_y[3:0];

  assign a_y_ss = aes_square_scale_gf2p4_gf2p2(a_y1 ^ a_y0);
  assign b_y_ss = aes_square_scale_gf2p4_gf2p2(b_y1 ^ b_y0);

  aes_dom_dep_mul_gf2pn #(
    .NPower      ( 4    ),
    .PreDOMIndep ( 1'b0 )
  ) aes_dom_mul_y1_y0 (
    .clk_i  ( clk_i    ),
    .rst_ni ( rst_ni   ),
    .a_x    ( a_y1     ), // Share a of x
    .a_y    ( a_y0     ), // Share a of y
    .b_x    ( b_y1     ), // Share b of x
    .b_y    ( b_y0     ), // Share b of y
    .z_0    ( z_1[3:0] ), // Randomness for blinding
    .z_1    ( z_1[7:4] ), // Randomness for resharing
    .a_q    ( a_y1_y0  ), // Share a of q
    .b_q    ( b_y1_y0  )  // Share b of q
  );

  assign a_gamma = a_y_ss ^ a_y1_y0;
  assign b_gamma = b_y_ss ^ b_y1_y0;

  ////////////////////
  // Stages 2 and 3 //
  ////////////////////

  logic [3:0] a_theta, b_theta;

  // a_gamma is masked by b_gamma, a_gamma_inv is masked by b_gamma_inv.
  aes_dom_inverse_gf2p4 aes_dom_inverse_gf2p4 (
    .clk_i       ( clk_i   ),
    .rst_ni      ( rst_ni  ),
    .a_gamma     ( a_gamma ),
    .b_gamma     ( b_gamma ),
    .prd         ( z_23    ),
    .a_gamma_inv ( a_theta ),
    .b_gamma_inv ( b_theta )
  );

  /////////////
  // Stage 4 //
  /////////////
  // Formulas 18 and 19 in [2].

  aes_dom_indep_mul_gf2pn #(
    .NPower ( 4 )
  ) aes_dom_mul_theta_y1 (
    .clk_i  ( clk_i        ),
    .rst_ni ( rst_ni       ),
    .a_x    ( a_y1         ), // Share a of x
    .a_y    ( a_theta      ), // Share a of y
    .b_x    ( b_y1         ), // Share b of x
    .b_y    ( b_theta      ), // Share b of y
    .z_0    ( z_4_1        ), // Randomness for resharing
    .a_q    ( a_y_inv[3:0] ), // Share a of q
    .b_q    ( b_y_inv[3:0] )  // Share b of q
  );

  aes_dom_indep_mul_gf2pn #(
    .NPower ( 4 )
  ) aes_dom_mul_theta_y0 (
    .clk_i  ( clk_i        ),
    .rst_ni ( rst_ni       ),
    .a_x    ( a_theta      ), // Share a of x
    .a_y    ( a_y0         ), // Share a of y
    .b_x    ( b_theta      ), // Share b of x
    .b_y    ( b_y0         ), // Share b of y
    .z_0    ( z_4_0        ), // Randomness for resharing
    .a_q    ( a_y_inv[7:4] ), // Share a of q
    .b_q    ( b_y_inv[7:4] )  // Share b of q
  );

endmodule

module aes_sbox_dom (
  input  logic              clk_i,
  input  logic              rst_ni,
  input  logic              en_i,
  output logic              out_req_o,
  input  logic              out_ack_i,
  input  aes_pkg::ciph_op_e op_i,
  input  logic        [7:0] data_i, // masked, the actual input data is data_i ^ mask_i
  input  logic        [7:0] mask_i, // input mask
  input  logic       [27:0] prd_i,  // pseudo-random data for remasking
  output logic        [7:0] data_o, // masked, the actual output data is data_o ^ mask_o
  output logic        [7:0] mask_o  // output mask
);

  import aes_pkg::*;
  import aes_sbox_canright_pkg::*;

  logic [7:0] in_data_basis_x, out_data_basis_x;
  logic [7:0] in_mask_basis_x, out_mask_basis_x;

  // Convert data to normal basis X.
  assign in_data_basis_x = (op_i == CIPH_FWD) ? aes_mvm(data_i, A2X) :
                                                aes_mvm(data_i ^ 8'h63, S2X);

  // Convert mask to normal basis X.
  // The addition of constant 8'h63 prior to the affine transformation is skipped.
  assign in_mask_basis_x  = (op_i == CIPH_FWD) ? aes_mvm(mask_i, A2X) :
                                                 aes_mvm(mask_i, S2X);

  // Do the inversion in normal basis X.
  aes_dom_inverse_gf2p8 aes_dom_inverse_gf2p8 (
    .clk_i   ( clk_i            ),
    .rst_ni  ( rst_ni           ),
    .a_y     ( in_data_basis_x  ), // input
    .b_y     ( in_mask_basis_x  ), // input
    .prd     ( prd_i            ), // input
    .a_y_inv ( out_data_basis_x ), // output
    .b_y_inv ( out_mask_basis_x )  // output
  );

  // Convert data to basis S or A.
  assign data_o = (op_i == CIPH_FWD) ? (aes_mvm(out_data_basis_x, X2S) ^ 8'h63) :
                                       (aes_mvm(out_data_basis_x, X2A));

  // Convert mask to basis S or A.
  // The addition of constant 8'h63 following the affine transformation is skipped.
  assign mask_o = (op_i == CIPH_FWD) ? aes_mvm(out_mask_basis_x, X2S) :
                                       aes_mvm(out_mask_basis_x, X2A);

  // Counter register
  logic [2:0] count_d, count_q;
  assign count_d = (out_req_o && out_ack_i) ? '0               :
                   out_req_o                ? count_q          :
                   en_i                     ? count_q + 3'b001 : count_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : reg_count
    if (!rst_ni) begin
      count_q <= '0;
    end else begin
      count_q <= count_d;
    end
  end
  assign out_req_o = en_i & count_q == 3'b100;

endmodule
