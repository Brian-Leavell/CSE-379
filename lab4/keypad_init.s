*********************************
* KEYPAD_INIT					;
* This subroutine initializes 	;
*	the daughter board keypad	;
*								;
* Authors:						;
*	Caroline Hart				;
*	Anthony Roberts				;
								;
* Register Usage:				;
*	R0	- stores an address		;
*	R1	- stores the contents	;
*		   of a memory register	;
keypad_init:					;
	PUSH {lr}					;
* Enable the clock for GPIO Port A and Port D
	LDR r1, SYSCTL				; Load base address of System Control
	LDRB r0, [r1,#RCGCGPIO]		; Load contents of RCGCGPIO register
	ORR r0, r0, #0x9			; Set bit 3 to enalbe and provide a clock to GPIO Port A & Port D
	STRB r0, [r1,#RCGCGPIO]		; Store modifed value of RCGCGPIO register back to memory
								;
* Set GPIO Port D, Pints 0-3 direction to Output
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODIR] 	; Load contents of GPIODIR register
	ORR r0, r0, #0xF			; Set bits 0-3 to set GPIO direction to Output
	STRB r0, [r1, #GPIODIR] 	; Store modifed value of GPIODIR register back to memory
								;
* Set GPIO Port A, Pints 2-5 direction to Input
	LDR r1, GPIO_PORT_A			; Load base address of GPIO Port A
	LDRB r0, [r1, #GPIODIR] 	; Load contents of GPIODIR register
	BIC r0, r0, #0x3C			; Clear bits 2-5 to set GPIO direction to input
	STRB r0, [r1, #GPIODIR] 	; Store modifed value of GPIODIR register back to memory
								;
* Enable GPIO Port D, Pins 0-3 as Digital
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #0xF			; Set bits 0-3 to set pins to digital
	STRB r0, [r1, #GPIODEN] 	; Store modifed value of GPIODEN register back to memory
								;
* Enable GPIO Port A, Pins 2-5 as Digital
	LDR r1, GPIO_PORT_A			; Load base address of GPIO Port A
	LDRB r0, [r1, #GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #0x3C			; Set bits 2-5 to set pins to digital
	STRB r0, [r1, #GPIODEN] 	; Store modifed value of GPIODEN register back to memory
								;
* Enable GPIO Port D, Pins 0-3  ;
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODATA] 	; Load contents of GPIODATA register
	ORR r0, r0, #0xF			; Set bits 0-3 to set pins to digital
	STRB r0, [r1, #GPIODATA] 	; Store modifed value of GPIODATA register back to memory
								;
	POP {pc}					; Return to caller
* END OF KEYPAD_INIT			;
*********************************