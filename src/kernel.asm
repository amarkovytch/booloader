[BITS 32]
global _start
extern kernel_start

CODE_SEG equ 0x08
DATA_SEG equ 0x10




_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x02000000
    mov esp, ebp

    ; enable A20
    ; https://wiki.osdev.org/A20_Line
    in al, 0x92
    or al, 2
    out 0x92, al

    call kernel_start
    jmp $

; 510 - (current_address - starting_address_in_this_section)
times 512 - ($ - $$) db 0
