// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: csrng app cmd request state machine module
//
//  - handles all app cmd requests from all requesting interfaces

module csrng_main_sm import csrng_pkg::*; (
  input logic                clk_i,
  input logic                rst_ni,

  input logic                enable_i,
  input logic                acmd_avail_i,
  output logic               acmd_accept_o,
  output logic               acmd_hdr_capt_o,
  input logic [2:0]          acmd_i,
  input logic                acmd_eop_i,
  input logic                ctr_drbg_cmd_req_rdy_i,
  input logic                flag0_i,
  output logic               cmd_entropy_req_o,
  input logic                cmd_entropy_avail_i,
  output logic               instant_req_o,
  output logic               reseed_req_o,
  output logic               generate_req_o,
  output logic               update_req_o,
  output logic               uninstant_req_o,
  input logic                cmd_complete_i,
  output logic               main_sm_err_o
);
// Encoding generated with:
// $ ./util/design/sparse-fsm-encode.py -d 3 -m 12 -n 8 \
//      -s 2565810189 --language=sv
//
// Hamming distance histogram:
//
//  0: --
//  1: --
//  2: --
//  3: |||||||||||||||| (30.30%)
//  4: |||||||||||||||||||| (37.88%)
//  5: ||||||||| (18.18%)
//  6: |||| (9.09%)
//  7: || (4.55%)
//  8: --
//
// Minimum Hamming distance: 3
// Maximum Hamming distance: 7
// Minimum Hamming weight: 2
// Maximum Hamming weight: 6
//

  localparam int StateWidth = 8;
  typedef    enum logic [StateWidth-1:0] {
    Idle         = 8'b01010011, // idle
    ParseCmd     = 8'b01001100, // parse the cmd
    InstantPrep  = 8'b00101010, // instantiate prep
    InstantReq   = 8'b11011101, // instantiate request (takes adata or entropy)
    ReseedPrep   = 8'b10110111, // reseed prep
    ReseedReq    = 8'b11001011, // reseed request (takes adata and entropy and Key,V,RC)
    GenerateReq  = 8'b10011110, // generate request (takes adata? and Key,V,RC)
    UpdatePrep   = 8'b10101001, // update prep
    UpdateReq    = 8'b00011001, // update request (takes adata and Key,V,RC)
    UninstantReq = 8'b00000111, // uninstantiate request (no input)
    CmdCompWait  = 8'b00010100, // wait for command to complete
    Error        = 8'b11110001  // error state, results in fatal alert
  } state_e;

  state_e state_d, state_q;

  logic [StateWidth-1:0] state_raw_q;

  // This primitive is used to place a size-only constraint on the
  // flops in order to prevent FSM state encoding optimizations.
  prim_flop #(
    .Width(StateWidth),
    .ResetValue(StateWidth'(Idle))
  ) u_state_regs (
    .clk_i,
    .rst_ni,
    .d_i ( state_d ),
    .q_o ( state_raw_q )
  );

  assign state_q = state_e'(state_raw_q);

  always_comb begin
    state_d = state_q;
    acmd_accept_o = 1'b0;
    acmd_hdr_capt_o = 1'b0;
    cmd_entropy_req_o = 1'b0;
    instant_req_o = 1'b0;
    reseed_req_o = 1'b0;
    generate_req_o = 1'b0;
    update_req_o = 1'b0;
    uninstant_req_o = 1'b0;
    main_sm_err_o = 1'b0;
    unique case (state_q)
      Idle: begin
        if (enable_i) begin
          if (ctr_drbg_cmd_req_rdy_i) begin
            // signal the arbiter to grant this request
            if (acmd_avail_i) begin
              acmd_accept_o = 1'b1;
              state_d = ParseCmd;
            end
          end
        end
      end
      ParseCmd: begin
        if (enable_i) begin
          if (ctr_drbg_cmd_req_rdy_i) begin
            if (acmd_i == INS) begin
              if (acmd_eop_i) begin
                acmd_hdr_capt_o = 1'b1;
                state_d = InstantPrep;
              end
            end else if (acmd_i == RES) begin
              if (acmd_eop_i) begin
                acmd_hdr_capt_o = 1'b1;
                state_d = ReseedPrep;
              end
            end else if (acmd_i == GEN) begin
              acmd_hdr_capt_o = 1'b1;
              state_d = GenerateReq;
            end else if (acmd_i == UPD) begin
              if (acmd_eop_i) begin
                acmd_hdr_capt_o = 1'b1;
                state_d = UpdatePrep;
              end
            end else if (acmd_i == UNI) begin
              acmd_hdr_capt_o = 1'b1;
              state_d = UninstantReq;
            end
          end
        end
      end
      InstantPrep: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          if (flag0_i) begin
            // assumes all adata is present now
            state_d = InstantReq;
          end else begin
          // delay one clock to fix timing issue
            cmd_entropy_req_o = 1'b1;
            if (cmd_entropy_avail_i) begin
              state_d = InstantReq;
            end
          end
        end
      end
      InstantReq: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          instant_req_o = 1'b1;
          state_d = CmdCompWait;
        end
      end
      ReseedPrep: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          cmd_entropy_req_o = 1'b1;
          // assumes all adata is present now
          if (cmd_entropy_avail_i) begin
            state_d = ReseedReq;
          end
        end
      end
      ReseedReq: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          reseed_req_o = 1'b1;
          state_d = CmdCompWait;
        end
      end
      GenerateReq: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          generate_req_o = 1'b1;
          state_d = CmdCompWait;
        end
      end
      UpdatePrep: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          // assumes all adata is present now
          state_d = UpdateReq;
        end
      end
      UpdateReq: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          update_req_o = 1'b1;
          state_d = CmdCompWait;
        end
      end
      UninstantReq: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          uninstant_req_o = 1'b1;
          state_d = CmdCompWait;
        end
      end
      CmdCompWait: begin
        if (!enable_i) begin
          state_d = Idle;
        end else begin
          if (cmd_complete_i) begin
            state_d = Idle;
          end
        end
      end
      Error: begin
        main_sm_err_o = 1'b1;
      end
      default: state_d = Error;
    endcase
  end

endmodule
