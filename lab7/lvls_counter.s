lvls_counter:

  PUSH {lr}
  PUSH {r0,r1,r2,r3}
  
  MOV r0, #0

;*Load Port B data register*
  MOV r2, #0x53FC
  MOVT r2, #0x4000

;Load data from LEDs data register*
  LDRB r1, [r2]
  
loop:
  AND r3, r1, #1
  CMP r3, #1
  BEQ push
  LSR r1, r1, #1
  B loop
    

push:
  ADD r0, r0, #1  ;increment acc
  CMP r0, #4
  BEQ end
  LSR r1, r1, #1
  B loop
  
end:
  ldr r2, ptr_to_lvl_count	;store value in memory for future subroutine
  STRB r0, [r2]
  
  POP {r0,r1,r2,r3}
  POP {lr}
  MOV pc, lr
