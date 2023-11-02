`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module instruction_decoder #(
    parameter int DATA_WIDTH = 32,
    parameter int INSTR_WIDTH = 32,
    parameter int OPCODE_WIDTH = 4,
    parameter int REG_ADDR_WIDTH = 5
)(
    input wire [INSTR_WIDTH-1:0] instr_in,

    output reg read_src_a,
    output reg read_src_b,
    output reg [REG_ADDR_WIDTH-1:0] src_addr_a,
    output reg [REG_ADDR_WIDTH-1:0] src_addr_b,
    output reg write_dest,
    output reg [REG_ADDR_WIDTH-1:0] dest_addr,
    output reg alu_en,
    output reg [OPCODE_WIDTH-1:0] alu_func_code,

    output reg branch_en,
    output reg [REG_ADDR_WIDTH-1:0] branch_addr_base,
    output reg [DATA_WIDTH-1:0] branch_addr_offset,
    output reg [OPCODE_WIDTH-1:0] branch_func_code,

    output reg jump_en,
    output reg link_en,
    output reg [DATA_WIDTH-1:0] jump_addr_offset,
    output reg [REG_ADDR_WIDTH-1:0] jump_link_addr,

    output reg load_en,
    output reg [OPCODE_WIDTH-1:0] load_func_code,
    output reg [REG_ADDR_WIDTH-1:0] load_addr_base,
    output reg [REG_ADDR_WITH-1:0] load_dest_addr,
    output reg [DATA_WIDTH-1:0] load_addr_offset,

    output reg store_en,
    output reg [OPCODE_WIDTH-1:0] store_func_code,
    output reg [REG_ADDR_WIDTH-1:0] store_addr_base,
    output reg [REG_ADDR_WIDTH-1:0] store_data_addr,
    output reg [DATA_WIDTH-1:0] store_addr_offset
);

wire [OPCODE_WIDTH-1:0] maj_opcode_u = instr_in[INSTR_WIDTH-1:INSTR_WIDTH-OPCODE_WIDTH];


wire read_enable_a;
wire read_enable_b;
wire [REG_ADDR_WIDTH-1:0] src_reg_a;
wire [REG_ADDR_WIDTH-1:0] src_reg_b;

wire write_enable;
wire [REG_ADDR_WIDTH-1:0] dest_reg;

wire alu_enable;
wire [OPCODE_WIDTH-1:0] alu_op;


wire branch_enable;
wire [REG_ADDR_WIDTH-1:0] branch_base;
wire [DATA_WIDTH-1:0] branch_offset;
wire [OPCODE_WIDTH-1:0] branch_op;

wire jump_enable;
wire link_enable;
wire [DATA_WIDTH-1:0] jump_offset;
wire [REG_ADDR_WIDTH-1:0] jump_link_dest;


wire load_enable;
wire [OPCODE_WIDTH-1:0] load_op;
wire [REG_ADDR_WIDTH-1:0] load_base;
wire [DATA_WIDTH-1:0] load_offset;
wire [REG_ADDR_WIDTH-1:0] load_dest;

wire store_enable;
wire [OPCODE_WIDTH-1:0] store_op;
wire [REG_ADDR_WIDTH-1:0] store_base;
wire [DATA_WIDTH-1:0] store_offset;
wire [REG_ADDR_WIDTH-1:0] store_data;


always_comb begin
    case (maj_opcode_u)
    default:
        begin
        end
    endcase
end

endmodule

`default_nettype wire
