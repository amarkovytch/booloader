real: compile_real common

protected: compile_protected

compile_real:
	nasm -f bin ./boot_real_mode.asm -o ./boot.bin

compile_protected:
	nasm -f bin ./boot_protected_mode.asm -o ./boot.bin

common:
	dd if=./message.txt >> ./boot.bin
	dd if=/dev/zero bs=512 count=1 >> ./boot.bin

clean:
	rm boot.bin