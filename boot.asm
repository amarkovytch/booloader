
ORG 0

; 16 bit arch
BITS 16
_start:
    jmp short init
    nop

times 33 db 0

jmp 0x7c0:start ; this sets our cs register before anything else

init:
    cli ; clear interrupts

    mov ax, 0x7c0 ;This is where Bios loads our bootloader
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00

    sti ; enable interrupts

    jmp start

start:
    mov si, message
.loop:    ; . means that it is a sub label of the outer label
    lodsb
    cmp al, 0
    je .end
    call print_char
    jmp .loop
.end:
    jmp $ ; jump to itself, endless loop

; the char to print should be in al
print_char:
    ; http://www.ctyme.com/intr/rb-0106.htm
    mov ah, 0eh ; int 0x10 + eh = Video output
    int 0x10
    ret

message: db 'Hello World', 0

; 510 - (current_address - starting_address_in_this_section)
times 510 - ($ - $$) db 0

; magic expected by Bios
dw 0xAA55