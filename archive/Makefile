real: compile_real common

all: compile_real common

compile_real:
	nasm -f bin ./boot_real_mode.asm -o ./boot.bin

common:
	dd if=./message.txt >> ./boot.bin
	dd if=/dev/zero bs=512 count=1 >> ./boot.bin

clean:
	rm boot.bin