; Khai bao doan du lieu
	AREA RESET, DATA, READONLY
	DCD 0x20001000 ; stack pointer value when stack is empty
	DCD Reset_Handler ; reset vector

ALIGN
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

	AREA MYCODE, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler

add_diagonal PROC
; add_diagonal: tinh tong cac phan tu cheo
	LDR R0, =nums;
	LDR R4, =Ynums;
	;MOV R3, #0; ;NEU COMMENT CODE CHAY SAI, NEU CO CODE CHAY DUNG
	MOV R1, #44;
loop
	MOV R2, #10;
	LDR R2, [R4], +R1; 
	ADD R3, R2;
	SUB R4, #1;
	CMP R4, #0;
	BEQ stop;
	B loop;
stop
	BX LR
	ENDP
		
Reset_Handler
	BL add_diagonal;
	SWI #0x11;
	END