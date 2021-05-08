loop
  CMP R4, #100
  BNE loop
  LDR R0, =GPIO_PORTF_DATA_R
  LDR R1, [R0]
  ORR R1, 0x02
  STR R1, [R0]
  B loop