module gen_map_table #(
    parameter int ARCH_COUNT = 32,
    parameter int ARCH_ADDR_WIDTH = $clog2(ARCH_COUNT),
    parameter int VIRT_COUNT = 256,
    parameter int VIRT_ADDR_WIDTH = $clog2(VIRT_COUNT),
    parameter int WRITE_PORTS = 4,
    parameter int READ_PORTS = 8,
    parameter int PHYS_ADDR_WIDTH = $clog2(CELLS)
)(
    input clk,
    input clk_en,
    input sync_rst_n,

    input [WRITE_PORTS - 1:0] wr_en,
    input [ARCH_ADDR_WIDTH - 1:0] wr_tbl_addr [WRITE_PORTS],

    input [PHYS_ADDR_WIDTH - 1:0] wr_arch_addr [WRITE_PORTS],
    input [VIRT_ADDR_WIDTH - 1:0] wr_virt_addr [WRITE_PORTS],
    input i_valid,

    input [READ_PORTS - 1:0] rd_en,
    input [ARCH_ADDR_WIDTH - 1:0] rd_tbl_addr [READ_PORTS],

    output valid_o,
    output [PHYS_ADDR_WIDTH - 1:0] rd_phys_addr [READ_PORTS],
    output [VIRT_ADDR_WIDTH - 1:0] rd_virt_addr [READ_PORTS]
);

typedef struct packed {
    reg map_valid [ARCH_COUNT];
    reg [VIRT_ADDR_WIDTH - 1:0] virt_addr [ARCH_COUNT];
    reg [PHYS_ADDR_WIDTH - 1:0] phys_addr [ARCH_COUNT];
} map_table_t;

//Reset
always_ff @(posedge clk or negedge sync_rst_n) begin
    if (!sync_rst_n) begin
        map_valid <= 0;
        virt_addr <= 0;
        phys_addr <= 0;
    end
end

//Write mappings
generate
    genvar i;
    for (i = 0; i < WRITE_PORTS; i = i + 1) begin: gen_writeGMT
        always_ff @(posedge clk) begin
            if (clk_en && wr_en[i]) begin
                map_valid[wr_tbl_addr[i]] <= valid;
                virt_addr[wr_tbl_addr[i]] <= wr_virt_addr[i];
                phys_addr[wr_tbl_addr[i]] <= wr_phys_addr[i];
            end
        end
    end
endgenerate

generate
    genvar j;
    for (j = 0; j < READ_PORTS; j = j + 1) begin: gen_readGMT
        always_comb begin
            if (read_en[j]) begin
                rd_virt_addr[j] = virt_addr[rd_tbl_addr[j]];
                valid_o[j] = map_valid[j];
                rd_phys_addr[j] = map_valid[rd_tbl_addr[j]];
            end
        end
    end
endgenerate
endmodule
