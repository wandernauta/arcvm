#include "config.h"
#include "assert.h"

void check_config() {
    if (!CHECK_CONFIG) return;

    assert(NUM_REGS >= 1);
    assert(USERSPACE >= 1);
}
