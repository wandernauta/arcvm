	.begin
	.org 2048
	sethi 0x3fff75, %r1	! Set r1 to VMEM_BASE
	ld [on], %r4

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
draw:	stb %r4, [%r1+%r5]
	inc %r4
	inc %r5
	inc %r6
	subcc %r6, TILE, %r10
	be nexty
	ba draw
done:	halt
on:	0x1
	.end
