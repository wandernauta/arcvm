! DO NOT EDIT THIS FILE.
! This file was automatically generated by arcpp.
! Edit the original file, wargames.arc, instead.
        .begin
        .org 2048
COUT .equ 0x0 
 _COUT0 .equ 0x0
COSTAT .equ 0x4 
 _COSTAT0 .equ 0x4
CIN .equ 0x8 
 _CIN0 .equ 0x8
CICTL .equ 0xC 
 _CICTL0 .equ 0xC
V_COLOR .equ 0xF1 
 _V_COLOR0 .equ 0xF1
V_CMD .equ 0xF2 
 _V_CMD0 .equ 0xF2
V_ADDR_X .equ 0xF4 
 _V_ADDR_X0 .equ 0xF4
V_ADDR_Y .equ 0xF8 
 _V_ADDR_Y0 .equ 0xF8
SCREENW .equ 320 
 _SCREENW0 .equ 320
SCREENH .equ 240 
 _SCREENH0 .equ 240
libdev_data: ba __end_libdev_data
MEM_IO: 0xFFFF0000 
 _MEM_IO0: 0xFFFF0000
__end_libdev_data:
libcon_data: ba __end_libcon_data
putc:
        ld [MEM_IO], %r30
        ld [%r30 + COSTAT], %r31
        andcc %r1, 0x80, %r31
        be putc
        stb %r3, [%r30 + COUT]
        jmpl %r15 + 4, %r0
getc:
        ld [MEM_IO], %r30
        ld [%r30 + CICTL], %r31
  andcc %r31, 0x80, %r0
  be getc
  ldub [%r4 + CIN], %r3
        jmpl %r15 + 4, %r0
__end_libcon_data:
.macro gfxx reg
    ld [MEM_IO], %r1
    st reg, [%r1+V_ADDR_X]
.endmacro
.macro gfxy reg
    ld [MEM_IO], %r1
    st reg, [%r1+V_ADDR_Y]
.endmacro
.macro gfxpixel reg
    stb reg, [%r1+V_COLOR]
.endmacro
libfnt_data: ba __end_libfnt_data
libfntfnt:
            ld [MEM_IO], %r30 ! %r30 = memory offset
            sub %r16, 32, %r16 ! Compensate ASCII offset
            sll %r16, 6, %r16 ! %r16 = data offset
            sll %r17, 3, %r17 ! %r17 = screen x offset
            sll %r18, 3, %r18 ! %r18 = screen y offset
            or %r0, 0, %r19 ! %r19 = x loop counter
            or %r0, 0, %r20 ! %r20 = y loop counter
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
            st %r6, [%r1+V_CMD] ! Update screen
            add %r16, 32, %r16
            srl %r16, 6, %r16
            srl %r17, 3, %r17
            srl %r18, 3, %r18
            clr %r19
            clr %r20
            clr %r30
            jmpl %r15 + 4, %r0
fntfont: 0x00000000, 0x00000000
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
            0x00000000, 0xFF000000
            0x00000000, 0xFF000000
            0x0000FFFF, 0xFFFFFF00
            0x00000000, 0xFF000000
            0x00000000, 0xFF000000
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
__end_libfnt_data:
Loop: ld [%r2 + str], %r3 ! Load next char into r3
        addcc %r3, 0, %r3
        be End ! Stop if null.
        or %r0, %r3, %r16 
 or %r0, %r4, %r17 
 or %r0, 1, %r18 
 or %r0, 0xFF, %r19 
 call libfntfnt
        !call putc
        add %r2, 4, %r2 ! Increment string offset (r2)
        inc %r4 ! Increment 0x58 position (r4)
        ba Loop
End: halt
        .org 3000
str: 0x20, 0x57, 0x4F, 0x55, 0x4C, 0x44, 0x20, 0x59, 0x4F, 0x55, 0x20, 0x4C, 0x49, 0x4B, 0x45, 0x20, 0x54, 0x4F, 0x20, 0x50, 0x4C, 0x41, 0x59
        0x20, 0x41, 0x20, 0x47, 0x41, 0x4D, 0x45, 0x3F
        0
        .end