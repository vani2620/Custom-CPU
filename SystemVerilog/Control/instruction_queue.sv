`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module instruction_queue #(
    parameter int INST_WIDTH = 32,
    parameter int ENTRIES = 64,
    parameter int ADDR_WIDTH = $clog2(ENTRIES),
    parameter int VIRT_COUNT = 256,
    parameter int VIRT_ADDR_WIDTH = $clog2(VIRT_COUNT),
    parameter int PHYS_COUNT = 128,
    parameter int PHYS_ADDR_WIDTH = $clog2(PHYS_COUNT),
    parameter int OPCODE_WIDTH = 7
)(
    input clk,
    input clk_en,
    input sync_rst_n,

    input wr_en,
    input [ADDR_WIDTH-1: 0] queue_wr_addr,

    input [OPCODE_WIDTH-1:0] wr_opcode,
    input [PHYS_ADDR_WIDTH-1:0] wr_dest_addr,
    input [PHYS_ADDR_WIDTH-1:0] wr_src_addr [2],
    input wr_src_valid [2],

    input rd_en,
    input [ADDR_WIDTH-1:0] queue_rd_addr,

    output [OPCODE_WIDTH-1:0] rd_opcode,
    output [PHYS_ADDR_WIDTH-1:0] rd_dest_addr,
    output [PHYS_ADDR_WIDTH-1:0] rd_src_addr[2],
    output rd_src_valid [2]
);

typedef struct packed {
    logic [OPCODE_WIDTH-1:0] opcode;
    logic [VIRT_ADDR_WIDTH-1:0] dest_addr;
    logic [VIRT_ADDR_WIDTH-1:0] src_addr [2];
    logic src_valid [2];
} queue_entry_t;

queue_entry_t instr_queue [ENTRIES];

always_ff @(posedge clk) begin
    if (sync_rst_n == 1'b0) begin
        for (int i = 0; i < ENTRIES; i++) begin
            instr_queue[i].opcode <= 0;
            instr_queue[i].dest_addr <= 0;
            instr_queue[i].src_addr[0] <= 0;
            instr_queue[i].src_addr[1] <= 0;
            instr_queue[i].src_valid[0] <= 0;
            instr_queue[i].src_valid[1] <= 0;
        end
    end else if (clk_en) begin
        if (wr_en) begin
            instr_queue[queue_wr_addr].opcode <= wr_opcode;
            instr_queue[queue_wr_addr].dest_addr <= wr_dest_addr;
            instr_queue[queue_wr_addr].src_addr[0] <= wr_src_addr[0];
            instr_queue[queue_wr_addr].src_addr[1] <= wr_src_addr[1];
        end
    end
end


endmodule

`default_nettype wire
