`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2021 04:40:44 PM
// Design Name: 
// Module Name: dut
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


module dut(
  input clk,
  input rst_n,
  
  input  s_axis_tvalid, 
  output s_axis_tready,
  input  [7:0] s_axis_tdata,

  output m_axis_tvalid,
  input  m_axis_tready,
  output [7:0] m_axis_tdata
);


wire [7:0] result;
wire valid_rgb_to_ycbcr, valid_ycbcr_to_rgb;
wire valid_contrast_enhancer;

wire [7:0] y_data_in_w, cb_data_in_w, cr_data_in_w;
wire [7:0] y_data_out_w, cb_data_out_w, cr_data_out_w;

rgb_to_ycbcr rgb_to_ycbcr(
  .clk(clk),
  .rst_n(rst_n),

  .valid_i(s_axis_tvalid),
  .valid_o(valid_rgb_to_ycbcr),

  .rgb_data_i(s_axis_tdata),
  .y_data_o(y_data_in_w),
  .cb_data_o(cb_data_in_w),
  .cr_data_o(cr_data_in_w)
);

contrast_enhancer contrast_enhancer(
  .clk(clk),
  .rst_n(rst_n),

  .valid_i(valid_rgb_to_ycbcr),
  .valid_o(valid_contrast_enhancer),

  .y_data_i(y_data_in_w),
  .cb_data_i(cb_data_in_w),
  .cr_data_i(cr_data_in_w),


  .y_data_o(y_data_out_w),
  .cb_data_o(cb_data_out_w),
  .cr_data_o(cr_data_out_w)
);

ycbcr_to_rgb ycbcr_to_rgb(
  .clk(clk),
  .rst_n(rst_n),

  .valid_i(valid_contrast_enhancer),
  .valid_o(valid_ycbcr_to_rgb),
  
  .y_data_i(y_data_out_w),
  .cb_data_i(cb_data_out_w),
  .cr_data_i(cr_data_out_w),
  .rgb_data_o(result)
);

fifo_generator_0 output_buffer (
  .wr_rst_busy(),        // output wire wr_rst_busy
  .rd_rst_busy(),        // output wire rd_rst_busy
  
  .s_aclk(clk),                  // input wire s_aclk
  .s_aresetn(rst_n),            // input wire s_aresetn
  
  .s_axis_tvalid(valid_ycbcr_to_rgb),    // input wire s_axis_tvalid
  .s_axis_tready(s_axis_tready),    // output wire s_axis_tready
  .s_axis_tdata(result),      // input wire [7 : 0] s_axis_tdata
  
  .m_axis_tvalid(m_axis_tvalid),    // output wire m_axis_tvalid
  .m_axis_tready(m_axis_tready),    // input wire m_axis_tready
  .m_axis_tdata(m_axis_tdata),      // output wire [7 : 0] m_axis_tdata
  
  .axis_prog_full()  // output wire axis_prog_full
);

endmodule
