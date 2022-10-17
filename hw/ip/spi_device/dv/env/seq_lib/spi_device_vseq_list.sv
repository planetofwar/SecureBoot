// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "spi_device_base_vseq.sv"
`include "spi_device_smoke_vseq.sv"
`include "spi_device_common_vseq.sv"
`include "spi_device_txrx_vseq.sv"
`include "spi_device_fifo_full_vseq.sv"
`include "spi_device_fifo_underflow_overflow_vseq.sv"
`include "spi_device_extreme_fifo_size_vseq.sv"
`include "spi_device_dummy_item_extra_dly_vseq.sv"
`include "spi_device_intr_vseq.sv"
`include "spi_device_perf_vseq.sv"
`include "spi_device_csb_read_vseq.sv"
`include "spi_device_rx_timeout_vseq.sv"
`include "spi_device_byte_transfer_vseq.sv"
`include "spi_device_tpm_base_vseq.sv"
`include "spi_device_tpm_read_hw_reg_vseq.sv"
`include "spi_device_tpm_all_vseq.sv"
`include "spi_device_bit_transfer_vseq.sv"
`include "spi_device_tx_async_fifo_reset_vseq.sv"
`include "spi_device_rx_async_fifo_reset_vseq.sv"
`include "spi_device_abort_vseq.sv"
`include "spi_device_tpm_sts_read_vseq.sv"
`include "spi_device_tpm_rw_vseq.sv"
`include "spi_device_pass_base_vseq.sv"
`include "spi_device_pass_cmd_filtering_vseq.sv"
`include "spi_device_pass_addr_payload_swap_vseq.sv"
`include "spi_device_intercept_vseq.sv"
`include "spi_device_mailbox_vseq.sv"
`include "spi_device_upload_vseq.sv"
`include "spi_device_cfg_cmd_vseq.sv"
`include "spi_device_flash_mode_vseq.sv"
`include "spi_device_read_buffer_direct_vseq.sv"
`include "spi_device_flash_all_vseq.sv"
`include "spi_device_flash_and_tpm_vseq.sv"
`include "spi_device_stress_all_vseq.sv"
