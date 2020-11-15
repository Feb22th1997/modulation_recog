`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/30 15:48:13
// Design Name: 
// Module Name: top_testbench
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


module top_testbench();

reg  			clk            ;
reg  			rst_n          ;
wire [15:0]		din_i          ;
wire [15:0] 	din_q          ;
reg  			din_valid      ;
wire			din_ready      ;
reg	[7:0]		din_cnt			;
reg  			ce;
reg [10:0]		addra;
wire classify_result_vld;
wire [7:0] classify_result;
//reg [15:0]	testIN;
reg vld ;
initial begin
clk           = 0 ;
rst_n         = 0 ;
din_valid     = 0 ;
din_cnt		  = 0 ;
ce 			= 1 ;
addra 		= 0 ; 
vld =1;
//#680000 vld = 1;  //前两层测试
//#5480000 vld = 1;
//#5480000 vld = 1;
//#5480000 vld = 1;
//#5480000 vld = 1;
//#5480000 vld = 1;
//#5480000 vld = 1;
//#5480000 vld = 1;
//#5480000 vld = 1;
//#5480000 vld = 1;
end
reg din_valid_tmp = 0;
always@(posedge clk)
begin
	if(classify_result_vld)
	begin
		vld <= 1;
	end
	rst_n		 <= 1;
	{din_valid,din_valid_tmp} <= {din_valid_tmp,vld};
	if(vld)
	begin

			if(din_cnt ==  8'd127)
			begin
					//addra <= 0;
					addra <= addra + 1;
					din_cnt<= 0;
					//ce <= 0;
					vld <= 0;
			end
			else
			begin
			
				addra <= addra + 1;
				din_cnt <= din_cnt + 1;
			end
			
		//end
	end
	
end

always #5 clk = ~clk;	

TOP  uut(
.clk           (clk) ,
.rst_n         (rst_n) ,
.din_i         (din_i) ,
.din_q         (din_q) ,
.din_valid     (din_valid) ,
.classify_result_vld    (classify_result_vld   	)     ,
.classify_result     	(classify_result  		)
);

CONV1_input0 din0 (
  .clka(clk),    // input wire clka
  .ena(ce),      // input wire ena
  .addra(addra),  // input wire [10 : 0] addra
  .douta(din_i)  // output wire [15 : 0] douta
);
CONV1_input1 din1 (
  .clka(clk),    // input wire clka
  .ena(ce),      // input wire ena
  .addra(addra),  // input wire [10 : 0] addra
  .douta(din_q)  // output wire [15 : 0] douta
);


endmodule
