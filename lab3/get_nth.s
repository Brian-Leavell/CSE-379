get_nth:;takes int in r0 and index in r1, returns number at that index in r0
PUSH {lr}
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
