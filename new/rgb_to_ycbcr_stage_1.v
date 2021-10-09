`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2021 12:40:37 AM
// Design Name: 
// Module Name: rgb_to_ycbcr_stage_1
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


module rgb_to_ycbcr_stage_1(

  input  clk,
  input  rst_n,

  input  valid_i,
  output valid_o,
  
  output  [1:0] status_o,

  input          [7:0] rgb_data_i,
  output signed [16:0] y_data_o,
  output signed [16:0] cb_data_o,
  output signed [16:0] cr_data_o
);

reg signed [16:0] y_data_r;
reg signed [16:0] cb_data_r;
reg signed [16:0] cr_data_r;

reg signed [16:0] y_mat_mem [2:0];
reg signed [16:0] cb_mat_mem [2:0];
reg signed [16:0] cr_mat_mem [2:0];

reg valid_r;
reg [1:0] status_r;

wire signed [16:0] y_mat_w;
wire signed [16:0] cb_mat_w;
wire signed [16:0] cr_mat_w;

initial begin
  y_mat_mem[0] = 77;    //0.299
  y_mat_mem[1] = 150;   //0.587
  y_mat_mem[2] = 29;    //0.114
  
  cb_mat_mem[0] = -43;  //-0.169
  cb_mat_mem[1] = -85;  //-0.331
  cb_mat_mem[2] = 128;  //0.500
  
  cr_mat_mem[0] = 128;  //0.500
  cr_mat_mem[1] = -107; //-0.419
  cr_mat_mem[2] = -21;  //-0.081SSSS
end

always @(posedge clk) begin
  if(!rst_n) begin
    y_data_r <= 0;
    cb_data_r <= 0;
    cr_data_r <= 0;
    valid_r <= 0;
    
    status_r <= 0;
  end
  else begin
    valid_r <= valid_i;
    if(valid_i) begin
      y_data_r  <= y_mat_w;
      cb_data_r <= cb_mat_w;
      cr_data_r <= cr_mat_w;
      status_r <= ((status_r == 2) ? 0 : (status_r + 1));
    end
  end
end

assign y_mat_w  = rgb_data_i *  y_mat_mem[status_r];
assign cb_mat_w = rgb_data_i * cb_mat_mem[status_r];
assign cr_mat_w = rgb_data_i * cr_mat_mem[status_r];

assign y_data_o = y_data_r;
assign cb_data_o = cb_data_r;
assign cr_data_o = cr_data_r;

assign status_o = status_r;
assign valid_o = valid_r;

endmodule
