//
// vm.c
// Main instruction loop.
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//
#include "vm.h"

void setup_registers() {
    for (uint32_t i = 0; i < NUM_REGS; i++) {
        r[i] = 0;
    }
}

bool condition(uint32_t cond) {
    switch (cond) {
        case 0:  return false; // bn: Branch never
        case 1:  return (psr & Z); // be: Branch equal
        case 2:  return (psr & Z || ((psr & N) ^ (psr & V))); // ble: Branch less or equal
        case 3:  return ((psr & N) ^ (psr & V)); // bl: Branch less
        case 4:  return (psr & C || psr & Z); // bleu: Branch less or equal unsigned
        case 5:  return (psr & C); // bcs: Branch carry set
        case 6:  return (psr & N); // bneg: Branch negative
        case 7:  return (psr & V); // bvs: Branch overflow set
        case 8:  return true; // ba: Branch always
        case 9:  return (!(psr & Z)); // bne: Branch not equal
        case 10: assert(false); // bg
        case 11: assert(false); // bge
        case 12: assert(false); // bgu
        case 13: return (!(psr & C)); // bcc: Branch carry clear
        case 14: return (!(psr & N)); // bpos Branch positive
        case 15: return (!(psr & V)); // bvc: Branch overflow clear
        default: assert(false); // Unknown branch
    }
}

void cc(int32_t val) {
    // Update condition codes
    psr = 0;
    if (val < 0) psr |= N;
    if (val == 0) psr |= Z;
    if (val << 31) psr |= C;

    if (TRACE_INSTRS) printf("Update cc for val %d\n", val);
}

int arcvm() {
    SDL_Event event;
    bool running = true;

    while (running) {
        while(SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_QUIT:
                    exit(0);
            }
        }

        clks++;

        // Reset r[0] register
        r[0] = 0;

        // Fetch and split instruction
        assert(pc < USERSPACE);
        uint32_t inst = load(pc);

        uint32_t op1 = (inst >> 30);
        uint32_t op2 = (inst << 7) >> 29;
        uint32_t op3 = (inst << 7) >> 26;
        uint32_t rd = (inst << 2) >> 27;
        uint32_t a = (inst << 13) >> 27;
        uint32_t cond = (inst << 3) >> 28;

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
                        if (addr % WORD != 0) assert(false);
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
                        if (addr % HALFWORD != 0) assert(false);
                        r[rd] = load(addr);
                        r[rd] = (uint32_t)(r[rd]) >> 16;
                        break;
                    case 10:
                        // ldsh
                        // Loads a signed halfword (sign-extends).
                        if (addr % HALFWORD != 0) assert(false);
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
                            // unknown
                            assert(false);
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
                        r[rd] = r[a] | b;
                        break;
                      case 3 + 16:
                        // xorcc
                        r[rd] = r[a] ^ b;
                        cc(r[rd]);
                        break;
                      case 3:
                        // xor
                        r[rd] = r[a] ^ b;
                        break;
                      case 4 + 16:
                        // subcc
                        r[rd] = r[a] - b;
                        cc(r[rd]);
                        break;
                      case 4:
                        // sub
                        r[rd] = r[a] - b;
                        break;
                      case 5 + 16:
                        // andncc
                        r[rd] = r[a] & ~b;
                        cc(r[rd]);
                        break;
                      case 5:
                        // andn
                        r[rd] = r[a] & ~b;
                        break;
                      case 6 + 16:
                        // orncc
                        assert(false);
                        cc(r[rd]);
                        break;
                      case 6:
                        // orn
                        assert(false);
                        break;
                      case 7 + 16:
                        // xnorcc
                        assert(false);
                        cc(r[rd]);
                        break;
                      case 7:
                        // xnor
                        assert(false);
                        break;
                      case 38:
                        // srl
                        r[rd] = r[a] >> b;
                        break;
                      case 56:
                        // jmpl
                        r[rd] = pc;
                        pc = r[a] + b;
                        continue;
                        break;
                      default:
                        // unknown
                        assert(false);
                        break;
                      }
                    break;
                case 1:
                    // call
                    if (false) {}
                    uint32_t dest = (uint32_t)inst << 2;
                    r[15] = pc;
                    pc += dest;
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
                        }
                    }
                    break;
                default:
                assert(false);
            }

        pc += WORD;
    }

    if (PRINT_SUMMARY) {
        printf("\n   SUMMARY\n");
        printf(" - Halted after %d cycles, %d host clocks.\n", clks, (int)clock());

        for (uint32_t i = 0; i < NUM_REGS; i++) {
            if (r[i] != 0) {
                printf(" - %%r%d = %d = %08x\n", i, r[i], r[i]);
            }
        }

        printf("\n");
    }

    while (true) {
        SDL_WaitEvent(&event);
        switch (event.type) {
            case SDL_KEYDOWN:
            case SDL_QUIT:
                exit(0);
        }
    }

    return 0;
}
