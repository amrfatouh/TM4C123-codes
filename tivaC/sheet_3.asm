;this is the example in sheet 3
;in this example we iterate over the three leds and flash them
;we flash red first then blue then green then red and so on

GPIO_PORTF_DATA_R       EQU    	0x400253FC
GPIO_PORTF_DIR_R        EQU    	0x40025400
GPIO_PORTF_AFSEL_R      EQU    	0x40025420
GPIO_PORTF_PUR_R        EQU    	0x40025510
GPIO_PORTF_DEN_R        EQU    	0x4002551C
GPIO_PORTF_CR_R         EQU    	0x40025524
GPIO_PORTF_AMSEL_R      EQU    	0x40025528
SYSCTL_RCGCGPIO_R       EQU			0x400FE608
GPIO_PORTF_LOCK_R       EQU			0x40025520
GPIO_PORTF_PCTL_R       EQU			0x4002552C
SYSCTL_RCGC2_R          EQU			0x400FE108

; lock key
GPIO_LOCK_KEY					EQU			0x4C4F434B

	; export SystemInit and __main functions to be used by startup.s file
	AREA |.text|, CODE, READONLY
	EXPORT SystemInit
	EXPORT __main

;the SystemInit function just calls 2 functions
SystemInit
	PUSH {LR}
	BL RGBLED_Init
	BL SW1_Init
	POP {PC}

__main
	MOV R3, #0x02 ;put 1 in red LED
SuperLoop
	CMP R3, #0x10 ;see if green LED is 1
	BNE read_sw1 ;if false, read_sw1
	MOV R3, #0x02 ;if true make red LED 1 and other LEDs 0
read_sw1
	BL SW1_Input ;puts the value of bit 4 (the switch) in R5
	CMP R5, #0x10 ;if switch is 1, do nothing
	BEQ end_if

	MOV R0, R3 ;if switch is 0, put R3 (the LED to be lit) into R0
	BL RGB_Output
	LSL R3, R3, #1
end_if
	B SuperLoop



;light the LED with (value = 1) in R0
;clears port F data and stores R0 in it
RGB_Output
	LDR R1, =GPIO_PORTF_DATA_R
	LDR R2, [R1]
	BIC R2, R2, #0x0E
	ORR R2, R2, R0
	STR R2, [R1]
	BX LR


; put value of bit 4 (the switch) in R5
SW1_Input
	LDR R1, =GPIO_PORTF_DATA_R
	LDR R5, [R1]
	AND R5, R5, #0x10
	BX LR


;steps for initializing the LEDs:
;1- enable port F (SYSCTL_RCGCGPIO_R)
;2- set the lock (GPIO_PORTF_LOCK_R)
;3- allow changing to port F (GPIO_PORTF_CR_R)
;4- disable analog mode(GPIO_PORTF_AMSEL_R)
;5- clear port F control (GPIO_PORTF_PCTL_R)
;6- clear the alternate function bits (GPIO_PORTF_AFSEL_R)
;7- set the digital enable of the LEDs (GPIO_PORTF_DEN_R)
;8- set the data of the leds (GPIO_PORTF_DATA_R)

RGBLED_Init

	;enable port F
	LDR R1, =SYSCTL_RCGCGPIO_R
	LDR R0, [R1]
	ORR R0, R0, #0x20
	STR R0, [R1]
	NOP
	NOP
	
	;setting the lock of bits
	;set bits you want to change to 1
	;not needed in this application (not needed in applications that use LEDs)
	LDR R1, =GPIO_PORTF_LOCK_R
	LDR R0, =0x4C4F434B
	STR R0, [R1]

  ; allow changing to port F
	LDR R1, =GPIO_PORTF_CR_R
	LDR R0, [R1]
	ORR R0, R0, #0x0E
	STR R0, [R1]
	
	;disable analog mode
	LDR R1, =GPIO_PORTF_AMSEL_R
	LDR R0, [R1]
	BIC R0, R0, #0x0E
	STR R0, [R1]
	
	;clear port F control (??)
	LDR R1, =GPIO_PORTF_PCTL_R
	LDR R0, [R1]
	LDR R2, =0x0000FFF0
	BIC R0, R0, R2
	STR R0, [R1]
	
	;clear the alternate function for the LED bits
	LDR R1, =GPIO_PORTF_AFSEL_R
	LDR R0, [R1]
	BIC R0, R0, #0x0E
	STR R0, [R1]
	
	;make the direction of the LEDs output direction
	LDR R1, =GPIO_PORTF_DIR_R
	LDR R0, [R1]
	ORR R0, R0, #0x0E
	STR R0, [R1]
	
	;digital enable the 3 LEDs
	LDR R1, =GPIO_PORTF_DEN_R
	LDR R0, [R1]
	ORR R0, R0, #0x0E
	STR R0, [R1]
	
	;put 1 in the data of the 3 LEDs
	LDR R1, =GPIO_PORTF_DATA_R
	LDR R0, [R1]
	BIC R0, R0, #0x0E
	STR R0, [R1]
	BX LR


;same as RGBLED_Init
;we'll also use PUR in the switch
SW1_Init
	;enable port F
	LDR R1, =SYSCTL_RCGCGPIO_R
	LDR R0, [R1]
	ORR R0, R0, #0x20
	STR R0, [R1]
	NOP
	NOP
	
	;set the lock key
	LDR R1, =GPIO_PORTF_LOCK_R
	LDR R0, =0x4C4F434B
	STR R0, [R1]

  ;allow writing to port F
	LDR R1, =GPIO_PORTF_CR_R
	LDR R0, [R1]
	ORR R0, R0, #0x10
	STR R0, [R1]
	
	;disable analog mode
	LDR R1, =GPIO_PORTF_AMSEL_R
	LDR R0, [R1]
	BIC R0, R0, #0x10
	STR R0, [R1]
	
	;clear the port control
	LDR R1, =GPIO_PORTF_PCTL_R
	LDR R0, [R1]
	BIC R0, R0, #0x000F0000
	STR R0, [R1]
	
	;disable the alternate function
	;we work with the switch at bit 4 in the following lines
	LDR R1, =GPIO_PORTF_AFSEL_R
	LDR R0, [R1]
	BIC R0, R0, #0x10
	STR R0, [R1]
	
	;clear the direction (make the switch at bit 4 an input)
	LDR R1, =GPIO_PORTF_DIR_R
	LDR R0, [R1]
	BIC R0, R0, #0x10
	STR R0, [R1]
	
	;use the pull up resistor with the switch
	LDR R1, =GPIO_PORTF_PUR_R
	LDR R0, [R1]
	ORR R0, R0, #0x10
	STR R0, [R1]
	
	;digital enable
	LDR R1, =GPIO_PORTF_DEN_R
	LDR R0, [R1]
	ORR R0, R0, #0x10
	STR R0, [R1]
	BX LR

	END
