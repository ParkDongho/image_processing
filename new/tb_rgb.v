`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2021 02:50:57 AM
// Design Name: 
// Module Name: tb_rgb
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

`define imageSize  620*413*3
`define headerSize 138
module tb_rgb(

    );

reg clk;
reg rst_n;
reg [7:0] imgData;
reg [7:0] imgDataR;
reg [7:0] imgDataG;
reg [7:0] imgDataB;
reg [7:0] imgDataRGBY;
integer file_in, file_out;
integer i, j;
reg imgDataValid;
integer sentSize;
wire intr;
wire [7:0] outData;
reg [7:0] outDataY;
reg [7:0] outDataCr;
reg [7:0] outDataCb;

reg [7:0] r, g, b;

wire outDataValid;
integer receivedData = 0;

initial begin
  clk = 1'b0;
  forever begin
    #5 clk = ~clk;
  end
end
	
initial begin 
  rst_n = 0;
  sentSize = 0;
  imgDataValid = 0;
  j = 0;

  #100;
  rst_n = 1;

  #100;
    
  file_in = $fopen("7.bmp", "rb"); //open input file
  file_out = $fopen("result_7.bmp", "wb"); //open output file

  //copy image header
  for (i=0; i<`headerSize; i=i+1) begin
    $fscanf(file_in, "%c", imgData); //reading header
    $fwrite(file_out, "%c", imgData); //copy header
  end

	//send image data
	//first sending
  while(sentSize < `imageSize) begin
    @(posedge clk);
    $fscanf(file_in, "%c", imgDataR); //read and send
    $fscanf(file_in, "%c", imgDataG); //read and send
    $fscanf(file_in, "%c", imgDataB); //read and send
    imgData = 0.299*imgDataR + 0.587*imgDataG + 0.114*imgDataB;
    imgDataRGBY = imgData;
    imgDataValid = 1'b1;
    
    @(posedge clk)
    imgData = imgDataR*0.713 - imgDataRGBY*0.713 + 128;
    
    @(posedge clk)
    imgData = imgDataB*0.564 - imgDataRGBY*0.564 + 128;
    
    sentSize = sentSize + 3;
  end
  @(posedge clk);
  imgDataValid = 1'b0;
	

  //file closing
  @(posedge clk);
  imgDataValid = 1'b0;
  $fclose(file_in);
end


//axi stream received
always begin
  while(receivedData < `imageSize) begin
    
    @(posedge clk)
    outDataY = outData;
  
    @(posedge clk)
    outDataCr = outData;
  
    @(posedge clk)
    
    outDataCb = outData;
    
    if(outDataValid) begin
    r = outDataY + (1.403*(outDataCr-128.0));
    g = outDataY - 0.714*(outDataCr-128.0)-0.344*(outDataCb-128.0);
    b = outDataY + 1.773*(outDataCb-128.0);
    
    $fwrite(file_out, "%c", r); //write result
    $fwrite(file_out, "%c", g); //write result
    $fwrite(file_out, "%c", b); //write result
    receivedData = receivedData +3;
    end
  end
  
  $fclose(file_out);
  $stop;

end


dut dut(
  .clk(clk),
  .rst_n(rst_n),
  
  .s_axis_tvalid(imgDataValid), 
  .s_axis_tready(intr),
  .s_axis_tdata(imgData),

  .m_axis_tvalid(outDataValid),
  .m_axis_tready(1'b1),
  .m_axis_tdata(outData)
);

endmodule

