#ifndef IDT_H
#define IDT_H

#include <stdint.h>

/* https://wiki.osdev.org/Interrupt_Descriptor_Table */

struct idt_desc
{
    uint16_t offset_1;       // offset bits 0..15
    uint16_t selector;       // a code segment selector in GDT or LDT
    uint8_t zero;            // unused, set to 0
    uint8_t type_attributes; // gate type, dpl, and p fields
    uint16_t offset_2;       // offset bits 16..31
} __attribute__((packed));

struct idtr_desc
{
    uint16_t limit; // size of descriptor table - 1
    uint32_t base;  //  base address of the start of the table
} __attribute__((packed));

/**
 * @brief Inits the interrupt table
 */
void interrupt_init();

#endif