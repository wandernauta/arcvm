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

// PROCESSOR CHARACTERISTICS

// The number of registers to use
static const unsigned int NUM_REGS = 32;

// The size of the userspace memory in bytes
static const unsigned int USERSPACE = 512 * 1024;

// Word size in bytes
static const unsigned int WORD = 4;

// Halfword size in bytes
static const unsigned int HALFWORD = 2;

// Word size in bits
static const unsigned int WORD_BITS = 8;

// MEMORY LOCATION DEFINITIONS AND OFFSETS

// Operating system-reserved memory in bytes
static const unsigned int MEM_OS = 0x800;

// Begin of I/O mapping in bytes
static const unsigned int MEM_IO = 0xFFFF0000;

// Console data (out) port
static const unsigned int C_OUT = 0xFFFF0000;

// Console status (in) port
static const unsigned int C_STAT = 0xFFFF0004;

// Video status (in) port (8 bits)
static const unsigned int V_STAT = 0xFFFF00F0;

// Video color (in/out) port (8 bits)
static const unsigned int V_COLOR = 0xFFFF00F1;

// Video command (out) port (16 bits)
static const unsigned int V_CMD = 0xFFFF00F2;

// Video pixel location (out/in) port (32+32 bits)
static const unsigned int V_ADDR_X = 0xFFFF00F4;
static const unsigned int V_ADDR_Y = 0xFFFF00F8;

// TRACING AND DEBUGGING

// Whether to check the configuration at runtime
static const bool CHECK_CONFIG = true;

// Trace (print) memory loads and stores
static const bool TRACE_MEMORY = false;

// Trace (print) instructions
static const bool TRACE_INSTRS = false;

// Display a run summary when the VM halts
static const bool PRINT_SUMMARY = true;

// VIDEO
static const bool VIDEO_ENABLED = true;
static const unsigned int VIDEO_WIDTH = 320;
static const unsigned int VIDEO_HEIGHT = 240;
static const unsigned int VIDEO_SCALE = 3;

void check_config();
