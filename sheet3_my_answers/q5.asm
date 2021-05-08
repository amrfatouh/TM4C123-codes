;take care:
  ;register names (__main & functions)
  ;NOP

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

NVIC_ST_CTRL_R        EQU     0xE000E010
NVIC_ST_RELOAD_R      EQU     0xE000E014
NVIC_ST_CURRENT_R     EQU     0xE000E018

GPIO_LOCK_KEY					EQU			0x4C4F434B


	AREA |.text|, CODE, READONLY
	EXPORT SystemInit
	EXPORT __main

SystemInit
  PUSH {LR}
  BL RGBInit
  BL SWInit
  POP {LR}
  
  BX LR

__main
  BL readPin4 ;R0 -> Pin 4
  MOV R11, R0
  MOV R12, #0x2 ;red LED

loop
  BL readPin4
  CMP R0, R11
  BEQ loop

  MOV R11, R0
  MOV R0, R12
  BL setLEDs

  LSL R12, #1
  CMP R12, #0x10
  BNE skipRed
  MOV R12, #0x2
skipRed
  B loop



RGBInit
  ;activate Port F
  LDR R0, =SYSCTL_RCGCGPIO_R
  MOV R1, #0x20
  STR R1, [R0]
  
  NOP
  NOP

  ;allow change to Port F
  LDR R0, =GPIO_PORTF_CR_R
  MOV R1, #0xFF
  STR R1, [R0]

  ;set led bits (1-3) to be output
  LDR R0, =GPIO_PORTF_DIR_R
  MOV R1, #0x0E
  STR R1, [R0]

  ;digital enable to Port F
  LDR R0, =GPIO_PORTF_DEN_R
  MOV R1, #0xFF
  STR R1, [R0]

  BX LR


SWInit
  ;activate Port F
  LDR R0, =SYSCTL_RCGCGPIO_R
  MOV R1, #0x20
  STR R1, [R0]
  
  NOP
  NOP

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


;parameters: R0 -> data by which LEDs would be set
setLEDs
  LDR R1, =GPIO_PORTF_DATA_R
  LDR R2, [R1]
  BIC R2, #0xE
  AND R0, #0x0E ;set all bits (other than LEDs bits) to zero 
  ORR R2, R0
  STR R2, [R1]

  BX LR


	END