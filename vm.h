#pragma once
//
// vm.h
// Main instruction loop.
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

#include <stdint.h>

#include <time.h>
#include "SDL.h"

#include "config.h"
#include "mem.h"
#include "bit.h"

static int32_t* r;

static uint32_t pc = 2048; // Program counter
static uint32_t psr = 0x0; // Processor status register
static uint32_t clks = 0;  // Clock counter

// Masks for the PSR
static const uint32_t N = 1 << 23; // Negative
static const uint32_t Z = 1 << 22; // Zero
static const uint32_t V = 1 << 21; // oVerflow
static const uint32_t C = 1 << 20; // Carry

// Functions
void panic(const char* msg);
void setup_registers();
bool condition(uint32_t cond);
int sign(int32_t x);
void cc(int32_t result, int32_t a, int32_t b);
int arcvm();
