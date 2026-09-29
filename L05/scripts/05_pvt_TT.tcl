source ../config/config.tcl
source ../scripts/common.tcl
set OUT "../results/pvt/TT"
file mkdir $OUT
setup_and_read $LIB_TT "../constraints/constraints_10ns.sdc"
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
syn_generic
syn_map
syn_opt
emit_reports "pvt_TT" $OUT
exit
