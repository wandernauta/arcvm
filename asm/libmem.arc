#ifndef LIBMEM
#define LIBMEM

#include "liblib.arc"

! 
! libmem
! ------
! 
! The libmem library provides higher-level access to the ARC memory subsystem.
! 

data(libmem)

! 
! **memchr**: Searches %r3 for %r4 stopping at %r5
!
! This subroutine is similar to the C memchr function. It searches a memory
! area starting at the address in %r3 for the byte in %r4. The address of the
! first byte that matches %r4 is put in %r3. If, after %r5-%r3 bytes, nothing has
! matched, %r4 is equal to %r5.
! 
memchr:
    ldub [%r3], %r16        ! Load the byte at %r3 into %r16
    inc %r3                 ! Increase the data pointer
    subcc %r5, %r3, %r0     ! Test if we're at our limit
    be 4                    ! If we are, skip to the return
    subcc %r16, %r4, %r0    ! If not, test the loaded byte
    bne memchr              ! If it doesn't match, keep looking
    dec %r3                 ! If it matches, decrease the data pointer
    ret

! 
! **memcpy**: Fills %r3 with %r5 bytes from %r4.
! 
! Similar to the memcpy function in C, this subroutine copies bytes from the
! memory address starting at %r4 to the memory address starting at %r3. In total,
! %r5 bytes are copied.
! 
memcpy:
    clr %r16
    clr %r17

    ldub [%r4], %r16
    stb %r16, [%r3+%r17]

    inc %r4
    inc %r17

    subcc %r17, %r5, %r0
    bne memcpy

    clr %r16    ! Clean up and return
    clr %r17
    ret

! 
! **memset**: Set a memory area from %r3 to %r5 to the constant byte in %r4.
! 
memset:
    stb %r4, [%r3+0]

    inc %r3
    subcc %r5, %r3, %r0
    bne memset

    ret

! 
! **memfrob**: Frobnicates the memory area from %r3 to %r5.
! 
! A fast memory frobnicator. Frobnicate the memory area again to defrobnicate
! it.
! 
memfrob:
    ldub [%r3], %r16        ! Load the byte at %r3 into %r16
    xor %r16, 42, %r16      ! XOR it with 42
    stb %r16, [%r3+0]       ! Store it back

    inc %r3                 ! Go to next byte
    subcc %r5, %r3, %r0     ! If there are more bytes...
    bne memfrob             ! go back to the beginning
    ret                     ! else return

enddata(libmem)
#endif
