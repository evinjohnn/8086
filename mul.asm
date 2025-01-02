data segment
    msg1 db "Enter first number (0-99): $"
    msg2 db 13,10,"Enter second number (0-99): $"
    msgResult db 13,10, "Result of multiplication: $"
    result db '00', '$'
    result1 db '00', '$'
data ends



code segment
assume cs:code, ds:data

start:
    ; Set up data segment
    mov ax, data
    mov ds, ax

    ; Input first number
    lea dx, msg1
    mov ah, 09h
    int 21h
    call GetTwoDigit
    mov bl, cl 
    mov bh, ch 

    ; Input second number
    lea dx, msg2
    mov ah, 09h
    int 21h
    call GetTwoDigit

    
    mov al, cl 
    mul bl 
    mov ah, 0
    call AdjustResult
    add al, '0'
    mov result1[1], al
    mov dh, ah 

    mov al, cl
    mul bh 
    add al, dh 
    mov ah, 0
    call AdjustResult
    mov dl, al
    mov dh, ah 

    mov al, ch 
    mul bl 
    add al, dl 
    mov ah, 0
    call AdjustResult
    add al, '0'
    mov result1[0], al
    mov dl, ah 

    mov al, ch
    mul bh 
    add al, dl 
    add al, dh 
    mov ah, 0
    call AdjustResult
    add al, '0'
    mov result[1], al
    add ah, '0'
    mov result[0], ah

    ; Display the result
    call DisplayResult

    ; Exit program
    mov ah, 4Ch
    int 21h


GetTwoDigit:
    mov ah, 01h
    int 21h
    mov ch, al
    mov ah, 01h
    int 21h
    mov cl, al
    sub cl, '0' 
    sub ch, '0' 
    ret


AdjustResult:
    cmp al, 9
    jbe AdjReturn
    sub al, 10
    inc ah
    ja AdjustResult
AdjReturn:
    ret


DisplayResult:
    lea dx, msgResult
    mov ah, 09h
    int 21h
    lea dx, result
    mov ah, 09h
    int 21h
    lea dx, result1
    mov ah, 09h
    int 21h
    ret

code ends
end start