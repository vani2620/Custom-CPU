`default_nettype none
// verilog-lint: waive-start line-length
// verilog-lint: waive-start parameter-name-style

module mem_buffer_reg #(
    parameter int DATA_WIDTH = 32,
    parameter int MEM_ADDR_WIDTH = 32,
    parameter int REG_ADDR_WIDTH = 5
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire wr_en,

    input wire [DATA_WIDTH-1 :0] data_in,

    input wire rd_en,

    output reg [DATA_WIDTH-1 :0] data_out
);

reg [DATA_WIDTH-1 :0] buffer;

always_ff @(posedge clk) begin
    if (!sync_rst_n) begin
        buffer <= 0;
    end else if (clk_en) begin
        if (wr_en) begin
            buffer <= data_in;
        end
    end
end

always_comb begin
    if (rd_en) begin
        data_out = buffer;
    end
end

endmodule

`default_nettype wire
