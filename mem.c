#include "mem.h"

void setup_memory() {
    memset(m, 0, USERSPACE);

    if (VIDEO_ENABLED) {
        SDL_Init(SDL_INIT_VIDEO);
        screen = SDL_SetVideoMode(VIDEO_WIDTH, VIDEO_HEIGHT, VIDEO_BPP, SDL_SWSURFACE);
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
        SDL_LockSurface(screen);
        Uint8 *p = (uint8_t*)screen->pixels + (byteaddr - VMEM_BASE);
        *p = byte;
        SDL_UnlockSurface(screen);
        SDL_UpdateRect(screen, 0, 0, 0, 0);
        return;
    } else if (byteaddr == MEM_IO + COUT) {
        putchar(byte);
        return;
    } else {
        assert(false);
        return;
    }
}
