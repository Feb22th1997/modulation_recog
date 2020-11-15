`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/13 17:37:46
// Design Name: 
// Module Name: hard_sigmoid_tb
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


module hard_sigmoid_tb(
    );
	
reg clk = 0;
reg rst_n =1;
reg in_vld =0;
reg [15:0]in_data =0;
wire out_vld ;
wire[15:0] out_data;

initial begin
clk  					= 0;
rst_n					= 1;
 in_vld = 0;
 in_data = 0;
/*

in_data = 16'b0010_0000_0000_0000; //1       (1,2,13)
#20 
in_data = 16'b0001_0000_0000_0000; //0.5
#20
in_data = 16'b0110_0000_0000_0000; // 3
#20
in_data = 16'b1111000000000000; // -0.5
#20
in_data = 16'b1010110011001101; // -2.6
*/

/*
in_data = 16'b0001_0000_0000_0000; //1       (1,3,12)
#20 
in_data = 16'b0000_1000_0000_0000; //0.5
#20
in_data = 16'b0101_0000_0000_0000; // 5
#20
in_data = 16'b0001_1000_0000_0000; //1
#20
in_data = 16'b1111100000000000; // -0.5
#20
in_data = 16'b1010011100110100; // -5.55
*/

//in_data = 16'b0000_1000_0000_0000; //1       (1,4,11)
/*
#20 
in_data = 16'b0000_0100_0000_0000; //0.5
#20
in_data = 16'b0001_1000_0000_0000; // 3
#20
in_data = 16'b1111110000000000; // -0.5
#20
in_data = 16'b1101010000000000; // -5.55
*/
end
reg [3:0] cnt = 0;
always@(posedge clk)
begin
	
	cnt <= cnt + 1;
	if(cnt==1)
	begin
		in_vld <= 1;
		in_data <= 16'b0000_1000_0000_0000;
	end
	else if (cnt == 2)
		in_data <= 16'b0000_0100_0000_0000; //0.5
	else if(cnt == 3)
		in_data <= 16'b0001_1000_0000_0000; // 3
	else
		in_data <= 16'b1101010000000000; // -5.55
		

end
hard_sigmoid  #(.int_bitsnum(4))uut(
.clk			(clk)	    ,
.rst_n			(rst_n)     ,
.in_vld			(in_vld	)	, //input valid 
.in_data		(in_data)	, //input data
.out_vld		(out_vld)	, //output valid
.out_data		(out_data)	  //output data 
);
always #5 clk = ~clk;	
endmodule
