#pragma once

#include <stdint.h>

#include "SDL.h"
#include <time.h>

#include "config.h"
#include "mem.h"
#include "bit.h"

static int32_t r[NUM_REGS];

static uint32_t pc = 2048; // Program counter
static uint32_t psr = 0x0; // Processor status register
static uint32_t clks = 0;  // Clock counter

// Masks for the PSR
static const uint32_t N = 1 << 23; // Negative
static const uint32_t Z = 1 << 22; // Zero
static const uint32_t V = 1 << 21; // oVerflow
static const uint32_t C = 1 << 20; // Carry

void setup_registers();
void cc(int32_t val);

static SDL_Surface* screen;

// Main loop
int arcvm();
