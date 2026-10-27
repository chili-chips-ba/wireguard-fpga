<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

[Back to **README**](README.md)

# Contributing to WireGuard-FPGA

## Found something?

Open an [Issue](https://github.com/chili-chips-ba/wireguard-fpga/issues). For bugs, include how to reproduce it: a modified [co-sim](4.sim), a waveform, or logs.

## Want to change something?

1. Bigger change? Open an Issue first, so we agree on the approach
2. Fork, branch off `main`, make the change
3. QA process:
   - **[run-lint](3.build/hw_build.openXC7/run-lint.sh)** shows no errors. Fix lint findings at the root. Waive only as the last resort, following steps in [run-lint-waivers.txt](3.build/hw_build.openXC7/run-lint-waivers.txt).
   - **[run-format --check](3.build/hw_build.openXC7/run-format.sh)** passes.
   - Ensure that **[co-sim](4.sim)** passes
   - and that the **[openXC7 build](3.build/hw_build.openXC7)** completes. Both are being restored on `main` ([#47](https://github.com/chili-chips-ba/wireguard-fpga/issues/47), [#48](https://github.com/chili-chips-ba/wireguard-fpga/issues/48)).
   - For a mere cleanup: **[run-leq](3.build/hw_build.openXC7/run-leq.sh)** to prove that there are no functional changes.

4. Open a Pull Request against `main`.

RTL changes go to [1.hw](1.hw). Observe our [RTL coding rules](1.hw/README.md#rtl-coding-rules). Third-party code in [1.hw/external_lib](1.hw/external_lib) (Alex Forencich's verilog-ethernet and verilog-axis) and PicoRV32 in [1.hw/ip.cpu/cpu.PICORV32](1.hw/ip.cpu/cpu.PICORV32) changes upstream first.

## License

Soft code is BSD-3-Clause; docs and vendored code are annotated in [REUSE.toml](REUSE.toml). Your contribution takes the license of the files it goes into. New files need an SPDX header; `reuse lint` must pass.

## GenAI

Allowed, if:

- you understand and take responsibility for every line,
- no third-party copyrighted content gets in,
- you say in the Pull Request which tool and model you used, and for what.

Purely AI-generated work is not accepted. This follows [NLnet's GenAI policy v1.1](https://nlnet.nl/foundation/policies/generativeAI/1.1/), our funder.

-----------
#### End-of-Document
