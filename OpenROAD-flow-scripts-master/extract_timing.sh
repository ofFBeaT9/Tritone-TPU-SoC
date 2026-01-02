#!/bin/bash
# ============================================================
# Tritone TPU SoC - Timing Extraction Script
# ============================================================
# Extracts timing data from OpenROAD flow results
#
# Usage: ./extract_timing.sh
#
# Date: Jan 2026
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_BASE="${SCRIPT_DIR}/flow/results"
OUTPUT_FILE="${SCRIPT_DIR}/asic_results/timing_summary.md"

echo "============================================================"
echo "Tritone SoC - Physical Timing Data Extraction"
echo "============================================================"
echo ""

# Create output directory
mkdir -p "${SCRIPT_DIR}/asic_results"

# Start markdown report
cat > "${OUTPUT_FILE}" << 'EOF'
# Tritone SoC Physical Timing Results

Generated: $(date)

## Summary

This report contains physical timing data from OpenROAD synthesis and P&R flows
for the Tritone SoC + TPU 64×64 design across multiple process nodes and frequencies.

---

## ASAP7 7nm Results

| Variant | Clock | Period (ps) | WNS (ps) | TNS (ps) | Cells | Area (um²) | Status |
|---------|-------|-------------|----------|----------|-------|------------|--------|
EOF

# Function to extract timing from a results directory
extract_timing() {
    local PDK=$1
    local DESIGN=$2
    local VARIANT=$3
    local CLOCK=$4
    local PERIOD=$5

    local RESULT_DIR="${RESULTS_BASE}/${PDK}/${DESIGN}/${VARIANT}"
    local REPORT="${RESULT_DIR}/base/6_report.log"
    local FINAL_RPT="${RESULT_DIR}/base/6_final.rpt"

    if [ ! -d "${RESULT_DIR}" ]; then
        echo "| ${VARIANT} | ${CLOCK} | ${PERIOD} | N/A | N/A | N/A | N/A | NOT RUN |" >> "${OUTPUT_FILE}"
        return
    fi

    # Try to extract WNS/TNS from various report formats
    local WNS="N/A"
    local TNS="N/A"
    local CELLS="N/A"
    local AREA="N/A"
    local STATUS="UNKNOWN"

    # Check for timing reports
    if [ -f "${REPORT}" ]; then
        WNS=$(grep -i "wns" "${REPORT}" 2>/dev/null | head -1 | grep -oE '[-]?[0-9]+\.?[0-9]*' | head -1)
        TNS=$(grep -i "tns" "${REPORT}" 2>/dev/null | head -1 | grep -oE '[-]?[0-9]+\.?[0-9]*' | head -1)
    fi

    if [ -f "${FINAL_RPT}" ]; then
        WNS=${WNS:-$(grep -i "worst.*slack" "${FINAL_RPT}" 2>/dev/null | head -1 | grep -oE '[-]?[0-9]+\.?[0-9]*' | head -1)}
        CELLS=$(grep -i "cell.*count\|number.*cells" "${FINAL_RPT}" 2>/dev/null | head -1 | grep -oE '[0-9]+' | head -1)
        AREA=$(grep -i "design.*area\|total.*area" "${FINAL_RPT}" 2>/dev/null | head -1 | grep -oE '[0-9]+\.?[0-9]*' | head -1)
    fi

    # Check for metrics.json (more reliable)
    local METRICS="${RESULT_DIR}/base/6_report.json"
    if [ -f "${METRICS}" ]; then
        WNS=$(grep -o '"finish__timing__setup__ws"[^,]*' "${METRICS}" 2>/dev/null | grep -oE '[-]?[0-9]+\.?[0-9]*')
        TNS=$(grep -o '"finish__timing__setup__tns"[^,]*' "${METRICS}" 2>/dev/null | grep -oE '[-]?[0-9]+\.?[0-9]*')
        CELLS=$(grep -o '"finish__design__instance__count"[^,]*' "${METRICS}" 2>/dev/null | grep -oE '[0-9]+')
        AREA=$(grep -o '"finish__design__instance__area"[^,]*' "${METRICS}" 2>/dev/null | grep -oE '[0-9]+\.?[0-9]*')
    fi

    # Determine status
    if [ "${WNS}" != "N/A" ] && [ "${WNS}" != "" ]; then
        # Check if WNS is negative (timing violation)
        if [[ "${WNS}" == -* ]]; then
            STATUS="VIOLATION"
        else
            STATUS="MET"
        fi
    fi

    # Default values
    WNS=${WNS:-"N/A"}
    TNS=${TNS:-"N/A"}
    CELLS=${CELLS:-"N/A"}
    AREA=${AREA:-"N/A"}

    echo "| ${VARIANT} | ${CLOCK} | ${PERIOD} | ${WNS} | ${TNS} | ${CELLS} | ${AREA} | ${STATUS} |" >> "${OUTPUT_FILE}"
}

