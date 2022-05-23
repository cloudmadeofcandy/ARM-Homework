	AREA RESET, DATA, READONLY
	EXPORT __vector
__vector
	DCD 0x20001000
	DCD reset_handler
number_array DCD 4,6,2,3,5,7
input_string DCB "HA NOI",0
number_n DCD 10

	AREA	MYCODE, CODE, READONLY
	EXPORT reset_handler
reset_handler
	LDR R0, =sum
	;LDR R0, =detect_A
	BLX R0
	ALIGN
		

	AREA	SUM_OF_EVEN_AND_ODD, CODE, READONLY
	ENTRY
	EXPORT sum
sum
	MOV R0, #0; gia tri tong chan
	MOV R1, #0; gia tri tong le
	LDR R2, =number_array; r2 chua dia chi phan tu dau tien cua mang
	MOV R3, #6; r3 chua kich thuoc mang
	MOV R4, #0; r4 la i
_loop
	CMP R4, R3; so sanh r4 & r3
	BEQ stop; neu bang thi ket thuc
	LSL R5, R4, #2; 
	ADD R5, R2; chuyen den dia chi phan tu thu i
	LDR R5, [R5]; lay gia tri cua phan tu thu i
	MOV R6, #1;
	AND R6, R6, R5;
	CMP R6, #1;
	BEQ sum_odd;
	BNE sum_even;
_add
	ADD R4, #1;
	B	_loop;
sum_odd
	ADD R1, R5;
	B _add;
sum_even
	ADD R0, R5;
	B _add;
	
	
stop B stop;
	END
		
			
	AREA	DETECT_A, CODE, READONLY
	ENTRY
	EXPORT detect_A
detect_A
	MOV R0, #0;
	LDR R1, =input_string;
loop
	LDRB R2, [R1], #1;
	CMP R2, #0x00;
	BEQ stop;
	CMP R2, #0x41;
	BEQ ret;
	ADD R0, #1;
	B loop
ret
	MOV R3, R0;
	B stop;
stop B stop;
	END
		