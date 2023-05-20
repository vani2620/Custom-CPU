`default_nettype none
// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module register_file_multiport_BRAM #(
    parameter int DATA_WIDTH = 64,
    parameter int REG_COUNT = 256,
    parameter int ADDR_WIDTH = $clog2(REG_COUNT),
    parameter int WRITE_PORTS = 4,
    parameter int READ_PORTS = 8
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire [WRITE_PORTS - 1:0] wr_en,

    input wire [ADDR_WIDTH * WRITE_PORTS - 1:0] addr,

    input wire [DATA_WIDTH * WRITE_PORTS - 1:0] wr_data,

    input wire [READ_PORTS - 1:0] rd_en,

    output reg [DATA_WIDTH * READ_PORTS - 1:0] rd_data
);

generate
genvar i;
for (i = 0; i < WRITE_PORTS; i = i + 1) begin: gen_regfile
    dual_port_ram #(
        .DATA_WIDTH(DATA_WIDTH * WRITE_PORTS),
        .REG_COUNT(REG_COUNT),
        .ADDR_WIDTH(ADDR_WIDTH * WRITE_PORTS),
        .RAM_PERF("HIGH-PERF"),
        .INIT_FILE(""))
        reg_bank[WRITE_PORTS - 1: 0] (
        .clk(clk),
        .clk_en(clk_en),
        .sync_rst_n(sync_rst_n),

        .wr_en_a(wr_en[i]),
        .wr_en_b(wr_en[i]),

        .addr_a(addr[(i + 1)  * ADDR_WIDTH - 1 -: ADDR_WIDTH]),
        .addr_b(addr[(i + 1)  * ADDR_WIDTH - 1 -: ADDR_WIDTH]),

        .wr_data_a(wr_data[(i + 1) * DATA_WIDTH - 1 -: DATA_WIDTH]),

        );
end
endgenerate

endmodule
`default_nettype wire
