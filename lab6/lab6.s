	.data

	.global prompt
	.global mydata

prompt:	.string "Your prompt with instructions is place here", 0
mydata:	.byte	0x20	; This is where you can store data.
			; The .byte assembler directive stores a byte
			; (initialized to 0x20) at the label mydata.
			; Halfwords & Words can be stored using the
			; directives .half & .word


bored:	.string "----------------------", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|          *         |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "|                    |", 0xA, 0xD
		.string "----------------------", 0x0



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
ptr_to_mydata:		.word mydata

lab6:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata

    bl uart_init
	bl uart_interrupt_init
	BL gpio_interrupt_init



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


	MOV pc, lr

Timer_Init:

	PUSH {lr}

   ;Connects clock to Timer by writing a 1 to bit 0
	MOV r0, #0x400FE604
	LDRB r1, [r0]
	ORR r1, r1, #1
	STRB r1, [r0]

	;Disables timer by writing a 0 to bit 0
	MOV r0, #0x4003000
	LDRB r1, [r0, #0x00C]
	BFC r1, #0, #1
	STRB r1. [r0, #0x00C]

	;Set Timer to 32-bit mode
	LDRB r1, [r0]
	ORR r1, r1, #1
	STRB r1, [r0]

	;Set Timer to be in periodic mode
	LDRB r1, [r0, #0x004]
	ORR r1, r1, #0x2
	STRB r1. [r0, #0x004]

	;Enable Timer to interrupt processor
	LDRB r1, [r0, #0x018]
	ORR r1, #0, #1
	STRB r1. [r0, #0x018]

	;Interrupt Servicing, clears interrupt
	LDRB r1, [r0, #0x024]
	ORR r1, r1, #1
	STRB r1, [r0, #0x024]

	;Configure processor to allow Timer to interrupt
	MOV r0, #0xE000E100
	LDR r1, [r0]
	ORR r1, r1, #0x80000
	STR r1, [r0]

	POP {lr}

	MOV pc, lr


UART0_Handler:

	PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}






	POP {r4,r5,r6,r7,r8,r9,r10,r11,lr}

	BX lr       	; Return

Switch_Handler:

	PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}
	PUSH {r0}
	PUSH {r1}






	POP {r1}
	POP {r0}



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


	BX lr       	; Return


simple_read_character:

	PUSH {lr}   ; Store register lr on stack

	MOV r1, #0xC000				;Load from mem the UART Data Register
	MOVT r1, #0x4000

	LDRB r2, [r1]				;Grab the first byte, "data" section holding the character that was pressed on the keyboard
	MOV r0, r2					;Pass to r0 for output character can use it

	POP {lr}
	MOV PC,LR      	; Return

output_character:

	PUSH {lr}   ; Store register lr on stack

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
	;MOV r0, #0xD; if null byte, load value for "enter" instead
	BL output_character
	POP {lr}
	MOV pc, lr

uart_init:
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
;---------------------------------------------------------------------------------------------------------------------------------------------------------------

tiva_init:
	PUSH {lr}
	PUSH {r0}
	PUSH {r1}
;*RGB AND SW1*
	;*Enable clock for port F*
	MOV r0, #0xE608
	MOVT r0, #0x400F

	LDR r1, [r0]
	ORR r1, r1, #32
	STR r1, [r0]

	;*Set pins F1-F3 to be Outputs*
	MOV r0, #0x5400
	MOVT r0, #0x4002

	LDRB r1, [r0]
	ORR r1, r1, #14
	STRB r1, [r0]

	;*Set pin F4 to be an Input*
	MOV r0, #0x5400
	MOVT r0, #0x4002

	LDRB r1, [r0]
	AND r1, r1, #0xEF
	STRB r1, [r0]

	;*Set pins F1-F4 to be Digital*
	MOV r0, #0x551C
	MOVT r0, #0x4002

	LDRB r1, [r0]
	ORR r1, r1, #0x1E
	STRB r1, [r0]

	;*Turn on pullup resistor for pin F4*
	;MOV r0, #0x5510
;	MOVT r0, #0x4002
;
;	LDRB r1, [r0]
;	ORR r1, r1, #16
;	STRB r1, [r0]

	BL not_a_fork_bomb;give time to make sure everything sets before continuing

	POP {r1}
	POP {r0}
	POP {lr}

	MOV pc,lr
;---------------------------------------------------------------------------------------------------------------------------------------------------------------

	.end
