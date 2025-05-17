jmp start      

msg:    db 0dh,0ah,0dh,0ah,"8-bit Simple Calculator",0dh,0ah,0dh,0ah,"1-Add",0dh,0ah,"2-Multiply",0dh,0ah,"3-Subtract",0dh,0ah,"4-Divide",0dh,0ah,"5-AND",0dh,0ah,"6-OR",0dh,0ah,"7-XOR",0dh,0ah,"8-To Binary",0dh,0ah,"9-To Hex",0dh,0ah,"0-Exit",0dh,0ah,0dh,0ah,"Enter your choice :  ", '$'
msg2:   db 0dh,0ah,0dh,0ah,"Enter First No: $"
msg3:   db 0dh,0ah,"Enter Second No: $"
msg4:   db 0dh,0ah,"Choice Error $" 
msg5:   db 0dh,0ah,"Result : $"
msg6:   db 0dh,0ah,"Exited Successfully. $"

start:  
    mov ah,9
    mov dx, offset msg 
    int 21h

    mov ah,0           
    int 16h            

    mov dl, al          
    mov ah, 2           
    int 21h             

    cmp al, '0'
    je exit

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
    jmp start 

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
    jmp start 

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
    jmp start 

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
    jmp start      

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
    jmp start

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
    jmp start

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
    jmp start

ToBinary:   
    mov ah,9
    mov dx, offset msg2
    int 21h
    mov cx,0
    call InputNo          
    push dx               
    mov ah,9
    mov dx, offset msg5
    int 21h
    pop ax                
    mov cx,16             
    mov bx,ax             
    
PrintBinaryLoop:
    rol bx,1              
    jc PrintOne
    mov dl,'0'
    jmp PrintDigit
PrintOne:
    mov dl,'1'
PrintDigit:
    mov ah,2
    int 21h
    loop PrintBinaryLoop
    jmp start

ToHex:      
    mov ah,9
    mov dx, offset msg2
    int 21h
    mov cx,0
    call InputNo        
    push dx            
    mov ah,9
    mov dx, offset msg5
    int 21h
    pop ax             
    
    mov cl,4
    rol ax,cl          
    call HexDigit
    rol ax,cl        
    call HexDigit
    
   
    rol ax,cl          
    call HexDigit
    rol ax,cl         
    call HexDigit
    
    jmp start

HexDigit:   
    push ax
    and al,0Fh        
    cmp al,9
    jbe HexPrint
    add al,7           
HexPrint:   
    add al,30h
    mov dl,al
    mov ah,2
    int 21h
    pop ax
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
    mov dx, offset msg6
    mov ah, 9
    int 21h  
    mov ah, 4Ch
    int 21h