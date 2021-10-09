`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2021 11:09:30 PM
// Design Name: 
// Module Name: rgb_to_ycbcr
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


module rgb_to_ycbcr(
  input  clk,
  input  rst_n,

  input  valid_i,
  output valid_o,

  input  [7:0] rgb_data_i,
  output [7:0] y_data_o,
  output [7:0] cb_data_o,
  output [7:0] cr_data_o
);

wire stage_1_valid_w;
wire stage_2_valid_w;

wire [1:0] stage_1_status_w;
wire [1:0] stage_2_status_w;

wire [16:0] stage_1_y_data_w;
wire [16:0] stage_1_cb_data_w;
wire [16:0] stage_1_cr_data_w;

wire [16:0] stage_2_y_data_w;
wire [16:0] stage_2_cb_data_w;
wire [16:0] stage_2_cr_data_w;

rgb_to_ycbcr_stage_1 rgb_to_ycbcr_stage_1(
  .clk(clk),
  .rst_n(rst_n),

  .valid_i(valid_i),
  .valid_o(stage_1_valid_w),
  
  .status_o(stage_1_status_w),

  .rgb_data_i(rgb_data_i),
  .y_data_o (stage_1_y_data_w),
  .cb_data_o(stage_1_cb_data_w),
  .cr_data_o(stage_1_cr_data_w)
);

rgb_to_ycbcr_stage_2 rgb_to_ycbcr_stage_2(

  .clk(clk),
  .rst_n(rst_n),

  .valid_i(stage_1_valid_w),
  .valid_o(stage_2_valid_w),
  
  .status_i(stage_1_status_w),  
  .status_o(stage_2_status_w),

  .y_data_i (stage_1_y_data_w),
  .cb_data_i(stage_1_cb_data_w),
  .cr_data_i(stage_1_cr_data_w),
  
  .y_data_o (stage_2_y_data_w),
  .cb_data_o(stage_2_cb_data_w),
  .cr_data_o(stage_2_cr_data_w)
);

rgb_to_ycbcr_stage_3 rgb_to_ycbcr_stage_3(

  .clk(clk),
  .rst_n(rst_n),

  .valid_i(stage_2_valid_w),
  .valid_o(valid_o),
  
  .status_i(stage_2_status_w),
  
  .y_data_i (stage_2_y_data_w),
  .cb_data_i(stage_2_cb_data_w),
  .cr_data_i(stage_2_cr_data_w),

  .y_data_o(y_data_o),
  .cb_data_o(cb_data_o),
  .cr_data_o(cr_data_o)
);

endmodule
