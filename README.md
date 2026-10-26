# 4-bit Array Multiplier — RTL to GDSII Using SKY130

A Verilog implementation of a 4-bit unsigned array multiplier, synthesized and implemented using an open-source RTL-to-GDSII flow with the SKY130 process design kit (PDK).

## Team Members
- **Mounika Mylavarapu** — Roll Number: 2024102006
- **Malige Haritha** — Roll Number: 2024102080

## Project Overview
This project implements a 4-bit unsigned array multiplier. It takes two 4-bit inputs, `a` and `b`, and produces an 8-bit product, `p`.
The design uses partial-product generation and addition to implement multiplication. It includes sequential logic (16 flip-flops), combinational multiplier logic, and an active-low reset.

### Design Specifications
| Parameter | Description |
|---|---|
| Design | 4-bit unsigned array multiplier |
| Input A | `a[3:0]` |
| Input B | `b[3:0]` |
| Output | `p[7:0]` |
| Clock | `clk` |
| Reset | Active-low `rst_n` |
| RTL language | Verilog HDL |
| Target technology | SKY130 |
| Synthesis | Yosys |
| Static timing analysis | OpenSTA |
| Physical design | LibreLane |

## Repository Structure
```
RTL-to-GDS-Multiplier/
├── pnr/
│   ├── runs/
│   │   ├── 4ns_final/
│   │   ├── 4p5_final/
│   │   ├── 5ns_final/
│   │   ├── 5p5_final/
│   │   ├── 6_final/
│   │   ├── final/
│   │   └── .gitkeep
│   ├── .gitkeep
│   ├── config.json
│   ├── metrics.json
│   └── mult_array.gds
├── report/
│   └── report.pdf
├── rtl/
│   ├── full_adder.v
│   ├── full_adder_faulty.v
│   └── mult_array.v
├── sta/
│   ├── constraints.sdc
│   ├── constraints_10ns.sdc
│   ├── constraints_10ns_pnr.sdc
│   ├── constraints_7ns.sdc
│   ├── mult_array_timing.rpt
│   ├── mult_array_timing_2p70ns.rpt
│   ├── run_sta.tcl
│   └── sta.tcl
├── synth/
│   ├── mult_array_netlist.v
│   ├── mult_array_stat.rpt
│   ├── mult_array_synth.v
│   ├── synth.log
│   ├── synth.tcl
│   └── synth.ys
├── tb/
│   └── tb_mult.v
├── report.md
└── README.md
```

## Tools and Technologies
- **Verilog HDL** — RTL design.
- **Icarus Verilog** — RTL and gate-level simulation.
- **Yosys** — logic synthesis and standard-cell mapping.
- **OpenSTA** — static timing analysis.
- **LibreLane** — physical-design implementation.
- **SKY130 PDK** — standard-cell technology.
- **Magic** — design-rule checking.
- **KLayout** — layout inspection and design-rule checking.
- **Netgen** — layout-versus-schematic verification.
- **GTKWave** — waveform visualization.

## 1. RTL Design and Functional Verification
The RTL source files are located in the `rtl/` directory.
| File | Description |
|---|---|
| `rtl/mult_array.v` | Top-level multiplier design |
| `rtl/full_adder.v` | Full-adder implementation |
| `rtl/full_adder_faulty.v` | Faulty full-adder implementation used for fault testing |
| `tb/tb_mult.v` | Multiplier testbench |
The testbench checks the multiplier's output against the expected product for all 256 combinations of the two 4-bit inputs.

### RTL Simulation
Run the following commands from the repository root in an environment with Icarus Verilog installed:

```bash
iverilog -g2012 -o sim \
    tb/tb_mult.v \
    rtl/full_adder.v \
    rtl/mult_array.v
vvp sim
```
If the testbench generates a VCD waveform file, inspect it using:
```bash
gtkwave mult.vcd
```
**Result:** PASS — 256 test vectors checked, 0 errors.

### Fault Testing
`rtl/full_adder_faulty.v` contains a full adder with an intentionally incorrect arithmetic function. It is used to show how an error in a single arithmetic block propagates to the multiplier output.
When the faulty full adder replaces the correct one, the testbench reports **95 mismatches out of 256** input combinations, confirming that the testbench detects arithmetic errors.
The correct and faulty implementations are tested separately. The faulty module is not part of the synthesized design.

## 2. Logic Synthesis Using Yosys
Yosys is used to synthesize the RTL and map the design to SKY130 standard cells.
The synthesis-related files are stored in `synth/`.

