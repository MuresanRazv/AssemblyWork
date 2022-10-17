bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    x db 5
    y dw 20
    z dd 7

; our code starts here
segment code use32 class=code
    start:
        ; 10 - x + y + 4 - 1 - z
        mov AL, 10
        sub AL, byte[x]; AL = AL - x = 10 - x = 10 - 5 = 5
        
        ;10 - x + y
        mov AH, 0
        add AX, word[y]; AX = 5 + y = 5 + 20 = 25
        
        ;10 - x + y + 4
        add AX, 4; AX = 25 + 4 = 29
        
        ;10 - x + y + 4 - 1 - z
        sub AX, 1; AX = 29 - 1 = 28
        
        mov EBX, 0
        mov BX, AX
        sub EBX, dword[z]; EBX = AX - z = 28 - 7 = 21
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
