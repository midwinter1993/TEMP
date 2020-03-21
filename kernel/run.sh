#!/bin/bash

##################################################
# Misc
#-------------------------------------------------
case "$(uname -s)" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN$(uname -s)"
esac

TOP=`pwd`
QEMU=qemu-system-x86_64


##################################################
# Run qemu with kernel+busybox
#-------------------------------------------------
# KERNEL=$TOP/obj/linux-5.5.11-x86-basic/arch/x86_64/boot/bzImage
# BUSYBOX=$TOP/obj/initramfs-busybox-x86.cpio.gz
KERNEL=$TOP/bzImage
BUSYBOX=$TOP/initramfs-busybox-x86.cpio.gz

case $machine in
    Linux) KVM_OPT="-enable-kvm -smp sockets=1,cores=5,threads=1 ";;
    *) KVM_OPT=""
esac

cd $TOP

$QEMU \
    -kernel $KERNEL \
    -initrd $BUSYBOX \
    -nographic \
    -append "console=ttyS0" \
    $KVM_OPT \
    # -D ./qemu.log
