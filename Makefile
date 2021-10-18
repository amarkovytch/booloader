
all: compile_protected

compile_protected:
	nasm -f bin ./src/boot_protected_mode.asm -o ./bin/boot.bin
clean:
	rm ./bin/boot.bin