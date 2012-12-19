	.begin
	.org 2048
	ldub [yeh], %r1
	halt
yeh:	0xcafebabe
	.end
