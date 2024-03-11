bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2, 1, 3, -3
    l1 equ $-a
    b db 4, 5, -5, 7
    l2 equ $-b
    r times l1+l2 db 0

; our code starts here
segment code use32 class=code
; Two byte strings A and B are given. Obtain the string R that contains only the odd positive elements of the two strings.
; Example:
; A: 2, 1, 3, -3
; B: 4, 5, -5, 7
; R: 1, 3, 5, 7

    start:
    
    mov ecx, l1 ;length of a
    mov esi, 0 ; index
    mov edx, 0
    
    jecxz stop 
    repeats:
    
        mov al, [a+esi]
        mov ah, al
        and al, 0000_0001b ;for the parity flag
        
        jpe go
        cmp ah, 0
        jle gonext
        mov [r+edx], ah
        add edx, 1
        go:
        gonext:
        inc esi
        
    loop repeats
    stop:
    
    mov ecx, 0
    mov ecx, l2 ;length of b
    ;keeping the previous index
    mov esi, 0 ; new index
        
    jecxz stopp
    repeatss:
    
        mov al, [b+esi]
        mov ah, al
        and al, 0000_0001b
        
        jpe goo
        cmp ah, 0
        jle gonextt
        mov [r+edx], ah
        add edx, 1
        goo:
        gonextt:
        inc esi 
        
    loop repeatss
    stopp:

        
    push dword 0      ; push the parameter for exit onto the stack
    call [exit]       ; call exit to terminate the program