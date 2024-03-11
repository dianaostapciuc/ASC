;A file name and a text (defined in the data segment) are given. The text contains lowercase letters and spaces. Replace all the letters on even positions with their position. Create a file with the given name and write the generated text to file.


bits 32

global start

; declare external functions needed by our program
extern exit, fopen, fprintf, fclose, perror
import exit msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
import perror msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data

    text db "vine iarna si examene"
    len db $-text
    file_name db "writing_stuff.txt", 0
    access_mode db "w", 0
    file_descriptor dd -1
    temp dd 0
    character_format db "%c", 0
    number_format db "%d", 0
    pos db 0

; our code starts here
segment code use32 class=code
    start:
    
    push dword access_mode
    push dword file_name
    call [fopen]       
    add esp, 4*2
    ; we create the file
    
    mov [file_descriptor], eax
    cmp eax, 0                  ; we check to see if we can open file, if not eax becomes 0
    je exitting
    
    mov ecx, 0
    mov cl, [len]
    add cl, 1 ;we add 1 to the length to use the positions accordingly
    
    mov eax, 0
    mov esi, text
    mov ebx, esi ;ebx stores ebi for future reference
    
    repeta:
    
        dec esi
        lodsb ; adding the first byte onto eax
        
        cmp al, 'a'
        jb notletter
        cmp al, 'z'
        ja notletter
        
        push esi
        sbb esi, ebx 
        add esi, 1
        mov edx, esi
        mov [pos], dl
        test esi, 1     ; we use test to see if the position is odd/even
        pop esi
        jnz notletter ; if the position is odd, we also print the character without modifying
        
        pusha
        push dword [pos]        ; modyfing and printing the even positions
        push dword number_format
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        popa
        jmp endd
        
        notletter:    ; we print whatever we don't change
        pusha ; we put all the values on the registers on a stack since fprintf might change them
        mov [temp], ax
        push dword character_format
        push dword temp
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        popa
        
        endd:
        inc esi   
        
    loop repeta
       
    push dword [file_descriptor]
    call [fclose]
    add esp, 4
    
    exitting:
    push dword 0
    call [exit]