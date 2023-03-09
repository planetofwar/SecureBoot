// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module boot_identifier
(
  input  clk_i,
  input  rst_ni,
  input  logic secure_boot_init_i,
  output logic secure_boot_o
);
localparam
  inactive = 1'b0,
  active = 1'b1;

logic state_reg, next_reg;
logic secure_boot_fin;

// fsm flipflop
always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    state_reg <= inactive;
  end else begin
    state_reg <= next_reg;
  end
end

// state transitions 
always_comb begin
  next_reg = state_reg; // defualt is staying in the same state
  case(state_reg)
    inactive : begin
      if(secure_boot_init_i) begin
        next_reg = active;
      end
      else begin
        next_reg = inactive;
      end
    end
    active : begin
      if(secure_boot_fin) begin
        next_reg = inactive;
      end
      else begin
        next_reg = active;
      end
    end
  endcase 
end

// output logic
always_comb begin
  case(state_reg)
    active : secure_boot_o = 1'b1;
    inactive : secure_boot_o = 1'b0;
  endcase
end

// secure boot fin logic
//assign secure_boot_fin = memory[map_addr];
assign secure_boot_fin = 0;
endmodule
