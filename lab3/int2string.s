PUSH {lr}
PUSH {r0}
MOV r2, r1 ;address to store at is in r2
BL get_length
MOV r1, r0
SUBU r1, r1, #1

I2Sloop:
POP {r0} ;get original r0 back
PUSH {r0} ;preserve original r0
BL get_nth ;gets nth digit specifed in r1 from int in r0, stores in r0
ADD r0, r0, #48; add 48 to get ascii value of digit
STRB r0, [r2]
ADD r2, r2, #1
SUBU r1, r1, #1
CMP r1, #0
BGE loop
MOV r0, #0
STRB r0, [r2]

POP{lr,r0}
MOV pc, lr
