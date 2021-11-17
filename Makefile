FILES = ./build/kernel.asm.o ./build/kernel.o
INCLUDES = -I ./src

# ffreestanding - freestanding environment
# fno-builtin - Don't recognize built-in functions that do not begin with__builtin_ as prefix
# 				also implied by ffreestanding
# fstrength-reduce - optimize expensive math operations with cheaper ones
# fomit-frame-pointer - omits the storing of stack frame pointers during function calls
# finline-functions - consider all functions for inlining, even if they are not declared inline
# Wno-unused-function - do not warn on presence of unused functions
# Wno-cpp - suppress warning messages emitted by #warning directives
FLAGS = -g -ffreestanding -fno-builtin -nostdlib -nostartfiles -nodefaultlibs -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -Wno-unused-label -Wno-unused-parameter -Wno-cpp -Werror -Wall -O0 -Iinc

all: ./bin/boot.bin ./bin/kernel.bin
	rm -rf ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin

./bin/kernel.bin: $(FILES)
	i686-elf-ld -g -relocatable $(FILES) -o ./build/kernelfull.o
	i686-elf-gcc $(FLAGS) -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o


./bin/boot.bin: ./src/boot/boot.asm
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot.bin

./build/kernel.asm.o: ./src/kernel.asm
	nasm -f elf -g  ./src/kernel.asm -o ./build/kernel.asm.o

./build/kernel.o: ./src/kernel.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./src/kernel.c -o ./build/kernel.o

clean:
	rm ./bin/boot.bin
	rm -rf ./bin/kernel.bin
	rm -rf $(FILES)
	rm -rf ./build/kernelfull.o