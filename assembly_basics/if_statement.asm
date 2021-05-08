;if statement
;c code:
;if (a > b) { x = 5; y = c + d; } else x = c - d;

;storing a value in a and b
LDR R0, =a
LDR R1, =bb
MOV R2, #5
STR R2, [R0]
MOV R2, #3
STR R2, [R1]

;loading the values of a and b
LDR R0, =a
LDR R0, [R0] ;R0 = a
LDR R1, =b
LDR R1, [R1] ;R1 = b

;comparing a and b
CMP R0, R1
BLE else_branch

;true condition
;store 5 in x
LDR R2, =x ;R2 = &x
MOV R3, #5
STR R3, [R2] ;R2 = NULL (we don't want x address anymore)
LDR R2, =y ;R2 = &y

;compute c+d
LDR R3, =c
LDR R3, [R3] ;R3 = c
LDR R4, =d
LDR R4, [R4] ;R4 = d
ADD R3, R3, R4 ;c+d

;put the result in y
STR R3, [R2] ; y=c+d
B exit_if

;false condition
;computing c-d and storing it in x
else_branch	LDR R2, =x ;R2 = &x
LDR R3, =c
LDR R3, [R3]
LDR R4, =d
LDR R4, [R4]
SUB R3, R3, R4 ;c-d
STR R3, [R2]

exit_if NOP