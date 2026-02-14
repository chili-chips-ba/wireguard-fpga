<!--
SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba

SPDX-License-Identifier: BSD-3-Clause
-->

# csr_gpio_test Simulation

> **Note:** Repository layout has been cleaned up.
> As with the UART demo, almost every build step now starts from the
> top‑level **`3.build/`** folder—*except* the final co‑simulation launch,
> which is run inside **`4.sim/`**.

This test exercises the **GPIO CSR** block:
the firmware drives two LEDs (`led1`, `led2`) and monitors two keys
(`key1`, `key2`).
In the supplied stimulus you will see `led1` held HIGH while `led2`
toggles; the BFM forces `key1/key2` to `1`, and the firmware reacts by
polling their **`next`** bits.

For this block only a small CSR window is needed, so we map
**`0x2000_0000 – 0x2000_FFFF`**.

---

## Build / run procedure

| Phase | Command | Run from | Notes |
|-------|---------|----------|-------|
| **1. Generate RTL + CSR headers** | `make -f MakefileCSR clean && make -f MakefileCSR` | **`3.build/`** | Produces RTL *.sv* + CSR headers in `csr_build/generated-files/`. |
| **2. Build firmware** | `make -f MakefileSW` | **`3.build/`** | `MakefileSW` compiles `main.cpp` chosen via `SW_MAIN := $(SW_TESTS)/csr_gpio_test`. |
| **3. Configure simulation** | Edit **`4.sim/vusermain.cfg`** →<br>```text vusermain0 -r -H -R -c -x 0x20000000 -X 0x2000FFFF -t ../3.build/sw_build/main.elf ``` | **`4.sim/`** | Narrow window covers only GPIO registers and cuts sim compile time. |
| **4. Run co‑simulation** | `make -f MakefileVProc.mk clean && make -f MakefileVProc.mk BUILD=ISS run` | **`4.sim/`** | Generates `wave.fst`. |
| **5. View results** | `gtkwave wave.fst` → **File → Read Savefile… →** `wave.CSR_GPIO_TEST.gtkw` |  **`4.sim/`** | Inspect LED/KEY hand‑shakes. |

---

## What you should see

* **`from_csr/gpio/led1`** — stays **1** (LED 1 on)
* **`from_csr/gpio/led2`** — periodic HIGH pulses (LED 2 blinking)
* **`to_csr/gpio/key[1|2]/next`** — asserted by the BFM to simulate key press

![image](https://github.com/user-attachments/assets/ca8dd625-ad9c-4e3f-873d-896a42f9bdf5)
