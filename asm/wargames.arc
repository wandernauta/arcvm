        .begin
        .org 2048

        #include "libcon.arc"
        #include "libfnt.arc"
        #include "libchr.arc"
        
one:    ld [%r2 + prompt], %r3   ! Load next char into r3
        addcc %r3, 0, %r3
        be wait                  ! Stop if null.
        fnt(%r3, %r4, 1, 0xFF)
        add %r2, 4, %r2          ! Increment string offset (r2)
        inc %r4                  ! Increment X position (r4)
        ba one

wait:   call getc

two:    
        clr %r2
        clr %r4

loop1:  ld [%r2 + line1], %r3
        addcc %r3, 0, %r3
        be three                  
        fnt(%r3, %r4, 3, 0xFF)
        add %r2, 4, %r2          
        inc %r4                  
        ba loop1

three:
        clr %r2
        clr %r4

loop2:  ld [%r2 + line2], %r3
        addcc %r3, 0, %r3
        be four                  
        fnt(%r3, %r4, 4, 0xFF)
        add %r2, 4, %r2          
        inc %r4                  
        ba loop2

four:
        clr %r2
        clr %r4

loop3:  ld [%r2 + line3], %r3
        addcc %r3, 0, %r3
        be end                  
        fnt(%r3, %r4, 5, 0xFF)
        add %r2, 4, %r2          
        inc %r4                  
        ba loop3


end:    halt

        .org 3000
prompt: _, W, O, U, L, D, _, Y, O, U, _, L, I, K, E, _, T, O, _, P, L, A, Y
        _, A, _, G, A, M, E, 0x3F
        0
line1:  _, A, _, S, T, A, N, G, E, _, G, A, M, E, 0
line2:  _, T, H, E, _, O, N, L, Y, _, W, I, N, N, I, N, G, _, M, O, V, E, _, I, S, 0
line3:  _, N, O, T, _, T, O, _, P, L, A, Y, 0
        .end
        
