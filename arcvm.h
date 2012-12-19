#pragma once

// System includes
#include <assert.h>
#include <time.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

// Config include
#include "config.h"

// Project includes
#include "bit.h"
#include "mem.h"
#include "vm.h"

// Configuration settings
#define MEM_WORDS 8 * 1024

// Utility macro's
#define toarc(x) htonl(x)
#define fromarc(x) ntohl(x)
