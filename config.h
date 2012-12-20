#pragma once
#include <stdint.h>
#include <stdbool.h>

// The number of registers to use
#define NUM_REGS 32

// The size of the userspace memory in bytes
#define USERSPACE 512 * 1024

// Whether to check the configuration at runtime
#define CHECK_CONFIG true

// Word size in bytes
#define WORD 4

// Halfword size in bytes
#define HALFWORD WORD/2

// Word size in bits
#define WORD_BITS 32

// Operating system-reserved memory in bytes
#define MEM_OS 0x800

// Begin of I/O-mapped area in bytes
#define MEM_IO 0xFFFF0000

// Console data I/O offset
#define COUT 0x0

// Console status I/O offset
#define COSTAT 0x4

// Trace (print) memory loads and stores
#define TRACE_MEMORY false

// Trace (print) instructions
#define TRACE_INSTRS false

// Display a run summary when the VM halts
#define PRINT_SUMMARY true

// Settings for video support
#define VIDEO_ENABLED true
#define VIDEO_WIDTH 640 
#define VIDEO_HEIGHT 480
#define VIDEO_BPP 8
#define VMEM_SIZE ((VIDEO_BPP/8) * VIDEO_WIDTH * VIDEO_HEIGHT)
#define VMEM_BASE (MEM_IO - VMEM_SIZE)

void check_config();
