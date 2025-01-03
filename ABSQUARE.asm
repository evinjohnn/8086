.model small        ; Define memory model
.stack 100h         ; Define stack size

.data
    msgA db "Enter value of a (0-99): $"
    msgB db 13,10,"Enter value of b (0-99): $"
    resultMsg db 13,10,"(a + b)^2 = $"
    a db ?          ; Variable to store a (8-bit)
    b db ?          ; Variable to store b (8-bit)
    result dw ?     ; Variable to store the result (16-bit)
.code
main proc
    mov ax, @data   ; Initialize data segment
    mov ds, ax

    ; Prompt for value of a
    lea dx, msgA    ; Load address of msgA into DX
    mov ah, 09h     ; DOS interrupt to display string
    int 21h         ; Display msgA

    ; Read value of a (two-digit number)
    call ReadTwoDigit ; Call subroutine to read a two-digit number
    mov [a], al     ; Store the value in a

    ; Prompt for value of b
    lea dx, msgB    ; Load address of msgB into DX
    mov ah, 09h     ; DOS interrupt to display string
    int 21h         ; Display msgB

    ; Read value of b (two-digit number)
    call ReadTwoDigit ; Call subroutine to read a two-digit number
    mov [b], al     ; Store the value in b

    ; Compute (a + b)^2 = a^2 + 2ab + b^2
    mov al, [a]     ; Load a into AL
    mul al          ; AX = a * a (a^2)
    mov bx, ax      ; Store a^2 in BX

    mov al, [a]     ; Load a into AL
    mov cl, [b]     ; Load b into CL
    mul cl          ; AX = a * b (ab)
    shl ax, 1       ; AX = 2 * ab (2ab)
    add bx, ax      ; BX = a^2 + 2ab

    mov al, [b]     ; Load b into AL
    mul al          ; AX = b * b (b^2)
    add bx, ax      ; BX = a^2 + 2ab + b^2

    mov [result], bx ; Store the result

    ; Display the result
    lea dx, resultMsg ; Load address of resultMsg into DX
    mov ah, 09h     ; DOS interrupt to display string
    int 21h         ; Display resultMsg

    ; Convert result to ASCII and display
    mov ax, [result] ; Load result into AX
    call DisplayNumber ; Call subroutine to display the number

    ; Exit program
    mov ah, 4Ch     ; DOS interrupt to terminate the program
    int 21h
main endp

; Subroutine to read a two-digit number
ReadTwoDigit proc
    mov ah, 01h     ; DOS interrupt to read a character
    int 21h         ; Read the first digit
    sub al, '0'     ; Convert ASCII to numeric
    mov bl, 10      ; Multiply by 10 to get the tens place
    mul bl          ; AL = AL * 10
    mov bh, al      ; Store the result in BH

    mov ah, 01h     ; DOS interrupt to read a character
    int 21h         ; Read the second digit
    sub al, '0'     ; Convert ASCII to numeric
    add bh, al      ; Add the units place to BH
    mov al, bh      ; Move the result to AL
    ret
ReadTwoDigit endp

; Subroutine to display a 16-bit number in AX
DisplayNumber proc
    mov cx, 0       ; Initialize digit counter
    mov bx, 10      ; Base 10 for division

ConvertLoop:
    xor dx, dx      ; Clear DX for division
    div bx          ; Divide AX by 10 (DX:AX / BX)
    push dx         ; Push remainder (digit) onto the stack
    inc cx          ; Increment digit counter
    cmp ax, 0       ; Check if quotient is zero
    jne ConvertLoop ; If not, repeat the loop

DisplayLoop:
    pop dx          ; Pop digit from the stack
    add dl, '0'     ; Convert digit to ASCII
    mov ah, 02h     ; DOS interrupt to display a character
    int 21h         ; Display the digit
    loop DisplayLoop ; Repeat for all digits
    ret
DisplayNumber endp

end main