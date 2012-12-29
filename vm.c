//
// vm.c
// Main instruction loop.
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//
#include "vm.h"

void panic(const char* msg) {
    fprintf(stderr, "\n");
    fprintf(stderr, "** PANIC **\n");
    fprintf(stderr, "%s (pc %u)\n", msg, pc);
    fprintf(stderr, "\n");
    exit(EXIT_FAILURE);
}

void setup_registers() {
    r = calloc(NUM_REGS, sizeof(int32_t));
}

bool condition(uint32_t cond) {
    switch (cond) {
        case 0:  return false;                                      // bn: Branch never
        case 1:  return (psr & Z);                                  // be: Branch equal
        case 2:  return (psr & Z || ((psr & N) ^ (psr & V)));       // ble: Branch less or equal
        case 3:  return ((psr & N) ^ (psr & V));                    // bl: Branch less
        case 4:  return (psr & C || psr & Z);                       // bleu: Branch less or equal unsigned
        case 5:  return (psr & C);                                  // bcs: Branch carry set
        case 6:  return (psr & N);                                  // bneg: Branch negative
        case 7:  return (psr & V);                                  // bvs: Branch overflow set
        case 8:  return true;                                       // ba: Branch always
        case 9:  return (!(psr & Z));                               // bne: Branch not equal
        case 10: return (!(psr & Z || ((psr & N) ^ (psr & V))));    // bg: Branch greater than
        case 11: return (!((psr & N) ^ (psr & V)));                 // bge: Branch greater than equal
        case 12: return (!(psr & C || psr & Z));                    // bgu: Branch greater than unsigned
        case 13: return (!(psr & C));                               // bcc: Branch carry clear
        case 14: return (!(psr & N));                               // bpos Branch positive
        case 15: return (!(psr & V));                               // bvc: Branch overflow clear
        default: panic("Unknown branch condition");
    }

    return true;
}

// Sign function: returns -1, 0, or 1 if the value is neg., zero or pos.
int sign(int32_t x) {
    if (x > 0) return 1;
    if (x < 0) return -1;
    return 0;
}

void cc(int32_t result, int32_t a, int32_t b) {
    // Update condition codes
    psr = 0;
    if (result < 0) psr |= N;
    if (result == 0) psr |= Z;
    if (result << 31) psr |= C;

    if (sign(a) == sign(b) && sign(result) != sign(a)) {
        // Overflow is only possible when both operands are the same sign. If
        // that is the case, and the result has a different sign, overflow has
        // occurred.
        psr |= V;
    }

    if (TRACE_INSTRS) {
        printf("Update cc for result %d, a %d, b %d: ", result, a, b);

        if (psr & N) printf(" N");
        if (psr & Z) printf(" Z");
        if (psr & V) printf(" V");
        if (psr & C) printf(" C");

        printf("\n");
    }
}

