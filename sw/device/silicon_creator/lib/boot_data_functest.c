// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/flash_ctrl.h"
#include "sw/device/lib/runtime/ibex.h"
#include "sw/device/lib/testing/check.h"
#include "sw/device/silicon_creator/lib/boot_data.h"
#include "sw/device/silicon_creator/lib/test_main.h"

#include "flash_ctrl_regs.h"  // Generated.
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

const test_config_t kTestConfig;

/**
 * Base addresses of flash info pages used for storing boot data.
 */
static const uint32_t kPageBaseAddrs[2] = {
    kBootDataPage0Base,
    kBootDataPage1Base,
};

/**
 * Boot data entry used in tests.
 */
boot_data_t kTestBootData = (boot_data_t){
    .digest = {{0x2f2a8ad9, 0x9076b353, 0x7f6a8f14, 0x2bc04b19, 0x6d9ee1a3,
                0x50d73250, 0x3070651e, 0x47fdeb51}},
    .identifier = kBootDataIdentifier,
    .counter = 6,
    .min_security_version_rom_ext = 0,
};

/**
 * Unlocks boot data info pages.
 */
static void unlock_boot_data_pages(void) {
  for (size_t i = 0; i < ARRAYSIZE(kPageBaseAddrs); ++i) {
    const uint32_t page_id =
        ((kPageBaseAddrs[i] - TOP_EARLGREY_FLASH_CTRL_MEM_BASE_ADDR) %
         FLASH_CTRL_PARAM_BYTES_PER_BANK) /
        FLASH_CTRL_PARAM_BYTES_PER_PAGE;
    mp_region_t info_region = {.num = page_id,
                               .base = kPageBaseAddrs[i],
                               .size = 0,  // unused for info pages.
                               .part = kInfoPartition,
                               .rd_en = true,
                               .prog_en = true,
                               .erase_en = true,
                               .scramble_en = false};
    flash_cfg_region(&info_region);
  }
}

/**
 * Erases boot data info pages.
 */
static void erase_boot_data_pages(void) {
  for (size_t i = 0; i < ARRAYSIZE(kPageBaseAddrs); ++i) {
    CHECK(flash_page_erase(kPageBaseAddrs[i], kInfoPartition) == 0,
          "Flash page erase failed.");
  }
}

/**
 * Writes a boot data entry at the given page and index.
 *
 * This function also checks that the entry was written correctly by reading it
 * back from the flash.
 *
 * @param page_base Page base address in bytes.
 * @param index Index of the entry to write in the given page.
 * @param boot_data A boot data entry.
 */
static void write_boot_data(uint32_t page_base, size_t index,
                            const boot_data_t *boot_data) {
  const uint32_t addr = page_base + index * sizeof(boot_data_t);
  uint32_t buf[kBootDataNumWords];
  memcpy(buf, boot_data, sizeof(boot_data_t));
  CHECK(flash_write(addr, kInfoPartition, buf, kBootDataNumWords) == 0,
        "Flash write failed.");

  CHECK(flash_read(addr, kInfoPartition, kBootDataNumWords, buf) == 0,
        "Flash read failed.");
  CHECK(memcmp(buf, boot_data, sizeof(boot_data_t)) == 0,
        "Flash write failed.");
}

/**
 * Reads the boot data entry at the given page and index.
 *
 * @param page_base Page base address in bytes.
 * @param index Index of the entry to read in the given page.
 * @param boot_data A boot data entry.
 */
static void read_boot_data(uint32_t page_base, size_t index,
                           boot_data_t *boot_data) {
  const uint32_t addr = page_base + index * sizeof(boot_data_t);
  uint32_t buf[kBootDataNumWords];
  CHECK(flash_read(addr, kInfoPartition, kBootDataNumWords, buf) == 0,
        "Flash read failed.");
  memcpy(boot_data, buf, sizeof(boot_data_t));
}

/**
 * Writes the given number of invalidated boot data entries to a page.
 *
 * This function invalidates the given boot data entry by setting its
 * `identifier` to `kBootDataInvalidatedIdentifier` before writing it to the
 * flash.
 *
 * @param page_base Page base address in bytes.
 * @param num_entries Number of entries to write.
 * @param boot_data A boot data entry.
 */
static void fill_with_invalidated_boot_data(uint32_t page_base,
                                            size_t num_entries,
                                            const boot_data_t *boot_data) {
  boot_data_t invalidated = *boot_data;
  invalidated.identifier = kBootDataInvalidatedIdentifier;
  for (size_t i = 0; i < num_entries; ++i) {
    write_boot_data(page_base, i, &invalidated);
  }
}

