#!/bin/sh

qemu-system-x86_64 -m 1G -drive file=netbsd.qcow2,format=qcow2,if=virtio -nographic -serial mon:stdio -display none -netdev user,id=net0,ipv6=off,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=net0 -accel tcg,thread=multi,tb-size=1024 -smp cores=8,threads=1 -cpu max
