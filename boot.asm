
ORG 0

; 16 bit arch
BITS 16
; This is required to place the bootloader on a usb and boot from it.
; Look here for additiona info : https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29
; If not placed, some bioses may refuse to boot up as they will be looking for there parameters
; The only stuff that we actually placed there is the : jmp short xxx ; nop. All the rest 33 bytes are 0.
_bios_parameter_block:
    jmp short init_cs
    nop
times 33 db 0

init_cs:
jmp 0x7c0:init_everything_else ; this sets our cs register before anything else

; Data Segment, StacK pointer, Interrupt vector ...
init_everything_else:
    cli ; clear interrupts

    mov ax, 0x7c0 ;This is where Bios loads our bootloader
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00

    ; ss points to 0
    ; for each interrupt the table contains offset and segment
    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0
    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7c0

    sti ; enable interrupts

    jmp real_start

real_start:
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

; Interrupt table
; Some interesting resourse to learn about exceptions : https://wiki.osdev.org/Exceptions
handle_zero:
    ; this basically prints 'A' on the screen
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0x00
    int 0x10
    iret

handle_one:
    ; this basically prints 'A' on the screen
    mov ah, 0eh
    mov al, 'V'
    mov bx, 0x00
    int 0x10
    iret


; 510 - (current_address - starting_address_in_this_section)
times 510 - ($ - $$) db 0

; magic expected by Bios
dw 0xAA55

# so the full size of our program is exactly 510 + 2 = 512 bytes (1 sector)