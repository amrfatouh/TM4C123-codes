ADD R0, R1, R2
ADD R0, R1, #2
ADD R0, R1 ;add R0 and R1 and store the result in R0
ADC ; (doctor's slides)
;add with carry, add as normal then add the result with the carry flag then store in destination reg
SUB R0, R0, R1
CMP	
SBC ; (doctor's slides)
;subtreact with carry, sub as normal then if the carry flag was 0, decrement the result by 1 then store it
;else if carry flag = 1, store the result as it is.
MUL R0, R0, R1
DIVU R0, R1 ;R0 / R1

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
ROR ;
;Rotate Right, like shift right but the elements are rotated and entered again from right
ROX
;Rotate Right Extended, like shift right, but the element is kept in the carry then pushed to the most significat bit at the next step

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
STR R0, [R1] ;store data in R0 into the place in memory whose address is in R1
STRH R0, [R1]	;half word
STRB R0, [R1] ;byte
MOV R0, #5 ;put 5 into R0
LDR R0, =5 ;put 5 into R0
MOV R0, R1 ;put R1 content into R0

CMP R0, R1
CMP R0, #0
BGT branchName
BGE branchName
BLT branchName
BLE branchName
BEQ branchName
BNE branchName
MOVGT PC, #28 ;put 28 into PC if greater than
B branchName
BX LR

PUSH {R0} ;push R0 into stack
PUSH {R0, R1} ;push R1 then R0
PUSH {R0-R2} ;push R2 then R1 then R0 into the stack
POP {R0} ;POP stack into R0
POP {R0, R1} ;pop stack into R0 then into R1
POP {R0-R2} ;pop stack into R0 then R1 then R2

z DCD 0
