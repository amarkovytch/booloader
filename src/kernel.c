#include "kernel.h"
#include "idt.h"
#include "utils.h"

void kernel_main()
{
    clear_screen();
    interrupt_init();
    print("Hello World!\n");
    print("Test");
}