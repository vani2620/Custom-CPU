module spi_controller #(
    parameter int SPI_DATA_WIDTH = 8,
    parameter int PERI_CNT = 4, //number of peripherals
    parameter int CYCLES_PER_HALF_BIT = 2,
    parameter int MAX_BYTES_PER_CS = 2,
    parameter int CS_INACTIVE_CYCLES = 1,
    parameter int CPOL = 0,
    parameter int CPHA = 0
)(
    input wire clk,
    input wire sync_rst_n,

    //Control signals
    input wire clk_en,
    input wire start_txn, //Ready to transmit data--pulse when bit counter = 0

    //From CPU
    input wire [SPI_DATA_WIDTH-1:0] parallel_wr_data,
    input wire [PERI_CNT-1:0] p_sel_one_cold,

    //From peripheral device
    input wire poci, //peripheral out, controller in

    //To peripheral device
    output reg copi, //controller out, peripheral in
    output reg [PERI_CNT-1:0] p_sel_one_cold,
    output reg p_clk, //SPI clock

    //To computer
    output reg end_txn
);

reg [DATA_WIDTH-1:0] data;
typedef struct packed {
    reg [1:0] mode;
    reg [$clog2(DATA_WIDTH)-1:0] bit_counter;
} spi_csr_t;

spi_csr_t spi_csr;


//reg [] spi_csr;
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
always_ff @(posedge clk) begin
    if (!sync_rst_n) begin
        data <= '0;
        counter <= '0;
        copi <= '0;
        spi_csr.mode <= '0;
        spi_csr.sel <= '0;
    end
end

endmodule
