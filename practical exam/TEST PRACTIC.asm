bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll
                       


; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "TEST.TXT", 0
    acces_mode db "a+", 0
    file_descriptor dd -1
    
    mess db " Dar trebuie", 0
    
    len equ 100
   
    read_mess db 0
    format db "%s", 0

; our code starts here
segment code use32 class=code
    start:
        push dword acces_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        cmp eax, 0
        je finish
        
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword read_mess
        call [fread]
        add esp, 4*4
        
        push dword read_mess
        call [printf]
        add esp, 4*1
        
        push dword mess
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*2
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4*1
    
        finish:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
