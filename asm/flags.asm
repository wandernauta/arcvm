! flags.asm
! Tests if the condition flags (NZVC) work correctly.

	.begin
	.org 2048
one:	! Check zero flag (be)
	orcc %r0, 0, %r0
	be two
	halt
two:	! Check zero flag (bne)
	orcc %r0, 1, %r0
	bne three
	halt
three:	! Check negative flag (bneg)
	orcc %r0, -1, %r0
	bneg four
	halt
four:	! Check positive flag (bpos)
	orcc %r0, 1, %r0
	bpos five
	halt
five:	! Check overflow flag (bvs)
	or %r0, -1, %r1
	srl %r1, 1, %r1
	addcc %r1, %r1, %r0
	or %r0, 0, %r1
	bvs six
	halt
six:	! Check carry flag (bcs)
	or %r0, -1, %r1
	addcc %r1, 2, %r0
	bcs pass
	halt
pass:	
	halt
	.end
