#include "idt.h"
#include "defines.h"
#include "utils.h"

/* initialized to 0 */
static struct idt_desc interrupt_table[TOTAL_INTERRUPTS];
static struct idtr_desc interrupt_table_descriptor;

extern void idt_load_asm(struct idtr_desc *ptr);

void idt_zero() { print("Divide by zero error\n"); }

static void idt_set(int interrupt_no, void *addr)
{
    struct idt_desc *interrupt = &interrupt_table[interrupt_no];

    interrupt->offset_1 = (uint32_t)addr & 0x0000ffff;
    interrupt->offset_2 = (uint32_t)addr >> 16;
    interrupt->selector = KERNEL_CODE_SELECTOR;
    interrupt->zero = 0;
    /* 1110 - Interrupt gate */
    /* 11 - DPL, ring level 3 */
    /* enabled */
    interrupt->type_attributes = (uint8_t)0b11101110;
}

void interrupt_init()
{
    interrupt_table_descriptor.limit = sizeof(interrupt_table) - 1;
    interrupt_table_descriptor.base = (uint32_t)&interrupt_table;

    idt_set(0, idt_zero);

    idt_load_asm(&interrupt_table_descriptor);
}
