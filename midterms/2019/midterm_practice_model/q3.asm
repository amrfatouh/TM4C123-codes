SYSCTL_RCGCGPIO_R 
GPIO_PORTB_DATA_R
GPIO_PORTB_DIR_R
GPIO_PORTB_AFSEL_R
GPIO_PORTB_PUR_R
GPIO_PORTB_PDR_R
GPIO_PORTB_DEN_R
GPIO_PORTB_LOCK_R
GPIO_PORTB_CR_R
GPIO_PORTB_AMSEL_R
GPIO_PORTB_PCTL_R
NVIC_ST_CTRL_R 
NVIC_ST_RELOAD_R
NVIC_ST_CURRENT_R

;activate port b
;enable writing to port b (commit)
;den
;dir

init
  ;activate Port B (bit 1) 0000_0010
  LDR R0, =SYSCTL_RCGCGPIO_R
  MOV R1, #0x02
  STR R1, [R0]

  ;enable writing to Port B
  LDR R0, =GPIO_PORTB_CR_R
  MOV R1, #0xFF
  STR R1, [R0]

  ;digital enable
  LDR R0, =GPIO_PORTB_DEN_R
  MOV R1, #0xFF
  STR R1, [R0]

  ;direction bit5: output (1), bit1: input (0) => 0010_0000 => 0x20
  LDR R0, =GPIO_PORTB_DIR_R
  MOV R1, #0x20
  STR R1, [R0]
  
  BX LR



checkObstacle
  LDR R0, =GPIO_PORTB_DATA_R
  LDR R1, [R0]
  ;if bit 1 == 1, then: there is obstacle
  ;and with: 0010 => 0x2
  AND R1, #0x2
  CMP R1, #0
  BEQ noObstacle
  MOV R1, #0x20
  LDR R2, [R0]
  ORR R2, R1
  STR R2, [R0]
  B exit
noObstacle
  MOV R1, #0x20
  LDR R2, [R0]
  BIC R2, R1
  STR R2, [R0]
exit
  BX LR