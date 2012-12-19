	.begin
	.org 2048
	add %r1, 1, %r3
    add %r2, 1, %r3
    add %r0, %r0, %r0
	addcc %r0, %r0, %r0
	halt
	.end
