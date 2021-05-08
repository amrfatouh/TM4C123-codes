;the function takes the Port F data as a parameter (in register R0) and only sets the LEDs depending on that data

;parameters: R0 -> data by which LEDs would be set
setLEDs
  LDR R1, =GPIO_PORTF_DATA_R
  LDR R2, [R1]
  BIC R2, #0xE
  AND R0, #0x0E ;set all bits (other than LEDs bits) to zero 
  ORR R2, R0
  STR R2, [R1]

  BX LR