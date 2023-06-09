# RISC-V simple counter program
#
# Stanislav Zhelnio, 2020
#
#include "new_instructions.h"
#include "reg_codes.h"

.text

start:      
    li x10, 0
    li x11, 0
    li x12, 0
    hyp rx10, rx11, rx10
    li x12, 0
#     bne x10, x12, fail
#     li x10, 28
#     li x11, 49
#     li x12, 21959
#     hyp rx10, rx11, rx10
#     bne x10, x12, fail
#     li x10, 142
#     li x11, 169
#     li x12, 2863301
#     hyp rx10, rx11, rx10
#     bne x10, x12, fail
#     li x10, 255
#     li x11, 255
#     li x12, 16581390
#     hyp rx10, rx11, rx10
#     bne x10, x12, fail
# success:
#     li a0, 0
#     beq zero, zero, end

# fail:
#     li a0, 1
#     beq zero, zero, end

# end:
#     beq zero, zero, end
