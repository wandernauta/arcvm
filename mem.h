#pragma once

#include <assert.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include "SDL.h"

#include "config.h"

// 'Video memory'
static SDL_Surface* screen;

// User memory
static uint8_t m[USERSPACE];

void setup_memory();
int32_t load(uint32_t byte);
void store(uint32_t byte, int32_t val);
void stb(uint32_t byteaddr, uint8_t byte);
