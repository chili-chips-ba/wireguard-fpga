#
# Example RISC-V assembly program
#
        # -----------------------------------------
        # Program section (known as text)
        # -----------------------------------------
        .text

# Start symbol (must be present), exported as a global symbol.
_start: .global _start

# Export main as a global symbol
        .global main

# Label for entry point of test code
main:
        ### TEST CODE STARTS HERE ###

        la    x3, data       # Load x3 with address of data label
        lw    x2, 0(x3)      # Load a word from memory at byte address labelled data into x2
        la    x4, 0x10001000 # Load x4 with address
        sw    x2, 0(x4)      # Store x2 to memory at byte address in x4
        lw    x5, 0(x4)      # Load word in from memory into x5
        bne   x5, x2, fail

        ###    END OF TEST CODE   ###
        li    a0, 1
pass:
        # Exit test using RISC-V International's riscv-tests pass/fail criteria
        li    a0, 0          # set a0 (x10) to 0 to indicate a pass code
        li    a7, 93         # set a7 (x17) to 93 (5dh) to indicate reached the end of the test
fail:
#        jal x0, fail
        ebreak

        # -----------------------------------------
        # Data section Note starts at 0x1000, as
        # set by DATAADDR variable in rv_asm.bat.
        # -----------------------------------------
        .data

# Label for the beginning of data
data:
        .word 0x900dc0de    # Test word data value
