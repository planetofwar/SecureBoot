// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef SPIDPI_H_
#define SPIDPI_H_

#include <limits.h>
#include <svdpi.h>

extern "C" {

#define MAX_TRANSACTION 4
struct spidpi_ctx {
  int loglevel;
  char ptyname[64];
  int master;
  int slave;
  FILE *mon_file;
  char mon_pathname[PATH_MAX];
  void *mon;
  int tick;
  int cpol;
  int cpha;
  int msbfirst;  // shift direction
  int nout;
  int bout;
  int nin;
  int bin;
  int din;
  int nmax;
  char driving;
  int state;
  char buf[MAX_TRANSACTION];
};

// SPI Master States
#define SP_IDLE 0
#define SP_CSFALL 1
#define SP_DMOVE 2
#define SP_LASTBIT 3
#define SP_CSRISE 4
#define SP_FINISH 99

// Bits in data to C
#define D2P_MISO 0x2
#define D2P_MISO_EN 0x1

// Bits in char from C
#define P2D_SCK 0x1
#define P2D_CSB 0x2
#define P2D_MOSI 0x4

void *spidpi_create(const char *name, int mode, int loglevel);
char spidpi_tick(void *ctx_void, svBitVecVal *d2p);
void spidpi_close(void *ctx_void);

// monitor
void monitor_spi(void *mon_void, FILE *mon_file, int loglevel, int tick,
                 int p2d, int d2p);
void *monitor_spi_init(int mode);
}
#endif  // SPIDPI_H_
