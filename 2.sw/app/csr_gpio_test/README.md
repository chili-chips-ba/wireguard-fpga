# csr_gpio_test Simulation

This repository contains the **csr_gpio_test** simulation for testing the GPIO CSR functionality. Below are the steps I followed to ensure the successful execution of the simulation.

## Steps to Ensure Successful Simulation

### 1. Ensured Proper CSR Headers
To ensure I was using the correct version of CSR headers for both software and hardware, I executed the following commands:

```bash
make -f MakefileCosim clean
make -f MakefileCosim
```

These commands automatically ran the sysrdl_cosim.py script located in the *3.build folder*. This ensured that the CSR headers for both software (**csr.h**, **csr_hw.h**, **csr_cosim.h**) and hardware (*1.hw/csr.peakrdl/* *) were aligned.

### 2. Modified main.cpp
In the *2.sw/app/csr_gpio_test* folder, I edited the **main.cpp** file to reduce the delay from 1000000 to 1 to prevent the simulation from taking too long.

### 3. Cleaned and Built Software
After modifying the **main.cpp** file, I cleaned and rebuilt the software in the *2.sw/app/csr_gpio_test* folder using the following commands:

```bash
make -f MakefileCpp clean
make -f MakefileCpp
```

### 4. Updated Configuration
In the *4.sim* folder, I updated the **vusermain.cfg** file with the following line to set the correct memory address range:

```bash
vusermain0 -r -H -R -c -x 0x20000000 -X 0x2000FFFF -t ../2.sw/app/csr_gpio_test/main.elf
```
This ensures that the correct address range of 0x20000000 to 0x2000FFFF is used to cover the GPIO CSR addresses.

### 5. Cleaned and Built the Simulation
After updating the **vusermain.cfg** file, I cleaned and built the simulation using the following commands:

```bash
make -f MakefileVProc.mk clean
make -f MakefileVProc.mk BUILD=ISS run
```

### 6. Launched the Simulation and Waveform Viewer
Finally, I launched the GTKWave waveform viewer with the following command:

```bash
gtkwave wave.fst
```
I then opened the wave.CSR_GPIO_TEST.gtkw file, where I observed the results as shown in the attached image.

![image](https://github.com/user-attachments/assets/4b380128-accc-4ce3-94f1-cf5f1e63fc3a)

