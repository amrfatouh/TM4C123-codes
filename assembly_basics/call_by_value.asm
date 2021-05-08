;call by value
;c code:
;void noChange(int val) { val = 5; }
;void main() { int a = 55; noChange(a); }

B main

;parameters: R1
noChange MOV R1, #5;
BX LR

main LDR R0, =val ;R0 = &val
MOV R1, #55
STR R1, [R0] ; *val = 55
BL noChange ;parameters: R1  ;send the value of the variable (not the address)