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
    input valid,

    input [READ_PORTS - 1:0] rd_en,

    output [PHYS_ADDR_WIDTH - 1:0] rd_arch_addr [READ_PORTS],
    output [VIRT_ADDR_WIDTH - 1:0] rd_virt_addr [READ_PORTS]
);

endmodule
