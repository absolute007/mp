; Hex to BCD 8 bit

.model small
.stack 
.data
    msg1 db 10,13, "Hex to BCD (8-bit): $"
    num db 0FFh          

.code
disp macro xx
    mov ah, 09h          
    lea dx, xx
    int 21h
endm

.startup
    disp msg1            

    mov cl, 0            
    mov al, num          
    mov ah, 0            
    mov bl, 10           

back:
    mov ah, 0            
    div bl               
    push ax              
    inc cl               
    cmp al, 0            
    jnz back          

back1:
    pop ax               
    mov dl, ah           
    add dl, 30h          
    mov ah, 02h          
    int 21h
    dec cl
    jnz back1   

.exit
end

; Hex to BCD 16 bits

.model small
.stack
.data
    msg1 db 10,13, "HEX to BCD: $"
    num dw 0ffh

.code
    disp macro xx
    mov ah, 09
    lea dx, xx
    int 21h
endm

.startup
    disp msg1
    mov dx, 0
    mov cl, 0
    mov bx, 0ah
    mov ax, num
    
back:
    mov dx, 0
    div bx
    push dx
    
    inc cl
    cmp ax, 0
    jnz back
    
back1:
    pop dx
    add dl, 30h
    mov ax, 02
    int 21h
    dec cl
    jnz back
    
.exit
end

; ASCII to BCD 8 bits

.model small
.stack 100h
.data
    msg1 db "Enter 8bit ASCII digit (0-9): $"
    msg2 db 10,13, "BCD value: $"
    
.code
disp macro xx
    mov ah, 09h
    lea dx, xx
    int 21h
endm

.startup
    disp msg1 
    
    mov ah, 01h
    int 21h
    
    sub al, 30h
    
    disp msg2
    mov dl, al
    add dl, 30h
    
    mov ah, 02h
    int 21h
    

.exit
end

; ASCII to BCD 16 bits

.model small
.stack 100h
.data
    msg db "Enter 2 ASCII digits (0?9): $"
    msg2 db 10,13, "BCD value (decimal): $"
.code

disp macro text
    mov ah, 09h
    lea dx, text
    int 21h
endm

.startup
    disp msg

    mov ah, 01h      ; read first ASCII digit
    int 21h
    sub al, 30h      ; convert ASCII ? number
    mov bl, al       ; save first digit

    mov ah, 01h      ; read second ASCII digit
    int 21h
    sub al, 30h      ; convert ASCII ? number

    mov bh, 10
    mov al, bl
    mul bh           ; AL = first_digit * 10
    add al, ah       ; add second digit
    mov ah, 0

    disp msg2

    ; display result
    mov bl, 10
print_loop:
    mov ah, 0
    div bl
    push ax
    cmp al, 0
    jnz print_loop

print_rev:
    pop ax
    add ah, 30h
    mov dl, ah
    mov ah, 02h
    int 21h
    cmp sp, 0        ; stop when stack empty
    jne print_rev

.exit
end

; BCD to ASCII 8 bits

.model small
.stack 100h
.data
    num db 09h
    msg db "BCD to ASCII (8-bit): $"
.code

disp macro text
    mov ah, 09h
    lea dx, text
    int 21h
endm

.startup
    disp msg

    mov al, num        ; AL = 09h
    add al, 30h        ; numeric ? ASCII ('0' + 9 = '9')
    mov dl, al
    mov ah, 02h
    int 21h

.exit
end


; BCD to ASCII 16 bits

.model small
.stack 100h
.data
    msg db "BCD to ASCII (16-bit): $"
    num dw 1234
.code

disp macro text
    mov ah, 09h
    lea dx, text
    int 21h
endm

.startup
    disp msg

    mov ax, num
    mov bx, 10
    mov cx, 0

convert:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jnz convert

display:
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    loop display

.exit
end

; string operation

.model small
.stack
.data
m1 db 10,13,"enter 1st string: $"
m2 db 10,13,"length: $"
m3 db 10,13,"the string is: $"
m4 db 10,13,"enter 2nd: $"
m5 db 10,13,"length: $"
m6 db 10,13,"the string is: $"
m7 db 10,13,"comparison: $"
m8 db 10,13,"string equal$"
m9 db 10,13,"string not equal$"
m10 db 10,13,"concat: $"

str1 db 80,?,80 DUP(?)
str2 db 80,?,80 DUP(?)
str3 db 80,?,80 DUP(?)

.code
Disp macro xx
mov ah,09h
lea dx,xx
int 21h

endm

.startup
Disp m1 ;Enter 1st string
mov ah,0Ah ;Read a string from the keyboard into buffer addressed by DX
lea dx,str1
int 21h

Disp m2 ;Length of 1st string
lea si,str1+1
mov dl,[si]
mov cl,dl
add dl,30h
mov ah,02h
int 21h

Disp m3 ;Display 1st string
lea si,str1+2

Back:
mov dl,[si]
mov ah,02h
int 21h

inc si
dec cl
jnz Back

Disp m4 ;Enter 2nd string
mov ah,0Ah
lea dx,str2
int 21h

Disp m5 ;Length of 2nd string
lea si,str2+1
mov dl,[si]
mov cl,dl
add dl,30h
mov ah,02h
int 21h



Disp m6 ;Display 2nd string
lea si,str2+2
Back1:
mov dl,[si]
mov ah,02h
int 21h

inc si
dec cl
jnz Back1

