/*
module RGB_separate.v

Convert 15bit `RGB_in` into 8bit `R`, `G`, `B`.
*/
module RGB_separate(RGB_in, R, G, B);

input   [15:0]  RGB_in;
output   [7:0]  R;
output   [7:0]  G;
output   [7:0]  B;

assign R = {RGB_in[15:11], 3'b0};
assign G = {RGB_in[10: 5], 2'b0};
assign B = {RGB_in[ 4: 0], 3'b0};

endmodule
