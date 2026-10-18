#!/usr/bin/env bash
set -u
cd /media/1TB/Dropbox/PipelineC/git/wireguard-fpga/3.build/pypeline_build || exit 1
export PYTHONDONTWRITEBYTECODE=1
export PYPELINEC="$PWD/generated-files/poly1305-fsm-compiler-attempt8-latest/compiler/src/pypelinec"
export PYPELINEC_CACHE_DIR="$PWD/generated-files/pypelinec-cache"
python3 -u ./measure.py --shared --poly1305 pipelined --poly1305-mult hybrid_square \
  --poly1305-compute fsm --target-mhz 80 -j 2 \
  --label shared-poly1305-fsm64-latest-qor-20261017 \
  --out-dir generated-files/shared-poly1305-fsm-qor-20261016 --reuse-syn \
  --sizes 16,64,256,1024,1420,1920 --packets 4 --peak-bytes 0 \
  --dirs both --taps all --seed 8439 --no-per-module-area --save-evidence
run_status=$?
printf '%s\n' "$run_status" > generated-files/shared-poly1305-fsm64-latest-qor-20261017.exit-code
exit "$run_status"
