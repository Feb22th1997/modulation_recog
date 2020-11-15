`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/05 14:54:08
// Design Name: 
// Module Name: top 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 					all neural network top  
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TOP(
input  					clk,
input  					rst_n,
input 	[15:0]			din_i,       //  2*128*1   (sign_bitsnum,int_bitsnum, decimal_bitsnum)=(1,0,15)
input 	[15:0] 			din_q,
input  					din_valid,
(*mark_debug="true"*)
output	reg		  		classify_result_vld,
(*mark_debug="true"*)
output 	reg [7:0]		classify_result
    );
	
(*mark_debug="true"*) 
wire			  	dense_valid;
(*mark_debug="true"*) 
wire [15:0]			dense_dout ;
(*mark_debug="true"*) 
reg [15:0] 			dense_dout_max = 0;
reg [3:0] 			cnt_dense = 0;
//reg [7:0]  			classify_result = 0;
//reg 				classify_result_vld =0;

//**************************
//  for  test 
(*mark_debug="true"*) 
reg [9:0] cnt_output = 0;
always@(posedge clk)
begin
	if(~rst_n)
	begin
		cnt_output <= 0;
	end
	else
	begin
		if(classify_result_vld)
		begin
			cnt_output <= cnt_output + 1;
		end
		
	end
end

//**************************


always@(posedge clk)
begin
	if(~rst_n)
	begin
		classify_result 	<= 0;
		dense_dout_max 		<= 0;
		cnt_dense 			<= 0;
		classify_result_vld	<= 0;
	end
	else
	begin
		if(dense_valid)
		begin
			cnt_dense <= cnt_dense + 1;
			if(~dense_dout[15])
			begin
				if(dense_dout >= dense_dout_max)
				begin
					dense_dout_max <= dense_dout ;
					classify_result <= cnt_dense + 1;
				end
			end

		end
		else
		begin
			if(cnt_dense ==4'd11) // 11个输出大小比较完毕
			begin
				classify_result_vld<=1;
			end
			
			if(classify_result_vld)
			begin
				classify_result_vld <= 0;
				classify_result <= 0;
				dense_dout_max <= 0;
				cnt_dense <= 0;
			end
		end
	end
end	
(*mark_debug="true"*) 	
wire					conv1_dout_valid;
(*mark_debug="true"*) 		
wire	[16*8-1:0]		conv1_dout_I;
(*mark_debug="true"*) 
wire	[16*8-1:0]		conv1_dout_Q;
(*mark_debug="true"*) 
wire 	[15:0]			conv2_dout;
(*mark_debug="true"*) 
wire 					conv2_dout_valid;
(*mark_debug="true"*) 
wire 					lstm_dout_vld;
(*mark_debug="true"*) 
wire 	[15:0]			lstm_dout;

CONV1 conv1(
.clk			    (clk      			),
.rst_n				(rst_n	  			),
.din_i				(din_i	  			),
.din_q				(din_q	  			),
.din_valid       	(din_valid			),		//在128个数据期间一直拉高
.map_valid			(conv1_dout_valid		),         // output
.output_I           (conv1_dout_I			),              //output	[16*8-1:0]		output_I,
.output_Q           (conv1_dout_Q			)               //output	[16*8-1:0]		output_Q
 );

CONV2 conv2(	
.clk			 	(clk				),
.rst_n           	(rst_n				),
.conv2_in_i      	(conv1_dout_I			),        
.conv2_in_q      	(conv1_dout_Q			),        
.conv2_in_valid		(conv1_dout_valid		),
.output_conv2		(conv2_dout		),  		//[15:0]	
.output_conv2_valid	(conv2_dout_valid)

);  
LSTM lstm (
.clk             	(clk                ),
.rst_n           	(rst_n              ),
.din_vld         	(conv2_dout_valid ),
.din             	(conv2_dout       ),
.lstm_dout_vld   	(lstm_dout_vld      ),
.lstm_dout       	(lstm_dout          )
);

denseLayer dense(     
.clk         		(clk        		),
.rst_n       		(rst_n      		),
.dense_din    		(lstm_dout    		),	//输入：[1,3,12]--(符号位，整数位，小数位)
.dense_din_vld  	(lstm_dout_vld  	), 	//128个输入的开始标志
.dout				(dense_dout			),		//输出：[1,3,12]  
.dout_valid 		(dense_valid 		)			 //11个输出的开始标志

);


endmodule
