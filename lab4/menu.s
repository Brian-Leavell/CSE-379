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
option4: 	.string "4.) EXIT (Esc)", 0
num_string: 	.string "    ", 0
gb: 		.string "Matrix Escaped ", 0

	.text

ptr_to_prompt:			.word prompt
ptr_to_prompt2:			.word prompt2
ptr_to_option1:			.word option1
ptr_to_option2:			.word option2
ptr_to_option3:			.word option3
ptr_to_option4:			.word option4
ptr_to_num_string:			.word num_string
ptr_to_gb:				.word gb

menu:

	PUSH {lr}
starthere:
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_prompt2
	ldr r6, ptr_to_option1
	ldr r7, ptr_to_option2
	ldr r8, ptr_to_option3
	ldr r10, ptr_to_option4
	ldr r9, ptr_to_num_string
	ldr r11, ptr_to_gb

	BL serial_init	;Initialize UART
	
	MOV r0, r4	;Place first prompt into r0
	BL output_string	;Output prompt to user

	MOV r0, r5	
	BL output_string	;Outputs second prompt

	;Below prints out the options for the users, 1-4
	MOV r0, r6
	BL output_string
	MOV r0, r7
	BL output_string
	MOV r0, r8
	BL output_string
	MOV r0, r10
	BL output_string

	MOV r0, r9	;Stores whatever user enters into memory
	BL read_string
	BL string2int	;Convert string into integer for menu selection option

	CMP r0, #1
	BEQ rgb_test_go
	
	CMP r0, #2
	BEQ ;led_test_go

	CMP r0, #3
	BEQ keypad_test_go
	
	CMP r0, #0x1B	;Check if user typed escape to terminate
  	BEQ goodbye

	
rgb_test_go:
	BL rgb_test		
	B starthere

led_test_go:
	BL led_test		
	B starthere
	
keypad_test_go:
	BL keypad_test
	B starthere
	
goodbye:
	MOV r0, r11
	BL output_string	;Goodbye prompt

	POP {lr}
	MOV pc, lr
