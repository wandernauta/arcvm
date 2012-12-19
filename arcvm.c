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

    if (VIDEO_ENABLED) {
        SDL_Init(SDL_INIT_VIDEO);
        screen = SDL_SetVideoMode(640, 480, 8, SDL_SWSURFACE);
    }

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