/**
 * Compares two `boot_data_t` structs.
 *
 * @param lhs LHS of the comparison.
 * @param rhs RHS of the comparison.
 * @return The result of the operation.
 */
static rom_error_t compare_boot_data(const boot_data_t *lhs,
                                     const boot_data_t *rhs) {
  if (memcmp(lhs, rhs, sizeof(boot_data_t)) != 0) {
    return kErrorUnknown;
  }
  return kErrorOk;
}

/**
 * Checks whether a boot data entry is valid.
 *
 * This function checks the `identifier`, `digest`, and counter fields of a boot
 * data entry.
 *
 * @param boot_data A boot data entry.
 * @return The result of the operation.
 */
static rom_error_t check_boot_data(const boot_data_t *boot_data,
                                   uint32_t counter) {
  enum {
    kDigestRegionOffset = sizeof(boot_data->digest),
    kDigestRegionSize = sizeof(boot_data_t) - sizeof(boot_data->digest),
  };

  if (boot_data->identifier != kBootDataIdentifier) {
    return kErrorUnknown;
  }

  if (boot_data->counter != counter) {
    return kErrorUnknown;
  }

  hmac_digest_t act_digest;
  hmac_sha256_init();
  RETURN_IF_ERROR(hmac_sha256_update(
      (const char *)boot_data + kDigestRegionOffset, kDigestRegionSize));
  RETURN_IF_ERROR(hmac_sha256_final(&act_digest));
  if (memcmp(&act_digest, &boot_data->digest, sizeof(act_digest)) != 0) {
    return kErrorUnknown;
  }
  return kErrorOk;
}

rom_error_t check_test_data_test(void) {
  RETURN_IF_ERROR(check_boot_data(&kTestBootData, kTestBootData.counter));
  return kErrorOk;
}

rom_error_t read_empty_default_allowed_test(void) {
  erase_boot_data_pages();

  boot_data_t boot_data;
  RETURN_IF_ERROR(boot_data_read(kLcStateTestUnlocked0, &boot_data));
  RETURN_IF_ERROR(check_boot_data(&boot_data, 5));
  return kErrorOk;
}

rom_error_t read_empty_default_not_allowed_test(void) {
  erase_boot_data_pages();

  boot_data_t boot_data;
  if (boot_data_read(kLcStateProd, &boot_data) == kErrorBootDataNotFound) {
    return kErrorOk;
  }
  return kErrorUnknown;
}

rom_error_t read_single_page_0_test(void) {
  erase_boot_data_pages();
  write_boot_data(kBootDataPage0Base, 0, &kTestBootData);

  boot_data_t boot_data;
  RETURN_IF_ERROR(boot_data_read(kLcStateProd, &boot_data));
  RETURN_IF_ERROR(compare_boot_data(&boot_data, &kTestBootData));
  return kErrorOk;
}

rom_error_t read_single_page_1_test(void) {
  erase_boot_data_pages();
  write_boot_data(kBootDataPage1Base, 0, &kTestBootData);

  boot_data_t boot_data;
  uint64_t start = ibex_mcycle_read();
  RETURN_IF_ERROR(boot_data_read(kLcStateProd, &boot_data));
  uint64_t end = ibex_mcycle_read();
  RETURN_IF_ERROR(compare_boot_data(&boot_data, &kTestBootData));
  uint32_t cycles = end - start;
  LOG_INFO("boot_data_read() took %u cycles", cycles);
  return kErrorOk;
}

rom_error_t read_full_page_0_test(void) {
  erase_boot_data_pages();
  fill_with_invalidated_boot_data(kBootDataPage0Base,
                                  kBootDataEntriesPerPage - 1, &kTestBootData);
  write_boot_data(kBootDataPage0Base, kBootDataEntriesPerPage - 1,
                  &kTestBootData);
  fill_with_invalidated_boot_data(kBootDataPage1Base, kBootDataEntriesPerPage,
                                  &kTestBootData);

  boot_data_t boot_data;
  RETURN_IF_ERROR(boot_data_read(kLcStateProd, &boot_data));
  RETURN_IF_ERROR(compare_boot_data(&boot_data, &kTestBootData));
  return kErrorOk;
}

