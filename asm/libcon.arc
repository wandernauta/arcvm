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
! **putc**: Writes the character (unsigned 8-bit) in %r3 to the console.
! 
putc:   
        ld [MEM_IO], %r30
        ld [%r30 + COSTAT], %r31
        andcc %r31, 0x80, %r31
        be putc
        stb %r3, [%r30 + COUT]
        ret

! 
! **getc**: Waits for and reads a character (unsigned 8-bit) to register %r3.
! 
getc:
        ld [MEM_IO], %r30
        ld [%r30 + CICTL], %r31
		andcc %r31, 0x80, %r31
		be getc

		ld [%r30 + CIN], %r3
        ret

enddata(libcon)

#endif
