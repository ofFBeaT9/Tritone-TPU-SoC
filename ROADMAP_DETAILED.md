# Balanced Ternary CMOS CPU/Accelerator
## Complete Implementation Roadmap - Every Step Detailed

**Project Duration**: 26 weeks (6 months)
**Technology**: Multi-Threshold Standard CMOS on SKY130 PDK
**End Goal**: FPGA prototype + Research publication + Optional ASIC tapeout

---

# TABLE OF CONTENTS

1. [Phase 1: Environment Setup & Cell Library (Weeks 1-4)](#phase-1-environment-setup--cell-library-weeks-1-4)
2. [Phase 2: RTL Synthesis Flow (Weeks 5-8)](#phase-2-rtl-synthesis-flow-weeks-5-8)
3. [Phase 3: FPGA ALU Prototype (Weeks 9-14)](#phase-3-fpga-alu-prototype-weeks-9-14)
4. [Phase 4: Ternary dCPU Core (Weeks 15-22)](#phase-4-ternary-cpu-core-weeks-15-22)
5. [Phase 5: Publication & Documentation (Weeks 23-26)](#phase-5-publication--documentation-weeks-23-26)
6. [Phase 6: ASIC Fabrication (Weeks 27+)](#phase-6-asic-fabrication-weeks-27)

---

# PHASE 1: ENVIRONMENT SETUP & CELL LIBRARY (Weeks 1-4)

## Week 1: Tool Installation & Environment Configuration

### Step 1.1: Install ngspice (Primary SPICE Simulator)
```bash
# Windows (using MSYS2)
pacman -S mingw-w64-x86_64-ngspice

# Linux (Ubuntu/Debian)
sudo apt-get install ngspice

# Or build from source for latest version (v45+)
git clone https://git.code.sf.net/p/ngspice/ngspice
cd ngspice
./autogen.sh
./configure --with-ngshared --enable-openmp --enable-xspice
make -j$(nproc)
sudo make install

# Verify installation
ngspice --version  # Should show v45 or higher
```

### Step 1.2: Install Xyce (Parallel SPICE for Large Circuits)
```bash
# Download from Sandia National Labs
# https://xyce.sandia.gov/downloads/

# Linux installation
tar -xzf Xyce-Release-7.10.0-OPENSOURCE-Linux.tar.gz
export PATH=$PATH:/path/to/Xyce-Release-7.10.0/bin

# Verify
Xyce -v
```

### Step 1.3: Download SKY130 PDK
```bash
# Create working directory
mkdir -p ~/ternary_cmos
cd ~/ternary_cmos

# Clone SKY130 PDK
git clone https://github.com/google/skywater-pdk.git
cd skywater-pdk
git submodule init libraries/sky130_fd_pr/latest
git submodule update

# Set environment variable
export PDK_ROOT=~/ternary_cmos/skywater-pdk
export SKY130_PDK=$PDK_ROOT/libraries/sky130_fd_pr/latest
```

### Step 1.4: Download PTM Models (Backup)
```bash
# Arizona State Predictive Technology Models
mkdir -p ~/ternary_cmos/ptm_models
cd ~/ternary_cmos/ptm_models

# Download from: http://ptm.asu.edu/
wget http://ptm.asu.edu/modelcard/LP/180nm_LP.pm
wget http://ptm.asu.edu/modelcard/LP/130nm_LP.pm
wget http://ptm.asu.edu/modelcard/LP/90nm_LP.pm
```

### Step 1.5: Create Project Directory Structure
```bash
mkdir -p ~/ternary_cmos/project
cd ~/ternary_cmos/project

# Create directory structure
mkdir -p spice/{cells,testbenches,results,models}
mkdir -p hdl/{rtl,tb,sim}
mkdir -p fpga/{src,constraints,ip,bitstreams}
mkdir -p asic/{lib,lef,gds,scripts}
mkdir -p docs/{specs,papers,notes}
mkdir -p tools/{scripts,configs}
```

### Step 1.6: Create ngspice Configuration File
```bash
# Create ~/.spiceinit
cat > ~/.spiceinit << 'EOF'
* ngspice initialization file for ternary CMOS
set filetype=ascii
set ngbehavior=hsa
set num_threads=4

* Convergence settings for ternary circuits
set gmin=1e-12
set abstol=1e-12
set reltol=1e-4
set vntol=1e-6
set itl1=500
set itl2=200
set itl4=100

* Enable OpenMP
set num_threads=4
EOF
```

### Step 1.7: Create SKY130 Model Include File
```bash
cat > ~/ternary_cmos/project/spice/models/sky130_models.spice << 'EOF'
* SKY130 Multi-Vth Device Models for Ternary Logic
* Include paths - adjust to your PDK location

.lib "$SKY130_PDK/models/sky130.lib.spice" tt

* Define voltage and temperature
.param VDD = 1.8
.param TEMP = 27

* Multi-Vth device definitions
* LVT NMOS: Low threshold (~0.29V) - turns on first
* SVT NMOS: Standard threshold (~0.42V)
* HVT PMOS: High threshold (~0.76V) - turns on last

.subckt LVT_NMOS d g s b W=1u L=150n
XM d g s b sky130_fd_pr__nfet_01v8_lvt W=W L=L
.ends

.subckt SVT_NMOS d g s b W=1u L=150n
XM d g s b sky130_fd_pr__nfet_01v8 W=W L=L
.ends

.subckt LVT_PMOS d g s b W=1u L=150n
XM d g s b sky130_fd_pr__pfet_01v8 W=W L=L
.ends

.subckt HVT_PMOS d g s b W=1u L=150n
XM d g s b sky130_fd_pr__pfet_01v8_hvt W=W L=L
.ends
EOF
```

---

## Week 2: Design Core Ternary Inverters (STI, PTI, NTI)

### Step 2.1: Standard Ternary Inverter (STI) - The Foundation

**Theory**: STI inverts all three logic levels:
- Input 0 (0V) → Output 2 (1.8V)
- Input 1 (0.9V) → Output 1 (0.9V)
- Input 2 (1.8V) → Output 0 (0V)

**Circuit**: Uses LVT and HVT devices to create stable VDD/2 output

```bash
cat > ~/ternary_cmos/project/spice/cells/sti.spice << 'EOF'
* Standard Ternary Inverter (STI)
* Balanced ternary: -1 (0V), 0 (0.9V), +1 (1.8V)

.subckt STI in out VDD VSS
* Parameters
.param Wn=500n Wp=1u Ln=150n Lp=150n

* Pull-up network (PMOS)
* HVT PMOS - switches at higher voltage
XMP1 out in VDD VDD sky130_fd_pr__pfet_01v8_hvt W=Wp L=Lp
* LVT PMOS - provides current for intermediate state
XMP2 out in VDD VDD sky130_fd_pr__pfet_01v8 W=Wp L=Lp

* Pull-down network (NMOS)
* LVT NMOS - switches at lower voltage
XMN1 out in VSS VSS sky130_fd_pr__nfet_01v8_lvt W=Wn L=Ln
* HVT NMOS (simulated with standard + sizing)
XMN2 out in VSS VSS sky130_fd_pr__nfet_01v8 W='Wn/2' L=Ln

.ends STI
EOF
```

### Step 2.2: STI Testbench
```bash
cat > ~/ternary_cmos/project/spice/testbenches/tb_sti.spice << 'EOF'
* STI Testbench - DC and Transient Analysis

.include '../models/sky130_models.spice'
.include '../cells/sti.spice'

* Supply voltage
VDD vdd 0 DC 1.8
VSS vss 0 DC 0

* Input stimulus - sweep through all three levels
VIN in 0 PWL(
+   0n 0
+  10n 0
+  20n 0.9
+  30n 0.9
+  40n 1.8
+  50n 1.8
+  60n 0.9
+  70n 0
+  80n 0)

* Device under test
XSTI in out vdd vss STI

* Load capacitance (typical)
CL out 0 10f

* Analysis commands
.dc VIN 0 1.8 0.01

.tran 0.1n 100n

* Measurements
.meas DC v_out_low FIND V(out) AT=0
.meas DC v_out_mid FIND V(out) AT=0.9
.meas DC v_out_high FIND V(out) AT=1.8

.meas TRAN tpd_lh TRIG V(in) VAL=0.9 FALL=1 TARG V(out) VAL=0.9 RISE=1
.meas TRAN tpd_hl TRIG V(in) VAL=0.9 RISE=1 TARG V(out) VAL=0.9 FALL=1

.control
run
set filetype=ascii

* DC Analysis Plot
plot dc1.V(out) vs V(in) title 'STI DC Transfer Curve'

* Transient Plot
plot tran1.V(in) tran1.V(out) title 'STI Transient Response'

* Check for 3 stable regions
echo "=== STI Verification ==="
echo "Expected: V(out) at Vin=0V should be ~1.8V"
echo "Expected: V(out) at Vin=0.9V should be ~0.9V"
echo "Expected: V(out) at Vin=1.8V should be ~0V"

wrdata ../results/sti_dc.csv dc1.V(out)
wrdata ../results/sti_tran.csv tran1.V(in) tran1.V(out)
.endc

.end
EOF
```

### Step 2.3: Run STI Simulation
```bash
cd ~/ternary_cmos/project/spice/testbenches
ngspice tb_sti.spice

# Check results
cat ../results/sti_dc.csv
```

### Step 2.4: Positive Ternary Inverter (PTI)
**Function**:
- Input 0, 1 → Output 2 (HIGH)
- Input 2 → Output 0 (LOW)

```bash
cat > ~/ternary_cmos/project/spice/cells/pti.spice << 'EOF'
* Positive Ternary Inverter (PTI)
* Threshold shifted upward - only responds to high input

.subckt PTI in out VDD VSS
.param Wn=500n Wp=2u Ln=150n Lp=150n

* Stronger pull-up (PMOS) - bias toward high output
XMP1 out in VDD VDD sky130_fd_pr__pfet_01v8 W='Wp*2' L=Lp
XMP2 out in VDD VDD sky130_fd_pr__pfet_01v8_hvt W=Wp L=Lp

* Weaker pull-down (NMOS)
XMN1 out in VSS VSS sky130_fd_pr__nfet_01v8_lvt W=Wn L=Ln

.ends PTI
EOF
```

### Step 2.5: Negative Ternary Inverter (NTI)
**Function**:
- Input 0 → Output 2 (HIGH)
- Input 1, 2 → Output 0 (LOW)

```bash
cat > ~/ternary_cmos/project/spice/cells/nti.spice << 'EOF'
* Negative Ternary Inverter (NTI)
* Threshold shifted downward - responds to low input only

.subckt NTI in out VDD VSS
.param Wn=1u Wp=500n Ln=150n Lp=150n

* Weaker pull-up (PMOS)
XMP1 out in VDD VDD sky130_fd_pr__pfet_01v8 W=Wp L=Lp

* Stronger pull-down (NMOS) - bias toward low output
XMN1 out in VSS VSS sky130_fd_pr__nfet_01v8_lvt W='Wn*2' L=Ln
XMN2 out in VSS VSS sky130_fd_pr__nfet_01v8 W=Wn L=Ln

.ends NTI
EOF
```

### Step 2.6: Create Inverter Comparison Testbench
```bash
cat > ~/ternary_cmos/project/spice/testbenches/tb_inverters.spice << 'EOF'
* Compare STI, PTI, NTI DC Transfer Curves

.include '../models/sky130_models.spice'
.include '../cells/sti.spice'
.include '../cells/pti.spice'
.include '../cells/nti.spice'

VDD vdd 0 DC 1.8
VSS vss 0 DC 0
VIN in 0 DC 0

XSTI in out_sti vdd vss STI
XPTI in out_pti vdd vss PTI
XNTI in out_nti vdd vss NTI

.dc VIN 0 1.8 0.01

.control
run
plot V(out_sti) V(out_pti) V(out_nti) vs V(in) title 'Ternary Inverters Comparison'
wrdata ../results/inverters_comparison.csv V(out_sti) V(out_pti) V(out_nti)
.endc

.end
EOF
```

---

## Week 3: Design Complex Ternary Gates

### Step 3.1: Ternary MIN Gate (T-AND equivalent)
**Function**: Y = MIN(A, B)
- Returns the minimum of two ternary inputs
- Acts like AND in ternary domain

```bash
cat > ~/ternary_cmos/project/spice/cells/tmin.spice << 'EOF'
* Ternary MIN Gate
* Y = MIN(A, B)
* Truth Table:
*   A\B | 0  1  2
*   ----+--------
*    0  | 0  0  0
*    1  | 0  1  1
*    2  | 0  1  2

.subckt TMIN A B Y VDD VSS
.param Wn=500n Wp=1u L=150n

* Implementation using pass-transistor logic with STI restoration

* Pass A if A < B, pass B otherwise
* Intermediate node
XMP1 VDD A n1 VDD sky130_fd_pr__pfet_01v8 W=Wp L=L
XMN1 n1 B Y VSS sky130_fd_pr__nfet_01v8_lvt W=Wn L=L

XMP2 VDD B n2 VDD sky130_fd_pr__pfet_01v8 W=Wp L=L
XMN2 n2 A Y VSS sky130_fd_pr__nfet_01v8_lvt W=Wn L=L

* Pull-down for low inputs
XMN3 Y A VSS VSS sky130_fd_pr__nfet_01v8 W=Wn L=L
XMN4 Y B VSS VSS sky130_fd_pr__nfet_01v8 W=Wn L=L

* Level restoration buffer
XSTI_buf Y Y_buf VDD VSS STI
XSTI_out Y_buf Y_out VDD VSS STI

.ends TMIN
EOF
```

### Step 3.2: Ternary MAX Gate (T-OR equivalent)
```bash
cat > ~/ternary_cmos/project/spice/cells/tmax.spice << 'EOF'
* Ternary MAX Gate
* Y = MAX(A, B)
* Truth Table:
*   A\B | 0  1  2
*   ----+--------
*    0  | 0  1  2
*    1  | 1  1  2
*    2  | 2  2  2

.subckt TMAX A B Y VDD VSS
.param Wn=500n Wp=1u L=150n

* Pull-up for high inputs
XMP1 VDD A Y VDD sky130_fd_pr__pfet_01v8_hvt W=Wp L=L
XMP2 VDD B Y VDD sky130_fd_pr__pfet_01v8_hvt W=Wp L=L

* Transmission gates for intermediate
XMN1 A B n1 VSS sky130_fd_pr__nfet_01v8 W=Wn L=L
XMP3 A B n1 VDD sky130_fd_pr__pfet_01v8 W=Wp L=L

* Level restoration
XSTI Y Y_restored VDD VSS STI

.ends TMAX
EOF
```

### Step 3.3: Ternary NAND Gate
```bash
cat > ~/ternary_cmos/project/spice/cells/tnand.spice << 'EOF'
* Ternary NAND Gate
* Y = NOT(MIN(A, B)) = STI(MIN(A,B))

.subckt TNAND A B Y VDD VSS

* First compute MIN
XTMIN A B min_out VDD VSS TMIN

* Then invert with STI
XSTI min_out Y VDD VSS STI

.ends TNAND
EOF
```

### Step 3.4: Ternary NOR Gate
```bash
cat > ~/ternary_cmos/project/spice/cells/tnor.spice << 'EOF'
* Ternary NOR Gate
* Y = NOT(MAX(A, B)) = STI(MAX(A,B))

.subckt TNOR A B Y VDD VSS

* First compute MAX
XTMAX A B max_out VDD VSS TMAX

* Then invert with STI
XSTI max_out Y VDD VSS STI

.ends TNOR
EOF
```

### Step 3.5: Ternary SUM Gate (Modulo-3 Addition)
```bash
cat > ~/ternary_cmos/project/spice/cells/tsum.spice << 'EOF'
* Ternary SUM Gate (Modulo-3)
* Y = (A + B) mod 3
* Truth Table:
*   A\B | 0  1  2
*   ----+--------
*    0  | 0  1  2
*    1  | 1  2  0
*    2  | 2  0  1

.subckt TSUM A B Y VDD VSS
.param W=500n L=150n

* Implementation using decoder + encoder approach
* Decode A and B, compute sum, encode result

* A decoder (generates A=0, A=1, A=2 signals)
XNTI_A A A_is_0 VDD VSS NTI
XPTI_A A A_is_2_inv VDD VSS PTI
XSTI_A2 A_is_2_inv A_is_2 VDD VSS STI

* B decoder
XNTI_B B B_is_0 VDD VSS NTI
XPTI_B B B_is_2_inv VDD VSS PTI
XSTI_B2 B_is_2_inv B_is_2 VDD VSS STI

* Sum logic (simplified - full implementation needs all 9 cases)
* This is a placeholder - full implementation requires
* multiplexer tree based on decoded inputs

* For now, use behavioral model placeholder
* (Real implementation would use T-MUX network)

.ends TSUM
EOF
```

### Step 3.6: 3-to-1 Ternary Multiplexer
```bash
cat > ~/ternary_cmos/project/spice/cells/tmux3.spice << 'EOF'
* 3-to-1 Ternary Multiplexer
* Selects D0, D1, or D2 based on ternary select signal S
* Y = D0 if S=0, D1 if S=1, D2 if S=2

.subckt TMUX3 D0 D1 D2 S Y VDD VSS
.param W=500n L=150n

* Generate select signals using threshold inverters
* S_is_0: active when S = 0
XNTI_S S S_is_0 VDD VSS NTI

* S_is_2: active when S = 2
XPTI_S S S_not_2 VDD VSS PTI
XSTI_S2 S_not_2 S_is_2 VDD VSS STI

* S_is_1: active when S = 1 (neither 0 nor 2)
* Computed as: NOT(S_is_0 OR S_is_2)
XTMAX_sel S_is_0 S_is_2 S_not_1 VDD VSS TMAX
XSTI_S1 S_not_1 S_is_1 VDD VSS STI

* Transmission gates for each input
* Pass D0 when S=0
XTG0_N D0 Y S_is_0 VSS sky130_fd_pr__nfet_01v8 W=W L=L
XTG0_P D0 Y S_is_0_bar VDD sky130_fd_pr__pfet_01v8 W=W L=L
XSTI_S0bar S_is_0 S_is_0_bar VDD VSS STI

* Pass D1 when S=1
XTG1_N D1 Y S_is_1 VSS sky130_fd_pr__nfet_01v8 W=W L=L
XTG1_P D1 Y S_is_1_bar VDD sky130_fd_pr__pfet_01v8 W=W L=L
XSTI_S1bar S_is_1 S_is_1_bar VDD VSS STI

* Pass D2 when S=2
XTG2_N D2 Y S_is_2 VSS sky130_fd_pr__nfet_01v8 W=W L=L
XTG2_P D2 Y S_is_2_bar VDD sky130_fd_pr__pfet_01v8 W=W L=L
XSTI_S2bar S_is_2 S_is_2_bar VDD VSS STI

* Output buffer for level restoration
XSTI_out Y Y_buf VDD VSS STI
XSTI_out2 Y_buf Y_final VDD VSS STI

.ends TMUX3
EOF
```

### Step 3.7: Balanced Ternary Half Adder
```bash
cat > ~/ternary_cmos/project/spice/cells/btha.spice << 'EOF'
* Balanced Ternary Half Adder (BTHA)
* Inputs: A, B (balanced ternary: -1, 0, +1)
* Outputs: Sum, Carry
*
* Truth Table:
*   A   B  | Sum Carry
*  -1  -1  |  +1   -1
*  -1   0  |  -1    0
*  -1  +1  |   0    0
*   0  -1  |  -1    0
*   0   0  |   0    0
*   0  +1  |  +1    0
*  +1  -1  |   0    0
*  +1   0  |  +1    0
*  +1  +1  |  -1   +1

.subckt BTHA A B SUM CARRY VDD VSS

* Sum = (A + B) mod 3 with balanced representation
XTSUM A B SUM VDD VSS TSUM

* Carry generation using consensus logic
* Carry = +1 if both inputs are +1
* Carry = -1 if both inputs are -1
* Carry = 0 otherwise

* Detect both positive
XPTI_A A A_pos VDD VSS PTI
XPTI_B B B_pos VDD VSS PTI
XTMIN_pos A_pos B_pos both_pos VDD VSS TMIN

* Detect both negative
XNTI_A A A_neg VDD VSS NTI
XNTI_B B B_neg VDD VSS NTI
XTMIN_neg A_neg B_neg both_neg VDD VSS TMIN

* Combine for carry output
* Carry = both_pos (if +1+1) OR negate(both_neg) (if -1-1)
XSTI_neg both_neg both_neg_inv VDD VSS STI
XTMAX_carry both_pos both_neg_inv CARRY VDD VSS TMAX

.ends BTHA
EOF
```

### Step 3.8: Balanced Ternary Full Adder (BTFA) - 42 Transistors Target
```bash
cat > ~/ternary_cmos/project/spice/cells/btfa.spice << 'EOF'
* Balanced Ternary Full Adder (BTFA)
* Target: 42 transistors (per Ko et al.)
* Inputs: A, B, Cin
* Outputs: Sum, Cout
*
* Logic:
*   temp = A + B + Cin (ternary sum, range -3 to +3)
*   Sum = temp mod 3 (with balanced representation)
*   Cout = floor(temp / 3)

.subckt BTFA A B CIN SUM COUT VDD VSS

* First stage: Add A and B
XBTHA1 A B sum1 carry1 VDD VSS BTHA

* Second stage: Add sum1 and Cin
XBTHA2 sum1 CIN SUM carry2 VDD VSS BTHA

* Combine carries: Cout = carry1 + carry2 (cannot both be ±1)
* Since carries are bounded, MAX suffices for positive, MIN for negative
XTMAX_cout carry1 carry2 COUT VDD VSS TMAX

.ends BTFA
EOF
```

---

## Week 4: Cell Characterization & Library Generation

### Step 4.1: Create Characterization Testbench Template
```bash
cat > ~/ternary_cmos/project/spice/testbenches/characterize_cell.spice << 'EOF'
* Cell Characterization Template
* Measures: delay, power, noise margins for all 6 transitions

.param CELL_NAME = 'STI'
.include '../models/sky130_models.spice'
.include '../cells/sti.spice'

VDD vdd 0 DC 1.8
VSS vss 0 DC 0

* Input slew rate sweep
.param TSLEW = 100p

* Output load sweep
.param CLOAD = 10f

* Test all 6 transitions:
* 0→1, 1→0, 1→2, 2→1, 0→2, 2→0

* Transition 0→1
VIN_01 in_01 0 PWL(0 0 100p 0 'TSLEW+100p' 0.9)
XDUT_01 in_01 out_01 vdd vss STI
CL_01 out_01 0 CLOAD

* Transition 1→0
VIN_10 in_10 0 PWL(0 0.9 100p 0.9 'TSLEW+100p' 0)
XDUT_10 in_10 out_10 vdd vss STI
CL_10 out_10 0 CLOAD

* Transition 1→2
VIN_12 in_12 0 PWL(0 0.9 100p 0.9 'TSLEW+100p' 1.8)
XDUT_12 in_12 out_12 vdd vss STI
CL_12 out_12 0 CLOAD

* Transition 2→1
VIN_21 in_21 0 PWL(0 1.8 100p 1.8 'TSLEW+100p' 0.9)
XDUT_21 in_21 out_21 vdd vss STI
CL_21 out_21 0 CLOAD

* Transition 0→2
VIN_02 in_02 0 PWL(0 0 100p 0 'TSLEW+100p' 1.8)
XDUT_02 in_02 out_02 vdd vss STI
CL_02 out_02 0 CLOAD

* Transition 2→0
VIN_20 in_20 0 PWL(0 1.8 100p 1.8 'TSLEW+100p' 0)
XDUT_20 in_20 out_20 vdd vss STI
CL_20 out_20 0 CLOAD

.tran 1p 500p

* Measurements for each transition
.meas TRAN tpd_01 TRIG V(in_01) VAL=0.45 RISE=1 TARG V(out_01) VAL=1.35 FALL=1
.meas TRAN tpd_10 TRIG V(in_10) VAL=0.45 FALL=1 TARG V(out_10) VAL=1.35 RISE=1
.meas TRAN tpd_12 TRIG V(in_12) VAL=1.35 RISE=1 TARG V(out_12) VAL=0.45 FALL=1
.meas TRAN tpd_21 TRIG V(in_21) VAL=1.35 FALL=1 TARG V(out_21) VAL=0.45 RISE=1
.meas TRAN tpd_02 TRIG V(in_02) VAL=0.9 RISE=1 TARG V(out_02) VAL=0.9 FALL=1
.meas TRAN tpd_20 TRIG V(in_20) VAL=0.9 FALL=1 TARG V(out_20) VAL=0.9 RISE=1

* Power measurement
.meas TRAN avg_power AVG P(VDD) FROM=100p TO=400p

.control
run
print tpd_01 tpd_10 tpd_12 tpd_21 tpd_02 tpd_20
print avg_power
.endc

.end
EOF
```

### Step 4.2: Monte Carlo Corner Analysis
```bash
cat > ~/ternary_cmos/project/spice/testbenches/monte_carlo_sti.spice << 'EOF'
* Monte Carlo Analysis for STI
* Tests process variation tolerance

.include '../models/sky130_models.spice'
.include '../cells/sti.spice'

VDD vdd 0 DC 1.8
VSS vss 0 DC 0
VIN in 0 DC 0.9

XSTI in out vdd vss STI

* Parameter variations (typical values for 130nm)
.param vth_sigma = 0.03
.param tox_sigma = 0.02

* Monte Carlo control
.control
let num_runs = 1000
let mc_results = vector(num_runs)

foreach run 0 num_runs-1
    * Apply random variation
    alter @XMP1[vth0] = 0.5 + gauss(0, vth_sigma)
    alter @XMN1[vth0] = 0.4 + gauss(0, vth_sigma)

    op
    let mc_results[run] = V(out)
end

* Statistics
let mean_out = mean(mc_results)
let std_out = stddev(mc_results)
echo "Mean output at Vin=0.9V: " mean_out
echo "Std deviation: " std_out
echo "3-sigma range: " mean_out-3*std_out " to " mean_out+3*std_out
.endc

.end
EOF
```

### Step 4.3: Generate Liberty (.lib) File
```bash
cat > ~/ternary_cmos/project/asic/lib/gt_logic_ternary.lib << 'EOF'
/* GT-LOGIC Ternary Standard Cell Library */
/* Process: SKY130 Multi-Vth */
/* Voltage: 1.8V */
/* Temperature: 25C */

library(gt_logic_ternary) {
  technology (cmos);
  delay_model : table_lookup;

  time_unit : "1ns";
  voltage_unit : "1V";
  current_unit : "1mA";
  pulling_resistance_unit : "1kohm";
  leakage_power_unit : "1nW";
  capacitive_load_unit (1, pf);

  nom_process : 1;
  nom_temperature : 25;
  nom_voltage : 1.8;

  /* Define ternary voltage thresholds */
  voltage_map (VDD, 1.8);
  voltage_map (VMID, 0.9);
  voltage_map (VSS, 0.0);

  /* Input threshold percentages for ternary */
  /* Low threshold: 25% = 0.45V */
  /* Mid threshold: 50% = 0.9V */
  /* High threshold: 75% = 1.35V */

  input_threshold_pct_fall : 50;
  input_threshold_pct_rise : 50;
  output_threshold_pct_fall : 50;
  output_threshold_pct_rise : 50;
  slew_lower_threshold_pct_fall : 20;
  slew_lower_threshold_pct_rise : 20;
  slew_upper_threshold_pct_fall : 80;
  slew_upper_threshold_pct_rise : 80;

  /* Operating conditions */
  operating_conditions (typical) {
    process : 1;
    temperature : 25;
    voltage : 1.8;
  }
  default_operating_conditions : typical;

  /* Standard Ternary Inverter */
  cell (STI) {
    area : 2.0;
    cell_footprint : "sti";

    pin (A) {
      direction : input;
      capacitance : 0.002;
    }

    pin (Y) {
      direction : output;
      function : "!A";  /* Simplified - actual is ternary inversion */
      max_capacitance : 0.1;

      /* Timing for 6 ternary transitions */
      timing () {
        related_pin : "A";
        timing_sense : negative_unate;

        /* 0->1 transition (output 2->1) */
        cell_rise (scalar) { values ("0.05"); }
        rise_transition (scalar) { values ("0.02"); }

        /* 1->0 transition (output 1->2) */
        cell_fall (scalar) { values ("0.05"); }
        fall_transition (scalar) { values ("0.02"); }
      }
    }

    pin (VDD) {
      direction : input;
      voltage_name : VDD;
    }

    pin (VSS) {
      direction : input;
      voltage_name : VSS;
    }
  }

  /* Positive Ternary Inverter */
  cell (PTI) {
    area : 2.0;
    cell_footprint : "pti";

    pin (A) {
      direction : input;
      capacitance : 0.002;
    }

    pin (Y) {
      direction : output;
      max_capacitance : 0.1;

      timing () {
        related_pin : "A";
        cell_rise (scalar) { values ("0.06"); }
        cell_fall (scalar) { values ("0.04"); }
      }
    }

    pin (VDD) { direction : input; voltage_name : VDD; }
    pin (VSS) { direction : input; voltage_name : VSS; }
  }

  /* Negative Ternary Inverter */
  cell (NTI) {
    area : 2.0;
    cell_footprint : "nti";

    pin (A) {
      direction : input;
      capacitance : 0.002;
    }

    pin (Y) {
      direction : output;
      max_capacitance : 0.1;

      timing () {
        related_pin : "A";
        cell_rise (scalar) { values ("0.04"); }
        cell_fall (scalar) { values ("0.06"); }
      }
    }

    pin (VDD) { direction : input; voltage_name : VDD; }
    pin (VSS) { direction : input; voltage_name : VSS; }
  }

  /* Balanced Ternary Full Adder */
  cell (BTFA) {
    area : 21.0;  /* ~42 transistors */
    cell_footprint : "btfa";

    pin (A) { direction : input; capacitance : 0.004; }
    pin (B) { direction : input; capacitance : 0.004; }
    pin (CIN) { direction : input; capacitance : 0.004; }

    pin (SUM) {
      direction : output;
      function : "(A + B + CIN) mod 3";
      max_capacitance : 0.1;

      timing () {
        related_pin : "A B CIN";
        cell_rise (scalar) { values ("0.15"); }
        cell_fall (scalar) { values ("0.15"); }
      }
    }

    pin (COUT) {
      direction : output;
      function : "floor((A + B + CIN) / 3)";
      max_capacitance : 0.1;

      timing () {
        related_pin : "A B CIN";
        cell_rise (scalar) { values ("0.12"); }
        cell_fall (scalar) { values ("0.12"); }
      }
    }

    pin (VDD) { direction : input; voltage_name : VDD; }
    pin (VSS) { direction : input; voltage_name : VSS; }
  }
}
EOF
```

### Step 4.4: Create Cell Summary Document
```bash
cat > ~/ternary_cmos/project/docs/specs/gt_logic_cells.md << 'EOF'
# GT-LOGIC Cell Library Specification

## Overview
Multi-threshold CMOS ternary cells for SKY130 process (1.8V)

## Voltage Levels
| Logic | Voltage | Balanced Ternary |
|-------|---------|------------------|
| 0 | 0V (GND) | -1 |
| 1 | 0.9V (VDD/2) | 0 |
| 2 | 1.8V (VDD) | +1 |

## Cell Inventory

### Inverters (Priority 0)
| Cell | Function | Transistors | Validated |
|------|----------|-------------|-----------|
| STI | Y = -A (full inversion) | 6 | [ ] |
| PTI | Y = 2 if A<2, else 0 | 6 | [ ] |
| NTI | Y = 2 if A=0, else 0 | 6 | [ ] |

### Logic Gates (Priority 1)
| Cell | Function | Transistors | Validated |
|------|----------|-------------|-----------|
| TMIN | Y = MIN(A,B) | 10 | [ ] |
| TMAX | Y = MAX(A,B) | 10 | [ ] |
| TNAND | Y = STI(MIN(A,B)) | 16 | [ ] |
| TNOR | Y = STI(MAX(A,B)) | 16 | [ ] |
| TSUM | Y = (A+B) mod 3 | 20 | [ ] |
| TMUX3 | Y = Ds where s=S | 24 | [ ] |

### Arithmetic (Priority 1)
| Cell | Function | Transistors | Validated |
|------|----------|-------------|-----------|
| BTHA | Half Adder | 30 | [ ] |
| BTFA | Full Adder | 42 | [ ] |

### Sequential (Priority 2)
| Cell | Function | Transistors | Validated |
|------|----------|-------------|-----------|
| TDFF | D Flip-Flop | 36 | [ ] |
| TLATCH | Transparent Latch | 24 | [ ] |

## Characterization Status
- [ ] DC transfer curves complete
- [ ] 6-transition timing complete
- [ ] Monte Carlo (1000 runs) complete
- [ ] 5-corner analysis complete
- [ ] Liberty file generated
- [ ] LEF file generated
EOF
```

---

# PHASE 2: RTL SYNTHESIS FLOW (Weeks 5-8)

## Week 5: HDL Framework Development

### Step 5.1: Create SystemVerilog Package for Ternary Types
```bash
cat > ~/ternary_cmos/project/hdl/rtl/ternary_pkg.sv << 'EOF'
// Ternary Logic Package
// Defines types, functions, and operators for balanced ternary

package ternary_pkg;

  // 2-bit encoding for ternary values
  // 00 = 0 (zero)
  // 01 = +1 (positive one)
  // 10 = -1 (negative one)
  // 11 = X (invalid/error)

  typedef enum logic [1:0] {
    T_ZERO    = 2'b00,
    T_POS_ONE = 2'b01,
    T_NEG_ONE = 2'b10,
    T_INVALID = 2'b11
  } trit_t;

  // N-trit vector type
  typedef trit_t [7:0] trit8_t;   // 8-trit word
  typedef trit_t [26:0] trit27_t; // 27-trit word (standard)

  // Ternary inversion (STI function)
  function automatic trit_t t_neg(trit_t a);
    case (a)
      T_NEG_ONE: return T_POS_ONE;
      T_ZERO:    return T_ZERO;
      T_POS_ONE: return T_NEG_ONE;
      default:   return T_INVALID;
    endcase
  endfunction

  // Ternary MIN (AND-like)
  function automatic trit_t t_min(trit_t a, trit_t b);
    if (a == T_INVALID || b == T_INVALID) return T_INVALID;
    if (a == T_NEG_ONE || b == T_NEG_ONE) return T_NEG_ONE;
    if (a == T_ZERO || b == T_ZERO) return T_ZERO;
    return T_POS_ONE;
  endfunction

  // Ternary MAX (OR-like)
  function automatic trit_t t_max(trit_t a, trit_t b);
    if (a == T_INVALID || b == T_INVALID) return T_INVALID;
    if (a == T_POS_ONE || b == T_POS_ONE) return T_POS_ONE;
    if (a == T_ZERO || b == T_ZERO) return T_ZERO;
    return T_NEG_ONE;
  endfunction

  // Ternary addition (single trit with carry)
  function automatic logic [3:0] t_add_trit(trit_t a, trit_t b, trit_t cin);
    logic signed [2:0] sum;
    trit_t result, cout;

    // Convert to signed integers and add
    sum = $signed({1'b0, a == T_POS_ONE}) - $signed({1'b0, a == T_NEG_ONE})
        + $signed({1'b0, b == T_POS_ONE}) - $signed({1'b0, b == T_NEG_ONE})
        + $signed({1'b0, cin == T_POS_ONE}) - $signed({1'b0, cin == T_NEG_ONE});

    // Convert back to balanced ternary
    case (sum)
      -3: begin result = T_ZERO;    cout = T_NEG_ONE; end
      -2: begin result = T_POS_ONE; cout = T_NEG_ONE; end
      -1: begin result = T_NEG_ONE; cout = T_ZERO;    end
       0: begin result = T_ZERO;    cout = T_ZERO;    end
       1: begin result = T_POS_ONE; cout = T_ZERO;    end
       2: begin result = T_NEG_ONE; cout = T_POS_ONE; end
       3: begin result = T_ZERO;    cout = T_POS_ONE; end
      default: begin result = T_INVALID; cout = T_INVALID; end
    endcase

    return {cout, result};
  endfunction

  // Convert binary to balanced ternary
  function automatic trit27_t bin_to_ternary(logic signed [31:0] val);
    trit27_t result;
    logic signed [31:0] temp;
    int i;

    temp = val;
    for (i = 0; i < 27; i++) begin
      case (temp % 3)
        0: result[i] = T_ZERO;
        1: result[i] = T_POS_ONE;
        2: begin
          result[i] = T_NEG_ONE;
          temp = temp + 1;  // Adjust for balanced representation
        end
      endcase
      temp = temp / 3;
    end
    return result;
  endfunction

  // Convert balanced ternary to binary
  function automatic logic signed [31:0] ternary_to_bin(trit27_t val);
    logic signed [31:0] result;
    logic signed [31:0] power3;
    int i;

    result = 0;
    power3 = 1;
    for (i = 0; i < 27; i++) begin
      case (val[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ; // T_ZERO adds nothing
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

endpackage
EOF
```

### Step 5.2: Create RTL Ternary Full Adder
```bash
cat > ~/ternary_cmos/project/hdl/rtl/btfa.sv << 'EOF'
// Balanced Ternary Full Adder - RTL Model
// Maps to 42-transistor T-CMOS implementation

module btfa
  import ternary_pkg::*;
(
  input  trit_t a,
  input  trit_t b,
  input  trit_t cin,
  output trit_t sum,
  output trit_t cout
);

  logic [3:0] result;

  assign result = t_add_trit(a, b, cin);
  assign cout = trit_t'(result[3:2]);
  assign sum  = trit_t'(result[1:0]);

endmodule
EOF
```

### Step 5.3: Create N-Trit Ripple Carry Adder
```bash
cat > ~/ternary_cmos/project/hdl/rtl/ternary_adder.sv << 'EOF'
// Parametric Balanced Ternary Adder
// N-trit ripple carry implementation

module ternary_adder
  import ternary_pkg::*;
#(
  parameter int WIDTH = 8  // Number of trits
)(
  input  trit_t [WIDTH-1:0] a,
  input  trit_t [WIDTH-1:0] b,
  input  trit_t             cin,
  output trit_t [WIDTH-1:0] sum,
  output trit_t             cout
);

  trit_t [WIDTH:0] carry;

  assign carry[0] = cin;

  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : gen_adders
      btfa u_btfa (
        .a    (a[i]),
        .b    (b[i]),
        .cin  (carry[i]),
        .sum  (sum[i]),
        .cout (carry[i+1])
      );
    end
  endgenerate

  assign cout = carry[WIDTH];

endmodule
EOF
```

### Step 5.4: Create Ternary ALU
```bash
cat > ~/ternary_cmos/project/hdl/rtl/ternary_alu.sv << 'EOF'
// Balanced Ternary ALU
// 8-trit datapath with multiple operations

module ternary_alu
  import ternary_pkg::*;
#(
  parameter int WIDTH = 8
)(
  input  trit_t [WIDTH-1:0] a,
  input  trit_t [WIDTH-1:0] b,
  input  logic [2:0]        op,
  output trit_t [WIDTH-1:0] result,
  output trit_t             carry,
  output logic              zero_flag,
  output logic              neg_flag
);

  // Operation codes
  localparam logic [2:0] OP_ADD = 3'b000;
  localparam logic [2:0] OP_SUB = 3'b001;
  localparam logic [2:0] OP_NEG = 3'b010;
  localparam logic [2:0] OP_MIN = 3'b011;
  localparam logic [2:0] OP_MAX = 3'b100;
  localparam logic [2:0] OP_SHL = 3'b101;  // Shift left (multiply by 3)
  localparam logic [2:0] OP_SHR = 3'b110;  // Shift right (divide by 3)
  localparam logic [2:0] OP_CMP = 3'b111;  // Compare

  // Internal signals
  trit_t [WIDTH-1:0] b_negated;
  trit_t [WIDTH-1:0] add_result;
  trit_t [WIDTH-1:0] min_result;
  trit_t [WIDTH-1:0] max_result;
  trit_t [WIDTH-1:0] neg_result;
  trit_t [WIDTH-1:0] shl_result;
  trit_t [WIDTH-1:0] shr_result;
  trit_t             add_carry;

  // Negate B for subtraction
  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : gen_neg_b
      assign b_negated[i] = t_neg(b[i]);
    end
  endgenerate

  // Adder (used for ADD and SUB)
  ternary_adder #(.WIDTH(WIDTH)) u_adder (
    .a    (a),
    .b    (op == OP_SUB ? b_negated : b),
    .cin  (T_ZERO),
    .sum  (add_result),
    .cout (add_carry)
  );

  // Bitwise operations
  generate
    for (i = 0; i < WIDTH; i++) begin : gen_bitwise
      assign neg_result[i] = t_neg(a[i]);
      assign min_result[i] = t_min(a[i], b[i]);
      assign max_result[i] = t_max(a[i], b[i]);
    end
  endgenerate

  // Shift operations
  assign shl_result = {a[WIDTH-2:0], T_ZERO};  // Shift left, insert 0
  assign shr_result = {T_ZERO, a[WIDTH-1:1]};  // Shift right, insert 0

  // Output multiplexer
  always_comb begin
    case (op)
      OP_ADD: result = add_result;
      OP_SUB: result = add_result;
      OP_NEG: result = neg_result;
      OP_MIN: result = min_result;
      OP_MAX: result = max_result;
      OP_SHL: result = shl_result;
      OP_SHR: result = shr_result;
      OP_CMP: result = add_result;  // Compare uses subtraction
      default: result = '{default: T_INVALID};
    endcase
  end

  // Carry output
  assign carry = (op == OP_ADD || op == OP_SUB) ? add_carry : T_ZERO;

  // Flags
  assign zero_flag = (result == '{default: T_ZERO});
  assign neg_flag = (result[WIDTH-1] == T_NEG_ONE);

endmodule
EOF
```

---

## Week 6: Synthesis Tool Selection and Setup

### Step 6.1: Install MRCS Tool (Quick Path)
```bash
# MRCS is browser-based, access at:
# https://mrcs.sourceforge.net/ (or search for Mixed Radix Circuit Synthesizer)

# For local development, we'll create our own synthesis scripts
mkdir -p ~/ternary_cmos/project/tools/synthesis
```

### Step 6.2: Create Custom Ternary Synthesis Script
```bash
cat > ~/ternary_cmos/project/tools/synthesis/ternary_synth.py << 'EOF'
#!/usr/bin/env python3
"""
Ternary Logic Synthesis Tool
Implements GT-LOGIC mapping for ternary RTL

Based on IEEE Access 2025 methodology
"""

import re
from dataclasses import dataclass
from typing import List, Dict, Set, Tuple

@dataclass
class TernaryCell:
    name: str
    inputs: List[str]
    outputs: List[str]
    transistor_count: int
    function: str

# GT-LOGIC Cell Library
GT_LOGIC_LIBRARY = {
    'STI': TernaryCell('STI', ['A'], ['Y'], 6, 'Y = -A'),
    'PTI': TernaryCell('PTI', ['A'], ['Y'], 6, 'Y = (A<2) ? 2 : 0'),
    'NTI': TernaryCell('NTI', ['A'], ['Y'], 6, 'Y = (A=0) ? 2 : 0'),
    'TMIN': TernaryCell('TMIN', ['A', 'B'], ['Y'], 10, 'Y = MIN(A,B)'),
    'TMAX': TernaryCell('TMAX', ['A', 'B'], ['Y'], 10, 'Y = MAX(A,B)'),
    'TNAND': TernaryCell('TNAND', ['A', 'B'], ['Y'], 16, 'Y = -MIN(A,B)'),
    'TNOR': TernaryCell('TNOR', ['A', 'B'], ['Y'], 16, 'Y = -MAX(A,B)'),
    'TMUX3': TernaryCell('TMUX3', ['D0', 'D1', 'D2', 'S'], ['Y'], 24, 'Y = D[S]'),
    'BTFA': TernaryCell('BTFA', ['A', 'B', 'CIN'], ['SUM', 'COUT'], 42, 'Full Adder'),
}

class TernarySynthesizer:
    def __init__(self):
        self.cells = GT_LOGIC_LIBRARY
        self.netlist = []
        self.wire_counter = 0

    def new_wire(self) -> str:
        self.wire_counter += 1
        return f"n{self.wire_counter}"

    def synthesize_neg(self, input_sig: str) -> Tuple[str, str]:
        """Synthesize ternary negation using STI"""
        output = self.new_wire()
        self.netlist.append(f"STI U_{len(self.netlist)} (.A({input_sig}), .Y({output}));")
        return output, "STI"

    def synthesize_min(self, a: str, b: str) -> Tuple[str, str]:
        """Synthesize MIN operation"""
        output = self.new_wire()
        self.netlist.append(f"TMIN U_{len(self.netlist)} (.A({a}), .B({b}), .Y({output}));")
        return output, "TMIN"

    def synthesize_max(self, a: str, b: str) -> Tuple[str, str]:
        """Synthesize MAX operation"""
        output = self.new_wire()
        self.netlist.append(f"TMAX U_{len(self.netlist)} (.A({a}), .B({b}), .Y({output}));")
        return output, "TMAX"

    def synthesize_adder(self, a: str, b: str, cin: str) -> Tuple[str, str, str]:
        """Synthesize full adder"""
        sum_out = self.new_wire()
        cout = self.new_wire()
        self.netlist.append(
            f"BTFA U_{len(self.netlist)} (.A({a}), .B({b}), .CIN({cin}), "
            f".SUM({sum_out}), .COUT({cout}));"
        )
        return sum_out, cout, "BTFA"

    def count_transistors(self) -> int:
        """Count total transistors in netlist"""
        total = 0
        for line in self.netlist:
            for cell_name, cell in self.cells.items():
                if line.startswith(cell_name):
                    total += cell.transistor_count
                    break
        return total

    def generate_verilog_netlist(self, module_name: str,
                                  inputs: List[str],
                                  outputs: List[str]) -> str:
        """Generate Verilog netlist from synthesis result"""
        lines = [
            f"// Synthesized ternary netlist",
            f"// Total transistors: {self.count_transistors()}",
            f"",
            f"module {module_name} (",
            f"  input  [1:0] {', '.join(inputs)},",
            f"  output [1:0] {', '.join(outputs)}",
            f");",
            f"",
            f"  // Internal wires",
        ]

        # Declare internal wires
        for i in range(1, self.wire_counter + 1):
            lines.append(f"  wire [1:0] n{i};")

        lines.append("")
        lines.append("  // Cell instances")

        for inst in self.netlist:
            lines.append(f"  {inst}")

        lines.append("")
        lines.append("endmodule")

        return '\n'.join(lines)


def main():
    """Demo: Synthesize a 4-trit adder"""
    synth = TernarySynthesizer()

    # 4-trit ripple carry adder
    print("Synthesizing 4-trit Balanced Ternary Adder...")

    # Inputs
    a = ['a0', 'a1', 'a2', 'a3']
    b = ['b0', 'b1', 'b2', 'b3']
    cin = 'cin'

    # Build adder chain
    carries = [cin]
    sums = []

    for i in range(4):
        s, c, _ = synth.synthesize_adder(a[i], b[i], carries[-1])
        sums.append(s)
        carries.append(c)

    print(f"Total cells: {len(synth.netlist)}")
    print(f"Total transistors: {synth.count_transistors()}")
    print()

    # Generate netlist
    netlist = synth.generate_verilog_netlist(
        'ternary_adder_4',
        a + b + [cin],
        sums + [carries[-1]]
    )

    print(netlist)

    # Save to file
    with open('../hdl/rtl/ternary_adder_4_synth.v', 'w') as f:
        f.write(netlist)

    print("\nNetlist saved to hdl/rtl/ternary_adder_4_synth.v")


if __name__ == '__main__':
    main()
EOF

chmod +x ~/ternary_cmos/project/tools/synthesis/ternary_synth.py
```

---

## Weeks 7-8: Reference Block Implementation

### Step 7.1: Implement and Validate BTFA
```bash
cat > ~/ternary_cmos/project/hdl/tb/tb_btfa.sv << 'EOF'
// BTFA Testbench - Exhaustive verification

`timescale 1ns/1ps

module tb_btfa;
  import ternary_pkg::*;

  // Signals
  trit_t a, b, cin;
  trit_t sum, cout;

  // Expected values
  trit_t exp_sum, exp_cout;

  // Counters
  int pass_count, fail_count;

  // DUT
  btfa dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );

  // Test all 27 input combinations (3^3)
  initial begin
    pass_count = 0;
    fail_count = 0;

    $display("=== BTFA Exhaustive Test ===");
    $display("A\tB\tCin\t|\tSum\tCout\t|\tExp_S\tExp_C\t|\tResult");
    $display("------------------------------------------------------------");

    // Iterate through all combinations
    for (int ia = 0; ia < 3; ia++) begin
      for (int ib = 0; ib < 3; ib++) begin
        for (int ic = 0; ic < 3; ic++) begin
          // Set inputs
          case (ia)
            0: a = T_NEG_ONE;
            1: a = T_ZERO;
            2: a = T_POS_ONE;
          endcase

          case (ib)
            0: b = T_NEG_ONE;
            1: b = T_ZERO;
            2: b = T_POS_ONE;
          endcase

          case (ic)
            0: cin = T_NEG_ONE;
            1: cin = T_ZERO;
            2: cin = T_POS_ONE;
          endcase

          // Calculate expected
          calculate_expected(ia-1, ib-1, ic-1, exp_sum, exp_cout);

          #10;  // Wait for propagation

          // Check results
          if (sum === exp_sum && cout === exp_cout) begin
            $display("%d\t%d\t%d\t|\t%d\t%d\t|\t%d\t%d\t|\tPASS",
                     ia-1, ib-1, ic-1,
                     trit_to_int(sum), trit_to_int(cout),
                     trit_to_int(exp_sum), trit_to_int(exp_cout));
            pass_count++;
          end else begin
            $display("%d\t%d\t%d\t|\t%d\t%d\t|\t%d\t%d\t|\tFAIL ***",
                     ia-1, ib-1, ic-1,
                     trit_to_int(sum), trit_to_int(cout),
                     trit_to_int(exp_sum), trit_to_int(exp_cout));
            fail_count++;
          end
        end
      end
    end

    $display("------------------------------------------------------------");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);

    if (fail_count == 0)
      $display("*** ALL TESTS PASSED ***");
    else
      $display("*** SOME TESTS FAILED ***");

    $finish;
  end

  // Helper function to calculate expected output
  task calculate_expected(
    input int a_val, b_val, c_val,
    output trit_t exp_s, exp_c
  );
    int total;
    total = a_val + b_val + c_val;

    // Balanced ternary: result in range -1 to +1
    if (total >= 2) begin
      exp_c = T_POS_ONE;
      total = total - 3;
    end else if (total <= -2) begin
      exp_c = T_NEG_ONE;
      total = total + 3;
    end else begin
      exp_c = T_ZERO;
    end

    case (total)
      -1: exp_s = T_NEG_ONE;
       0: exp_s = T_ZERO;
       1: exp_s = T_POS_ONE;
      default: exp_s = T_INVALID;
    endcase
  endtask

  // Helper function to convert trit to integer for display
  function int trit_to_int(trit_t t);
    case (t)
      T_NEG_ONE: return -1;
      T_ZERO:    return 0;
      T_POS_ONE: return 1;
      default:   return 99;
    endcase
  endfunction

endmodule
EOF
```

### Step 7.2: Create Simulation Script
```bash
cat > ~/ternary_cmos/project/hdl/sim/run_sim.sh << 'EOF'
#!/bin/bash
# Ternary HDL Simulation Script

# Set paths
RTL_DIR="../rtl"
TB_DIR="../tb"

# Compile with Icarus Verilog
echo "Compiling ternary RTL..."
iverilog -g2012 -o sim.vvp \
    $RTL_DIR/ternary_pkg.sv \
    $RTL_DIR/btfa.sv \
    $RTL_DIR/ternary_adder.sv \
    $RTL_DIR/ternary_alu.sv \
    $TB_DIR/tb_btfa.sv

if [ $? -eq 0 ]; then
    echo "Running simulation..."
    vvp sim.vvp
else
    echo "Compilation failed!"
    exit 1
fi
EOF

chmod +x ~/ternary_cmos/project/hdl/sim/run_sim.sh
```

---

# PHASE 3: FPGA ALU PROTOTYPE (Weeks 9-14)

## Weeks 9-10: Architecture Design

### Step 9.1: Create Top-Level ALU Module for FPGA
```bash
cat > ~/ternary_cmos/project/fpga/src/ternary_alu_top.sv << 'EOF'
// Top-level Ternary ALU for FPGA Implementation
// Binary I/O interface with internal ternary processing

module ternary_alu_top (
  input  logic        clk,
  input  logic        rst_n,

  // Binary input interface (2 bits per trit)
  input  logic [15:0] a_bin,      // 8 trits = 16 bits
  input  logic [15:0] b_bin,      // 8 trits = 16 bits
  input  logic [2:0]  op,
  input  logic        valid_in,

  // Binary output interface
  output logic [15:0] result_bin,
  output logic [1:0]  carry_bin,
  output logic        zero_flag,
  output logic        neg_flag,
  output logic        valid_out
);

  import ternary_pkg::*;

  // Internal ternary signals
  trit_t [7:0] a_tern, b_tern;
  trit_t [7:0] result_tern;
  trit_t       carry_tern;

  // Convert binary inputs to ternary
  genvar i;
  generate
    for (i = 0; i < 8; i++) begin : gen_input_conv
      assign a_tern[i] = trit_t'(a_bin[2*i+1:2*i]);
      assign b_tern[i] = trit_t'(b_bin[2*i+1:2*i]);
    end
  endgenerate

  // Ternary ALU core
  ternary_alu #(.WIDTH(8)) u_alu (
    .a         (a_tern),
    .b         (b_tern),
    .op        (op),
    .result    (result_tern),
    .carry     (carry_tern),
    .zero_flag (zero_flag),
    .neg_flag  (neg_flag)
  );

  // Convert ternary outputs to binary
  generate
    for (i = 0; i < 8; i++) begin : gen_output_conv
      assign result_bin[2*i+1:2*i] = result_tern[i];
    end
  endgenerate

  assign carry_bin = carry_tern;

  // Pipeline register for valid signal
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      valid_out <= 1'b0;
    else
      valid_out <= valid_in;
  end

endmodule
EOF
```

### Step 9.2: Create FPGA Constraints (Xilinx)
```bash
cat > ~/ternary_cmos/project/fpga/constraints/ternary_alu.xdc << 'EOF'
# Ternary ALU FPGA Constraints
# Target: Xilinx UltraScale+ (adjust pins for your board)

# Clock constraint - 100 MHz
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Input delays
set_input_delay -clock sys_clk -max 2.0 [get_ports {a_bin[*] b_bin[*] op[*] valid_in}]
set_input_delay -clock sys_clk -min 0.5 [get_ports {a_bin[*] b_bin[*] op[*] valid_in}]

# Output delays
set_output_delay -clock sys_clk -max 2.0 [get_ports {result_bin[*] carry_bin[*] zero_flag neg_flag valid_out}]
set_output_delay -clock sys_clk -min 0.5 [get_ports {result_bin[*] carry_bin[*] zero_flag neg_flag valid_out}]

# Reset is asynchronous
set_false_path -from [get_ports rst_n]

# I/O standards (adjust for your board)
set_property IOSTANDARD LVCMOS18 [get_ports *]

# Optional: Place critical paths
# set_property LOC SLICE_X0Y0 [get_cells u_alu/gen_adders[0].u_btfa]
EOF
```

## Weeks 11-14: Implementation and Benchmarking

### Step 11.1: Create Vivado TCL Build Script
```bash
cat > ~/ternary_cmos/project/fpga/scripts/build.tcl << 'EOF'
# Vivado Build Script for Ternary ALU

# Project settings
set project_name "ternary_alu"
set part "xcvu9p-flga2104-2L-e"  # UltraScale+ VU9P
set top_module "ternary_alu_top"

# Create project
create_project $project_name ./build -part $part -force

# Add source files
add_files -norecurse {
    ../src/ternary_pkg.sv
    ../src/btfa.sv
    ../src/ternary_adder.sv
    ../src/ternary_alu.sv
    ../src/ternary_alu_top.sv
}

# Add constraints
add_files -fileset constrs_1 -norecurse ../constraints/ternary_alu.xdc

# Set top module
set_property top $top_module [current_fileset]

# Run synthesis
synth_design -top $top_module -part $part

# Report utilization after synthesis
report_utilization -file reports/synth_utilization.rpt
report_timing_summary -file reports/synth_timing.rpt

# Run implementation
opt_design
place_design
route_design

# Generate reports
report_utilization -file reports/impl_utilization.rpt
report_timing_summary -file reports/impl_timing.rpt
report_power -file reports/impl_power.rpt

# Generate bitstream
write_bitstream -force $project_name.bit

puts "Build complete!"
EOF
```

### Step 11.2: Create Benchmark Test
```bash
cat > ~/ternary_cmos/project/fpga/src/ternary_alu_tb.sv << 'EOF'
// FPGA Testbench for Ternary ALU
// Generates random test vectors and measures throughput

`timescale 1ns/1ps

module ternary_alu_tb;

  // Clock and reset
  logic clk = 0;
  logic rst_n;

  // DUT signals
  logic [15:0] a_bin, b_bin;
  logic [2:0]  op;
  logic        valid_in;
  logic [15:0] result_bin;
  logic [1:0]  carry_bin;
  logic        zero_flag, neg_flag;
  logic        valid_out;

  // Test counters
  int test_count = 0;
  int error_count = 0;
  real start_time, end_time;

  // Clock generation - 100 MHz
  always #5 clk = ~clk;

  // DUT instance
  ternary_alu_top dut (.*);

  // Test sequence
  initial begin
    $display("=== Ternary ALU FPGA Benchmark ===");

    // Reset
    rst_n = 0;
    valid_in = 0;
    a_bin = 0;
    b_bin = 0;
    op = 0;
    #100;
    rst_n = 1;
    #100;

    // Warm up
    repeat (100) begin
      @(posedge clk);
      a_bin = $random;
      b_bin = $random;
      op = $random % 8;
      valid_in = 1;
    end

    // Benchmark - 10000 operations
    start_time = $realtime;

    repeat (10000) begin
      @(posedge clk);
      a_bin = $random;
      b_bin = $random;
      op = $random % 8;
      valid_in = 1;
      test_count++;
    end

    @(posedge clk);
    valid_in = 0;

    // Wait for pipeline to drain
    repeat (10) @(posedge clk);

    end_time = $realtime;

    // Report results
    $display("------------------------------------");
    $display("Total operations: %0d", test_count);
    $display("Total time: %0.2f ns", end_time - start_time);
    $display("Throughput: %0.2f Mops/s", test_count / ((end_time - start_time) / 1e9) / 1e6);
    $display("------------------------------------");

    $finish;
  end

endmodule
EOF
```

---

# PHASE 4: TERNARY CPU CORE (Weeks 15-22)

## Week 15: ISA Definition

### Step 15.1: Create ISA Specification Document
```bash
cat > ~/ternary_cmos/project/docs/specs/btisa_v01.md << 'EOF'
# Balanced Ternary Instruction Set Architecture (BTISA) v0.1

## Overview
- Word size: 27 trits (≈42.8 bits equivalent)
- Register count: 9 general-purpose (R0-R8)
- Memory: Trit-addressable, initial 729 words (3^6)
- Encoding: All instructions are 9 trits

## Register Set
| Register | Name | Description |
|----------|------|-------------|
| R0 | zero | Always zero (hardwired) |
| R1-R7 | t1-t7 | General purpose |
| R8 | ra | Return address |

## Instruction Encoding (9 trits)
```
[8:6] Opcode (3 trits = 27 opcodes possible)
[5:4] Rd     (2 trits = 9 registers)
[3:2] Rs1    (2 trits = 9 registers)
[1:0] Rs2/Imm (2 trits = 9 values or register)
```

## Instruction Set

### Arithmetic Operations (Opcode 0XX)
| Opcode | Mnemonic | Operation | Description |
|--------|----------|-----------|-------------|
| 000 | ADD | Rd = Rs1 + Rs2 | Ternary addition |
| 00+ | SUB | Rd = Rs1 - Rs2 | Ternary subtraction |
| 00- | NEG | Rd = -Rs1 | Negate |
| 0+0 | MUL | Rd = Rs1 × Rs2 | Ternary multiply |
| 0++ | SHL | Rd = Rs1 << 1 | Shift left (×3) |
| 0+- | SHR | Rd = Rs1 >> 1 | Shift right (÷3) |

### Logic Operations (Opcode +XX)
| Opcode | Mnemonic | Operation | Description |
|--------|----------|-----------|-------------|
| +00 | MIN | Rd = MIN(Rs1, Rs2) | Tritwise minimum |
| +0+ | MAX | Rd = MAX(Rs1, Rs2) | Tritwise maximum |
| +0- | XOR | Rd = Rs1 XOR Rs2 | Ternary XOR (mod-3 add) |

### Memory Operations (Opcode -XX)
| Opcode | Mnemonic | Operation | Description |
|--------|----------|-----------|-------------|
| -00 | LD | Rd = Mem[Rs1 + Imm] | Load word |
| -0+ | ST | Mem[Rs1 + Imm] = Rs2 | Store word |
| -0- | LDT | Rd = Mem[Rs1][Imm] | Load trit |
| -+0 | STT | Mem[Rs1][Imm] = Rs2[0] | Store trit |

### Control Flow (Opcode 0-X)
| Opcode | Mnemonic | Operation | Description |
|--------|----------|-----------|-------------|
| 0-0 | BEQ | if Rs1=Rs2: PC += Imm | Branch if equal |
| 0-+ | BNE | if Rs1≠Rs2: PC += Imm | Branch if not equal |
| 0-- | BLT | if Rs1<Rs2: PC += Imm | Branch if less than |
| +-0 | JAL | Rd = PC+1; PC = Rs1+Imm | Jump and link |
| +-- | JR | PC = Rs1 | Jump register |

### System (Opcode --X)
| Opcode | Mnemonic | Operation | Description |
|--------|----------|-----------|-------------|
| --0 | NOP | - | No operation |
| --+ | HALT | - | Halt execution |
| --- | ECALL | - | Environment call |

## Example Assembly
```asm
# Compute Fibonacci(5)
# R1 = n, R2 = fib(n-1), R3 = fib(n-2), R4 = result

    ADD R1, R0, 5    # n = 5 (as balanced ternary: ++-0)
    ADD R2, R0, 1    # fib(1) = 1
    ADD R3, R0, 0    # fib(0) = 0

loop:
    BEQ R1, R0, done # if n == 0, exit
    ADD R4, R2, R3   # result = fib(n-1) + fib(n-2)
    ADD R3, R2, R0   # fib(n-2) = fib(n-1)
    ADD R2, R4, R0   # fib(n-1) = result
    SUB R1, R1, 1    # n = n - 1
    BNE R0, R0, loop # always branch (R0 always equals R0, then negate check)

done:
    HALT
```
EOF
```

### Step 15.2: Create Instruction Encoder/Decoder
```bash
cat > ~/ternary_cmos/project/hdl/rtl/btisa_decoder.sv << 'EOF'
// BTISA Instruction Decoder

module btisa_decoder
  import ternary_pkg::*;
(
  input  trit_t [8:0] instruction,

  output trit_t [2:0] opcode,
  output trit_t [1:0] rd,
  output trit_t [1:0] rs1,
  output trit_t [1:0] rs2_imm,

  output logic        reg_write,
  output logic        mem_read,
  output logic        mem_write,
  output logic        branch,
  output logic        jump,
  output logic        alu_src,  // 0=register, 1=immediate
  output logic [2:0]  alu_op
);

  // Extract fields
  assign opcode  = instruction[8:6];
  assign rd      = instruction[5:4];
  assign rs1     = instruction[3:2];
  assign rs2_imm = instruction[1:0];

  // Decode control signals
  always_comb begin
    // Defaults
    reg_write = 1'b0;
    mem_read  = 1'b0;
    mem_write = 1'b0;
    branch    = 1'b0;
    jump      = 1'b0;
    alu_src   = 1'b0;
    alu_op    = 3'b000;

    // Opcode decoding (simplified)
    case ({opcode[2], opcode[1], opcode[0]})
      // ADD: 000
      {T_ZERO, T_ZERO, T_ZERO}: begin
        reg_write = 1'b1;
        alu_op = 3'b000;
      end

      // SUB: 00+
      {T_ZERO, T_ZERO, T_POS_ONE}: begin
        reg_write = 1'b1;
        alu_op = 3'b001;
      end

      // NEG: 00-
      {T_ZERO, T_ZERO, T_NEG_ONE}: begin
        reg_write = 1'b1;
        alu_op = 3'b010;
      end

      // LD: -00
      {T_NEG_ONE, T_ZERO, T_ZERO}: begin
        reg_write = 1'b1;
        mem_read = 1'b1;
        alu_src = 1'b1;
        alu_op = 3'b000;  // ADD for address calculation
      end

      // ST: -0+
      {T_NEG_ONE, T_ZERO, T_POS_ONE}: begin
        mem_write = 1'b1;
        alu_src = 1'b1;
        alu_op = 3'b000;
      end

      // BEQ: 0-0
      {T_ZERO, T_NEG_ONE, T_ZERO}: begin
        branch = 1'b1;
        alu_op = 3'b001;  // SUB for comparison
      end

      // JAL: +-0
      {T_POS_ONE, T_NEG_ONE, T_ZERO}: begin
        reg_write = 1'b1;
        jump = 1'b1;
      end

      default: begin
        // NOP or invalid
      end
    endcase
  end

endmodule
EOF
```

## Weeks 16-18: Microarchitecture Implementation

### Step 16.1: Create Register File
```bash
cat > ~/ternary_cmos/project/hdl/rtl/ternary_regfile.sv << 'EOF'
// Ternary Register File
// 9 registers × 27 trits each

module ternary_regfile
  import ternary_pkg::*;
#(
  parameter int NUM_REGS = 9,
  parameter int TRIT_WIDTH = 27
)(
  input  logic                     clk,
  input  logic                     rst_n,

  // Read ports
  input  trit_t [1:0]              rs1_addr,
  input  trit_t [1:0]              rs2_addr,
  output trit_t [TRIT_WIDTH-1:0]   rs1_data,
  output trit_t [TRIT_WIDTH-1:0]   rs2_data,

  // Write port
  input  trit_t [1:0]              rd_addr,
  input  trit_t [TRIT_WIDTH-1:0]   rd_data,
  input  logic                     we
);

  // Register storage
  trit_t [TRIT_WIDTH-1:0] regs [NUM_REGS];

  // Address conversion (ternary to integer)
  function automatic int trit2_to_int(trit_t [1:0] addr);
    int result;
    result = 0;
    if (addr[0] == T_POS_ONE) result += 1;
    else if (addr[0] == T_NEG_ONE) result += 2;  // -1 maps to index 2
    if (addr[1] == T_POS_ONE) result += 3;
    else if (addr[1] == T_NEG_ONE) result += 6;
    return result;
  endfunction

  // Read ports (combinational)
  assign rs1_data = regs[trit2_to_int(rs1_addr)];
  assign rs2_data = regs[trit2_to_int(rs2_addr)];

  // Write port (sequential)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset all registers to zero
      for (int i = 0; i < NUM_REGS; i++) begin
        regs[i] <= '{default: T_ZERO};
      end
    end else begin
      // R0 is always zero (don't write)
      if (we && trit2_to_int(rd_addr) != 0) begin
        regs[trit2_to_int(rd_addr)] <= rd_data;
      end
    end
  end

endmodule
EOF
```

### Step 16.2: Create CPU Top Module
```bash
cat > ~/ternary_cmos/project/hdl/rtl/ternary_cpu.sv << 'EOF'
// Balanced Ternary CPU Core
// 4-stage pipeline: IF -> ID -> EX -> WB

module ternary_cpu
  import ternary_pkg::*;
#(
  parameter int TRIT_WIDTH = 27,
  parameter int IMEM_SIZE = 243,  // 3^5 instructions
  parameter int DMEM_SIZE = 729   // 3^6 data words
)(
  input  logic clk,
  input  logic rst_n,

  // Instruction memory interface
  output trit_t [7:0]            imem_addr,
  input  trit_t [8:0]            imem_data,

  // Data memory interface
  output trit_t [8:0]            dmem_addr,
  output trit_t [TRIT_WIDTH-1:0] dmem_wdata,
  input  trit_t [TRIT_WIDTH-1:0] dmem_rdata,
  output logic                   dmem_we,
  output logic                   dmem_re,

  // Status
  output logic                   halted
);

  // Pipeline registers
  // IF/ID
  trit_t [8:0]  if_id_instr;
  trit_t [7:0]  if_id_pc;
  logic         if_id_valid;

  // ID/EX
  trit_t [TRIT_WIDTH-1:0] id_ex_rs1_data;
  trit_t [TRIT_WIDTH-1:0] id_ex_rs2_data;
  trit_t [1:0]            id_ex_rd;
  trit_t [1:0]            id_ex_imm;
  logic [2:0]             id_ex_alu_op;
  logic                   id_ex_reg_write;
  logic                   id_ex_mem_read;
  logic                   id_ex_mem_write;
  logic                   id_ex_alu_src;
  trit_t [7:0]            id_ex_pc;
  logic                   id_ex_valid;

  // EX/WB
  trit_t [TRIT_WIDTH-1:0] ex_wb_result;
  trit_t [1:0]            ex_wb_rd;
  logic                   ex_wb_reg_write;
  logic                   ex_wb_valid;

  // Program counter
  trit_t [7:0] pc;
  trit_t [7:0] next_pc;

  // Decoder outputs
  trit_t [2:0] dec_opcode;
  trit_t [1:0] dec_rd, dec_rs1, dec_rs2_imm;
  logic        dec_reg_write, dec_mem_read, dec_mem_write;
  logic        dec_branch, dec_jump, dec_alu_src;
  logic [2:0]  dec_alu_op;

  // Register file signals
  trit_t [TRIT_WIDTH-1:0] rf_rs1_data, rf_rs2_data;

  // ALU signals
  trit_t [TRIT_WIDTH-1:0] alu_result;
  trit_t                  alu_carry;
  logic                   alu_zero, alu_neg;

  //==========================================================================
  // IF Stage: Instruction Fetch
  //==========================================================================

  assign imem_addr = pc;

  // PC update logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pc <= '{default: T_ZERO};
    end else if (!halted) begin
      pc <= next_pc;
    end
  end

  // Simple PC increment (add 1 in ternary)
  ternary_adder #(.WIDTH(8)) pc_adder (
    .a    (pc),
    .b    ('{T_POS_ONE, default: T_ZERO}),
    .cin  (T_ZERO),
    .sum  (next_pc),
    .cout ()
  );

  // IF/ID pipeline register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      if_id_instr <= '{default: T_ZERO};
      if_id_pc <= '{default: T_ZERO};
      if_id_valid <= 1'b0;
    end else begin
      if_id_instr <= imem_data;
      if_id_pc <= pc;
      if_id_valid <= 1'b1;
    end
  end

  //==========================================================================
  // ID Stage: Instruction Decode
  //==========================================================================

  btisa_decoder u_decoder (
    .instruction (if_id_instr),
    .opcode      (dec_opcode),
    .rd          (dec_rd),
    .rs1         (dec_rs1),
    .rs2_imm     (dec_rs2_imm),
    .reg_write   (dec_reg_write),
    .mem_read    (dec_mem_read),
    .mem_write   (dec_mem_write),
    .branch      (dec_branch),
    .jump        (dec_jump),
    .alu_src     (dec_alu_src),
    .alu_op      (dec_alu_op)
  );

  ternary_regfile #(
    .NUM_REGS   (9),
    .TRIT_WIDTH (TRIT_WIDTH)
  ) u_regfile (
    .clk      (clk),
    .rst_n    (rst_n),
    .rs1_addr (dec_rs1),
    .rs2_addr (dec_rs2_imm),
    .rs1_data (rf_rs1_data),
    .rs2_data (rf_rs2_data),
    .rd_addr  (ex_wb_rd),
    .rd_data  (ex_wb_result),
    .we       (ex_wb_reg_write && ex_wb_valid)
  );

  // ID/EX pipeline register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      id_ex_valid <= 1'b0;
    end else begin
      id_ex_rs1_data <= rf_rs1_data;
      id_ex_rs2_data <= rf_rs2_data;
      id_ex_rd <= dec_rd;
      id_ex_imm <= dec_rs2_imm;
      id_ex_alu_op <= dec_alu_op;
      id_ex_reg_write <= dec_reg_write;
      id_ex_mem_read <= dec_mem_read;
      id_ex_mem_write <= dec_mem_write;
      id_ex_alu_src <= dec_alu_src;
      id_ex_pc <= if_id_pc;
      id_ex_valid <= if_id_valid;
    end
  end

  //==========================================================================
  // EX Stage: Execute
  //==========================================================================

  // ALU operand B selection
  trit_t [TRIT_WIDTH-1:0] alu_b;
  assign alu_b = id_ex_alu_src ?
                 {{(TRIT_WIDTH-2){T_ZERO}}, id_ex_imm} :
                 id_ex_rs2_data;

  ternary_alu #(.WIDTH(TRIT_WIDTH)) u_alu (
    .a         (id_ex_rs1_data),
    .b         (alu_b),
    .op        (id_ex_alu_op),
    .result    (alu_result),
    .carry     (alu_carry),
    .zero_flag (alu_zero),
    .neg_flag  (alu_neg)
  );

  // Data memory interface
  assign dmem_addr = alu_result[8:0];
  assign dmem_wdata = id_ex_rs2_data;
  assign dmem_we = id_ex_mem_write && id_ex_valid;
  assign dmem_re = id_ex_mem_read && id_ex_valid;

  // EX/WB pipeline register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ex_wb_valid <= 1'b0;
    end else begin
      ex_wb_result <= id_ex_mem_read ? dmem_rdata : alu_result;
      ex_wb_rd <= id_ex_rd;
      ex_wb_reg_write <= id_ex_reg_write;
      ex_wb_valid <= id_ex_valid;
    end
  end

  //==========================================================================
  // Control
  //==========================================================================

  // Halt detection (simplified)
  assign halted = (if_id_instr == '{T_NEG_ONE, T_NEG_ONE, T_POS_ONE,
                                    default: T_ZERO});

endmodule
EOF
```

---

# PHASE 5: PUBLICATION & DOCUMENTATION (Weeks 23-26)

## Week 23: Benchmarking

### Step 23.1: Create Benchmark Suite
```bash
cat > ~/ternary_cmos/project/docs/benchmarks/benchmark_results.md << 'EOF'
# Ternary CPU Benchmark Results

## Test Environment
- FPGA: Xilinx VU9P UltraScale+
- Clock: [Measured] MHz
- Process: SKY130 (simulation) / FPGA (actual)

## Cell-Level Metrics

### Transistor Counts
| Cell | Target | Achieved | Status |
|------|--------|----------|--------|
| STI | 6 | | |
| PTI | 6 | | |
| NTI | 6 | | |
| BTFA | 42 | | |

### Timing (Simulation)
| Cell | 0→1 (ps) | 1→2 (ps) | 2→1 (ps) | 1→0 (ps) |
|------|----------|----------|----------|----------|
| STI | | | | |
| PTI | | | | |
| BTFA | | | | |

## ALU-Level Metrics

### FPGA Utilization
| Resource | Used | Available | % |
|----------|------|-----------|---|
| LUTs | | | |
| FFs | | | |
| BRAM | | | |
| DSP | | | |

### Performance
| Metric | Value |
|--------|-------|
| Fmax | MHz |
| Throughput | Mops/s |
| Power | W |

## Comparison with Literature

### vs Binary Equivalent
| Metric | Ternary | Binary | Improvement |
|--------|---------|--------|-------------|
| Transistors (adder) | | | |
| LUTs (FPGA) | | | |
| Info density | 1.585 bits/trit | 1 bit/bit | 58.5% |

### vs Other Ternary Implementations
| Work | Technology | Transistors | Delay | PDP |
|------|------------|-------------|-------|-----|
| This work | Multi-Vth CMOS | | | |
| Ko et al. | T-CMOS | 42 | | |
| CNTFET [ref] | CNTFET | 56+ | | |
EOF
```

## Weeks 24-25: Paper Writing

### Step 24.1: Create Paper Outline
```bash
cat > ~/ternary_cmos/project/docs/papers/paper_outline.md << 'EOF'
# Paper: Balanced Ternary CPU on Multi-Threshold CMOS

## Target Venue
- Primary: IEEE Transactions on VLSI Systems
- Secondary: IEEE Access
- Conference: ISMVL (Int'l Symposium on Multiple-Valued Logic)

## Abstract (150 words)
[Key contributions, main results, significance]

## 1. Introduction (1.5 pages)
- Moore's Law slowdown motivation
- Information density argument (log2(3) = 1.585)
- Balanced ternary advantages for arithmetic
- Contributions:
  1. Complete GT-LOGIC cell library on SKY130
  2. Ternary synthesis methodology
  3. First balanced ternary CPU on FPGA
  4. Open-source release

## 2. Background (2 pages)
### 2.1 Balanced Ternary Arithmetic
- Representation: {-1, 0, +1}
- Negation = sign flip
- No two's complement needed
- Knuth's truncation = rounding property

### 2.2 Multi-Threshold CMOS for Ternary Logic
- LVT/SVT/HVT device combinations
- Voltage levels: 0V, VDD/2, VDD
- Prior work comparison

### 2.3 Related Work
- T-CMOS (Ko et al.)
- CNTFET approaches
- Memristor-based ternary
- FPGA emulation methods

## 3. GT-LOGIC Cell Library (3 pages)
### 3.1 Standard Ternary Inverter (STI)
- Circuit topology
- Noise margin analysis
- Monte Carlo results

### 3.2 Threshold Inverters (PTI, NTI)
- Threshold shift mechanism
- Use in decoding

### 3.3 Arithmetic Cells
- BTFA design (42 transistors)
- Carry propagation analysis

### 3.4 Characterization Methodology
- 6-transition timing model
- Liberty file generation

## 4. Ternary Synthesis Flow (2 pages)
### 4.1 HDL Encoding
- 2-bit representation
- Ternary package definition

### 4.2 GT-LOGIC Mapping
- Synthesis algorithm
- Technology mapping

## 5. CPU Architecture (3 pages)
### 5.1 ISA Design (BTISA)
- Instruction format
- Operation set

### 5.2 Microarchitecture
- 4-stage pipeline
- Register file design
- Memory interface

## 6. Implementation Results (3 pages)
### 6.1 SPICE Validation
- Cell-level results
- Corner analysis

### 6.2 FPGA Implementation
- Resource utilization
- Timing results
- Power measurements

### 6.3 Comparison
- vs Binary equivalent
- vs Other ternary work

## 7. Conclusion (0.5 pages)
- Summary of contributions
- Future work: ASIC tapeout

## References (30-40 citations)
EOF
```

## Week 26: Open-Source Release

### Step 26.1: Create GitHub Repository Structure
```bash
cat > ~/ternary_cmos/project/README.md << 'EOF'
# Balanced Ternary CMOS CPU

Open-source implementation of a balanced ternary (-1, 0, +1) CPU using multi-threshold CMOS technology.

## Features
- Complete GT-LOGIC cell library (SPICE + Liberty)
- Ternary synthesis flow
- 8-trit ALU with full operations
- Minimal ternary CPU (BTISA v0.1)
- FPGA prototype on Xilinx UltraScale+

## Repository Structure
```
├── spice/           # SPICE cell library
│   ├── cells/       # Cell definitions
│   ├── testbenches/ # Validation testbenches
│   └── models/      # Device models
├── hdl/             # HDL source code
│   ├── rtl/         # Synthesizable RTL
│   └── tb/          # Testbenches
├── fpga/            # FPGA implementation
│   ├── src/         # FPGA-specific RTL
│   └── constraints/ # Timing constraints
├── asic/            # ASIC cell library
│   └── lib/         # Liberty files
├── docs/            # Documentation
│   ├── specs/       # Specifications
│   └── papers/      # Publications
└── tools/           # Scripts and tools
    └── synthesis/   # Synthesis scripts
```

## Quick Start

### Prerequisites
- ngspice v45+
- Icarus Verilog or Verilator
- Vivado (for FPGA)
- SKY130 PDK

### Simulation
```bash
cd spice/testbenches
ngspice tb_sti.spice

cd hdl/sim
./run_sim.sh
```

### FPGA Build
```bash
cd fpga/scripts
vivado -mode tcl -source build.tcl
```

## Citation
If you use this work, please cite:
```bibtex
@article{ternary_cpu_2025,
  title={Balanced Ternary CPU on Multi-Threshold CMOS},
  author={...},
  journal={...},
  year={2025}
}
```

## License
MIT License

## Acknowledgments
- SKY130 PDK by Google/SkyWater
- GT-LOGIC methodology references
- Ko et al. T-CMOS work
EOF
```

---

# PHASE 6: ASIC FABRICATION (Weeks 27+)

## ASIC Preparation Steps

### Step 27.1: OpenLane Setup
```bash
# Install OpenLane
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane
make

# Set up SKY130 PDK for OpenLane
export PDK_ROOT=/path/to/pdks
export PDK=sky130A
```

### Step 27.2: Create OpenLane Configuration
```bash
cat > ~/ternary_cmos/project/asic/openlane/config.json << 'EOF'
{
    "DESIGN_NAME": "ternary_alu_top",
    "VERILOG_FILES": "dir::src/*.sv",
    "CLOCK_PORT": "clk",
    "CLOCK_PERIOD": 20.0,
    "DIE_AREA": "0 0 500 500",
    "FP_SIZING": "absolute",
    "PL_TARGET_DENSITY": 0.5,

    "LIB_SYNTH": "dir::lib/gt_logic_ternary.lib",
    "LIB_FASTEST": "dir::lib/gt_logic_ternary_ff.lib",
    "LIB_SLOWEST": "dir::lib/gt_logic_ternary_ss.lib",

    "EXTRA_LEFS": "dir::lef/gt_logic_cells.lef",
    "EXTRA_GDS_FILES": "dir::gds/gt_logic_cells.gds",

    "SYNTH_STRATEGY": "DELAY 0",
    "PL_BASIC_PLACEMENT": 1,
    "FP_CORE_UTIL": 40,

    "ROUTING_CORES": 4,
    "RUN_KLAYOUT_XOR": 0
}
EOF
```

### Step 27.3: Efabless Caravel Integration
```bash
# Clone Caravel user project template
git clone https://github.com/efabless/caravel_user_project.git
cd caravel_user_project

# Copy ternary design files
cp -r ~/ternary_cmos/project/asic/openlane/* openlane/ternary_alu/
cp -r ~/ternary_cmos/project/hdl/rtl/* verilog/rtl/

# Run precheck
make precheck
make run-precheck
```

---

# APPENDIX A: Complete File Checklist

## Phase 1 Deliverables
- [ ] `spice/models/sky130_models.spice`
- [ ] `spice/cells/sti.spice`
- [ ] `spice/cells/pti.spice`
- [ ] `spice/cells/nti.spice`
- [ ] `spice/cells/tmin.spice`
- [ ] `spice/cells/tmax.spice`
- [ ] `spice/cells/tnand.spice`
- [ ] `spice/cells/tnor.spice`
- [ ] `spice/cells/tsum.spice`
- [ ] `spice/cells/tmux3.spice`
- [ ] `spice/cells/btha.spice`
- [ ] `spice/cells/btfa.spice`
- [ ] `spice/testbenches/tb_*.spice`
- [ ] `asic/lib/gt_logic_ternary.lib`
- [ ] `docs/specs/gt_logic_cells.md`

## Phase 2 Deliverables
- [ ] `hdl/rtl/ternary_pkg.sv`
- [ ] `hdl/rtl/btfa.sv`
- [ ] `hdl/rtl/ternary_adder.sv`
- [ ] `hdl/rtl/ternary_alu.sv`
- [ ] `hdl/tb/tb_btfa.sv`
- [ ] `tools/synthesis/ternary_synth.py`

## Phase 3 Deliverables
- [ ] `fpga/src/ternary_alu_top.sv`
- [ ] `fpga/constraints/ternary_alu.xdc`
- [ ] `fpga/scripts/build.tcl`
- [ ] `fpga/bitstreams/ternary_alu.bit`

## Phase 4 Deliverables
- [ ] `docs/specs/btisa_v01.md`
- [ ] `hdl/rtl/btisa_decoder.sv`
- [ ] `hdl/rtl/ternary_regfile.sv`
- [ ] `hdl/rtl/ternary_cpu.sv`

## Phase 5 Deliverables
- [ ] `docs/benchmarks/benchmark_results.md`
- [ ] `docs/papers/paper_outline.md`
- [ ] `README.md`

## Phase 6 Deliverables
- [ ] `asic/openlane/config.json`
- [ ] `asic/lef/gt_logic_cells.lef`
- [ ] `asic/gds/gt_logic_cells.gds`

---

# APPENDIX B: Key References

1. Ko et al., "Exploration of Ternary Logic Using T-CMOS" (IEEE 10167755)
2. Park et al., "GT-LOGIC RTL Synthesis" (IEEE Access 2025)
3. Shin et al., "T-CMOS Compact Model" (ISMVL 2017)
4. SKY130 PDK Documentation
5. OpenLane Documentation
6. Efabless Caravel Documentation

---

**Document Version**: 1.0
**Last Updated**: 2025-12-16
**Status**: Ready for Implementation
