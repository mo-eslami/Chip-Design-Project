#!/bin/sh
set -e
rm -rf waves.shm
xrun -64bit -sv -access +rwc -input run_batch_with_shm.tcl -l xrun_shm.log ../rtl/aes128_iterative.v ../tb/aes128_tb.sv -top aes128_tb
