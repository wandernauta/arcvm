#include "mem.h"

void setup_memory() {
    memset(m, 0, USERSPACE);

    if (VIDEO_ENABLED) {
        SDL_Init(SDL_INIT_VIDEO);
        screen = SDL_SetVideoMode(VIDEO_WIDTH * VIDEO_SCALE, VIDEO_HEIGHT * VIDEO_SCALE, 8, SDL_SWSURFACE);
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
        return 0;
    } else if (byteaddr > MEM_IO) {
        // Load from I/O address space
        if (TRACE_MEMORY) printf("ld io %u (+%u)\n", byteaddr, byteaddr - MEM_IO);

        switch (byteaddr) {
            case C_STAT:
                // Return all ones: everything is OK
                return 0xFFFFFFFF;
                break;
            case V_STAT:
                if (VIDEO_ENABLED) {
                    return 0xFFFFFFFF;
                } else {
                    return 0x00000000;
                }
                break;
            default:
                // Unknown or unreadable port
                break;
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

    switch (byteaddr) {
        case V_ADDR_X:
            xpos = val;
            break;
        case V_ADDR_Y:
            ypos = val;
            break;
        default:
            stb(byteaddr+0, (uval>>0) & 0xff);
            stb(byteaddr+1, (uval>>8) & 0xff);
            stb(byteaddr+2, (uval>>16) & 0xff);
            stb(byteaddr+3, (uval>>24) & 0xff);
            break;
    }
}

void stb(uint32_t byteaddr, uint8_t byte) {
    if (TRACE_MEMORY) printf("st %d=%02x -> %u\n", byte, byte, byteaddr);

    if (byteaddr < MEM_OS) {
        // Store to system memory.
        return;
    } else if (byteaddr < MEM_IO) {
        // Store to user space.
        m[byteaddr] = byte;
    } else if (byteaddr >= MEM_IO) {
        // Store to input/output mapping
        
        switch (byteaddr) {
            case C_OUT:
                putchar(byte);
                break;
            case V_COLOR:
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

                break;
            case V_CMD:
                SDL_Flip(screen);
                break;
            default:
                // Unknown I/O device
                break;
        }

        return;
    } else {
        assert(false);
        return;
    }
}
