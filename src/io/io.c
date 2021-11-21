#include "io.h"

extern void out_byte_to_port_asm(uint8_t b, uint16_t port);
extern void out_word_to_port_asm(uint16_t w, uint16_t port);
extern uint8_t in_byte_from_port_asm(uint16_t port);
extern uint16_t in_word_from_port_asm(uint16_t port);

void out_byte_to_port(uint8_t b, uint16_t port) { out_byte_to_port_asm(b, port); }
void out_word_to_port(uint16_t w, uint16_t port) { out_word_to_port_asm(w, port); }
uint8_t in_byte_from_port(uint16_t port) { return in_byte_from_port_asm(port); }
uint16_t in_word_from_port(uint16_t port) { return in_word_from_port_asm(port); }