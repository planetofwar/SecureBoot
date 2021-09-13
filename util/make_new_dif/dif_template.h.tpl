// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

<%doc>
    This file is the "DIF library header template", which provides a base for
    manually-implmenting portions of a DIF for a new peripheral, defining all of
    the declarations that would be expected of a DIF library as described in the
    README.md. This header includes the auto-generated DIF library header, whose
    template is defined in util/make_new_dif/dif_autogen.inc.tpl.

    This file should be instantiated with the `util/make_new_dif.py` script.

    The script also includes additional options for controlling how the template
    is instantiated. After the script runs:
       - delete this comment, 
       - the #error below, and 
       - any unnecessary definitions.
    Finally, remember to run clang-format!

    Note, this template requires the following Python objects to be passed:

    1. ip: See util/make_new_dif.py for the definition of the `ip` obj.
</%doc>

#ifndef OPENTITAN_SW_DEVICE_LIB_DIF_DIF_${ip.name_upper}_H_
#define OPENTITAN_SW_DEVICE_LIB_DIF_DIF_${ip.name_upper}_H_


#error "This file is a template, and not real code."

/**
 * @file
 * @brief <a href="/hw/ip/${ip.name_snake}/doc/">${ip.name_long_upper}</a> Device Interface Functions
 */

#include <stdint.h>

#include "sw/device/lib/dif/dif_warn_unused_result.h"

#include "sw/device/lib/dif/autogen/dif_${ip.name_snake}_autogen.inc"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * Hardware instantiation parameters for ${ip.name_long_lower}.
 *
 * This struct describes information about the underlying HARDWARE that is
 * not determined until the hardware IP is used as part of a top-level
 * design. This EXCLUDES the base address of the IP as this is defined the IP's
 * handle struct which is autogenerated using the 
 * util/make_new_dif/dif_autogen.h.tpl template. This is typically only used
 * with templated (generic) IPs, such as the Alert Handler.
 */
typedef struct dif_${ip.name_snake}_params {
  // Fields, if necessary.
  // DO NOT include the IP's base address as a field, see above.
} dif_${ip.name_snake}_params_t;

/**
 * Runtime configuration for ${ip.name_long_lower}.
 *
 * This struct describes (SOFTWARE) runtime information for one-time
 * configuration of the hardware.
 */
typedef struct dif_${ip.name_snake}_config {
  // Fields, if necessary.
} dif_${ip.name_snake}_config_t;

/**
 * Additional results of a ${ip.name_long_lower} operation.
 * 
 * Note: base result values are defined in the fully autogenerated header, see
 * the util/make_new_dif/dif_autogen.h.tpl template, there fore these values
 * must start at 3.
 */
typedef enum dif_${ip.name_snake}_result_ext {
  // Remove this variant if you don't need it.
  kDif${ip.name_camel}Locked = 3,
  // Additional variants if required..
} dif_${ip.name_snake}_result_ext_t;

/**
 * Parameters for a ${ip.name_long_lower} transaction.
 */
typedef struct dif_${ip.name_snake}_transaction {
  // Your fields here.
} dif_${ip.name_snake}_transaction_t;

/**
 * An output location for a ${ip.name_long_lower} transaction.
 */
typedef struct dif_${ip.name_snake}_output {
  // Your fields here.
} dif_${ip.name_snake}_output_t;

/**
 * Calculates information needed to safely call a DIF. Functions like this
 * should be used instead of global variables or #defines.
 *
 * This function does not actuate the hardware.
 *
 * @param params Hardware instantiation parameters.
 * @return The information required.
 */
DIF_WARN_UNUSED_RESULT
uint32_t dif_${ip.name_snake}_get_size(dif_${ip.name_snake}_params_t params);

/**
 * Creates a new handle for ${ip.name_long_lower}.
 *
 * This function does not actuate the hardware.
 *
 * @param base_addr The MMIO base address of the IP.
 * @param params Hardware instantiation parameters. (optional, may remove)
 * @param[out] ${ip.name_snake} Out param for the initialized handle.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_${ip.name_snake}_result_t dif_${ip.name_snake}_init(
  mmio_region_t base_addr,
  dif_${ip.name_snake}_params_t params,
  dif_${ip.name_snake}_t *${ip.name_snake});

/**
 * Configures ${ip.name_long_lower} with runtime information.
 *
 * This function should only need to be called once for the lifetime of
 * `handle`.
 *
 * @param ${ip.name_snake} A ${ip.name_long_lower} handle.
 * @param config Runtime configuration parameters.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_${ip.name_snake}_result_t dif_${ip.name_snake}_configure(
  const dif_${ip.name_snake}_t *${ip.name_snake},
  dif_${ip.name_snake}_config_t config);

/**
 * Begins a ${ip.name_long_lower} transaction.
 *
 * Each call to this function should be sequenced with a call to
 * `dif_${ip.name_snake}_end()`.
 *
 * @param ${ip.name_snake} A ${ip.name_long_lower} handle.
 * @param transaction Transaction configuration parameters.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_${ip.name_snake}_result_t dif_${ip.name_snake}_start(
  const dif_${ip.name_snake}_t *${ip.name_snake},
  dif_${ip.name_snake}_transaction_t transaction);

/** Ends a ${ip.name_long_lower} transaction, writing the results to the given output..
 *
 * @param ${ip.name_snake} A ${ip.name_long_lower} handle.
 * @param output Transaction output parameters.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_${ip.name_snake}_result_t dif_${ip.name_snake}_end(
  const dif_${ip.name_snake}_t *${ip.name_snake},
  dif_${ip.name_snake}_output_t output);

/**
 * Locks out ${ip.name_long_lower} functionality.
 *
 * This function is reentrant: calling it while functionality is locked will
 * have no effect and return `kDif${ip.name_camel}Ok`.
 *
 * @param ${ip.name_snake} A ${ip.name_long_lower} handle.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_${ip.name_snake}_result_t dif_${ip.name_snake}_lock(
  const dif_${ip.name_snake}_t *${ip.name_snake});

/**
 * Checks whether this ${ip.name_long_lower} is locked.
 *
 * @param ${ip.name_snake} A ${ip.name_long_lower} handle.
 * @param[out] is_locked Out-param for the locked state.
 * @return The result of the operation.
 */
DIF_WARN_UNUSED_RESULT
dif_${ip.name_snake}_result_t dif_${ip.name_snake}_is_locked(
  const dif_${ip.name_snake}_t *${ip.name_snake},
  bool *is_locked);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_LIB_DIF_DIF_${ip.name_upper}_H_
