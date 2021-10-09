`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2021 08:29:14 PM
// Design Name: 
// Module Name: sram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sram(
  input clk,
  input  [7:0] data_i,
  output reg [7:0] data_o
);
   (* rom_style="block" *)
   reg [7:0] rom_data [255:0];
   integer i;
   real func_result;
   real j;
   
   
   initial begin
     for(i = 0; i < 256; i=i+1) begin
       j = i;
       /*
       if(i<90) begin //0~89
         func_result = 0;
       end
       else if(i<155) begin //90~154
         func_result = ((90.0-0.0)/(155.0-90.0))*(j-90.0);
       end
       else if(i<195) begin //155~194
         func_result = (123.0-90.0)/(195.0-155.0)*(j-155.0)+90.0;
       end
       else if(i<213) begin //195~212
         func_result = (255.0-123.0)/(213.0-195.0)*(j-195.0)+123.0;
       end
       else begin
         func_result = 255;
       end
       */
       
       
       func_result = j;
       if(func_result>255) begin
         func_result = 255;
       end
       
       rom_data[i] = func_result;
       
     end
   end

   always @(posedge clk) begin
     data_o <= rom_data[data_i];
   end
endmodule
