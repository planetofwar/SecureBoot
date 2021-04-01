// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class clkmgr_virtual_sequencer extends cip_base_virtual_sequencer #(
    .CFG_T(clkmgr_env_cfg),
    .COV_T(clkmgr_env_cov)
  );
  `uvm_component_utils(clkmgr_virtual_sequencer)


  `uvm_component_new

endclass
