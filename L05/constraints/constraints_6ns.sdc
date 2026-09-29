create_clock -name clk -period 6.0 [get_ports clk]
set_clock_uncertainty 0.10 [get_clocks clk]

set_input_delay  1.0 -clock clk [get_ports {start key[*] plaintext[*]}]
set_output_delay 1.0 -clock clk [get_ports {ciphertext[*] busy done}]

# Reset is asynchronous from the point of view of the functional
# datapath in this teaching design. For a production flow, reset
# timing methodology must be defined explicitly.
set_false_path -from [get_ports rst_n]
