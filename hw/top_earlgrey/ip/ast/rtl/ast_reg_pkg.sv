// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package ast_reg_pkg;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic [7:0]  q;
  } ast_reg2hw_revid_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } ast_reg2hw_rwtype0_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } field0;
    struct packed {
      logic        q;
    } field1;
    struct packed {
      logic        q;
    } field4;
    struct packed {
      logic [7:0]  q;
    } field15_8;
  } ast_reg2hw_rwtype1_reg_t;


  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } ast_hw2reg_rwtype0_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    ast_reg2hw_revid_reg_t revid; // [50:43]
    ast_reg2hw_rwtype0_reg_t rwtype0; // [42:11]
    ast_reg2hw_rwtype1_reg_t rwtype1; // [10:0]
  } ast_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    ast_hw2reg_rwtype0_reg_t rwtype0; // [32:0]
  } ast_hw2reg_t;

  // Register Address
  parameter logic [3:0] AST_REVID_OFFSET = 4'h 0;
  parameter logic [3:0] AST_RWTYPE0_OFFSET = 4'h 4;
  parameter logic [3:0] AST_RWTYPE1_OFFSET = 4'h 8;


  // Register Index
  typedef enum int {
    AST_REVID,
    AST_RWTYPE0,
    AST_RWTYPE1
  } ast_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] AST_PERMIT [3] = '{
    4'b 0001, // index[0] AST_REVID
    4'b 1111, // index[1] AST_RWTYPE0
    4'b 0011  // index[2] AST_RWTYPE1
  };
endpackage

