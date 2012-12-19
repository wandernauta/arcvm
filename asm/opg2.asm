! opg2.asm
! Dit programma bepaalt het aantal even getallen in een rij getallen `arr'.
! 
! Eigenlijk telt het programma getallen met een nulbit op de meest rechtse
! positie: een even getal is eentje met een 0 als LSB in 2-complement-notatie.
! Het programma werkt dus ook correct als er negatieve getallen in de rij
! voorkomen (2-complement).
! 
! De rij moet afgesloten worden door een 0 (die niet meegeteld wordt).
	.begin
	.org 0
	sethi arr, %r1
	srl %r1, 10, %r8	! %r8 = &arr
loop:				! while (true) {
	ld [%r8], %r2		! 	%r2 = arr[%r8];
	add %r8, 4, %r8		! 	%r8 += 4 bytes;	

				!	// Oneven getallen overslaan:
	andcc %r2, 0x1, %r0	!	z = (LSB(%r2));
	bne loop		!	if (!z) continue;

				!	// Afbreken bij 0:
	orcc %r2, %r0, %r0	! 	z = (%r2 == 0);
	be done			! 	if (z) break;

				!	// Getal is niet nul en niet oneven, tellen
	inc %r3			!	%r3 += 1;

        ba loop			! }
done:	halt			! %r3 == aantal even getallen
	.org 200
arr:	5,4,3,6,2,3,4,2,-1,1,2,0	! Voorbeeld-array.
	.end

!     _   _/_ _   _  _/_   --
! ((/(//)(/(-/ /)(/(//(/   Wander Nauta, 2012
