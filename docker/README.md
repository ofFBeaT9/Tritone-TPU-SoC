# SKY130 BSIM4 Simulation Environment

Docker-based environment for running full BSIM4 SPICE simulations of the Multi-Vth STI cell with SKY130 foundry PDK.

## Quick Start

### 1. Build the Docker Image

```bash
cd docker
docker build -t tritone-spice .
```

### 2. Run Interactive Shell

```bash
docker run -v $(pwd)/..:/tritone -it tritone-spice
```

Or using docker-compose:
```bash
docker-compose run shell
```

### 3. Run TT Corner Simulation

```bash
docker-compose run sim-tt
```

### 4. Run All Corners

```bash
docker-compose run sim-all-corners
```

## Files

| File | Description |
|------|-------------|
| `Dockerfile` | Ubuntu 22.04 + ngspice + Python |
| `docker-compose.yml` | Service definitions for simulations |
| `run_bsim4_sim.sh` | Multi-corner simulation runner |

## Testbenches

| Testbench | Description |
|-----------|-------------|
| `tb_sti_multivth_bsim4.spice` | Full TT corner characterization |
| `tb_sti_multicorner_bsim4.spice` | All 5 process corners (TT/SS/FF/SF/FS) |

## Results

Results are saved to `/tritone/spice/results/`:

- `dc_*.dat` - DC transfer curves for each corner
- `transient_*.dat` - Transient response waveforms
- `log_*.txt` - Simulation logs with measurements
- `sim_*.log` - Full simulation output

## Key Metrics

The testbenches measure:

1. **DC Transfer Characteristic**
   - Output at Vin = 0V, 0.9V, 1.8V
   - Switching thresholds VIL, VIH

2. **Noise Margins**
   - NML (LOW region margin)
   - NMM (MID region margins)
   - NMH (HIGH region margin)

3. **PVT Sensitivity**
   - Voltage: ±10% (1.62V to 1.98V)
   - Temperature: -40°C to 125°C
   - Process: TT, SS, FF, SF, FS corners

4. **Transient Response**
   - Propagation delays tpHL, tpLH

## Post-Processing

Use the Python script to generate plots:

```bash
cd /tritone/spice
python3 ../tools/plot_pvt_results.py
```

## Troubleshooting

### ngspice can't find models
Ensure the PDK is properly mounted:
```bash
ls /tritone/pdk/sky130_fd_pr/models/corners/
```

### Permission issues
Results directory needs write access:
```bash
chmod 777 /tritone/spice/results
```

### Simulation errors
Check the log files in `/tritone/spice/results/log_*.txt`
