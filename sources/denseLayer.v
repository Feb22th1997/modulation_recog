`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/12 11:05:35
// Design Name: 
// Module Name: denseLayer
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

//  input	(1,3,12)
// weights  (1,3,12)
//bias   (1,6,9)
//output (1,6,9)
module denseLayer(
input clk,
input rst_n,
input [15:0]dense_din,    //输入：[1,3,12]--(符号位，整数位，小数位)
input dense_din_vld,    //128个输入的开始标志
(*mark_debug="true"*)
output reg[15:0]dout, //输出：[1,3,12]
(*mark_debug="true"*)
output reg dout_valid  //11个输出的开始标志
    );
	
reg 			rd_en =0;
wire 			full ;
wire 			empty;
wire [15 : 0] 	din ;
reg 			din_valid = 0;
FIFO_16X1024 input_buffer (
  .clk(clk),      // input wire clk
  .srst(~rst_n),    // input wire srst
  .din(dense_din),      // input wire [15 : 0] din
  .wr_en(dense_din_vld),  // input wire wr_en
  .rd_en(rd_en),  // input wire rd_en
  .dout(din),    // output wire [15 : 0] dout
  .full(full),    // output wire full
  .empty(empty)  // output wire empty
);

reg [8:0] cnt_dense_din = 0;
reg [8:0] cnt_rd_en = 0;
always@(posedge clk)
begin
	if(~rst_n)
	begin
		rd_en <=0;
		cnt_dense_din <= 0;
		din_valid <=0;
		cnt_rd_en <=0;
	end
	else
	begin
		din_valid <= rd_en ;
		if(dense_din_vld)
		begin
			if(cnt_dense_din == 127)
			begin
				cnt_dense_din <=0;
				rd_en <= 1;
			end
			else
			begin
				cnt_dense_din <= cnt_dense_din + 1;
			end
			
		end
		
		if(rd_en)
		begin
			if(cnt_rd_en==127)
			begin
				cnt_rd_en <= 0;
				rd_en <= 0;
			end
			else
			begin
				cnt_rd_en<= cnt_rd_en + 1;
			end
		end
		else
		begin
			cnt_rd_en <= 0;
		end
	end
end


    reg sel =0;
    wire wea;
    reg [6:0]addr_xw =0;
	reg [6:0]addr_xr =0;
    reg [3:0]addr_biases = 0;
    wire [15:0]x,b;
    reg [10:0]addr_weights = 0 ;
    wire [15:0]wx;
    //reg [15:0]wx0,wx1,wx2,wx3,wx4,wx5,wx6,wx7,wx8,wx9,wx10;
    
    //reg [3:0]state,state_delay1,state_delay2;
    reg [3:0] state        =0;
	reg [3:0] state_delay1 =0;
	reg [3:0] state_delay2 =0;
	
    reg [6:0]counter = 0;
	
	reg [15:0] sum0  = 0;             reg [15:0] wx0  = 0;
	reg [15:0] sum1  = 0;             reg [15:0] wx1  = 0;
	reg [15:0] sum2  = 0;             reg [15:0] wx2  = 0;
	reg [15:0] sum3  = 0;             reg [15:0] wx3  = 0;
	reg [15:0] sum4  = 0;             reg [15:0] wx4  = 0;
	reg [15:0] sum5  = 0;             reg [15:0] wx5  = 0;
	reg [15:0] sum6  = 0;             reg [15:0] wx6  = 0;
	reg [15:0] sum7  = 0;             reg [15:0] wx7  = 0;
	reg [15:0] sum8  = 0;             reg [15:0] wx8  = 0;
	reg [15:0] sum9  = 0;             reg [15:0] wx9  = 0;
	reg [15:0] sum10 = 0;             reg [15:0] wx10 = 0;
    
    blk_mem_dense_in dense_in_ram (
      .clka(clk),    // input wire clka
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addr_xw),  // input wire [6 : 0] addra
      .dina(din),    // input wire [15 : 0] dina
      .clkb(clk),    // input wire clkb
      .addrb(addr_xr),  // input wire [6 : 0] addrb
      .doutb(x)  // output wire [15 : 0] doutb
    );
    
    blk_mem_dense_biases dense_biases_rom (
      .clka(clk),    // input wire clka
      .addra(addr_biases),  // input wire [3 : 0] addra
      .douta(b)  // output wire [15 : 0] douta
    );
    

	always@ (posedge clk)
	begin
	
	end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) sel <= 1'b0;
        else begin
            if(din_valid==1'b1) sel <= 1'b1;
            if(counter==7'd127) sel <= 1'b0;
        end
    end
    //写数据
    assign wea = din_valid;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            addr_xw <= 7'd0;
        end
        else begin
            if(din_valid==1'b1) begin
                addr_xw <= addr_xw + 1'b1;
            end
            else begin
                addr_xw <= 7'd0;
            end
        end
    end
    
    //乘
    dense_mult dense_mult_wx(
        .clk(clk),
        .rst_n(rst_n),
        .addr_weights(addr_weights),
        .x(x),
        .wx(wx)
    );
    //读取w,x
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            addr_weights <= 11'd0;
        end
        else begin
            if(sel==1'b1) addr_weights <= addr_weights + 1'b1;
            else addr_weights <= 11'd0;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            addr_xr <= 7'd0;
        end
        else begin
            if(state==4'd10) addr_xr <= addr_xr + 7'd1;
            if(counter==7'd127) addr_xr <= 7'd0;
        end
    end
    
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= 4'd0;
        end
        else begin
            if(sel==1'b1) begin
                if(state==4'd11) state <= 4'd1; else state <= state + 1'b1;
                case(state)
                4'd1: wx10 <= wx;
                4'd2: wx0 <= wx;
                4'd3: wx1 <= wx;
                4'd4: wx2 <= wx;
                4'd5: wx3 <= wx;
                4'd6: wx4 <= wx;
                4'd7: wx5 <= wx;
                4'd8: wx6 <= wx;
                4'd9: wx7 <= wx;
                4'd10: wx8 <= wx;
                4'd11: wx9 <= wx;
                default: ;
                endcase
            end
            else begin
                state <= 4'd0;
            end
        end
    end
    
    //累加
    always @(posedge clk) begin
        state_delay1 <= state;
        state_delay2 <= state_delay1;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            counter <= 7'd0;
        end
        else begin
            if(state_delay2==4'd11) counter <= counter + 1'b1;
            if(counter==7'd127) counter <= 7'd0;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum0<=16'd0;sum1<=16'd0;sum2<=16'd0;sum3<=16'd0;sum4<=16'd0;
            sum5<=16'd0;sum6<=16'd0;sum7<=16'd0;sum8<=16'd0;sum9<=16'd0;sum10<=16'd0;
        end
        else begin
            if(state_delay2==4'd11) begin
                sum0<=sum0+wx0;sum1<=sum1+wx1;sum2<=sum2+wx2;sum3<=sum3+wx3;sum4<=sum4+wx4;
                sum5<=sum5+wx5;sum6<=sum6+wx6;sum7<=sum7+wx7;sum8<=sum8+wx8;sum9<=sum9+wx9;sum10<=sum10+wx10;
            end
            if(counter==7'd127) begin
                sum0<=16'd0;sum1<=16'd0;sum2<=16'd0;sum3<=16'd0;sum4<=16'd0;
                sum5<=16'd0;sum6<=16'd0;sum7<=16'd0;sum8<=16'd0;sum9<=16'd0;sum10<=16'd0;
            end
        end
    end
    
    //串行输出
    reg sel_dout =0;
    reg [3:0]dout_cnt =0;
    //reg [15:0]dout0,dout1,dout2,dout3,dout4,dout5,dout6,dout7,dout8,dout9,dout10;
	
	reg [15:0] dout0  = 0;
	reg [15:0] dout1  = 0;
	reg [15:0] dout2  = 0;
	reg [15:0] dout3  = 0;
	reg [15:0] dout4  = 0;
	reg [15:0] dout5  = 0;
	reg [15:0] dout6  = 0;
	reg [15:0] dout7  = 0;
	reg [15:0] dout8  = 0;
	reg [15:0] dout9  = 0;
	reg [15:0] dout10 = 0;
	
	
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            dout0<=16'd0;dout1<=16'd0;dout2<=16'd0;dout3<=16'd0;dout4<=16'd0;
            dout5<=16'd0;dout6<=16'd0;dout7<=16'd0;dout8<=16'd0;dout9<=16'd0;dout10<=16'd0;
        end
        else begin
            if(counter==7'd127) begin
                dout0<=sum0;dout1<=sum1;dout2<=sum2;dout3<=sum3;dout4<=sum4;
                dout5<=sum5;dout6<=sum6;dout7<=sum7;dout8<=sum8;dout9<=sum9;dout10<=sum10;
            end
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sel_dout <= 1'b0;
        end
        else begin
            if(counter==7'd127) sel_dout <= 1'b1;
            if(dout_cnt==4'd12) sel_dout <= 1'b0;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            dout_cnt <= 4'd0;
        end
        else begin
            if(sel_dout==1'b1) begin
                dout_cnt <= dout_cnt + 1'b1;
            end
            else begin
                dout_cnt <= 4'd0;
            end
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) addr_biases <= 4'd0;
        else begin
            if(dout_cnt<=4'd11) addr_biases <= dout_cnt;
            else addr_biases <= 4'd0;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            dout <= 16'd0;
            dout_valid <= 1'b0;
        end
        else begin
            case(dout_cnt)
            4'd2: begin
                dout_valid <= 1'b1;
                dout <= dout0 + b;
            end
            4'd3: dout <= dout1 + b;
            4'd4: dout <= dout2 + b;
            4'd5: dout <= dout3 + b;
            4'd6: dout <= dout4 + b;
            4'd7: dout <= dout5 + b;
            4'd8: dout <= dout6 + b;
            4'd9: dout <= dout7 + b;
            4'd10: dout <= dout8 + b;
            4'd11: dout <= dout9 + b;
            4'd12: dout <= dout10 + b;
            4'd13: dout_valid <= 1'b0;
            default: dout <= 16'd0;
            endcase
        end
    end
    
endmodule
