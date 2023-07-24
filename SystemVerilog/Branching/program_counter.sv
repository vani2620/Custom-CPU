`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module program_counter #(
    parameter int PC_SHORT_OFFSET_WIDTH = 12,
    parameter int PC_LONG_OFFSET_WIDTH = 20,
    parameter int INSTR_ADDR_WIDTH = 32,
    parameter int REG_ADDR_WIDTH = 5
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire stall,

    input wire branch_en,
    input wire jump_link_en,
    input wire long_offset_en,

    input wire [REG_ADDR_WIDTH - 1 : 0] link_addr_in,
    input wire [PC_SHORT_OFFSET_WIDTH - 1 : 0] short_offset,
    input wire [PC_LONG_OFFSET_WIDTH - 1 : 0] long_offset,

    output reg [INSTR_ADDR_WIDTH - 1 : 0] next_instr_addr,
    output reg [REG_ADDR_WIDTH - 1 : 0] link_addr_out
);

reg [INTSR_ADDR_WIDTH - 1 : 0] cur_instr_reg;
reg [REG_ADDR_WIDTH - 1 : 0] link_addr_reg;

//Program counter logic
always_ff @(posedge clk) begin
    if (!sync_rst_n) begin
        cur_instr_reg <= 0;
        link_addr_reg <= 0;
    end
    else if (clk_en) begin
        //If stall is asserted, do not increment the program counter
        while (stall) begin
            next_instr_addr <= cur_instr_reg;
        end
        //If branch is asserted, add the branch offset to the program counter
        if (branch_en) begin
            next_instr_addr <= cur_instr_reg + (short_offset << 1);
        end
        //If relative jump is asserted, add the jump offset to the program counter
        else if (jump_link_en) begin
            //If link is asserted, store the current program counter in the link register
            if (link_en) begin
                link_addr_reg <= link_addr_in;
            end
            else begin
                link_addr_reg <= cur_instr_reg + 4;
            end
            next_instr_addr <= cur_instr_reg + (short_offset << 1);
        end
        else if (long_offset_en) begin
            next_instr_addr <= cur_instr_reg + (long_offset << 12);
        end
        else begin
            next_instr_addr <= cur_instr_reg + 4;
        end
    end
end

endmodule

`default_nettype wire