# Extract ASAP7 results
echo "Extracting ASAP7 results..."
extract_timing "asap7" "tritone_soc" "baseline" "1.0 GHz" "1000"
extract_timing "asap7" "tritone_soc" "aggressive" "1.5 GHz" "667"
extract_timing "asap7" "tritone_soc_v2" "maxperf" "2.0 GHz" "500"

# Add Sky130 section
cat >> "${OUTPUT_FILE}" << 'EOF'

---

## Sky130 130nm Results

| Variant | Clock | Period (ps) | WNS (ps) | TNS (ps) | Cells | Area (um²) | Status |
|---------|-------|-------------|----------|----------|-------|------------|--------|
EOF

# Extract Sky130 results
echo "Extracting Sky130 results..."
extract_timing "sky130hd" "tritone_soc" "baseline" "150 MHz" "6667"
extract_timing "sky130hd" "tritone_soc" "aggressive" "200 MHz" "5000"

# Add critical path section
cat >> "${OUTPUT_FILE}" << 'EOF'

---

## Critical Path Analysis

### ASAP7 2 GHz Critical Path

EOF

# Try to extract critical path
CRIT_PATH_FILE="${RESULTS_BASE}/asap7/tritone_soc_v2/maxperf/base/6_report.log"
if [ -f "${CRIT_PATH_FILE}" ]; then
    echo '```' >> "${OUTPUT_FILE}"
    grep -A 30 "Critical Path\|Worst Path\|setup.*path" "${CRIT_PATH_FILE}" 2>/dev/null | head -35 >> "${OUTPUT_FILE}"
    echo '```' >> "${OUTPUT_FILE}"
else
    echo "*Critical path data not available - run maxperf flow first*" >> "${OUTPUT_FILE}"
fi

cat >> "${OUTPUT_FILE}" << 'EOF'

### Sky130 200 MHz Critical Path

EOF

CRIT_PATH_SKY="${RESULTS_BASE}/sky130hd/tritone_soc/aggressive/base/6_report.log"
if [ -f "${CRIT_PATH_SKY}" ]; then
    echo '```' >> "${OUTPUT_FILE}"
    grep -A 30 "Critical Path\|Worst Path\|setup.*path" "${CRIT_PATH_SKY}" 2>/dev/null | head -35 >> "${OUTPUT_FILE}"
    echo '```' >> "${OUTPUT_FILE}"
else
    echo "*Critical path data not available - run aggressive flow first*" >> "${OUTPUT_FILE}"
fi

# Add power section
cat >> "${OUTPUT_FILE}" << 'EOF'

---

## Power Estimates

| PDK | Variant | Dynamic (mW) | Leakage (mW) | Total (mW) |
|-----|---------|--------------|--------------|------------|
EOF

# Try to extract power data
for PDK in asap7 sky130hd; do
    for VARIANT in baseline aggressive maxperf; do
        if [ "${PDK}" == "sky130hd" ] && [ "${VARIANT}" == "maxperf" ]; then
            continue  # Sky130 doesn't have maxperf
        fi

        POWER_FILE="${RESULTS_BASE}/${PDK}/tritone_soc/${VARIANT}/base/6_report.json"
        if [ -f "${POWER_FILE}" ]; then
            DYN=$(grep -o '"finish__power__total"[^,]*' "${POWER_FILE}" 2>/dev/null | grep -oE '[0-9]+\.?[0-9]*')
            LEAK=$(grep -o '"finish__power__leakage"[^,]*' "${POWER_FILE}" 2>/dev/null | grep -oE '[0-9]+\.?[0-9]*')
            DYN=${DYN:-"N/A"}
            LEAK=${LEAK:-"N/A"}
            if [ "${DYN}" != "N/A" ] && [ "${LEAK}" != "N/A" ]; then
                TOTAL=$(echo "${DYN} + ${LEAK}" | bc 2>/dev/null || echo "N/A")
            else
                TOTAL="N/A"
            fi
            echo "| ${PDK} | ${VARIANT} | ${DYN} | ${LEAK} | ${TOTAL} |" >> "${OUTPUT_FILE}"
        fi
    done
done

# Footer
cat >> "${OUTPUT_FILE}" << 'EOF'

---

## Notes

- **WNS (Worst Negative Slack):** Negative values indicate timing violations
- **TNS (Total Negative Slack):** Sum of all negative slacks
- **MET:** Timing constraints satisfied (WNS >= 0)
- **VIOLATION:** Timing constraints not met (WNS < 0)

## Log Files

- ASAP7 1.0 GHz: `asic_results/asap7_1ghz.log`
- ASAP7 1.5 GHz: `asic_results/asap7_1500mhz.log`
- ASAP7 2.0 GHz: `asic_results/asap7_2ghz.log`
- Sky130 150 MHz: `asic_results/sky130_150mhz.log`
- Sky130 200 MHz: `asic_results/sky130_200mhz.log`

---

*Generated by Tritone SoC Physical Design Flow*
EOF

echo ""
echo "============================================================"
echo "Timing extraction complete!"
echo "============================================================"
echo ""
echo "Report saved to: ${OUTPUT_FILE}"
echo ""
cat "${OUTPUT_FILE}"
