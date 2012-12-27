#ifndef LIBCON
#define LIBCON

#include "liblib.arc"
#include "libdev.arc"

! 
! libcon
! ------
! 
! The libcon library provides subroutines for outputting text.
! 

data(libcon)

! 
! **putc**: Writes a character (unsigned 8-bit) to the console.
! 
putc:   
        ld [MEM_IO], %r30
        ldub [%r30 + COSTAT], %r31
        andcc %r1, 0x80, %r31
        be putc
        stb %r3, [%r30 + COUT]
        ret

enddata(libcon)

#endif
