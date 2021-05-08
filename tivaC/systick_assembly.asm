;in this example we use systick to make a delay
;we flash red led first then wait for 1 second using systick
;we then flash the blue led and wait 1s
;then we flash the green led

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

NVIC_ST_CTRL_R        EQU     0xE000E010
NVIC_ST_RELOAD_R      EQU     0xE000E014
NVIC_ST_CURRENT_R     EQU     0xE000E018


	AREA |.text|, CODE, READONLY
	EXPORT SystemInit
	EXPORT __main

; initializing steps (in doctor's example):
; =========================================
; 1- activate port F
; 2- allow change to port F
; 3- set direction of port F bits (input/output)
; 4- enable pull up resistors for the switches (bit 0 and 4)
; 5- digital enable for all bits of port F

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

  BL systickInit
  
  ;flash red led
	LDR R0, =GPIO_PORTF_DATA_R
  MOV R1, #0
  STR R1, [R0]
  MOV R1, #0x0002
  STR R1, [R0]

  BL systickWait1000ms

  ;flash blue led
	LDR R0, =GPIO_PORTF_DATA_R
  MOV R1, #0
  STR R1, [R0]
  MOV R1, #0x0004
  STR R1, [R0]

  BL systickWait1000ms

  ;flash green led
	LDR R0, =GPIO_PORTF_DATA_R
  MOV R1, #0
  STR R1, [R0]
  MOV R1, #0x0008
  STR R1, [R0]



systickInit
  ;disable systick during setup
  LDR R0, =NVIC_ST_CTRL_R
  MOV R1, #0
  STR R1, [R0]

  ;set reload to maximum reload value
  LDR R0, =NVIC_ST_RELOAD_R
  LDR R1, =0x00FFFFFF
  STR R1, [R0]

  ;set current to 0
  LDR R0, =NVIC_ST_CURRENT_R
  MOV R1, #0
  STR R1, [R0]

  ;enable systick
  LDR R0, =NVIC_ST_CTRL_R
  MOV R1, #5
  STR R1, [R0]

  BX LR



;parameters: R0 -> delay
systickWait1ms
  ;store 15999 (equivalent to 1 ms) in RELOAD register
  LDR R1, =NVIC_ST_RELOAD_R
  LDR R0, =15999
  STR R0, [R1]

  ;clear current
  LDR R0, =NVIC_ST_CURRENT_R
  MOV R1, #0
  STR R1, [R0]

  ;wait for count to finish
systickLoop
  LDR R0, =NVIC_ST_CTRL_R
  LDR R0, [R0]
  LDR R1, =0x00010000
  AND R0, R1
  CMP R0, #0
  BNE endSystickLoop
  B systickLoop
endSystickLoop
  BX LR


;R10 mustn't be changed when calling another function
systickWait1000ms
  MOV R10, #1000
  PUSH {LR}
loop1000ms
  BL systickWait1ms
  SUB R10, #1
  CMP R10, #0
  BNE loop1000ms
  POP {LR}
  BX LR
	END