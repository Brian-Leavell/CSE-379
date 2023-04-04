update_pos:

  PUSH {r4,r5,r6,r7,r8,r9,r10,r11,lr}
  PUSH {r0,r1}

  ;Load pointer to previously pushed key
  MOV r0, ptr_to_prev_key
  
  ;Key pressed was w
  CMP r0, #0x77
  BEQ yInc
  ;Key pressed was a
  CMP r0, #0x61
  BEQ xDec
  ;Key pressed was s
  CMP r0, #0x73
  BEQ yDec
  ;Key pressed was d
  CMP r0, #0x64
  BEQ xInc
  
  
;Increments y coord by 1
yInc:
    MOV r1, ptr_to_y_coord
    ADD r1, r1, #1
    B end
    
;Decrements y coord by 1
yDec:
    MOV r1, ptr_to_y_coord
    SUB r1, r1, #1
    B end

;Increments x coord by 1
xInc:
    MOV r1, ptr_to_x_coord
    ADD r1, r1, #1
    B end

;Decrements x coord by 1
xDec:
    MOV r1, ptr_to_x_coord
    SUB r1, r1, #1
    B end

end:
  BL update_col  ;called to see if a collision occured
  
  POP {r0,r1}
  POP {r4,r5,r6,r7,r8,r9,r10,r11,lr}
  MOV pc, lr
