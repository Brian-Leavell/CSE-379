gpio_btn_and_LEDS_init:

PUSH {lr}

*PUSH BUTTONS*
*Enable clock for port D*
MOV r0, #0xE608
MOVT r0, #0x400F

LDR r1, [r0]
ORR r1, r1, #8
STR r1, [r0]

*Set pins D0-D3 to be Input*
MOV r0, #0x7400
MOVT r0, #0x4000

LDRB r1, [r0]	
AND r1, r1, #0xF0
STRB r1, [r0]

*Turn on pullup resistors for D0-D3*
MOV r0, #0x7510
MOVT r0, #0x4000

LDRB r1, [r0]
ORR r1, r1, #15
STRB r1, [r0]

*Set pins 0-3 to be Digital*
MOV r0, #0x751C
MOVT r0, #0x4000

LDRB r1, [r0]
ORR r1, r1, #15
STRB r1, [r0]

*LEDS*
*Enable clock for port B*
MOV r0, #0xE608
MOVT r0, #0x400F

LDR r1, [r0]
ORR r1, r1, #2
STR r1, [r0]

*Set pins B0-B3 to be outputs*
MOV r0, #0x5400
MOVT r0, #0x4000

LDR r1, [r0]
ORR r1, r1, #15
STR r1, [r0]

*Set pins B0-B3 to be digital*
MOV r0, #0x551C
MOVT r0, #0x4000

LDRB r1, [r0]
ORR r1, r1, #15
STRB r1, [r0]

*RGB AND SW1*
*Enable clock for port F*
MOV r0, #0xE608
MOVT r0, #0x400F

LDR r1, [r0]
ORR r1, r1, #32
STR r1, [r0]

*Set pins F1-F3 to be Outputs*
MOV r0, #0x5400
MOVT r0, #0x4002

LDRB r1, [r0]	
ORR r1, r1, #14
STRB r1, [r0]

*Set pin F4 to be an Input*
MOV r0, #0x5400
MOVT r0, #0x4002

LDRB r1, [r0]	
AND r1, r1, #0xEF
STRB r1, [r0]

*Set pins F1-F4 to be Digital*
MOV r0, #0x551C
MOVT r0, #0x4002

LDRB r1, [r0]	
ORR r1, r1, #0x1E
STRB r1, [r0]

*Turn on pullup resistor for pin F4*
MOV r0, #0x5510
MOVT r0, #0x4002

LDRB r1, [r0]
ORR r1, r1, #16
STRB r1, [r0]

BL not_a_fork_bomb

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

POP {lr}
MOV pc, lr