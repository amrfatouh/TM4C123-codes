;swap
;c code:
;void swap(int* a, int* b){ int t = *b; *b = *a; *a = t; }
;void main() { int a = 1, b = 2; swap(&a, &b); }

B main

;parameters: R0 = &a, R1 = &b
swap
LDR R2, [R0] ;R2 = *a
LDR R3, [R1] ;R3 = *b
STR R2, [R1] ;*b = *a
STR R3, [R0] ;*a = *b
BX LR

main
LDR R0, =a
LDR R1, =b
MOV R2, #1
STR R2, [R0]
MOV R2, #2
STR R2, [R1]

BL swap ;parameters: R0, R1