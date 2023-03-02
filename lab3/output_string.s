PUSH {lr}
MOV r1, r0; put mem adress in r1 since r0 will be changed

OSloop:
LRB r0, [r1]; get byte at mem pointer
CMP r0, #0; chec to see if null byte hit
BEQ OSend
BL output_char
ADD r1, r1, #1; increment memory pointer to next digit

OSend:
MOV r0, 0xA; if null byte, load value for "enter" instead
BL output_char
POP {lr}
MOV pc, lr
