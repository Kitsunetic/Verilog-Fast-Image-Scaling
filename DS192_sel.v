/*
*/
module DS192_sel (
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
reg         [1:0]       xcnt;
reg         [1:0]       ycnt;
reg         [7:0]       fx;
reg [7:0] mem [127:0];
reg [6:0] mem_addr;

assign write_en     = ycnt != 2'b01 && xcnt != 2'b01;

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
            ycnt <= ycnt + 1;
            mem_addr <= 0;
        end
        if(xcnt != 2'b01) mem_addr <= mem_addr + 1;
        xcnt <= xcnt + 1;
        fx <= fx + 1;
    end
end


always @(posedge clk) case({ycnt, xcnt})
    // line 1st and 4'th
    4'b0000, 4'b1100: dout <= din;
    4'b0001, 4'b1101: mem[mem_addr] <= din>>1;
    4'b0010, 4'b1110: dout <= din>>1 + mem[mem_addr];
    4'b0011, 4'b1111: dout <= din;
    
    // line 2nd
    4'b0100: mem[mem_addr] <= din>>1;
    4'b0101: mem[mem_addr] <= din>>2;
    4'b0110: mem[mem_addr] <= din>>2 + mem[mem_addr];
    4'b0111: mem[mem_addr] <= din>>1;
    
    // line 3nd
    4'b0100: dout <= din>>1 + mem[mem_addr];
    4'b0101: mem[mem_addr] <= din>>2 + mem[mem_addr];
    4'b0110: dout <= din>>2 + mem[mem_addr];
    4'b0111: dout <= din>>1 + mem[mem_addr];
endcase

endmodule
