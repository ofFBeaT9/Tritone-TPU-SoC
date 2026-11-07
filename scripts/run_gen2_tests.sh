#!/bin/bash
# TTPU-Gen2 regression on Verilator (OSS CAD Suite): the SEC register test and the existing TPU v2 / SoC v2 test benches.
# Usage: scripts/run_gen2_tests.sh [build dir]   (from the repository root)
cd "$(dirname "$0")/../hdl"
B=${1:-/tmp/ttpu_gen2_build}; mkdir -p $B
FILES="rtl/ternary_pkg.sv rtl/tpu/ternary_mac.sv rtl/tpu/ternary_pe.sv rtl/tpu/ternary_systolic_array.sv rtl/tpu/ternary_pe_cluster.sv"
for t in tpu/tb_ttpu_gen2_sec soc/tb_tritone_soc_v2 tpu/tb_tpu_benchmarks tpu/tb_tpu_banking tpu/tb_tpu_64x64; do
  n=$(basename $t)
  verilator --binary --timing -Wno-fatal -Wno-lint -Wno-style -Irtl -y rtl -y rtl/tpu -y rtl/soc --top-module $n \
    --Mdir $B/$n -j 2 $FILES tb/$t.sv > $B/$n.build.log 2>&1 || { echo "$n: BUILD FAILED"; continue; }
  (cd $B && timeout 1200 ./$n/V$n > $B/$n.run.log 2>&1)
  echo "$n: $(grep -E 'ALL TESTS PASSED|SOME TESTS FAILED|TOPS VERIFICATION PASSED|Errors: [0-9]+|Failed: +[0-9]+' $B/$n.run.log | tail -2 | tr '\n' ' ')"
done
