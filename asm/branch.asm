	.begin
	.org 2048
begin:	dec %r1
	inc %r1
	inc %r1
	be begin
	bneg begin
	bn begin
	nop
	halt
	.end
