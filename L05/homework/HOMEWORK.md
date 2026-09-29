# Homework — Lecture 05: Logical Synthesis

## Part A — PPA experiment

Using the supplied AES-128 iterative design, perform:

1. baseline at 10 ns
2. timing-oriented run at 8 ns
3. timing-oriented run at 6 ns
4. area-oriented run at 12 ns
5. power-oriented run at 10 ns

Fill:

| Run | Clock | Area | WNS | TNS | Cell count | Power |
|---|---:|---:|---:|---:|---:|---:|
| Baseline | 10 ns | | | | | |
| Timing-8 | 8 ns | | | | | |
| Timing-6 | 6 ns | | | | | |
| Area | 12 ns | | | | | |
| Power | 10 ns | | | | | |

## Part B — Netlist evidence

For the baseline and timing-8 runs:

1. list five standard-cell types that changed in count;
2. identify at least one critical-path cell whose drive strength changed, if applicable;
3. identify whether buffer/inverter usage changed;
4. show two short excerpts from the mapped Verilog as evidence.

## Part C — PVT

Compare TT, SS and FF.

Explain:

1. why voltage changes delay;
2. why temperature changes delay;
3. why setup and hold are usually stressed at different corners;
4. why TT cannot represent all signoff conditions.

## Part D — Liberty

From the TT Liberty file, provide:

- one cell name
- its area
- one input pin
- its capacitance
- one timing arc
- one cell-rise/cell-fall lookup table

Then answer:

> How does synthesis know that cell A is faster or slower than cell B?

## Part E — Conceptual

Answer in 3–5 sentences each:

1. Why can reducing area hurt timing?
2. Why can reducing area fail to reduce power?
3. Why can two libraries implementing the same RTL produce different netlists?
4. What is the difference between a Liberty file and a LEF file?
5. Why is a mapped netlist not yet a GDS layout?

## Submission

Submit:

```text
report.pdf
results/
  baseline/
  timing/
  area/
  power/
  pvt/
```

Your report must contain at least one plot or table generated from your own synthesis results.
