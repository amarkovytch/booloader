# Booloader
Bootloader from Udemy:  "Developing a Multithreaded Kernel From Scratch!" course

## How to compile
```code
make all
```

# How to run
```shell
qemu-system-x86_64 -nographic -hda ./boot.bin
Ctrl+a and then c to exit
```

# How to debug
Note :  16 bit code debugging didn't work for me, just 32-bit protected mode

Run gdb and then:
```shell
target remote | qemu-system-x86_64 -hda ./boot.bin -S -gdb stdio
```
This will stop before the first instruction (thanks to -S flag). You can now setup breakpoint to any address

# Additional files
Older version of the bootloader in 'real' mode can be found in 'old' folder