#include "kernel.h"
#include "idt.h"
#include "utils.h"

extern void test_interrupt();

void kernel_main()
{
    clear_screen();
    interrupt_init();
    print("Hello World!\n");
    print("Test\n");

    //test_interrupt();

}