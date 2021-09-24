// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/boot_rom/bootstrap.h"

#include <stddef.h>

#include "sw/device/boot_rom/spiflash_frame.h"
#include "sw/device/lib/arch/device.h"
#include "sw/device/lib/base/memory.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_gpio.h"
#include "sw/device/lib/dif/dif_hmac.h"
#include "sw/device/lib/dif/dif_spi_device.h"
#include "sw/device/lib/flash_ctrl.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/check.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

#define GPIO_BOOTSTRAP_BIT_MASK 0x00020000u

/**
 * Check if flash is blank to determine if bootstrap is needed.
 *
 * TODO: Update this to check bootstrap pin instead in Verilator.
 */
static bool bootstrap_requested(void) {
  // The following flash empty-sniff-check is done this way due to the lack of
  // clear eflash reset in SIM environments.
  if (kDeviceType == kDeviceSimVerilator) {
    mmio_region_t flash_region = mmio_region_from_addr(FLASH_MEM_BASE_ADDR);
    uint32_t value = mmio_region_read32(flash_region, 0x0);
    return value == 0 || value == UINT32_MAX;
  }

  // Initialize GPIO device.
  dif_gpio_t gpio;
  dif_gpio_params_t gpio_params = {
      .base_addr = mmio_region_from_addr(TOP_EARLGREY_GPIO_BASE_ADDR)};
  CHECK(dif_gpio_init(gpio_params, &gpio) == kDifGpioOk);

  dif_gpio_state_t gpio_in;
  CHECK(dif_gpio_read_all(&gpio, &gpio_in) == kDifGpioOk);
  return (gpio_in & GPIO_BOOTSTRAP_BIT_MASK) != 0;
}

/**
 * Erase all flash, and verify blank.
 */
static int erase_flash(void) {
  if (flash_bank_erase(FLASH_BANK_0) != 0) {
    return E_BS_ERASE;
  }
  if (flash_bank_erase(FLASH_BANK_1) != 0) {
    return E_BS_ERASE;
  }
  if (flash_check_empty() == 0) {
    return E_BS_NOTEMPTY;
  }

  return 0;
}

/**
 * Computes the SHA256 of the given data.
 */
static void compute_sha256(const dif_hmac_t *hmac, const void *data, size_t len,
                           dif_hmac_digest_t *digest) {
  const dif_hmac_transaction_t config = {
      .digest_endianness = kDifHmacEndiannessLittle,
      .message_endianness = kDifHmacEndiannessLittle,
  };
  CHECK(dif_hmac_mode_sha256_start(hmac, config) == kDifOk,
        "Error on hmac start.");
  const char *data8 = (const char *)data;
  size_t data_left = len;
  while (data_left > 0) {
    size_t bytes_sent;
    dif_result_t result =
        dif_hmac_fifo_push(hmac, data8, data_left, &bytes_sent);
    if (result == kDifOk) {
      break;
    }
    CHECK(result == kDifIpFifoFull, "Error while pushing to FIFO.");
    data8 += bytes_sent;
    data_left -= bytes_sent;
  }

  CHECK(dif_hmac_process(hmac) == kDifOk, "Error processing digest.");
  dif_result_t digest_result = kDifIpBusy;
  while (digest_result == kDifIpBusy) {
    digest_result = dif_hmac_finish(hmac, digest);
  }
  CHECK(digest_result == kDifOk, "Error reading the digest.");
}

/**
 * Compares the SHA256 hash of the recieved data with the recieved hash.
 *
 * Returns true if the hashes match.
 */
static bool check_frame_hash(const dif_hmac_t *hmac,
                             const spiflash_frame_t *frame) {
  dif_hmac_digest_t digest;
  size_t digest_len = sizeof(digest.digest);

  uint8_t *data = ((uint8_t *)frame) + digest_len;
  compute_sha256(hmac, data, sizeof(spiflash_frame_t) - digest_len, &digest);

  return memcmp(digest.digest, frame->header.hash.digest, digest_len) == 0;
}

/**
 * Load spiflash frames from the SPI interface.
 *
 * This function checks that the sequence numbers and hashes of the frames are
 * correct before programming them into flash.
 */