Disp m7 ; Comparison
lea si,str1+1

mov cl,[si]
lea di,str2+1
mov ch,[di]
cmp cl,ch
jnz AA
lea si,str1+2
lea di,str2+2

Back2:
mov dl,[si]
mov dh,[di]
cmp dl,dh
jnz AA
inc si
inc di
dec cl
jnz Back2

Disp m8 ;Strings are Equal
jmp con

AA:
Disp m9 ; Strings are not Equal

con:
Disp m10 ;Concatenated String is

lea si,str1+1
mov cl,[si]
mov bl,cl

lea di,str2+1
mov ch,[di]
mov bh,ch
add bl,bh

lea si,str1+2
lea di,str3+2

Back3:
mov dl,[si]
mov [di],dl
inc si
inc di
dec cl
jnz Back3
lea si,str2+2

Back4:
mov dl,[si]
mov [di],dl
inc si
inc di
dec ch

jnz Back4
lea di,str3+2

Back5:
mov dl,[di]
mov ah,02h
int 21h
inc di
dec bl
jnz Back5

Exit:
.exit
end

; Mouse interfacing

.model small
.stack
.data
msg1 db 10,13,"Mouse driver present:$"
.code
disp macro xx
    mov ah,09h
    lea dx,xx
    int 21h
endm
.startup
; --- check for mouse driver ---
mov ax,0000h
int 33h
cmp ax,0FFFFh
jne last
disp msg1
; --- set mouse limits ---
mov ax,0007h        ; set horizontal range
mov cx,10
mov dx,200
int 33h
mov ax,0008h        ; set vertical range
mov cx,10
mov dx,150
int 33h
pixel:
mov ax,0001h        ; show mouse cursor
int 33h
mov ax,0003h        ; get mouse position + button status
int 33h
cmp bx,1            ; left button pressed?
je left
cmp bx,2            ; right button pressed?
je last
jmp pixel
left:
mov ax,0013h        ; set graphics mode (320x200x256)
int 10h
mov ax,0003h        ; get mouse pos again
int 33h
mov ah,0Ch          ; write pixel
mov al,4            ; color = red
mov cx,cx           ; column (x from CX of int 33h)
mov dx,dx           ; row (y from DX of int 33h)
int 10h
jmp pixel
last:
mov ax,0003h        ; restore text mode
int 10h
.exit
end


; Negative numbers 

.model small
.stack 100h

.data
    arr db 10, -5, 25, -2, 15, -3, 0    ; array of signed numbers
    len db 7                             ; total number of elements
    msg db 10,13, "Negative numbers are: $"

.code

disp macro text
    mov ah, 09h
    lea dx, text
    int 21h
endm

.startup
    disp msg                ; print message
    
    mov cl, len             ; counter = number of elements
    lea si, arr             ; SI points to the start of array

next_num:
    mov al, [si]            ; get current element
    cmp al, 0               ; compare with zero
    jge skip_print          ; if AL >= 0 ? skip

    ; ---- Print negative number ----
    mov bl, al              ; copy to BL
    mov ah, 02h
    mov dl, '-'             ; print minus sign
    int 21h

    neg bl                  ; make it positive for display
    add bl, 30h             ; convert to ASCII
    mov dl, bl
    mov ah, 02h
    int 21h

skip_print:
    inc si                  ; move to next element
    dec cl                  ; decrement count
    jnz next_num            ; repeat until all elements processed

.exit
end

;Macro procedure addition and subtraction 

.model small
.stack 100h

.data
    msg1 db 10,13, "enter no: $"
    res_add db 10,13, "add: $"
    res_sub db 10,13, "sub: $"

.code

disp macro message
    mov ah, 09h
    lea dx, message
    int 21h
endm

.startup
    disp msg1
    mov ah, 01h
    int 21h
    sub al, 30h
    mov bl, al         

    disp msg1
    mov ah, 01h
    int 21h
    sub al, 30h       
    mov bh, al         

    disp res_add
    mov al, bl
    add al, bh
    add al, 30h  
    mov dl, al
    mov ah, 02h
    int 21h

    call sub_proc

.exit

sub_proc proc
    disp res_sub
    mov al, bl
    sub al, bh
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h
    ret
sub_proc endp

end 

; Mixed mode
#include <stdio.h>
int main() {
    int a, b, result;
    char op;
 
    printf("Simple Assembly Calculator\n");
 
    while(1) {
        printf("\nEnter expression (a + b, a - b, a * b, a / b) or q to quit:\n");
        if (scanf(" %d %c %d", &a, &op, &b) != 3) break;
 
        switch(op) {
            case '+':
                __asm {
                    mov eax, a
                    add eax, b
                    mov result, eax
                }
                break;
            case '-':
                __asm {
                    mov eax, a
                    sub eax, b
                    mov result, eax
                }
                break;
            case '*':
                __asm {
                    mov eax, a
                    imul eax, b
                    mov result, eax
                }
                break;
            case '/':
                if(b == 0) {
                    printf("Error: Division by zero!\n");
                    continue;
                }
                __asm {
                    mov eax, a
                    cdq         ; sign-extend EAX into EDX:EAX
                    idiv b      ; divide EDX:EAX by b, quotient in EAX
                    mov result, eax
                }
                break;
            default:
                printf("Invalid operator!\n");
                continue;
        }
 
        printf("Result: %d\n", result);
    }
 
    printf("Calculator exited.\n");
    return 0;
} 

