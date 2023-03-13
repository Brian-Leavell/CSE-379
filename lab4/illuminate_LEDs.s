illuminate_LEDs:

PUSH {lr}

*Load Port B data register*
MOV r2, #0x53FC
MOVT r2, #0x4000

*Insert data passed into r0 into LEDs data register*
LDRB r1, [r2]
BFI r1, r0, #0, #4

STRB r1, [r2]

POP {lr}
MOV pc, lr