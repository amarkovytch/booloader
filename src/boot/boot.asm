ORG 0x7c00 ;This is where Bios loads our bootloader

; 16 bit arch
BITS 16
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; This is required to place the bootloader on a usb and boot from it.
; Look here for additiona info : https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29
; If not placed, some bioses may refuse to boot up as they will be looking for there parameters
; The only stuff that we actually placed there is the : jmp short xxx ; nop. All the rest 33 bytes are 0.
_start:
_bios_parameter_block:
    jmp short init_cs
    nop
times 33 db 0

init_cs:
jmp 0:init_everything_else ; this sets our cs register before anything else

; Data Segment, StacK pointer, Interrupt vector ...
init_everything_else:
    cli ; clear interrupts

    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    sti ; enable interrupts

.load_protected:
    cli
    lgdt [gdt_descriptior]
    ; enable protected mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:load32


    jmp $ ; jump to itself, endless loop

; GDT table
; https://wiki.osdev.org/Protected_mode
; https://wiki.osdev.org/Global_Descriptor_Table
; http://www.osdever.net/tutorials/view/the-world-of-protected-mode

; the purpose here is just to configure as much memory as possible for Kernel use
gdt_start:

; the first segment always has to be NULL, this is required by Intel
gdt_null:
    dd 0x0
    dd 0x0

; offset 0x8
gdt_code:        ; CS should point to this
    dw 0xffff    ; Segment limit, first 0-15 bytes
    dw 0         ; Base first 0-15 bytes
    db 0         ; Base 16-23 bits
    db 10011010b ; Access byte
    db 11001111b ; High 4 bit flags, limit 16:19
    db 0         ; Base 24-31 bits

gdt_data:        ; DS, SS, ES, FS, GS
    dw 0xffff    ; Segment limit, first 0-15 bytes
    dw 0         ; Base first 0-15 bytes
    db 0         ; Base 16-23 bits
    db 10010010b ; Access byte
    db 11001111b ; High 4 bit flags, limit 16:19
    db 0         ; Base 24-31 bits

gdt_end:
gdt_descriptior:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
load32:
    mov eax, 1          ; starting sector
    mov ecx, 100        ; total number of sectors to read
    mov edi, 0x0100000  ; the address to load into
    call ata_lba_read
    ; now we can jump to code that is loaded to 0x0100000
    jmp CODE_SEG:0x0100000

ata_lba_read:
    ; https://wiki.osdev.org/ATA_PIO_Mode
    mov ebx, eax    ; backup the starting sector

    ; Send the highest 8 bits of the lba to disc controller
    shr eax, 24
    or eax, 0xe0 ; select the master drive
    mov dx, 0x1f6
    out dx, al ; send the highest bits to disc controller address

    ; Send the total sectors to read
    mov eax, ecx
    mov dx, 0x1f2
    out dx, al

    ; Send more bits of the lba
    mov eax, ebx
    mov dx, 0x1f3
    out dx, al

    ; Send more bits of the lba
    mov dx, 0x1f4
    mov eax, ebx
    shr eax, 8
    out dx, al

    ; Send the last bits of the lba
    mov dx, 0x1f5
    mov eax, ebx
    shr eax, 16
    out dx, al

    ; Send 'read sectors' (0x20) command
    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

    ; Read all sectors into memory
.next_sector:
    push ecx

    ; check if we need to read
.try_again:
    mov dx, 0x1f7
    in al, dx
    test al, 8
    jz .try_again

    ; Read 256 words at a time - 1 sector of 512 bytes
    mov ecx, 256
    mov dx, 0x1f0
    ; insw - read word from i/o port specified in dx to ES:DI
    ; rep prefix - repeat ecx times
    rep insw
    pop ecx
    ; loop is exactly like dec ecx / jnz, except it doesn't set flags.
    loop .next_sector

    ; THE END
    ret





; 510 - (current_address - starting_address_in_this_section)
times 510 - ($ - $$) db 0

; magic expected by Bios
dw 0xAA55
; so the full size of our program is exactly 510 + 2 = 512 bytes (1 sector)
