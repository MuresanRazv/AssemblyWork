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
    x db 3
    y dw 2
    z dd 10
    
; our code starts here
segment code use32 class=code
    start:
        ;( 10 / x + 2 * x / 7 - 2 * x ) * z
        mov AX, 10
        div byte[x]; AX = 10 / x        
        mov BL, AL
        
        ;2 * x
        mov AL, 2
        mul byte[x] 
        ;AX / y
        mov DX, 0 ;AX -> DX:AX
        div word[y]
        
        ; BL = 10 / x, AX = 2 * x / y
        mov BH, 0
        add BX, AX
        
        ;2 * x
        mov AL, 2
        mul byte[x]; AX = AL * x
        
        ;10 / x + 2 * x / 7 - 2 * x
        sub BX, AX
        
        ;( 10 / x + 2 * x / 7 - 2 * x ) * z
        ;() * z = BX * z
        mov EAX, 0
        mov AX, BX;EAX = ()
        mul dword[z];EDX:EAX = EAX * z 
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
