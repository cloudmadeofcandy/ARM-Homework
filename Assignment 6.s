	AREA RESET, DATA, READONLY
	DCD 0X20001000
	DCD Reset_Handler
string1 DCB "Hello, World" ,0
string2 DCB "Goodbye, World" ,0
string3 DCB "Hello, Goodbye" ,0
string4 DCB "Hello" ,0

	AREA MEMORY, DATA, READWRITE
arr SPACE 100;
	
		
	AREA MYCODE, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler
		
		
string_comparison PROC
loop_comparison
	LDRB R2, [R0], #1;
	LDRB R3, [R1], #1;
	CMP R2, R3;
	ADD R5, #1
	BNE unequal;
	CMP R2, #0;
	BEQ equal;
	B loop_comparison;
unequal
	MOV R4, #0;
	BX LR;
equal
	MOV R4, #1;
	BX LR;
	ENDP
		
string_reverse PROC
	LDR R1, =arr;
	LDRB R2, [R0], #1;
loop_reverse
	CMP R2, #0;
	BEQ toarr
	PUSH {R2}
	LDRB R2, [R0], #1;
	ADD R3, #1;
	B loop_reverse
toarr
	CMP R3, #0;
	BEQ stop_reverse;
	POP {R2};
	STRB R2, [R1], #1;
	SUB R3, #1;
	B toarr
stop_reverse
	MOV R2, #0;
	STRB R2, [R1], #1
	BX LR
	ENDP
		
string_concat PROC
	LDR R0, [R0];
	LDR R1, [R1];
detect_0
	LDRB R2, [R0], #1;
	CMP R2, #0;
	BEQ concat;
	B detect_0;
concat
	LDRB R2, [R1], #1;
	CMP R2, #0;
	BEQ stop_concat;
	STRB R2, [R0], #1;
	B concat
stop_concat
	STRB R2, [R0];
	BX LR;
	ENDP

Reset_Handler
	LDR R0, =string1;
	LDR R1, =string4;
	BL string_concat;
	SWI #0X11
	END