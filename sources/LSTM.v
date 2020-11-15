`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/13 09:13:04
// Design Name: 
// Module Name: LSTM
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

//	weights max=2.1449 and min=-1.9764, so weights quantification  (1,2,13)
//											bias quantification    (1,5,12)

module LSTM(
input 			clk,
input			rst_n,
input 			din_vld,
input [15:0]	din, 
output 			lstm_dout_vld,
output[15:0]	lstm_dout
);
reg				kernel_en  = 1;
reg  [11 : 0] 	kernel_addr = 0;
wire [63 : 0] 	kernel_data; 		//(1,2,13)

reg [9:0] 		testcnt = 0;  // for test

reg [12 : 0] 	addr_wr = 0;
reg [12 : 0] 	addr_rd = 0;
reg [12 : 0] 	addr_rd_tmp = 0;
wire [15 : 0] 	lstm_din ; 

reg 			CE = 1;
reg [4:0] 		cnt32 = 0;
reg [5*4-1:0] 	cnt32_tmp = 0;
reg [4:0] 		accu_cnt32 = 0;
reg 	  		rd_in_flag = 0;
reg 	  		rd_kernel_flag = 0;

reg [31:0] 		sum32_i=0;
reg [31:0] 		sum32_f=0;
reg [31:0] 		sum32_c=0;
reg [31:0] 		sum32_o=0;

wire [31 : 0] 	prdt_i;
wire [31 : 0] 	prdt_f;
wire [31 : 0] 	prdt_c;
wire [31 : 0] 	prdt_o;




reg  	[6 : 0] 	bias_addr = 0;
wire 	[71 : 0] 	lstm_bias; //  bias  ifco  18bits (1,5,12)
reg 	[17:0]		x_i  = 0;  //(1,5,12)
reg 	[17:0]		x_f  = 0;
reg 	[17:0]		x_c  = 0;
reg 	[17:0]		x_o  = 0;

reg 				addbias_flag = 0;
reg 	[4:0] 		addbias_flag_tmp=0;	
reg 	[4:0] 		add_cnt32 = 0;
reg 	[7:0] 		cnt128 = 0;
reg  [7 : 0] 	cnt132 = 0;
wire [32*4-1:0]		prdt_r_i ;
wire [32*4-1:0]		prdt_r_f ;
wire [32*4-1:0]		prdt_r_c ;
wire [32*4-1:0]		prdt_r_o ;

reg 	[11:0] 		r_kernel_addr =0;
wire	[255:0] 	r_kernel_data; //data fomat: ifcoifcoifcoifco
reg 				h_flag =0;
reg    				h_wr_en =  0  ;
//reg		[6 : 0] 	h_wr_addr  = 0;
wire	[15 : 0]	h        ;
wire	[31:0]		h_tmp;// (2,3,27)
assign  h = h_tmp[30:15]; //(1,3,12)
assign  lstm_dout = h;
assign	lstm_dout_vld = (cnt132==131)?h_flag : 1'b0;

reg		[4 : 0]		h_rd_addr  = 0;
wire	[63 : 0]	h_rd_data  ;
reg 				rd_Rkernel_flag = 0;
reg 	[5*4-1:0]	cnt32_tmp1 = 0;
reg 	[4:0]		accu_cnt32_rk = 0;
reg		[32*4-1:0] 	sum32_r_i =0  ;
reg		[32*4-1:0] 	sum32_r_f =0  ;
reg		[32*4-1:0] 	sum32_r_c =0  ;
reg		[32*4-1:0] 	sum32_r_o =0  ;
reg 	[31:0]		sum_r_i_tmpa = 0;
reg 	[31:0]		sum_r_f_tmpa = 0;
reg 	[31:0]		sum_r_c_tmpa = 0;
reg 	[31:0]		sum_r_o_tmpa = 0;
reg 	[31:0]		sum_r_i_tmpb = 0;
reg 	[31:0]		sum_r_f_tmpb = 0;
reg 	[31:0]		sum_r_c_tmpb = 0;
reg 	[31:0]		sum_r_o_tmpb = 0;
reg 	[31:0]		sum_r_i = 0;
reg 	[31:0]		sum_r_f = 0;
reg 	[31:0]		sum_r_c = 0;
reg 	[31:0]		sum_r_o = 0;
reg 	[4:0]		cnt32_0  =0;
reg 	[4:0]		cnt32_0_tmp = 0;
		
reg 				result_flag =0;

reg    				c_wr_en =  0  ;
reg		[6 : 0] 	c_wr_addr  = 0;
reg 	[15 : 0]	c_wr_data = 0; // (1,5,10)
reg		[6 : 0]		c_rd_addr  = 0;
wire	[15 : 0]	c_rd_data  ;

reg  [4:0] 		cnt32_1 = 0; 
reg 			fifo_h_rd_en =0;
wire [63 :0] 	fifo_hout;
wire			fifo_h_full         ;
wire			fifo_h_empty        ;
reg  [4 : 0]	h_buffer_addr = 0;

reg [17:0]		sigmoid_input_i = 0; //(1,5,12)
reg [17:0]		sigmoid_input_f	= 0;
reg [17:0]		sigmoid_input_o	= 0;
reg [17:0]		tanh_input_c	= 0;

reg [16*8-1:0]  sgd_dout_o_tmp =0;
reg [15:0]		sgd_dout_o_dly9 =0;  //(1,3,12)



reg 			sigmoid_in_flag = 0;
wire			sgd_out_flag_i  ;
wire			sgd_out_flag_f  ;
wire			sgd_out_flag_o  ;
wire	[15:0]	sgd_dout_i  ; //(1,3,12)
wire	[15:0]	sgd_dout_f  ;
wire	[15:0]	sgd_dout_o  ;
wire  	[17:0] 	tanh_out_xc ;//(1,0,17) 
reg 	[2:0] 		c_flag_tmp = 0;

reg       		mult_flag =0;
reg 	[3:0] 	mult_flag_tmp =0;

wire	[31:0]		fXc_tm;		 // (2,10,20)
wire 	[31:0]		iXtanh_out_c;// (2,5,27)

reg 	[6:0]		h_wr_en_tmp = 0;
reg 	[17:0]		c_wr_data18bit = 0;
wire 	[17:0]  	tanh_out_c ;//(1,0,17) 
reg c_rd_flag =0;
wire [15:0] h_wr_data_fifo;
wire [15:0] c_wr_data_ram ;
assign 	h_wr_data_fifo = (cnt132 == 131) ? 0: h;
assign  c_wr_data_ram = (cnt132 == 131) ? 0: c_wr_data;


always@(posedge clk)  
begin
	if(~rst_n)
	begin
		
	end
	else
	begin
		
		
		

		

	end
end



//test
//reg [9:0]  cnt_lstmoutput=0;
//always@(posedge clk)
//begin
//	
//	if(lstm_dout_vld)
//	begin
//		cnt_lstmoutput <= cnt_lstmoutput + 1;
//	end
//	
//	
//end
/*
reg [15:0]  cnt_lstminput=0;
always@(posedge clk)
begin
	
	if(din_vld)
	begin
		cnt_lstminput <= cnt_lstminput + 1;
	end
end
*/
always@(posedge clk)  
begin
	if(~rst_n)
	begin
		
	end
	else
	begin
	// x*kernel
		if(din_vld)  //save to input_buffer
		begin
			if(addr_wr == 13'd4223)  //132*32-1
			begin
				addr_wr <= 13'd0;
			end
			else
			begin
				addr_wr <= addr_wr + 13'd1;
			end
			if(addr_wr==128)// 开始 
			begin
				rd_kernel_flag <= 1;
			end
		end
		else;
		{accu_cnt32,cnt32_tmp} <= {cnt32_tmp,cnt32};  //  delay 5clk, wait mult result 3clk, reading data need 2 clk
		/*if(addr_wr == 32)  // 开始计算的时间还有待确定 ？
		begin
			rd_kernel_flag <= 1;
		end
		else;
		*/
		if(rd_kernel_flag)
		begin
			if(kernel_addr == 4096-1)
			begin
				kernel_addr <= 0;
				rd_kernel_flag <= 0;
				
			end
			else
			begin
				kernel_addr <= kernel_addr + 1;			
			end
		end
		else
		begin
			kernel_addr <= 0;
		end
		rd_in_flag <=  rd_kernel_flag;
		{addbias_flag, addbias_flag_tmp} <= {addbias_flag_tmp,rd_in_flag};
		if(rd_in_flag)
		begin
			if(cnt32 == 31)
			begin
				cnt32 <= 0;
				addr_rd <= addr_rd_tmp;  //  4096次之后要改

			end
			else
			begin
				cnt32 <= cnt32 + 1;
				addr_rd <= addr_rd + 1;
			end
		end
		else
		begin
			cnt32<= 0;
			//addr_rd<=0;
			
		end
		
		if(accu_cnt32==5'b0)
		begin
			sum32_i <=  prdt_i; // (2,5,25)
			sum32_f <=  prdt_f;
			sum32_c <=  prdt_c;
			sum32_o <=  prdt_o;
			x_i <= sum32_i[30:13] + lstm_bias[71:54];
			x_f <= sum32_f[30:13] + lstm_bias[53:36];
			x_c <= sum32_c[30:13] + lstm_bias[35:18];
			x_o <= sum32_o[30:13] + lstm_bias[17: 0];
		end
		else
		begin
			sum32_i <= sum32_i + prdt_i;
			sum32_f <= sum32_f + prdt_f;
			sum32_c <= sum32_c + prdt_c;
			sum32_o <= sum32_o + prdt_o;
		end 
		if(addbias_flag)
		begin
			if(add_cnt32 ==31)
			begin
				add_cnt32 <=  0;
				
				bias_addr <= bias_addr + 1;
			//	if(cnt128 == 127)
			//	begin
			//		cnt128 <= 0;
			//		x_ifco_over <= 1;
			//	end
			//	else
			//	begin
			//		cnt128 <= cnt128 + 1;
			//	end
			end
			else
			begin
				add_cnt32 <=  add_cnt32 + 1;
			
			end
		end
		else
		begin
			
			bias_addr <= 0;
			add_cnt32 <= 0;
			//cnt128 <= 0;
		end
	
	
	// h*recurrent_kernel 
		{accu_cnt32_rk,cnt32_tmp1} <= {cnt32_tmp1,h_rd_addr};  //  delay 5clk, wait mult result 3clk, reading data need 2 clk
		{cnt32_0,cnt32_0_tmp}  <= {cnt32_0_tmp,accu_cnt32_rk};
		//if(testcnt == 32)  // 开始时间要修改
		//begin
		//	rd_Rkernel_flag <= 1;
		//end
		if(addr_wr==128) //  开始
		begin
			rd_Rkernel_flag <= 1;
		end
		h_wr_en  <=  fifo_h_rd_en;
		if(fifo_h_rd_en)
		begin
			if(cnt32_1 == 31)
			begin
				fifo_h_rd_en <= 0;
				cnt32_1 <= 0; 
			end
			else
			begin
				cnt32_1 <= cnt32_1 + 1;
			end
		end
		else
		begin
			cnt32_1 <= 0;
		end
		if(h_wr_en)
		begin
			if(h_buffer_addr == 31)
			begin
				h_buffer_addr <= 0;
				//fifo_h_rd_en <= 0;
				if(cnt132 == 132-1)
				begin
					cnt132 <= 0;
				end
				else
				begin
					cnt132 <= cnt132 + 1;
					rd_Rkernel_flag <= 1;
					rd_kernel_flag <=1;
				end
			end
			else
			begin
				h_buffer_addr <= h_buffer_addr + 1;
			end
		end
		else
		begin
			h_buffer_addr <= 0;
		end	
		
		if(rd_Rkernel_flag)  // 同时 read  h  and recurrent_kernel ,latency is 2 clks
		begin
			r_kernel_addr <= r_kernel_addr + 1;  
			if(h_rd_addr==31)
			begin
				h_rd_addr <= 0;
				if(cnt128 == 127)
				begin
					cnt128 <= 0;
					rd_Rkernel_flag <= 0;
					fifo_h_rd_en <= 1;
					if(addr_rd_tmp==4224-32)
					begin
						addr_rd_tmp<=0;
					end
					else
					begin
						addr_rd_tmp <= addr_rd_tmp + 32 ;
					end
					
				end
				else
				begin
					cnt128 <= cnt128 + 1;
				end
				
			end
			else
			begin
				h_rd_addr <= h_rd_addr + 1;
			end
		end
		else
		begin
			h_rd_addr <= 0;
			r_kernel_addr <= 0;
			cnt128 <= 0;

		end
		
		if(accu_cnt32_rk==5'd0)
		begin
			sum32_r_i[31:0] <= prdt_r_i[31:0];  sum32_r_i[63:32] <= prdt_r_i[63:32];
			sum32_r_f[31:0] <= prdt_r_f[31:0];  sum32_r_f[63:32] <= prdt_r_f[63:32];
			sum32_r_c[31:0] <= prdt_r_c[31:0];  sum32_r_c[63:32] <= prdt_r_c[63:32];
			sum32_r_o[31:0] <= prdt_r_o[31:0];  sum32_r_o[63:32] <= prdt_r_o[63:32];
			sum32_r_i[95:64] <= prdt_r_i[95:64];  sum32_r_i[127:96] <= prdt_r_i[127:96];
			sum32_r_f[95:64] <= prdt_r_f[95:64];  sum32_r_f[127:96] <= prdt_r_f[127:96];
			sum32_r_c[95:64] <= prdt_r_c[95:64];  sum32_r_c[127:96] <= prdt_r_c[127:96];
			sum32_r_o[95:64] <= prdt_r_o[95:64];  sum32_r_o[127:96] <= prdt_r_o[127:96];
			
			sum_r_i_tmpa  <= sum32_r_i[31:0] + sum32_r_i[63:32]  ;
			sum_r_f_tmpa  <= sum32_r_f[31:0] + sum32_r_f[63:32]  ;
			sum_r_c_tmpa  <= sum32_r_c[31:0] + sum32_r_c[63:32]  ;                               
			sum_r_o_tmpa  <= sum32_r_o[31:0] + sum32_r_o[63:32]  ;
			sum_r_i_tmpb  <= sum32_r_i[95:64] + sum32_r_i[127:96]  ;
			sum_r_f_tmpb  <= sum32_r_f[95:64] + sum32_r_f[127:96]  ;
			sum_r_c_tmpb  <= sum32_r_c[95:64] + sum32_r_c[127:96]  ;
			sum_r_o_tmpb  <= sum32_r_o[95:64] + sum32_r_o[127:96]  ;
		end
		else
		begin
			sum32_r_i[31 : 0] <= sum32_r_i[31 : 0] + prdt_r_i[31 : 0] ;
			sum32_r_f[31 : 0] <= sum32_r_f[31 : 0] + prdt_r_f[31 : 0] ;
			sum32_r_c[31 : 0] <= sum32_r_c[31 : 0] + prdt_r_c[31 : 0] ;
			sum32_r_o[31 : 0] <= sum32_r_o[31 : 0] + prdt_r_o[31 : 0] ;
			sum32_r_i[63 :32] <= sum32_r_i[63 :32] + prdt_r_i[63 :32] ;
			sum32_r_f[63 :32] <= sum32_r_f[63 :32] + prdt_r_f[63 :32] ;
			sum32_r_c[63 :32] <= sum32_r_c[63 :32] + prdt_r_c[63 :32] ;
			sum32_r_o[63 :32] <= sum32_r_o[63 :32] + prdt_r_o[63 :32] ;
			sum32_r_i[95 :64] <= sum32_r_i[95 :64] + prdt_r_i[95 :64] ;
			sum32_r_f[95 :64] <= sum32_r_f[95 :64] + prdt_r_f[95 :64] ;
			sum32_r_c[95 :64] <= sum32_r_c[95 :64] + prdt_r_c[95 :64] ;
			sum32_r_o[95 :64] <= sum32_r_o[95 :64] + prdt_r_o[95 :64] ;
			sum32_r_i[127:96] <= sum32_r_i[127:96] + prdt_r_i[127:96] ;
			sum32_r_f[127:96] <= sum32_r_f[127:96] + prdt_r_f[127:96] ;
			sum32_r_c[127:96] <= sum32_r_c[127:96] + prdt_r_c[127:96] ;
			sum32_r_o[127:96] <= sum32_r_o[127:96] + prdt_r_o[127:96] ;
		end 
		
		if(cnt32_0==31)
		begin
			result_flag <= 1;
			sum_r_i <= sum_r_i_tmpa + sum_r_i_tmpb;
			sum_r_f <= sum_r_f_tmpa + sum_r_f_tmpb;
			sum_r_c <= sum_r_c_tmpa + sum_r_c_tmpb;
			sum_r_o <= sum_r_o_tmpa + sum_r_o_tmpb;
		end
		else
		begin
			result_flag <= 0;
		end

	end
end

always@(posedge clk)
begin
	if(~rst_n)
	begin
	
	end
	else
	begin
	sigmoid_in_flag <= result_flag ;
	{mult_flag,mult_flag_tmp} <= {mult_flag_tmp,sigmoid_in_flag};
	
	//c_rd_flag <= mult_flag_tmp[0];
	if(mult_flag)
	begin
		c_rd_addr <= c_rd_addr + 1;
	end
	else;
	
	
	{c_wr_en, c_flag_tmp } <= {c_flag_tmp,mult_flag};
	
	{h_flag,h_wr_en_tmp}	<= {h_wr_en_tmp,c_wr_en};
	if(c_wr_en)
	begin
		c_wr_addr <= c_wr_addr + 1;
	end
	

	sigmoid_input_i <=	sum_r_i[30:13]  +    x_i[17:0]  ;
	sigmoid_input_f	<=  sum_r_f[30:13]  +    x_f[17:0]  ;
	tanh_input_c	<=  sum_r_c[30:13]  +    x_c[17:0]  ; 
	sigmoid_input_o	<=  sum_r_o[30:13]  +    x_o[17:0]  ;
	{sgd_dout_o_dly9,sgd_dout_o_tmp} <= {sgd_dout_o_tmp,sgd_dout_o};

	c_wr_data <= {fXc_tm[30],fXc_tm[26:12]} + {{3{iXtanh_out_c[31]}},iXtanh_out_c[29:17]}; // (1,5,10)
	c_wr_data18bit <={fXc_tm[30],fXc_tm[26:10]} + {{3{iXtanh_out_c[31]}},iXtanh_out_c[29:15]}; // (1,5,12)
	
	end
end
   
// i * np.tanh(x_c + np.dot(h_tm_c, recurrent_kernel_c))
MULT_16X16 mult_iXtanh_out_c (.CLK(clk), .A(sgd_dout_i),.B(tanh_out_xc[17:2]), .CE(CE),.P(iXtanh_out_c));// (2,3,27)
//sgd_dout_i_dly5:(1,3,12)    tanh_out_xc(1,0,17)  

//f * c_tm
MULT_16X16  mult_fXc_tm (.CLK(clk), .A(sgd_dout_f),.B(c_rd_data), .CE(CE),.P(fXc_tm));// (2,8,22)
//sgd_dout_f_dly5:(1,3,12)     c_rd_data(1,5,10)

MULT_16X16  mult_oXtanh_out_c (.CLK(clk), .A(sgd_dout_o_dly9),.B(tanh_out_c[17:2]), .CE(CE),.P(h_tmp));// (2,3,27)
 //sgd_dout_o_dly9(1,3,12)    tanh_out_c :(1,0,17)  
hard_sigmoid #(.int_bitsnum(4) ) hard_sigmoid_i(
.clk        (clk)       ,
.rst_n      (rst_n)     ,
.in_vld		(sigmoid_in_flag	)	,	//input valid 
.in_data	({sigmoid_input_i[17],sigmoid_input_i[15:1]})	,	//(1,4,12)
.out_vld	(sgd_out_flag_i)	,	//output valid
.out_data	(sgd_dout_i)		//output [15:0]data 
 );
 hard_sigmoid #(.int_bitsnum(4) ) hard_sigmoid_f(
.clk        (clk)       ,
.rst_n      (rst_n)     ,
.in_vld		(sigmoid_in_flag	)	,	//input valid 
.in_data	({sigmoid_input_f[17],sigmoid_input_f[15:1]})	,	//input [15:0] data
.out_vld	(sgd_out_flag_f)	,	//output valid
.out_data	(sgd_dout_f)		//output [15:0]data 
 );
 hard_sigmoid #(.int_bitsnum(4) ) hard_sigmoid_o(
.clk        (clk)       ,
.rst_n      (rst_n)     ,
.in_vld		(sigmoid_in_flag	)	,	//input valid 
.in_data	({sigmoid_input_o[17],sigmoid_input_o[15:1]})	,	//input [15:0] data
.out_vld	(sgd_out_flag_o)	,	//output valid
.out_data	(sgd_dout_o)		//output [15:0]data 
 );


tanh tanh_instance1(
.clk			(clk		),
.tanh_in 		(tanh_input_c	),		// (1,5,12)
.tanh_out		(tanh_out_xc	)			//(1,0,17)  
 );
 tanh tanh_instance2(
.clk			(clk		),
.tanh_in 		(c_wr_data18bit	),		// (1,5,12)
.tanh_out		(tanh_out_c)			//(1,0,17)  
 );
genvar s1;
generate
	for(s1 = 0; s1 < 4; s1= s1 + 1)
	begin:round1   				
		MULT_16X16 mult_Rkerneli (.CLK(clk), .A(h_rd_data[s1*16+15-:16]),.B(r_kernel_data[255-(s1*64)-:16]), .CE(CE),.P(prdt_r_i[s1*32+31-:32] ));
		MULT_16X16 mult_Rkernelf (.CLK(clk), .A(h_rd_data[s1*16+15-:16]),.B(r_kernel_data[239-(s1*64)-:16]), .CE(CE),.P(prdt_r_f[s1*32+31-:32] ));
		MULT_16X16 mult_Rkernelc (.CLK(clk), .A(h_rd_data[s1*16+15-:16]),.B(r_kernel_data[223-(s1*64)-:16]), .CE(CE),.P(prdt_r_c[s1*32+31-:32] ));
		MULT_16X16 mult_Rkernelo (.CLK(clk), .A(h_rd_data[s1*16+15-:16]),.B(r_kernel_data[207-(s1*64)-:16]), .CE(CE),.P(prdt_r_o[s1*32+31-:32] ));
	end
endgenerate





SDPRAM_16X128_C c_buffer (
  .clka(clk),    // input wire clka
  .wea(c_wr_en),      // input wire [0 : 0] wea
  .addra(c_wr_addr),  // input wire [6 : 0] addra
  .dina(c_wr_data_ram),    // input wire [15 : 0] dina  // (1,5,10)
  .clkb(clk),    // input wire clkb
  .addrb(c_rd_addr),  // input wire [6 : 0] addrb
  .doutb(c_rd_data)  // output wire [15 : 0] doutb	// (1,5,10)
);



FIFO_16X128 h_buffer_fifo (
  .clk(clk),      // input wire clk
  .srst(!rst_n),    // input wire srst
  .din(h_wr_data_fifo),      // input wire [15 : 0] din
  .wr_en(h_flag),  // input wire wr_en
  .rd_en(fifo_h_rd_en),  // input wire rd_en
  .dout(fifo_hout),    // output wire [63 : 0] dout
  .full(fifo_h_full),    // output wire full
  .empty(fifo_h_empty)  // output wire empty
);

SDPRAM_64X32 h_buffer (
  .clka(clk),    // input wire clka
  .wea(h_wr_en),      // input wire [0 : 0] wea
  .addra(h_buffer_addr),  // input wire [4 : 0] addra
  .dina({fifo_hout[15:0],fifo_hout[31:16],fifo_hout[47:32],fifo_hout[63:48]}),    // input wire [63 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(h_rd_addr),  // input wire [4 : 0] addrb
  .doutb(h_rd_data)  // output wire [63 : 0] doutb
);
/*
SDPRAM_16X128 h_buffer (   							//  in :a,b,c,d,    out: dcba       latency :2clks
  .clka(clk),    // input wire clka
  .wea(0),      // input wire [0 : 0] wea
  .addra(h_wr_addr),  // input wire [6 : 0] addra
  .dina(h),    // input wire [15 : 0] dina  			 //(1,3,12)
  .clkb(clk),    // input wire clkb
  .addrb(h_rd_addr),  // input wire [4 : 0] addrb
  .doutb(h_rd_data)  // output wire [63 : 0] doutb
);

*/
SPROM_IFCO_256X4096 recurrent_kernel_ifco_x4 (           // latency :2clks
  .clka(clk),    // input wire clka
  .addra(r_kernel_addr),  // input wire [11 : 0] addra
  .douta(r_kernel_data)  // output wire [255 : 0] douta   //data fomat: ifcoifcoifcoifco
);


SPROM_LSTM_BIAS72X128 lstm_bias_ifco (  //  latency  2 clks
  .clka(clk),    // input wire clka
  .addra(bias_addr),  // input wire [6 : 0] addra
  .douta(lstm_bias)  // output wire [71 : 0] douta   
);




BRAM_16X4224 input_buffer (  // cnn2output dim  1*32*132 = 4244
  .clka(clk),    // input wire clka
  .wea(din_vld),      // input wire [0 : 0] wea
  .addra(addr_wr),  // input wire [12 : 0] addra
  .dina(din),    // input wire [15 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(addr_rd),  // input wire [12 : 0] addrb
  .doutb(lstm_din)  // output wire [15 : 0] doutb
);


BRAM_KERNEL_64X4096  kernel_ifco_32X128 ( 
  .clka(clk),    // input wire clka
  .ena(kernel_en),      // input wire ena
  .addra(kernel_addr),  // input wire [11 : 0] addra
  .douta(kernel_data)  // output wire [63 : 0] douta 			
);



MULT_16X16 mult_kerneli (
  .CLK(clk),  // input wire CLK
  .A(lstm_din),      // input wire [15 : 0] A
  .B(kernel_data[63:48]),      // input wire [15 : 0] B
  .CE(CE),    // input wire CE
  .P(prdt_i)      // output wire [31 : 0] P
);
MULT_16X16 mult_kernelf (
  .CLK(clk),  // input wire CLK
  .A(lstm_din),      // input wire [15 : 0] A
  .B(kernel_data[47:32]),      // input wire [15 : 0] B
  .CE(CE),    // input wire CE
  .P(prdt_f)      // output wire [31 : 0] P
);
MULT_16X16 mult_kernelc (
  .CLK(clk),  // input wire CLK
  .A(lstm_din),      // input wire [15 : 0] A
  .B(kernel_data[31:16]),      // input wire [15 : 0] B
  .CE(CE),    // input wire CE
  .P(prdt_c)      // output wire [31 : 0] P
);
MULT_16X16 mult_kernelo (
  .CLK(clk),  // input wire CLK
  .A(lstm_din),      // input wire [15 : 0] A
  .B(kernel_data[15:0]),      // input wire [15 : 0] B
  .CE(CE),    // input wire CE
  .P(prdt_o)      // output wire [31 : 0] P
);

endmodule
