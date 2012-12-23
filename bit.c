#include "bit.h"
//
// bit.c
// Bit twiddling and manipulation
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

uint32_t swap32(uint32_t val) {
    return ((val & 0xFF) << 24)
           | ((val & 0xFF00) << 8)
           | ((val >> 8) & 0xFF00)
           | ((val >> 24) & 0xFF);
}

void print32(uint32_t val) {
    for (int k = 0; k < 32; k++) {
        putchar(val & 0x80000000 ? '1' : '0');
        val = val << 1;
    }
}
