#ifndef LIBFNT
#define LIBFNT

#include "liblib.arc"
#include "libgfx.arc"
#include "libdev.arc"
#include "libcon.arc"

! 
! libfnt
! ------
! 
! The libfnt library contains subroutines that draw text to the screen in a
! simple bitmap font.
! 

#define fnt(char, x, y, color) or %r0, char, %r16 \n or %r0, x, %r17 \n or %r0, y, %r18 \n or %r0, color, %r19 \n call libfntfnt

data(libfnt)
libfntfnt:
            ld [MEM_IO], %r30       ! %r30 = memory offset

            sub %r16, 32, %r16      ! Compensate ASCII offset

            sll %r16, 6, %r16       ! %r16 = data offset
            sll %r17, 3, %r17       ! %r17 = screen x offset
            sll %r18, 3, %r18       ! %r18 = screen y offset

            or %r0, 0, %r19         ! %r19 = x loop counter
            or %r0, 0, %r20         ! %r20 = y loop counter

            lff_nexty:
            subcc %r20, 8, %r0
            be lff_done

            inc %r20
            or %r0, 0, %r19

            lff_loop:
            subcc %r19, 8, %r0
            be lff_nexty

            ldsb [%r16+fntfont], %r21 ! %r21 = data byte

            add %r17, %r19, %r25
            add %r18, %r20, %r26
            gfxx %r25
            gfxy %r26
            gfxpixel %r21

            inc %r19 ! Increase X loop counter
            inc %r16 ! Increase data offset

            ba lff_loop

            lff_done:
            st %r6, [%r1+V_CMD]     ! Update screen
            add %r16, 32, %r16
            srl %r16, 6, %r16
            srl %r17, 3, %r17
            srl %r18, 3, %r18
            clr %r19
            clr %r20
            clr %r30
            ret

