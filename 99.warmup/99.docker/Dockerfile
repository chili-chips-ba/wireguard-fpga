# Base stage for common tools and dependencies
FROM ubuntu:22.04 AS base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.cargo/bin:/usr/local/bin:$PATH"

# Install common dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf bc bison build-essential ca-certificates ccache flex file git help2man \
    libfl2 libfl-dev libgoogle-perftools-dev numactl perl python3 python3-pip zlib1g \
    wget curl tar openocd meson gperf desktop-file-utils libgtk-3-dev libbz2-dev \
    libjudy-dev libgirepository1.0-dev libgtk-4-dev gnupg libgmp-dev netbase \
    software-properties-common libssl-dev cargo clang lld libreadline-dev gawk \
    tcl-dev libffi-dev graphviz xdot sudo pkg-config libboost-system-dev \
    libboost-python-dev libboost-filesystem-dev texinfo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python tools
RUN python3 -m pip install meson ninja peakrdl

#======================================================#
#                       Verible                        #
#======================================================#
RUN mkdir -p /opt/verible && \
    wget -O /opt/verible/verible.tar.gz "https://github.com/chipsalliance/verible/releases/download/v0.0-3860-gf3da2ce6/verible-v0.0-3860-gf3da2ce6-linux-static-x86_64.tar.gz" && \
    tar -xzf /opt/verible/verible.tar.gz -C /opt/verible --strip-components=1 && \
    ln -s /opt/verible/bin/* /usr/local/bin && \
    rm /opt/verible/verible.tar.gz

# ===== Verilator stage ===== #
FROM base AS verilator

#======================================================#
#                       Verilator                      #
#======================================================#
RUN git clone --depth 1 https://github.com/verilator/verilator.git && \
    cd verilator && \
    autoconf && ./configure && \
    make -j$(nproc) && make install && \
    rm -rf /verilator

# ==== Yosys stage ==== #
FROM base AS yosys

#======================================================#
#                        yosys                         #
#======================================================#
RUN git clone --depth 1 https://github.com/YosysHQ/yosys.git && \
    cd yosys && \
    make config-clang && git submodule update --init && \
    make -j$(nproc) && make install && \
    rm -rf /yosys

# ===== Final stage combining everything ===== #
FROM base AS final

# Copy Verilator and Yosys from their respective stages
COPY --from=verilator /usr/local /usr/local
COPY --from=yosys /usr/local /usr/local

# Additional repositories for FPGA and memory modeling
RUN git config --global http.postBuffer 1048576000 && \
    git config --global core.compression 0 && \
    git config --global http.lowSpeedLimit 0 && \
    git config --global http.lowSpeedTime 999 && \
    git clone https://github.com/chili-chips-ba/wireguard-fpga.git /wireguard-fpga && \
    git clone https://github.com/wyvernSemi/vproc.git /vproc && \
    git clone https://github.com/wyvernSemi/mem_model.git /mem_model && \
    git clone https://github.com/wyvernSemi/tcpIpPg.git /tcpIpPg

#======================================================#
#                   RISC-V GNU Toolchain               #
#======================================================#
#RUN git clone --depth 1 https://github.com/riscv/riscv-gnu-toolchain.git && \
#    cd riscv-gnu-toolchain && ./configure --prefix=/opt/riscv && make linux -j$(nproc)

#======================================================#
#                       PipelineC                      #
#======================================================#
RUN git clone --depth 1 https://github.com/JulianKemmerer/PipelineC.git && \
    echo 'export PATH=$PATH:/PipelineC/src' >> /etc/profile


#======================================================#
#                         sv2v                         #
#======================================================#
RUN curl -sSL https://get.haskellstack.org/ | sh -s - -f && \
    git clone --depth 1 https://github.com/zachjs/sv2v.git && \
    cd sv2v && make

#======================================================#
#                     CDC Snitch                       #
#======================================================#
RUN git clone --depth 1 https://github.com/BerkeleyLab/Bedrock.git

#======================================================#
#                       surfer                         #
#======================================================#
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y && \
    rustup update && \
    cargo install --git https://gitlab.com/surfer-project/surfer surfer


#======================================================#
#                   ibex demo system                   #
#======================================================#
RUN git clone --depth 1 https://github.com/lowRISC/ibex-demo-system.git

#======================================================#
#                        ibex                          #
#======================================================#
RUN git clone https://github.com/lowRISC/ibex.git

#======================================================#
#                     bringup bench                    #
#======================================================#
RUN git clone https://github.com/toddmaustin/bringup-bench.git

#======================================================#
#                 FPGADesignElements                   #
#======================================================#
RUN git clone https://github.com/laforest/FPGADesignElements.git

# Set the working directory
WORKDIR /workspace

#======================================================#
#               LXQT Desktop Environment              #
#======================================================#

RUN apt-get update && apt-get install -y --no-install-recommends \
        lxqt-core qtwayland5 xfwm4 \
        featherpad lxqt-about lxqt-config lxqt-qtplugin \
        pavucontrol-qt qlipper qterminal \
        adwaita-icon-theme papirus-icon-theme oxygen-icon-theme hicolor-icon-theme \
    && rm -rf /var/lib/apt/lists/*

# Configure LXQT desktop
RUN mkdir -p /etc/skel/.config/lxqt && \
    echo '[General]\n\
__userfile__=true\n\
icon_theme=Adwaita\n\
single_click_activate=false\n\
theme=ambiance\n\
tool_button_style=ToolButtonTextBesideIcon\n\
\n\
[Qt]\n\
doubleClickInterval=400\n\
font="Sans,11,-1,5,50,0,0,0,0,0"\n\
style=Fusion\n\
wheelScrollLines=3\n\
' >/etc/skel/.config/lxqt/lxqt.conf

# Update GTK icon cache
RUN gtk-update-icon-cache -f /usr/share/icons/Adwaita

# Add quicklaunch configuration for LXQT panel
RUN mkdir -p /etc/xdg/lxqt && echo '[quicklaunch]\n\
alignment=Left\n\
apps\\1\desktop=/usr/share/applications/pcmanfm-qt.desktop\n\
apps\\2\desktop=/usr/share/applications/qterminal.desktop\n\
apps\\3\desktop=/usr/share/applications/juffed.desktop\n\
apps\size=3\n\
type=quicklaunch\n\
' >> /etc/xdg/lxqt/panel.conf

# Add start script for LXQT
RUN echo '#! /bin/bash\n\
xdpyinfo | grep -q -i COMPOSITE || echo "x11docker/lxqt: X extension COMPOSITE not found.\n\
Graphical glitches might occur.\n\
If you run with x11docker option --nxagent, please add option --composite.\n\
" >&2\n\
startlxqt\n\
' > /usr/local/bin/start && chmod +x /usr/local/bin/start

# Default to LXQT startup
CMD ["start"]

