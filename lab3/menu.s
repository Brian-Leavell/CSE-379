	  .data

	  .global prompt
  	.global results
  	.global num_1_string
 	 .global num_2_string
  	.global serial_init

prompt:		.string "Commence Testing :)", 0
prompt2: 	.string "Select an Option Below", 0
option1: 	.string "1.) RGB LED (SW1 Tiva)", 0
option2: 	.string "2.) LED + Switches", 0
option3: 	.string "3.) Keypad", 0
num_string: 	.string "    ", 0

	.text

ptr_to_prompt:			.word prompt
ptr_to_prompt2:			.word prompt2
ptr_to_option1:			.word option1
ptr_to_option2:			.word option2
ptr_to_option3:			.word option3
ptr_to_num_string:			.word num_string

menu:

	PUSH {lr}
starthere:
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_prompt2
	ldr r6, ptr_to_option1
	ldr r7, ptr_to_option2
	ldr r8, ptr_to_option3
	ldr r9, ptr_to_num_string

	BL serial_init	;Initialize UART
	
	MOV r0, r4	;Place first prompt into r0
	BL output_string	;Output prompt to user

	MOV r0, r5	
	BL output_string	;Outputs second prompt

	;Below prints out the options for the users, 1-5
	MOV r0, r6
	BL output_string
	MOV r0, r7
	BL output_string
	MOV r0, r8
	BL output_string

	MOV r0, r9	;Stores whatever user enters into memory
	BL read_string
	BL string2int	;Convert string into integer for menu selection option

	CMP r0, #1
	BEQ rgb_test_go
	
	CMP r0, #2
	BEQ ;LEDs test

	CMP r0, #3
	BEQ ;Keypad test



	
rgb_test_go:
	BL rgb_test		
	B starthere

led_test_go:
	BL led_test		
	B starthere

	





	POP {lr}
	MOV pc, lr
