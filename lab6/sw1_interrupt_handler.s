sw1_interrupt_handler:

  PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}
  PUSH {r0,r1}
  
  ;Address that holds time interval of Timer
  MOV r0, #0x0
  MOVT r0, #0x4003
  
  ;Divide by 2 so * moves twice as fast
  LDR r1, [r0, #0x028]
  LSR r1, r1, #1
  STR r1, [r0, #0x028]
  
  
  POP {r0,r1}
	POP {r4,r5,r6,r7,r8,r9,r10,r11,lr}
  MOV pc, lr
