;assignment example 3
;c code:
;z = (a << 2) | (B & 15)

LDR R0, =a
LDR R0, [R0] ;R0 = a
LDR R1, =b
LDR R1, [R1] ;R1 = b

LSL R0, R0, #2 ;a << 2
AND R1, R1, #15 ;b & 15
ORR R0, R0, R1 ; (a<<2) | (b&15)

LDR R1, =z
STR R0, [R1]