#!/usr/bin/env bash
set -euo pipefail
LIB="${1:?Usage: ./inspect_liberty.sh /path/to/file.lib}"
echo "=== library declarations ==="
grep -nE '^[[:space:]]*library\(' "$LIB" | head
echo
echo "=== first cell declarations ==="
grep -nE '^[[:space:]]*cell\(' "$LIB" | head -20
echo
echo "=== area examples ==="
grep -nE '^[[:space:]]*area[[:space:]]*:' "$LIB" | head -20
echo
echo "=== timing blocks ==="
grep -nE '^[[:space:]]*timing\(' "$LIB" | head -20
echo
echo "=== pin direction/capacitance examples ==="
grep -nE 'direction[[:space:]]*:|capacitance[[:space:]]*:' "$LIB" | head -30
