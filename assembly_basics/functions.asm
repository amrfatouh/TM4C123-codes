;functions
;c code:
;unsigned long Num;
;void change() { Num += 25; }
;void main() { Num = 0; change(); }

change LDR R0, =Num
LDR R1, [R0]
ADD R1, #25
STR R1, [R0]
BX LR

main LDR R0, =Num
MOV R1, #0
STR R1, [R0]
BL change