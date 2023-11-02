`default_nettype none
// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module regfile_state_tracker #(
    parameter int PHYS_COUNT = 16,
    parameter int ARCH_COUNT = 8,
    parameter int WRITE_PORTS = 4,
    parameter int READ_PORTS = 8,
    parameter int ADDR_WIDTH = $clog2(PHYS_COUNT)
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire [WRITE_PORTS - 1:0] wr_en,
    input wire [ADDR_WIDTH - 1:0] wr_addr [WRITE_PORTS],

    input wire [READ_PORTS - 1:0] rd_en,
    input wire [ADDR_WIDTH - 1:0] rd_addr [READ_PORTS],

    input wire [WRITE_PORTS - 1:0] valid,
    input wire [WRITE_PORTS - 1:0] reclaim_cancel,
    input wire [WRITE_PORTS - 1:0] commit_reg,

    output reg [3:0] rd_state [READ_PORTS]
);

typedef enum logic [3:0] {
    FREE = 4'b0001,
    RENAME_BUFFER_NOT_VALID = 4'b0010,
    RENAME_BUFFER_VALID = 4'b0100,
    ARCHITECTURAL = 4'b1000
} reg_state_e;

reg [PHYS_COUNT - 1:0][WRITE_PORTS - 1:0][3:0] state_table;
reg [PHYS_COUNT - 1:0][WRITE_PORTS - 1:0][3:0] next_state_table;

initial begin
    for (int i = 0; i < WRITE_PORTS; i = i + 1) begin
        for (int j = 1; j < PHYS_COUNT; j = j + 1) begin
            if (j < ARCH_COUNT) begin
                next_state_table[j[i]] <= ARCHITECTURAL;
            end
            else if ((j >= ARCH_COUNT) && (j < PHYS_COUNT)) begin
                next_state_table[j[i]] <= FREE;
            end
            state_table[j][i] <= next_state_table[j][i];
        end
    end
end

always_ff @(posedge clk) begin
    //Reset logic
    if (!sync_rst_n) begin
        for (int k = 0; k < WRITE_PORTS; k = k + 1) begin
            for (int l = 0; l < PHYS_COUNT; l = l + 1) begin
                if (k < ARCH_COUNT) begin
                    state_table[l[k]] <= ARCHITECTURAL;
                end
                else if ((k >= ARCH_COUNT) && (k < PHYS_COUNT)) begin
                    state_table[l[k]] <= FREE;
                end
            end
        end
    end
    //Update logic
    else if (clk_en) begin
        for (int m = 0; m < WRITE_PORTS; m = m + 1) begin
            if (wr_en[m]) begin
                if ((reclaim_cancel[m]) && (state_table[wr_addr[m]] != FREE)) begin
                    next_state_table[wr_addr[m]] <= FREE;
                end
                else if ((valid[m]) && (state_table[wr_addr[m]] == RENAME_BUFFER_NOT_VALID)) begin
                    next_state_table[wr_addr[m]] <= RENAME_BUFFER_VALID;
                end
                else if ((commit_reg[m]) && (state_table[wr_addr[m]] == RENAME_BUFFER_VALID)) begin
                    next_state_table[wr_addr[m]] <= ARCHITECTURAL;
                end
                state_table[wr_addr[m]] <= next_state_table [wr_addr[m]];
            end
        end
    end
end

always_comb begin
    for (int n = 0; n < READ_PORTS; n = n + 1) begin
        if (rd_en[n]) begin
            rd_state[n] = state_table[rd_addr[n]];
        end
    end
end

endmodule

`default_nettype wire
