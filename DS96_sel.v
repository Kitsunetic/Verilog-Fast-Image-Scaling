/*
*/
module DS96_sel (
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
reg         [2:0]   xcnt;
reg         [2:0]   ycnt;
reg         [7:0]   fx;
reg         [7:0]   mem [95:0];
reg         [6:0]   mem_addr;

assign write_en = (ycnt == 3'b001 || ycnt == 3'b101 || ycnt == 3'b111) &&
                  (xcnt == 3'b001 || xcnt == 3'b101 || xcnt == 3'b111);

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
            ycnt     <= ycnt + 1;
            mem_addr <= 0;
        end
        else if(xcnt == 3'b001 || xcnt == 3'b101 || xcnt == 3'b111) begin
            mem_addr <= mem_addr + 1;
        end
        xcnt <= xcnt + 1;
        fx <= fx + 1;
    end
end

always @(posedge clk) case({ycnt, xcnt})
    6'b000000, 6'b110000: mem[mem_addr] <= din>>2;
    6'b000001, 6'b110001: mem[mem_addr] <= din>>2 + mem[mem_addr];
    6'b000010, 6'b110010: mem[mem_addr] <= din>>3;
    6'b000011, 6'b110011: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b000100, 6'b110100: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b000101, 6'b110101: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b000110, 6'b110110: mem[mem_addr] <= din>>2;
    6'b000111, 6'b110111: mem[mem_addr] <= din>>2 + mem[mem_addr];
                                                        
    6'b001000, 6'b111000: mem[mem_addr] <= din>>2 + mem[mem_addr];
    6'b001001, 6'b111001:          dout <= din>>2 + mem[mem_addr];
    6'b001010, 6'b111010: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b001011, 6'b111011: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b001100, 6'b111100: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b001101, 6'b111101:          dout <= din>>3 + mem[mem_addr];
    6'b001110, 6'b111110: mem[mem_addr] <= din>>2 + mem[mem_addr];
    6'b001111, 6'b111111:          dout <= din>>2 + mem[mem_addr];
                                                        
    6'b010000:            mem[mem_addr] <= din>>3;
    6'b010001:            mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b010010:            mem[mem_addr] <= din>>4;
    6'b010011:            mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b010100:            mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b010101:            mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b010110:            mem[mem_addr] <= din>>3;
    6'b010111:            mem[mem_addr] <= din>>3 + mem[mem_addr];
                                                        
    6'b011000, 6'b100000: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b011001, 6'b100001: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b011010, 6'b100010: mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b011011, 6'b100011: mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b011100, 6'b100100: mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b011101, 6'b100101: mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b011110, 6'b100110: mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b011111, 6'b100111: mem[mem_addr] <= din>>3 + mem[mem_addr];
                                                        
    6'b101000:            mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b101001:                     dout <= din>>3 + mem[mem_addr];
    6'b101010:            mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b101011:            mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b101100:            mem[mem_addr] <= din>>4 + mem[mem_addr];
    6'b101101:                     dout <= din>>4 + mem[mem_addr];
    6'b101110:            mem[mem_addr] <= din>>3 + mem[mem_addr];
    6'b101111:                     dout <= din>>3 + mem[mem_addr];
endcase
endmodule
