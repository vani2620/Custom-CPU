`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module program_counter #(
    parameter int INSTR_ADDR_WIDTH = 32,
    parameter int REG_ADDR_WIDTH = 5
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire stall,

    input wire branch_en,
    input wire jump_en,
    input wire link_en,
    input wire [4:0] branch_cond,

    input wire [INSTR_ADDR_WIDTH - 1:0] branch_base_addr,

    input wire [INSTR_ADDR_WIDTH - 1:0] short_offset, //16-bit signed offset, sign-extended to 32 bits, used with register-relative addressing
    input wire [INSTR_ADDR_WIDTH - 1:0] long_offset, //24-bit signed offset, sign-extended to 32 bits, used with PC-relative addressing

    output reg [INSTR_ADDR_WIDTH - 1:0] next_instr_addr,
    output reg [REG_ADDR_WIDTH - 1:0] link_reg_addr
);

reg [INSTR_ADDR_WIDTH - 1:0] counter;
reg [4:0] conditions;

wire [INSTR_ADDR_WIDTH - 1:0] inc_counter = counter << 1; //byte-addressed memory; shortest instructions are 2 bytes

wire [INSTR_ADDR_WIDTH - 1:0] temp_next_instr_addr;

always_comb begin : calcNext
    if (stall) begin
        temp_next_instr_addr = counter;
    end else if (branch_en) begin
        temp_next_instr_addr = branch_base_addr + (short_offset << 1);
    end else if (jump_en) begin
        temp_next_instr_addr = counter + (long_offset << 1);
    end else begin
        temp_next_instr_addr = inc_counter;
    end
end

always_comb begin : linkReg
    link_reg_addr = inc_counter;
end

always_ff @(posedge clk) begin : updatePC
    if (!sync_rst_n) begin
        counter <= 0;
        conditions <= 0;
    end else if (clk_en) begin
        counter <= temp_next_instr_addr;
    end
end


endmodule

`default_nettype wire
