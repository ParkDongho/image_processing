`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2021 11:29:26 PM
// Design Name: 
// Module Name: contrast_enhancer
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


module contrast_enhancer(
  input  clk,
  input  rst_n,

  input  valid_i,
  output valid_o,

  input  [7:0] y_data_i,
  input  [7:0] cb_data_i,
  input  [7:0] cr_data_i,

  output [7:0] y_data_o,
  output [7:0] cb_data_o,
  output [7:0] cr_data_o
);
reg valid_r;
reg [7:0] cb_data_r, cr_data_r;
  
always @(posedge clk) begin
  if(!rst_n) begin
    valid_r <= 0;
    cb_data_r <= 0;
    cr_data_r <= 0;  
  end
  else begin
    valid_r <= valid_i;
    cb_data_r <= cb_data_i;
    cr_data_r <= cr_data_i;
  end 
end

sram sram(
  .clk(clk),
  .data_i(y_data_i),
  .data_o(y_data_o)  
);

assign cb_data_o = cb_data_r;
assign cr_data_o = cr_data_r;
assign valid_o = valid_r;

endmodule
