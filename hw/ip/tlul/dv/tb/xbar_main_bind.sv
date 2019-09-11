// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module xbar_main_bind;

  // TODO: this file should be generated like xbar_main

  // host interfaces
  bind xbar_main tlul_assert tlul_assert_host_corei (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_corei_i),
    .d2h    (tl_corei_o)
  );
  bind xbar_main tlul_assert tlul_assert_host_cored (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_cored_i),
    .d2h    (tl_cored_o)
  );
  bind xbar_main tlul_assert tlul_assert_host_sba (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_dm_sba_i),
    .d2h    (tl_dm_sba_o)
  );

  // device interfaces
  bind xbar_main tlul_assert tlul_assert_device_rom (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_rom_o),
    .d2h    (tl_rom_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_debug (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_debug_mem_o),
    .d2h    (tl_debug_mem_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_ram (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_ram_main_o),
    .d2h    (tl_ram_main_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_eflash (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_eflash_o),
    .d2h    (tl_eflash_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_uart (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_uart_o),
    .d2h    (tl_uart_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_gpio (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_gpio_o),
    .d2h    (tl_gpio_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_spi_device (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_spi_device_o),
    .d2h    (tl_spi_device_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_flash (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_flash_ctrl_o),
    .d2h    (tl_flash_ctrl_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_rv_timer (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_rv_timer_o),
    .d2h    (tl_rv_timer_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_hmac (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_hmac_o),
    .d2h    (tl_hmac_i)
  );
  bind xbar_main tlul_assert tlul_assert_device_plic (
    .clk_i  (clk_main_i),
    .rst_ni (rst_main_ni),
    .h2d    (tl_rv_plic_o),
    .d2h    (tl_rv_plic_i)
  );

endmodule
