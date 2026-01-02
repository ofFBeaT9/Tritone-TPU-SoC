# Tritone SoC Physical Timing Results

**Date:** January 2, 2026
**Design:** Tritone SoC v1 (CPU + TPU stub)
**Tool:** OpenROAD Flow Scripts 24Q3
**RTL Modules:** 45 SystemVerilog files

---

## Executive Summary

| PDK | Target | Achieved Fmax | Status |
|-----|--------|---------------|--------|
| **ASAP7 7nm** | 1.0 GHz | **1.154 GHz** | TIMING MET |
| **ASAP7 7nm** | 1.5 GHz | **1.858 GHz** | TIMING MET |
| ASAP7 7nm | 2.0 GHz | OOM @ synthesis | Full TPU needs 16+ GB |
| Sky130 130nm | 150 MHz | Hold violations | Needs optimization |
| Sky130 130nm | 200 MHz | Not run | Pending |

---

## ASAP7 7nm Results

### 1 GHz Baseline (COMPLETED - TIMING MET)

| Metric | Value | Notes |
|--------|-------|-------|
| **Target Clock** | 1000 ps (1.0 GHz) | Baseline target |
| **Achieved Fmax** | **1153.7 MHz** | 15.4% margin |
| **Setup WNS** | +133.2 ps | Positive = met |
| **Hold WNS** | +10.1 ps | Positive = met |
| **Setup TNS** | 0 ps | No violations |
| **Hold TNS** | 0 ps | No violations |
| **Clock Skew (setup)** | 38.9 ps | Well controlled |
| **Clock Skew (hold)** | 41.7 ps | Well controlled |

#### Area and Utilization
| Metric | Value |
|--------|-------|
| Die Area | 766 um² |
| Core Area | 461 um² |
| Standard Cells | 1,870 |
| Total Instances | 4,164 (incl. fill/tap) |
| Utilization | 51.6% |

#### Power Analysis
| Component | Power |
|-----------|-------|
| Internal Power | 400.0 uW |
| Switching Power | 146.2 uW |
| Leakage Power | 0.18 uW |
| **Total Power** | **546.4 uW** |

#### IR Drop Analysis
| Net | Average Drop | Worst Drop | Percentage |
|-----|--------------|------------|------------|
| VDD | 0.24 mV | 1.60 mV | 0.21% |
| VSS | 0.25 mV | 1.42 mV | 0.18% |

#### Cell Distribution
| Cell Type | Count | Area (um²) |
|-----------|-------|------------|
| Sequential | 263 | 99.7 |
| Combinational | 932 | 101.3 |
| Clock Buffers | 13 | 3.7 |
| Timing Repair | 168 | 13.6 |
| Inverters | 69 | 3.0 |
| Fill Cells | 2,294 | 223.1 |
| Tap Cells | 158 | 4.6 |
| Tie Cells | 266 | 11.6 |

#### DRC Status
- **Violations:** 0
- **Status:** CLEAN

---

### 1.5 GHz Aggressive (COMPLETED - TIMING MET)

| Metric | Value | Notes |
|--------|-------|-------|
| **Target Clock** | 667 ps (1.5 GHz) | Aggressive target |
| **Achieved Fmax** | **1857.6 MHz** | 23.8% margin |
| **Setup WNS** | +128.7 ps | Positive = met |
| **Hold WNS** | +20.2 ps | Positive = met |
| **Setup TNS** | 0 ps | No violations |
| **Hold TNS** | 0 ps | No violations |
| **Clock Skew (setup)** | 31.6 ps | Well controlled |
| **Clock Skew (hold)** | 35.4 ps | Well controlled |
| **Total Cells** | 1,958 | - |
| **Total Power** | 820.6 uW | @ 1.5 GHz |
| **Utilization** | 53.2% | - |
| **DRC Violations** | 0 | CLEAN |

**Note:** Flow completed with 2 threads (`-threads 2`) to reduce memory usage

---

### 2 GHz Maximum Performance (NOT RUN)

