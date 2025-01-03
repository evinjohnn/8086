.model small        ; Define memory model
.stack 100h         ; Define stack size

.data               ; Data segment
    msg1 db "Enter first number (0-99): $"
    msg2 db 13,10,"Enter second number (0-99): $"
    msgResult db 13,10, "Result of subtraction: $"
    result db '00', '$' ; Buffer to store the result
    result1 db '00','$' ; Buffer to store the result (if needed)

.code               ; Code segment
main proc           ; Start of main procedure
    mov ax, @data   ; Load address of data segment into AX
    mov ds, ax      ; Move AX to DS to set data segment

    ; Get first number
    lea dx, msg1    ; Load address of msg1 into DX
    mov ah, 09h     ; DOS function to display string
    int 21h         ; Call DOS interrupt
    call GetTwoDigitNumber ; Call subroutine to get two-digit number
    mov bl, al      ; Store first number in BL

    ; Get second number
    lea dx, msg2    ; Load address of msg2 into DX
    mov ah, 09h     ; DOS function to display string
    int 21h         ; Call DOS interrupt
    call GetTwoDigitNumber ; Call subroutine to get two-digit number
    mov bh, al      ; Store second number in BH

    ; Subtract the two numbers
    sub bl, bh      ; Subtract the second number from the first
    mov al, bl      ; Move result to AL
    call ConvertToASCII ; Call subroutine to convert result to ASCII

    ; Display the result
    lea dx, msgResult ; Load address of msgResult into DX
    mov ah, 09h     ; DOS function to display string
    int 21h         ; Call DOS interrupt
    lea dx, result  ; Load address of result into DX
    mov ah, 09h     ; DOS function to display string
    int 21h         ; Call DOS interrupt

    ; Exit program
    mov ah, 4Ch     ; DOS function to terminate program
    int 21h         ; Call DOS interrupt
main endp           ; End of main procedure

; Subroutine to get a two-digit number
GetTwoDigitNumber proc
    mov ah, 01h     ; DOS function to read a single character
    int 21h         ; Call DOS interrupt
    sub al, '0'     ; Convert ASCII to numeric
    mov cl, 10      ; Multiply tens place by 10
    mul cl          ; AL = AL * 10
    mov ch, al      ; Store tens place in CH

    mov ah, 01h     ; DOS function to read a single character
    int 21h         ; Call DOS interrupt
    sub al, '0'     ; Convert ASCII to numeric
    add ch, al      ; Add units place to tens place
    mov al, ch      ; Return result in AL
    ret             ; Return from subroutine
GetTwoDigitNumber endp

; Subroutine to convert a number to ASCII
ConvertToASCII proc
    mov ah, 0       ; Clear AH
    mov bl, 10      ; Divide by 10 to get tens place
    div bl          ; AL = AX / 10, AH = remainder
    add al, '0'     ; Convert to ASCII
    mov result[0], al ; Store tens place

    add ah, '0'     ; Convert to ASCII
    mov result[1], ah ; Store units place
    ret             ; Return from subroutine
ConvertToASCII endp

end main            ; End of program