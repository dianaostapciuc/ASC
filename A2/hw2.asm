bits 32
global start

extern exit 
import exit msvcrt.dll 

segment data use32 class=data
    a db 20
    b dw 25
    c dd 3
    d dq 62
    
    a1 db 15
    b1 dw 26
    c1 dd 30
    d1 dq 75
    
    a3 db 7
    b3 db 2
    c3 db 3
    e3 dw 20
    x3 dq 3
    
segment code use32 class=code
start:
 ;a - byte, b - word, c - double word, d - qword - Unsigned representation
 ;19: (d+d)-(a+a)-(b+b)-(c+c) = 124 - 40 - 50 - 6 = 28
 
mov EAX, [d]
mov EBX, [d+4]
add EAX, [d]
adc EBX, [d+4]

mov ECX, 0
mov CL, [a]
add CL, [a]
sub EAX, ECX
sbb EBX, 0

mov ECX, 0
mov CX, [b]
add CX, [b]
sub EAX, ECX
sbb EBX, 0

mov ECX, 0
mov ECX, [c]
add ECX, [c]
sub EAX, ECX
sbb EBX, 0

 ;a - byte, b - word, c - double word, d - qword - Signed representation
 ;19: (d+a)-(c-b)-(b-a)+(c+d) = 90 - 4 - 11 + 105 = 180
mov EAX, 0
mov EBX, 0
mov ECX, 0
mov EDX, 0

mov EBX, [d1]
mov ECX,[d1+4] ; ECX:EBX
mov AX, [a1]
cbw
cwd
cdq ;EDX:EAX
add EBX, EAX
adc ECX, EDX ;we have the result of d+a on ECX:EBX

mov EAX, 0
mov EDX, 0
mov AX, [b1]
cwd
push DX
push AX
pop EAX
mov EDX, 0
mov EDX, [c1]
sub EDX, EAX ; we have the result in EDX for now

mov EAX, 0
mov EAX, EDX ;result in EAX
cdq ;EDX:EAX

sub EBX, EAX
sbb ECX, EDX ;result ECX:EBX, we have EAX, EDX free

mov EAX, 0
mov EDX, 0
mov DX, [b1]
mov AL, [a1]
cbw
sub DX, AX ;result on DX (b-a= 11)

mov EAX, 0
mov AX, DX
mov DX, 0
cwd
push DX
push AX
pop EAX
cdq ;result on EDX:EAX

sub EBX, EAX
sbb ECX, EDX ; 75, result on ECX:EBX, the rest free

mov EAX, 0
mov EDX, 0
mov EAX, [c1]
cdq ;EDX:EAX
add EAX, [d1]
adc EDX, [d1+4] ;c+d result on EDX:EAX 

add EBX, EAX
adc ECX, EDX

; 19: (a+a+b*c*100+x)/(a+10)+e*a; a,b,c-byte; e-doubleword; x-qword = 176

; unsigned:

mov BX,0
mov BL, [a3]
add BL, BL ;a+a result in BL = 14 (correct)

mov AL, [b3]
mov DL, [c3]
mul byte DL ; result of b*c in AX = 6 (correct)

mov CL, 100
mul byte CL ; result of b*c*100 in AX = 600 (correct)

add BX, AX ; result of a+a+b*c*100 in BX = 614 (correct) 

mov EAX,0
mov EDX,0
mov AX,BX;EDX:EAX=a+a+b*c*100 (correct)

mov EBX, [x3]
mov ECX, [x3+4] ;ECX:EBX - x (correct)
add EAX,EBX
adc EDX,ECX;EDX:EAX=a+a+b*c*100+x = 617(correct)

mov ECX, 0
mov CL, [a3]
add CL, 10 ;result of a+10 in CL = 17 (correct)

div dword ECX ;result in EDX:EAX = 36 (correct) rest 5 in EDX (correct)

mov EBX, 0
mov ECX, 0

mov EBX, EAX
mov ECX, EDX ;result in ECX:EBX (correct, it moves the values)

mov EAX, 0
mov EDX, 0
mov EAX, [e3]
mul byte [a3] ;e*a in EDX:EAX = 140 (correct)

add EAX, EBX
adc EDX, ECX    ; = 176 (corect)

; 19: (a+a+b*c*100+x)/(a+10)+e*a; a,b,c-byte; e-doubleword; x-qword 

; unsigned:

mov BX,0
mov BL, [a3]
add BL, BL ;a+a result in BL

mov AL, [b3]
mov DL, [c3]
mul byte DL ; result of b*c in AX

mov CL, 100
mul byte CL ; result of b*c*100 in AX

add BX, AX ; result of a+a+b*c*100 in BX
mov EAX,0
mov EDX,0
mov AX,BX ;EDX:EAX=a+a+b*c*100

mov EBX, [x3]
mov ECX, [x3+4] ;ECX:EBX - x
add EAX,EBX
adc EDX,ECX ;EDX:EAX=a+a+b*c*100+x

mov ECX, 0
mov CL, [a3]
add CL, 10 ;result of a+10 in CL

div dword ECX

; (a+a+b*c*100+x)/(a+10)+e*a -> signed

mov EBX,0
mov BL, [a3]
add BL, BL ;a+a result in BL = 14 

mov EAX, 0
mov EDX, 0
mov AL, [b3]
mov DL, [c3]
imul byte DL ; result of b*c in AX = 6 

mov ECX, 0
mov CL, 100
imul byte CL ; result of b*c*100 in AX = 600 (correct)

add BX, AX ; result of a+a+b*c*100 in BX = 614  (correct)

mov EAX,0
mov EDX,0
mov AX,BX ; (correct)
cwd
cdq ;EDX:EAX=a+a+b*c*100 

mov EBX, [x3]
mov ECX, [x3+4] ;ECX:EBX - x 
add EAX,EBX
adc EDX,ECX ;EDX:EAX=a+a+b*c*100+x = 617 (correct)

mov EBX, 0
mov ECX, 0
mov ECX, EDX
mov EBX, EAX ;now, result is on ECX:EBX (correct)


mov EAX, 0
mov AL, [a3]
add AL, 10 ;result of a+10 in AL = 17 (correct)
cbw
cwd

mov EDX, 0
mov EDX, EAX
mov EAX, EBX
mov EBX, EDX;this contains 17
mov EDX, ECX ;result on EDX:EAX again

idiv dword EBX ;result in EDX:EAX = 36  rest 5 in EDX (correct)

mov EBX, 0
mov ECX, 0

mov EBX, EAX
mov ECX, EDX ;moves result in ECX:EBX (correct)

mov EAX, 0
mov EDX, 0
mov EDX, [e3] ;e-dw, a-b
mov AL, [a3]
cbw
cwde
imul dword EDX ;e*a in EAX = 140

mov EDX, 0
cdq ;e*a in EDX:EAX

add EAX, EBX
adc EDX, ECX    ; = 176 

push dword 0 
call [exit]