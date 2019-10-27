/*

*/
`timescale 1ns / 1ps

module tb_top;

parameter CONVERT_TYPE_NONE     = 15;
parameter CONVERT_TYPE_DS_192   = 0;
parameter CONVERT_TYPE_DS_128   = 1;
parameter CONVERT_TYPE_DS_96    = 2;
parameter CONVERT_TYPE_DS_64    = 3;
parameter CONVERT_TYPE_US_192   = 4;
parameter CONVERT_TYPE_US_128   = 5;
parameter CONVERT_TYPE_US_96    = 6;
parameter CONVERT_TYPE_US_64    = 7;

parameter CONVERT_TYPE_TESTBENCH= CONVERT_TYPE_DS_64;

wire    [15:0]  LCD_RGB;
wire            write_en;
reg             clk;
reg             rst_n;
reg     [16:0]  pixel_counter;
reg     [2:0]   convert_type;

top top_a(
    .clk            (clk), 
    .rst_n          (rst_n), 
    .convert_type   (convert_type),
    .LCD_RGB        (LCD_RGB),
    .write_en       (write_en)
);

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
        convert_type  <= CONVERT_TYPE_TESTBENCH;
    end 
    else if(pixel_counter == 17'h1_0000) begin
        $stop;
    end 
    else begin
        pixel_counter <= pixel_counter + 1;
    end
end

integer fd;
initial fd = $fopen("output.txt", "w");
always@(posedge clk) begin
    if (pixel_counter == 17'h1_0000) begin
        $fclose(fd);
    end
    else if(write_en) begin
        $fwrite(fd, "%h\n", LCD_RGB);
    end
end
endmodule
