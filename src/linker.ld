ENTRY(_start)
OUTPUT_FORMAT(binary)
SECTIONS
{
    . = 1M; /* the starting address ix 0x10 0000 */
    .text : ALIGN(4096)
    {
        /* take all the text sections from all object files,
           if there are none, this section will not get created */
        *(.text)
    }

    .rodata : ALIGN(4096)
    {
        *(.rodata)
    }

    .data : ALIGN(4096)
    {
        *(.data)
    }

    .bss : ALIGN(4096)
    {
        *(COMMON) /* https://stackoverflow.com/questions/16835716/bss-vs-common-what-goes-where */
        *(.bss)
    }
}