| Metric | Value | Notes |
|--------|-------|-------|
| **Target Clock** | 500 ps (2.0 GHz) | Maximum target |
| **Status** | Pending | Requires 16+ GB RAM |
| **Design Variant** | tritone_soc_v2 | Uses 2-stage pipelined MAC |

---

## Sky130 130nm Results

### 150 MHz Baseline (INCOMPLETE)

| Metric | Value | Notes |
|--------|-------|-------|
| **Target Clock** | 6667 ps (150 MHz) | Baseline target |
| **Status** | Failed @ CTS | Hold repair exhausted |
| **Hold WNS** | -199.5 ps | Significant violation |
| **Hold TNS** | -52,065 ps | 262 endpoints |

**Root Cause:** Sky130 cell library has significant hold timing requirements. The repair process exhausted the maximum buffer count (362 buffers inserted) before fixing all violations.

**Recommended Fix:**
1. Increase `MAX_REPAIR_BUFFER_COUNT` in flow config
2. Use multi-corner timing with faster cells
3. Reduce clock uncertainty
4. Consider design changes to reduce register-to-register paths

---

### 200 MHz Aggressive (NOT RUN)

| Metric | Value | Notes |
|--------|-------|-------|
| **Target Clock** | 5000 ps (200 MHz) | Aggressive target |
| **Status** | Pending | Requires hold fixes first |

---

## Critical Path Analysis

### ASAP7 1 GHz - Critical Path
```
From: Register in CPU pipeline
To:   Register in CPU pipeline
Path Type: Setup
Slack: +133.2 ps

The design achieves 1.154 GHz with 15.4% timing margin.
This confirms the 5-stage pipelined CPU architecture
is well-suited for ASAP7 7nm process.
```

---

## Files Generated

### ASAP7 1 GHz Baseline
| File | Description |
|------|-------------|
| `6_final.gds` | Final GDSII layout |
| `6_final.def` | Final DEF placement |
| `6_final.odb` | OpenROAD database |
| `6_final.sdc` | Final timing constraints |
| `6_final.spef` | Parasitic extraction |
| `6_final.v` | Gate-level netlist |

---

## Recommendations

### For Higher Frequency (2 GHz)
1. **Memory:** Increase Docker container memory to 16+ GB
2. **Pipeline:** Enable `USE_2GHZ_PIPELINE=1` for 2-stage MAC
3. **Sequential:** Run flows sequentially to avoid memory contention

### For Sky130 Timing Closure
1. **Hold Fixing:** Increase buffer limits in config
2. **Constraints:** Relax clock uncertainty from 200ps to 300ps
3. **Multi-Vt:** Enable multi-threshold voltage cells
4. **Target:** Consider 100 MHz as baseline for Sky130

### For Full TPU Integration
1. **Design:** Current flow uses `tritone_soc` (CPU + TPU stub)
2. **Full TPU:** Use `tritone_soc_v2` with 64x64 systolic array
3. **Area:** Expect 10-50x larger area for full TPU

---

## Runtime Summary

| Flow | Runtime | Peak Memory | Status |
|------|---------|-------------|--------|
| ASAP7 1 GHz | 3m 8s | 4.0 GB | Complete |
| ASAP7 1.5 GHz | ~1m (partial) | 7.3 GB | OOM |
| Sky130 150 MHz | ~30s (partial) | 0.3 GB | Hold fail |

---

## Conclusion

**ASAP7 7nm @ 1 GHz: VERIFIED TIMING CLOSURE**

The Tritone SoC achieves timing closure at 1 GHz on ASAP7 7nm process with 15.4% margin (actual Fmax: 1.154 GHz). This validates the RTL architecture for high-frequency operation.

Key achievements:
- Zero setup/hold violations
- Zero DRC violations
- 51.6% utilization (room for TPU integration)
- Sub-mW power consumption
- Excellent IR drop (<0.25%)

The design is ready for:
1. Full TPU integration (tritone_soc_v2)
2. Higher frequency exploration (1.5-2 GHz)
3. Multi-corner PVT analysis
