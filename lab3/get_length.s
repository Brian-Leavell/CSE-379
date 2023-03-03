get_length:
PUSH {lr}
MOV r2, #0; initialize accumulator in r2 to 0
MOV r3, r0; put r0 in r3 so we can modify r0's value without losing r0

get_lengthloop:
ADD r2, r2, #1; increase digit count
SDIV r3, r3, #10; divide by 10 and round down (trying to get to 0)
CMP r3, #0; checking to see if 0 is reached
BGT get_lengthloop; if not at zero, we know there's another digit so divide and accumulate again
MOV r0, r2
POP {lr}
MOV pc, lr
