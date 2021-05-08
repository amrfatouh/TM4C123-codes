;for loop
;c code:
; for(int i=0, int f = 0; i<N; i++)
;		f = f + c[i] * x[i];

MOV R0, #0 ;R0 = i
MOV R1, #0 ;R1 = f
LDR R2, =N ;R2 = &N
loop LDR R3, [R2] ;R3 = N
CMP R0, R3
BGE exit

LSL R4, R0, #2 ; R4 = i*4
LDR R5, =c ;R5 = &c
ADD R5, R4
LDR R5, [R5]
LDR R6, =x ;R6 = &x
ADD R6, R4
LDR R6, [R6]
MUL R5, R6
ADD R1, R5

ADD R0, #1
B loop

exit