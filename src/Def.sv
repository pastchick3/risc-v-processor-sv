package Def;
    // System specifications
    localparam DATA_SIZE = 8;
    localparam INST_SIZE = 32;
    localparam MEM_LEN = 32;
    localparam ADDR_SIZE = 5;

    // Input files
    localparam PROGRAM = "utils/program.obj";
    localparam DATA = "utils/data.mem";

    // Enum for branch instructions
    localparam NO_JUMP = 0;
    localparam BEQ = 1;
    localparam BLT = 2;

    // Enum for ALU operations
    localparam AND = 0;
    localparam OR = 1;
    localparam ADD = 2;
    localparam SUB = 3;

    // Port type
    typedef logic [INST_SIZE-1:0] inst_port;
    typedef logic [ADDR_SIZE-1:0] addr_port;
    typedef logic [DATA_SIZE-1:0] data_port;
endpackage
