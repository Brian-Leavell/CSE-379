read_from_push_btns:

	PUSH {lr}

	*Loads data register from port D*
	MOV r0, #0x73FC
	MOVT r0, #0x4000

	LDRB r1, [r0] 
	MOV r2, #0	;ACC

	*Extract bit 0*
	UBFX r1, r1, #0, #1
	LSL r1, r1, #3
	ADD r2, r2, r1

	*Extract bit 1*
	UBFX r1, r1, #1, #1
	LSL r1, r1, #2
	ADD r2, r2, r1

	*Extract bit 2*
	UBFX r1, r1, #2, #1
	LSL r1, r1, #1
	ADD r2, r2, r1

	*Extract bit 3*
	UBFX r1, r1, #3, #1
	ADD r2, r2, r1

	MOV r0, r2

	POP {lr}
	MOV pc, lr



