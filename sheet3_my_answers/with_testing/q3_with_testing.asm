;making the function "readPin4"
;the function reads the value of Pin 4 and puts it in R0

SYSCTL_RCGCGPIO_R     EQU		  0x400FE608
GPIO_PORTF_CR_R       EQU    	0x40025524
GPIO_PORTF_DEN_R      EQU    	0x4002551C
GPIO_PORTF_DIR_R      EQU    	0x40025400
GPIO_PORTF_PUR_R      EQU    	0x40025510
GPIO_PORTF_DATA_R     EQU    	0x400253FC

GPIO_PORTF_AFSEL_R    EQU    	0x40025420
GPIO_PORTF_AMSEL_R    EQU    	0x40025528
SYSCTL_RCGC2_R        EQU		  0x400FE108
GPIO_PORTF_LOCK_R       EQU			0x40025520
GPIO_PORTF_PCTL_R       EQU			0x4002552C
SYSCTL_RCGC2_R          EQU			0x400FE108

NVIC_ST_CTRL_R        EQU     0xE000E010
NVIC_ST_RELOAD_R      EQU     0xE000E014
NVIC_ST_CURRENT_R     EQU     0xE000E018

GPIO_LOCK_KEY					EQU			0x4C4F434B

	AREA |.text|, CODE, READONLY
	EXPORT SystemInit
	EXPORT __main


;code to test "readPin4" function

;initialize Port F & switch bit
SystemInit
  PUSH {LR}
  BL SWInit
  POP {LR}
  BX LR


;when switch is on, flash the red LED
__main
loop
	BL readPin4
  CMP R0, #0 ;if R0 == 0 => switch is ON
  BNE loop
  LDR R0, =GPIO_PORTF_DATA_R
  LDR R1, [R0]
  MOV R2, #0xE
  ORR R1, R2
  
  ;set LEDs bits to digital output
  LDR R0, =GPIO_PORTF_DIR_R
  LDR R1, [R0]
  MOV R2, #0x0E
  ORR R1, R2
  STR R1, [R0]
  
  LDR R0, =GPIO_PORTF_DATA_R
  STR R1, [R0]

  B endMain


SWInit
  ;activate Port F
  LDR R0, =SYSCTL_RCGCGPIO_R
  MOV R1, #0x20
  STR R1, [R0]

  ;allow change to Port F
  LDR R0, =GPIO_PORTF_CR_R
  MOV R1, #0xFF
  STR R1, [R0]

  ;set switch bit (4) to be input
  LDR R0, =GPIO_PORTF_DIR_R
  LDR R1, [R0]
  MOV R2, #0xEF
  AND R1, R2
  STR R1, [R0]

  ;digital enable to Port F
  LDR R0, =GPIO_PORTF_DEN_R
  MOV R1, #0xFF
  STR R1, [R0]

  BX LR


;returns the value of bit 4 at R0
readPin4
  LDR R0, =GPIO_PORTF_DATA_R
  LDR R0, [R0]
  MOV R1, #0x10
  AND R0, R1

  BX LR

endMain
  END