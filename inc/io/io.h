#ifndef IO_H
#define IO_H

#include <stdint.h>

void out_byte_to_port(uint8_t b, uint16_t port);
void out_word_to_port(uint16_t w, uint16_t port);
uint8_t in_byte_from_port(uint16_t port);
uint16_t in_word_from_port(uint16_t port);

#endif