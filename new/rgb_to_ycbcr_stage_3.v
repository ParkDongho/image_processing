`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2021 01:19:26 AM
// Design Name: 
// Module Name: rgb_to_ycbcr_stage_3
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


module rgb_to_ycbcr_stage_3( 

  input  clk,
  input  rst_n,

  input  valid_i,
  output valid_o,
  
  
  input  [1:0] status_i,

  input signed [16:0] y_data_i,
  input signed [16:0] cb_data_i,
  input signed [16:0] cr_data_i,

  output [7:0] y_data_o,
  output [7:0] cb_data_o,
  output [7:0] cr_data_o
);

reg signed [16:0] y_data_r;
reg signed [16:0] cb_data_r;
reg signed [16:0] cr_data_r;

reg valid_1_r;
reg valid_2_r;
reg valid_3_r;

always @(posedge clk) begin
  if(!rst_n) begin
    y_data_r <= 0;
    cb_data_r <= 0;
    cr_data_r <= 0;
    
    valid_1_r <= 0;
    valid_2_r <= 0;
    valid_3_r <= 0;
  end
  else begin
    if(valid_i & (status_i==0)) begin
      y_data_r  <= y_data_i;
      cb_data_r <= cb_data_i;
      cr_data_r <= cr_data_i;
      
      valid_1_r <= 1;
      valid_2_r <= 1;
      valid_3_r <= 1;
    end
    else begin
      valid_1_r <= valid_2_r;
      valid_2_r <= valid_3_r;
      valid_3_r <= 0;
    end
  end
end

assign y_data_o = y_data_r[16] ? 0 : y_data_r[15:8];
assign cb_data_o = cb_data_r[16] ? 0 : cb_data_r[15:8];
assign cr_data_o = cr_data_r[16] ? 0 : cr_data_r[15:8];

assign valid_o = valid_1_r;

endmodule
