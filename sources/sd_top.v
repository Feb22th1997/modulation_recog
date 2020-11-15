`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 19:25:58
// Design Name: 
// Module Name: sd_top
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


module sd_top(
    input         sys_clk_p,
    input         sys_clk_n,
    output [3:0]  a7_led, // a7_led[2:0]3'd6 = DONE,  a7_led[3]// 0=file not found, 1=file found
    input         RESETN,
    output        SD_SCK,
    inout         SD_CMD,
    input [3:0]   SD_DAT,
    output        UART_TX
    );
    
wire sys_clk,clk;
wire tx_data_ready;

wire classify_result_vld;
wire [7:0] classify_result;
//assign UART_TX = (^classify_result) & classify_result_vld;

IBUFDS sys_clk_ibufgds   
(
    .O (sys_clk       ),
    .I (sys_clk_p     ),
    .IB(sys_clk_n     )
);

sys_pll sys_pll_m0
(
    .clk_in1 (sys_clk         ),
    .clk_out1(clk             ),//100M
    .reset   (1'b0            ),
    .locked  (                )
);

(*mark_debug="true"*)   
wire [31:0]sd_data;
(*mark_debug="true"*)
wire sd_data_valid;
    
file_reader #(.FILE_NAME   ("signal.txt"),  //文件�? 
              .CLK_DIV     (2            ),  //when clk = 50~100MHz , set CLK_DIV to 2;
                                             //when clk = 100~200MHz, set CLK_DIV to 3;
              .UART_CLK_DIV(868          )   //100MHz/868=115200
              )file_reader_inst0(
    .clk            (clk            ),
    .a7_led         (a7_led         ),
    .sd_data        (sd_data        ),
    .sd_data_valid  (sd_data_valid  ),
    .RESETN         (RESETN         ),
    .SD_SCK         (SD_SCK         ),
    .SD_CMD         (SD_CMD         ),
    .SD_DAT         (SD_DAT         )
);

(*mark_debug="true"*)  
reg 		rd_sd_buffer = 0;
(*mark_debug="true"*)  
wire [31:0] sd_data_buffer;
(*mark_debug="true"*)  
wire 		sd_buffer_full;
(*mark_debug="true"*)  
wire		sd_buffer_empty;
/*
FIFO_32X16384 SD_DATA_BUFFER (
  .clk(clk),      // input wire clk
  .srst(~RESETN),    // input wire srst
  .din(sd_data),      // input wire [31 : 0] din
  .wr_en(sd_data_valid),  // input wire wr_en
  .rd_en(rd_sd_buffer),  // input wire rd_en
  .dout(sd_data_buffer),    // output wire [31 : 0] dout
  .full(sd_buffer_full),    // output wire full
  .empty(sd_buffer_empty)  // output wire empty
);
*/
FIFO_32X32768 SD_DATA_BUFFER (
  .clk(clk),      // input wire clk
  .srst(~RESETN),    // input wire srst
  .din(sd_data),      // input wire [31 : 0] din
  .wr_en(sd_data_valid),  // input wire wr_en
  .rd_en(rd_sd_buffer),  // input wire rd_en
  .dout(sd_data_buffer),    // output wire [31 : 0] dout
  .full(sd_buffer_full),    // output wire full
  .empty(sd_buffer_empty)  // output wire empty
);


(*mark_debug="true"*)  
reg [7:0]		cnt128 = 0;
reg [7:0]   	cnt_sd = 0;
(*mark_debug="true"*)  
reg 			din_valid = 0;

(*mark_debug="true"*)  
reg 			flag       = 0;
(*mark_debug="true"*)  
reg 			flag_dly1  = 0;
always@(posedge clk ,negedge RESETN)
begin
	if(!RESETN)
	begin
		cnt128 			<= 0; 
		rd_sd_buffer 	<= 0;
		din_valid 		<= 0;
		cnt_sd 			<= 0;
		flag			<= 0;
		flag_dly1		<= 0;
	end
	else
	begin
	
		if(sd_data_valid)
		begin
			if(cnt128 ==8'd130)
			begin
				cnt128 <= 8'd130;
			end
			else
			begin
				cnt128 <= cnt128 + 1;
			end
			if(cnt128 ==8'd128)
			begin
				flag <= 1;  //第一殿128个数捿
			end
		end
		flag_dly1 <= flag;
		
		if({flag_dly1,flag} == 2'b01)  //jump 0-->1 
		begin
			rd_sd_buffer <= 1; 
		end
		else
		begin
			if(classify_result_vld)
			begin
				if(~sd_buffer_empty)
				begin
					rd_sd_buffer <= 1;
				end
			end
		end
		


		din_valid <= rd_sd_buffer;
		if(rd_sd_buffer)
		begin
			if(cnt_sd ==127)
			begin
				cnt_sd <= 0;
				rd_sd_buffer <=0;
			end
			else
			begin
				cnt_sd <= cnt_sd + 1;
			end
		end	
	end

end



 TOP top_instance(
.clk					(clk					)	  ,
.rst_n          		(RESETN          		)     ,
.din_i          		(sd_data_buffer[31:16]    		)     ,
.din_q          		(sd_data_buffer[15:0]     		)     ,
.din_valid      		(din_valid    		)     ,
.classify_result_vld    (classify_result_vld   	)     ,
.classify_result     	(classify_result  		)
);



uart_classify 
#(.CLK_FRE(75),     //clock frequency(Mhz)        修改
  .BAUD_RATE(115200) //serial baud rate
)uart_classify_inst(
    .clk                (clk           ),
    .rst_n              (RESETN        ),
    .classify_result    (classify_result  ),
    .classify_result_vld(classify_result_vld ),
    .uart_tx            (UART_TX       )
);
/*
my_uart_tx
#(
	.CLK_FRE  (60),     //clock frequency(Mhz)        修改
	.BAUD_RATE (115200) //serial baud rate
)
(
.clk           (clk            ),   //clock input                                input         clk            
.rst_n         (RESETN        ),   //asynchronous reset input, low active       input         rst_n          
.tx_data       (classify_result        ),  //data to send                                input[7:0]    tx_data        
.tx_data_valid (classify_result_vld  ),   //data to be sent is valid                   input         tx_data_valid  
.tx_data_ready (tx_data_ready  ),   //send ready                                 output reg    tx_data_ready  
.tx_pin        (UART_TX         )   //serial data output                        output        tx_pin         
);
*/
endmodule
