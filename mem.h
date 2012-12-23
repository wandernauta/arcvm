#pragma once
//
// mem.h
// ARC memory subsystem implementation
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

#include <assert.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include "SDL.h"

#include "config.h"
#include "bit.h"

// 'Video memory'
static SDL_Surface* screen;

uint16_t xpos;
uint16_t ypos;

// User memory
static uint8_t m[USERSPACE];

void setup_memory();
int32_t load(uint32_t byte);
uint8_t ldb(uint32_t byte);
void store(uint32_t byte, int32_t val);
void stb(uint32_t byteaddr, uint8_t byte);
