w - 0x77
a - 0x61
s - 0x73
d - 0x64


update_pos:

	PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}
  PUSH {r0,r1}

  ;Load pointer to previously pushed key
  MOV r0, ptr_to_prev_key
  
  CMP r0, #0x77
  BEQ yInc
  
  CMP r0, #0x61
  BEQ xDec
  
  CMP r0, #0x73
  BEQ yDec
  
  CMP r0, #0x64
  BEQ xInc
  
  

yInc:


yDec:


xInc:


xDec:





  POP {r0,r1}
	POP {r4,r5,r6,r7,r8,r9,r10,r11,lr}
  MOV pc, lr
