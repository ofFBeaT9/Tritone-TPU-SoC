# Metrics Definitions

This document defines all metrics used in Tritone ASIC characterization with their exact sources and units.

---

## Timing Metrics

| Metric | Definition | Source Report | Units |
|--------|------------|---------------|-------|
| WNS (Setup) | Worst Negative Slack for setup timing | `signoff/*_sta.max.rpt` | ns |
| WNS (Hold) | Worst Negative Slack for hold timing | `signoff/*_sta.min.rpt` | ns |
| TNS | Total Negative Slack (sum of all violations) | `signoff/*_sta.max.rpt` | ns |
| Critical Path | Data arrival time on worst timing path | `signoff/*_sta.max.rpt` | ns |
| Setup Slack | Time margin before setup violation | `signoff/*_sta.max.rpt` | ns |
| Recovery Slack | Async reset recovery time margin | `signoff/*_sta.max.rpt` | ns |

**Pass Criteria:**
- WNS >= 0 (no negative slack)
- TNS = 0 (no accumulated violations)

---

## Power Metrics

All power values measured at **Typical Corner** (TT, 25C, 1.8V).

| Metric | Definition | Source Report | Units |
|--------|------------|---------------|-------|
| Power (Internal) | Cell internal switching power | `signoff/*_sta.power.rpt` | uW |
| Power (Switching) | Net/wire switching power | `signoff/*_sta.power.rpt` | uW |
| Power (Leakage) | Static leakage power | `signoff/*_sta.power.rpt` | nW |
| Power (Total) | Internal + Switching + Leakage | Calculated | uW |

**Power Report Format:**
```
Group                  Internal  Switching    Leakage      Total
                          Power      Power      Power      Power (Watts)
----------------------------------------------------------------
Sequential             X.XXe-XX   X.XXe-XX   X.XXe-XX   X.XXe-XX
Combinational          X.XXe-XX   X.XXe-XX   X.XXe-XX   X.XXe-XX
Clock                  X.XXe-XX   X.XXe-XX   X.XXe-XX   X.XXe-XX
----------------------------------------------------------------
Total                  X.XXe-XX   X.XXe-XX   X.XXe-XX   X.XXe-XX
```

**Important:** The `metrics.csv` power values may have extraction bugs. Always verify against the actual signoff power reports.

---

## Area Metrics

| Metric | Definition | Source | Units |
|--------|------------|--------|-------|
| Die Area | Total die dimensions (width x height) | `metrics.csv` | mm^2 |
| Core Area | Placeable area inside die margins | `metrics.csv` | um^2 |
| Utilization | (Cell Area / Core Area) x 100 | `metrics.csv` | % |
| Cell Count | Number of standard cells | `metrics.csv` | count |
| Decap Cells | Decoupling capacitor filler cells | `metrics.csv` | count |

---

## Sign-Off Checks

| Check | Tool | Pass Criteria | Report |
|-------|------|---------------|--------|
| DRC | Magic | 0 violations | `signoff/*-drc.rpt` |
| LVS | Netgen | 0 errors | `signoff/*-lvs.rpt` |
| Antenna | OpenROAD | 0 violations | `signoff/*-antenna.rpt` |
| STA Setup | OpenSTA | WNS >= 0 | `signoff/*_sta.max.rpt` |
| STA Hold | OpenSTA | WNS >= 0 | `signoff/*_sta.min.rpt` |

**"PASS" Definition:**
A run passes if ALL of the following are true:
- DRC: 0 violations
- LVS: 0 errors
- Antenna: 0 violations
- STA Setup: WNS >= 0
- STA Hold: WNS >= 0

---

## PVT Corners

OpenLane reports timing at multiple Process-Voltage-Temperature corners:

| Corner | Process | Voltage | Temperature | Use |
|--------|---------|---------|-------------|-----|
| Typical (TT) | Typical | 1.8V | 25C | Power reporting |
| Slow (SS) | Slow | 1.6V | 100C | Setup timing (worst) |
| Fast (FF) | Fast | 1.95V | -40C | Hold timing (worst) |

---

## Report File Locations

For a run named `tritone_v6_300mhz`:

| Report Type | Path |
|-------------|------|
| Metrics CSV | `runs/tritone_v6_300mhz/reports/metrics.csv` |
| Power (Signoff) | `runs/tritone_v6_300mhz/reports/signoff/31-rcx_sta.power.rpt` |
| Timing (Setup) | `runs/tritone_v6_300mhz/reports/signoff/31-rcx_sta.max.rpt` |
| Timing (Hold) | `runs/tritone_v6_300mhz/reports/signoff/31-rcx_sta.min.rpt` |
| DRC | `runs/tritone_v6_300mhz/reports/signoff/35-drc.rpt` |
| LVS | `runs/tritone_v6_300mhz/reports/signoff/37-lvs.rpt` |
| Antenna | `runs/tritone_v6_300mhz/reports/signoff/24-antenna.rpt` |
