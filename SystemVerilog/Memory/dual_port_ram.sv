`default_nettype none
// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style


//DOES NOT INFER TRUE DUAL PORT
module dual_port_ram #(
    parameter int DATA_WIDTH = 8,
    parameter int REG_COUNT = 16,
    parameter int ADDR_WIDTH = $clog2(REG_COUNT),
    parameter string RAM_PERF = "HIGH_PERF",
    parameter string INIT_FILE = ""
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire wr_en_a,
    input wire wr_en_b,

    input wire [ADDR_WIDTH - 1: 0] addr_a,
    input wire [ADDR_WIDTH - 1: 0] addr_b,

    input wire [DATA_WIDTH - 1: 0] wr_data_a,
    input wire [DATA_WIDTH - 1: 0] wr_data_b,

    input wire rd_en_a,
    input wire rd_en_b,

    input wire rd_reg_rst_a,
    input wire rd_reg_rst_b,

    input wire rd_clk_en_a,
    input wire rd_clk_en_b,

    output reg [ADDR_WIDTH - 1: 0] rd_data_a,
    output reg [ADDR_WIDTH - 1: 0] rd_data_b
);
(* ram_style = "block" *) reg [DATA_WIDTH - 1: 0] data [REG_COUNT];
reg [DATA_WIDTH - 1: 0] mem_data_a = 'b0;
reg [DATA_WIDTH - 1: 0] mem_data_b = 'b0;

generate
    if (INIT_FILE == "") begin: gen_init_zero
        int i;
        initial begin
            for (i = 0; i < REG_COUNT; i = i + 1) begin
                data[i] <= 'b0;
            end
        end
    end: gen_init_zero
    else if (INIT_FILE != "") begin: gen_use_init_file
        int i;
        initial begin
            $readmemh({INIT_FILE, ".hex"}, data, 0, REG_COUNT - 1);
        end
    end: gen_use_init_file
endgenerate

always_ff @(posedge clk) begin
    if (clk_en) begin
        if (wr_en_a) begin
            data[addr_a] <= wr_data_a;
        end
        mem_data_a <= data[addr_a];
    end
end

always_ff @(posedge clk) begin
    if (clk_en) begin
        if (wr_en_b) begin
            data[addr_b] <= wr_data_b;
        end
        mem_data_b <= data[addr_b];
    end
end

generate
    if (RAM_PERF == "LOW_LAT") begin: gen_low_latency
        always_comb begin
            if (rd_en_a) begin: gen_read_data
                rd_data_a = mem_data_a;
                rd_data_b = mem_data_b;
            end
        end
    end else begin: gen_high_perf
        reg [DATA_WIDTH - 1:0] rd_reg_data_a = 'b0;
        reg [DATA_WIDTH - 1:0] rd_reg_data_b = 'b0;

        always @(posedge clk) begin
            if (rd_reg_rst_a) begin
                rd_reg_data_a <= 'b0;
            end
            else if (rd_clk_en_a) begin
                rd_reg_data_a <= mem_data_a;
            end
        end

        always @(posedge clk) begin
            if (rd_reg_rst_b) begin
                rd_reg_data_b <= 'b0;
            end
            else if (rd_clk_en_b) begin
                rd_reg_data_b <= mem_data_b;
            end
        end

        always_comb begin
            if (rd_en_a) begin: gen_high_perf_read_a
                rd_data_a = rd_reg_data_a;
            end
            else if (rd_en_b) begin:gen_high_perf_read_b
                rd_data_b = rd_reg_data_b;
            end
        end
    end
endgenerate

endmodule
`default_nettype wire
