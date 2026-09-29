source ../config/config.tcl
source ../scripts/common.tcl

# Power experiment.
# Power optimization is most meaningful with realistic switching activity.
# This run enables commonly used power-effort attributes when available,
# while deliberately using catch() so a release with different attributes
# does not fail before producing a baseline report.
set OUT "../results/power"
file mkdir $OUT
setup_and_read $LIB_TT "../constraints/constraints_10ns.sdc"

set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high

if {[catch {set_db leakage_power_effort high} msg]} {
    puts "INFO: leakage_power_effort unavailable: $msg"
} else {
    puts "INFO: leakage_power_effort=high"
}
if {[catch {set_db dynamic_power_effort high} msg]} {
    puts "INFO: dynamic_power_effort unavailable: $msg"
} else {
    puts "INFO: dynamic_power_effort=high"
}
if {[catch {set_db opt_power true} msg]} {
    puts "INFO: opt_power unavailable: $msg"
} else {
    puts "INFO: opt_power enabled."
}

syn_generic
syn_map
syn_opt

emit_reports "power" $OUT
exit
