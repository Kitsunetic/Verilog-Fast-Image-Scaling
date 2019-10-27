module RGB_compress(R, G, B, RGB_out);

input   [7:0]   R, G, B;
output  [15:0]  RGB_out;

assign RGB_out = {R[4:0], G[5:0], B[4:0]};

endmodule
