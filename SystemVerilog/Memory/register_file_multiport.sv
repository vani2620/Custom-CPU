module register_file_multiport #(
    parameter int DATA_WIDTH = 64,
    parameter int PHYS_COUNT = 128,
    parameter int ARCH_COUNT = 32,
    parameter int ADDR_WIDTH = $clog2(PHYS_COUNT), //no touch. touch bad. break code.
    parameter int WRITE_PORTS = 4,
    parameter int READ_PORTS = 8,
    parameter int STATE_WIDTH = 4
)(
    input clk,
    input clk_en,
    input sync_rst_n,

    input [WRITE_PORTS - 1:0][DATA_WIDTH - 1:0] wr_data,
    input [WRITE_PORTS - 1:0][STATE_WIDTH - 1:0] wr_state,

    input [WRITE_PORTS - 1:0] wr_data_en,
    input [WRITE_PORTS - 1:0] wr_state_en,
    input [ADDR_WIDTH - 1:0] wr_addr [WRITE_PORTS],

    input [READ_PORTS - 1:0] rd_data_en,
    input [READ_PORTS - 1:0] rd_state_en,
    input [ADDR_WIDTH - 1:0] rd_addr [READ_PORTS],


    output [READ_PORTS - 1:0][DATA_WIDTH - 1:0] rd_data,
    output [READ_PORTS - 1:0][STATE_WIDTH - 1:0] rd_state
);

reg [DATA_WIDTH - 1:0] data_reg_file [PHYS_COUNT]; //Register file for holding data
reg [STATE_WIDTH - 1:0] state_reg_file [PHYS_COUNT]; //Tracks state of each register

generate
    genvar i;
    for (i = 0; i < WRITE_PORTS; i = i + 1) begin: gen_regfile
        always_ff @(posedge clk) begin
            if (!sync_rst_n) begin: Reset
                //Reset all registers
                data_reg_file[wr_addr[i]] <= 0;
                state_reg_file[wr_addr[i]] <= 0;
            end: Reset
            else if (clk_en && wr_data_en[i]) begin: WriteData
                data_reg_file[wr_addr[i]] <= wr_data;
            end: WriteData
            else if (clk_en && wr_state_en[i]) begin: UpdateState
                state_reg_file[wr_addr[i]] <= wr_state;
            end: UpdateState
        end
    end: gen_regfile
endgenerate

always_comb begin
    for (int i = 0; i < READ_PORTS; i = i + 1) begin
        if (rd_data_en[i]) begin
            rd_data[i] = data_reg_file[rd_addr[i]];
        end
        else if (rd_state_en[i]) begin
            rd_state[i] = state_reg_file[rd_addr[i]];
        end
    end
end

endmodule