fntfont:    0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0xFFFF0000
            0x0000FFFF, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x0000FFFF, 0x00FFFF00
            0x0000FFFF, 0x00FFFF00
            0x000000FF, 0x00FF0000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0x00FFFF00
            0x0000FFFF, 0x00FFFF00
            0x00FFFFFF, 0xFFFFFFFF
            0x0000FFFF, 0x00FFFF00
            0x00FFFFFF, 0xFFFFFFFF
            0x0000FFFF, 0x00FFFF00
            0x0000FFFF, 0x00FFFF00
            0x00000000, 0x00000000
            0x00000000, 0xFF000000
            0x000000FF, 0xFFFFFF00
            0x0000FF00, 0x00000000
            0x000000FF, 0xFFFF0000
            0x00000000, 0x0000FF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0xFF000000
            0x00000000, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0x00000000
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0x00FFFF00
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x0000FF00, 0xFF000000
            0x00FFFF00, 0x00FF00FF
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFFFFFF
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00FFFF00, 0x00000000
            0x0000FFFF, 0x00000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0x00000000
            0x00FFFF00, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00FFFF00
            0x00000000, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00000000, 0xFFFF0000
            0x00000000, 0x00FFFF00
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0x00FFFF00
            0x000000FF, 0xFFFF0000
            0x00FFFFFF, 0xFFFFFFFF
            0x000000FF, 0xFFFF0000
            0x0000FFFF, 0x00FFFF00
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0x00000000
            0x0000FFFF, 0x00000000
            0x0000FFFF, 0x00000000
            0x00FFFF00, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00FFFF00
            0x00000000, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0x00000000
            0x00FFFF00, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0xFFFFFF00
            0x00FFFFFF, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00FFFFFF, 0xFFFFFF00
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0x00FFFF00
            0x00000000, 0xFFFF0000
            0x0000FFFF, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0x00FFFF00
            0x000000FF, 0xFFFF0000
            0x00000000, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00000000, 0xFFFF0000
            0x000000FF, 0xFFFF0000
            0x0000FF00, 0xFFFF0000
            0x00FF0000, 0xFFFF0000
            0x00FFFFFF, 0xFFFFFF00
            0x00000000, 0xFFFF0000
            0x00000000, 0xFFFF0000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00FFFF00, 0x00000000
            0x00FFFFFF, 0xFFFF0000
            0x00000000, 0x00FFFF00
            0x00000000, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00000000
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0xFFFF0000
            0x00000000, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFFFF00
            0x00000000, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00FFFF00
            0x00000000, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0x00000000
            0x000000FF, 0xFF000000
            0x00000000, 0xFFFF0000
            0x00000000, 0x00FFFF00
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00FFFF00, 0x00000000
            0x0000FFFF, 0x00000000
            0x000000FF, 0xFF000000
            0x00000000, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0x00000000
            0x00FFFF00, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0x00FFFF00
            0x000000FF, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFF000000
            0x00FF0000, 0x00FF0000
            0x00FF00FF, 0xFFFF0000
            0x00FF00FF, 0xFF000000
            0x00FF0000, 0x0000FF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFFFF, 0xFFFFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0xFFFFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFFFF, 0xFFFFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x000000FF, 0xFFFFFF00
            0x00000000, 0xFFFF0000
            0x00000000, 0xFFFF0000
            0x00000000, 0xFFFF0000
            0x00FFFF00, 0xFFFF0000
            0x00FFFF00, 0xFFFF0000
            0x0000FFFF, 0xFF000000
            0x00000000, 0x00000000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0xFFFF0000
            0x00FFFFFF, 0xFF000000
            0x00FFFFFF, 0x00000000
            0x00FFFFFF, 0xFF000000
            0x00FFFF00, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00000000, 0x00000000
            0x00FFFF00, 0x0000FFFF
            0x00FFFFFF, 0x00FFFFFF
            0x00FFFFFF, 0xFFFFFFFF
            0x00FFFF00, 0xFF00FFFF
            0x00FFFF00, 0x0000FFFF
            0x00FFFF00, 0x0000FFFF
            0x00FFFF00, 0x0000FFFF
            0x00000000, 0x00000000
            0x00FFFF00, 0x0000FFFF
            0x00FFFFFF, 0x0000FFFF
            0x00FFFFFF, 0xFF00FFFF
            0x00FFFF00, 0xFFFFFFFF
            0x00FFFF00, 0x00FFFFFF
            0x00FFFF00, 0x0000FFFF
            0x00FFFF00, 0x0000FFFF
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00000000
            0x00FFFF00, 0x00000000
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0xFFFFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00FFFF00
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFFFF, 0xFFFF0000
            0x00FFFFFF, 0xFF000000
            0x00FFFF00, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00000000, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00000000
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00FFFFFF, 0xFFFFFF00
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFFFF00
            0x00000000, 0x00000000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x00FFFF00, 0x0000FFFF
            0x00FFFF00, 0x0000FFFF
            0x00FFFF00, 0x0000FFFF
            0x00FFFF00, 0xFF00FFFF
            0x00FFFFFF, 0xFFFFFFFF
            0x00FFFFFF, 0x00FFFFFF
            0x00FFFF00, 0x0000FFFF
            0x00000000, 0x00000000
            0x00FFFF00, 0x0000FFFF
            0x00FFFF00, 0x0000FFFF
            0x0000FFFF, 0x00FFFF00
            0x000000FF, 0xFFFF0000
            0x0000FFFF, 0x00FFFF00
            0x00FFFF00, 0x0000FFFF
            0x00FFFF00, 0x0000FFFF
            0x00000000, 0x00000000
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x00FFFF00, 0x00FFFF00
            0x0000FFFF, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00000000, 0x00FFFF00
            0x00000000, 0xFFFF0000
            0x000000FF, 0xFF000000
            0x0000FFFF, 0x00000000
            0x00FFFF00, 0x00000000
            0x00FFFFFF, 0xFFFFFF00
            0x00000000, 0x00000000
            0x000000FF, 0xFFFFFF00
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFFFFFF00
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00FFFF00, 0x00000000
            0x0000FFFF, 0x00000000
            0x000000FF, 0xFF000000
            0x00000000, 0xFFFF0000
            0x00000000, 0x00FFFF00
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x000000FF, 0xFF000000
            0x00FFFFFF, 0xFF000000
            0x00000000, 0x00000000
            0x00000000, 0xFF000000
            0x000000FF, 0x00FF0000
            0x0000FF00, 0x0000FF00
            0x00FF0000, 0x000000FF
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00FFFFFF, 0xFFFFFFFF
            0x00000000, 0x00000000
            0x00000000, 0x00000000
            0x00000000, 0x00000000

enddata(libfnt)

#endif
