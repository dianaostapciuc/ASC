; hw1

bits 32
global start
extern exit
import exit msvcrt.dll  
segment data use32 class=data
x db 1

a db 30
b db 3
c db 2
d db 7

a2 dw 10
b2 dw 8
c2 dw 7
d2 dw 4

a3 db 5
b3 db 6
c3 db 7
d3 dw 60 

a4 db 20
b4 db 7
c4 db 4
d4 db 5
e4 dw 65
f4 dw 24
g4 dw 82 
h4 dw 94

segment code use32 class=code

start:

;simple exercises (24: 256/1)

mov AX, 256
div BYTE [x] 
    
; a,b,c,d - byte
; 24 :(a-b-b-c)+(a-c-c-d)
    
mov AL, [a]
sub AL,[b]
sub AL,[b]
sub AL,[c]
mov BL, [a]
sub BL, [c]
sub BL, [c]
sub BL, [d]
add BL, AL
    
; a, b, c, d - word
; 24 : (a-c)+(b-d)
    
mov AX, [a2]
sub AX, [c2]
mov BX, [b2]
sub BX, [d2]
add AX, BX

; a,b,c - byte, d - word
; 24 : (10*a-5*b)+(d-5*c) = 20 + 25 = 45

mov AL, [a3]
mov BL, 10
mul byte BL ; 10*a <- ax

mov CX, AX ; we move the multiplying result in CX

mov AL, [b3]
mov BL, 5
mul byte BL

sub CX, AX ; <- 10*a-5*b

mov DX, [d3] ; <- d3

mov AX, 0
mov BL, 5
mov AL, [c3]
mul byte BL

sub DX, AX ; <- d-5*c

add CX, DX

; a,b,c,d-byte, e,f,g,h-word
; 24 : [(a-d)+b]*2/c = 11

mov AL, [a4]
mov BL, [d4]
sub AL, BL ;<- a-d

mov CL, [b4] ;<- b

add AL, CL ;<- (a-d) + b

mov BH, 2
mul byte BH ; <- ((a-d)+b)*2

mov BH, 0
mov BH, [c4]
div byte BH   ;<- ((a-d)+b)*2/c

push dword 0
call [exit]
    