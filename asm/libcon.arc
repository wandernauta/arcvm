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

putc:   
        ld [MEM_IO], %r4
        ldub [%r4 + COSTAT], %r1
        andcc %r1, 0x80, %r1
        be putc
        stb %r3, [%r4 + COUT]
        jmpl %r15 + 4, %r0

enddata(libcon)

#endif
