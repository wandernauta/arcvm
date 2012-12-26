! flags.asm
! Tests if the condition flags (NZVC) work correctly.

	.begin
one:	! Check zero flag (be)
	orcc %r0, 0, %r0
	be two
	ba fail
two:	! Check zero flag (bne)
	orcc %r0, 1, %r0
	bne three
	ba fail
three:	! Check negative flag (bneg)
	orcc %r0, -1, %r0
	bneg four
	ba fail
four:	! Check positive flag (bpos)
	orcc %r0, 1, %r0
	bpos five
	ba fail
five:	! Check overflow flag (bvs)
	or %r0, -1, %r1
	srl %r1, 1, %r1
	addcc %r1, %r1, %r0
	or %r0, 0, %r1
	bvs six
	ba fail
six:	! Check carry flag (bcs)
	or %r0, -1, %r1
	addcc %r1, 2, %r0
	bcs pass
	ba fail
pass:	halt
fail:	
	ba fail
	.end
