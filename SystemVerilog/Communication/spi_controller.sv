module spi_controller #(
    parameter int DATA_WIDTH = 64,
    parameter int PERI_CNT = 4 //bogus number of peripherals
)(
    input clk,
    input clk_en,
    input sync_rst_n,
    input start_txn,

    input wr_en,

    input [1:0] spi_mode,
    input [2:0] byte_sel, //enables the transmission of one to eight bytes

    input [DATA_WIDTH - 1:0] parallel_wr_data,

    input [PERI_CNT - 1:0] chip_sel_one_cold,

    input poci, //peripheral out, controller in

    output copi, //controller out, peripheral in
    output [PERI_CNT - 1:0] s_chip_sel_one_cold,
    output count,
    output end_txn
);

reg [DATA_WIDTH - 1:0] data;
reg [$clog2(DATA_WIDTH) - 1:0] counter;
reg [] spi_csr;
// Register fields
    //spi_csr[1:0] = spi_mode
        //spi_mode[0] = CPOL
        //spi_mode[1] = CPHA
    //spi_csr[4:2] = byte_sel
    //spi_csr[8:5] = state[3:0] (TODO)
        //state[0] = valid?
        //state[1] = txn in progress?
        //state[2] = idle/done

//RESET
always_ff @(posedge clk or negedge sync_rst_n) begin
    if (!sync_rst_n) begin
        data <= 0;
        counter <= 0;
        copi <= 0;
    end
end


always_ff @(posedge clk) begin
    //Write data from core
    if (clk_en && wr_en) begin
        data <= parallel_wr_data;
    end
    //Transaction
    else if (clk_en && start_txn) begin
        counter <= counter - 1;
        count <= counter;
        data <= {din, data[6:0]};
        pico <= data[7];
    end
end

endmodule
