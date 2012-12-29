#include "mem.h"
#include "vm.h"

//
// mem.c
// ARC memory subsystem implementation
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

void setup_memory() {
    m = calloc(USERSPACE, 1024);

    if (VIDEO_ENABLED) {
        SDL_Init(SDL_INIT_VIDEO);
        screen = SDL_SetVideoMode(VIDEO_WIDTH * VIDEO_SCALE, VIDEO_HEIGHT * VIDEO_SCALE, 8, SDL_HWSURFACE | SDL_DOUBLEBUF);
                SDL_EnableUNICODE( 1 );
        assert(screen);
    }
}

int32_t load(uint32_t byteaddr) {
    uint32_t wordaddr = byteaddr / 4;
    assert (byteaddr % 4 == 0);

    if (TRACE_MEMORY) printf("ld %u\n", byteaddr);

    if (MEM_OS <= byteaddr && byteaddr < MEM_IO && byteaddr < (uint32_t)USERSPACE*1024) {
        // Load from user space
        return ((int32_t*)m)[wordaddr];
    } else if (byteaddr < MEM_OS) {
        // Load from system memory
        return 0;
    } else if (byteaddr > MEM_IO) {
        // Load from I/O address space
        if (TRACE_MEMORY) printf("ld io %u (+%u)\n", byteaddr, byteaddr - MEM_IO);

        if (byteaddr == C_STAT) {
            // Return all ones: everything is OK
            return 0xFFFFFFFF;
        } else if (byteaddr == C_ICTL) {
            // Return all ones: alll good
            SDL_Delay(0);

            if (key == 0) {
                return 0;
            } else {
                return 0xFFFFFFFF;
            }
        } else if (byteaddr == V_STAT) {
            if (VIDEO_ENABLED) {
                return 0xFFFFFFFF;
            } else {
                return 0x00000000;
            }
        } else if (byteaddr == C_IN) {
            int k = key;
            key = 0;
            return k;
        } else {
            // unknown
            panic("Access of unknown I/O device");
        }
    } else {
        panic("Load from unknown address");
    }
    return 0;
}

uint8_t ldb(uint32_t byteaddr) {
    // Byte-swap the correct word
    if (TRACE_MEMORY) {
        printf("ld b addr: %u word: %u ", byteaddr, byteaddr - (byteaddr % 4));
    }

    int32_t word = load(byteaddr - (byteaddr % 4));

    if (TRACE_MEMORY) {
        print32(word);
        printf(" ");
    }

    int32_t sword = swap32(word);

    if (TRACE_MEMORY) {
        print32(sword);
        printf("\n");
    }

    return ((char*)&sword)[byteaddr % 4];
}

void store(uint32_t byteaddr, int32_t val) {
    uint32_t wordaddr = byteaddr / 4;
    uint32_t uval = (uint32_t)val;

    if (TRACE_MEMORY) printf("st %d=%08x -> %u\n", val, val, byteaddr);

    if (byteaddr == V_ADDR_X) {
        xpos = val;
    } else if (byteaddr == V_ADDR_Y) {
        ypos = val;
    } else {
        stb(byteaddr+0, (uval>>0) & 0xff);
        stb(byteaddr+1, (uval>>8) & 0xff);
        stb(byteaddr+2, (uval>>16) & 0xff);
        stb(byteaddr+3, (uval>>24) & 0xff);
    }
}

void stb(uint32_t byteaddr, uint8_t byte) {
    if (TRACE_MEMORY) printf("st %d=%02x -> %u\n", byte, byte, byteaddr);

    if (byteaddr < MEM_OS) {
        // Store to system memory.
        return;
    } else if (byteaddr < MEM_IO && byteaddr < (uint32_t)USERSPACE*1024) {
        // Store to user space.
        m[byteaddr] = byte;
    } else if (byteaddr >= MEM_IO) {
        // Store to input/output mapping

        if (byteaddr == C_OUT) {
            putchar(byte);
            fflush(stdout);
        } else if (byteaddr == V_COLOR) {
            if (false) {}
            uint8_t* p = screen->pixels;

            uint32_t px = xpos * VIDEO_SCALE;
            uint32_t py = ypos * VIDEO_SCALE;

            SDL_Rect rect;
            rect.x = px;
            rect.y = py;
            rect.w = VIDEO_SCALE;
            rect.h = VIDEO_SCALE;
            SDL_FillRect(screen, &rect, byte);

            if (TRACE_MEMORY) printf("px x: %u y: %u b: %u (%02x)\n", xpos, ypos, byte, byte);
        } else if (byteaddr == V_CMD) {
            SDL_Flip(screen);
        } else {
            // Unknown I/O device
        }
        
        return;
    } else {
        panic("Store (stb) to unknown address");
        return;
    }
}

void handle_key(int k) {
    key = k;
}
