// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/silicon_creator/mask_rom/mask_rom.h"

#include <stdbool.h>
#include <stdint.h>

#include "sw/device/lib/base/csr.h"
#include "sw/device/lib/base/stdasm.h"
#include "sw/device/lib/pinmux.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/silicon_creator/rom_exts/rom_ext_manifest_parser.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

// This is the expected ROM_EXT Manifest Identifier
static const uint32_t kRomExtIdentifierExpected = 0x4552544F;

typedef void(boot_fn)(void);

void mask_rom_exception_handler(void) { wait_for_interrupt(); }
void mask_rom_nmi_handler(void) { wait_for_interrupt(); }

void mask_rom_boot(void) {
  pinmux_init();
  // boot_reason = read_boot_reason(); // Boot Policy Module

  // Clean Device State Part 2.
  // See "Cleaning Device State" Below.
  // clean_device_state_part_2(boot_reason); // Chip-Specific Startup Module

  // Enable Memory Protection
  // - PMP Initial Region (if not done in power on)
  // enable_memory_protection();  // Lockdown Module

  // Chip-specific startup functionality (NOTE: we expect this portion of
  // initialization to be done in assembly before C runtime init.  Delete
  // this segment of comments & pseudo-code when done).
  // **Open Q:** Proprietary Software Strategy.
  // - Clocks
  // - AST / Entropy.
  // - Flash
  // - Fuses
  // chip_specific_startup(); // Chip-Specific Startup Module

  // Manufacturing boot-strapping intervention.
  // **Open Q:** How does the Mask ROM deal with chip recovery?
  // Tentative answer: recovery is performed by ROM_EXT.
  // **Open Q:** Pin Strapping Configuration.
  // manufacturing_boot_strap(boot_policy, boot_reason); // Bootstrap Module

  // Read Boot Policy for ROM_EXTs from flash (2.b)
  // boot_policy = read_boot_policy(boot_reason); // Boot Policy Module

  // Determine which ROM_EXT slot is prioritised (2.b, 2.c.i)
  // for ( current_rom_ext_manifest in rom_ext_manifests_to_try(boot_policy) ) {
  // // Boot Policy Module
  while (true) {
    // Check ROM_EXT Manifest (2.c.ii)
    // **Open Q:** Integration with Secure Boot Hardware
    // - Header Format (ROM_EXT Manifest Module)
    // - Plausible Key (??)
    // - Initial Digest Checks (Keys + Signature Module)
    // - **Open Q**: ROM_EXT Anti-rollback (??)
    // if (!check_rom_ext_manifest(current_rom_ext_manifest)) {
    //  // Manifest Failure (check Boot Policy)
    //  if (try_next_on_manifest_failed(boot_policy)) // Boot Policy Module
    //    continue
    //  else
    //    break
    //}
    // Temporary implementation for the above `if` block.
    rom_ext_manifest_t rom_ext = rom_ext_get_parameters(kRomExtManifestSlotA);

    // Find Public Key for ROM_EXT Image Signature (2.c.iii)
    // **Open Q:** Key Selection method/mechanism.
    // rom_ext_pub_key = read_pub_key(current_rom_ext_manifest); // ROM_EXT
    // Manifest Module:
    // rom_ext_pub_key_id = calculate_key_id(rom_ext_pub_key);
    // // Keys + Signature Module:
    // if (!check_pub_key_id_valid(rom_ext_pub_key_id)) {
    //  // Manifest failure (Check Boot Policy)
    //  if (try_next_on_manifest_failed(boot_policy))  // Boot Policy Module
    //    continue
    //  else
    //    break
    //}

    // Verify ROM_EXT Image Signature (2.c.iii)
    // **Open Q:** Integration with Secure Boot Hardware, OTBN
    // if (!verify_rom_ext_signature(rom_ext_pub_key,
    //                              current_rom_ext_manifest)) { // Hardened
    //                              Jump Module
    //  // Manifest Failure (check Boot Policy)
    //  // **Open Q:** Does this need different logic to the check after
    //  //   `check_rom_ext_manifest`?
    //  if (try_next_on_manifest_failed(boot_policy)) // Boot Policy Module
    //    continue
    //  else
    //    break
    //}
    // Temporary implementation for the two above `if` blocks.
    if (rom_ext_get_identifier(rom_ext) != kRomExtIdentifierExpected) {
      break;
    }

    // Update Boot Policy on Successful Signature
    // **Open Q:** Does this ensure ROM_EXT Anti-rollback is updated?
    // update_next_boot_policy(boot_policy, current_rom_ext_manifest); // Boot
    // Policy Module

    // Beyond this point, you know `current_rom_ext_manifest` is valid and the
    // signature has been authenticated.
    //
    // The Mask ROM now has to do various things to prepare to execute the
    // current ROM_EXT. Most of this is initializing identities, keys, and
    // potentially locking down some hardware, before jumping to ROM_EXT.
    //
    // If any of these steps fail, we've probably left the hardware in an
    // invalid state and should just reboot (because it may not be possible to
    // undo the changes, for instance to write-enable bits).

    // System State Measurements (2.c.iv)
    // measurements = perform_system_state_measurements(); // System State
    // Module if (!boot_allowed_with_state(measurements)) { // System State
    // Module
    //  // Lifecycle failure (no policy check)
    //  break
    //}

    // CreatorRootKey (2.c.iv)
    // - This is only allowed to be done if we have verified the signature on
    //   the current ROM_EXT.
    // **Open Q:** Does Mask ROM just lock down key manager inputs, and let the
    //             ROM_EXT load the key?
    // derive_and_lock_creator_root_key_inputs(measurements); // System State
    // Module

    // Lock down Peripherals based on descriptors in ROM_EXT manifest.
    // - This does not cover key-related lockdown, which is done in
    //   `derive_and_lock_creator_root_key_inputs`.
    // peripheral_lockdown(current_rom_ext_manifest); // Lockdown Module

    // PMP Region for ROM_EXT (2.c.v)
    // **Open Q:** Integration with Secure Boot Hardware
    // **Open Q:** Do we need to prevent access to Mask ROM after final jump?
    // pmp_unlock_rom_ext(); // Hardened Jump Module.

    // Transfer Execution to ROM_EXT (2.c.vi)
    // **Open Q:** Integration with Secure Boot Hardware
    // **Open Q:** Accumulated measurements to tie manifest to hardware config.
    // if (!final_jump_to_rom_ext(current_rom_ext_manifest)) { // Hardened Jump
    // Module
    if (true) {
      // Set mtvec for ROM_EXT.
      uintptr_t interrupt_vector = rom_ext_get_interrupt_vector(rom_ext);
      CSR_WRITE(CSR_REG_MTVEC, (uint32_t)interrupt_vector);

      // Jump to ROM_EXT entry point.
      boot_fn *rom_ext_entry = (boot_fn *)rom_ext_get_entry(rom_ext);
      rom_ext_entry();
      // NOTE: never expecting a return, but if something were to go wrong
      // in the real `jump` implementation, we need to enter a failure case.

      // Boot Failure (no policy check)
      // - Because we may have locked some write-enable bits that any following
      //   manifest cannot change if it needs to, we have to just reboot here.
      // boot_failed(boot_policy, current_rom_ext_manifest); // Boot Policy
      // Module
    }
  }

  // Boot failed for all ROM_EXTs allowed by boot policy
  // boot_failed(boot_policy); // Boot Policy Module
  asm volatile("unimp");
  while (true) {
    wait_for_interrupt();
  }
}
