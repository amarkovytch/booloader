#ifndef UTILS_H
#define UTILS_H

#include <stddef.h>

/**
 * @brief Clears the screen (prints black ' ' all over)
 */
void clear_screen();

/**
 * @brief Prints message on the screen
 *
 * @param msg The message to print
 */
void print(const char *msg);

/**
 * @brief Set memory to char c
 *
 * @param memory The memory to set
 * @param size The size of memory to set
 * @param char The char to set memory with
 */
void memset(void *s, int c, size_t n);

#endif
