`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module instruction_decoder #(
    parameter int INSTR_WIDTH = 32,
    parameter int OPCODE_WIDTH = 4,
    parameter int REG_ADDR_WIDTH = 5
)(
    input wire [INSTR_WIDTH-1:0] instr_in,

    output reg read_src_a,
    output reg read_src_b,
    output reg [REG_ADDR_WIDTH-1:0] src_reg_addr_a,
    output reg [REG_ADDR_WIDTH-1:0] src_reg_addr_b,
    output reg write_dest,
    output reg [REG_ADDR_WIDTH-1:0] dest_reg_addr,
    output reg alu_en,
    output reg alu_op
);

wire [OPCODE_WIDTH-1:0] maj_opcode_u = instr_in[INSTR_WIDTH-1:INSTR_WIDTH-OPCODE_WIDTH];

endmodule

`default_nettype wire