int arcvm() {
    SDL_Event event;
    bool running = true;

    SDL_WM_SetCaption("arcvm (Running)", NULL);

    while (running) {
        while(SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_KEYDOWN:
                    if (event.key.keysym.sym == SDLK_ESCAPE) {
                        exit(0);
                    } else {
                        handle_key(event.key.keysym.unicode);
                    }
                    break;
                case SDL_QUIT:
                    exit(0);
            }
        }

        clks++;

        // Reset r[0] register
        r[0] = 0;

        if (pc >= (uint32_t)USERSPACE * 1024) {
            panic("Runaway program counter");
        }

        // Fetch and split instruction
        uint32_t inst = load(pc);

        uint32_t op1 = (inst >> 30);
        uint32_t op2 = (inst << 7) >> 29;
        uint32_t op3 = (inst << 7) >> 26;
        uint32_t rd = (inst << 2) >> 27;
        int32_t a = (inst << 13) >> 27;
        uint32_t cond = (inst << 3) >> 28;

        uint32_t si22 = ((inst << 10) >> 10);

        // i22 is signed - correct it
        int32_t i22 = (int32_t)((inst << 10) >> 10);
        if (i22 & (1 << 21)) i22 |= (0xFFFFFFFF << 22);

        // Get either rs2 or simm13 as b
        int32_t b = 0;
        if (inst & (1 << 13)) {
            // Fetch as simm13
            if (inst & (1 << 12)) {
                b = ((-1 & 0x1FFF) & inst) | (-1 << 13);
            } else {
                b = inst & 0x1FFF;
            }
        } else {
            b = r[inst & 0x1F];
        }

        if (TRACE_INSTRS) {
            printf("pc %d inst %08x op1 %u op2 %u op3 %u rd %u \n", pc, inst, op1, op2, op3, rd);
        }

        // Decode and execute instruction
        switch(op1) {
            case 3:
                // ld or st
                if (false) {}
                uint32_t addr = r[a] + b;

                switch(op3) {
                    case 0:
                        // ld
                        // Loads a word.
                        if (addr % WORD != 0) panic("Maligned word (ld)");
                        r[rd] = load(addr);
                        break;
                    case 1:
                        // ldub
                        // Loads an unsigned byte (zero-pads).
                        r[rd] = ldb(addr);
                        break;
                    case 9:
                        // ldsb
                        // Loads a signed byte (sign-extends).
                        r[rd] = (int8_t)ldb(addr);
                        break;
                    case 2:
                        // lduh
                        // Loads an unsigned halfword (zero-pads)
                        if (addr % HALFWORD != 0) panic("Maligned halfword (ld)");
                        r[rd] = load(addr);
                        r[rd] = (uint32_t)(r[rd]) >> 16;
                        break;
                    case 10:
                        // ldsh
                        // Loads a signed halfword (sign-extends).
                        if (addr % HALFWORD != 0) panic("Maligned halfword (ld)");
                        r[rd] = load(addr);
                        r[rd] = r[rd] >> 16;
                        break;
                    case 4:
                        // st
                        // Stores a word.
                        store(addr, r[rd]);
                        break;
                    case 5:
                        // stb
                        // Stores a byte.
                        stb(addr, (uint8_t)(r[rd]));
                        break;
                    case 6:
                        // sth
                        stb(addr, (uint8_t)(r[rd] >> 0));
                        stb(addr+1, (uint8_t)(r[rd] >> 8));
                        break;
                    default:
                        if (inst == 0xFFFFFFFF) {
                            // halt
                            running = false;
                        } else {
                            // unknown memory instruction
                            panic("Unknown memory-class instruction");
                            break;
                    }
                }
                break;
                case 2:
                    // arithmetic and logical

                    switch (op3) {
                      case 0 + 16:
                        // addcc
                        r[rd] = r[a] + b;
                        cc(r[rd], r[a], b);
                        break;
                      case 0:
                        // add
                        r[rd] = r[a] + b;
                        break;
                      case 1 + 16:
                        // andcc
                        r[rd] = r[a] & b;
                        cc(r[rd], r[a], b);
                        break;
                      case 1:
                        // and
                        r[rd] = r[a] & b;
                        break;
                      case 2 + 16:
                        // orcc
                        r[rd] = r[a] | b;
                        cc(r[rd], r[a], b);
                        break;
                      case 2:
                        // or
                        r[rd] = r[a] | b;
                        break;
                      case 3 + 16:
                        // xorcc
                        r[rd] = r[a] ^ b;
                        cc(r[rd], r[a], b);
                        break;
                      case 3:
                        // xor
                        r[rd] = r[a] ^ b;
                        break;
                      case 4 + 16:
                        // subcc
                        r[rd] = r[a] - b;
                        cc(r[rd], r[a], b);
                        break;
                      case 4:
                        // sub
                        r[rd] = r[a] - b;
                        break;
                      case 5 + 16:
                        // andncc
                        r[rd] = r[a] & ~b;
                        cc(r[rd], r[a], b);
                        break;
                      case 5:
                        // andn
                        r[rd] = r[a] & ~b;
                        break;
                      case 6 + 16:
                        // orncc
                        r[rd] = r[a] | ~b;
                        cc(r[rd], r[a], b);
                        break;
                      case 6:
                        // orn
                        r[rd] = r[a] | ~b;
                        break;
                      case 7 + 16:
                        // xnorcc
                        r[rd] = r[a] ^ ~b;
                        cc(r[rd], r[a], b);
                        break;
                      case 7:
                        // xnor
                        r[rd] = r[a] ^ ~b;
                        break;
                      case 37:
                        // sll
                        r[rd] = (uint32_t)r[a] << (uint32_t)b;
                        break;
                      case 38:
                        // srl
                        r[rd] = (uint32_t)r[a] >> (uint32_t)b;
                        break;
                      case 39:
                        // sra
                        r[rd] = r[a] >> b;
                        break;
                      case 56:
                        // jmpl
                        r[rd] = pc;
                        pc = r[a] + b;
                        continue;
                        break;
                      case 58:
                        // ta
                        panic("Trap instruction reached");
                        break;
                      default:
                        // unknown instruction
                        panic("Unknown arithmetic instruction");
                        break;
                      }
                    break;
                case 1:
                    // call
                    if (false) {}
                    uint32_t dest = (uint32_t)inst << 2;
                    r[15] = pc;
                    pc += dest;
                    continue;
                    break;
                case 0:
                    // sethi or branch
                    if (op2 == 4) {
                        // sethi
                        r[rd] = 0;
                        r[rd] |= (si22 << 10);
                    } else {
                        if (condition(cond)) {
                            pc += 4 * i22;
                            continue;
                        }
                    }
                    break;
                default:
                    panic("Unknown instruction");
            }

        pc += WORD;
    }

    if (PRINT_SUMMARY) {
        printf("\n   SUMMARY\n");
        printf(" - Halted after %d cycles, %d host clocks.\n", clks, (int)clock());

        for (int32_t i = 0; i < NUM_REGS; i++) {
            if (r[i] != 0) {
                printf(" - %%r%d = %d = %08x\n", i, r[i], r[i]);
            }
        }

        printf("\n");
    }

    if (VIDEO_ENABLED) {
        // The simulation has ended. Keep showing the last frame until the user
        // presses a key (useful for programs that produce a single image)

        SDL_WM_SetCaption("arcvm (Finished)", NULL);
        while (true) {
            SDL_Delay(0);
            SDL_WaitEvent(&event);
            switch (event.type) {
                case SDL_KEYDOWN:
                case SDL_QUIT:
                    exit(0);
            }
        }
    }

    return 0;
}
