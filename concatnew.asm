
ASSUME CS:CODE,DS:DATA
DATA SEGMENT
	STR1 DB 30 DUP("$")
	STR2 DB 30 DUP("$")
	MSG1 DB 13,10,"STR 1:$"
	MSG2 DB 13,10,"STR 2:$"
	RES DB 13,10,"CONCATENATED STRING: $"
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA         ; Initialize data segment
	MOV DS,AX           ; Point DS to the data segment

	LEA DX,MSG1         ; Load address of MSG1 into DX
	MOV AH,09H          ; DOS interrupt to display string
	INT 21H             ; Display MSG1
	LEA SI,STR1         ; Load address of STR1 into SI
	LOOP0: MOV AH,01H   ; DOS interrupt to read a character
		INT 21H
		CMP AL,13         ; Check if Enter key (carriage return) is pressed
		JE SKIP0          ; If yes, exit the loop
		MOV [SI],AL       ; Store the character in STR1
		INC SI            ; Increment SI to point to the next location
		JMP LOOP0         ; Repeat the loop
	SKIP0: MOV AH,09H   ; DOS interrupt to display string
		LEA DX,MSG2      ; Load address of MSG2 into DX
		INT 21H          ; Display MSG2
	LEA SI,STR2         ; Load address of STR2 into SI
	LOOP1: MOV AH,01H   ; DOS interrupt to read a character
		INT 21H
		CMP AL,13         ; Check if Enter key is pressed
		JE SKIP1          ; If yes, exit the loop
		MOV [SI],AL       ; Store the character in STR2
		INC SI            ; Increment SI to point to the next location
		JMP LOOP1         ; Repeat the loop
	SKIP1: CALL CONCAT   ; Call the CONCAT subroutine
	MOV AH,4CH          ; DOS interrupt to terminate the program
	INT 21H
CONCAT PROC
	LEA SI,STR1         ; Load address of STR1 into SI
	LEA DI,STR2         ; Load address of STR2 into DI
	MOV AL,"$"          ; Initialize AL with the string terminator
	LOOP2: CMP AL,[SI]  ; Check for the end of STR1
		JZ ADD_SPACE    ; If terminator is found, go to add space
		INC SI          ; Otherwise, move to the next character in STR1
		JMP LOOP2       ; Repeat the loop
	ADD_SPACE: MOV [SI]," " ; Add a space character at the end of STR1
		INC SI  
		JMP LOOP3        ; Move to the next position
	LOOP3: CMP AL,[DI]  ; Check for the end of STR2
		JZ EXIT         ; If terminator is found, exit the loop
		MOV BL,[DI]     ; Copy character from STR2
		MOV [SI],BL     ; Append the character to STR1
		INC SI          ; Increment SI to the next position
		INC DI          ; Increment DI to the next position
		JMP LOOP3       ; Repeat the loop
	EXIT: MOV [SI],AL   ; Add the string terminator at the end of STR1
		LEA DX,RES      ; Load address of RES into DX
		MOV AH,09H      ; DOS interrupt to display string
		INT 21H         ; Display RES
		LEA DX,STR1     ; Load address of STR1 into DX
		MOV AH,09H      ; DOS interrupt to display concatenated string
		INT 21H         ; Display the concatenated string
		RET             ; Return to the calling function
CONCAT ENDP
CODE ENDS
END START