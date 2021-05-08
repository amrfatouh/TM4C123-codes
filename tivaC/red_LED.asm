;in this code, we chaeck if switch is on, we toggle the red led continuously
;we make a delay between each toggle (250000 instructions as a delay [delay el8laba])

;registers
GPIO_PORTF_DATA_R     EQU    	0x400253FC
GPIO_PORTF_DIR_R      EQU    	0x40025400
GPIO_PORTF_AFSEL_R    EQU    	0x40025420
GPIO_PORTF_PUR_R      EQU    	0x40025510
GPIO_PORTF_DEN_R      EQU    	0x4002551C
GPIO_PORTF_CR_R       EQU    	0x40025524
GPIO_PORTF_AMSEL_R    EQU    	0x40025528
SYSCTL_RCGC2_R        EQU		  0x400FE108
SYSCTL_RCGCGPIO_R     EQU		  0x400FE608


	AREA |.text|, CODE, READONLY
	EXPORT SystemInit
	EXPORT __main

; initializing steps (in doctor's example):
; =========================================
; 1- activate port F [SYSCTL_RCGCGPIO_R]
; 2- allow change to port F [GPIO_PORTF_CR_R]
; 3- set direction of port F bits (input/output) [GPIO_PORTF_DIR_R]
; 4- enable pull up resistors for the switches (bit 0 and 4) [GPIO_PORTF_PUR_R]
; 5- digital enable for all bits of port F [GPIO_PORTF_DEN_R]

;to manipulate the leds: GPIO_PORTF_DATA_R

SystemInit
  ; activate Port F
	LDR R1, =SYSCTL_RCGCGPIO_R 
	LDR R0, [R1]
	ORR R0, R0, #0x20 ; set bit 5 to activate Port F  ;0x20 = 0010_0000
	STR R0, [R1]
	NOP
	NOP ; allow time for Port F activation
	
  ; allow change to Port F
	LDR R1, =GPIO_PORTF_CR_R 
	MOV R0, #0xFF ; 1 means allow access
	STR R0, [R1]
	
  ; set direction register
	LDR R1, =GPIO_PORTF_DIR_R 
	MOV R0, #0x0E ; PF0 and PF7-4 input, PF3-1 output  ;0x0E = 0000_1110
	STR R0, [R1]

  ; pull-up resistors for PF4,PF0
	LDR R1, =GPIO_PORTF_PUR_R 
	MOV R0, #0x11 ; enable pull-up on PF0 and PF4  ;0x11 = 0001_0001
	STR R0, [R1]
	
  ; enable Port F digital
	LDR R1, =GPIO_PORTF_DEN_R 
	MOV R0, #0xFF ; 1 means enable digital I/O
	STR R0, [R1]
	BX LR


__main

loop
  ;load data address
	LDR R1, =GPIO_PORTF_DATA_R

  ;check if switch is on
	LDR R0, [R1]
  AND R0, #0x01
  CMP R0, #0x01
  BEQ loop

  ;if switch is on, toggle the red LED
  LDR R0, [R1]
	EOR R0, #0x02
	STR R0, [R1]
  BL delay
	B loop
	
delay
  LDR R0, =250000
loop2
  CMP R0, #0
  BEQ endloop2

  SUB R0, #1
  B loop2
endloop2
  BX LR

	END