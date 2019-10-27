module DS64_sel (
    clk,
    rst_n,
    din,
    dout,
    write_en
);

input               clk;
input               rst_n;
input       [7:0]   din;
output reg  [7:0]   dout;
output              write_en;
reg         [1:0]   xcnt;
reg         [1:0]   ycnt;
reg         [7:0]   fx;
reg         [7:0]   mem [63:0];
reg         [6:0]   mem_addr;

assign write_en = (ycnt == 2'b11) & (xcnt == 2'b11);

// specify reset and counters
always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        // reset
        dout        <= 0;
        
        xcnt        <= 0;
        ycnt        <= 0;
        mem_addr    <= 0;
        fx          <= 0;
    end
    else begin
        if(fx == 255) begin
            ycnt     <= ycnt + 1;
            mem_addr <= 0;
        end
        else if(xcnt == 2'b11) begin
            mem_addr <= mem_addr + 1;
        end
        xcnt <= xcnt + 1;
        fx <= fx + 1;
    end
end

always @(posedge clk) begin
    if((ycnt == 2'b00) & (xcnt == 2'b00)) mem[mem_addr] <= din>>4;
    else if(ycnt == 2'b11 && xcnt == 2'b11) dout <= mem[mem_addr] + din>>4;
    else mem[mem_addr] <= din>>4 + mem[mem_addr];
end
endmodule
