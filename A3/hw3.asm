; Given the byte A and the word B, compute the doubleword C as follows:
; the bits 24-31 of C are the same as the bits of A (correct)
; the bits 16-23 of C are the invert of the bits of the lowest byte of B 
; the bits 10-15 of C have the value 1
; the bits 2-9 of C are the same as the bits of the highest byte of B
; the bits 0-1 both contain the value of the sign bit of A (sign bit is the leftest bit)

bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it
import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
    a db 0101_1001b
    b dw 0100_1011_1011_1110b
    c dd 0
    
segment  code use32 class=code ; code segment
start: 

;we compute the result here in EBX

mov EBX, 0                   
mov EAX, 0
mov ECX, 0

mov AL, [a]

mov EBX, EAX
mov EAX, 0
mov CL, 24
rol EBX, CL ;24-31

mov AX, [b]
and AX, 0000000011111111b
not AL ; we invert the values


mov CL, 16
rol EAX, CL
or EBX, EAX ;16-23

or EBX, 000000000000000011111100_0000_0000b ;10-15

mov AX, 0
mov AX, [b]
and AX, 1111111100000000b

mov CL, 6
ror EAX, CL
or EBX, EAX ; 2-9

mov EAX, 0
mov AL, [a]
and AL, 1000_0000b

mov CL, 7
ror EAX, CL
or EBX, EAX ; 0

mov CL, 1
rol EAX, CL
or EBX, EAX ; 1

push dword 0 ;saves on stack the parameter of the function exit
call [exit] ;function exit is called in order to end the execution of the program