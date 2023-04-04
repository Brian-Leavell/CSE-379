sw1_interrupt_handler:

	PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}
	PUSH {r0,r1}
  
  
  	;clear the flag here pls thx
	MOV r0, #0x5000			;Load port F address
	MOVT r0, #0x4002
	;Clear intterupt flag for SW1 Tiva to allow a different interrupt to activate if needed
	LDRB r1, [r0,#0x41C]
	ORR r1, #0x10
	STRB r1, [r0, #0x41C]
  
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
