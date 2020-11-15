`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/19 16:59:35
// Design Name: 
// Module Name: lstm_tb
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


module lstm_tb();
reg 				clk         ;
reg 				rst_n       ;
reg 				din_vld     ;
wire   [15:0]	 	din         ;
wire   				dout_vld    ;
wire  [15:0]		dout	    ;
reg  flag = 0;
reg  flag_tmp = 0;
reg [12 : 0] addra = 0;


initial begin
clk = 0;
rst_n = 0;
din_vld =0;
flag = 0;
#15 flag = 1;
#5480000 flag =1;
end


always@(posedge clk)
begin
	rst_n		 <= 1;
	//flag <= 1;
	{din_vld,flag_tmp} <= {flag_tmp,flag};
	if(flag)
	begin
		if(addra == 4244-1)
		begin
			addra <= 0;
			flag <= 0;
		end
		else
		begin
			addra <= addra + 1;
		end
	end
	else;
end



	
LSTM uut(
.clk        (clk      ),
.rst_n      (rst_n    ),
.din_vld    (din_vld  ),
.din        (din      ),
.lstm_dout_vld   (dout_vld ),
.lstm_dout       (dout     )

);
always #5 clk = ~clk;
ROM_LSTM your_instance_name (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra(addra),  // input wire [12 : 0] addra
  .douta(din)  // output wire [15 : 0] douta
);
endmodule
