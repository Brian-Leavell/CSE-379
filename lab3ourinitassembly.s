.text

.global lab3
.global serial_init



lab3:
PUSH {lr}   ; Store lr to stack

  ; Your code is placed here.
  ; Sample test code starts here
  ;BL serial_init
  BL read_character
  BL output_character

  ; Sample test code ends here


POP {lr}	  ; Restore lr from stack
mov pc, lr
read_character:
PUSH {lr}   				;Store register lr on stack
              ; Your code to receive a character obtained from the keyboard
              ; in PuTTy is placed here.  The character is received in r0.


MOV r1, #0xC018				;These two lines move the flag data register address from mem into r1
MOVT r1, #0x4000

LOOP:
LDRB r3, [r1]			;Offset to reach TxFF and TxFE
AND r3, r3, #0x10			;AND Logic to isolate bit stored in TxFE register

CMP r3, #0					;If 0, flag is set and register is holding a value
BEQ GOTIT
B LOOP						;Reload and AND again if flag is a 1, meaning register is empty

GOTIT:
MOV r1, #0xC000				;Load from mem the UART Data Register
MOVT r1, #0x4000

LDRB r3, [r1]				;Grab the first byte, "data" section holding the character that was pressed on the keyboard
MOV r0, r3					;Pass to r0 for output character can use it

POP {lr}
mov pc, lr

output_character:
PUSH {lr}     ; Store register lr on stack

          ; Your code to output a character to be displayed in PuTTy
            ; is placed here.  The character to be displayed is passed
            ; into the routine in r0.

MOV r1, #0xC018; load bottom of flag register address into r1
MOVT r1, #0x4000; load top of flag register address into r1
MOV r2, #0xC000; load bottom of data register address into r2
MOVT r2, #0x4000; load top of data register address into r2

mysillylittlelabel:
LDRB r3, [r1]; load value in flag register into r3
AND r3, r3, #0x20; mask to get value of TxFF
CMP r3, #0; see if TxFF is zero yet
BNE mysillylittlelabel; if TxFF is not zero yet, load and check agaiN
STRB r0, [r2]; if TxFF is zero, store value of r0 in data register

POP {lr}
mov pc, lr

serial_init:
PUSH{lr}

MOV r0, #0xE618
MOVT r0, #0x400F
MOV r1, #1
STR r1, [r0]

MOV r0, #0xE608
MOVT r0, #0x400F
MOV r1, #1
STR r1, [r0]

MOV r0, #0xC030
MOVT r0, #0x4000
MOV r1, #0
STR r1, [r0]

MOV r0, #0xC024
MOVT r0, #0x4000
MOV r1, #8
STR r1, [r0]

MOV r0, #0xC028
MOVT r0, #0x4000
MOV r1, #44
STR r1, [r0]

MOV r0, #0xCFC8
MOVT r0, #0x4000
MOV r1, #0
STR r1, [r0]

MOV r0, #0xC02C
MOVT r0, #0x4000
MOV r1, #0x60
STR r1, [r0]

MOV r0, #0xC030
MOVT r0, #0x4000
MOV r1, #0x301
STR r1, [r0]


MOV r0, #0x451C
MOVT r0, #0x4000
LDR r1, [r0]
ORR r1, r1, #0x03
STR r1, [r0]

MOV r0, #0x4420
MOVT r0, #0x4000
LDR r1, [r0]
ORR r1, r1, #0x03
STR r1, [r0]

MOV r0, #0x452C
MOVT r0, #0x4000
LDR r1, [r0]
ORR r1, r1, #0x11
STR r1, [r0]

POP{lr}
MOV pc, lr

.end
