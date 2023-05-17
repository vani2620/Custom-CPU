module instruction_queue #(
    parameter int INST_WIDTH = 32,
    parameter int ENTRIES = 64,
    parameter int ADDR_WIDTH = $clog2(ENTRIES),
    parameter int PHYS_COUNT = 128,
    parameter int PHYS_ADDR_WIDTH = 0,
    parameter int OPCODE_WIDTH = 7
)(
    input clk,
    input clk_en,
    input sync_rst_n,

    input wr_en,
    input [ADDR_WIDTH - 1: 0] queue_wr_addr,

    input [OPCODE_WIDTH - 1:0] wr_opcode,
    input [PHYS_ADDR_WIDTH - 1:0] wr_dest_addr,
    input [PHYS_ADDR_WIDTH - 1:0] wr_src_addr [2],
    input wr_src_valid [2],

    input rd_en,
    input [ADDR_WIDTH - 1:0] queue_rd_addr,

    output [OPCODE_WIDTH - 1:0] rd_opcode,
    output [PHYS_ADDR_WIDTH - 1:0] rd_dest_addr,
    output [PHYS_ADDR_WIDTH - 1:0] rd_src_addr[2],
    output rd_src_valid [2]
);

reg instr_queue;


endmodule
