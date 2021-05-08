LDR R0, =Num

func
  LDR R1, [R0]
  CMP R1, #100
  BGE else
  ADD R1, #1
  B endIf
else
  MOV R1, #-100
endIf
  STR R1, [R0]

  BX LR