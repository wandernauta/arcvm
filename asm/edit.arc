! 
! edit.asc
! A visual editor
! 
! This file is part of the arcvm example set. Read the README.mkd files for
! more information.
! 
        .begin
        .org 2048

        #include "libcon.arc"
        #include "libfnt.arc"


in:
        fnt(0x5F, %r2, %r4, 0xFF)
        call getc

        subcc %r3, 0x8, %r0
        be bksp

        subcc %r3, 0xA, %r0
        be newl

        subcc %r3, 0xD, %r0
        be newl

norm:   
        andn %r3, 32, %r3          ! Force uppercase
        fnt(%r3, %r2, %r4, 0xFF)
        inc %r2
        ba in
newl:
        fnt(0x20, %r2, %r4, 0xFF)
        inc %r4
        clr %r2
        ba in
bksp:
        fnt(0x20, %r2, %r4, 0xFF)
        dec %r2
        ba in

end:    halt
        .end
        
