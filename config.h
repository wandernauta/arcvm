#pragma once
#include <stdint.h>
#include <stdbool.h>

// PROCESSOR CHARACTERISTICS

// The number of registers to use
#define NUM_REGS 32

// The size of the userspace memory in bytes
#define USERSPACE 512 * 1024

// Word size in bytes
#define WORD 4

// Halfword size in bytes
#define HALFWORD WORD/2

// Word size in bits
#define WORD_BITS WORD*4

// MEMORY LOCATION DEFINITIONS AND OFFSETS

// Operating system-reserved memory in bytes
#define MEM_OS 0x800

// Begin of I/O mapping in bytes
#define MEM_IO 0xFFFF0000

// Console data (out) port
#define C_OUT MEM_IO + 0x00

// Console status (in) port
#define C_STAT MEM_IO + 0x04

// Video status (in) port (8 bits)
#define V_STAT MEM_IO + 0xF0

// Video color (in/out) port (8 bits)
#define V_COLOR MEM_IO + 0xF1

// Video command (out) port (16 bits)
#define V_CMD MEM_IO + 0xF2

// Video pixel location (out/in) port (32+32 bits)
#define V_ADDR_X MEM_IO + 0xF4
#define V_ADDR_Y MEM_IO + 0xF8

// TRACING AND DEBUGGING

// Whether to check the configuration at runtime
#define CHECK_CONFIG true

// Trace (print) memory loads and stores
#define TRACE_MEMORY false

// Trace (print) instructions
#define TRACE_INSTRS false

// Display a run summary when the VM halts
#define PRINT_SUMMARY true

// VIDEO
#define VIDEO_ENABLED true
#define VIDEO_WIDTH 320 
#define VIDEO_HEIGHT 240
#define VIDEO_SCALE 3

void check_config();
