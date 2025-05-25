# Sanity Test for CSR HAL: GPIO, UART, Ethernet

This test program is designed to verify the basic functionality of the CSR HAL for GPIO, UART and Ethernet interfaces.

## Current Status

### ✅ GPIO

- **Tested successfully** using both:
  - **ISS model of the CPU**
  - **RTL model using PicoRV32**
- Functionality:
  - Turns on `LED2`
  - Mirrors `KEY1` to `LED1`

### ⚠️ UART

- Functionality: Sends `"Hello world!\r\n"` via UART
- Status:
  - **ISS model:**
    - Works **only if the string is located in RAM**
    - If the string is located in **IMEM**, only every **4th character is read correctly**; other characters are null. This suggests an **alignment issue**.
  - **RTL model:**
    - Works regardless of string location (RAM or IMEM)

### ⏳ Ethernet

- Code is prepared for receiving and forwarding Ethernet packets between `eth1` and `eth2`
- Not yet tested

## Notes

- The code includes commented-out sections for UART receiving and Ethernet handling for further testing.
- This test is useful as a base for validating CSR HAL functionality after some changes.