#!/bin/bash

# prereq: source build/envsetup.sh

f=$(find -name '*-ramdisk' | sed -e 's,./,,' | sed -e 's/.img-ramdisk//')
lz4 -d "$f.img-ramdisk" ramdisk.cpio

mkdir "${f}_ramdisk"
cd "${f}_ramdisk" || exit
cpio -idmv < ../ramdisk.cpio
rm -rf ../ramdisk.cpio ../${f}.img-ramdisk
