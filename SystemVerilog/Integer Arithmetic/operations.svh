`ifndef OPERATIONS
`define OPERATIONS
    //Logic unit operations
    `define LOGIC_OPCODE_WIDTH    2
    `define OR                    2'b01
    `define AND                   2'b10
    `define XOR                   2'b11

    //Shifter operations
    `define SHIFT_OPCODE_WIDTH    3
    `define LLOG                  3'b001
    `define RLOG                  3'b010
    `define LROT                  3'b011
    `define RROT                  3'b100
    `define RAR                   3'b101
`endif
