! DO NOT EDIT THIS FILE.
! This file was automatically generated by arcpp.
! Edit the original file, libcon.arc, instead.
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
