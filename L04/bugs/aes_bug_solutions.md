# Detailed homework solutions

## Bug 01 — Missing MixColumns
First divergence: first regular round. Cause: `aes_round()` omits `mix_columns`. Fix: restore `t = mix_columns(t);`.

## Bug 02 — MixColumns in final round
First divergence: final round. Rounds 1–9 can match. Cause: final AES round must omit MixColumns. Fix: remove it from `aes_final_round()`.

## Bug 03 — Early final-round control
First divergence: round counter/control. `round < 9` ends regular-round processing one cycle early. Fix: `round < 10`.

## Bug 04 — Wrong ShiftRows
First divergence: first round state. Cause: row-1 byte permutation is wrong. Fix: row 1 must rotate left by one byte.

## Bug 05 — Wrong Rcon
First divergence: when the affected round key is consumed. Round-9 Rcon is `8'h1b`, not `8'h1a`. Fix the constant.

## Bug 06 — Start accepted while busy
The current transaction can be overwritten/restarted. Fix the acceptance condition to `start && !busy`. This is a protocol bug even if the KAT sometimes still passes.

## Bug 07 — Done stuck high
`done` must be a one-cycle pulse. Clear it every active clock and assert it only on completion.

## Bug 08 — Busy deasserted too early
`busy` must remain asserted until the transaction has completed according to the interface contract. Fix the sequencing so the final result and status transition occur consistently.

## Bug 09 — Round-key mismatch
The round must use the newly generated round key for that round. Using the previous key causes the state to diverge at the first affected round. Fix by using `next_round_key(round_key, round)` consistently.

## Verification extension
Use the second vector exactly as supplied. Check `start` while busy does not corrupt the current transaction. Check `done` is `0,1,0` around completion. Measure latency from the accepted start edge to the done edge from the waveform/RTL rather than guessing.
