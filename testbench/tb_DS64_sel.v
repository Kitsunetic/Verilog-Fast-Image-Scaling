/*

*/
`timescale 1ns / 1ps

module tb_DS64_sel;

wire            write_en;
reg             clk;
reg             rst_n;
reg     [16:0]  pixel_counter;

wire     [15:0]  BRAMDATA;

wire [23:0] RGB_sep, RGB_com;
wire [15:0] RGB;


bufferram bufferram_i (
    .addra          (pixel_counter),
    .douta          (BRAMDATA)
);

RGB_separate RGB_separate_module (
    .RGB_in  (BRAMDATA),
    .R       (RGB_sep[23:16]),
    .G       (RGB_sep[15:8 ]),
    .B       (RGB_sep[7 :0 ])
);

RGB_compress RGB_compress_module (
    .R              (RGB_com[23:16]),
    .G              (RGB_com[15:8 ]),
    .B              (RGB_com[7 :0 ]),
    .RGB_out        (RGB)
);

genvar i;
generate for(i = 23; i > 0; i = i-8) begin: DS64_
    DS64_sel DS64_module (
        .clk (clk),
        .rst_n (rst_n),
        .din (RGB_sep[i:i-7]),
        .dout (RGB_com[i:i-7]),
        .write_en (write_en)
    );
end
endgenerate


initial begin
    rst_n = 0;
    #30 rst_n = 1;
end

initial begin
    clk = 0;
    forever #40 clk = ~clk;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pixel_counter <= 0;
    end 
    else if(pixel_counter == 17'h1_0000) begin
        $fclose(fd);
    end 
    else begin
        pixel_counter <= pixel_counter + 1;
    end
end

integer fd;
initial fd = $fopen("output 64.txt", "w");
always@(posedge clk) begin
    if (pixel_counter != 17'h1_0000 && write_en) begin
        $fwrite(fd, "%h\n", RGB);
    end
end

endmodule
