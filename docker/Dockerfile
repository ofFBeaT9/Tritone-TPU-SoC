# ============================================================================
# Docker Environment for SKY130 BSIM4 SPICE Simulation
# ============================================================================
# Tritone Ternary Processor - Multi-Vth STI Characterization
#
# Features:
#   - ngspice 42 with full BSIM4 support
#   - SKY130 PDK models
#   - Python for post-processing
#   - Automated PVT sweep scripts
#
# Build: docker build -t tritone-spice .
# Run:   docker run -v $(pwd)/..:/tritone -it tritone-spice
# ============================================================================

FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ngspice \
    python3 \
    python3-pip \
    python3-numpy \
    python3-matplotlib \
    git \
    wget \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Verify ngspice version and BSIM4 support
RUN ngspice --version

# Create working directories
RUN mkdir -p /tritone/spice/results

# Set working directory
WORKDIR /tritone

# Copy simulation scripts
COPY run_bsim4_sim.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run_bsim4_sim.sh

# Default command
CMD ["/bin/bash"]
