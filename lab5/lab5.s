	.data

	.global prompt
	.global mydata

prompt:	.string "Press a key or SW1 on the Tiva Board, press q to quit :)", 0

UARTcount:		.byte	0x00
Switchcount: 	.byte 	0x00
UARTGraph:		.string "                                                                    ", 0
SwitchGraph:	.string "                                                                    ", 0
UARTgraphprompt:	.string "Key Presses| ", 0
Switchgraphprompt:	.string "SW1 Presses| ", 0
keyboard:		.string "Key Presses: ", 0
tiva:			.string "SW1 Presses: ", 0


	.text

	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler		; This is needed for Lab #6
	.global simple_read_character
	.global output_character	; This is from your Lab #4 Library
	.global read_string		; This is from your Lab #4 Library
	.global output_string		; This is from your Lab #4 Library
	.global uart_init		; This is from your Lab #4 Library
	.global lab5

ptr_to_prompt:		.word prompt
ptr_to_UARTcount:	.word UARTcount
ptr_to_Switchcount:	.word Switchcount
ptr_to_UARTGraph:	.word UARTGraph
ptr_to_SwitchGraph:	.word SwitchGraph


lab5:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata

        bl uart_init
	bl uart_interrupt_init
	bl uart_interrupt_init

	; This is where you should implement a loop, waiting for the user to
	; enter a q, indicating they want to end the program.

	POP {lr}		; Restore lr from the stack
	MOV pc, lr



uart_interrupt_init:
	;Loads UARTIM address
	MOV r0, #0xC000
	MOVT r0, #0x4000

	;Sets RIXM for UART
	LDR r1, [r0, #0x038]
	ORR r1, r1, #0x10
	STR r1, [r0, #0x038]

	;Clear UART Interrupt
	LDRB r1, [r0, #0x044]
	ORR r1, r1, #0x10
	STRB r1, [r0, #0x044]

	;Configures processor to allow UART to interrupt processor
	;Load Interrupt Set Enable Register
	MOV r0, #0xE000
	MOVT r0, #0xE000

	LDRB r1, [r0, #0x100]
	ORR r1, r1, #0x20
	STRB r1, [r0, #0x100]


	MOV pc, lr


gpio_interrupt_init:

	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.

	;Code below turns on clock for port F
	MOV r0, #0xE608
	MOVT r0, #0x400F

	LDRB r1, [r0]
	ORR r1, r1, #32
	STRB r1, [r0]

	;*Set pin F4 to be an Input*
	MOV r0, #0x5000			;Load port F address
    MOVT r0, #0x4002

	LDRB r1, [r0, #0x400]
	AND r1, r1, #0xEF
	STRB r1, [r0, #0x400]

	;*Set pin F4 to be Digital*
	LDRB r1, [r0, #0x51C]
	ORR r1, r1, #0x10
	STRB r1, [r0, #0x51C]

	;Turn on pullup resistor for pin F4
	LDRB r1, [r0, #0x510]
	ORR r1, r1, #16
	STRB r1, [r0, #0x510]

	;Make interrupt for SW1 edge sensitive
	LDRB r1, [r0,#0x404]
	AND r1, #0xEF
	STRB r1, [r0, #0x404]

	;Make interrupt for SW1 single edge triggering
	LDRB r1, [r0,#0x408]
	AND r1, #0xEF
	STRB r1, [r0, #0x408]

	;Make interrupt for SW1 falling edge trigger
	LDRB r1, [r0,#0x40C]
	AND r1, #0xEF
	STRB r1, [r0, #0x40C]

	;Enable intterupt for SW1 Tiva
	LDRB r1, [r0,#0x410]
	ORR r1, #0x10
	STRB r1, [r0, #0x410]

	;Clear intterupt flag for SW1 Tiva to allow a different interrupt to activate if needed
	LDRB r1, [r0,#0x41C]
	ORR r1, #0x10
	STRB r1, [r0, #0x41C]

	;Allow GPIO Port F to use interrupts
	MOV r0, #0xE100
	MOVT r0, #0xE000

	LDRB r1, [r0, #3]
	ORR r1, r1, #0x40
	STRB r1, [r0, #3]

	BL not_a_fork_bomb ;give time to make sure everything sets before continuing

	MOV pc, lr


UART0_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}
	PUSH {r0}
	PUSH {r1}

	;clear the flag here pls thx

	ldr r0, ptr_to_UARTcount	;loads pointer to count data
	LDRB r1, [r0]				;loads byte with count
	ADD r1, r1, #1 	; increase the count of keyboar presses

	STRB r1, [r0]	;store new count value in memory

	ldr r0, ptr_to_UARTgraph ;memory address where we want to store the x's
	BL updart
	BL refresh	;jared from subway comes to clear the screen and update it

	POP {r1}
	POP {r0}
	POP {r4,r5,r6,r7,r8,r9,r10,r11,lr}

	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}



	POP {r4,r5,r6,r7,r8,r9,r10,r11,lr}
	BX lr       	; Return


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed
	; for Lab #5, but will be used in Lab #6.  It is referenced here
	; because the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.
	PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}



	POP {r4,r5,r6,r7,r8,r9,r10,r11,lr}

	BX lr       	; Return
;------------------------------------------------------------------------------------------------------------------------------------------
refresh:
	PUSH {lr}





	POP {lr}
	MOV pc, lr

;------------------------------------------------------------------------------------------------------------------------------------------
simple_read_character:

	PUSH {lr}   ; Store register lr on stack

	MOV r1, #0xC000				;Load from mem the UART Data Register
	MOVT r1, #0x4000

	LDRB r2, [r1]				;Grab the first byte, "data" section holding the character that was pressed on the keyboard
	MOV r0, r2					;Pass to r0 for output character can use it

	POP {lr}
	MOV PC,LR      	; Return

;------------------------------------------------------------------------------------------------------------------------------------------
updart:; takes a memeory address in r0 and a number of x's to put there in r1
	PUSH {lr}
	PUSH {r0}
	PUSH {r1}
	PUSH {r2}

	MOV r2, #120;Save ASCII value for "x" in r2

updartloop:
	BEQ r1, #0, updartend; exit once nummber of x's desired added to string
	STRB r2, [r0]		;store x in memory
	SUB r1, r1, #1		;decrement counter
	ADD r0, r0, #1		;increment memory address
	B updartloop

updartend:
	MOV r2, #0		;store null byte in memory
	STRB r2, [r0]

	POP {r2}
	POP {r1}
	POP {r0}
	POP {lr}
	MOV pc, lr





;------------------------------------------------------------------------------------------------------------------------------------------
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
	MOV pc, lr

;------------------------------------------------------------------------------------------------------------------------------------------
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



;-----------------------------------------------------------------------------------------------------------------------------------------------------

not_a_fork_bomb:;runs a ton of instructions to give time for the pull up register to actually set. Is actually not a fork bomb just a loop
	PUSH {lr}
	PUSH{r0}
	PUSH{r1}

	MOV r0, #0xFFFF
	MOVT r0, #0x0002
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

;---------------------------------------------------------------------------------------------------------------------------------------------------------------


	.end
