#ifndef LIBGFX
#define LIBGFX

#include "liblib.arc"
#include "libdev.arc"

! 
! libgfx
! ------
! 
! The libgfx library provides higher-level subroutines and utilities for using the virtual display.
! 

.macro gfxx reg
    ld [MEM_IO], %r1
    st reg, [%r1+V_ADDR_X]
.endmacro

.macro gfxy reg
    ld [MEM_IO], %r1
    st reg, [%r1+V_ADDR_Y]
.endmacro

.macro gfxpixel reg
    stb reg, [%r1+V_COLOR]
.endmacro

#endif
