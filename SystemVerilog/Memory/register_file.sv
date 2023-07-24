`default_nettype none
// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module register_file #(
    parameter int DATA_WIDTH = 64,
    parameter int PHYS_COUNT = 64,
    parameter int ARCH_COUNT = 32,
    parameter int ADDR_WIDTH = $clog2(PHYS_COUNT),
    parameter int WRITE_PORTS = 2,
    parameter int READ_PORTS = 4,
    parameter int STATE_WIDTH = 4
)(
    input clk,
    input clk_en,
    input sync_rst_n,

    input [DATA_WIDTH - 1 : 0] wr_data [WRITE_PORTS],
    input [STATE_WIDTH - 1 : 0] wr_state [WRITE_PORTS],

    input [WRITE_PORTS - 1 : 0] wr_data_en,
    input [WRITE_PORTS - 1 : 0] wr_state_en,
    input [ADDR_WIDTH - 1 : 0] wr_addr [WRITE_PORTS],

    input [READ_PORTS - 1 : 0] rd_data_en,
    input [READ_PORTS - 1 : 0] rd_state_en,
    input [ADDR_WIDTH - 1 : 0] rd_addr [READ_PORTS],

    output [DATA_WIDTH - 1 : 0] rd_data [READ_PORTS],
    output [STATE_WIDTH - 1 : 0] rd_state [READ_PORTS]
);

reg [DATA_WIDTH - 1 : 0] data_reg_file [PHYS_COUNT];
reg [STATE_WIDTH - 1 : 0] state_reg_file [PHYS_COUNT];

always_ff @(posedge clk) begin
    if (!sync_rst_n) begin
        for (int i = 0; i < WRITE_PORTS; i++) begin
            data_reg_file[wr_addr[i]] <= 0;
            state_reg_file[wr_addr[i]] <= 0;
        end
    end
    else if (clk_en) begin
        for (int i = 0; i < WRITE_PORTS; i++) begin
            if (wr_data_en[i]) begin
                data_reg_file[wr_addr[i]] <= wr_data;
            end
            else if (wr_state_en[i]) begin
                state_reg_file[wr_addr[i]] <= wr_state;
            end
        end
    end
end

always_comb begin
    for (int i = 0; i < READ_PORTS; i++) begin
        if (rd_data_en[i]) begin
            rd_data[i] = data_reg_file[rd_addr[i]];
        end
        else if (rd_state_en[i]) begin
            rd_state[i] = state_reg_file[rd_addr[i]];
        end
    end
end

endmodule
`default_nettype wire
