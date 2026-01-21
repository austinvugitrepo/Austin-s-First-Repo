@echo off
set QEMU_PATH=.\qemu\qemu-system-x86_64.exe

%QEMU_PATH% -L .\qemu\share -m 1G -drive file=netbsd.qcow2,format=qcow2,if=virtio -netdev user,id=net0,ipv6=off,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=net0 -accel tcg,thread=multi,tb-size=1024 -smp cores=8,threads=1 -cpu max -vga std -device usb-ehci,id=usb -device usb-tablet -display gtk,zoom-to-fit=on

pause