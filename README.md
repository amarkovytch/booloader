# Booloader
Bootloader from Udemy:  "Developing a Multithreaded Kernel From Scratch!" course

## How to compile
```code
nasm -f bin ./boot.asm -o ./boot.bin
```

# How to run
```shell
qemu-system-x86_64 -nographic -hda ./boot.bin
Ctrl+a and then c to exit
```