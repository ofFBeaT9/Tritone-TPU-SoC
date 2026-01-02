# VMID Generation for Tritone FPGA Implementation

## Overview

Tritone's 3-rail ternary CMOS cells require three supply voltages:
- **VDD** = 1.8V (logic high)
- **VMID** = 0.9V (intermediate level for ternary state)
- **VSS** = 0V (ground)

Since standard FPGAs and development boards only provide VDD and VSS, VMID must be generated externally on the PCB.

---

## Option 1: LDO Regulator (Recommended)

**Best for:** Prototyping, development boards, production systems

### Circuit Design

```
VDD (1.8V) ──┬── C1 ──┬── VIN ─────────┐
             │  100nF │                │
            GND      GND         ┌─────┴─────┐
                                 │   LDO     │
                                 │  1.8V→0.9V │
                                 │           │
                                 │  VOUT ────┼── VMID (0.9V)
                                 │           │
                                 └─────┬─────┘
                                       │
                              C2 ──────┼── C3
                             10µF     100nF
                                       │
                                      GND
```

### Recommended LDO ICs

| Part Number | Manufacturer | Dropout | Current | Package | Notes |
|-------------|--------------|---------|---------|---------|-------|
| **TPS73018** | TI | 75mV | 150mA | SOT-23 | Low noise, ultra-low dropout |
| **ADP151** | ADI | 85mV | 200mA | LFCSP-4 | 9µVrms noise |
| **MIC5365** | Microchip | 160mV | 150mA | SOT-23 | Low cost |
| **LP2985** | TI | 280mV | 150mA | SOT-23 | Fixed 0.9V option |

### Design Considerations

1. **Output Voltage Accuracy**: Target ±50mV (0.85V - 0.95V)
   - Use LDO with ±1% accuracy
   - Or adjustable LDO with precision resistors

2. **Current Requirement**: Estimate ~10% of VDD current
   - For 50mW Tritone CPU @ 1.8V: I_VDD ≈ 28mA
   - VMID current: ~3-5mA typical
   - Choose LDO with 50mA+ headroom

3. **Bypass Capacitors**:
   - Input: 100nF ceramic (close to LDO)
   - Output: 10µF ceramic + 100nF ceramic
   - Low ESR capacitors for stability

4. **PCB Layout**:
   - Place LDO close to FPGA VMID pins
   - Short, wide traces for VMID distribution
   - Separate ground plane from high-speed digital

---

## Option 2: Resistive Divider with Buffer

**Best for:** Quick prototyping, low current applications

### Circuit Design

```
VDD (1.8V) ──┬── R1 ──┬── (+) ─────────┐
             │  10kΩ  │                │
            GND       │          ┌─────┴─────┐
                      │          │  Op-Amp   │
                     ─┴─         │  Buffer   │
                     ─┬─         │           │
                      │ R2       │  OUT ─────┼── VMID (0.9V)
                      │ 10kΩ     │           │
                      │          │  (-) ─────┘
                     GND         │
                                GND
```

### Op-Amp Selection

| Part Number | Manufacturer | GBW | Slew Rate | Rail-to-Rail | Package |
|-------------|--------------|-----|-----------|--------------|---------|
| **MCP6001** | Microchip | 1MHz | 0.6V/µs | Yes | SOT-23 |
| **LMV321** | TI | 1MHz | 1V/µs | Yes | SOT-23 |
| **OPA340** | TI | 5.5MHz | 6V/µs | Yes | SOT-23 |

### Voltage Calculation

```
VMID = VDD × R2 / (R1 + R2) = 1.8V × 10k / 20k = 0.9V
```

For better accuracy, use 0.1% tolerance resistors.

### Limitations

- Higher power consumption in resistor divider (~90µW)
- Op-amp output current limited (typically 20-50mA)
- Temperature drift in resistors affects VMID accuracy

---

## Option 3: Precision Voltage Reference

**Best for:** High-accuracy applications, temperature-critical designs

### Using REF5010 (1.0V Reference)

```
VDD (3.3V) ──┬── C1 ──┬── VIN ─────────┐
             │ 100nF  │                │
            GND      GND         ┌─────┴─────┐
                                 │  REF5010  │
                                 │  1.0V Ref │
                                 │           │
                                 │  VOUT ────┼── Divide to 0.9V
                                 │           │
                                 └─────┬─────┘
                                       │
                                      GND
```

Note: 1.0V reference requires external divider to get 0.9V (R1=1k, R2=9k gives 0.9V).

---

## PCB Design Guidelines

### Power Distribution

1. **VMID Plane**: Consider a small VMID plane or thick trace for low IR drop
2. **Via Stitching**: Use vias to connect VMID layer to LDO output
3. **Decoupling**: Place 100nF caps at each VMID connection point

### Routing

```
Recommended trace widths (1oz copper):
- VDD main: 20-30 mil
- VSS main: 20-30 mil
- VMID main: 15-20 mil (lower current)
- VMID branches: 10 mil minimum
```

### Thermal Considerations

- LDO power dissipation: P = (VIN - VOUT) × IOUT
- For 1.8V→0.9V @ 50mA: P = 0.9V × 50mA = 45mW
- Ensure adequate thermal relief

---

## FPGA Pin Mapping

### Nexys A7 / Artix-7 Example

```tcl
# In ternary_cpu_system.xdc:

# VMID should be connected to a PMOD or custom header
# Example: Use PMOD JA pin 4 for VMID connection to test point

# IMPORTANT: VMID is an analog voltage, not a digital I/O
# It must be routed externally to the 3-rail cells

# For simulation/emulation, VMID generation is internal
# For physical implementation, route VMID from external regulator
```

### Test Points

Add test points for debugging:
- TP1: VMID voltage (for multimeter verification)
- TP2: VMID current sense (optional, via shunt resistor)

---

## Validation Checklist

- [ ] VMID voltage within 0.85V - 0.95V at all load conditions
- [ ] VMID ripple < 10mV peak-to-peak
- [ ] VMID temperature stability: ±50mV over -40°C to +85°C
- [ ] LDO thermal: junction temperature < 100°C at max load
- [ ] Bypass capacitors placed within 5mm of LDO pins
- [ ] VMID traces sized for expected current with margin

---

## Bill of Materials (BOM)

### Option 1: LDO Solution

| Qty | Part | Value | Package | Description |
|-----|------|-------|---------|-------------|
| 1 | U1 | TPS73018 | SOT-23 | 0.9V 150mA LDO |
| 1 | C1 | 100nF | 0402 | Input bypass |
| 1 | C2 | 10µF | 0603 | Output bulk |
| 1 | C3 | 100nF | 0402 | Output HF bypass |

### Option 2: Op-Amp Buffer

| Qty | Part | Value | Package | Description |
|-----|------|-------|---------|-------------|
| 1 | U1 | MCP6001 | SOT-23 | Rail-to-rail op-amp |
| 2 | R1, R2 | 10kΩ 0.1% | 0402 | Voltage divider |
| 2 | C1, C2 | 100nF | 0402 | Bypass capacitors |

---

## References

- TPS73018 Datasheet: [TI TPS730xx](https://www.ti.com/product/TPS73018)
- MCP6001 Datasheet: [Microchip MCP6001](https://www.microchip.com/MCP6001)
- Tritone Roadmap Section 6.1: Temperature Compensation
- SKY130 PDK VMID requirements: 0.9V ±50mV

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-26 | BMad Master | Initial release |
