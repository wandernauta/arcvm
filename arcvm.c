/*
 * arcvm.c
 * A RISC Computer Virtual Machine
 * 
 * Copyright (c) 2012, Wander Nauta
 * 
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "arcvm.h"

int32_t* r;         // General-purpose registers
uint8_t* m;         // User space memory
uint32_t pc = 2048; // Program counter
uint32_t psr = 0x0; // Processor status register
uint32_t clks = 0;  // Clock counter

// Masks for the PSR
const uint32_t N = 1 << 23; // Negative
const uint32_t Z = 1 << 22; // Zero
const uint32_t V = 1 << 21; // oVerflow
const uint32_t C = 1 << 20; // Carry

SDL_Surface* screen;

uint32_t swap32(uint32_t val) {
    return ((val & 0xFF) << 24)
           | ((val & 0xFF00) << 8)
           | ((val >> 8) & 0xFF00)
           | ((val >> 24) & 0xFF);
}

void p(uint32_t val) {
    for (int k = 0; k < 32; k++) {
        putchar(val & 0x80000000 ? '1' : '0');
        val = val << 1;
    }
}

void setup_registers() {
    r = calloc(32, sizeof(uint32_t));
}

void setup_memory() {
    m = calloc(MEM_WORDS, sizeof(uint32_t));
}

void setup_video() {
    SDL_Init(SDL_INIT_VIDEO);
    screen = SDL_SetVideoMode(640, 480, 8, SDL_SWSURFACE);

    /*
    SDL_Event ev;

    SDL_LockSurface(screen);


    for (int x = 0; x < 256; x += 1) {
        for (int y = 0; y < 256; y++) {
            uint32_t color = SDL_MapRGB(screen->format, y % 256, x % 256, 0);
            Uint8 *bufp;
            bufp = (Uint8 *)screen->pixels + y*screen->pitch + x;
            *bufp = color;
        }
    }

    SDL_UnlockSurface(screen);
    SDL_UpdateRect(screen, 0, 0, 0, 0);
    

    while(1) {}
    exit(1);
    */
}

int32_t load(uint32_t wordaddr) {
    if (wordaddr < 2048) {
        printf("Load from system memory. Returning 0.");
        return 0;
    } else if (wordaddr > 2147483648) {
        printf("Load from I/O address space. Returning 0.");
        return 0;
    } else if (2048 <= wordaddr && wordaddr < 2147483648) {
        return m[wordaddr];
    } else {
        printf("WTF?");
        return 0;
    }
}

void store(uint32_t wordaddr, int32_t val) {
    m[wordaddr] = val;
    return;
}

void cc(int32_t val) {
    // Update condition codes
    psr = 0;
    if (val < 0) psr |= N;
    if (val == 0) psr |= Z;
}

