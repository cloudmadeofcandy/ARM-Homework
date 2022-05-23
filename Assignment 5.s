	AREA RESET, DATA, READONLY
	EXPORT vector
vector
	DCD 0x20001000
	DCD _main	
	
	AREA MEM, DATA
input DCD 25;
arr SPACE 100*4;
dividend DCD 0;
divisor DCD 0;
quotient DCD 0;
modulo DCD 0;	
	ALIGN
	
	AREA MYCODE, CODE, READONLY
	ENTRY
	EXPORT _main

from_hex_to_binary PROC
	LDR R0, =input;
	LDR R0, [R0];
	LDR R5, =arr
loop
	CMP R0, #0;
	BEQ toarr;
	AND R1, R0, #1;
	PUSH {R1};
	LSR R0, #1;
	ADD R2, #1
	B loop;
toarr
	CMP R2, #0;
	BEQ stop1;
	SUB R2, #1;
	POP {R3};
	STRB R3, [R5], #1;
	B toarr;
stop1
	BX LR
	ENDP


from_hex_to_oct PROC
	LDR R0, =input;
	LDR R0, [R0];
	LDR R5, =arr
loop_oct
	CMP R0, #0;
	BEQ toarr_oct;
	AND R1, R0, #2_111;
	PUSH {R1};
	LSR R0, #3;
	ADD R2, #1
	B loop_oct;
toarr_oct
	CMP R2, #0;
	BEQ stop2;
	SUB R2, #1;
	POP {R3};
	STRB R3, [R5], #1;
	B toarr_oct;
stop2
	BX LR
	ENDP
		
		
from_hex_to_dec PROC
	LDR R0, =input;
	LDR R0, [R0];
	LDR R5, =arr
	MOV R4, #0;
	MOV R3, #10;
loop_dec
	CMP R0, #0;
	BEQ toarr_dec;
	LDR R1, =0xCCCCCCCD ;10
	UMULL R2, R1, R0, R1
	MOV R1, R1, LSR #3
	MUL R2, R1, R3;
	SUB R2, R0, R2;
	PUSH {R2}
	MOV R0, R1;
	ADD R4, #1;
	B loop_dec;
toarr_dec
	CMP R4, #0;
	BEQ stop3;
	SUB R4, #1;
	POP {R3};
	STRB R3, [R5], #1;
	B toarr_dec;
stop3
	BX LR
	ENDP

division PROC; takes 2 arguments, dividend and divisor
	LDR R0, =dividend;
	LDR R0, [R0];
	LDR R2, =divisor;
	LDR R2, [R2];
	MOV R1, #0;
loop_division
	CMP R0, R2;
	BLT stop_div;
	SUB R0, R2;
	ADD R1, #1;
	B loop_division;
stop_div
	; WHEN FUNCTION ENDS, R0 BECOMES THE REGISTER THAT CONTAINS THE MODULO
	; R1 BECOMES THE QUOTIENT
	; R2 IS THE DIVISOR
	LDR R3, =modulo
	STR R0, [R3];
	LDR R3, =quotient
	STR R1, [R3];
	BX LR
	ENDP

detect_prime PROC; takes 1 input =input and return TRUE or FALSE in register r0
	LDR R0, =input;
	LDR R0, [R0]; R0 IS THE DIVIDEND
	MOV R4, R0; COPY ORIGINAL VALUE
	CMP R4, #2;
	BEQ prime;
	AND R2, R0, #1;
	CMP R2, #0;
	BEQ non_prime
	MOV R2, #3; R2 IS THE DIVISOR
	MOV R5, R0, LSR #1; R1 CONTAINS 1/2 INPUT.
loop_detect_prime
	CMP R2, R5;
	BGE prime;
	LDR R3, =divisor; R3 IS THE MEMORY PROXY
	STR R2, [R3];
	LDR R3, =dividend;
	STR R4, [R3];
	PUSH {LR};
	BL division;
	POP {LR}
	CMP R0, #0;
	BEQ non_prime;
	ADD R2, #2;
	B loop_detect_prime
prime
	MOV R0, #1;
	B stop_prime;
non_prime
	MOV R0, #0;
	B stop_prime;
stop_prime
	BX LR
	ENDP

count_prime PROC
	LDR R6, =input; R6 IS USED AS POINTER
	LDR R7, [R6]; R7 IS USED TO CONTAIN THE N VALUE;
	AND R8, R7, #1;
	CMP R8, #0;
	SUBEQ R7, #1;
	MOV R8, #0;
loop_count_prime
	CMP R7, #1;
	BLE stop_count_prime
	STR R7, [R6];
	PUSH {LR}
	BL detect_prime
	POP {LR}
	CMP R0, #1;
	ADDEQ R8, #1;
	SUB R7, #1;
	B loop_count_prime
stop_count_prime
	BX LR;
	ENDP

_main
;	LDR R0, =input;
;	MOV R1, #25;
;	STR R1, [R0];
;	BL arr_of_prime;
	;BL division;
;	BL count_prime;
	BL from_hex_to_binary;
stop
	SWI #0x11
	END