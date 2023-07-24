`default_nettype none

// verilog_lint: waive-start line-length
// verilog_lint: waive-start parameter-name-style

module load_store_queue #(
    parameter int MEM_ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32,
    parameter int ENTRIES = 128
)(
    input wire clk,
    input wire clk_en,
    input wire sync_rst_n,

    input wire push_queue,

    input wire load_store_en, //if 0, load_en, if 1, store_en
    input wire [MEM_ADDR_WIDTH - 1 : 0] mem_addr_in,
    input wire [DATA_WIDTH - 1 : 0] mem_data_in,
    input wire mem_commit,

    input wire pop_queue,

    output reg [MEM_ADDR_WIDTH - 1 : 0] mem_addr_out,
    output reg [DATA_WIDTH - 1 : 0] mem_data_out
);

typedef struct packed {
    reg load_store;
    reg [MEM_ADDR_WIDTH - 1 : 0] mem_addr;
    reg [DATA_WIDTH - 1 : 0] mem_data;
    reg commit;
} mem_load_store_queue_t;

mem_load_store_queue_t mem_lsq [ENTRIES];

always_ff @(clk) begin
    if (!sync_rst_n) begin
        for (int i = 0; i < ENTRIES; i = i + 1) begin
            mem_lsq[i].load_store <= 0;
            mem_lsq[i].mem_addr <= 0;
            mem_lsq[i].mem_data <= 0;
            mem_lsq[i].commit <= 0;
        end
    end else if (clk_en) begin
        if (push_queue) begin
            if (load_store_en == 1'b0) begin
                mem_lsq[0].load_store <= 1'b0;  //load
                mem_lsq[0].mem_addr <= mem_addr_in;
            end
        end else if (pop_queue) begin
            if (mem_lsq[ENTRIES - 1].commit) begin
                mem_addr_out <= mem_lsq[ENTRIES - 1].mem_addr;
                mem_data_out <= mem_lsq[ENTRIES - 1].mem_data;
            end
        end
    end
end

endmodule

`default_nettype wire