int main(int argc, char** argv) {
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
    setup_video();

    // Ignore first hex
    uint32_t offset = 0;
    fscanf(in, "%x", &offset);

    // Load program into memory
    while (!feof(in)) {
        uint32_t byteaddr = 0;
        uint32_t val = 0;
        fscanf(in, "%x", &byteaddr);
        fscanf(in, "%x", &val);

        uint32_t addr = byteaddr / 4;
        
        assert(addr < MEM_WORDS);
        ((uint32_t*)m)[addr] = val;
    }

    // Dump memory
    /*
    for (int i = 0; i < MEM_WORDS; i++) {
        if (i % 8 == 0) {
            //("\n");
            //("%10d: ", i * 4);
        }
        //("%08x ", m[i]);
    }
    */

    SDL_Event event;
    bool running = true;

    while (running) {
        while ( SDL_PollEvent(&event) ) {
            switch (event.type) {
                case SDL_KEYDOWN:
                case SDL_QUIT:
                    exit(0);
            }
        }

        clks++;
        // Dump registers
       /*
        for (int i = 0; i < 32; i++) {
            printf("%x ", r[i]);
        }
        printf("\n");*/

        r[0] = 0;

        if (pc/4 >= MEM_WORDS) {
            fprintf(stderr, "Program counter out of bounds. Exiting.\n");
            exit(EXIT_FAILURE);
        }
        // Fetch and split instruction
        uint32_t inst = ((uint32_t*)m)[pc/4];
        uint32_t op1 = (inst >> 30);
        uint32_t op2 = (inst << 7) >> 29;
        uint32_t op3 = (inst << 7) >> 26;
        uint32_t rd = (inst << 2) >> 27;
        uint32_t a = (inst << 13) >> 27;
        uint32_t cond = (inst << 3) >> 28;

        //printf("%08x\n", inst);

        uint32_t si22 = ((inst << 10) >> 10);

        // i22 is signed - correct it
        int32_t i22 = (int32_t)((inst << 10) >> 10);
        if (i22 & (1 << 21)) i22 |= (0xFFFFFFFF << 22);

        // Get either rs2 or simm13 as b
        uint32_t b = 0;
        if (inst & (1 << 13)) {
            // Fetch as simm13
            if (inst & (1 << 12)) {
                b = ((-1 & 0x1FFF) & inst) | (-1 << 13);
            } else {
                b = inst & 0x1FFF;
            }
            //b = inst & 0x1FFF;
            //b= -1;
        } else {
            b = r[inst & 0x1F];
        }
        printf("B from inst ");
        p(inst);
        printf(" equals ");
        p(b);
        printf("\n");

        // Decode and execute instruction
        if (op1 == 3) {
            // ld or st
            switch(op3) {
                case 0:
                    // ld
                    printf("ld\n");
                    r[rd] = load(r[a] + b);
                    break;
                case 1:
                    // ldub
                    printf("ldub a %d=%d b %d d %d \n", a, r[a], b, rd);
                    uint8_t byte = ((int8_t*)m)[r[a]+b];
                    uint32_t val = byte;
                    r[rd] = val;
                    break;
                case 9:
                    // ldsb
                    printf("ldsb\n");
                    break;
                case 2:
                    // lduh
                    printf("lduh\n");
                    break;
                case 10:
                    // ldsh
                    printf("ldsh\n");
                    break;
                case 4:
                    // st
                    printf("st\n");
                    m[r[a]+b] = r[rd];
                    break;
                case 5:
                    // stb
                    printf("stb\n");
                    ((int8_t*)m)[r[a]+b] = (int8_t)r[rd];
                    break;
                case 6:
                    // sth
                    printf("sth\n");
                    break;
                default:
                    if (inst == 0xFFFFFFFF) {
                        // halt
                        running = false;
                    } else {
                        // unknown
                        printf("%d: Unknown instruction (op3=%d) ", pc, op3);
                        p(inst);
                        printf("\n");
                        break;
                    }
            }
        } else if (op1 == 2) {
            // arithmetic and logical

            switch (op3) {
              case 0 + 16:
                // addcc
                r[rd] = r[a] + b;
                cc(r[rd]);
                break;
              case 0:
                // add
                r[rd] = r[a] + b;
                break;
              case 1 + 16:
                // andcc
                r[rd] = r[a] & b;
                cc(r[rd]);
                break;
              case 1:
                // and
                r[rd] = r[a] & b;
                break;
              case 2 + 16:
                // orcc
                r[rd] = r[a] | b;
                cc(r[rd]);
                break;
              case 2:
                // or
                if (rd != 0) r[rd] = r[a] | b;
                break;
              case 3 + 16:
                // xorcc
                if (rd != 0) r[rd] = r[a] ^ b;
                cc(r[rd]);
                break;
              case 3:
                // xor
                if (rd != 0) r[rd] = r[a] ^ b;
                break;
              case 4 + 16:
                // subcc
                if (rd != 0) r[rd] = r[a] ^ b;
                cc(r[rd]);
                break;
              case 4:
                // sub
                break;
              case 5 + 16:
                // andncc
                cc(r[rd]);
                break;
              case 5:
                // andn
                break;
              case 6 + 16:
                // orncc
                cc(r[rd]);
                break;
              case 6:
                // orn
                break;
              case 7 + 16:
                // xnorcc
                cc(r[rd]);
                break;
              case 7:
                // xnor
                break;
              case 38:
                // srl
                if (rd != 0) r[rd] = r[a] >> b;
                break;

              default:
                // unknown
                break;
              }
        } else if (op1 == 1) {
            // call
        } else if (op1 == 0) {
            // sethi or branch
            if (op2 == 4) {
                // sethi
                r[rd] = 0;
                r[rd] |= (si22 << 10);
            } else {
                switch (cond) {
                  case 0:
                    // bn: Branch never
                    break;
                  case 1:
                    // be: Branch equal
                    if (psr & Z) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 2:
                    // ble: Branch less or equal
                    if (psr & Z || ((psr & N) ^ (psr & V))) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 3:
                    // bl: Branch less
                    if ((psr & N) ^ (psr & V)) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 4:
                    // bleu: Branch less or equal unsigned
                    if (psr & C || psr & Z) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 5:
                    // bcs: Branch carry set
                    if (psr & C) {
                        pc += 4 * i22;
                        continue;
                    }
                    continue;
                    break;
                  case 6:
                    // bneg; Branch negative
                    if (psr & N) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 7:
                    // bvs: Branch overflow set
                    if (psr & V) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 8:
                    // ba: Branch always
                    pc += 4 * i22;
                    continue;
                    break;
                  case 9:
                    // bne: Branch not equal
                    if (!(psr & Z)) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 10:
                    // bg
                    break;
                  case 11:
                    // bge
                    break;
                  case 12:
                    // bgu
                    break;
                  case 13:
                    // bcc
                    if (!(psr & C)) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 14:
                    // bpos
                    if (!(psr & N)) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  case 15:
                    // bvc
                    if (!(psr & V)) {
                        pc += 4 * i22;
                        continue;
                    }
                    break;
                  default:
                    // ?;
                    break;
                  }
                }
            } else {
            }

        pc += 4;
    }

    printf("-- Finished after %d cycles, %d clocks.\n", clks, (int)clock());

    return 0;
}
