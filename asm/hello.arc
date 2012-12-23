! 
! hello.arc
! Prints a nice message to standard output
! 
! This file is part of the arcvm example set. Read the README.mkd files for
! more information.
! 
        .begin
        .org 2048

        #include "libcon.arc"
        
Loop:   ld [%r2 + str], %r3    ! Load next char into r3
        addcc %r3, 0, %r3
        be End                 ! Stop if null.
        call putc
        add %r2, 4, %r2        ! Increment string offset (r2)
        ba Loop
End:    halt

        .org 3000
str:    0x48, 0x65, 0x6c, 0x6c, 0x6f
        0x2c, 0x20, 0x77, 0x6f, 0x72 
        0x6c, 0x64, 0x21, 0x0a, 0
        .end
        
