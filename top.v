module top (
    input           clk,
    input           rst_n, 
    input   [2:0]   convert_type,
    output  [15:0]  LCD_RGB, // LCD signal
    output          write_en,
    output          stop
);

TFTLCDCtrl TFTLCDCtrl_i (      
    .clk            (clk),      
    .rst_n          (rst_n),
    .convert_type   (convert_type),
    .RGB            (LCD_RGB),
    .write_en       (write_en),
    .stop           (stop),
      
    .BRAMADDR       (BRAMADDRA),      
    .BRAMDATA       (BRAMDATA)      
);

bufferram bufferram_i (
    .addra          (BRAMADDRA),
    .douta          (BRAMDATA)
);

endmodule
