bits 32
global isprime
extern exit
import exit msvcrt.dll
 
segment data use32 class=data
; ... 



segment code use32 class=code
isprime:
; ... 
    
    push ebp
    mov ebp, esp
    
    cmp [ebp + 8], dword 1    ;ebp+8 is where our argument is
    jle not_prime

    mov ebx, 2
    loop_2:
    
        cmp ebx, [ebp + 8]
        je prime
    
        mov edx, 0
        mov eax, [ebp + 8]  ; or cdq since since we've reached this point then our number is positive
        div ebx
        cmp edx, 0
        je not_prime
        inc ebx
        jmp loop_2
        
    prime:
        mov eax, 1
        jmp ending
    not_prime:
        mov eax, 0
        
    ending:
    mov esp, ebp
    pop ebp
    ret
