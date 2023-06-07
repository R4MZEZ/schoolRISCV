# RISC-V simple counter program
#
# Stanislav Zhelnio, 2020
#
#include "new_instructions.h"
#include "reg_codes.h"

.text

start:      
    li x10, 1
    li x11, 4
    li x12, 3
    hyp rx10, rx11, rx10
    bne x10, x12, fail

success:
    li a0, 0
    beq zero, zero, end

fail:
    li a0, 1
    beq zero, zero, end

end:
    beq zero, zero, end
