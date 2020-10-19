// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_DIF_DIF_RSTMGR_H_
#define OPENTITAN_SW_DEVICE_LIB_DIF_DIF_RSTMGR_H_

/**
 * @file
 * @brief <a href="/hw/ip/rstmgr/doc/">Reset Manager</a> Device Interface
 * Functions
 */

#include <stdbool.h>
#include <stdint.h>

#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_warn_unused_result.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * Reset Manager peripheral software reset control.
 */
typedef enum dif_rstmgr_software_reset {
  /**
   * Simple reset (release straight away).
   */
  kDifRstmgrSoftwareReset = 0,
  kDifRstmgrSoftwareResetHold,    /**< Hold peripheral in reset. */
  kDifRstmgrSoftwareResetRelease, /**< Release peripheral from reset. */
} dif_rstmgr_software_reset_t;

/**
 * Reset Manager reset information bitfield.
 */
typedef uint32_t dif_rstmgr_reset_info_bitfield_t;

/**
 * Reset Manager possible reset information enumeration.
 *
 * Invariants are used to extract information encoded in
 * `dif_rstmgr_reset_info_bitfield_t`, which means that the values must
 * correspond
 * to the individual bits (0x1, 0x2, 0x4, ..., 0x80000000).
 *
 * Note: these must match the autogenerated register definitions.
 */
typedef enum dif_rstmgr_reset_info {
  /**
   * Device has reset due to power up.
   */
  kDifRstmgrResetInfoPor = 0x1,
  /**
   * Device has reset due to lowe power exit.
   */
  kDifRstmgrResetInfoLowPowerExit = (0x1 << 1),
  /**
   * Device has reset due to non-debug-module request.
   */
  kDifRstmgrResetInfoNdm = (0x1 << 2),
  /**
   * Device has reset due to a peripheral request. This can be an alert
   * escalation, watchdog or anything else.
   */
  kDifRstmgrResetInfoHwReq = (0x1 << 3),
  /**
   * \internal used to catch missing `_Static_assert` for public variants.
   */
  kDifRstmgrResetInfoLast = kDifRstmgrResetInfoHwReq,
} dif_rstmgr_reset_info_t;

/**
 * Reset Manager software reset available peripherals.
 */
typedef uint32_t dif_rstmgr_peripheral_t;

/**
 * The result of a Reset Manager operation.
 */
typedef enum dif_rstmgr_result {
  /**
   * Indicates that the operation succeeded.
   */
  kDifRstmgrOk = 0,
  /**
   * Indicates some unspecified failure.
   */
  kDifRstmgrError = 1,
  /**
   * Indicates that some parameter passed into a function failed a
   * precondition.
   *
   * When this value is returned, no hardware operations occurred.
   */
  kDifRstmgrBadArg = 2,
} dif_rstmgr_result_t;

/**
 * Hardware instantiation parameters for Reset Manager.
 *
 * This struct describes information about the underlying hardware that is
 * not determined until the hardware design is used as part of a top-level
 * design.
 */
typedef struct dif_rstmgr_params {
  /**
   * The base address for the rstmgr hardware registers.
   */
  mmio_region_t base_addr;
} dif_rstmgr_params_t;

/**
 * A handle to rstmgr.
 *
 * This type should be treated as opaque by users.
 */
typedef struct dif_rstmgr { dif_rstmgr_params_t params; } dif_rstmgr_t;

/**
 * Creates a new handle for Reset Manager.
 *
 * This function does not actuate the hardware.
 *
 * @param params Hardware instantiation parameters.
 * @param handle Out param for the initialized handle.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_rstmgr_result_t dif_rstmgr_init(dif_rstmgr_params_t params,
                                    dif_rstmgr_t *handle);

/**
 * Resets the Reset Manager registers to sane defaults.
 *
 * Note that software reset enable registers cannot be cleared once have been
 * locked.
 *
 * @param handle A Reset Manager handle.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_rstmgr_result_t dif_rstmgr_reset(const dif_rstmgr_t *handle);

/**
 * Locks out requested peripheral reset functionality.
 *
 * Calling this function when software reset is locked will have no effect
 * and return `kDifRstmgrOk`.
 *
 * @param handle A Reset Manager handle.
 * @param peripheral Peripheral to lock the reset functionality for.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_rstmgr_result_t dif_rstmgr_reset_lock(const dif_rstmgr_t *handle,
                                          dif_rstmgr_peripheral_t peripheral);

/**
 * Checks whether requested peripheral reset functionality is locked.
 *
 * @param handle A Reset Manager handle.
 * @param peripheral Peripheral to check the reset lock for.
 * @param is_locked Out-param for the locked state.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_rstmgr_result_t dif_rstmgr_reset_is_locked(
    const dif_rstmgr_t *handle, dif_rstmgr_peripheral_t peripheral,
    bool *is_locked);

/**
 * Obtains the complete Reset Manager reset information.
 *
 * The reset info are parsed and presented to the caller as an
 * array of flags in 'info'.
 *
 * @param handle A Reset Manager handle.
 * @param info Reset information.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_rstmgr_result_t dif_rstmgr_reset_info_get(
    const dif_rstmgr_t *handle, dif_rstmgr_reset_info_bitfield_t *info);

/**
 * Clears the reset information in Reset Manager.
 *
 * @param handle A Reset Manager handle.
 * @return `dif_rstmgr_result_t`.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_rstmgr_result_t dif_rstmgr_reset_info_clear(const dif_rstmgr_t *handle);

/**
 * The result of a Reset Manager software reset operation.
 */
typedef enum dif_rstmgr_software_reset_result {
  /**
   * Indicates that the operation succeeded.
   */
  kDifRstmgrSoftwareResetOk = kDifRstmgrOk,
  /**
   * Indicates some unspecified failure.
   */
  kDifRstmgrSoftwareResetError = kDifRstmgrError,
  /**
   * Indicates that some parameter passed into a function failed a
   * precondition.
   *
   * When this value is returned, no hardware operations occurred.
   */
  kDifRstmgrSoftwareResetBadArg = kDifRstmgrBadArg,
  /**
   * Indicates that this operation has been locked out, and can never
   * succeed until hardware reset.
   */
  kDifRstmgrSoftwareResetLocked,
} dif_rstmgr_software_reset_result_t;

/**
 * Asserts or de-asserts software reset for the requested peripheral.
 *
 * @param handle A Reset Manager handle.
 * @param peripheral Peripheral to assert/de-assert reset for.
 * @param reset Reset control.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_rstmgr_software_reset_result_t dif_rstmgr_software_reset(
    const dif_rstmgr_t *handle, dif_rstmgr_peripheral_t peripheral,
    dif_rstmgr_software_reset_t reset);

/**
 * Queries whether the requested peripheral is held in reset.
 *
 * @param handle A Reset Manager handle.
 * @param peripheral Peripheral to query.
 * @param asserted 'true' when held in reset, `false` otherwise.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_rstmgr_result_t dif_rstmgr_software_reset_is_held(
    const dif_rstmgr_t *handle, dif_rstmgr_peripheral_t peripheral,
    bool *asserted);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_LIB_DIF_DIF_RSTMGR_H_
