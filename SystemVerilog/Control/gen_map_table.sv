module gen_map_table #(
    parameter int ARCH_COUNT = 32,
    parameter int ARCH_ADDR_WIDTH = $clog2(ARCH_COUNT),
    parameter int VIRT_COUNT = 256,
    parameter int VIRT_ADDR_WIDTH = $clog2(VIRT_COUNT),
    parameter int WRITE_PORTS = 4,
    parameter int READ_PORTS = 4,
    parameter int PHYS_ADDR_WIDTH = $clog2(CELLS)
)(
    input clk,
    input clk_en,
    input sync_rst_n,

    input [ARCH_ADDR_WIDTH - 1:0] arch_addr [WRITE_PORTS]
);

endmodule
