#!/bin/bash

TOP=`pwd`

##################################################
# Build kernel
#-------------------------------------------------
KERNEL=linux-5.5.11
KERNEL_DIR="$TOP/$KERNEL"
cd $KERNEL_DIR


# Basic config
mkdir -pv ../obj/$KERNEL-x86-basic

# make O=../obj/$KERNEL-x86-basic clean
# make O=../obj/$KERNEL-x86-basic x86_64_defconfig
# make O=../obj/$KERNEL-x86-basic kvmconfig
# make O=../obj/$KERNEL-x86-basic nconfig
# make O=../obj/$KERNEL-x86-basic -j8

# Small config
# make O=../obj/$KERNEL-x86-basic alldefconfig
# make O=../obj/$KERNEL-x86-basic nconfig
make O=../obj/$KERNEL-x86-basic -j8

# Config
# -> Device Drivers
#   -> Character devices
#     -> Serial drivers
#        [*] 8250/16550 and compatible serial support
#        [*] Console on 8250/16550 and compatible serial port
# -> General setup
#    [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support

