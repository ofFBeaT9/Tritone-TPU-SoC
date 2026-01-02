# GT-LOGIC Ternary Cell Library Specification

## Overview

Multi-threshold CMOS ternary standard cells for SKY130 process (1.8V nominal).

**Project**: Balanced Ternary CMOS CPU/Accelerator  
**Technology**: SKY130 PDK (Google/SkyWater 130nm)  
**Nominal Voltage**: 1.8V  
**Temperature Range**: -40°C to 125°C  

---

## Voltage Encoding

| Logic Level | Voltage | Balanced Ternary | Binary Encoding |
|-------------|---------|------------------|-----------------|
| 0 | 0V (GND) | -1 | 10 |
| 1 | 0.9V (VDD/2) | 0 | 00 |
| 2 | 1.8V (VDD) | +1 | 01 |
| X | Invalid | Invalid | 11 |

### Voltage Thresholds

| Boundary | Voltage | Description |
|----------|---------|-------------|
| V_low_max | 0.45V | Maximum voltage for logic 0 |
| V_mid_min | 0.45V | Minimum voltage for logic 1 |
| V_mid_max | 1.35V | Maximum voltage for logic 1 |
| V_high_min | 1.35V | Minimum voltage for logic 2 |

## Power Rails

- `VDD` = 1.8V
- `VMID` = 0.9V (explicit mid-rail)
- `VSS` = 0V

Phase 1 uses a 3-rail voltage-mode approach (decode + rail select) so the mid-level is deterministic during simulation.

---

## Cell Inventory

### Priority 0: Ternary Inverters (Foundation)

| Cell | Function | Transistors | Status | Notes |
|------|----------|-------------|--------|-------|
| **STI** | Y = -A (full inversion) | 4 | ☑ Designed | Standard Ternary Inverter |
| **PTI** | Y = 2 if A<2, else 0 | 3 | ☑ Designed | Positive Threshold Inverter |
| **NTI** | Y = 2 if A=0, else 0 | 3 | ☑ Designed | Negative Threshold Inverter |

### Priority 1: Basic Logic Gates

| Cell | Function | Transistors | Status | Notes |
|------|----------|-------------|--------|-------|
| **TMIN** | Y = MIN(A,B) | 10 | ☑ Designed | Ternary AND equivalent |
| **TMAX** | Y = MAX(A,B) | 10 | ☑ Designed | Ternary OR equivalent |
| **TNAND** | Y = STI(MIN(A,B)) | 14 | ☑ Designed | TMIN + STI |
| **TNOR** | Y = STI(MAX(A,B)) | 14 | ☑ Designed | TMAX + STI |
| **TMUX3** | Y = D_S (3:1 mux) | 24 | ☑ Designed | Select from 3 inputs |

### Priority 1: Arithmetic Cells

| Cell | Function | Transistors | Status | Notes |
|------|----------|-------------|--------|-------|
| **BTHA** | Half Adder | 30 | ☑ Designed | SUM, CARRY outputs |
| **BTFA** | Full Adder | 42* | ☑ Designed | A+B+Cin, target 42T |

*Target based on Ko et al. optimized design

### Priority 2: Sequential Cells (Future)

| Cell | Function | Transistors | Status | Notes |
|------|----------|-------------|--------|-------|
| TDFF | D Flip-Flop | ~36 | ☐ Pending | Edge-triggered |
| TLATCH | Transparent Latch | ~24 | ☐ Pending | Level-sensitive |
| TSRFF | SR Flip-Flop | ~30 | ☐ Pending | Set-Reset |

---

## Cell Descriptions

### STI - Standard Ternary Inverter

**Symbol**: `Y = -A` or `Y = STI(A)`

**Truth Table**:
| Input A | Output Y |
|---------|----------|
| 0 (0V) | 2 (1.8V) |
| 1 (0.9V) | 1 (0.9V) |
| 2 (1.8V) | 0 (0V) |

**Implementation**: 
- HVT PMOS + SVT PMOS (pull-up)
- LVT NMOS + SVT NMOS (pull-down)
- Multi-Vth creates three stable regions

### PTI - Positive Ternary Inverter

**Symbol**: `Y = PTI(A)`

**Truth Table**:
| Input A | Output Y |
|---------|----------|
| 0 | 2 |
| 1 | 2 |
| 2 | 0 |

**Implementation**: Strong pull-up, weak pull-down  
**Use Case**: Detect high input, threshold at ~1.35V

### NTI - Negative Ternary Inverter

**Symbol**: `Y = NTI(A)`

**Truth Table**:
| Input A | Output Y |
|---------|----------|
| 0 | 2 |
| 1 | 0 |
| 2 | 0 |

**Implementation**: Weak pull-up, strong pull-down  
**Use Case**: Detect low input, threshold at ~0.45V

### BTFA - Balanced Ternary Full Adder

**Symbol**: `{COUT, SUM} = A + B + CIN`

**Key Properties**:
- Inputs/Outputs: Balanced ternary {-1, 0, +1}
- Range of A+B+CIN: -3 to +3
- SUM = (A+B+CIN) mod 3
- COUT = floor((A+B+CIN) / 3)

---

## Characterization Status

### Completed
- [x] Cell netlists (SPICE subcircuits)
- [x] DC testbenches
- [x] Transient testbenches
- [x] Characterization templates
- [x] Run simulations with ngspice (batch)

### Pending
- [ ] Extract timing parameters
- [ ] Monte Carlo analysis (1000 runs)
- [ ] 5-corner analysis (TT, FF, SS, SF, FS)
- [ ] Generate Liberty (.lib) file
- [ ] Generate LEF file
- [ ] DRC/LVS verification

---

## Design Rules

### Transistor Sizing Guidelines

| Device Type | Minimum W | Typical W | Purpose |
|-------------|-----------|-----------|---------|
| LVT NMOS | 400n | 500n | Fast switching, low threshold |
| SVT NMOS | 400n | 500n | Standard pull-down |
| SVT PMOS | 600n | 800n | Standard pull-up |
| HVT PMOS | 800n | 1u | Delayed switching, high threshold |

### Layout Considerations

1. **Multi-Vth Spacing**: Maintain minimum spacing between different Vth devices
2. **Well Taps**: Place substrate/well taps every 10 cells
3. **Power Rails**: VDD and VSS must support 3-level switching current
4. **Intermediate Node Capacitance**: Critical for VDD/2 stability

---

## Simulation Commands

### Run STI DC Analysis
```bash
cd project/spice/testbenches
ngspice tb_sti.spice
```

### Run Inverter Comparison
```bash
ngspice tb_inverters.spice
```

### Run Characterization
```bash
ngspice characterize_sti.spice
```

### Run Monte Carlo
```bash
ngspice monte_carlo_sti.spice
```

---

## References

1. Mouftah, H.T. and Jordan, I.B., "Design of Ternary COS/MOS Memory and Sequential Circuits", IEEE Trans. Computers, 1977
2. Ko, U. and Balsara, P.T., "High-Performance Energy-Efficient D-Flip-Flop Circuits", IEEE TCAS-II, 2000
3. SkyWater SKY130 PDK Documentation: https://skywater-pdk.readthedocs.io/

---

*Document Version: 1.0*  
*Last Updated: Phase 1, Week 2-4*
