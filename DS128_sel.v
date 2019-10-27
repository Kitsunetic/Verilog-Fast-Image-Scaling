/*
*/
module DS128_sel (
    clk,
    rst_n,
    din,
    dout,
    write_en
);

input               clk;
input               rst_n;
input       [7:0]   din;
output reg     [7:0]   dout;
output              write_en;
reg                 xcnt;
reg                 ycnt;
reg         [7:0]   fx;
reg         [7:0]   mem [127:0];
reg         [6:0]   mem_addr;

assign write_en = ycnt & xcnt;

// specify reset and counters
always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        xcnt        <= 0;
        ycnt        <= 0;
        fx          <= 0;
        mem_addr    <= 0;
    end
    else begin
        if(fx == 255) begin
            ycnt <= ~ycnt;
            mem_addr <= 0;
        end
        xcnt <= ~xcnt;
        fx <= fx + 1;
        mem_addr <= mem_addr + 1;
    end
end

always @(posedge clk) case({ycnt, xcnt})
    2'b00: mem[mem_addr] <= din >> 2;
    2'b01: mem[mem_addr] <= mem[mem_addr] + din >> 2;
    2'b10: mem[mem_addr] <= mem[mem_addr] + din >> 2;
    2'b11: dout <= mem[mem_addr] + din >> 2;
endcase

endmodule
