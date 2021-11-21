section .asm

;extern void out_word_to_port_asm(uint16_t w, uint16_t port);
;extern uint8_t in_byte_from_port_asm(uint16_t port);
;extern uint16_t in_word_from_port_asm(uint16_t port);

global out_byte_to_port_asm
global out_word_to_port_asm
global in_byte_from_port_asm
global in_word_from_port_asm

out_byte_to_port_asm:
    push ebp
    mov ebp, esp

    mov eax, [ebp+8]; b
    mov edx, [ebp+12]; port
    out dx, al

    pop ebp
    ret

out_word_to_port_asm:
    push ebp
    mov ebp, esp

    mov eax, [ebp+8]; b
    mov edx, [ebp+12]; port
    out dx, ax

    pop ebp
    ret

in_byte_from_port_asm:
    push ebp
    mov ebp, esp

    mov edx, [ebp+8]; port
    in al, dx

    pop ebp
    ret

in_word_from_port_asm:
    push ebp
    mov ebp, esp

    mov edx, [ebp+8]; port
    in ax, dx

    pop ebp
    ret