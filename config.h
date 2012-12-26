#pragma once
//
// config.h
// Compile-time configuration
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

#include <stdint.h>
#include <stdbool.h>

// VM VERSION ETC
extern int MAJOR;
extern int MINOR;

// PROCESSOR CHARACTERISTICS

// The number of registers to use
extern int NUM_REGS;

// The size of the userspace memory in kilobytes
extern int USERSPACE;

// Word size in bytes
extern int WORD;

// Halfword size in bytes
extern int HALFWORD;

// Word size in bits
extern int WORD_BITS;

// MEMORY LOCATION DEFINITIONS AND OFFSETS

// Operating system-reserved memory in bytes
extern unsigned int MEM_OS;

// Begin of I/O mapping in bytes
extern unsigned int MEM_IO;

// Console data (out) port
extern unsigned int C_OUT;

// Console status (in) port
extern unsigned int C_STAT;

// Video status (in) port (8 bits)
extern unsigned int V_STAT;

// Video color (in/out) port (8 bits)
extern unsigned int V_COLOR;

// Video command (out) port (16 bits)
extern unsigned int V_CMD;

// Video pixel location (out/in) port (32+32 bits)
extern unsigned int V_ADDR_X;
extern unsigned int V_ADDR_Y;

// TRACING AND DEBUGGING

// Whether to check the configuration at runtime
extern int CHECK_CONFIG;

// Trace (print) memory loads and stores
extern int TRACE_MEMORY;

// Trace (print) instructions
extern int TRACE_INSTRS;

// Display a run summary when the VM halts
extern int PRINT_SUMMARY;

// VIDEO
extern int VIDEO_ENABLED;
extern int VIDEO_WIDTH;
extern int VIDEO_HEIGHT;
extern int VIDEO_SCALE;

void check_config();
