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
extern isprime
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    message db "How many numbers are you reading? ", 0    
    mess db "nr=", 0    
    format db "%d", 0
    n db 0
    x dd 0

; our code starts here 
segment code use32 public code
    start:
        
       
        push dword message
        call [printf]
        add esp, 4*1
        
        push dword n
        push dword format
        call [scanf]
        add esp, 4*2
        
        mov ecx, [n]
               
        list:
            pushad ;pushes the values of the registers and preserves them, keeps them safe
            
            push dword mess
            call [printf]
            add esp, 4*1
            
            push dword x
            push dword format
            call [scanf]
            add esp, 4*2
                        
            push dword [x]
            call isprime
            add esp, 4*1
            
            cmp eax, 0
            jne yes
            jmp no
            
            yes:
                
                push dword [x]
                push dword format
                call [printf]
                add esp, 4*2
                
            no:
                popad

        loop list
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program