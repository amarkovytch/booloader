CC = i686-elf-gcc
LD = i686-elf-ld
ASM = nasm

OBJ_DIR = ./obj
BUILD_DIR = ./bin
SRC_DIR = ./src

_OBJ = kernel.asm.o kernel.o utils.o
OBJ = $(patsubst %,$(OBJ_DIR)/%,$(_OBJ))

INCLUDES = -I ./inc

# ffreestanding - freestanding environment
# fno-builtin - Don't recognize built-in functions that do not begin with__builtin_ as prefix
# 				also implied by ffreestanding
# fstrength-reduce - optimize expensive math operations with cheaper ones
# fomit-frame-pointer - omits the storing of stack frame pointers during function calls
# finline-functions - consider all functions for inlining, even if they are not declared inline
# Wno-unused-function - do not warn on presence of unused functions
# Wno-cpp - suppress warning messages emitted by #warning directives
FLAGS = -g -ffreestanding -fno-builtin -nostdlib -nostartfiles -nodefaultlibs -falign-jumps -falign-functions -falign-labels \
        -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -Wno-unused-label \
		-Wno-unused-parameter -Wno-cpp -Werror -Wall -O0

all: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin
	rm -rf $(BUILD_DIR)/os.bin
	dd if=$(BUILD_DIR)/boot.bin >> $(BUILD_DIR)/os.bin
	dd if=$(BUILD_DIR)/kernel.bin >> $(BUILD_DIR)/os.bin
	dd if=/dev/zero bs=512 count=100 >> $(BUILD_DIR)/os.bin

$(BUILD_DIR)/kernel.bin: $(OBJ)
	$(LD) -g -relocatable $(OBJ) -o $(OBJ_DIR)/kernelfull.o
	$(CC) $(FLAGS) -T $(SRC_DIR)/linker.ld -o $(BUILD_DIR)/kernel.bin -ffreestanding -O0 -nostdlib $(OBJ_DIR)/kernelfull.o


$(BUILD_DIR)/boot.bin: $(SRC_DIR)/boot/boot.asm
	$(ASM) -f bin $(SRC_DIR)/boot/boot.asm -o $(BUILD_DIR)/boot.bin

$(OBJ_DIR)/kernel.asm.o: $(SRC_DIR)/kernel.asm
	$(ASM) -f elf -g   $(SRC_DIR)/kernel.asm -o $(OBJ_DIR)/kernel.asm.o

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(INCLUDES) $(FLAGS) -std=gnu99 -c -o $@ $<

clean:
	rm -rf $(OBJ_DIR)/*
	rm -rf $(BUILD_DIR)/*
