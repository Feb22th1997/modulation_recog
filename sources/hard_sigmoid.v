`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/13 10:11:15
// Design Name: 
// Module Name: hard_sigmoid
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//					python code   x > 2.5 y = 1; x<-2.5  y = 0; 
//						def hard_sigmoid(x):
//  					  x = 0.2 * x + 0.5
//  					  x[x < 0] = 0
//  					  x[x > 1] = 1
//  					  return x
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// pipeline = 5;
module hard_sigmoid #(parameter int_bitsnum = 4)(
input 			clk,
input 			rst_n,
input			in_vld,  			//input valid 
input  [15:0] 	in_data, 			//input data   
output 			out_vld,			//output valid
output [15:0] 	out_data			//output data 
    );
//parameter  int_bitsnum = 4; //  need to  >= 2 
//equal to input_data_format (sign_bitsnum,int_bitsnum, decimal_bitsnum)=(1,3,12)
reg 	[15:0]	float0p2 =  16'b0001100110011001; //   0.2  0.199981689453125  
												  //(sign_bitsnum,int_bitsnum, decimal_bitsnum)=(1,0,15)

wire 	[31 : 0] P;  // if int_bitsnum = 3 , data_format of P =(2,3,27)
reg   [31 : 0] float0p5 = 0;//  0.5
reg   [31 : 0] axplusb = 0;
reg	  [15 : 0] float1p0 = 0;
wire  [15 : 0] out_data_reg1;
reg		[15 : 0]out_data_reg = 0;
assign out_data_reg1 = {axplusb[31],axplusb[28-:int_bitsnum-1],axplusb[30-int_bitsnum-1-:16-int_bitsnum]} ;  // (1,2,13)
assign out_data = out_data_reg;
reg [3:0] vld_dly = 0;
reg 	out_vld_reg = 0;
assign out_vld = out_vld_reg;

always@(posedge clk)
begin
	if(!rst_n)
	begin
		axplusb <= 0;
		float0p5 <= 0;
		float1p0 <= 0;
	end
	else
	begin
		{out_vld_reg,vld_dly} <= {vld_dly,in_vld};
		float0p5[30-int_bitsnum-1] <= 1'b1;   //0.5
		float1p0[15-int_bitsnum+1] <= 1'b1; 
		/*if(in_vld)
		begin
			axplusb[31:0] <= float0p5[31:0] + P[31:0];
		end
		else
		begin
			axplusb <= 0;
		end
		*/
		axplusb[31:0] <= float0p5[31:0] + P[31:0];
		if(out_data_reg1[15])
		begin
			out_data_reg <= 0;
		end
		else if(out_data_reg1[14-:int_bitsnum-1] >=1)
		begin
			out_data_reg <= float1p0 ;
		end
		else
		begin
			out_data_reg <= out_data_reg1;
		end
	end
end	

//for test 
/*
reg [15:0] indata_test= 16'hffff;
reg [15:0] outdata_test = 16'hffff;

always@(posedge clk)
begin
	if(in_vld)
	begin
		indata_test <= in_data;
	end
	else
	begin
		indata_test <= 16'h0;
	end
	
	if(out_vld)
		outdata_test <= out_data;
	else
		outdata_test <= 16'h0;
		
end
*/
MULT_16X16 float0p2Xx (      //0.2*x
  .CLK(clk),  // input wire CLK
  .A(float0p2),      // input wire [15 : 0] A
  .B(in_data),      // input wire [15 : 0] B
  .CE(1'b1),    // input wire CE
  .P(P)      // output wire [31 : 0] P
);
	
	
endmodule
