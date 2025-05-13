jmp start      

msg:    db "1-Add",0dh,0ah,"2-Multiply",0dh,0ah,"3-Subtract",0dh,0ah,"4-Divide",0dh,0ah,"5-AND",0dh,0ah,"6-OR",0dh,0ah,"7-XOR",0dh,0ah,"8-To Binary",0dh,0ah,"9-To Hex",0dh,0ah,'$'
msg2:   db 0dh,0ah,"Enter First No: $"
msg3:   db 0dh,0ah,"Enter Second No: $"
msg4:   db 0dh,0ah,"Choice Error $" 
msg5:   db 0dh,0ah,"Result : $" 
msg6:   db 0dh,0ah,'Press space to exit.',0dh,0ah,'$'

start:  
    mov ah,9
    mov dx, offset msg 
    int 21h

    mov ah,0                       
    int 16h  

    cmp al,31h 
    je Addition
    cmp al,32h
    je Multiply
    cmp al,33h
    je Subtract
    cmp al,34h
    je Divide
    cmp al,35h
    je LogicAND
    cmp al,36h
    je LogicOR
    cmp al,37h
    je LogicXOR
    cmp al,38h
    je ToBinary
    cmp al,39h
    je ToHex      

    mov ah,09h
    mov dx, offset msg4
    int 21h
    mov ah,0
    int 16h
    jmp start

Addition:   
    mov ah,9  
    mov dx, offset msg2  
    int 21h
    mov cx,0
    call InputNo  
    push dx
    mov ah,9
    mov dx, offset msg3
    int 21h 
    mov cx,0
    call InputNo
    pop bx
    add dx,bx
    push dx 
    mov ah,9
    mov dx, offset msg5
    int 21h
    mov cx,10000
    pop dx
    call View 
    jmp exit 

Multiply:   
    mov ah,9
    mov dx, offset msg2
    int 21h
    mov cx,0
    call InputNo
    push dx
    mov ah,9
    mov dx, offset msg3
    int 21h 
    mov cx,0
    call InputNo
    pop bx
    mov ax,dx
    mul bx 
    mov dx,ax
    push dx 
    mov ah,9
    mov dx, offset msg5
    int 21h
    mov cx,10000
    pop dx
    call View 
    jmp exit 

Subtract:   
    mov ah,9
    mov dx, offset msg2
    int 21h
    mov cx,0
    call InputNo
    push dx
    mov ah,9
    mov dx, offset msg3
    int 21h 
    mov cx,0
    call InputNo
    pop bx
    sub bx,dx
    mov dx,bx
    push dx 
    mov ah,9
    mov dx, offset msg5
    int 21h
    mov cx,10000
    pop dx
    call View 
    jmp exit 

Divide:     
    mov ah,9
    mov dx, offset msg2
    int 21h
    mov cx,0
    call InputNo
    push dx
    mov ah,9
    mov dx, offset msg3
    int 21h 
    mov cx,0
    call InputNo
    pop bx
    mov ax,bx
    mov cx,dx
    mov dx,0
    div cx
    mov dx,ax
    push dx 
    mov ah,9
    mov dx, offset msg5
    int 21h
    mov cx,10000
    pop dx
    call View
    jmp exit      

LogicAND:   
    mov ah,9
    mov dx, offset msg2
    int 21h
    mov cx,0
    call InputNo
    push dx
    mov ah,9
    mov dx, offset msg3
    int 21h
    mov cx,0
    call InputNo
    pop bx
    and dx,bx
    push dx
    mov ah,9
    mov dx, offset msg5
    int 21h
    mov cx,10000
    pop dx
    call View
    jmp exit

LogicOR:    
    mov ah,9
    mov dx, offset msg2
    int 21h
    mov cx,0
    call InputNo
    push dx
    mov ah,9
    mov dx, offset msg3
    int 21h
    mov cx,0
    call InputNo
    pop bx
    or dx,bx
    push dx
    mov ah,9
    mov dx, offset msg5
    int 21h
    mov cx,10000
    pop dx
    call View
    jmp exit

LogicXOR:   
    mov ah,9
    mov dx, offset msg2
    int 21h
    mov cx,0
    call InputNo
    push dx
    mov ah,9
    mov dx, offset msg3
    int 21h
    mov cx,0
    call InputNo
    pop bx
    xor dx,bx
    push dx
    mov ah,9
    mov dx, offset msg5
    int 21h
    mov cx,10000
    pop dx
    call View
    jmp exit

ToBinary:
    mov ah, 9
    mov dx, offset msg2
    int 21h

    mov cx, 0
    call InputNo      ; result stored in DX
    mov al, dl        ; get lower 8 bits into AL

    mov ah, 9
    mov dx, offset msg5
    int 21h

    mov cx, 8         ; 8 bits to print
print_binary:
    rol al, 1         ; rotate left; MSB to CF
    jc print_1
    mov dl, '0'
    jmp print_bit
print_1:
    mov dl, '1'
print_bit:
    mov ah, 2
    int 21h
    loop print_binary
    jmp exit



ToHex:
    mov ah, 9
    mov dx, offset msg2
    int 21h

    mov cx, 0
    call InputNo     ; result in DX
    mov al, dl       ; move 8-bit value into AL

    mov ah, 9
    mov dx, offset msg5
    int 21h

    ; High nibble
    mov ah, al
    and ah, 0F0h
    shr ah, 4
    call PrintHexDigit

    ; Low nibble
    mov ah, al
    and ah, 0Fh
    call PrintHexDigit

    jmp exit  
    
PrintHexDigit:
    mov dl, ah
    cmp dl, 9
    jbe print_digit
    add dl, 7
print_digit:
    add dl, 30h
    mov ah, 2
    int 21h
    ret


InputNo:    
    mov ah,0
    int 16h  
    mov dx,0  
    mov bx,1 
    cmp al,0dh 
    je FormNo 
    sub ax,30h 
    call ViewNo 
    mov ah,0 
    push ax  
    inc cx   
    jmp InputNo 

FormNo:     
    pop ax 
    push dx      
    mul bx
    pop dx
    add dx,ax
    mov ax,bx    
    mov bx,10
    push dx
    mul bx
    pop dx
    mov bx,ax
    dec cx
    cmp cx,0
    jne FormNo
    ret

View:       
    mov ax,dx
    mov dx,0
    div cx 
    call ViewNo
    mov bx,dx 
    mov dx,0
    mov ax,cx 
    mov cx,10
    div cx
    mov dx,bx 
    mov cx,ax
    cmp ax,0
    jne View
    ret

ViewNo:     
    push ax 
    push dx 
    mov dx,ax 
    add dl,30h 
    mov ah,2
    int 21h
    pop dx  
    pop ax
    ret

exit:       
    mov dx,offset msg6
    mov ah, 9
    int 21h  
    mov ah,0
    int 16h
    mov ah,4Ch
    int 21h
