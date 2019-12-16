.MODEL SMALL
.386
.STACK 100
.DATA
	
	MSG1 DB "TYPES OF PORK$"
	ASTERISK DB "*************$"
	MSG2 DB "Enter a number (1 to 6): $"
	ERRORM DB "Invalid! Please enter again: $"
	MSG3 DB "Enter the weight (1kg,3kg or 5kg): $"
	MSG4 DB "Enter the quantity: $"
	MSG5 DB "The total weight of $"
	MSG6 DB "units of pork loin is $"
	NL DB 0AH,0DH,"$"

	BELLY DB "1. PORK BELLY$"
	LOIN DB "2. PORK LOIN$"
	RIB DB "3. PORK RIB$"
	SHOULDER DB "4. PORK SHOULDER$"
	HAM DB "5. HAM$"
	QUIT DB "6. QUIT$"
	
	;QUANTITY DB 100 DUP("$")
	WEIGHT DB ?
	CHOICE DB ?


.CODE
MAIN PROC

	MOV AX,@DATA
	MOV DS,AX
	MOV SI,OFFSET QUANTITY

	;-----DISPLAY THE MENU
	MOV AH,09H
	LEA DX,MSG1
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H
	LEA DX,ASTERISK
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H
	
	MOV AH,09H
	LEA DX,BELLY
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H
	LEA DX,LOIN
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H
	LEA DX,RIB
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H
	LEA DX,SHOULDER
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H
	LEA DX,HAM
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H

	MOV AH,09H
	LEA DX,QUIT
	INT 21H

	MOV AH,09H
	LEA DX,NL
	INT 21H

	;-----DISPLAY THE INPUT MESSAGE
	MOV AH,09H	
	LEA DX,MSG2
	INT 21H
		
	;-----ALLOW USER TO SELECT THE TYPE OF MEAT
	SELECTION:
		MOV AH,01H
		INT 21H
		MOV CHOICE,AL
		
		MOV AH,09H
		LEA DX,NL
		INT 21H		
		
		CMP AL,"1"
		JNGE ERROR

		CMP AL,"6"
		JNLE ERROR

		JMP VALID

		ERROR:
			MOV AH,09H
			LEA DX,ERRORM
			INT 21H

	JMP SELECTION

	;-----ALLOW USER TO ENTER THE WEIGHT OF MEAT
	VALID:
		MOV AH,09H
		LEA DX,NL
		INT 21H
		
		MOV AH,09H
		LEA DX,MSG3		;ENTER THE WEIGHT (1,3,5KG) :
		INT 21H

		MOV AH,01H
		INT 21H
		SUB AL,30H
		MOV WEIGHT,AL

		MOV AH,09H
		LEA DX,NL
		INT 21H

		CMP AL,1		;COMPARE THE INPUT WITH NUMBER 1
		JE CORRECT
		
		CMP AL,3		;COMPARE THE INPUT WITH NUMBER 3
		JE CORRECT

		CMP AL,5		;COMPARE THE INPUT WITH NUMBER 5
		JE CORRECT

		MOV AH,09H
		LEA DX,ERRORM
		INT 21H

	JMP VALID

	CORRECT:
		MOV AH,09H
		LEA DX,MSG4
		INT 21H	

		MOV CX,0
		CALL QUANTITY
		PUSH DX

		POP BX
		MOV AX,DX
		MUL WEIGHT
		MOV DX,AX
		PUSH DX
		MOV AH,09H

		MOV CX,10000
		POP DX 
		CALL VIEW
		
		JMP EXIT
	QUANTITY:
		MOV AH,0H
		INT 16H
		MOV DX,0
		MOV BX,1
		CMP AL,0DH
		JE FORMNO
		SUB AX,30H
		CALL VIEWNO
		MOV AH,0H
		PUSH AX
		INC CX
		JMP QUANTITY
		
	FORMNO:
		POP AX
		PUSH DX
		MUL BX
		POP DX
		ADD DX,AX
		MOV AX,BX
		MOV BX,10
		PUSH DX
		MUL BX
		POP DX
		MOV BX,AX
		DEC CX
		CMP CX,0
		JNE FORMNO
		RET
	
	VIEW:
		MOV AX,DX
		MOV DX,0
		DIV CX
		CALL VIEWNO
		MOV BX,DX
		MOV DX,0
		MOV AX,CX
		MOV CX,10
		DIV CX
		MOV DX,BX
		MOV CX,AX
		CMP AX,0
		JNE VIEW
		RET       

	VIEWNO:
		PUSH AX
		PUSH DX
		
		MOV AH,02H
		
		MOV DX,AX
		ADD DL,30H
		INT 21H
		
		POP DX
		POP AX
		RET

	EXIT:
		MOV AX,4C00H
		INT 21H

MAIN ENDP
END MAIN