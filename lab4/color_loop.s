*PORT F, RED = 1 BLUE = 2 GREEN = 3
*RED		001	1
*BLUE   	010	2
*GREEN		100	4
*YELLOW		110	6
*PURPLE		011	3
*WHITE		111	7

*ADD BRANCH AT END OF ILLIMNAITE RGB TO GO BACK TO BTN PUSHED CHECK SUBROUTINE

btn_pushed_check:
	PUSH {r2} ;use as ACC preserve incase other routine uses it
	MOV r2, 0

	BL read_from_push_btn
	CMP r0, #1
	BEQ color_loop
	B btn_push_check


color_loop:

	PUSH {lr}
	ADD r2, r2, #1 ;increment ACC 

	*LIGHT UP RED*
	CMP r2, #1
	BEQ red_light

	*LIGHT UP BLUE*
	CMP r2, #2
	BEQ blue_light

	*LIGHT UP GREEN*
	CMP r2, #3
	BEQ green_light

	*LIGHT UP YELLOW*
	CMP r2, #4
	BEQ yellow_light

	*LIGHT UP PURPLE*
	CMP r2, #5
	BEQ purple_light

	*LIGHT UP WHITE*
	CMP r2, #6
	BEQ white_light

	POP {lr}
	MOV pc, lr


red_light:

	PUSH {lr}

	MOV r0, #1
	BL illuminate_RGB_LED

	POP {lr}
	MOV pc, lr

blue_light:

	PUSH {lr}

	MOV r0, #2
	BL illuminate_RGB_LED
	

	POP {lr}
	MOV pc, lr

green_light:

	PUSH {lr}

	MOV r0, #4
	BL illuminate_RGB_LED

	POP {lr}
	MOV pc, lr

yellow_light:

	PUSH {lr}

	MOV r0, #6
	BL illuminate_RGB_LED

	POP {lr}
	MOV pc, lr

purple_light:

	PUSH {lr}

	MOV r0, #3
	BL illuminate_RGB_LED

	POP {lr}
	MOV pc, lr

white_light:

	PUSH {lr}

	MOV r0, #7
	MOV r2, #0
	BL illuminate_RGB_LED

	POP {lr}
	MOV pc, lr