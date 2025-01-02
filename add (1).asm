data segment
    msg1 db "Enter first number (0-99): $"
    msg2 db 13,10,"Enter second number (0-99): $"
    msgResult db 13,10, "Result of addition: $"
    result db '00', '$'
    result1 db '00','$'
data ends

code segment
assume cs:code, ds:data

start:
    mov ax, data
    mov ds, ax

    lea dx, msg1
    mov ah, 09h
    int 21h
    call GetSingleDigit
    mov bl, cl
    mov bh, ch

    lea dx, msg2 
    mov ah, 09h
    int 21h
    call GetSingleDigit
    mov al, cl
    add al, bl

    mov ah, 0
    aaa
loop2:
    add ch, ah
    add bh, ch
    mov bl, bh
    mov bh, 0
    cmp bl, 9
    jbe StoreResult
    sub bl, 10
    inc bh

StoreResult:
    call ConvertToASCII
    lea dx, msgResult
    mov ah, 09h
    int 21h
    lea dx, result
    mov ah, 09h
    int 21h
    lea dx, result1
    mov ah, 09h
    int 21h

    mov ah, 4Ch
    int 21h

GetSingleDigit:
    mov ah, 01h
    int 21h
    mov ch, al
    mov ah, 01h
    int 21h
    mov cl, al
    sub cl, '0'
    sub ch, '0'
    ret

ConvertToASCII:
    add bl, '0'
    mov result1[0], bl
    add al, '0'
    mov result1[1], al
    mov result1[2], '$'
    add bh, '0'
    mov result[0], 0
    mov result[1], bh
    ret

code ends
end start