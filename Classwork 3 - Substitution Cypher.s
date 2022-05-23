	AREA RESET, DATA, READONLY
	EXPORT __VECTORS
__VECTORS
	DCD 0X20001000;
	DCD Reset_Handler;
GCD1 DCD 30;
GCD2 DCD 35;
GCDC DCD 5, 10, 15, 20;
meta DCD 4;
PLAINTEXT DCB "ABCDEF ATTACK AT DAWN", 0;	
K DCB "POIUYTREWQASDFGHJKLMNBVCXZ", 0;
	
	AREA DATUM, DATA, READWRITE
RETURN SPACE 100;


	AREA MYCODE, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler
division PROC
	POP {R0}; DIVIDEND
	POP {R1}; DIVISOR
	MOV R2,#0;
loop_division
	CMP R0, R1;
	BEQ divisible;
	BLT indivisible;
	SUB R0, R1;
	ADD R2, #1;
	B loop_division;
indivisible
	MOV R3, R0;
	B end_func
divisible
	ADD R2, #1;
	MOV R3, #0;
	B end_func
end_func
	BX LR;
	ENDP;
		
detect_prime PROC
	
	BX LR;
	ENDP
;	LDR R0, =GCD1;
;	LDR R0, [R0];
;	LDR R1, =GCD2;
;	LDR R1, [R1];


gcd PROC
	POP {R0};
	POP {R1};
compare_gcd
	CMP R0, R1;
	BLT swap;
	B gcd1;
swap
	MOV R2, R0; C = A
	MOV R0, R1; A = B
	MOV R1, R2; B = C
gcd1
	CMP R0, R1
	BLT repeat_gcd
	BEQ end_gcd
	SUB R0, R1
	B gcd1;
repeat_gcd
	B compare_gcd
end_gcd
	MOV R0, R1;
	BX LR
	ENDP
		
GCDchain PROC
	LDR R3, =GCDC;
	PUSH {LR};
initialize
	LDR R1, [R3], #4;
	LDR R4, =meta;
	LDR R4, [R4];
	SUB R4, #2;
	PUSH {R1};
	LDR R1, [R3], #4;
	PUSH {R1};
	BL gcd;
loop_chain
	CMP R4, #0;
	BEQ stop;
	PUSH {R0};
	LDR R1, [R3], #4;
	PUSH {R1};
	SUB R4, #1;
	BL gcd;
	B loop_chain
stop
	POP {LR};
	BX LR;
	ENDP
	
	

substitution_cipher PROC
	LDR R0, =PLAINTEXT;
	LDR R1, =RETURN;
	LDR R2, =K;
loop_cipher
	LDRB R3, [R0], #1;
	CMP R3, #0;
	BEQ end_sub_ci;
	CMP R3, #0X41
	BLT copy;
	CMP R3, #0X5A
	BGT copy;
	SUB R3, #0X41;
copy
	LDRB R4, [R2, R3];
	STRB R4, [R1], #1;
	B loop_cipher;
end_sub_ci
	LDR R1, =RETURN;
	BX LR;
	ENDP;




Reset_Handler
;	MOV R0, #7; DIVISOR
;	PUSH {R0};
;	MOV R0, #37; DIVIDEND
;	PUSH {R0};
;	BL division;
	BL GCDchain;
	SWI #0X11;
	END