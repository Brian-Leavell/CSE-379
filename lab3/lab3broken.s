.data

.global prompt
.global results
.global num_1_string
.global num_2_string
.global serial_init

prompt:	.string "Enter your first number: ", 0
prompt2: .string "Enter your second number: ", 0
result:	.string "Average: ", 0
num_1_string: 	.string "                             ", 0
num_2_string:  	.string "                             ", 0
num_3_string:  	.string "                             ", 0
prompt3:	.string "Restart Program? (y/n)", 0
gb: 		.string "CYA :) ", 0
.text

.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_prompt:			.word prompt
ptr_to_prompt2:			.word prompt2
ptr_to_result:			.word result
ptr_to_num_1_string:	.word num_1_string
ptr_to_num_2_string:	.word num_2_string
ptr_to_num_3_string:	.word num_3_string
ptr_to_prompt3:			.word prompt3
ptr_to_gb:				.word gb

lab3:
PUSH {lr}   ; Store lr to stack
ldr r4, ptr_to_prompt
ldr r8, ptr_to_prompt2
ldr r5, ptr_to_result
ldr r6, ptr_to_num_1_string
ldr r7, ptr_to_num_2_string
ldr r9, ptr_to_num_3_string
ldr r11, ptr_to_prompt3

	; Your code is placed here.  This is your main routine for
	; Lab #3.  This should call your other routines such as
	; uart_init, read_string, output_string, int2string, &
	; string2int
BL serial_init	 ;Initilaizes UART

MOV r0, r4	 ;Places pointer pointing to first prompt in memory into r0 so it can be used by output_string
BL output_string ;First prompt needs to be printed to the screen

MOV r0, r6	 ;This is the address that we want to store the first number at
BL read_string	 ;Stores the number the user will enter

MOV r0, r8	 ;Places pointer pointing to second prompt in memory into r0 so it can be used by output_string
BL output_string ;Second prompt needs to be printed to the screen

MOV r0, r7	 ;This is the address that we want to store the second number at
BL read_string	 ;Stores the number the user will enter


MOV r0, r6	;Address where first entered number is stored
BL string2int	;Convert stored number into an integer

MOV r2, r0	;Copy number from memory after converting it to integer
push {r2}	;preserve r2

MOV r0, r7	;Address where second entered number is stored
BL string2int	;Convert stored number into an integer
pop {r2}	;Return r2 from stack

MOV r3, r0	;Copy number from memory after converting it to integer

MOV r8, #2	;Register needed to divide by 2
ADD r2, r2, r3	;Adds two numbers together
SDIV r2, r2, r8  ;Average

MOV r0, r2	;Move average into r0
MOV r1, r9	;Address where we store the string
BL int2string	;Converts average into string

MOV r0, r5
BL output_string ;Memory address where RESULT prompt is stored

MOV r0, r9
BL output_string ;Memory address where the average number is stored

MOV r0, r11	;Restart prompt loaded
BL output_string

BL read_character

CMP r0, #0x79	;Check if user typed y to restart
BEQ lab3
CMP r0, #0x59
BEQ lab3

ldr r11, ptr_to_gb

MOV r0, r11
BL output_string	;Goodbye prompt



POP {lr}	  ; Restore lr from stack
mov pc, lr


read_string:
PUSH {lr}; reads standard input and stores at address beginning at r0
MOV r1, r0

read_stringloop:
PUSH {r1}
BL read_character
BL output_character
POP {r1}
CMP r0, #0xA
BEQ RSend
STRB r0, [r1]
ADD r1, r1, #1
B read_stringloop

RSend:
MOV r0, #0
STRB r0, [r1]
POP{lr}
MOV pc, lr


output_string:
PUSH {lr};prints the null terminated string starting at address in r0 to standard output
MOV r1, r0; put mem adress in r1 since r0 will be changed

OSloop:
LDRB r0, [r1]; get byte at mem pointer
CMP r0, #0; check to see if null byte hit
BEQ OSend
PUSH {r1}
BL output_character
POP {r1}
ADD r1, r1, #1; increment memory pointer to next digit
B OSloop

OSend:
MOV r0, #0xD; if null byte, load value for "enter" instead
BL output_character
POP {lr}
MOV pc, lr


read_character:
PUSH {lr}   ; Store register lr on stack

	; Your code for your read_character routine is placed here
MOV r1, #0xC018				;These two lines move the flag data register address from mem into r1
MOVT r1, #0x4000

rcharloop:
LDRB r3, [r1]				;Offset to reach TxFF and TxFE
AND r3, r3, #0x10			;AND Logic to isolate bit stored in TxFE register

CMP r3, #0					;If 0, flag is set and register is holding a value
BEQ gotit
B rcharloop						;Reload and AND again if flag is a 1, meaning register is empty

gotit:
MOV r1, #0xC000				;Load from mem the UART Data Register
MOVT r1, #0x4000

LDRB r3, [r1]				;Grab the first byte, "data" section holding the character that was pressed on the keyboard
MOV r0, r3					;Pass to r0 for output character can use it

POP {lr}
mov pc, lr


output_character:
PUSH {lr}   ; Store register lr on stack

	; Your code for your output_character routine is placed here

MOV r1, #0xC018; load bottom of flag register address into r1
MOVT r1, #0x4000; load top of flag register address into r1
MOV r2, #0xC000; load bottom of data register address into r2
MOVT r2, #0x4000; load top of data register address into r2

