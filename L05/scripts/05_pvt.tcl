source ../config/config.tcl
source ../scripts/common.tcl

# Run TT, SS and FF using identical RTL and constraints.
# Only the characterized Liberty file changes.
foreach {tag lib} [list \
    TT $LIB_TT \
    SS $LIB_SS \
    FF $LIB_FF] {

    set OUT "../results/pvt/$tag"
    file mkdir $OUT

    puts "======================================================"
    puts "PVT RUN: $tag -> $lib"
    puts "======================================================"

    setup_and_read $lib "../constraints/constraints_10ns.sdc"

    set_db syn_generic_effort medium
    set_db syn_map_effort medium
    set_db syn_opt_effort medium

    syn_generic
    syn_map
    syn_opt

    emit_reports "pvt_$tag" $OUT

    # Each foreach iteration is a fresh Genus design setup in production
    # flows. If your release keeps database state between iterations,
    # run these three corners as separate Genus invocations instead.
}
exit
