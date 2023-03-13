.text
.global lab4

lab4:
	PUSH {lr}

	;Code below turns on clock for port F
	MOV r0, #0xE608
	MOVT r0, #0x400F

	LDRB r1, [r0]
	ORR r1, r1, #32

	STRB r1, [r0]

test_output_red:
	BL read_from_push_btn
	CMP r0, #1
	BEQ call_output_red
	B test_output_red


call_output_red:
	MOV r0, #1
	BL illuminate_RGB_LED

theend:

	POP {lr}
	MOV pc, lr

read_from_push_btn:
	PUSH {lr}

	;loads base address for port f into r0
	MOV r0, #0x5000
	MOVT r0, #0x4002
	;sets the bit for pin 4 to be an input
	LDRB r1, [r0, #0x400]
	BIC r1, r1, #16
	STRB r1, [r0, #0x400]
	;set pin 4 to be digital
	LDRB r1, [r0, #0x51C]
	ORR r1, r1, #16
	STRB r1, [r0, #0x51C]
	;sets the pull up register for PF4
	LDRB r1, [r0, #0x510]
	ORR r1, r1, #16
	STRB r1, [r0, #0x510]
	BL not_a_fork_bomb
	;loads the data register for port f and stores the value for pin 4 in r0
	LDRB r1, [r0, #0x3FC]
	UBFX r1, r1, #4, #1
	MVN r0, r1
	AND r0, r0, #1


	POP {lr}
	MOV pc, lr

illuminate_RGB_LED:
	PUSH {lr}

				;
	MOV r1, #0x5000
	MOVT r1, #0x4002

	;sets the bits for pins 1,2,3 to be outputs
	LDRB r2, [r1, #0x400]
	ORR r2, r2, #14
	STRB r2, [r1, #0x400]
	;sets the bits for pins 1,2,3 to be digital
	LDRB r2, [r1, #0x51C]
	ORR r2, r2, #14
	STRB r2, [r1, #0x51C]
	;loads the data register for port f, inserts the desired bits for the LEDs to be active, and stores the new value for the data register back.
	LDRB r2, [r1, #0x3FC]
	BFI r2, r0, #1, #3
	STRB r2, [r1, #0x3FC]


	POP {lr}
	MOV pc, lr

not_a_fork_bomb:;runs a ton of instructions to give time for the pull up register to actually set. Is actually not a fork bomb just a loop
	PUSH {lr}
	PUSH{r0}
	PUSH{r1}

	MOV r0, #0x7FFF
	MOV r1, #0

perhaps_a_fork_bomb:
	SUB r0, r0, #1
	CMP r0, r1
	BEQ nomorefork
	B perhaps_a_fork_bomb

nomorefork:
	POP {r1}
	POP {r0}
	POP {lr}

	MOV pc, lr


.end
