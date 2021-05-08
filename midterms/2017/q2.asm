LDR R0, =FirstNum
MOV R1, #0 ;iterator
loop
  CMP R1, #10
  BGE endLoop

  LDR R2, [R0, R1, LSL #2]
  ADD R3, R2

  ADD R1, #1
  B loop
endLoop

  UDIV R3, #10 ;divide th sum by 10
  MOV R5, R3