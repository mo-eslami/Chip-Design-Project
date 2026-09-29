source ../config/config.tcl
source ../scripts/common.tcl

# Timing experiment: change ONLY the clock constraint across runs.
# Recommended: run 10 ns, 8 ns and 6 ns. The rest of the flow is identical.
set OUT "../results/timing"
file mkdir $OUT
setup_and_read $LIB_TT "../constraints/constraints_8ns.sdc"

set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high
set_db tns_opto true

syn_generic
syn_map
syn_opt

emit_reports "timing_8ns" $OUT
exit
