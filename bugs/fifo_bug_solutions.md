# FIFO homework — detailed solutions

## Bug 1 — full off-by-one
For an 8-entry FIFO, full must correspond to eight stored entries under the chosen count/pointer convention. A count-based implementation should use `count == 8`. Test the transition from seven to eight writes and the blocked ninth write.

## Bug 2 — pointer wrap-around
A pointer must return from the last storage location to index zero. Test enough writes/reads to cross the boundary. Check both write and read pointers independently.

## Bug 3 — simultaneous read/write
When both operations are accepted in one cycle, occupancy normally remains unchanged. Handle neither/read-only/write-only/both explicitly. A test must exercise `rd_en && wr_en` with the FIFO neither empty nor full.

## Bug 4 — empty polarity
`empty` must be asserted exactly when there are zero valid entries. A simple invariant is `empty == (count == 0)` for a count-based design. Test reset, first write, and final read.

## Bug 5 — read-data timing/address
Define the FIFO interface contract first: synchronous registered read or combinational read. Then verify that `rdata` changes at the specified edge/address. A test that checks only the data value but not its timing can miss the bug.

## General method
For every FIFO bug: state the invariant, create a stimulus that can violate it, find the first failing cycle, identify the RTL statement, and rerun the complete regression after the fix.
