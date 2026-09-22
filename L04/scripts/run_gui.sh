#!/bin/sh
set -e
xrun -64bit -sv -access +rwc -gui ../rtl/aes128_iterative.v ../tb/aes128_tb.sv -top aes128_tb
