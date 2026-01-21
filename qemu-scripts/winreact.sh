#!/bin/sh

xhost +local:root
doas qemu-system-i386 -m 512M -drive if=ide,file=reactos_hdd.qcow2 -net nic,model=pcnet -net user -vga cirrus -usbdevice tablet -rtc base=localtime -serial stdio
