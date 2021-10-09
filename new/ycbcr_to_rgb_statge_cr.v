`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dongho Park
// 
// Create Date: 10/09/2021 04:44:27 PM
// Design Name: 
// Module Name: ycbcr_to_rgb_statge_cr
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


module ycbcr_to_rgb_statge_cr(
  input  clk,
  input  rst_n,

  input  valid_i,
  output valid_o,
  
  input  [1:0] state_i,
  output [1:0] state_o,

  input  [7:0] cr_data_i,
  input  signed [16:0] accum_data_i,
  output  [7:0] accum_data_o
  
);

reg signed [16:0] cr_data_1_r, cr_data_2_r;
reg signed [16:0] mat_mem [2:0];
reg signed [16:0] accum_r;
reg [1:0] state_r;
reg valid_r;

wire signed [16:0] mul_result_w;
wire signed [16:0] add_result_w;

initial begin
  mat_mem[0] = 358;
  mat_mem[1] = -182;
  mat_mem[2] = 0;
end


always @(posedge clk) begin
  if(!rst_n) begin
    cr_data_1_r <= 0;
    cr_data_2_r <= 0;
    accum_r <= 0;
    state_r <= 0;
    valid_r <= 0;
  end
  else begin
    cr_data_1_r <= $signed({1'b0, cr_data_i}) - 128;
    cr_data_2_r <= cr_data_1_r;
    if(valid_i) begin
      if(add_result_w[16]) begin
        accum_r <= 0;
      end
      else begin
        accum_r <= add_result_w[15:8];
      end
      state_r <= state_i;
      valid_r <= valid_i;
    end
  end
end

assign valid_o = valid_r;
assign state_o = state_r;
assign accum_data_o = accum_r;
assign mul_result_w = cr_data_2_r*mat_mem[state_r]; 
assign add_result_w = mul_result_w + accum_data_i;

endmodule
