#ifndef LIBCHK
#define LIBCHK

#include "liblib.arc"
#include "libcon.arc"

! 
! libchk
! ------
! 
! The libchk utility library provides macros and subroutines that facilitate
! testing and debugging libraries and user code.
! 

data(libchk)
! 
! **abort**: Immediately stops execution.
! 
abort:
    ta 0
    ret

! 
! **ae**: Assert equal (assembler macro)
! 
! Asserts that the zero bit is set. Useful for checking expectations.
.macro ae
    bne abort
.endmacro

!
! **an**: Assert never (arcpp macro)
!
! Asserts that the instruction is never executed.
.macro an
    ba abort
.endmacro

#define pass or %r0, 0x2E, %r3 \n call putc

enddata(libchk)
#endif
