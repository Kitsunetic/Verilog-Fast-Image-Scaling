/*
16비트 데이터를 RGB로 변환
*/
module TFTLCDCtrl (  
    input               clk,    
    input               rst_n,
    input       [2:0]   convert_type,
    output      [15:0]  RGB,        // TFT-LCD Red signal
    output              write_en,
    output              stop,
    
    input       [15:0]  BRAMDATA,   // BRAM Data 16bits
    output reg  [15:0]  BRAMADDR    // BRAM Address
);

always@(posedge clk or negedge rst_n) begin
    if (!rst_n)    BRAMADDR <= 0;
    else if(!stop) BRAMADDR <= BRAMADDR + 1;
end

//assign RGB = BRAMDATA;

DSUS DSUS_i (
    .clk            (clk),
    .rst_n          (rst_n),
    .convert_type   (convert_type),
    .BRAMDATA       (BRAMDATA),
    .RGB_out        (RGB),
    .write_en_out   (write_en),
    .stop_out       (stop)
);

endmodule
