`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dongho Park	
// 
// Create Date: 10/08/2021 04:27:04 PM
// Design Name: 
// Module Name: tb
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
`define imageSize  945*630*3
`define headerSize 768

module tb(

);

reg clk;
reg rst_n;
reg [7:0] imgData;
integer file_in, file_out;
integer i;
reg imgDataValid;
integer sentSize;
wire intr;
wire [7:0] outData;
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

  #100;
  rst_n = 1;

  #100;
    
  file_in = $fopen("11.bmp", "rb"); //open input file
  file_out = $fopen("result_11.bmp", "wb"); //open output file

  //copy image header
  for (i=0; i<`headerSize; i=i+1) begin
    $fscanf(file_in, "%c", imgData); //reading header
    $fwrite(file_out, "%c", imgData); //copy header
  end

	//send image data
	//first sending
  while(sentSize < `imageSize) begin
    @(posedge clk);
    $fscanf(file_in, "%c", imgData); //read and send
    imgDataValid <= 1'b1;
  end
  @(posedge clk);
	imgDataValid <= 1'b0;
	sentSize = sentSize + 1;

	//file closing
	@(posedge clk);
	imgDataValid <= 1'b0;
	$fclose(file_in);
end

//axi stream received
always @(posedge clk) begin
  if(outDataValid) begin
    $fwrite(file_out, "%c", outData); //write result
    receivedData = receivedData + 1;
  end
  if(receivedData == `imageSize) begin
    $fclose(file_out);
    $stop;
  end
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
