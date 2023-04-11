    module instruction_queue #(
        parameter int INST_WIDTH = 32,
        parameter int ENTRIES = 64,
        parameter int ADDR_WIDTH = $clog2(ENTRIES),
        parameter int PHYS_REG_COUNT = 128,
        parameter int REG_ADDR_WIDTH
    ) (
        input clk,
        input clk_en,
        input sync_rst_n,

        input [REG_ADDR_WIDTH - 1:0] wr_op_addr,

        input [1:0][REG_ADDR_WIDTH - 1:0] rd_op_addr,
        input [1:0] rd_op_ready
    );
endmodule
