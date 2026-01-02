# Golden Run Bundle

This directory contains artifacts for reproducing the Tritone 300MHz synthesis results.

## Contents

| File | Purpose |
|------|---------|
| `config.golden.json` | Exact OpenLane configuration used |
| `metrics.golden.csv` | Expected metrics for verification |
| `checksums.sha256` | SHA256 checksums for GDS/LEF files |

## Expected Results (tritone_v6_300mhz)

| Metric | Expected Value |
|--------|----------------|
| Frequency | 300 MHz |
| Clock Period | 3.33 ns |
| Critical Path | 1.32 ns |
| Setup Slack | 1.09 ns |
| Power (Typical) | 966 µW |
| Die Area | 0.16 mm² |
| DRC Violations | 0 |
| LVS Errors | 0 |

## Reproduction Steps

1. **Install prerequisites:**
   ```bash
   # Docker
   docker pull ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69

   # PDK via Volare
   pip install volare
   volare enable sky130A
   ```

2. **Copy golden config:**
   ```bash
   cp golden/config.golden.json OpenLane/designs/ternary_cpu_system/config.json
   ```

3. **Run synthesis:**
   ```powershell
   docker run --rm `
     -v "E:\ternary cmos compile\tritone-complete\OpenLane\designs\ternary_cpu_system:/openlane/designs/ternary_cpu_system" `
     -v "C:\Users\ACER\.ciel:/home/ciel/.volare" `
     -e PDK_ROOT=/home/ciel/.volare `
     -e PDK=sky130A `
     ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69 `
     ./flow.tcl -design /openlane/designs/ternary_cpu_system -tag tritone_golden
   ```

4. **Verify results:**
   ```bash
   python scripts/extract_metrics.py
   # Compare with golden/metrics.golden.csv
   ```

## Verification Checklist

- [ ] Flow completes without errors
- [ ] DRC: 0 violations
- [ ] LVS: 0 errors
- [ ] Antenna: 0 violations
- [ ] Setup timing: WNS >= 0
- [ ] Hold timing: WNS >= 0
- [ ] Power within 10% of expected

## Tool Versions

| Tool | Version |
|------|---------|
| OpenLane | ff5509f65b17bfa4068d5336495ab1718987ff69 |
| PDK | SKY130A |
| Standard Cells | sky130_fd_sc_hd |
