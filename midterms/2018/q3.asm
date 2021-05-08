  LDR R0, =num
  MOV R1, #0
  STR R1, [R0]

loop
  ADD R1, #1
  STR R1, [R0]
  B loop