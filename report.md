# 4-bit Unsigned Array Multiplier — RTL to GDSII

## Team Members
- Mounika Mylavarapu — 2024102006
- Malige Haritha — 2024102080

## RTL and Gate-Level Simulation
Both RTL simulation and gate-level simulation passed all 256 input combinations with zero errors.

## Synthesis Results
| Metric | Result |
|---|---:|
| Mapped cells | 73 |
| Total cell area | 805.7728 µm² |
| Flip-flops | 16 |
| Flip-flop area | 400.384 µm² |
| Sequential area percentage | 49.69% |

## Static Timing Analysis

The synthesis-level static timing analysis (STA) was evaluated using the saved timing reports.

| Metric | Result |
|---|---:|
| Data arrival time | Approximately 2.46 ns |
| Worst negative slack (WNS), 10 ns constraint | +7.30 ns |
| Total negative slack (TNS), 10 ns constraint | 0 ns |
| Estimated minimum clock period | 2.70 ns |
| Estimated maximum frequency | 370.37 MHz |
| Slack at 2.70 ns constraint | Approximately 0 ns |

The reported critical register-to-register path starts at flip-flop \`_118_\` and ends at flip-flop \`_112_\`. The path contains eight combinational cells between the launching and capturing flip-flops: \`_083_\` (and2_0), \`_055_\` (or3_1), \`_059_\` (and4_1), \`_070_\` (o2111a_1), \`_076_\` (o21ai_0), \`_090_\` (xnor3_1), \`_091_\` (maj3_1), and \`_092_\` (xor3_1). The launch and capture cells are \`dfrtp_1\` flip-flops.

These are synthesis-level timing results. They must be distinguished from the post-route physical-design timing results reported below.

## Physical Design

The selected physical-design run is \`mult_array_7ns_fixed\`, using a 7.0 ns clock period in its final SDC constraints. The run completed, and the final reports show positive setup slack, zero TNS, and no reported final DRC, LVS, or antenna violations.

| Metric | Selected run result |
|---|---:|
| Run | \`mult_array_7ns_fixed\` |
| Clock period | 7.0 ns |
| Worst-corner setup slack (WNS) | +0.7505 ns |
| Total negative slack (TNS) | 0 ns |
| Total instance count | 1892 |
| Standard-cell count | 333 |
| Total instance area | 17759.5 µm² |
| Standard-cell area | 1218.67 µm² |
| Routed wirelength | 2334 tool-reported units |
| Final design violations | 0 |
| Magic DRC errors | 0 |
| KLayout DRC errors | 0 |
| LVS errors | 0 |
| Antenna violations | 0 |
| Timing status | Pass at 7.0 ns |

The total instance area includes physical-only cells such as fill and tap cells; it should not be compared directly with the synthesis mapped-cell area. The final physical-design run passed at 7.0 ns, but the required 3.5 ns target was not met in the tested runs. Formal equivalence checking (EQY) was skipped by the flow configuration and is not claimed as passed.

## PnR Clock-Period Comparison

The following table compares completed runs using the clock periods recorded in their final SDC files. Negative slack indicates setup timing violations.

| Run | Clock Period (ns) | WNS (ns) | TNS (ns) | Timing |
|---|---:|---:|---:|---|
| mult_array_4ns | 3.5 | -1.764 | -5.126 | Fail |
| mult_array_4p5ns | 3.5 | -1.764 | -5.126 | Fail |
| mult_array_4p5ns_fixed | 4.5 | -0.711 | -1.400 | Fail |
| mult_array_5ns | 5.0 | -0.211 | -0.234 | Fail |
| mult_array_5p5ns | 5.5 | -0.114 | -0.114 | Fail |
| mult_array_6ns | 6.0 | -0.250 | -0.317 | Fail |
| mult_array_7ns | 6.0 | -0.250 | -0.317 | Fail |
| mult_array_7ns_fixed | 7.0 | +0.750 | 0 | Pass |
| mult_array_10ns_abs | 10.0 | +3.750 | 0 | Pass |

The selected final physical-design run is mult_array_7ns_fixed. Its worst-corner setup slack is +0.7505 ns and TNS is zero, with zero reported DRC, LVS, and antenna violations. Using Fmax = 1000/(CLOCK_PERIOD − setup slack), the post-route Fmax is approximately 160.01 MHz. The Part C estimate is 370.37 MHz. The assignment's 3.5 ns target was not met in the tested runs. Run names do not always match their actual SDC clock periods, so the recorded SDC constraints were used for this comparison.

## Physical Layout

### Full Die Layout

![Full die layout](full_die.png)

### Zoomed Routing

![Zoomed routing layout](zoomed_routing.png)


## Simulation Waveform

The waveform was generated from a separate testbench copy using a 3.5 ns clock period. It shows the input operands, clock, active-low reset, and registered product output. For the highlighted example, A = 5 (0101) and B = 7 (0111), so the expected product is 35 (00100011 in binary, or 0x23 in hexadecimal). The waveform shows P = 35 for these operands after the registered datapath latency.

The testbench completed all 256 input combinations with zero errors at this simulation clock period. This demonstrates functional simulation correctness; it does not establish that the placed-and-routed design meets the 3.5 ns timing target. The selected physical-design run passed at 7.0 ns, while the 3.5 ns physical-design attempt failed setup timing.

![GTKWave simulation waveform](waveform.png)

## Worked Multiplication Example



Using Haritha's roll number (2024102080):



- Last digit = 0

- A = 0 + 5 = 5

- B = 7



In 4-bit binary:



A = 0101

B = 0111



Partial products:



```text

      0101

