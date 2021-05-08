ADD R0, R1, R2
ADD R0, R1, #2
ADD R0, R1 ;add R0 and R1 and store the result in R0
ADC ;?? (doctor's slides)
SUB R0, R0, R1
CMP
SBC ;?? (doctor's slides)
MUL R0, R0, R1

ADDS R0, #1 ;adds 1 to R0 and check if it's zero, it uses the branch statement after it 
SUBS R0, #1 ;subtract 1 from R0 and uses the next branch statement
ANDS R0, #1 ;do AND operation on R0 with 1 and uses the next branch statement
BEQ branchName

AND
ORR
EOR
BIC R0, #0x01 ;clear bit number 1  ;same as AND R0, #0xFE

LSL R0, R0, #2
LSL R0, #2
LSR R0, R0, #2
ASR R0, R0, #2
ROR ;??

LDR R0, [R1] 			;load(R1) (take address stored in R1 and load the value from the memory into R0)
LDR R0, [R1, #4]	;load(R1 + 4)
LDR R0, [R1, R2]	;load(R1 + R2)
LDR R0, [R1, R2, LSL #2] ;load(R1 + (R2<<2))
LDR R0, [R1], #4 ;load(R1) and increment R1 by 4
LDRH R0, [R1] ;half word
LDRB R0, [R1] ;byte
LDRSH R0, [R1] ;signed half word (sign extend)
LDRSB R0, [R1] ;signed byte
LDRD R0, [R1] ;data (64-bit [2 registers])
STR R0, [R1] ;store one word from address stored in R1 into R0
STRH R0, [R1]	;half word
STRB R0, [R1] ;byte
MOV R0, #5 ;put 5 into R0
LDR R0, =5 ;put 5 into R0
MOV R0, R1 ;put R1 content into R0

CMP R0, R1
CMP R0, #0
BGT branchName
B branchName
BX LR

PUSH {R0} ;push R0 into stack
PUSH {R0, R1} ;push R1 then R0
PUSH {R0-R2} ;push R2 then R1 then R0 into the stack
POP {R0} ;POP stack into R0
POP {R0, R1} ;pop stack into R0 then into R1
POP {R0-R2} ;pop stack into R0 then R1 then R2