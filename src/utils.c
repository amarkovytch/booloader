#include "utils.h"
#include "defines.h"
#include <stdbool.h>
#include <stdint.h>

/* initialized to 0 */
static uint8_t CURRENT_PRINT_COL_POS;
static uint8_t CURRENT_PRINT_ROW_POS;

static uint16_t terminal_prepare_char(char c, char colour) { return (colour << 8) | c; }

static void print_pos_advance()
{
    CURRENT_PRINT_COL_POS++;
    if (CURRENT_PRINT_COL_POS >= VGA_WIDTH)
    {
        CURRENT_PRINT_COL_POS = 0;
        CURRENT_PRINT_ROW_POS++;
        if (CURRENT_PRINT_ROW_POS >= VGA_HEIGHT)
        {
            CURRENT_PRINT_ROW_POS = 0;
        }
    }
}

static void print_pos_new_line()
{
    CURRENT_PRINT_COL_POS = 0;
    CURRENT_PRINT_ROW_POS++;
    if (CURRENT_PRINT_ROW_POS >= VGA_HEIGHT)
    {
        CURRENT_PRINT_ROW_POS = 0;
    }
}

/* prints char at current to current col and row and advances them according to limits */
static void print_char_at_current_pos_and_advance_pos(char ch, uint8_t color)
{
    uint16_t *video_mem = (uint16_t *)VIDEO_TEXT_MODE_MEMORY_ADDR;
    video_mem[CURRENT_PRINT_COL_POS + VGA_WIDTH * CURRENT_PRINT_ROW_POS] = terminal_prepare_char(ch, color);

    print_pos_advance();
}

/* deals with special characters (i.e \n). returns true if given char was special */
static bool print_treat_special_chars(char ch)
{
    switch (ch)
    {
    case ('\n'):
        print_pos_new_line();
        return true;
    default:
        return false;
    }
}

void clear_screen()
{
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++)
    {
        print_char_at_current_pos_and_advance_pos(' ', 0);
    }
}

/* https://wiki.osdev.org/Printing_To_Screen */
void print(const char *msg)
{
    for (int i = 0; msg[i] != 0; i++)
    {
        if (print_treat_special_chars(msg[i]))
        {
            continue;
        }
        print_char_at_current_pos_and_advance_pos(msg[i], 15);
    }
}

void memset(void *s, int c, size_t n)
{
    for (int i = 0; i < n; i++)
    {
        ((char *)s)[i] = (char)c;
    }
}