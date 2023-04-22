// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_BASE_CSR_REGISTERS_H_
#define OPENTITAN_SW_DEVICE_LIB_BASE_CSR_REGISTERS_H_

/**
 * Ibex Control and Status Register (CSR) definitions.
 *
 * Note: these currently map directly to the CSR addresses but this
 * shouldn't be relied upon. These definitions should be treated as
 * opaque.
 */
#define CSR_REG_MSTATUS 0x300
#define CSR_REG_MISA 0x301
#define CSR_REG_MIE 0x304
#define CSR_REG_MTVEC 0x305
#define CSR_REG_MCOUNTINHIBIT 0x320
#define CSR_REG_MHPMEVENT3 0x323
#define CSR_REG_MHPMEVENT4 0x324
#define CSR_REG_MHPMEVENT5 0x325
#define CSR_REG_MHPMEVENT6 0x326
#define CSR_REG_MHPMEVENT7 0x327
#define CSR_REG_MHPMEVENT8 0x328
#define CSR_REG_MHPMEVENT9 0x329
#define CSR_REG_MHPMEVENT10 0x32A
#define CSR_REG_MHPMEVENT11 0x32B
#define CSR_REG_MHPMEVENT12 0x32C
#define CSR_REG_MHPMEVENT13 0x32D
#define CSR_REG_MHPMEVENT14 0x32E
#define CSR_REG_MHPMEVENT15 0x32F
#define CSR_REG_MHPMEVENT16 0x330
#define CSR_REG_MHPMEVENT17 0x331
#define CSR_REG_MHPMEVENT18 0x332
#define CSR_REG_MHPMEVENT19 0x333
#define CSR_REG_MHPMEVENT20 0x334
#define CSR_REG_MHPMEVENT21 0x335
#define CSR_REG_MHPMEVENT22 0x336
#define CSR_REG_MHPMEVENT23 0x337
#define CSR_REG_MHPMEVENT24 0x338
#define CSR_REG_MHPMEVENT25 0x339
#define CSR_REG_MHPMEVENT26 0x33A
#define CSR_REG_MHPMEVENT27 0x33B
#define CSR_REG_MHPMEVENT28 0x33C
#define CSR_REG_MHPMEVENT29 0x33D
#define CSR_REG_MHPMEVENT30 0x33E
#define CSR_REG_MHPMEVENT31 0x33F
#define CSR_REG_MSCRATCH 0x340
#define CSR_REG_MEPC 0x341
#define CSR_REG_MCAUSE 0x342
#define CSR_REG_MTVAL 0x343
#define CSR_REG_MIP 0x344
#define CSR_REG_MSECCFG 0x747
#define CSR_REG_MSECCFGH 0x757
#define CSR_REG_PMPCFG0 0x3A0
#define CSR_REG_PMPCFG1 0x3A1
#define CSR_REG_PMPCFG2 0x3A2
#define CSR_REG_PMPCFG3 0x3A3
#define CSR_REG_PMPADDR0 0x3B0
#define CSR_REG_PMPADDR1 0x3B1
#define CSR_REG_PMPADDR2 0x3B2
#define CSR_REG_PMPADDR3 0x3B3
#define CSR_REG_PMPADDR4 0x3B4
#define CSR_REG_PMPADDR5 0x3B5
#define CSR_REG_PMPADDR6 0x3B6
#define CSR_REG_PMPADDR7 0x3B7
#define CSR_REG_PMPADDR8 0x3B8
#define CSR_REG_PMPADDR9 0x3B9
#define CSR_REG_PMPADDR10 0x3BA
#define CSR_REG_PMPADDR11 0x3BB
#define CSR_REG_PMPADDR12 0x3BC
#define CSR_REG_PMPADDR13 0x3BD
#define CSR_REG_PMPADDR14 0x3BE
#define CSR_REG_PMPADDR15 0x3BF
#define CSR_REG_TSELECT 0x7A0
#define CSR_REG_TDATA1 0x7A1
#define CSR_REG_TDATA2 0x7A2
#define CSR_REG_TDATA3 0x7A3
#define CSR_REG_MCONTEXT 0x7A8
#define CSR_REG_SCONTEXT 0x7AA
#define CSR_REG_DCSR 0x7B0
#define CSR_REG_DPC 0x7B1
#define CSR_REG_DSCRATCH0 0x7B2
#define CSR_REG_DSCRATCH1 0x7B3
#define CSR_REG_CPUCTRL 0x7C0
#define CSR_REG_SECURESEED 0x7C1
#define CSR_REG_MCYCLE 0xB00
#define CSR_REG_MINSTRET 0xB02
#define CSR_REG_MHPMCOUNTER3 0xB03
#define CSR_REG_MHPMCOUNTER4 0xB04
#define CSR_REG_MHPMCOUNTER5 0xB05
#define CSR_REG_MHPMCOUNTER6 0xB06
#define CSR_REG_MHPMCOUNTER7 0xB07
#define CSR_REG_MHPMCOUNTER8 0xB08
#define CSR_REG_MHPMCOUNTER9 0xB09
#define CSR_REG_MHPMCOUNTER10 0xB0A
#define CSR_REG_MHPMCOUNTER11 0xB0B
#define CSR_REG_MHPMCOUNTER12 0xB0C
#define CSR_REG_MHPMCOUNTER13 0xB0D
#define CSR_REG_MHPMCOUNTER14 0xB0E
#define CSR_REG_MHPMCOUNTER15 0xB0F
#define CSR_REG_MHPMCOUNTER16 0xB10
#define CSR_REG_MHPMCOUNTER17 0xB11
#define CSR_REG_MHPMCOUNTER18 0xB12
#define CSR_REG_MHPMCOUNTER19 0xB13
#define CSR_REG_MHPMCOUNTER20 0xB14
#define CSR_REG_MHPMCOUNTER21 0xB15
#define CSR_REG_MHPMCOUNTER22 0xB16
#define CSR_REG_MHPMCOUNTER23 0xB17
#define CSR_REG_MHPMCOUNTER24 0xB18
#define CSR_REG_MHPMCOUNTER25 0xB19
#define CSR_REG_MHPMCOUNTER26 0xB1A
#define CSR_REG_MHPMCOUNTER27 0xB1B
#define CSR_REG_MHPMCOUNTER28 0xB1C
#define CSR_REG_MHPMCOUNTER29 0xB1D
#define CSR_REG_MHPMCOUNTER30 0xB1E
#define CSR_REG_MHPMCOUNTER31 0xB1F
#define CSR_REG_MCYCLEH 0xB80
#define CSR_REG_MINSTRETH 0xB82
#define CSR_REG_MHPMCOUNTER3H 0xB83
#define CSR_REG_MHPMCOUNTER4H 0xB84
#define CSR_REG_MHPMCOUNTER5H 0xB85
#define CSR_REG_MHPMCOUNTER6H 0xB86
#define CSR_REG_MHPMCOUNTER7H 0xB87
#define CSR_REG_MHPMCOUNTER8H 0xB88
#define CSR_REG_MHPMCOUNTER9H 0xB89
#define CSR_REG_MHPMCOUNTER10H 0xB8A
#define CSR_REG_MHPMCOUNTER11H 0xB8B
#define CSR_REG_MHPMCOUNTER12H 0xB8C
#define CSR_REG_MHPMCOUNTER13H 0xB8D
#define CSR_REG_MHPMCOUNTER14H 0xB8E
#define CSR_REG_MHPMCOUNTER15H 0xB8F
#define CSR_REG_MHPMCOUNTER16H 0xB90
#define CSR_REG_MHPMCOUNTER17H 0xB91
#define CSR_REG_MHPMCOUNTER18H 0xB92
#define CSR_REG_MHPMCOUNTER19H 0xB93
#define CSR_REG_MHPMCOUNTER20H 0xB94
#define CSR_REG_MHPMCOUNTER21H 0xB95
#define CSR_REG_MHPMCOUNTER22H 0xB96
#define CSR_REG_MHPMCOUNTER23H 0xB97
#define CSR_REG_MHPMCOUNTER24H 0xB98
#define CSR_REG_MHPMCOUNTER25H 0xB99
#define CSR_REG_MHPMCOUNTER26H 0xB9A
#define CSR_REG_MHPMCOUNTER27H 0xB9B
#define CSR_REG_MHPMCOUNTER28H 0xB9C
#define CSR_REG_MHPMCOUNTER29H 0xB9D
#define CSR_REG_MHPMCOUNTER30H 0xB9E
#define CSR_REG_MHPMCOUNTER31H 0xB9F
#define CSR_REG_MHARTID 0xF14
#endif  // OPENTITAN_SW_DEVICE_LIB_BASE_CSR_REGISTERS_H_
