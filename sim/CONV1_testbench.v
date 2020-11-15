`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/21 10:26:24
// Design Name: 
// Module Name: cnn1_1_test
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


module CONV1_testbench(
);
reg  			clk            ;
reg  			rst_n          ;
wire [15:0]		din_i          ;
wire [15:0] 	din_q          ;
reg  			din_valid      ;
wire			din_ready      ;
reg	[7:0]		din_cnt			;
reg  			ce;
reg [6:0]		addra;
//reg [15:0]	testIN;
initial begin
clk           = 0 ;
rst_n         = 0 ;
//din_i         = 16'h4000;
//din_q         = 16'h4000;
din_valid     = 0 ;
din_cnt		  = 0 ;
ce 			= 1 ;
addra 		= 0 ; 

end

always@(posedge clk)
begin
	rst_n		 <= 1;


	if(din_cnt < 8'd130)
	begin
		if(din_cnt ==  8'd129)
		begin
				addra<= 0;
				din_cnt<= 0;
		end
		else
		begin
		
			addra <= addra + 1;
			din_cnt <= din_cnt + 1;
		end
		
	end
	else
	begin
		
	end
	
	if(din_cnt== 1)
	begin
		din_valid <= 1;
	end
	if(din_cnt == 129)
	begin
		
		//din_valid <= 0;
	end
	
end
always #5 clk = ~clk;	

CONV1  uut(
.clk           (clk) ,
.rst_n         (rst_n) ,
.din_i         (din_i) ,
.din_q         (din_q) ,
.din_valid     (din_valid) 
//.din_ready     (din_ready) 
//.map_out       (map_out) ,
//.map_ready     (map_ready)
);

CONV1_input0 din0 (
  .clka(clk),    // input wire clka
  .ena(ce),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(din_i)  // output wire [15 : 0] douta
);
CONV1_input1 din1 (
  .clka(clk),    // input wire clka
  .ena(ce),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(din_q)  // output wire [15 : 0] douta
);


endmodule
