module spi_controller #(
    parameter int DATA_WIDTH = 64,
    parameter int PERI_CNT = 4 //bogus number of peripherals
)(
    input clk,
    input clk_en,
    input sync_rst_n,

    input wr_en,

    input [1:0] spi_mode,
    input [2:0] byte_sel, //enables the transmission of one to eight bytes
    input start_txn,
    input [DATA_WIDTH - 1:0] parallel_wr_data,

    input [PERI_CNT - 1:0] peri_select_in,

    input poci, //peripheral out, controller in

    output copi, //controller out, peripheral in
    output [PERI_CNT - 1:0] peri_select_out
);

reg [DATA_WIDTH - 1:0] data;
reg [$clog2(DATA_WIDTH) - 1:0] counter;

always_ff @(posedge clk) begin
    if (!sync_rst_n) begin
        data <= 0;
    end
    else if (clk_en && wr_en) begin
        data <= parallel_wr_data;
    end
    else if (clk_en && comm_en) begin
    end
end

endmodule