| File | Purpose |
|---|---|
| `synth/synth.tcl` | Synthesis script |
| `synth/synth.ys` | Yosys synthesis commands |
| `synth/mult_array_netlist.v` | Mapped netlist |
| `synth/mult_array_synth.v` | Synthesized Verilog representation |
| `synth/mult_array_stat.rpt` | Synthesis statistics |
| `synth/synth.log` | Synthesis log |

### Run Synthesis
```bash
yosys -c synth/synth.tcl
```
### Synthesis Results
| Metric | Result |
|---|---:|
| Total mapped cells | 73 |
| Flip-flops | 16 |
| Total synthesized cell area | 805.7728 µm² |

## 3. Gate-Level Simulation
Gate-level simulation checks the functionality of the synthesized design using the mapped netlist and the SKY130 standard-cell models.
The synthesized netlist is available at:
```
synth/mult_array_netlist.v
```
**Result:** PASS — all 256 input combinations verified, 0 errors.

The SKY130 model paths and simulation defines depend on the installed PDK environment.

## 4. Static Timing Analysis

Static timing analysis is performed using OpenSTA. The timing scripts and constraints are located in `sta/`.

| File | Description |
|---|---|
| `sta/sta.tcl` | Static timing analysis script |
| `sta/run_sta.tcl` | STA run script |
| `sta/constraints.sdc` | Timing constraints |
| `sta/constraints_10ns.sdc` | Constraints for 10 ns analysis |
| `sta/constraints_10ns_pnr.sdc` | PnR-related 10 ns constraints |
| `sta/constraints_7ns.sdc` | Constraints for 7 ns analysis |
| `sta/mult_array_timing.rpt` | Timing report |
| `sta/mult_array_timing_2p70ns.rpt` | Timing report for a tighter clock constraint |

### Synthesis-Level Timing

| Metric | Result |
|---|---:|
| Clock period for initial analysis | 10 ns |
| Worst slack at 10 ns | Approximately +7.30 ns |
| Estimated minimum clock period | Approximately 2.70 ns |
| Estimated maximum frequency | Approximately 370.37 MHz |

The minimum clock period and maximum frequency are estimates from synthesis-level timing analysis. They do not represent the frequency achievable after physical implementation, where clock tree, wire parasitics, and routing add delay.

## 5. Place and Route
Physical implementation is performed using LibreLane and the SKY130 PDK.
The `pnr/` directory contains the physical-design configuration, run directories, metrics, and final GDSII layout.

| File or directory | Description |
|---|---|
| `pnr/config.json` | Physical-design configuration |
| `pnr/metrics.json` | Implementation metrics |
| `pnr/mult_array.gds` | Final GDSII layout |
| `pnr/runs/` | Physical-design run directories |

### Timing Experiments

Several clock-period targets were explored during physical implementation (4 ns, 4.5 ns, 5 ns, 5.5 ns, 6 ns, and 7 ns). The tighter targets did not achieve setup timing closure. The 7 ns run closed timing with positive setup slack and was selected as the final implementation.

### Final Physical-Design Results

The selected final implementation is `mult_array_7ns_fixed` (7 ns clock period).
| Metric | Result |
|---|---:|
| Clock period | 7.0 ns |
| Worst setup slack | +0.7505 ns |
| Total negative slack | 0 ns |
| Total instances | 1892 |
| Standard-cell count | 333 |
| Total instance area | 17759.5 µm² |
| Standard-cell area | 1218.67 µm² |
| Routed wirelength | 2334 (tool-reported units) |
| Magic DRC violations | 0 |
| KLayout DRC violations | 0 |
| LVS violations | 0 |
| Antenna violations | 0 |

The total instance count is higher than the standard-cell count because it also includes physical-only cells (such as tap and fill cells) inserted during physical design.

## 6. Physical Verification
The final layout was checked for design-rule and connectivity issues:
- **Magic DRC:** 0 violations.
- **KLayout DRC:** 0 violations.
- **LVS (Netgen):** 0 violations.
- **Antenna checks:** 0 violations.

## 7. Project Reports and Deliverables
- `report/report.pdf` — Final PDF report.
- `report.md` — Markdown report.
- `pnr/mult_array.gds` — Final GDSII layout.

The reports document the design, functional verification, synthesis, static timing analysis, physical-design implementation, and assignment discussion questions.

## Conclusion
This project demonstrates the complete RTL-to-GDSII flow for a 4-bit unsigned array multiplier using Verilog and the SKY130 PDK. The design was functionally verified at RTL and gate level, synthesized with Yosys, analyzed with OpenSTA, and implemented with LibreLane. The final 7 ns implementation achieves positive setup slack and passes DRC, LVS, and antenna checks with no violations.
