;Vi?t chuong tr�nh t�nh t?ng c�c s? <= N. SU DUNG NGAN XEP
	AREA RESET, DATA, READONLY
		DCD 0X20001000
		DCD MAIN
N DCD 5
	AREA MYCODE, CODE, READONLY
	ENTRY
MAIN
	MOV R1, #1;
	MOV R2, #2;
	MOV R3, #3;
	;PUSH {R2, R1, R3};
	PUSH {R1};
	PUSH {R2};
	PUSH {R3};
	POP {R5, R6, R4}
STOP 
	b STOP
	END
	