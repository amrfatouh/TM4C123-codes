;assignement example
;c code:
;x = (a + b) - c;

LDR R0, =a
LDR R0, [R0]
LDR R1, =b
LDR R1, [R1]
LDR R2, =c
LDR R2, [R2]

ADD R3, R0, R1 ;a + b
SUB R3, R3, R2 ;(a+b) - c

LDR R4, =x
STR R3, [R4]