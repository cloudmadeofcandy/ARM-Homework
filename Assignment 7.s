	AREA RESET, DATA, READONLY
	EXPORT __VECTORS
__VECTORS
	DCD 0X20001000
	DCD Reset_Handler
plaintext DCB "LETS KILL A ZEBRA", 0;
caesarkey DCD 3;
substitutionkey DCB "QWERTYUIOPASDFGHJKLZXCVBNM"
	ALIGN
	
	AREA DATASPACE, DATA, READWRITE
ciphertext SPACE 100;
	
		
	AREA MAIN, CODE, READONLY
	ENTRY
	EXPORT Reset_Handler
caesar_cipher PROC
	;for uppercase text only
	LDR R0, =plaintext;
	LDR R1, =ciphertext;
	LDR R3, =caesarkey;
	LDR R3, [R3];
loop
	LDRB R2, [R0], #1;
	CMP R2, #0;
	BEQ stop_caesar;
	CMP R2, #0X20;
	BEQ store;
	ADD R2, R3;
	CMP R2, #0X5A;
	BGT modulate;
	BLE store;
modulate
	SUB R2, #26;
store
	STRB R2, [R1], #1;
	B loop;
stop_caesar
	STRB R2, [R1], #1;
	LDR R0, =ciphertext;
	BX LR;
	ENDP
	
substitution_cipher PROC
	;AGAIN, ONLY WORKS WITH CAPITAL LETTERS
	LDR R0, =plaintext;
	LDR R1, =substitutionkey;
	LDRB R2, [R0], #1;
	SUB R2, #1;
	ENDP


Reset_Handler
	BL caesar_cipher;
stop
	SWI 0X11;
	END