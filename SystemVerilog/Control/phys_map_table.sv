module phys_map_table #(
    parameter int CELLS = 128,
    parameter int VIRT_COUNT = 128,
    parameter int VIRT_ADDR_WIDTH = $clog2(VIRT_COUNT),
    parameter int WRITE_PORTS = 4,
    parameter int READ_PORTS = 4,
    parameter int PHYS_ADDR_WIDTH = $clog2(CELLS)
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire [WRITE_PORTS - 1:0] wr_en,
    input wire [WRITE_PORTS - 1:0][PHYS_ADDR_WIDTH - 1:0] wr_addr,

    input wire [WRITE_PORTS - 1:0][VIRT_ADDR_WIDTH - 1:0] tag_in,

    input wire [READ_PORTS - 1:0] rd_en,

    output reg [READ_PORTS - 1:0][PHYS_ADDR_WIDTH - 1:0] rd_addr,
    output reg [READ_PORTS - 1:0] cam_hit
);

reg [VIRT_ADDR_WIDTH - 1:0] cam_array [CELLS];

generate
genvar i;
    for (i = 0; i < WRITE_PORTS; i = i + 1) begin: gen_writecam
        always_ff @(posedge clk) begin
            if (!sync_rst_n) begin: Reset
                cam_array[wr_addr[i]] <= '0;
            end: Reset
            else if (clk_en && wr_en[i]) begin: updateTag
                cam_array[wr_addr[i]] <= tag_in;
            end: updateTag
        end
    end: gen_writecam
endgenerate

//Tag search
generate
genvar j;
    for (j = 0; j < READ_PORTS; j = j + 1) begin: gen_readcam
        always_comb begin
            for (int i = 0; i < CELLS; i = i + 1) begin
                if ((rd_en[j]) && (cam_array[i] == tag_in[j])) begin
                    rd_addr[j] = i;
                    cam_hit[j] = 1'b1;
                    break;
                end
            end
        end
    end: gen_readcam
endgenerate

endmodule
