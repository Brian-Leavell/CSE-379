write_pos:

	PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}
  PUSH {r0, r1}
  
  
  MOV r2, #24 ;constant for multiplying to go through rows of board
  
  ;Load the y coordinate, mult by 24 to get what row we are in currently
  MOV r0, ptr_to_y_coord
  MUL r0, r0, r2
  
  ;Load x coordinate and combine with y to find location with *
  MOV r1, ptr_to_x_coord
  ADD r0, r0, r1
  
  ;Load board with this offset to go to that playable space
  MOV r3, ptr_to_bored
  ADD r3, r3, r0
  
  ;Load * into register and write onto the board
  MOV r1, #0x2A
  STRB r1, [r3] 
  
  
  POP {r0,r1}
	POP {r4,r5,r6,r7,r8,r9,r10,r11,lr}
  MOV pc, lr
