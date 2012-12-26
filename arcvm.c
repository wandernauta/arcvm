//
// arcvm.c
// Sets up memory and state for arcvm.
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

#include "arcvm.h"

int main (int argc, char **argv) {
    static struct option long_options[] = {
       {"check-config", no_argument, &CHECK_CONFIG, 1},
       {"no-check-config", no_argument, &CHECK_CONFIG, 0},
       {"trace-memory", no_argument, &TRACE_MEMORY, 1},
       {"no-trace-memory", no_argument, &TRACE_MEMORY, 0},
       {"trace-instrs", no_argument, &TRACE_INSTRS, 1},
       {"no-trace-instrs", no_argument, &TRACE_INSTRS, 0},
       {"summary", no_argument, &PRINT_SUMMARY, 1},
       {"no-summary", no_argument, &PRINT_SUMMARY, 0},
       {"video", no_argument, &VIDEO_ENABLED, 1},
       {"no-video", no_argument, &VIDEO_ENABLED, 0},

       {"help", no_argument, 0, 'h'},
       {"version", no_argument, 0, 'V'},

       {0, 0, 0, 0}
    };
    /* getopt_long stores the option index here. */
    int option_index = 0;
    int opt = 0;

    while ((opt = getopt_long(argc, argv, "", long_options, &option_index)) != -1) {
        switch (opt) {
            case 0:
                continue;
            case 'h':
                printf("Usage: ./arcvm <file.bin>\n");
                printf("\n");
                printf(" --check-config     do sanity checks\n");
                printf(" --no-check-config  skip sanity checks\n");
                printf(" --trace-memory     trace memory accesses\n");
                printf(" --no-trace-memory  don't trace memory\n");
                printf(" --trace-instrs     trace all instructions\n");
                printf(" --no-trace-instrs  skip instruction traces\n");
                printf(" --summary          print a post-run summary\n");
                printf(" --no-summary       don't print a post-run\n");
                printf(" --video            enable video\n");
                printf(" --no-video         disable video\n");
                printf("\n");
                exit(EXIT_SUCCESS);
            case 'V':
                printf("arcvm %d.%d\n", MAJOR, MINOR);
                exit(EXIT_SUCCESS);
            case '?':
                break;
            default:
                abort();
        }
    }

    check_config();

    if (optind >= argc) {
        fprintf(stderr, "Usage: ./arcvm <file.bin>\n");
        exit(EXIT_FAILURE);
    }

    FILE* in = fopen(argv[optind], "r");

    if (!in) {
        fprintf(stderr, "Can't open file %s, exiting\n", argv[optind]);
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

        if (byteaddr > 0 && byteaddr < (uint32_t)USERSPACE * 1024) store(byteaddr, val);
    }

    arcvm();
}
