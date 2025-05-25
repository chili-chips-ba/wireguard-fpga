# csr_uart_test Simulation

> **Note:** Repository layout was cleaned up.
> All build steps now start from the top‑level **`3.build/`** folder—except the
> final co‑simulation launch, which is run inside **`4.sim/`**.

The functional test is simple:
`bfm_uart.sv` transmits **“Mi smo FPGA raja\r\n”**, the firmware calls
`uart_recv()`, and we watch the 16‑byte RX FIFO fill/overflow.
The address map must span **`0x1000_0000 – 0x3FFF_FFFF`** so that **DMEM**
is visible.

---

## Build / run procedure

| Phase | Command | Run from | Notes |
|-------|---------|----------|-------|
| **1. Generate RTL + CSR headers** | `make -f MakefileCSR clean && make -f MakefileCSR` | **`3.build/`** | Produces RTL *.sv* and CSR headers in `csr_build/generated-files/`. |
| **2. Build firmware** | `make -f MakefileSW` | **`3.build/`** | `MakefileSW` compiles `main.cpp` chosen via `SW_MAIN := $(SW_TESTS)/csr_uart_test`. |
| **3. Configure simulation** | Edit **`4.sim/vusermain.cfg`** →<br>```text vusermain0 -r -H -R -c -x 0x10000000 -X 0x3FFFFFFF -t ../3.build/sw_build/main.elf ``` | **`4.sim/`** | Full range is mandatory; the old GPIO span cuts off DMEM. |
| **4. Run co‑simulation** | `make -f MakefileVProc.mk clean && make -f MakefileVProc.mk BUILD=ISS run` | **`4.sim/`** | Generates `wave.fst`. |
| **5. View results** | `gtkwave wave.fst` → **File → Read Save File →** `wave.CSR_UART_TEST.gtkw` | **`4.sim/`** | Inspect RX data and `oflow`. |

---

## What you should see

* **`from_csr/uart/tx/data`** — bytes sent by BFM: **M i s m o F P G A …**
* **`to_csr/uart/rx/data`** — same bytes as firmware reads
* **`to_csr/uart/rx/valid`** — pulse per byte
* **`to_csr/uart/rx/oflow`** — asserts if `uart_recv()` lags behind (FIFO = 16 B)

![UART RX waveform](https://github.com/user-attachments/assets/ad248d4e-de57-423d-b88f-8cc1a7c7debf)
