// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package otbn_env_pkg;
  // dep packages
  import uvm_pkg::*;
  import top_pkg::*;
  import dv_utils_pkg::*;
  import dv_lib_pkg::*;
  import tl_agent_pkg::*;
  import cip_base_pkg::*;
  import otbn_model_agent_pkg::*;
  import otbn_memutil_pkg::*;

  // autogenerated RAL model
  import otbn_reg_pkg::*;
  import otbn_ral_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // typedefs

  typedef virtual pins_if #(1) idle_vif;

  // A very simple wrapper around a word that has been loaded from the input binary and needs
  // storing to OTBN's IMEM or DMEM.
  typedef struct packed {
    // Is this destined for IMEM?
    bit           for_imem;
    // The (word) offset within the destination memory
    bit [21:0]    offset;
    // The data to be loaded
    bit [31:0]    data;

  } otbn_loaded_word;


  // package sources
  `include "otbn_env_cfg.sv"
  `include "otbn_env_cov.sv"
  `include "otbn_virtual_sequencer.sv"
  `include "otbn_scoreboard.sv"
  `include "otbn_env.sv"

  `include "otbn_vseq_list.sv"

endpackage
