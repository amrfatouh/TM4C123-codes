;making the function "setLEDs"
;the function takes the Port F data as a parameter and only sets the LEDs depending on that data

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

;code to test "setLEDs" function

;initialize Port F & LEDs bits
SystemInit
  PUSH {LR}
  BL RGBInit
  POP {LR}
  BX LR

;flash all LEDs
__main
  MOV R0, #0xC ;flash blue & green LEDs
  BL setLEDs

  B endMain


RGBInit
  ;activate Port F
  LDR R0, =SYSCTL_RCGCGPIO_R
  MOV R1, #0x20
  STR R1, [R0]

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



;parameters: R0 -> data by which LEDs would be set
setLEDs
  LDR R1, =GPIO_PORTF_DATA_R
  LDR R2, [R1]
  BIC R2, #0xE
  AND R0, #0x0E ;set all bits (other than LEDs bits) to zero 
  ORR R2, R0
  STR R2, [R1]

  BX LR

endMain
  END