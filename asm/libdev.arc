#ifndef LIBDEV
#define LIBDEV

#include "liblib.arc"

! 
! libdev
! ------
! 
! The libdev library provides higher-level access to virtual peripherals.
! 

! 
! **COUT**: Console output port offset (8 bits)
equ(COUT, 0x0)

! 
! **COSTAT**: Console status port offset (8 bits)
equ(COSTAT, 0x4)

! 
! **CIN**: Keyboard input port offset (8 bits)
equ(CIN, 0x8)

! 
! **CICTL**: Keyboard status port offset (8 bits)
equ(CICTL, 0xC)

! 
! **V_COLOR**: Video color port offset (8 bits)
! 
! Color (pixel) data should be written to this port. Writing to this port
! 'paints' the pixel on the screen.
equ(V_COLOR, 0xF1)

! 
! **V_CMD**: Video command port offset (8 bits)
! 
! Write a byte to this port to update the screen. The store operation will
! return when the screen is updated - this can take multiple milliseconds
! depending on configuration.
equ(V_CMD, 0xF2)

! 
! **V_ADDR_X**: Video X coordinate port offset
! 
! Write the X coordinate of the pixel you want to paint to this port before
! writing the color.
equ(V_ADDR_X, 0xF4)

! 
! **V_ADDR_Y**: Video Y coordinate port offset
! 
! Write the Y coordinate of the pixel you want to paint to this port before
! writing the color.
equ(V_ADDR_Y, 0xF8)

! 
! **SCREENW**: The width of the virtual screen in pixels
equ(SCREENW, 320)

! 
! **SCREENH**: The height of the virtual screen in pixels
equ(SCREENH, 240)

data(libdev)
! 
! **MEM_IO**: The begin of the I/O mapped memory space, in bytes. 
const(MEM_IO, 0xFFFF0000)
enddata(libdev)

#endif
