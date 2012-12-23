#ifndef LIBCOL
#define LIBCOL

#include "liblib.arc"

! 
! libcol
! ------
! 
! The libcol library provides assemble-time constants that expand to 8-bit
! color values. The color values can be written to the screen directly.
! 

    .begin

    BLACK .equ 0
    BLUE .equ 3
    BROWN .equ 164
    CYAN .equ 191
    GREEN .equ 28
    MAROON .equ 32
    NAVY .equ 1
    OLIVE .equ 132
    ORANGE .equ 236
    PINK .equ 227
    RED .equ 224
    WHITE .euq 255
    YELLOW .equ 252

    .end

#endif
