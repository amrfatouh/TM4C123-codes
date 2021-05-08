;assignment example 2
;c code:
;y = a*(b+c);

LDR R0, =a 
LDR R0, [R0] ;R0 = a
LDR R1, =b
LDR R1, [R1] ;R1 = b
LDR R2, =c
LDR R2, [R2] ;R2 = c

ADD R3, R1, R2 ;b+c
MUl R3, R3, R0 ;a * (b+c)

LDR R4, =y
STR R3, [R4]