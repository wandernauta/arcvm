        .begin
        .org 2048

        #include "libcon.arc"
        #include "libfnt.arc"
        #include "libchr.arc"
        
Loop:   ld [%r2 + str], %r3    ! Load next char into r3
        addcc %r3, 0, %r3
        be End                 ! Stop if null.
        fnt(%r3, %r4, 1, 0xFF)
        !call putc
        add %r2, 4, %r2        ! Increment string offset (r2)
        inc %r4                ! Increment X position (r4)
        ba Loop
End:    halt

        .org 3000
str:    _, W, O, U, L, D, _, Y, O, U, _, L, I, K, E, _, T, O, _, P, L, A, Y
        _, A, _, G, A, M, E, 0x3F
        0
        .end
        
