#include "vm.h"

void panic() {
    fprintf(stderr, "!! PANIC !!\nPC %d", pc);
}

void setup_registers() {
    for (uint32_t i = 0; i < NUM_REGS; i++) {
        r[i] = 0;
    }
}

void cc(int32_t val) {
    // Update condition codes
    psr = 0;
    if (val < 0) psr |= N;
    if (val == 0) psr |= Z;
}

int arcvm() {
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

        // Reset r[0] register
        r[0] = 0;

        // Fetch and split instruction
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
            printf("pc %d inst %08x\n", pc, inst);
        }

        // Decode and execute instruction
        if (op1 == 3) {
            // ld or st
            uint32_t addr = r[a] + b;

            switch(op3) {
                case 0:
                    // ld
                    // Loads a word.
                    if (addr % WORD != 0) panic();
                    r[rd] = load(addr);
                    break;
                case 1:
                    // ldub
                    // Loads an unsigned byte (zero-pads).
                    r[rd] = load(addr);
                    r[rd] = (uint32_t)(r[rd]) >> 24;
                    break;
                case 9:
                    // ldsb
                    // Loads a signed byte (sign-extends).
                    r[rd] = load(addr);
                    r[rd] = r[rd] >> 24;
                    break;
                case 2:
                    // lduh
                    // Loads an unsigned halfword (zero-pads)
                    if (addr % HALFWORD != 0) panic();
                    r[rd] = load(addr);
                    r[rd] = (uint32_t)(r[rd]) >> 16;
                    break;
                case 10:
                    // ldsh
                    // Loads a signed halfword (sign-extends).
                    if (addr % HALFWORD != 0) panic();
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
                    break;
                default:
                    if (inst == 0xFFFFFFFF) {
                        // halt
                        running = false;
                    } else {
                        // unknown
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

        pc += WORD;
    }

    if (PRINT_SUMMARY) {
        printf("\n   SUMMARY\n");
        printf(" - Halted after %d cycles, %d clocks.\n", clks, (int)clock());

        for (uint32_t i = 0; i < NUM_REGS; i++) {
            if (r[i] != 0) {
                printf(" - %%r%d = %d = %08x\n", i, r[i], r[i]);
            }
        }

        printf("\n");
    }

    return 0;
}
