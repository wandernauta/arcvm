#pragma once
//
// arcvm.h
// Sets up memory and state for arcvm.
//
// Copyright (C) 2012, 2013 Wander Nauta
// This file is distributed under the MIT license - see LICENSE.mkd.
//

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
