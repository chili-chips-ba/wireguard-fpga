# csr_uart_test Simulation

This test follows the same procedure and commands as [csr_gpio_test](../csr_gpio_test/README.md), but it is located in the `2.sw/app/csr_uart_test` folder.

The UART FIFO has a **16‑byte** buffer. If `uart_recv()` is not called frequently enough, the FIFO will overflow, which is clearly visible in the waveform. I made sure to observe the overflow flag and the stored characters in the `wave.CSR_UART_TEST.gtkw` file after opening it in **GTKWave**.

---

## Steps I Followed

| Step | Command / File | What It Does |
|------|----------------|--------------|
| **1. Refresh CSR headers** | ```make -f MakefileCosim clean && make -f MakefileCosim ``` | Keeps software and hardware CSR definitions in sync. |
| **2. Build the UART test firmware** <br>(inside `2.sw/app/csr_uart_test`) | ```make -f MakefileCpp clean && make -f MakefileCpp ``` | Generates `main.elf` that continuously calls `uart_recv()`. |
| **3. Adjust the simulation CFG** <br>(inside `4.sim`) | In **`vusermain.cfg`** replace the line with: <br>``` text vusermain0 -r -H -R -c -x 0x10000000 -X 0x3FFFFFFF -t ../2.sw/app/csr_uart_test/main.elf ``` | **⚠️  Important:** the wider range `0x1000_0000 – 0x3FFF_FFFF` includes **DMEM**. The narrower range used in the GPIO test (`0x2000_0000 – 0x2000_FFFF`) **skips DMEM** and the program will never run correctly. |
| **4. Build & run the co‑simulation** | ```make -f MakefileVProc.mk clean make -f MakefileVProc.mk BUILD=ISS run ``` | Produces `wave.fst` with all DUT signals. |
| **5. View the results** | ```gtkwave wave.fst ``` <br>then load **`wave.CSR_UART_TEST.gtkw`** | Inspect RX/TX activity and watch the `oflow` flag when FIFO fills. |

---

## What You Should See

* **`from_csr/uart/tx/data`** – characters generated in `bfm_uart.sv`, e.g. **M i  s m o  F P G A …**
* **`to_csr/uart/rx/data`** – the same characters as they are read by `uart_recv()`
* **`to_csr/uart/rx/valid`** – one‑cycle pulse for every received byte

Below is an example waveform screenshot confirming correct reception (green trace shows the string *“Mi smo FPGA raja\r\n”* arriving byte‑by‑byte):

![UART RX waveform](./doc/img/uart_rx_ok.png)


## Quick Tips

* Want to replay a different string? Edit `send_string()` in `bfm_uart.sv`.
* To stress‑test overflow, comment out `uart_recv()` in `main.cpp` and watch `oflow` assert after 16 bytes.
