source ../config/config.tcl
source ../scripts/common.tcl

# Area experiment.
# IMPORTANT: Genus option names can differ by release. We therefore
# use the broadly supported effort controls and test the optional
# area objective through catch(). If your release supports opt_area,
# it is enabled; otherwise the run remains a high-effort mapping run.
set OUT "../results/area"
file mkdir $OUT
setup_and_read $LIB_TT "../constraints/constraints_12ns.sdc"

set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high
set_db tns_opto false

if {[catch {set_db opt_area true} msg]} {
    puts "INFO: opt_area is not available in this Genus release: $msg"
    puts "INFO: Area comparison will rely on relaxed timing + high-effort optimization."
} else {
    puts "INFO: opt_area enabled."
}

syn_generic
syn_map
syn_opt

emit_reports "area_12ns" $OUT
exit
