#include "config.h"
//
// config.c
// Compile-time configuration
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

#include "assert.h"

// Defaults
int MAJOR = 0;
int MINOR = 1;
int NUM_REGS = 32;
int USERSPACE = 512;
int WORD = 4;
int HALFWORD = 2;
int WORD_BITS = 8;
unsigned int MEM_OS = 0x800;
unsigned int MEM_IO = 0xFFFF0000;
unsigned int C_OUT = 0xFFFF0000;
unsigned int C_STAT = 0xFFFF0004;
unsigned int V_STAT = 0xFFFF00F0;
unsigned int V_COLOR = 0xFFFF00F1;
unsigned int V_CMD = 0xFFFF00F2;
unsigned int V_ADDR_X = 0xFFFF00F4;
unsigned int V_ADDR_Y = 0xFFFF00F8;
int CHECK_CONFIG = true;
int TRACE_MEMORY = false;
int TRACE_INSTRS = false;
int PRINT_SUMMARY = true;
int VIDEO_ENABLED = true;
int VIDEO_WIDTH = 320;
int VIDEO_HEIGHT = 240;
int VIDEO_SCALE = 3;

void check_config() {
    if (!CHECK_CONFIG) return;

    assert(NUM_REGS >= 1);
    assert(USERSPACE >= 1);
    assert(MEM_IO >= MEM_OS);

    assert(C_OUT);
    assert(C_STAT);
    assert(V_STAT);
    assert(V_COLOR);
    assert(V_CMD);
    assert(V_ADDR_X);
    assert(V_ADDR_Y);

    assert(VIDEO_WIDTH >= 1);
    assert(VIDEO_HEIGHT >= 1);
    assert(VIDEO_SCALE >= 1);
}

