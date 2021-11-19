#include "defines.h"
#include <stdint.h>

static uint16_t terminal_prepare_char(char c, char colour) { return (colour << 8) | c; }

void clear_screen()
{
    uint16_t *video_mem = (uint16_t *)VIDEO_TEXT_MODE_MEMORY_ADDR;

    for (int i = 0; i < VGA_WIDTH; i++)
    {
        for (int j = 0; j < VGA_HEIGHT; j++)
        {
            video_mem[i + VGA_WIDTH * j] = terminal_prepare_char(' ', 0);
        }
    }
}

/* https://wiki.osdev.org/Printing_To_Screen */
void print(const char *msg)
{
    uint16_t *video_mem = (uint16_t *)VIDEO_TEXT_MODE_MEMORY_ADDR;

    int i = 0;
    for (i = 0; msg[i] != 0; i++)
    {
        video_mem[i] = terminal_prepare_char(msg[i], 15);
    }
}