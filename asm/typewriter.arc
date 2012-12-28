! 
! typewriter.asc
! A port of the ARCTools typewriter example.
! 
! This file is part of the arcvm example set. Read the README.mkd files for
! more information.
! 

        .begin
        .org 2048

        #include "libdev.arc"
        #include "libcon.arc"

        ld [MEM_IO], %r4

loop:   ld [%r4 + CICTL], %r1
        andcc %r1, 0x80, %r1
        be loop

        ld [%r4 + CIN], %r3
        subcc %r3, 27, %r5    ! 27 is Escape
        be end                ! stop if it is.

        call putc
        ba loop

end:    halt
        .end
        
