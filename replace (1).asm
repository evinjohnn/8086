data segment
    str1 db 20 dup("$")                         
    cr db ?                                    
    rc db ?                                     
   
    mainstr db 13,10,"str 1 : $"                
    replstr db 13,10,"char to replace : $"      
    newstring db 13,10,"replacement char : $"   
    outstring db 13,10,"modified str : $"      
    notstring db 13,10,"no occurrences found $" 
data ends


code segment
    assume cs:code, ds:data

start:
    mov ax, data                 
    mov ds, ax
   
    lea dx, mainstr              
    mov ah, 09h
    int 21h

    lea si, str1                 
    mov cx, 20                   
    call read

    mov [si], '$'       

    lea dx, replstr             
    mov ah, 09h
    int 21h

    mov ah, 01h                  
    int 21h
    mov [cr], al                 

    lea dx, newstring            
    mov ah, 09h
    int 21h

    mov ah, 01h                  
    int 21h
    mov [rc], al                 

    call replace                

    mov ah, 4ch                  
    int 21h

replace:
    lea si, str1                 
    mov al, [cr]                
    mov bl, [rc]                
    xor cx, cx                   

replace_loop:
    cmp [si], '$'       
    je done                      
    cmp  [si], al        
    jne next                     
    mov [si], bl                 
    inc cx                       

next:
    inc si                       
    jmp replace_loop            

done:
    cmp cx, 0                    
    je no_occurrences            

    lea dx, outstring            
    mov ah, 09h
    int 21h
    lea dx, str1                 
    mov ah, 09h
    int 21h
    ret

no_occurrences:
    lea dx, notstring            
    mov ah, 09h
    int 21h
    ret

read:
    mov ah, 01h                 
    int 21h
    cmp al, 13                   
    je return                     
    mov [si], al                 
    inc si                      
    loop read                    

return:
    ret
code ends
end start
