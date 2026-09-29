source ../config/config.tcl
source ../scripts/common.tcl
set OUT "../results/pvt/FF"
file mkdir $OUT
setup_and_read $LIB_FF "../constraints/constraints_10ns.sdc"
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
syn_generic
syn_map
syn_opt
emit_reports "pvt_FF" $OUT
exit
