	.begin
	.org 0			! start program at 0
a_st	.equ 72			! address of array a
	ld [address], %r2	! %r2 = &a;
	andcc %r3, %r0, %r3	! %r3 = 0;
	andcc %r4, %r0, %r4     ! %r4 = 0;
loop:	                        ! while(true) {
	ld [%r2+%r4], %r5	!   %r5 = mem[%r2 + %r4];
        andcc %r5, %r5, %r0     !   if (%r5 == 0)
        be done                 !     break;
	addcc %r3, %r5, %r3	!   %r3 = %r5 + %r3;
	addcc %r4, 4, %r4	!   %r4 = %r4 + 4;
	ba loop                 ! }
done:	halt

address:a_st
	.org a_st
a:	25
	-10
	33
	-5
	7
        50
        25
        -25
        0
	0xcafebabe		! Marker
.end
