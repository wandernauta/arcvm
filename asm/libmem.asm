! DO NOT EDIT THIS FILE.
! This file was automatically generated by arcpp.
! Edit the original file, libmem.arc, instead.
libmem_data: ba __end_libmem_data
memchr:
    ldub [%r3], %r16 ! Load the byte at %r3 into %r16
    inc %r3 ! Increase the data pointer
    subcc %r5, %r3, %r0 ! Test if we're at our limit
    be 4 ! If we are, skip to the return
    subcc %r16, %r4, %r0 ! If not, test the loaded byte
    bne memchr ! If it doesn't match, keep looking
    dec %r3 ! If it matches, decrease the data pointer
    jmpl %r15 + 4, %r0
memcpy:
    clr %r16
    clr %r17
    ldub [%r4], %r16
    stb %r16, [%r3+%r17]
    inc %r4
    inc %r17
    subcc %r17, %r5, %r0
    bne memcpy
    clr %r16 ! Clean up and return
    clr %r17
    jmpl %r15 + 4, %r0
memset:
    stb %r4, [%r3+0]
    inc %r3
    subcc %r5, %r3, %r0
    bne memset
    jmpl %r15 + 4, %r0
memfrob:
    ldub [%r3], %r16 ! Load the byte at %r3 into %r16
    xor %r16, 42, %r16 ! XOR it with 42
    stb %r16, [%r3+0] ! Store it back
    inc %r3 ! Go to next byte
    subcc %r5, %r3, %r0 ! If there are more bytes...
    bne memfrob ! go back to the beginning
    jmpl %r15 + 4, %r0 ! else return
__end_libmem_data:
