! DO NOT EDIT THIS FILE.
! This file was automatically generated by arcpp.
! Edit the original file, hello.arc, instead.
        .begin
        .org 2048
COUT .equ 0 
 _COUT0 .equ 0
COSTAT .equ 4 
 _COSTAT0 .equ 4
CIN .equ 8 
 _CIN0 .equ 8
CICTL .equ 12 
 _CICTL0 .equ 12
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
        andcc %r31, 0x80, %r31
        be putc
        stb %r3, [%r30 + COUT]
        jmpl %r15 + 4, %r0
getc:
        ld [MEM_IO], %r30
        ld [%r30 + CICTL], %r31
  andcc %r31, 0x80, %r31
  be getc
  ld [%r30 + CIN], %r3
        jmpl %r15 + 4, %r0
__end_libcon_data:
Loop: ld [%r2 + str], %r3 ! Load next char into r3
        addcc %r3, 0, %r3
        be End ! Stop if null.
        call putc
        add %r2, 4, %r2 ! Increment string offset (r2)
        ba Loop
End: halt
        .org 3000
str: 0x48, 0x65, 0x6c, 0x6c, 0x6f
        0x2c, 0x20, 0x77, 0x6f, 0x72
        0x6c, 0x64, 0x21, 0x0a, 0
        .end
