module rgb_to_ycbcr_stage_2(

  input  clk,
  input  rst_n,

  input  valid_i,
  output valid_o,
  
  input   [1:0] status_i,
  output  [1:0] status_o,

  input signed [16:0] y_data_i,
  input signed [16:0] cb_data_i,
  input signed [16:0] cr_data_i,

  output signed [16:0] y_data_o,
  output signed [16:0] cb_data_o,
  output signed [16:0] cr_data_o
);

reg signed [16:0] y_data_r;
reg signed [16:0] cb_data_r;
reg signed [16:0] cr_data_r;

reg valid_r;
reg [1:0] status_r;



always @(posedge clk) begin
  if(!rst_n) begin
    y_data_r  <= 0;
    cb_data_r <= 0;
    cr_data_r <= 0;
    
    valid_r <= 0;
    status_r <= 0;
    
  end
  else begin
    valid_r <= valid_i;
    status_r <= status_i;
    
    if(valid_i) begin
      y_data_r  <= y_data_i  + (status_r==0 ? 0 : y_data_r);
      cb_data_r <= cb_data_i + (status_r==0 ? 32768 : cb_data_r);
      cr_data_r <= cr_data_i + (status_r==0 ? 32768 : cr_data_r);
    end
  end
end

assign y_data_o = y_data_r;
assign cb_data_o = cb_data_r;
assign cr_data_o = cr_data_r;

assign valid_o = valid_r;
assign status_o = status_r;

endmodule
