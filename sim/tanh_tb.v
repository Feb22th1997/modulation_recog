`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 15:28:08
// Design Name: 
// Module Name: tanh_tb
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


module tanh_tb();
reg clk;
reg [17:0] tanh_in;
wire[17:0] tanh_out;
reg [7:0] cnt = 0;
reg [15:0] test_num =16'hffff;
initial begin
tanh_in = 0;
clk = 0;
end

always@(posedge clk)
begin
	cnt <= cnt + 1;
	if(cnt == 3)
	begin
		tanh_in <=18'b0000_0010_0000_0000_00;//0.5 (1,5,12) 
	end
	else if(cnt ==4)
	begin
		tanh_in <=18'b0000_0100_0000_0000_00;//1 (1,5,12) 
	end
	else if(cnt==5)
	begin
		tanh_in <= 18'b0111_1111_1111_1111_11;
	end
	else if(cnt == 6)
	begin
		tanh_in <= 18'b1011_1100_1111_1111_11;
	end
	else if(cnt==7)
	begin
		tanh_in <= 18'b1110_1111_1111_1111_11;
	end
	
	
	
end

tanh uut(
.clk(clk),
.tanh_in(tanh_in),
.tanh_out(tanh_out)
);

always #5 clk = ~clk;
endmodule
