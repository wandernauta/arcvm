#include "mem.h"

void setup_memory() {
    memset(m, 0, USERSPACE);

    if (VIDEO_ENABLED) {
        SDL_Init(SDL_INIT_VIDEO);
        screen = SDL_SetVideoMode(VIDEO_WIDTH * VIDEO_SCALE, VIDEO_HEIGHT * VIDEO_SCALE, VIDEO_BPP, SDL_SWSURFACE|SDL_DOUBLEBUF);
        assert(screen);
    }
}

int32_t load(uint32_t byteaddr) {
    uint32_t wordaddr = byteaddr / 4;

    if (TRACE_MEMORY) printf("ld %u\n", byteaddr);

    if (MEM_OS <= byteaddr && byteaddr < MEM_IO) {
        // Load from user space
        return ((int32_t*)m)[wordaddr];
    } else if (byteaddr < MEM_OS) {
        // Load from system memory
        if (TRACE_MEMORY) printf("ld sys %u\n", byteaddr);
        return 0;
    } else if (byteaddr > MEM_IO) {
        // Load from I/O address space
        if (TRACE_MEMORY) printf("ld io %u (+%u)\n", byteaddr, byteaddr - MEM_IO);

        if (byteaddr == MEM_IO + COUT) {
            if (TRACE_MEMORY) printf("ld io cout\n");
        } else if (byteaddr == MEM_IO + COSTAT) {
            if (TRACE_MEMORY) printf("ld io costat\n");
            return 0xFFFFFFFF;
        }
    } else {
        assert(false);
    }
    return 0;
}

void store(uint32_t byteaddr, int32_t val) {
    uint32_t wordaddr = byteaddr / 4;
    uint32_t uval = (uint32_t)val;

    if (TRACE_MEMORY) printf("st %d=%08x -> %u\n", val, val, byteaddr);

    stb(byteaddr+0, (uval>>0) & 0xff);
    stb(byteaddr+1, (uval>>8) & 0xff);
    stb(byteaddr+2, (uval>>16) & 0xff);
    stb(byteaddr+3, (uval>>24) & 0xff);
}

void stb(uint32_t byteaddr, uint8_t byte) {
    if (TRACE_MEMORY) printf("st %d=%02x -> %u\n", byte, byte, byteaddr);

    if (byteaddr < MEM_OS) {
        // Store to system memory.
        return;
    } else if (byteaddr < VMEM_BASE) {
        // Store to user space.
        m[byteaddr] = byte;
    } else if (byteaddr < MEM_IO) {
        // Store to video output.
        assert(screen);

        //if (SDL_MUSTLOCK(screen)) SDL_LockSurface(screen);

        const uint32_t off = byteaddr - VMEM_BASE;
        const uint32_t lx = off % VIDEO_WIDTH;
        const uint32_t ly = off / VIDEO_WIDTH;

        const uint32_t px = lx * VIDEO_SCALE;
        const uint32_t py = ly * VIDEO_SCALE;

        uint8_t* p = screen->pixels;

        for (int x = 0; x < VIDEO_SCALE; x++) {
            for (int y = 0; y < VIDEO_SCALE; y++) {
                *(p + ((py + y) * VIDEO_WIDTH * VIDEO_SCALE) + px + x) = byte;
            }
        }

        //if (SDL_MUSTLOCK(screen)) SDL_UnlockSurface(screen);
        SDL_UpdateRect(screen, px, py, VIDEO_SCALE, VIDEO_SCALE);
        return;
    } else if (byteaddr == MEM_IO + COUT) {
        putchar(byte);
        return;
    } else {
        assert(false);
        return;
    }
}
