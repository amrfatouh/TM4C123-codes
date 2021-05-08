;array example
;c code:
;for (int i=0; i<5; i++) { aa[i] = i; bb[i] = 5; }

	MOV R0, #0 ;R0 = i  ;initializing the loop
	LDR R1, =aa ;R1 = aa
	LDR R2, =bb ;R2 = bb
loop
	CMP R0, #5 ;condition
	BGE endLoop
	
	STR R0, [R1, R0, LSL #2]
	MOV R3, #5
	STR R3, [R2, R0, LSL #2]
	
	ADD R0, #1 ;increment
	B loop
endLoop