;call by reference
;c code
;void change(int* val) { *val = 5; }
;void main() { int val = 55; change(&val); }

B main

;parameters R0
change
MOV R1, #5
STR R1, [R0]
BX LR

main
LDR R0, =val ;R0 = &val
MOV R1, #55
STR R1, [R0]
BL change ;parameters: R0