! DO NOT EDIT THIS FILE.
! This file was automatically generated by arcpp.
! Edit the original file, logo.arc, instead.
    .begin
    .org 2048
BLACK .equ 0 
 _BLACK0 .equ 0
BLUE .equ 3 
 _BLUE0 .equ 3
BROWN .equ 164 
 _BROWN0 .equ 164
CYAN .equ 191 
 _CYAN0 .equ 191
GREEN .equ 28 
 _GREEN0 .equ 28
MAROON .equ 32 
 _MAROON0 .equ 32
NAVY .equ 1 
 _NAVY0 .equ 1
OLIVE .equ 132 
 _OLIVE0 .equ 132
ORANGE .equ 236 
 _ORANGE0 .equ 236
PINK .equ 227 
 _PINK0 .equ 227
RED .equ 224 
 _RED0 .equ 224
WHITE .equ 255 
 _WHITE0 .equ 255
YELLOW .equ 252 
 _YELLOW0 .equ 252
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
    ld [MEM_IO], %r1 ! set r1 to the IO offset
    IMAGE_W .equ 104 ! In pixels
    IMAGE_H .equ 51 ! In pixels
init:
    or %r0, WHITE, %r4 ! %r4 = the color (white)
    or %r0, 0, %r2 ! %r2 = the x coord
    or %r0, 0, %r3 ! %r3 = the y coord
    or %r0, 0, %r9 ! %r9 = data offset
    or %r0, 0, %r12 ! %r12 = the x offset
    or %r0, 0, %r13 ! %r13 = the y offset
nexty:
    subcc %r3, IMAGE_H, %r0
    be done
    inc %r3
    or %r0, 0, %r2
loop:
    subcc %r2, IMAGE_W, %r0
    be nexty
    ldsb [%r9 + logo], %r6
    add %r2, 100, %r12
    add %r3, 90, %r13
    gfxx %r12
    gfxy %r13
    gfxpixel %r6
    add %r2, 1, %r2
    add %r9, 1, %r9 ! Increase data offset
    ba loop
done:
    st %r6, [%r1+V_CMD]
    halt
logo: 0x00000000, 0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000
        0x00000000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000
        0x00000000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000
        0x00000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000
        0x00000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000
        0x00000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000
        0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00
        0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00
        0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff
        0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff
        0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffff0000
        0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0x00000000
        0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x0000ffff, 0xffffff00, 0x00000000
        0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x000000ff, 0xff000000, 0x00000000
        0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffff00ff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xff000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x000000ff, 0x00000000, 0x00000000
        0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x0000ffff, 0xffff0000, 0x00000000
        0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff00ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0x00000000
        0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff00ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xff000000
        0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffff00
        0x000000ff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
        0x000000ff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffff00, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00
        0x0000ffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffff00, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00ffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00
        0x0000ffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffff00, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00ffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000
        0x0000ffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xff000000
        0x00ffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000
        0x00ffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000
        0x00ffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xff0000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000
        0xffffffff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000, 0x00ffffff, 0xffffffff, 0xffffffff, 0xff0000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x000000ff, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000
        0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00000000, 0x0000ffff, 0xffffffff, 0xffffffff, 0xff0000ff, 0xffffffff, 0xffffffff, 0xffff0000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffff00, 0x00000000, 0x00000000, 0x00000000, 0x000000ff, 0xffffffff, 0xffffffff, 0xff000000, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
        0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f000f0, 0x00f000f0, 0xf0f0f0f0
        0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f000f0, 0x00f000f0, 0x00f000f0
        0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f0f0f0, 0xf0f00000, 0xf00000f0, 0x00f000f0
        .end
