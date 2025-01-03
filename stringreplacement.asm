.model small        ; Define memory model
.stack 100h         ; Define stack size

.data
    inputStr db 100 dup('$')     ; Buffer to store the input string
    searchWord db 20 dup('$')    ; Buffer to store the word to search
    replaceWord db 20 dup('$')   ; Buffer to store the replacement word
    outputStr db 100 dup('$')    ; Buffer to store the modified string

    msgInput db "Enter the input string: $"
    msgSearch db 13,10,"Enter the word to search: $"
    msgReplace db 13,10,"Enter the replacement word: $"
    msgOutput db 13,10,"Modified string: $"
    msgNotFound db 13,10,"Word not found!$"
.code
main proc
    mov ax, @data   ; Initialize data segment
    mov ds, ax

    ; Prompt for input string
    lea dx, msgInput
    mov ah, 09h
    int 21h
    lea di, inputStr ; Load address of inputStr into DI
    call ReadString  ; Call subroutine to read the input string

    ; Prompt for word to search
    lea dx, msgSearch
    mov ah, 09h
    int 21h
    lea di, searchWord ; Load address of searchWord into DI
    call ReadString  ; Call subroutine to read the search word

    ; Prompt for replacement word
    lea dx, msgReplace
    mov ah, 09h
    int 21h
    lea di, replaceWord ; Load address of replaceWord into DI
    call ReadString  ; Call subroutine to read the replacement word

    ; Perform word replacement
    call ReplaceWord ; Call subroutine to replace the word

    ; Display the result
    lea dx, msgOutput
    mov ah, 09h
    int 21h
    lea dx, outputStr
    mov ah, 09h
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h
main endp

; Subroutine to read a string
ReadString proc
    mov cx, 0       ; Initialize character counter
ReadLoop:
    mov ah, 01h     ; DOS interrupt to read a character
    int 21h
    cmp al, 13      ; Check if Enter key is pressed
    je ReadDone     ; If yes, exit the loop
    stosb           ; Store the character in [DI] and increment DI
    inc cx          ; Increment character counter
    jmp ReadLoop    ; Repeat the loop
ReadDone:
    mov al, '$'     ; Add string terminator
    stosb
    ret
ReadString endp

; Subroutine to replace a word in the input string
ReplaceWord proc
    lea si, inputStr ; Load address of inputStr into SI
    lea di, outputStr ; Load address of outputStr into DI
    lea bx, searchWord ; Load address of searchWord into BX

ReplaceLoop:
    lodsb           ; Load a character from [SI] into AL and increment SI
    cmp al, '$'     ; Check if end of input string
    je ReplaceDone  ; If yes, exit the loop

    ; Check if the current character matches the first character of the search word
    cmp al, [bx]
    jne CopyChar    ; If not, copy the character to outputStr

    ; Compare the rest of the search word
    push si         ; Save SI
    push bx         ; Save BX
CompareLoop:
    inc bx          ; Move to the next character in searchWord
    lodsb           ; Load the next character from inputStr
    cmp al, [bx]    ; Compare with the next character in searchWord
    jne CompareFail ; If not equal, the word doesn't match
    cmp byte ptr [bx], '$' ; Check if end of searchWord
    jne CompareLoop ; If not, continue comparing

    ; If the word matches, replace it
    pop bx          ; Restore BX
    pop si          ; Restore SI
    lea si, replaceWord ; Load address of replaceWord into SI
CopyReplace:
    lodsb           ; Load a character from replaceWord into AL
    cmp al, '$'     ; Check if end of replaceWord
    je ReplaceLoop  ; If yes, continue searching
    stosb           ; Store the character in outputStr and increment DI
    jmp CopyReplace ; Repeat the loop

CompareFail:
    pop bx          ; Restore BX
    pop si          ; Restore SI
CopyChar:
    stosb           ; Store the character in outputStr and increment DI
    jmp ReplaceLoop ; Repeat the loop

ReplaceDone:
    mov al, '$'     ; Add string terminator
    stosb
    ret
ReplaceWord endp

end main