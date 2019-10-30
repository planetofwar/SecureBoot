// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// UVM Registers auto-generated by `reggen` containing data structure
// Do Not Edit directly

// Block: gpio
`ifndef GPIO_REG_BLOCK__SV
`define GPIO_REG_BLOCK__SV

// Forward declare all register/memory/block classes
typedef class gpio_reg_intr_state;
typedef class gpio_reg_intr_enable;
typedef class gpio_reg_intr_test;
typedef class gpio_reg_data_in;
typedef class gpio_reg_direct_out;
typedef class gpio_reg_masked_out_lower;
typedef class gpio_reg_masked_out_upper;
typedef class gpio_reg_direct_oe;
typedef class gpio_reg_masked_oe_lower;
typedef class gpio_reg_masked_oe_upper;
typedef class gpio_reg_intr_ctrl_en_rising;
typedef class gpio_reg_intr_ctrl_en_falling;
typedef class gpio_reg_intr_ctrl_en_lvlhigh;
typedef class gpio_reg_intr_ctrl_en_lvllow;
typedef class gpio_reg_ctrl_en_input_filter;
typedef class gpio_reg_block;

// Class: gpio_reg_intr_state
class gpio_reg_intr_state extends dv_base_reg;
  // fields
  rand dv_base_reg_field gpio;

  `uvm_object_utils(gpio_reg_intr_state)

  function new(string       name = "gpio_reg_intr_state",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    gpio = dv_base_reg_field::type_id::create("gpio");
    gpio.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("W1C"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_intr_state

// Class: gpio_reg_intr_enable
class gpio_reg_intr_enable extends dv_base_reg;
  // fields
  rand dv_base_reg_field gpio;

  `uvm_object_utils(gpio_reg_intr_enable)

  function new(string       name = "gpio_reg_intr_enable",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    gpio = dv_base_reg_field::type_id::create("gpio");
    gpio.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_intr_enable

// Class: gpio_reg_intr_test
class gpio_reg_intr_test extends dv_base_reg;
  // fields
  rand dv_base_reg_field gpio;

  `uvm_object_utils(gpio_reg_intr_test)

  function new(string       name = "gpio_reg_intr_test",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    gpio = dv_base_reg_field::type_id::create("gpio");
    gpio.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_intr_test

// Class: gpio_reg_data_in
class gpio_reg_data_in extends dv_base_reg;
  // fields
  rand dv_base_reg_field data_in;

  `uvm_object_utils(gpio_reg_data_in)

  function new(string       name = "gpio_reg_data_in",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    data_in = dv_base_reg_field::type_id::create("data_in");
    data_in.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_data_in

// Class: gpio_reg_direct_out
class gpio_reg_direct_out extends dv_base_reg;
  // fields
  rand dv_base_reg_field direct_out;

  `uvm_object_utils(gpio_reg_direct_out)

  function new(string       name = "gpio_reg_direct_out",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    direct_out = dv_base_reg_field::type_id::create("direct_out");
    direct_out.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_direct_out

// Class: gpio_reg_masked_out_lower
class gpio_reg_masked_out_lower extends dv_base_reg;
  // fields
  rand dv_base_reg_field data;
  rand dv_base_reg_field mask;

  `uvm_object_utils(gpio_reg_masked_out_lower)

  function new(string       name = "gpio_reg_masked_out_lower",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    data = dv_base_reg_field::type_id::create("data");
    data.configure(
      .parent(this),
      .size(16),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    mask = dv_base_reg_field::type_id::create("mask");
    mask.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_masked_out_lower

// Class: gpio_reg_masked_out_upper
class gpio_reg_masked_out_upper extends dv_base_reg;
  // fields
  rand dv_base_reg_field data;
  rand dv_base_reg_field mask;

  `uvm_object_utils(gpio_reg_masked_out_upper)

  function new(string       name = "gpio_reg_masked_out_upper",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    data = dv_base_reg_field::type_id::create("data");
    data.configure(
      .parent(this),
      .size(16),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    mask = dv_base_reg_field::type_id::create("mask");
    mask.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_masked_out_upper

// Class: gpio_reg_direct_oe
class gpio_reg_direct_oe extends dv_base_reg;
  // fields
  rand dv_base_reg_field direct_oe;

  `uvm_object_utils(gpio_reg_direct_oe)

  function new(string       name = "gpio_reg_direct_oe",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    direct_oe = dv_base_reg_field::type_id::create("direct_oe");
    direct_oe.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_direct_oe

// Class: gpio_reg_masked_oe_lower
class gpio_reg_masked_oe_lower extends dv_base_reg;
  // fields
  rand dv_base_reg_field data;
  rand dv_base_reg_field mask;

  `uvm_object_utils(gpio_reg_masked_oe_lower)

  function new(string       name = "gpio_reg_masked_oe_lower",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    data = dv_base_reg_field::type_id::create("data");
    data.configure(
      .parent(this),
      .size(16),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    mask = dv_base_reg_field::type_id::create("mask");
    mask.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_masked_oe_lower

// Class: gpio_reg_masked_oe_upper
class gpio_reg_masked_oe_upper extends dv_base_reg;
  // fields
  rand dv_base_reg_field data;
  rand dv_base_reg_field mask;

  `uvm_object_utils(gpio_reg_masked_oe_upper)

  function new(string       name = "gpio_reg_masked_oe_upper",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    data = dv_base_reg_field::type_id::create("data");
    data.configure(
      .parent(this),
      .size(16),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    mask = dv_base_reg_field::type_id::create("mask");
    mask.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_masked_oe_upper

// Class: gpio_reg_intr_ctrl_en_rising
class gpio_reg_intr_ctrl_en_rising extends dv_base_reg;
  // fields
  rand dv_base_reg_field intr_ctrl_en_rising;

  `uvm_object_utils(gpio_reg_intr_ctrl_en_rising)

  function new(string       name = "gpio_reg_intr_ctrl_en_rising",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    intr_ctrl_en_rising = dv_base_reg_field::type_id::create("intr_ctrl_en_rising");
    intr_ctrl_en_rising.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_intr_ctrl_en_rising

// Class: gpio_reg_intr_ctrl_en_falling
class gpio_reg_intr_ctrl_en_falling extends dv_base_reg;
  // fields
  rand dv_base_reg_field intr_ctrl_en_falling;

  `uvm_object_utils(gpio_reg_intr_ctrl_en_falling)

  function new(string       name = "gpio_reg_intr_ctrl_en_falling",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    intr_ctrl_en_falling = dv_base_reg_field::type_id::create("intr_ctrl_en_falling");
    intr_ctrl_en_falling.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_intr_ctrl_en_falling

// Class: gpio_reg_intr_ctrl_en_lvlhigh
class gpio_reg_intr_ctrl_en_lvlhigh extends dv_base_reg;
  // fields
  rand dv_base_reg_field intr_ctrl_en_lvlhigh;

  `uvm_object_utils(gpio_reg_intr_ctrl_en_lvlhigh)

  function new(string       name = "gpio_reg_intr_ctrl_en_lvlhigh",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    intr_ctrl_en_lvlhigh = dv_base_reg_field::type_id::create("intr_ctrl_en_lvlhigh");
    intr_ctrl_en_lvlhigh.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_intr_ctrl_en_lvlhigh

// Class: gpio_reg_intr_ctrl_en_lvllow
class gpio_reg_intr_ctrl_en_lvllow extends dv_base_reg;
  // fields
  rand dv_base_reg_field intr_ctrl_en_lvllow;

  `uvm_object_utils(gpio_reg_intr_ctrl_en_lvllow)

  function new(string       name = "gpio_reg_intr_ctrl_en_lvllow",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    intr_ctrl_en_lvllow = dv_base_reg_field::type_id::create("intr_ctrl_en_lvllow");
    intr_ctrl_en_lvllow.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_intr_ctrl_en_lvllow

// Class: gpio_reg_ctrl_en_input_filter
class gpio_reg_ctrl_en_input_filter extends dv_base_reg;
  // fields
  rand dv_base_reg_field ctrl_en_input_filter;

  `uvm_object_utils(gpio_reg_ctrl_en_input_filter)

  function new(string       name = "gpio_reg_ctrl_en_input_filter",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    ctrl_en_input_filter = dv_base_reg_field::type_id::create("ctrl_en_input_filter");
    ctrl_en_input_filter.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : gpio_reg_ctrl_en_input_filter

// Class: gpio_reg_block
class gpio_reg_block extends dv_base_reg_block;
  // registers
  rand gpio_reg_intr_state intr_state;
  rand gpio_reg_intr_enable intr_enable;
  rand gpio_reg_intr_test intr_test;
  rand gpio_reg_data_in data_in;
  rand gpio_reg_direct_out direct_out;
  rand gpio_reg_masked_out_lower masked_out_lower;
  rand gpio_reg_masked_out_upper masked_out_upper;
  rand gpio_reg_direct_oe direct_oe;
  rand gpio_reg_masked_oe_lower masked_oe_lower;
  rand gpio_reg_masked_oe_upper masked_oe_upper;
  rand gpio_reg_intr_ctrl_en_rising intr_ctrl_en_rising;
  rand gpio_reg_intr_ctrl_en_falling intr_ctrl_en_falling;
  rand gpio_reg_intr_ctrl_en_lvlhigh intr_ctrl_en_lvlhigh;
  rand gpio_reg_intr_ctrl_en_lvllow intr_ctrl_en_lvllow;
  rand gpio_reg_ctrl_en_input_filter ctrl_en_input_filter;

  `uvm_object_utils(gpio_reg_block)

  function new(string name = "gpio_reg_block",
               int    has_coverage = UVM_NO_COVERAGE);
    super.new(name, has_coverage);
  endfunction : new

  virtual function void build(uvm_reg_addr_t base_addr);
    // create default map
    this.default_map = create_map(.name("default_map"),
                                  .base_addr(base_addr),
                                  .n_bytes(4),
                                  .endian(UVM_LITTLE_ENDIAN));

    // create registers
    intr_state = gpio_reg_intr_state::type_id::create("intr_state");
    intr_state.configure(.blk_parent(this));
    intr_state.build();
    default_map.add_reg(.rg(intr_state),
                        .offset(32'h0),
                        .rights("RW"));
    intr_enable = gpio_reg_intr_enable::type_id::create("intr_enable");
    intr_enable.configure(.blk_parent(this));
    intr_enable.build();
    default_map.add_reg(.rg(intr_enable),
                        .offset(32'h4),
                        .rights("RW"));
    intr_test = gpio_reg_intr_test::type_id::create("intr_test");
    intr_test.configure(.blk_parent(this));
    intr_test.build();
    default_map.add_reg(.rg(intr_test),
                        .offset(32'h8),
                        .rights("WO"));
    data_in = gpio_reg_data_in::type_id::create("data_in");
    data_in.configure(.blk_parent(this));
    data_in.build();
    default_map.add_reg(.rg(data_in),
                        .offset(32'hc),
                        .rights("RO"));
    direct_out = gpio_reg_direct_out::type_id::create("direct_out");
    direct_out.configure(.blk_parent(this));
    direct_out.build();
    default_map.add_reg(.rg(direct_out),
                        .offset(32'h10),
                        .rights("RW"));
    masked_out_lower = gpio_reg_masked_out_lower::type_id::create("masked_out_lower");
    masked_out_lower.configure(.blk_parent(this));
    masked_out_lower.build();
    default_map.add_reg(.rg(masked_out_lower),
                        .offset(32'h14),
                        .rights("RW"));
    masked_out_upper = gpio_reg_masked_out_upper::type_id::create("masked_out_upper");
    masked_out_upper.configure(.blk_parent(this));
    masked_out_upper.build();
    default_map.add_reg(.rg(masked_out_upper),
                        .offset(32'h18),
                        .rights("RW"));
    direct_oe = gpio_reg_direct_oe::type_id::create("direct_oe");
    direct_oe.configure(.blk_parent(this));
    direct_oe.build();
    default_map.add_reg(.rg(direct_oe),
                        .offset(32'h1c),
                        .rights("RW"));
    masked_oe_lower = gpio_reg_masked_oe_lower::type_id::create("masked_oe_lower");
    masked_oe_lower.configure(.blk_parent(this));
    masked_oe_lower.build();
    default_map.add_reg(.rg(masked_oe_lower),
                        .offset(32'h20),
                        .rights("RW"));
    masked_oe_upper = gpio_reg_masked_oe_upper::type_id::create("masked_oe_upper");
    masked_oe_upper.configure(.blk_parent(this));
    masked_oe_upper.build();
    default_map.add_reg(.rg(masked_oe_upper),
                        .offset(32'h24),
                        .rights("RW"));
    intr_ctrl_en_rising = gpio_reg_intr_ctrl_en_rising::type_id::create("intr_ctrl_en_rising");
    intr_ctrl_en_rising.configure(.blk_parent(this));
    intr_ctrl_en_rising.build();
    default_map.add_reg(.rg(intr_ctrl_en_rising),
                        .offset(32'h28),
                        .rights("RW"));
    intr_ctrl_en_falling = gpio_reg_intr_ctrl_en_falling::type_id::create("intr_ctrl_en_falling");
    intr_ctrl_en_falling.configure(.blk_parent(this));
    intr_ctrl_en_falling.build();
    default_map.add_reg(.rg(intr_ctrl_en_falling),
                        .offset(32'h2c),
                        .rights("RW"));
    intr_ctrl_en_lvlhigh = gpio_reg_intr_ctrl_en_lvlhigh::type_id::create("intr_ctrl_en_lvlhigh");
    intr_ctrl_en_lvlhigh.configure(.blk_parent(this));
    intr_ctrl_en_lvlhigh.build();
    default_map.add_reg(.rg(intr_ctrl_en_lvlhigh),
                        .offset(32'h30),
                        .rights("RW"));
    intr_ctrl_en_lvllow = gpio_reg_intr_ctrl_en_lvllow::type_id::create("intr_ctrl_en_lvllow");
    intr_ctrl_en_lvllow.configure(.blk_parent(this));
    intr_ctrl_en_lvllow.build();
    default_map.add_reg(.rg(intr_ctrl_en_lvllow),
                        .offset(32'h34),
                        .rights("RW"));
    ctrl_en_input_filter = gpio_reg_ctrl_en_input_filter::type_id::create("ctrl_en_input_filter");
    ctrl_en_input_filter.configure(.blk_parent(this));
    ctrl_en_input_filter.build();
    default_map.add_reg(.rg(ctrl_en_input_filter),
                        .offset(32'h38),
                        .rights("RW"));
  endfunction : build

endclass : gpio_reg_block

`endif
