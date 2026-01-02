# Tool Versions

This document pins all tool versions used for Tritone ASIC synthesis to ensure reproducibility.

---

## OpenLane

| Property | Value |
|----------|-------|
| Docker Image | `ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69` |
| OpenLane Commit | `ff5509f65b17bfa4068d5336495ab1718987ff69` |
| Flow Version | OpenLane 2.x (OpenROAD-based) |

**Verify Installed Version:**
```bash
docker run --rm ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69 cat /openlane/.git/HEAD
```

---

## PDK

| Property | Value |
|----------|-------|
| PDK | SKY130A |
| Standard Cell Library | sky130_fd_sc_hd (high density) |
| PDK Manager | Volare |
| Source | `C:\Users\ACER\.ciel` (Windows) or `/home/ciel/.volare` (Docker mount) |

**Install PDK via Volare:**
```bash
pip install volare
volare enable sky130A
```

---

## Embedded Tools (from Docker Image)

| Tool | Purpose |
|------|---------|
| Yosys | RTL synthesis (Verilog to netlist) |
| OpenROAD | Floorplanning, placement, CTS, routing |
| Magic | DRC, parasitic extraction, GDS manipulation |
| Netgen | LVS (Layout vs Schematic) |
| KLayout | GDS visualization |
| OpenSTA | Static Timing Analysis |

---

## Run Configurations

### tritone_v4 (Baseline)
- OpenLane: `337ffbf4749b8bc6e8d8742ed9a595934142198b`
- Config: `config.v4-baseline.json`
- Strategy: `AREA 0`

### tritone_v6_300mhz (Optimized)
- OpenLane: `ff5509f65b17bfa4068d5336495ab1718987ff69`
- Config: `config.json`
- Strategy: `DELAY 0`

---

## Reproducibility Commands

**Reproduce 300MHz Run:**
```powershell
docker run --rm `
  -v "E:\ternary cmos compile\tritone-complete\OpenLane\designs\ternary_cpu_system:/openlane/designs/ternary_cpu_system" `
  -v "C:\Users\ACER\.ciel:/home/ciel/.volare" `
  -e PDK_ROOT=/home/ciel/.volare `
  -e PDK=sky130A `
  ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69 `
  ./flow.tcl -design /openlane/designs/ternary_cpu_system -tag tritone_v6_300mhz
```

---

## Machine Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| OS | Windows 10/11 with Docker or Linux | Ubuntu 20.04+ |
| RAM | 8 GB | 16 GB |
| Disk | 20 GB free | 50 GB free |
| Docker | Required | Latest stable |
| Runtime | ~10 min/run | ~5 min/run (SSD) |
