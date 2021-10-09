module ycbcr_to_rgb(
  input  clk,
  input  rst_n,

  input  valid_i,
  output valid_o,

  input  [7:0] y_data_i,
  input  [7:0] cb_data_i,
  input  [7:0] cr_data_i,
  output [7:0] rgb_data_o
);

wire valid_1_w, valid_2_w;
wire [1:0] state_1_w, state_2_w;
wire [7:0] accum_1_w;
wire [16:0] accum_2_w;

ycbcr_to_rgb_stage_y ycbcr_to_rgb_stage_y(
  .clk(clk),
  .rst_n(rst_n),

  .valid_i(valid_i),
  .valid_o(valid_1_w),
  
  .state_o(state_1_w),

  .y_data_i(y_data_i),
  .accum_data_o(accum_1_w)
);

ycbcr_to_rgb_stage_cb ycbcr_to_rgb_stage_cb(

  .clk(clk),
  .rst_n(rst_n),

  .valid_i(valid_1_w),
  .valid_o(valid_2_w),
  
  .state_i(state_1_w),
  .state_o(state_2_w),

  .cb_data_i(cb_data_i),
  .accum_data_i(accum_1_w),
  .accum_data_o(accum_2_w)
);


ycbcr_to_rgb_statge_cr ycbcr_to_rgb_statge_cr(
  .clk(clk),
  .rst_n(rst_n),

  .valid_i(valid_2_w),
  .valid_o(valid_o),
  
  .state_i(state_2_w),
  .state_o(),

  .cr_data_i(cr_data_i),
  .accum_data_i(accum_2_w),
  .accum_data_o(rgb_data_o)
);

endmodule