mysillylittlelabel:
LDRB r3, [r1]; load value in flag register into r3
AND r3, r3, #0x20; mask to get value of TxFF
CMP r3, #0; see if TxFF is zero yet
BNE mysillylittlelabel; if TxFF is not zero yet, load and check agaiN
CMP r0, #0xD
BEQ fixreturn
STRB r0, [r2]; if TxFF is zero, store value of r0 in data register
B afterfixreturn
fixreturn:
STRB r0, [r2]
MOV r0, #0xA
B mysillylittlelabel
afterfixreturn:
POP {lr}
mov pc, lr


serial_init:
PUSH {lr}  ; Store register lr on stack

;Enables clock for UART0
MOV r0, #0xE618
MOVT r0, #0x400F
MOV r1, #1
STR r1, [r0]
;Enables clock for PORTA
MOV r0, #0xE608
MOVT r0, #0x400F
MOV r1, #1
STR r1, [r0]
;Disables UART0 control
MOV r0, #0xC030
MOVT r0, #0x4000
MOV r1, #0
STR r1, [r0]
;Sets the Baud Rate for UART0_IBRD_R to 115,200
MOV r0, #0xC024
MOVT r0, #0x4000
MOV r1, #8
STR r1, [r0]
;Sets the Baud Rate for UART0_FBRD_R to 115,200
MOV r0, #0xC028
MOVT r0, #0x4000
MOV r1, #44
STR r1, [r0]
;Ensures we are using the system clock
MOV r0, #0xCFC8
MOVT r0, #0x4000
MOV r1, #0
STR r1, [r0]
;Sets the word length to 8 bits with 1 stop bit and no parity bits
MOV r0, #0xC02C
MOVT r0, #0x4000
MOV r1, #0x60
STR r1, [r0]
;Enables UART0 Control
MOV r0, #0xC030
MOVT r0, #0x4000
MOV r1, #0x301
STR r1, [r0]

;Sets PA0 to Digital Port
MOV r0, #0x451C
MOVT r0, #0x4000
LDR r1, [r0]
ORR r1, r1, #0x03
STR r1, [r0]
;Sets PA1 to Digital Port
MOV r0, #0x4420
MOVT r0, #0x4000
LDR r1, [r0]
ORR r1, r1, #0x03
STR r1, [r0]
;Configures PA0 and PA1 for UART0
MOV r0, #0x452C
MOVT r0, #0x4000
LDR r1, [r0]
ORR r1, r1, #0x11
STR r1, [r0]

POP {lr}
mov pc, lr

int2string:
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
PUSH {r0}
PUSH {r1} ;preserve original r0, current r1 and r2
BL get_nth ;gets nth digit specifed in r1 from int in r0, stores in r0
POP {r1}; get back r1 and r2 that may have been changed in get_nth
ADD r0, r0, #48; add 48 to get ascii value of digit
STRB r0, [r2]
ADD r2, r2, #1
SUB r1, r1, #1
CMP r1, #0
BGE I2Sloop
MOV r0, #0
STRB r0, [r2]

POP{lr,r0}
MOV pc, lr



string2int:
PUSH {lr}   ; Store register lr on stack

MOV r2, #0	;This keeps track of the decimal, ensuring the individual digits get added properly into the correct 10s spot
MOV r3, #10	;Constant allowing us to multiply by 10 inside of loop

s2iloop:
LDRB r1, [r0]	;Loads the first digit from memory

CMP r1, #0x00		;Check is value in r1 is ASCII Null, which means it's the end of the number
BEQ FINISH		;This means the string is over, as a NULL byte indicates the end of the string

MUL r2, r2, r3	;Move decimal to the right 1
SUB	r1, r1, #48	;Converts ASCII value to its true value
ADD r2, r2, r1	;Places value into r2 before decimal is moved again
ADD r0, r0, #0x1 ;Increment pointer to go to next digit in memory

B s2iloop

FINISH:
MOV r0, r2

POP {lr}
mov pc, lr

get_length:
PUSH {lr}
MOV r2, #0; initialize accumulator in r2 to 0
MOV r3, r0; put r0 in r3 so we can modify r0's value without losing r0
MOV r10, #10

get_lengthloop:
ADD r2, r2, #1; increase digit count
SDIV r3, r3, r10; divide by 10 and round down (trying to get to 0)
CMP r3, #0; checking to see if 0 is reached
BGT get_lengthloop; if not at zero, we know there's another digit so divide and accumulate again
MOV r0, r2
POP {lr}
MOV pc, lr

get_nth:;takes int in r0 and index in r1, returns number at that index in r0
PUSH {lr}
MOV r4, #10
MOV r3, r0
MUL r3, r3, r4; preserve the value for first run of loop2
ADD r1, r1, #1; preserve the value for first run of loop2

get_nthloop:
SDIV r3, r3, r4
SUB r1, r1, #1
CMP r1, #0
BGT get_nthloop

MOV r0, r3
SDIV r3, r3, r4; divide by 10, round down
MUL r3, r3, r4; multiply by 10, get back same magnitude but 0 in 1's place
SUB r1, r0, r3; subtract rounded down number from original number

MOV r0, r1
POP {lr}
MOV pc, lr

.end
