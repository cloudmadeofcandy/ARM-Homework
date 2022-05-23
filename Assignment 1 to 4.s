; Khai bao doan du lieu
	AREA RESET, DATA, READONLY
	DCD 0x20001000 ; stack pointer value when stack is empty
	DCD Reset_Handler ; reset vector

ALIGN
number_array DCD 4,6,2,3,5,7
input_string DCB "HA NOI",0
number_n DCD 10
factor DCD 5
base DCD 3
exp DCD 5
NUM DCD 3
nums
	DCD 1,1,1,1,1,1,1,1,1,10
	DCD 1,2,1,1,1,1,1,1,10,1
	DCD 1,1,3,1,1,1,1,10,1,1
	DCD 1,1,1,4,1,1,10,1,1,1
	DCD 1,1,1,1,5,10,1,1,1,1
	DCD 1,1,1,1,10,6,1,1,1,1
	DCD 1,1,1,10,1,1,7,1,1,1
	DCD 1,1,10,1,1,1,1,8,1,1
	DCD 1,10,1,1,1,1,1,1,9,1
	DCD 10,1,1,1,1,1,1,1,1,10
Xnums DCD 10;
Ynums DCD 10;
pn_nums DCD -1, 5, -2, -3, 5, 8, 9, 7;
X	DCD 10
Y	DCD 25
FUNC_RESULT	DCD 0x0
	
	
	AREA MYCODE, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler	


UCLN PROC
	LDR R0,=X
	LDR R0,[R0]
	LDR R1,=Y
	LDR R1,[R1]
UCLN_LOOP
	CMP R0,R1
	BLO UCLN_LO
	BHI UCLN_HI
	LDR R0,=FUNC_RESULT
	STR R1,[R0]
	BX LR
UCLN_LO
	SUB R1,R0
	B UCLN_LOOP
UCLN_HI
	SUB R0,R1
	B UCLN_LOOP
	
BCLN PROC
	LDR R0,=X
	MOV R1,#6
	STR R1,[R0]
	LDR R0,=Y
	MOV R1,#9
	STR R1,[R0]
	BL UCLN
	LDR R0,=FUNC_RESULT
	LDR R1,[R0]
	LDR R2,=X
	LDR R2,[R2]
	LDR R3,=Y
	LDR R3,[R3]
	MUL R2,R3
	MOV R3,#0 ;KET QUA
BCNN_LOOP
	CMP R2,#0
	BEQ STOP
	SUB R2,R1
	ADD R3,#1
	B BCNN_LOOP
		

sum_of_odd_and_even PROC
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
	ENDP
		
;----------------------------------------------;

divisible5 PROC
	LDR R0, =factor;
	LDR R0, [R0];
loop_div
	CMP R0, #5;
	BEQ divisible
	BLT stop
	SUB R0, #5;
	B loop_div;
divisible
	MOV R1, #1
	B stop
	endp
		
;----------------------------------------------;

factorial PROC
	LDR R0, =factor;
	LDR R0, [R0];
	MOV R1, R0;
	CMP R1, #0;
	BEQ special_case;
	CMP R1, #1;
	BEQ special_case;
loop_factorial;
	CMP R1, #1;
	BEQ return;
	SUB R1, #1;
	MUL R0, R1;
	B loop_factorial;
return
	MOV R5, R0;
	B stop
special_case;
	MOV R5, #1;
	B stop;
	ENDP

;----------------------------------------------;

add_diagonal PROC
; add_diagonal: tinh tong cac phan tu cheo
	LDR R0, =nums;
	LDR R4, =Ynums;
	LDR R4, [R4];
	;MOV R3, #0; ;NEU COMMENT CODE CHAY SAI, NEU CO CODE CHAY DUNG
loop_diagonal
	LDR R2, [R0], #44; 
	ADD R3, R2;
	SUB R4, #1;
	CMP R4, #0;
	BEQ stop;
	B loop_diagonal;
	ENDP

;----------------------------------------------;

x_to_the_nth PROC
;	LDR R0, =base;
;	LDR R0, [R0];
;	LDR R1, =exp;
;	LDR R1, [R1];
	MOV R2, #1;
loop_x
	CMP R1, #0;
	BEQ stop;
	MUL R2, R0;
	SUB R1, #1;
	B loop_x;
	ENDP
		
;----------------------------------------------;
	
add_x_to_the_nth PROC
	PUSH {LR};
	MOV R3, #5; DUNG DEN SO 2
	MOV R4, #1;
	LDR R0, =base;
	LDR R0, [R0];
loop
	CMP R3, #1;
	BEQ end_add;
	MOV R1, R3;
	BL x_to_the_nth;
	ADD R4, R2;
	SUB R3, #1;
	B loop;
end_add
	POP {LR};
	B stop;
	ENDP
	
		
		
Reset_Handler
	BL add_x_to_the_nth;
	SWI #0x11;
stop BX LR;
	END
		
		
		