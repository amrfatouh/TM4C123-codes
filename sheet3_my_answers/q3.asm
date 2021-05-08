;the function reads the value of Pin 4 and puts it in R0

;returns the value of bit 4 at R0
readPin4
  LDR R0, =GPIO_PORTF_DATA_R
  LDR R0, [R0]
  MOV R1, #0x10
  AND R0, R1

  BX LR