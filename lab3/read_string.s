PUSH {lr}; reads standard input and stores at address beginning at r1
loop:
BL read_char
BL print_char
CMP r0, #0xA
BEQ end
STRB r0, [r1]
ADD r1, r1, #1
B loop

end:
MOV r0, #0
STRB r0, [r1]
POP{lr}
MOV pc, lr
