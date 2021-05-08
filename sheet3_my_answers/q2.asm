;the function initializes bits 4 to be digital input (as a switch)

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