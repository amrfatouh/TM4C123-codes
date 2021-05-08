;x: positive/negative/zero number
;y: absolute value of that number

  LDR R0, =x
  LDR R0, [R0]
  CMP R0, #0
  BGE skip
  MOV R1, #0xFFFFFFFF
  EOR R0, R1
  ADD R0, #1
skip
  LDR R1, =y
  STR R0, [R1]