rom_error_t read_full_page_1_test(void) {
  erase_boot_data_pages();
  fill_with_invalidated_boot_data(kBootDataPage0Base, kBootDataEntriesPerPage,
                                  &kTestBootData);
  fill_with_invalidated_boot_data(kBootDataPage1Base,
                                  kBootDataEntriesPerPage - 1, &kTestBootData);
  write_boot_data(kBootDataPage1Base, kBootDataEntriesPerPage - 1,
                  &kTestBootData);

  boot_data_t boot_data;
  uint64_t start = ibex_mcycle_read();
  RETURN_IF_ERROR(boot_data_read(kLcStateProd, &boot_data));
  uint64_t end = ibex_mcycle_read();
  RETURN_IF_ERROR(compare_boot_data(&boot_data, &kTestBootData));
  uint32_t cycles = end - start;
  LOG_INFO("boot_data_read() took %u cycles", cycles);
  return kErrorOk;
}

rom_error_t write_empty_test(void) {
  erase_boot_data_pages();
  RETURN_IF_ERROR(boot_data_write(&kTestBootData));
  boot_data_t boot_data;
  RETURN_IF_ERROR(boot_data_read(kLcStateProd, &boot_data));
  RETURN_IF_ERROR(compare_boot_data(&kTestBootData, &boot_data));
  return kErrorOk;
}

rom_error_t write_page_switch_test(void) {
  erase_boot_data_pages();
  boot_data_t boot_data_act;
  boot_data_t boot_data_exp;
  // Counter value starts from `kBootDataDefault.counter` defined in
  // `boot_data.c` and is incremented before each write.
  uint32_t counter_exp = 5;

  // Write `kBootDataEntriesPerPage` + 1 entries to test the switch from page 0
  // to page 1.
  for (size_t i = 0; i < kBootDataEntriesPerPage + 1; ++i) {
    RETURN_IF_ERROR(boot_data_write(&kTestBootData));
    // Check `identifier`, `digest`, and `counter` fields.
    RETURN_IF_ERROR(boot_data_read(kLcStateProd, &boot_data_act));
    RETURN_IF_ERROR(check_boot_data(&boot_data_act, ++counter_exp));
    if (i > 0) {
      // Previous entry must be invalidated.
      boot_data_t prev_entry;
      read_boot_data(kBootDataPage0Base, i - 1, &prev_entry);
      if (prev_entry.identifier != kBootDataInvalidatedIdentifier) {
        return kErrorUnknown;
      }
    }
  }
  // Last written entry must be at entry 0 in page 1.
  read_boot_data(kBootDataPage1Base, 0, &boot_data_exp);
  if (memcmp(&boot_data_act, &boot_data_exp, sizeof(boot_data_t)) != 0) {
    LOG_ERROR("Page 0 -> 1 switch failed.");
    return kErrorUnknown;
  }

  // Write `kBootDataEntriesPerPage` entries to test the switch from page 1 to
  // page 0.
  for (size_t i = 1; i < kBootDataEntriesPerPage + 1; ++i) {
    RETURN_IF_ERROR(boot_data_write(&kTestBootData));
    // Check `identifier`, `digest`, and `counter` fields.
    RETURN_IF_ERROR(boot_data_read(kLcStateProd, &boot_data_act));
    RETURN_IF_ERROR(check_boot_data(&boot_data_act, ++counter_exp));
    // Previous entry must be invalidated.
    boot_data_t prev_entry;
    read_boot_data(kBootDataPage1Base, i - 1, &prev_entry);
    if (prev_entry.identifier != kBootDataInvalidatedIdentifier) {
      return kErrorUnknown;
    }
  }
  // Last written entry must be at entry 0 in page 0.
  read_boot_data(kBootDataPage0Base, 0, &boot_data_exp);
  if (memcmp(&boot_data_act, &boot_data_exp, sizeof(boot_data_t)) != 0) {
    LOG_ERROR("Page 1 -> 0 switch failed.");
    return kErrorUnknown;
  }

  return kErrorOk;
}

bool test_main(void) {
  rom_error_t result = kErrorOk;

  flash_init_block();
  unlock_boot_data_pages();

  EXECUTE_TEST(result, check_test_data_test);
  EXECUTE_TEST(result, read_empty_default_allowed_test);
  EXECUTE_TEST(result, read_empty_default_not_allowed_test);
  EXECUTE_TEST(result, read_single_page_0_test);
  EXECUTE_TEST(result, read_single_page_1_test);
  EXECUTE_TEST(result, read_full_page_0_test);
  EXECUTE_TEST(result, read_full_page_1_test);
  EXECUTE_TEST(result, write_empty_test);
  EXECUTE_TEST(result, write_page_switch_test);

  return result == kErrorOk;
}
