//
// arcvm.c
// Sets up memory and state for arcvm.
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

#include "arcvm.h"

int main(int argc, char** argv) {
    check_config();

    if (argc < 2) {
        fprintf(stderr, "Usage: ./arcvm <file.bin>\n");
        exit(EXIT_FAILURE);
    }

    FILE* in = fopen(argv[1], "r");

    if (!in) {
        fprintf(stderr, "Can't open file %s, exiting\n", argv[1]);
        exit(EXIT_FAILURE);
    }

    setup_registers();
    setup_memory();

    // Ignore first hex
    uint32_t offset = 0;
    fscanf(in, "%x", &offset);

    // Load program into memory
    while (!feof(in)) {
        uint32_t byteaddr = 0;
        uint32_t val = 0;

        int a = fscanf(in, "%x", &byteaddr);
        int b = fscanf(in, "%x", &val);

        if (byteaddr > 0 && byteaddr < USERSPACE) store(byteaddr, val);
    }

    arcvm();
}
