`default_nettype none
// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module single_issue_regfile #(
    parameter int DATA_WIDTH = 64,
    parameter int REG_COUNT = 16,
    parameter int ADDR_WIDTH = $clog2(REG_COUNT)
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire wr_en,
    input wire [DATA_WIDTH-1:0] wr_data,
    input wire [ADDR_WIDTH-1:0] wr_addr,

    input wire rd_en_a,
    input wire rd_en_b,
    input wire [ADDR_WIDTH-1:0] rd_addr_a,
    input wire [ADDR_WIDTH-1:0] rd_addr_b,

    output reg [DATA_WIDTH-1:0] rd_data_a,
    output reg [DATA_WIDTH-1:0] rd_data_b
);

reg [DATA_WIDTH-1:0] regfile [REG_COUNT];

always_ff @(posedge clk) begin
    if (!sync_rst_n) begin
        for (int i = 0; i < REG_COUNT; i++) begin
            regfile[i] <= 0;
        end
    end else if (clk_en) begin
        if (wr_en) begin
            regfile[wr_addr] <= wr_data;
        end
    end
end

always_comb begin
    if (rd_en_a) begin
        rd_data_a = regfile[rd_addr_a];
    end
    if (rd_en_b) begin
        rd_data_b = regfile[rd_addr_b];
    end
end

endmodule

`default_nettype wire
