# Common flow fragment. Sourced by experiment scripts.
# This package intentionally uses the widely supported Common UI sequence:
#   read HDL -> elaborate -> read SDC -> syn_generic -> syn_map -> syn_opt
# See Cadence references and the lecture notes for version-specific options.

proc setup_and_read {lib_file sdc_file} {
    global DESIGN RTL_FILES
    set_db / .library [list $lib_file]
    read_hdl -language v2001 $RTL_FILES
    elaborate $DESIGN
    check_design -unresolved
    read_sdc $sdc_file
    check_timing
}

proc emit_reports {tag outdir} {
    global DESIGN
    file mkdir $outdir
    report_qor    > "$outdir/${tag}_qor.rpt"
    report_area   > "$outdir/${tag}_area.rpt"
    report_gates  > "$outdir/${tag}_gates.rpt"
    report_timing -nworst 10 > "$outdir/${tag}_timing.rpt"
    report_power  > "$outdir/${tag}_power.rpt"
    write_hdl > "$outdir/${tag}_mapped.v"
    write_sdc > "$outdir/${tag}.sdc"
    write_db "$outdir/${tag}.db"
}
