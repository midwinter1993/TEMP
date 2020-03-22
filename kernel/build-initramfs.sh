#!/bin/bash

TOP=`pwd`

prepare_initramfs() {
    # Create initramfs dir
    mkdir -pv $TOP/initramfs/x86-busybox
    cd $TOP/initramfs/x86-busybox
    mkdir -pv {bin,sbin,etc,proc,sys,usr/{bin,sbin}}
    cp -av $TOP/obj/busybox-x86/_install/* .

    # Create init file
    cat <<EOT >> init
#!/bin/sh

mount -t proc none /proc
mount -t sysfs none /sys
mknod -m 666 /dev/ttyS0 c 4 64

setsid  cttyhack sh
exec /bin/sh
EOT

    chmod +x init
}

compress_initramfs() {
    cd $TOP/initramfs/x86-busybox

    find . -print0 \
        | cpio --null -ov --format=newc \
        | gzip -9 > $TOP/obj/initramfs-busybox-x86.cpio.gz
}

# prepare_initramfs

compress_initramfs
