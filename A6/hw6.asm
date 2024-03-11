bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
extern exit, printf, scanf ; add printf and scanf as extern functions               
import printf msvcrt.dll    ; tell the assembler that function printf is found in msvcrt.dll library
import scanf msvcrt.dll     ; similar for scanf

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    message1 db "a=", 0
    message2 db "b=", 0
    format db "%d", 0
    format2 db "%x", 0
    a dd 0
    b dd 0
; our code starts here
segment code use32 class=code
    start:
    
    add esp, 0
        
    push dword message1
    call [printf]
    add esp, 4*1
    
    push dword a
    push dword format 
    call [scanf]
    add esp, 4*2
    
    push dword message2
    call [printf]
    add esp, 4*1
    
    push dword b
    push dword format
    call [scanf]
    add esp, 4*2

    mov al, [a]
    mov bl, [b]
    add al, bl
    
    push dword eax
    push dword format2
    call [printf]
    add esp, 4*2
    
    push dword 0      ; push the parameter for exit onto the stack
    call [exit]       ; call exit to terminate the program
