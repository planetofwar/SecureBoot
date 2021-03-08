// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// FPV CSR read and write assertions auto-generated by `reggen` containing data structure
// Do Not Edit directly
// TODO: This automation currently only support register without HW write access
<%
  from reggen import (gen_fpv)
  from reggen.register import Register

  from topgen import lib

  lblock = block.name.lower()

  # This template shouldn't be instantiated if the device interface
  # doesn't actually have any registers.
  assert rb.flat_regs

%>\
<%def name="construct_classes(block)">\

`include "prim_assert.sv"
`ifdef UVM
  import uvm_pkg::*;
`endif

// Block: ${lblock}
module ${mod_base}_csr_assert_fpv import tlul_pkg::*; import ${lblock}_reg_pkg::*;
    import top_pkg::*;(
  input clk_i,
  input rst_ni,

  // tile link ports
  input tl_h2d_t h2d,
  input tl_d2h_t d2h,

  // reg and hw ports
  input ${mod_base}_reg2hw_t reg2hw,
  input ${mod_base}_hw2reg_t hw2reg
);

`ifndef VERILATOR
`ifndef SYNTHESIS

  typedef struct packed {
    logic [TL_DW-1:0] wr_data;
    logic [TL_AW-1:0] addr;
    logic             wr_pending;
    logic             rd_pending;
  } pend_item_t;

  bit disable_sva;

  // mask register to convert byte to bit
  logic [TL_DW-1:0] a_mask_bit;

  assign a_mask_bit[7:0]   = h2d.a_mask[0] ? '1 : '0;
  assign a_mask_bit[15:8]  = h2d.a_mask[1] ? '1 : '0;
  assign a_mask_bit[23:16] = h2d.a_mask[2] ? '1 : '0;
  assign a_mask_bit[31:24] = h2d.a_mask[3] ? '1 : '0;

<%
  addr_width = rb.get_addr_width()
  addr_msb  = addr_width - 1
  block_size = ((rb.flat_regs[-1].offset) >> 2) + 1
%>\
  // store internal expected values for HW ReadOnly registers
  logic [TL_DW-1:0] exp_vals[${block_size}];
  pend_item_t [2**TL_AIW-1:0] pend_trans;

  // normalized address only take the [${addr_msb}:2] address from the TLUL a_address
  bit [${addr_msb}:0] normalized_addr;
  assign normalized_addr = {h2d.a_address[${addr_msb}:2], 2'b0};

<%
  hro_regs_list = [r for r in rb.flat_regs if not r.hwaccess.allows_write()]
%>\
% if len(hro_regs_list) > 0:
  // for write HRO registers, store the write data into exp_vals
  always_ff @(negedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
       pend_trans <= '0;
  % for hro_reg in hro_regs_list:
       exp_vals[${hro_reg.offset >> 2}] <= ${hro_reg.resval};
  % endfor
    end else begin
      if (h2d.a_valid && d2h.a_ready) begin
        pend_trans[h2d.a_source].addr <= normalized_addr >> 2;
        if (h2d.a_opcode inside {PutFullData, PutPartialData}) begin
          pend_trans[h2d.a_source].wr_data <= h2d.a_data & a_mask_bit;
          pend_trans[h2d.a_source].wr_pending <= 1'b1;
        end else if (h2d.a_opcode == Get) begin
          pend_trans[h2d.a_source].rd_pending <= 1'b1;
        end
      end
      if (d2h.d_valid) begin
        if (pend_trans[d2h.d_source].wr_pending == 1) begin
          if (!d2h.d_error) begin
            exp_vals[pend_trans[d2h.d_source].addr] <= pend_trans[d2h.d_source].wr_data;
          end
          pend_trans[d2h.d_source].wr_pending <= 1'b0;
        end
        if (h2d.d_ready && pend_trans[d2h.d_source].rd_pending == 1) begin
          pend_trans[d2h.d_source].rd_pending <= 1'b0;
        end
      end
    end
  end

  // for read HRO registers, assert read out values by access policy and exp_vals
  % for hro_reg in hro_regs_list:
<%
    r_name       = hro_reg.name.lower()
    reg_addr     = hro_reg.offset
    reg_addr_hex = format(reg_addr, 'x')
    regwen       = hro_reg.regwen
    reg_mask     = 0

    for f in hro_reg.get_field_list():
      f_access = f.swaccess.key.lower()
      if f_access == "rw" and regwen == None:
        reg_mask = reg_mask | f.bits.bitmask()
%>\
    % if reg_mask != 0:
<%  reg_mask_hex = format(reg_mask, 'x') %>\
    `ASSERT(${r_name}_rd_A, d2h.d_valid && pend_trans[d2h.d_source].rd_pending &&
           pend_trans[d2h.d_source].addr == (${addr_width}'h${reg_addr_hex} >> 2) |->
           d2h.d_error ||
           (d2h.d_data & 'h${reg_mask_hex}) == (exp_vals[${reg_addr >> 2}] & 'h${reg_mask_hex}))

    % endif
  % endfor
% endif

  `ifdef UVM
    initial forever begin
      bit csr_assert_en;
      uvm_config_db#(bit)::wait_modified(null, "%m", "csr_assert_en");
      if (!uvm_config_db#(bit)::get(null, "%m", "csr_assert_en", csr_assert_en)) begin
        `uvm_fatal("csr_assert", "Can't find csr_assert_en")
      end
      disable_sva = !csr_assert_en;
    end
  `endif

</%def>\
${construct_classes(block)}
`endif
`endif
endmodule
