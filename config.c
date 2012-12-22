#include "config.h"
#include "assert.h"

void check_config() {
    if (!CHECK_CONFIG) return;

    assert(NUM_REGS >= 1);
    assert(USERSPACE >= 1);
    assert(MEM_OS >= 0);
    assert(MEM_IO >= MEM_OS);

    assert(C_OUT);
    assert(C_STAT);
    assert(V_STAT);
    assert(V_COLOR);
    assert(V_CMD);
    assert(V_ADDR_X);
    assert(V_ADDR_Y);

    assert(VIDEO_WIDTH >= 1);
    assert(VIDEO_HEIGHT >= 1);
    assert(VIDEO_SCALE >= 1);
}

