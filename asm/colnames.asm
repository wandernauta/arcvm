	.begin
	.org 2048
	sethi 0x3fffc0, %r1	! Set r1 to MEM_IO
	ld [on], %r4

	V_COLOR .equ 0xF1
	V_CMD .equ 0xF2
	V_ADDR_X .equ 0xF4
	V_ADDR_Y .equ 0xF8

	WIDTH .equ 320
	HEIGHT .equ 240

	! %r6 = x
	! %r7 = y

nexty:	inc %r7
	and %r6, 0, %r6
loop:		
	stb %r4, [%r1+V_COLOR]
	inc %r6
	st %r6, [%r1+V_ADDR_X]
	st %r7, [%r1+V_ADDR_Y]
	subcc %r6, WIDTH, %r0
	be nexty
	subcc %r7, HEIGHT, %r0
	be done
	ba loop
done:	stb %r4, [%r1+V_CMD]
	halt
on:	0xFFFFFFFF
	.end
