get_nth:
PUSH {lr}
MOV r3, r0
MUL r3, r3, #10; preserve the value for first run of loop2
ADD r1, r1, #1; preserve the value for first run of loop2

nthloop:
DIV r3, r3, #10
SUB r1, r1, #1
CMP r1, #0
BGT nthloop


SDIV r3, r3, #10; divide by 10, round down
MUL r3, r3, #10; multiply by 10, get back same magnitude but 0 in 1's place
SUB r1, r0, r3; subtract rounded down number from original number


MOV r0, r2
POP {lr}
MOV pc, lr
