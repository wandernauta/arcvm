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
	TILE .equ 16
	SQUARE .equ 256

	! %r4 = color
	! %r5 = offset
	! %r6 = x
	! %r7 = y

nexty:	add %r5, WIDTH, %r5
	sub %r5, TILE, %r5
	and %r6, 0, %r6
	inc %r7
	subcc %r7, TILE, %r10
	be done
draw:	st %r6, [%r1+V_ADDR_X]
	st %r7, [%r1+V_ADDR_Y]
	stb %r4, [%r1+V_COLOR]
	inc %r4
	inc %r5
	inc %r6
	subcc %r6, TILE, %r10
	be nexty
	ba draw
done:	ld [on], %r4
	stb %r4, [%r1+V_CMD]
	halt
on:	0x1
	.end