static int bootstrap_flash(dif_spi_device_t *spi, dif_hmac_t *hmac) {
  dif_hmac_digest_t ack = {0};
  uint32_t expected_frame_num = 0;
  while (true) {
    size_t bytes_available;
    CHECK(dif_spi_device_rx_pending(spi, &bytes_available) == kDifSpiDeviceOk,
          "Failed to check pending bytes.");
    if (bytes_available >= sizeof(spiflash_frame_t)) {
      spiflash_frame_t frame;
      CHECK(dif_spi_device_recv(spi, &frame, sizeof(spiflash_frame_t),
                                /*bytes_received=*/NULL) == kDifSpiDeviceOk,
            "Failed to recieve bytes from SPI.");

      uint32_t frame_num = SPIFLASH_FRAME_NUM(frame.header.frame_num);
      LOG_INFO("Processing frame #%d, expecting #%d", frame_num,
               expected_frame_num);

      if (frame_num == expected_frame_num) {
        if (!check_frame_hash(hmac, &frame)) {
          LOG_ERROR("Detected hash mismatch on frame #%d", frame_num);
          CHECK(dif_spi_device_send(spi, (uint8_t *)&ack.digest,
                                    sizeof(ack.digest),
                                    /*bytes_received=*/NULL) == kDifSpiDeviceOk,
                "Failed to send bytes to SPI.");
          continue;
        }

        compute_sha256(hmac, &frame, sizeof(spiflash_frame_t), &ack);
        CHECK(
            dif_spi_device_send(spi, (uint8_t *)&ack.digest, sizeof(ack.digest),
                                /*bytes_received=*/NULL) == kDifSpiDeviceOk,
            "Failed to send bytes to SPI.");

        if (expected_frame_num == 0) {
          flash_default_region_access(/*rd_en=*/true, /*prog_en=*/true,
                                      /*erase_en=*/true);
          int flash_error = erase_flash();
          if (flash_error != 0) {
            return flash_error;
          }
          LOG_INFO("Flash erase successful");
        }

        if (flash_write(frame.header.flash_offset, kDataPartition, frame.data,
                        SPIFLASH_FRAME_DATA_WORDS) != 0) {
          return E_BS_WRITE;
        }

        ++expected_frame_num;
        if (SPIFLASH_FRAME_IS_EOF(frame.header.frame_num)) {
          LOG_INFO("Bootstrap: DONE!");
          return 0;
        }
      } else {
        // Send previous ack if unable to verify current frame.
        CHECK(
            dif_spi_device_send(spi, (uint8_t *)&ack.digest, sizeof(ack.digest),
                                /*bytes_received=*/NULL) == kDifSpiDeviceOk,
            "Failed to send bytes to SPI.");
      }
    }
  }
}

int bootstrap(void) {
  if (!bootstrap_requested()) {
    return 0;
  }

  // SPI device is only initialized in bootstrap mode.
  LOG_INFO("Bootstrap requested, initialising HW...");
  flash_init_block();

  dif_spi_device_t spi;
  CHECK(dif_spi_device_init(
            (dif_spi_device_params_t){
                .base_addr =
                    mmio_region_from_addr(TOP_EARLGREY_SPI_DEVICE_BASE_ADDR),
            },
            &spi) == kDifSpiDeviceOk,
        "Failed to initialize SPI.");
  CHECK(
      dif_spi_device_configure(&spi,
                               (dif_spi_device_config_t){
                                   .clock_polarity = kDifSpiDeviceEdgePositive,
                                   .data_phase = kDifSpiDeviceEdgeNegative,
                                   .tx_order = kDifSpiDeviceBitOrderMsbToLsb,
                                   .rx_order = kDifSpiDeviceBitOrderMsbToLsb,
                                   .rx_fifo_timeout = 63,
                                   .rx_fifo_len = kDifSpiDeviceBufferLen / 2,
                                   .tx_fifo_len = kDifSpiDeviceBufferLen / 2,
                               }) == kDifSpiDeviceOk,
      "Failed to configure SPI.");

  dif_hmac_t hmac;
  CHECK(dif_hmac_init(mmio_region_from_addr(TOP_EARLGREY_HMAC_BASE_ADDR),
                      &hmac) == kDifOk,
        "Failed to configure HMAC.");

  LOG_INFO("HW initialisation completed, waiting for SPI input...");
  int error = bootstrap_flash(&spi, &hmac);
  if (error != 0) {
    error |= erase_flash();
    LOG_ERROR("Bootstrap error: 0x%x", error);
  }

  // Always make sure to revert flash_ctrl access to default settings.
  // bootstrap_flash enables access to flash to perform update.
  flash_default_region_access(/*rd_en=*/false, /*prog_en=*/false,
                              /*erase_en=*/false);
  return error;
}
