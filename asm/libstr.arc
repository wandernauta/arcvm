#ifndef LIBSTR
#define LIBSTR

#include "liblib.arc"
#include "libmem.arc"

! 
! libstr
! ------
! 
! The libmem library provides some string-related subroutines. Note that this
! library assumes C-style strings, i.e. one byte per character.
! 

data(libstr)

! 
! **strlen**: Set %r5 to the length of the packed string starting at %r3
! 
strlen:
    or %r0, %r3, %r16       ! Save original starting offset
    or %r0, 0x0, %r4        ! Look for null bytes
    ld [MEM_IO], %r5
    call memchr
    ret

enddata(libstr)
#endif