×     0111

------------

      0101

     0101

    0101

------------

    00100011

```



Therefore, 5 × 7 = 35, and the expected 8-bit product is `00100011`.

## Fault-Injection Test



A separate faulty full-adder copy was created by changing the sum equation from `a^b^cin` to `a^b`, thereby ignoring the carry-in.



- Input combinations checked: 256

- Mismatches detected: 95

- Testbench result: FAIL, as expected for the injected fault.

- Example: for a=3 and b=3, expected product = 9, faulty output = 5.



The fault was successfully detected. The original `rtl/full_adder.v` was not modified.

## Multiplier Block Diagram



```text

a[3:0], b[3:0]

       |

       v

Input Registers (a_reg, b_reg)

       |

       v

Partial Products (16 AND gates)

       |

       v

Array of Full Adders (12 full adders)

       |

       v

Output Register (p[7:0])

       ^

       |

clk and active-low reset rst_n

```

## Timing and Throughput Calculations



- Estimated minimum clock period: 2.70 ns

- Maximum frequency: 1000 / 2.70 = 370.37 MHz

- Two-cycle latency: 2 × 2.70 = 5.40 ns

- Throughput: 1000 / (2 × 2.70) = 185.19 million results/s



These values are derived from the saved synthesis-level STA reports. The selected physical-design run uses a separate 7 ns clock period, with a worst-corner setup slack of +0.7505 ns.

## Discussion Questions



### 1. Why does the synthesis cell count differ from 16 AND gates plus 12 full adders?



The 16 AND gates generate the partial products, and the 12 full adders combine them. Synthesis maps this logic into cells from the target standard-cell library. Each full adder may require multiple library cells, and logic optimization can change the implementation. Therefore, the mapped-cell count is not simply 16 + 12. The reported mapped-cell count is 73.



### 2. How does the critical path relate to the full-adder array?



The critical path is a register-to-register path from flip-flop _118_ to flip-flop _112_. The saved 10 ns STA report gives a data arrival time of 2.46 ns and slack of +7.30 ns. The path contains eight combinational cells: _083_ (and2_0), _055_ (or3_1), _059_ (and4_1), _070_ (o2111a_1), _076_ (o21ai_0), _090_ (xnor3_1), _091_ (maj3_1), and _092_ (xor3_1), between the launching and capturing dfrtp_1 flip-flops. The path delay depends on mapped logic, cell delays, loading, and interconnect.

### 3. What percentage of synthesis area is occupied by flip-flops?



The 16 flip-flops occupy 400.384 µm² out of a total mapped cell area of 805.7728 µm².



Sequential area percentage = (400.384 / 805.7728) × 100 = 49.69%.



Thus, approximately half of the mapped synthesis area is occupied by flip-flops.



### 4. Why can post-route timing differ from synthesis timing, and why are extra cells added?



Synthesis maps the logic to standard cells, while physical design adds placement and routed-wire parasitics, which affect delay. In the selected final run, the reported physical-design cell classes include 17 timing-repair buffers, 4 clock buffers, 245 tap cells, and 1559 fill cells. The final design also contains 16 sequential cells, 48 multi-input combinational cells, and 3 inverters. These are final-run cell-class counts, not a claim that every cell was newly added after synthesis.



The selected 7 ns physical-design run reported +0.7505 ns worst-corner setup slack. The 3.5 ns attempt did not pass setup timing, so the passing 7 ns result must not be presented as proof that the tighter target was met.

### 5. What do DRC and LVS check?



Design Rule Check (DRC) verifies that the physical layout follows the process design rules, including geometric width and spacing requirements. Layout Versus Schematic (LVS) verifies that the circuit extracted from the layout matches the intended circuit in devices and connectivity.



The selected 7 ns physical-design run reported zero final Magic DRC errors, zero KLayout DRC errors, and zero LVS errors.



### 6. How does an 8-bit array multiplier compare with a 4-bit multiplier?



For a conventional unsigned array multiplier of width N, the partial-product AND-gate count is N² and the full-adder count is N(N−1).



- For N = 4: 16 partial-product AND gates and 12 full adders.

- For N = 8: 64 partial-product AND gates and 56 full adders.



The 8-bit multiplier needs substantially more hardware. Its delay cannot be determined exactly by simply doubling the measured 4-bit delay; the actual critical path depends on the architecture, cell mapping, loading, and routing.
