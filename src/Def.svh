// System specifications
`define DATA_SIZE 8
`define INST_SIZE 32
`define MEM_LEN 32
`define ADDR_SIZE 5

// Input files
`define PROGRAM "utils/program.obj"
`define DATA "utils/data.mem"

// Enum for branch instructions
`define NO_JUMP 0
`define BEQ 1
`define BLT 2

// Enum for ALU operations
`define AND 0
`define OR 1
`define ADD 2
`define SUB 3
