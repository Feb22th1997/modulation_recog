`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 10:06:15
// Design Name: 
// Module Name: conv2_testbench
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


module conv2_testbench(
    );
reg  					clk             ;
reg  					rst_n           ;
//reg [16*8-1 : 0]  		conv2_in_i      ;
//reg [16*8-1 : 0]  		conv2_in_q      ;
reg						conv2_in_valid = 0  ;
reg [16:0]				din_cnt         ;
wire  [255:0] 			dout ;
reg  [11 : 0] 			addra=0;
reg 					vld_reg =0;
reg 					conv2_in_valid_tmp =0;
initial begin
clk  					= 0;
rst_n					= 1;
//conv2_in_i              = 128'b0;
//conv2_in_q              = 128'b0;
conv2_in_valid 		    = 0;
din_cnt 				= 0;

end
/*
always@(posedge clk)
begin
	//conv2_in_i <= 128'h0001_0001_0001_0001_0001_0001_0001_0001; //0100
	//conv2_in_q <= 128'h0001_0001_0001_0001_0001_0001_0001_0001;
	//conv2_in_i <= 128'h000_4000_4000_4000_4000_4000_4000_4000; //1
	//conv2_in_q <= 128'h4000_4000_4000_4000_4000_4000_4000_4000; //1
	conv2_in_i <= 128'h2000_2000_2000_2000_2000_2000_2000_2000; //0.5
	conv2_in_q <= 128'h2000_2000_2000_2000_2000_2000_2000_2000; 
	if(din_cnt != 8)
	begin
		rst_n		 <= 1;
		conv2_in_valid    <= 1;
		din_cnt <= din_cnt + 1;
	end
	else
	begin
		rst_n		 <= 1;	
		//conv2_in_valid    <= 0;	
	end
end
*/
always #5 clk = ~clk;	
always@(posedge clk)begin
	vld_reg <= 1;
	if(vld_reg)
	begin
	if( addra==2070)begin
		addra <= 0;
		vld_reg<=0;
	end
	else begin
		addra <= addra + 1;
	end
	
	end
	conv2_in_valid_tmp <= vld_reg;
	conv2_in_valid <=conv2_in_valid_tmp;
	
end
CONV2  uut(
.clk	 		  (clk			)    ,
.rst_n	 		  (rst_n		)    ,
.conv2_in_i  	  (dout[255:128])       ,
.conv2_in_q	  	  (dout[127:0])       ,
.conv2_in_valid   (conv2_in_valid)    
);

SPROM_256X2080_CNN2_INPUT cnn2_input (
  .clka(clk),    // input wire clka
  .addra(addra),  // input wire [11 : 0] addra
  .douta(dout)  // output wire [255 : 0] douta
);
endmodule
