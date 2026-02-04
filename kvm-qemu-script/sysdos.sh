#!/bin/sh
qemu-system-i386 -m 64 -cdrom FD14BNS.iso -hda dos.qcow2 -display curses -net nic,model=pcnet -net user -enable-kvm -boot c 

# use ftp because ssh is depreciated on freedos
