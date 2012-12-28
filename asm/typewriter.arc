! 
! typewriter.asc
! A port of the ARCTools typewriter example.
! 
! This file is part of the arcvm example set. Read the README.mkd files for
! more information.
! 
        .begin
        .org 2048

        #include "libcon.arc"

loop:   call getc
        call putc
        ba loop

end:    halt
        .end
        
