;the function initializes bits 1-3 to be digital outputs

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