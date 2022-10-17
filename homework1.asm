bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 3
    b dw 5
    c dd 10
    d db 7

; our code starts here
segment code use32 class=code
    start:
        ; clean EAX for later division
        mov EAX, 0
        
        ; (a + b) * c / d - (a * b)
        
        ; (a + b) -> AX
        mov AH, 0
        mov AL, byte[a]
        add AX, word[b]
        
        ; (a + b) * c
        ;    |      |
        ;  word * dword => EDX:EAX
        
        mul dword[c]
        
        ; (a + b) * c / d
        ;  ----------   | 
        ;       |      byte
        ;       |
        ;    EDX:EAX: dword

        mov EBX, 0
        mov BL, byte[d]
        div EBX
        
        ; (a + b) * c / d - (a * b)
        ;  --------------      |
        ;         |            |
        ;         |         byte * word: DX:AX
        ;         |
        ;      EDX:EAX: dword
        
        ; move (a + b) * c / d to ECX:EBX and store (a * b) in DX:AX
        mov ECX, EDX
        mov EBX, EAX
        mov EDX, 0
        
        ; store a in EAX
        mov EAX, 0
        ; a - byte => 
        mov AL, byte[a]
        mul word[b]
        
        ; now subtract (a * b) from ECX:EBX
        sub EBX, EAX
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
