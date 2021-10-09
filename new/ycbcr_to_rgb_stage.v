`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:Dongho Park 
// 
// Create Date: 10/09/2021 02:41:50 AM
// Design Name: 
// Module Name: ycbcr_to_rgb_stage
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


module ycbcr_to_rgb_stage_y(
  input  clk,
  input  rst_n,

  input  valid_i,
  output valid_o,
  
  output [1:0] state_o,

  input  [7:0] y_data_i,
  output  [7:0] accum_data_o
);

reg [7:0] mat_mem [2:0];
reg [7:0] accum_r;
reg valid_r;
reg [1:0] state_r;


always @(posedge clk) begin
  if(!rst_n) begin
    accum_r <= 0;
    valid_r <= 0;
    state_r <= 0;
  end
  else begin
    if(valid_i) begin
      accum_r <= y_data_i;
      valid_r <= valid_i;
      state_r <= ((state_r == 2) ? 0 : (state_r + 1));
    end
  end
end

assign valid_o = valid_r;
assign state_o = state_r;
assign accum_data_o = accum_r;

endmodule
