# ============================================================
# Lecture 05 / Genus configuration
# Edit ONLY this file for your local SKY130 installation.
# ============================================================

set DESIGN aes128_iterative

# RTL
set RTL_DIR "../rtl"
set RTL_FILES [list "$RTL_DIR/aes128_iterative.v"]

# Liberty: point these to the exact files in your working SKY130 setup.
# Default example uses TT. Change the path, not the filename, as needed.
set LIB_DIR "/PATH/TO/YOUR/SKY130/LIBS"
set LIB_TT "$LIB_DIR/sky130_tt_1.8_25_nldm.lib"
set LIB_SS "$LIB_DIR/sky130_ss_1.62_125_nldm.lib"
set LIB_FF "$LIB_DIR/sky130_ff_1.98_0_nldm.lib"

# Optional physical abstracts. Not required for this logical-synthesis lecture.
# Leave empty if your Genus setup is logical-only.
set LEF_FILES {}

# Search paths
set_db init_hdl_search_path [list $RTL_DIR]
set_db init_lib_search_path [list $LIB_DIR]

# -------------------------
# Common constraints
# -------------------------
set CLOCK_PORT clk
set CLOCK_PERIOD 10.0
set INPUT_DELAY  1.0
set OUTPUT_DELAY 1.0

# We intentionally keep reset simple for this lecture.
# Do not false-path start/data ports: they are functional inputs.
