if {[file exists work]} {vdel -lib work -all}
vlib work
vmap work work
vlog ../rtl/aes128_iterative.v
vlog -sv ../tb/aes128_tb.sv
vsim -voptargs=+acc work.aes128_tb
add wave sim:/aes128_tb/clk sim:/aes128_tb/rst_n sim:/aes128_tb/start sim:/aes128_tb/busy sim:/aes128_tb/done sim:/aes128_tb/key sim:/aes128_tb/plaintext sim:/aes128_tb/ciphertext
add wave sim:/aes128_tb/dut/round sim:/aes128_tb/dut/state sim:/aes128_tb/dut/round_key
run -all
wave zoom full
