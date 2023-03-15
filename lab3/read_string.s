read_string:
  PUSH {lr}; reads standard input and stores at address beginning at r0
  MOV r1, r0

read_stringloop:
  PUSH {r1}
  BL read_character
  BL output_character
  POP {r1}
  CMP r0, #0xA
  BEQ RSend
  STRB r0, [r1]
  ADD r1, r1, #1
  B read_stringloop

RSend:
  MOV r0, #0
  STRB r0, [r1]
  POP{lr}
  MOV pc, lr
