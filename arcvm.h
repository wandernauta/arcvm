#pragma once

// Header includes
#include <assert.h>
#include <time.h>
#include <iso646.h>
#include <netinet/in.h> // For endianness conversion
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "SDL.h"

// Configuration settings
#define MEM_WORDS 8 * 1024

// Utility macro's
#define toarc(x) htonl(x)
#define fromarc(x) ntohl(x)
