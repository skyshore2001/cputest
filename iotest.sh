#!/bin/sh

echo "=== WRITE TEST (no buffer)"
dd if=/dev/zero of=bigfile bs=8K count=1000 oflag=direct,nonblock

echo "=== WRITE TEST (with buffer)"
dd if=/dev/zero of=bigfile bs=8K count=1000 conv=fsync

#read -p "press any key to cont..."
echo "=== READ TEST (no buffer)"
dd if=bigfile of=/dev/null bs=8k count=1000 iflag=direct,nonblock

rm bigfile
