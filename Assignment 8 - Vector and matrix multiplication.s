	AREA RESET, DATA, READONLY
	DCD 0X20001000
	DCD Reset_Handler
;arr1 DCD 1,2,3,4,5
;arr2 DCD 6,7,8,9,0
mat1 DCD 1,2,3
	 DCD 4,5,6
	 DCD 7,8,9
mat2 DCD 1,2,3
	 DCD 4,5,6
	 DCD 7,8,9
meta_a DCD 5
meta_mat1 DCD 3, 3
meta_mat2 DCD 3, 3
	
	AREA MEMORY, DATA, READWRITE
arr1 SPACE 4*100
arr2 SPACE 4*100
answer DCD 0
product SPACE 4*100

	ALIGN
	
	AREA MYCODE, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler

vector_multiplication PROC; TAKES 3 ARGUMENTS: THE ADDRESSES OF THE FIRST AND SECOND ARRAY AND THEIR SIZE
	;RETURNS THE RESULT IN AN ARRAY CALLED ANSWER
	
	
;	INITIALIZATION OF FUNCTION
	LDR R0, =arr1;
	LDR R1, =arr2;
	LDR R2, =meta_a;
	LDR R2, [R2];
	LDR R3, =answer;


loop_vector_mul
	CMP R2, #0;
	BEQ stop_vector_mul;
	LDR R4, [R0], #4;
	LDR R5, [R1], #4;
	MUL R4, R5;
	ADD R6, R4;
	SUB R2, #1;
	B loop_vector_mul;
stop_vector_mul
	STR R6, [R3];
	LDR R0, =answer;
	BX LR
	ENDP


matrix_multiplication PROC; TAKES 3 ARGUMENTS: THE ADDRESSES OF THE FIRST AND SECOND ARRAY AND THEIR SIZE
	;RETURNS THE RESULT IN AN ARRAY CALLED PRODUCT
	LDR R0, =meta_mat1;
	LDR R1, =meta_mat2;
	LDR R10, =product; WHERE THE RESULT WILL BE SAVED
	LDR R0, [R0, #4]; RETRIEVE THE # OF COLS IN mat_1; AND ROWS IN mat_2
	LDR R2, [R1, #4]; RETRIEVE THE # OF COLS IN mat_2
	LDR R1, [R1];	  RETRIEVE THE # OF ROWS IN mat_2
	MOV R11, #1;
	CMP R0, R1; IF # COLS mat_1 != # ROWS mat_2, STOP THE PROC IMMEDIATELY
	BNE stop_mat_mul;
	
			  ; R0 CONTAINS # of COLS IN mat_1; ROW IN mat_2
	MOV R1, R2; R1 CONTAINS # of COLS IN mat_2; ROW IN mat_1
	PUSH {R1};
	
	LDR R2, =mat1; POINTS TO THE FIRST ELEMENT
	LDR R3, =mat2;

loop_point
	LDR R4, =arr1;
	LDR R5, =arr2;
	MOV R6, #0;
	MOV R7, #0;
	MOV R8, #0;
	
copy_arr_1
	CMP R6, R0;
	BEQ stop_copy_1;
	LDR R7, [R2, R8];
	ADD R8, #4;
	STR R7, [R4], #4;
	ADD R6, #1;
	B copy_arr_1;
stop_copy_1
	MOV R6, #0;
	MOV R7, R1;
	MOV R8, #4;
	MUL R7, R7, R8;
	MOV R9, #0;
	B copy_arr_2

copy_arr_2
	CMP R6, R0;
	BEQ stop_copy_2;
	LDR R8, [R3, R9];
	ADD R9, R7;
	STR R8, [R5], #4;
	ADD R6, #1;
	B copy_arr_2
stop_copy_2
	MOV R6, #0;
	B calculate;

calculate
	PUSH {R0-R3}
	PUSH {LR}
	BL vector_multiplication;
	POP {LR};
	STR R6, [R10], #4;
	POP {R0-R3}
	CMP R11, R1;
	BLT continue_loop_mat_2
	BEQ continue_loop_mat_1
continue_loop_mat_2
	ADD R11, #1;
	ADD R3, #4;
	B loop_point;
continue_loop_mat_1
	MOV R11, #1;
	POP {R6};
	CMP R6, #1;
	BEQ stop_mat_mul;
	LSL R7, R0, #2;
	ADD R2, R7;
	SUB R6, #1;
	PUSH {R6};
	LDR R3, =mat2;
	B loop_point;
	
stop_mat_mul
	BX LR;
	ENDP


Reset_Handler
	BL matrix_multiplication;
	SWI 0X11;
	END