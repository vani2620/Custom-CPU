    module regfile_state_tracker #(
        parameter int PHYS_COUNT = 128,
        parameter int ARCH_COUNT = 32,
        parameter int WRITE_PORTS = 4,
        parameter int READ_PORTS = 8,
        parameter int ADDR_WIDTH = $clog2(PHYS_COUNT)
    )(
        input wire clk,
        input wire sync_rst_n,

        input wire [WRITE_PORTS - 1:0] alloc_reg,
        input wire [WRITE_PORTS - 1:0] valid_reg,
        input wire [WRITE_PORTS - 1:0] reclaim_reg,

        input wire [WRITE_PORTS - 1:0] wr_en,
        input wire [ADDR_WIDTH - 1:0] wr_addr [WRITE_PORTS],

        input wire [READ_PORTS - 1:0] rd_en,
        input wire [ADDR_WIDTH - 1:0] rd_addr [READ_PORTS],

        output reg [3:0] rd_state
    );

    reg [PHYS_COUNT - 1:0] state_table [4];

    initial begin
        for (int i = 1; i < PHYS_COUNT; i = i + 1) begin
            if (i < ARCH_COUNT) begin
                state_table[i] <= 'b1000;
            end
            else if (i >= ARCH_COUNT && i < PHYS_COUNT) begin
                state_table[i] <= 'b0000;
            end
        end
    end



    endmodule
