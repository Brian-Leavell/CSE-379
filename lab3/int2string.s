PUSH {lr};takes int in r0 and address in r1, converts the int to a string and stores at r1
PUSH {r0}
MOV r2, r1 ;address to store at is in r2
PUSH {r2}
BL get_length
POP {r2}
MOV r1, r0
SUB r1, r1, #1

I2Sloop:
POP {r0} ;get original r0 back
PUSH {r0,r1,r2} ;preserve original r0, current r1 and r2
BL get_nth ;gets nth digit specifed in r1 from int in r0, stores in r0
POP {r1,r2} get back r1 and r2 that may have been changed in get_nth
ADD r0, r0, #48; add 48 to get ascii value of digit
STRB r0, [r2]
ADD r2, r2, #1
SUB r1, r1, #1
CMP r1, #0
BGE loop
MOV r0, #0
STRB r0, [r2]

POP{lr,r0}
MOV pc, lr
