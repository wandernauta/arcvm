#ifndef LIBGFX
#define LIBGFX

#include "liblib.arc"
#include "libdev.arc"

! 
! libgfx
! ------
! 
! The libgfx library provides higher-level subroutines and utilities for using the virtual display.
! These macros load the memory offset into register %r1.
! 

! 
! **gfxx**: Sets the video X cursor to the position given register
! 
.macro gfxx reg
    ld [MEM_IO], %r1
    st reg, [%r1+V_ADDR_X]
.endmacro

! 
! **gfxy**: Sets the video Y cursor to the position given register
! 
.macro gfxy reg
    ld [MEM_IO], %r1
    st reg, [%r1+V_ADDR_Y]
.endmacro

! 
! **gfxx**: Writes the color in the given register to the screen
! 
.macro gfxpixel reg
    ld [MEM_IO], %r1
    stb reg, [%r1+V_COLOR]
.endmacro

! 
! **gfxsync**: Updates the display
! 
.macro gfxsync
    ld [MEM_IO], %r1
    st %r0, [%r1+V_CMD]
.endmacro

#endif
