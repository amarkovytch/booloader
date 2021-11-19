# Booloader
Bootloader from Udemys:  "Developing a Multithreaded Kernel From Scratch!" course

## Prerequisites
* Install cross platform gcc with no dependencies on native libraries, visit this page for more info:
https://wiki.osdev.org/GCC_Cross-Compiler


## How to compile
```code
make all
```

# How to run
```shell
qemu-system-x86_64 -hda ./bin/os.bin
```
or
```shell
./run.sh
```

Ctrl+a and then c to exit

# How to debug
Note :  16 bit code debugging didn't work for me, just 32-bit protected mode

Run gdb and then:
```shell
target remote | qemu-system-x86_64 -hda ./bin/os.bin -S -gdb stdio
```
This will stop before the first instruction (thanks to -S flag). You can now setup breakpoint to any address

# Additional files
Older version of the bootloader in 'real' mode can be found in 'old' folder