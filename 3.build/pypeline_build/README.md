# pypeline_build — ChaCha20-Poly1305 AEAD in Pypeline

Pypeline (Python front-end for PipelineC) port of the C designs in
`../pipelinec_build/`. Same three design variants, same synthesizable
testbenches, same Artix-7 xc7a200tffg1156-2 @ 80 MHz target.

The `$PIPELINEC` environment variable must point to the PipelineC executable
(`<PipelineC repo>/src/pipelinec`) before running any build script — both the
scripts and the design files' `sys.path` bootstrap (`src/pypeline_env.py`)
use it to locate the repo (with a fallback to the sibling `../../../PipelineC`
checkout).

## Build Commands

**Simulate with cocotb + GHDL (the designs' acceptance tests):**
```bash
./build_sim_comb.sh         # Combinational sim, encrypt TB  -> generated-files-sim-comb/
./build_sim_comb_dec.sh     # Combinational sim, decrypt TB  -> generated-files-sim-comb-dec/
./build_sim_comb_shared.sh  # Combinational sim, shared TB   -> generated-files-sim-comb-shared/ (slow!)
./build_sim_pipe.sh         # Pipelined sim, encrypt TB      -> generated-files-sim-pipe/ (hours!)
./build_sim_pipe_dec.sh     # Pipelined sim, decrypt TB      -> generated-files-sim-pipe-dec/ (hours!)
./build_sim_pipe_shared.sh  # Pipelined sim, shared TB       -> generated-files-sim-pipe-shared/ (hours!)
```
Pass criteria: no `ERROR` lines anywhere in the output, and per side both
`Test 0 DONE!` and `Test 1 DONE!` prints. The `_pipe` variants run real
autopipelining through the synthesis tool first (like the C
`build_sim_pipe*.sh`), which is what takes hours.

**Generate Verilog (for FPGA synthesis):**
```bash
./build_verilog.sh          # Standalone encrypt -> generated-files-verilog/
./build_verilog_decrypt.sh  # Standalone decrypt -> generated-files-verilog-decrypt/
./build_verilog_shared.sh   # Shared encrypt+decrypt -> generated-files-verilog-shared/
```

## Source Layout (mirrors ../pipelinec_build/src/)

```
src/
  pypeline_env.py               sys.path bootstrap (import first in every file)
  aead_types.py                 shared sizes/types (axis128/axis512, streams, null helpers)
  chacha20/
    chacha20.py                 ChaCha20 math + pipeline-control FSM (chacha20.h)
    chacha20_encrypt.py         per-instance wires + own stream pipeline (chacha20.c, encrypt)
    chacha20_decrypt.py         ... decrypt instance
    chacha20_encrypt_shared.py  pipeline-less instance for the shared design
    chacha20_decrypt_shared.py  ...
    chacha20_pipeline_shared.py the one shared pipeline + round-robin mux (chacha20_pipeline_shared.c)
  poly1305/
    poly1305.py                 u320 limb math + MAC FSM (poly1305.h)
    poly1305_mac_encrypt.py     per-instance wires + MCP compute (poly1305_mac.c, encrypt)
    poly1305_mac_decrypt.py     ... decrypt instance
    poly1305_verify_decrypt.py  tag comparison FSM
  prep_auth_data/
    prep_auth_data.py           AAD||ciphertext||lengths framing FSM (prep_auth_data.h)
    prep_auth_data_encrypt.py   per-instance wires + MAIN
    prep_auth_data_decrypt.py   ...
  auth_tag/
    append_auth_tag.py          append tag after ciphertext (encrypt output)
    strip_auth_tag.py           split tag off ciphertext (decrypt input, early-tlast buffer)
    wait_to_verify.py           128-deep FIFO holding plaintext until tag verdict
  chacha20poly1305/
    chacha20poly1305_encrypt_ports.py   DUT-facing global wires (the .h wires)
    chacha20poly1305_encrypt_hw_io.py   flattened Input[]/Output[] ports + io conversion MAIN
    chacha20poly1305_decrypt_ports.py / chacha20poly1305_decrypt_hw_io.py
    encrypt_dataflow.py / decrypt_dataflow.py            standalone wiring MAINs (80 MHz)
    encrypt_dataflow_shared.py / decrypt_dataflow_shared.py  shared-design duplicates
    tb_common.py                test vectors (plain Python data)
    encrypt_tb.py / decrypt_tb.py   synthesizable testbench MAINs
  chacha20poly1305_encrypt.py / _tb.py                    tops (hw / sim)
  chacha20poly1305_decrypt.py / _tb.py
  chacha20poly1305_encrypt_decrypt_shared.py / _tb.py
```

Conventions vs the C sources:

- C's `#define INST_NAME` + re-`#include` per-instance trick becomes one thin
  `.py` module per instance (global wire names get the module-name prefix, so
  e.g. `chacha20_encrypt.py`'s `axis_in` elaborates as `chacha20_encrypt_axis_in`).
- C's `#ifndef SIMULATION` hardware ports become separate `*_hw_io.py` modules
  imported only by the hardware tops (the sim TB tops omit them).
- `GLOBAL_VALID_READY_PIPELINE_INST` / `GLOBAL_VALID_READY_MCP_INST` /
  `GLOBAL_STREAM_FIFO` become `make_stream_pipeline` / `make_valid_ready_mcp` /
  `make_stream_fifo` instances each wired up in a dedicated `@MAIN`.
- Every top `.py` imports ALL hardware modules explicitly (sub-module imports
  are not followed for hardware elaboration).
- MAINs compute into locals and drive each global wire exactly once at the end
  (a function may not both read and write the same wire).

`PYPELINE_ISSUES.md` logs the compiler bug found during this port (fixed in
PipelineC) plus the language paper cuts and their idiomatic workarounds.
