● Let me quantify the temperature improvement needed, then compare the two options.

  ---
  How Much Temperature Improvement Is Needed?

  Current State vs. Target

  | Metric              | Current Performance    | Target Spec | Gap                   |
  |---------------------|------------------------|-------------|-----------------------|
  | Mid-level at 27°C   | 0.974V (74mV error)    | 0.9V ±50mV  | ✓ PASS                |
  | Mid-level at -40°C  | 0.366V (534mV error)   | 0.9V ±100mV | 434mV to fix          |
  | Mid-level at +125°C | 1.432V (532mV error)   | 0.9V ±100mV | 432mV to fix          |
  | Total swing         | 1.066V (0.366V→1.432V) | 0.2V max    | 5.3x reduction needed |

  Noise Margin Impact

  The mid-level error directly erodes noise margins:

  At 27°C:   NMM ≈ 28mV   (barely acceptable, target >50mV)
  At -40°C:  NMM ≈ -400mV (NEGATIVE - logic FAILS)
  At +125°C: NMM ≈ -400mV (NEGATIVE - logic FAILS)

  When mid-level shifts to 0.366V at cold, it's indistinguishable from logic LOW (0V). When it shifts to 1.432V at hot, it's indistinguishable from logic HIGH (1.8V). The ternary logic becomes binary at temperature extremes.

  Quantified Improvement Targets

  | Operating Range | Temperature Span | Required Stability | Difficulty       |
  |-----------------|------------------|--------------------|------------------|
  | Lab/Demo        | 20-30°C          | ±50mV              | Already achieved |
  | Consumer        | 0°C to +70°C     | ±100mV             | ~3x improvement  |
  | Commercial      | -10°C to +85°C   | ±100mV             | ~4x improvement  |
  | Industrial      | -40°C to +125°C  | ±100mV             | 5.3x improvement |

  Bottom line: You need to reduce mid-level variation from 1.066V total swing down to <200mV total swing — roughly 5x improvement for industrial grade.

  ---
  Option 1 vs Option 2 Comparison

  Option 1: 3-Rail Power Supply (Explicit VMID Rail)

  Concept: Route VDD, VSS, and VMID (0.9V) as three separate power rails.

          VDD (1.8V)
             │
      ┌──────┴──────┐
      │   STI_3RAIL │
      │             │──── out
      │   in ───────│
      │             │
      └──────┬──────┘
             │
          VMID (0.9V) ←── External/regulated supply
             │
          VSS (0V)

  Temperature Performance:
  | Temp   | Mid-Level Output | Error | Status |
  |--------|------------------|-------|--------|
  | -40°C  | 0.9V             | 0mV   | ✓      |
  | +27°C  | 0.9V             | 0mV   | ✓      |
  | +125°C | 0.9V             | 0mV   | ✓      |

  VMID is a supply rail — it doesn't drift with temperature (assuming decent regulation).

  ---
  Option 2: Bandgap-Referenced VMID Generation

  Concept: Generate stable 0.9V on-chip using bandgap reference + voltage divider/buffer.

                      ┌─────────────────┐
      VDD (1.8V) ────►│  Bandgap Ref    │────► 1.25V (temp-stable)
                      │  (~1.25V)       │         │
                      └─────────────────┘         ▼
                                           ┌──────────┐
                                           │ Resistor │
                                           │ Divider  │────► 0.9V (VMID)
                                           │ + Buffer │
                                           └──────────┘
                                                 │
                                                 ▼
                                        Distributed to STI cells

  Temperature Performance (typical bandgap):
  | Temp   | Bandgap Output | VMID (scaled) | Error |
  |--------|----------------|---------------|-------|
  | -40°C  | 1.25V ±2mV     | 0.9V ±1.5mV   | <2mV  |
  | +27°C  | 1.25V          | 0.9V          | 0mV   |
  | +125°C | 1.25V ±3mV     | 0.9V ±2mV     | <3mV  |

  ---
  Head-to-Head Comparison

  | Criteria              | Option 1: 3-Rail Supply    | Option 2: Bandgap VMID      |
  |-----------------------|----------------------------|-----------------------------|
  | Temperature stability | Depends on external supply | <5mV over full range        |
  | Design complexity     | Low (routing only)         | Medium (analog design)      |
  | Area overhead         | ~50% more power grid       | ~500-2000 µm² for bandgap   |
  | Power overhead        | Negligible                 | ~1-10 µW static             |
  | Routing impact        | +1 power rail everywhere   | Only to distribution points |
  | External dependency   | Needs 0.9V supply          | Self-contained              |
  | SKY130 feasibility    | Trivial                    | Bandgap IPs available       |
  | ASAP7 feasibility     | Trivial                    | Requires analog design      |
  | Time to implement     | Days                       | Weeks                       |

  ---
  Key Differentiator: Where Does VMID Come From?

  Option 1: External VMID

  Board-level:  VDD ──┬── 1.8V to chip
                      │
                LDO ──┴── 0.9V to chip (VMID)
                      │
                VSS ──┴── 0V to chip
  - Pro: Zero on-chip overhead
  - Con: Requires 3-pin power (or on-board regulator), board complexity

  Option 2: Internal VMID Generation

  Board-level:  VDD ──── 1.8V to chip
                VSS ──── 0V to chip

  On-chip:      VDD ──► Bandgap ──► VMID (0.9V) ──► Distributed internally
  - Pro: Standard 2-pin power, self-contained
  - Con: On-chip area and power for bandgap

  ---
  My Analysis

  Option 1 is simpler but shifts complexity to the board/system level.

  Option 2 is more complex but gives you a fully self-contained chip.

  For Tritone specifically:

  | Factor                 | Recommendation                                      |
  |------------------------|-----------------------------------------------------|
  | For FPGA prototyping   | Option 1 — FPGAs already have multiple supply rails |
  | For ASIC (SKY130)      | Option 2 — SKY130 has open-source bandgap IPs       |
  | For publication        | Either works — document the approach                |
  | For commercial product | Option 2 — customers expect 2-pin power             |

  ---
  Practical Recommendation

  Given Tritone's current state (research/publication phase), I'd suggest:

  1. Short-term: Use Option 1 for immediate validation
    - Your 3-rail STI already exists and is validated
    - Proves temperature independence without analog complexity
    - Good enough for FPGA demo and paper claims
  2. Medium-term: Implement Option 2 for ASIC tapeout
    - SKY130 has sky130_fd_io__top_power_lvc_wpad with bandgap
    - Or use open-source bandgap from https://github.com/ArtisticZhao/sky130_bm_bandgap
    - Makes chip self-contained

  The paper already acknowledges this: Section VII lists "Temperature compensation circuits" as future work. Either option satisfies that requirement.

  Would you like me to explore the SKY130 bandgap options, or detail the 3-rail power grid implementation?
