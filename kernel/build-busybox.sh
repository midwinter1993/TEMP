#!/bin/bash

TOP=`pwd`

BUSYBOX_DIR=$TOP/busybox-1.31.1

##################################################
# Config busybox
#-------------------------------------------------

cd $BUSYBOX_DIR

# mkdir -pv ../obj/busybox-x86
# make O=../obj/busybox-x86 defconfig
# make O=../obj/busybox-x86 menuconfig # Set: [y] Build BusyBox as a static binary (no shared libs)

# Build busybox
cd ../obj/busybox-x86
make -j8
make install
