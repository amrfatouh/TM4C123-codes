;PORT ACTIVATION
;activate the port
SYSCTL_RCGCGPIO_R       EQU		  0x400FE608 ;don't forget the NOP
;see whether the port is activated or not
SYSCTL_PRGPIO_R         EQU		  0x400FEA08 ;used instead of NOP

;PORT LOCK
;used to unlock the port
;unlocking the port must precede the rest of the instructions
GPIO_PORTF_LOCK_R       EQU			0x40025520 ;used when dealing with PF0
;used to confirm unlocking the port and enable writing to it
GPIO_PORTF_CR_R         EQU    	0x40025524

;REST OF INITIALIZATIONS
;digital enable
GPIO_PORTF_DEN_R        EQU    	0x4002551C
;pin direction (input/output)
GPIO_PORTF_DIR_R        EQU    	0x40025400
;pull up resistors
GPIO_PORTF_PUR_R        EQU    	0x40025510

;data
GPIO_PORTF_DATA_R       EQU    	0x400253FC

;ALTERNATE FUNCTIONS
;alternate function select
GPIO_PORTF_AFSEL_R      EQU    	0x40025420
;port control - used to determine the selected alternate function
GPIO_PORTF_PCTL_R       EQU			0x4002552C

;analog mode select
GPIO_PORTF_AMSEL_R      EQU    	0x40025528
;??
SYSCTL_RCGC2_R          EQU		  0x400FE108

;SYSTICK
;systick control and status
NVIC_ST_CTRL_R          EQU     0xE000E010
;systick reload
NVIC_ST_RELOAD_R        EQU     0xE000E014
;systick current
NVIC_ST_CURRENT_R       EQU     0xE000E018

;key used to unlock ports
GPIO_LOCK_KEY					  EQU			0x4C4F434B