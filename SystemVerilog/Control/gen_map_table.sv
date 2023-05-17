module gen_map_table #(
    parameter int ARCH_COUNT = 32,
    parameter int ARCH_ADDR_WIDTH = $clog2(ARCH_COUNT),
    parameter int VIRT_COUNT = 128,
    parameter int VIRT_ADDR_WIDTH = $clog2(VIRT_COUNT),
    parameter int WRITE_PORTS = 4,
    parameter int READ_PORTS = 8,
    parameter int PHYS_ADDR_COUNT = 128,
    parameter int PHYS_ADDR_WIDTH = $clog2(PHYS_ADDR_COUNT)
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire [WRITE_PORTS - 1:0] wr_en,
    input wire [ARCH_ADDR_WIDTH - 1:0] tbl_wr_addr [WRITE_PORTS],

    input wire [PHYS_ADDR_WIDTH - 1:0] wr_phys_addr [WRITE_PORTS],
    input wire [VIRT_ADDR_WIDTH - 1:0] wr_virt_addr [WRITE_PORTS],
    input wire i_valid,

    input wire [READ_PORTS - 1:0] rd_en,
    input wire [ARCH_ADDR_WIDTH - 1:0] tbl_rd_addr [READ_PORTS],

    output reg valid_o,
    output reg [PHYS_ADDR_WIDTH - 1:0] rd_phys_addr [READ_PORTS],
    output reg [VIRT_ADDR_WIDTH - 1:0] rd_virt_addr [READ_PORTS]
);

typedef struct {
    reg map_valid [ARCH_COUNT];
    reg [VIRT_ADDR_WIDTH - 1:0] virt_addr [ARCH_COUNT];
    reg [PHYS_ADDR_WIDTH - 1:0] phys_addr [ARCH_COUNT];
} map_table_t;

map_table_t tbl;

//Reset or write
always_ff @(posedge clk or negedge sync_rst_n) begin
    for (int i = 0; i < ARCH_COUNT; i = i + 1) begin
        if (!sync_rst_n) begin
            tbl.map_valid[i] <= '0;
            tbl.virt_addr[i] <= '0;
            tbl.phys_addr[i] <= '0;
        end
    end
    for (int i = 0; i < WRITE_PORTS; i = i + 1) begin
        if (clk_en && wr_en[i]) begin
            tbl.map_valid[tbl_wr_addr[i]] <= i_valid;
            tbl.virt_addr[tbl_wr_addr[i]] <= wr_virt_addr[i];
            tbl.phys_addr[tbl_wr_addr[i]] <= wr_phys_addr[i];
        end
    end
end


always_comb begin
    for (int j = 0; j < READ_PORTS; j = j + 1) begin
        if (rd_en[j]) begin
            rd_virt_addr[j] = tbl.virt_addr[tbl_rd_addr[j]];
            valid_o = tbl.map_valid[j];
            rd_phys_addr[j] = tbl.phys_addr[tbl_rd_addr[j]];
        end
    end
end
endmodule
