`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/25 09:43:11
// Design Name: 
// Module Name: CONV2
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


module CONV2(

input  					clk,
input  					rst_n,
input [16*8-1 : 0]  	conv2_in_i,//(1,1,14)
input [16*8-1 : 0]  	conv2_in_q,//(1,1,14)
input					conv2_in_valid,
output [15:0]			output_conv2,
output					output_conv2_valid
); 

reg 					rd_fifo = 0;

wire 	[16*8-1:0]		dout_cnn1_i;
wire 	[16*8-1:0]		dout_cnn1_q;
wire 					full_cnn1_i;
wire 					full_cnn1_q;
wire 					empty_cnn1_i;
wire 					empty_cnn1_q;


reg 		[8 : 0] 		addr_weight = 0;
reg			[4 : 0] 		addr_bias = 0;
wire 		[127 : 0] 		w00;//(1,1,14)
wire 		[127 : 0] 		w01;
wire 		[127 : 0] 		w02;
wire 		[127 : 0] 		w10;
wire 		[127 : 0] 		w11;
wire 		[127 : 0] 		w12;
wire 		[23 : 0]  		cnn2_bias;

reg  						CE = 1 ;
reg			[16*8-1:0]		I0 = 0;
reg			[16*8-1:0]		I1 = 0;	
reg			[16*8-1:0]		I2 = 0;	
reg			[16*8-1:0]		Q0 = 0;	
reg			[16*8-1:0]		Q1 = 0;	
reg			[16*8-1:0]		Q2 = 0;	
	
reg			[16*8-1:0]		I0_tmp = 0;
reg			[16*8-1:0]		I1_tmp = 0;	
reg			[16*8-1:0]		I2_tmp = 0;	
reg			[16*8-1:0]		Q0_tmp = 0;	
reg			[16*8-1:0]		Q1_tmp = 0;	
reg			[16*8-1:0]		Q2_tmp = 0;	
	


reg 		[8 : 0]			addr_wr		= 0;
reg  		[8 : 0] 		addr_rd_i 	= 0;
reg  		[8 : 0] 		addr_rd_q 	= 0;
wire 		[127 : 0] 		dout_i0;
wire 		[127 : 0] 		dout_i1;
wire 		[127 : 0] 		dout_i2;
wire 		[127 : 0] 		dout_q0;
wire 		[127 : 0] 		dout_q1;
wire 		[127 : 0] 		dout_q2;

reg 						rd_en		= 0;
reg 		[9:0] 			cnt512 		= 0;
reg 		[12:0]			cnt130X32 	= 0; 
reg 		[9:0]			cnt16X32 	= 0;
reg 		[7:0]			cnt_43clk 	= 0;
//  I2 Q2 16个时钟满  6个128路数据准备好，并行计算8*6个乘法16次（16时钟） 同时准别浩6个128路数据 ，

reg  [2:0] 			ram_wr_sel 			= 3'b001;
reg 				buf_begin 			= 0;
reg 				rden_tmp 			= 0;
reg  [2:0] 			state0 				= 3'b001;		
reg  [15:0]     	clk_cnt 			= 0;
reg  [4:0]      	rd_cnt 				= 0;
reg 				rd_wait_cnt_flag 	= 0;
reg  [9:0]			rd_wait_cnt 		= 0 ;
reg 				bram_en_wr 			= 0;
reg 				ram_shift_flag 		= 0;
reg					rd_ram_flag_tmp 	= 0;
reg [2:0]			reg_delay		 	= 0;
reg 				pading_flag 		= 0;
reg 				pading_flag_tmp 	= 0;
reg [1:0]			tmp_delay3clk 		= 0;
reg					addr_bias_flag 		= 0;
reg 	[4:0]		cnt16_1 			= 0;
reg 				cnt16_flag 			= 0;

wire  	[32*8-1:0]  	p00 ;
wire  	[32*8-1:0]  	p01 ;
wire  	[32*8-1:0]  	p02 ;

wire  	[32*8-1:0]  	p10 ;
wire  	[32*8-1:0]  	p11 ;
wire  	[32*8-1:0]  	p12 ;
wire 	[17*4-1:0]		sum1_1   ;
wire 	[17*4-1:0]		sum1_2   ;
wire 	[17*4-1:0]		sum1_3   ;
wire 	[17*4-1:0]		sum1_4   ;
wire 	[17*4-1:0]		sum1_5   ;
wire 	[17*4-1:0]		sum1_6   ;
wire 	[18*2-1:0]		sum2_1  ;
wire 	[18*2-1:0]		sum2_2  ;
wire 	[18*2-1:0]		sum2_3  ;
wire 	[18*2-1:0]		sum2_4  ;
wire 	[18*2-1:0]		sum2_5  ;
wire 	[18*2-1:0]		sum2_6  ;
wire	[18:0]   		sum3_1  ;
wire	[18:0]   		sum3_2  ;
wire	[18:0]   		sum3_3  ;
wire	[18:0]   		sum3_4  ;
wire	[18:0]   		sum3_5  ;
wire	[18:0]   		sum3_6  ;
wire	[19:0]			sum4_1  ;
wire	[19:0]			sum4_2  ;
wire	[19:0]			sum4_3  ;
wire 	[20:0]			sum5_1  ;
wire 	[20:0]			sum5_2  ;
wire 	[21:0]			sum6_1  ;
wire 	[22:0]			sum7;
wire 	[23:0]			sum8;
wire 	[24:0]			sum9;
wire 	[24:0] 			sum10;	
wire 	[24:0] 			sum11;

assign output_conv2 =  sum11[24]?16'b0:{sum11[24],sum11[15:13],sum11[12:1]}; // 1 3 12-

reg [9:0] 	cnt46 					= 0;
reg 		output_flag				= 0;
reg [4:0]	out_cnt16 				= 0;
reg  		output_conv2_vld_reg 	= 0;

assign  output_conv2_valid= output_conv2_vld_reg;

reg [10:0] 	cnt512forzero 			= 0;
reg [2:0] 	zp012 					= 3'b100;
reg [15:0] 	cnt_cnn2input 			= 0;
reg [15:0] 	cnt_cnn2output 			= 0;


/*
reg [15:0] cnt = 0;
integer     file1 ;
initial begin
    file1 = $fopen("D:/Modulation_recognition/data_conv2_output.txt","w");
end
always@(posedge clk)
begin
    if(output_conv2_vld_reg)
    begin
        if(cnt < 32*4)
        begin
            $fwrite(file1,"%h\n",output_conv2[15:0]);
            
            cnt <= cnt + 1;
        end
        else
        begin
            $fclose(file1);
        end
    end
    else;    
end
*/
//-----------------------------------------------------------------------



always@(posedge clk ) 
begin
	if(!rst_n)
	begin
		addr_wr		<= 0;
		addr_rd_i 	<= 0;
		addr_rd_q 	<= 0;
		ram_wr_sel 			<= 3'b001;
		buf_begin 			<= 0;
		rden_tmp 			<= 0;
		state0 				<= 3'b001;
		clk_cnt 			<= 0;
		rd_cnt 				<= 0;
		rd_wait_cnt_flag 	<= 0;
		rd_wait_cnt 		<= 0 ;
		bram_en_wr 			<= 0;
		ram_shift_flag 		<= 0;
		rd_ram_flag_tmp 	<= 0;
		reg_delay		 	<= 0;
		pading_flag 		<= 0;
		pading_flag_tmp 	<= 0;
		tmp_delay3clk 		<= 0;
		addr_bias_flag 		<= 0;
		cnt16_1 			<= 0;
		cnt16_flag 			<= 0;
		cnt46 					<= 0;
		output_flag				<= 0;
		out_cnt16 				<= 0;
		output_conv2_vld_reg 	<= 0;
		cnt512forzero 			<= 0;
		zp012 					<= 3'b100;
		cnt_cnn2input 			<= 0;
		cnt_cnn2output 			<= 0;
		
	end
	else
	begin
		//clk_cnt <= clk_cnt + 1;
		//
		//
		//if(clk_cnt == 200)			//  什么时候开始待定
		////if(full_cnn1_i )			
		//begin
		//	rd_fifo <= 1;  
		//	rd_ram_flag_tmp <= 1;  //
		//end
		//else;
		if(conv2_in_valid)
		begin
			if(cnt_cnn2input ==64)
			begin
				
				rd_fifo <= 1;  
				rd_ram_flag_tmp <= 1;
				
				cnt_cnn2input <= cnt_cnn2input + 1;
			end
			else if(cnt_cnn2input==2080)
			begin
				cnt_cnn2input <= 1;
			end
			else
			begin
				cnt_cnn2input <= cnt_cnn2input + 1;
			end
			
		end
		
		
		
		
		if(output_conv2_valid)
		begin
			cnt_cnn2output <= cnt_cnn2output + 1;
		end
		else;  
		
		
		//test 
		if(cnt_cnn2output==132*32)
		begin
			rd_fifo <= 0;  
			rd_ram_flag_tmp <= 0; 
			cnt_cnn2output <= 0;
			pading_flag_tmp <= 0;
			rd_wait_cnt_flag <= 0;
		end
		{rd_en,reg_delay} <= {reg_delay,rd_ram_flag_tmp};
		if(rd_fifo)  // 开始从FIFO读输入
		begin
			if(rd_cnt==15)  // 读入一个128路信号
			begin
				rd_cnt <=0;
				rd_fifo<=0;  // 读一个(128)之后停止
				rd_wait_cnt_flag <= 1;
				ram_shift_flag <= 1;
			end
			else
			begin
				rd_cnt <= rd_cnt + 1;
			end
		end
		else;
		

		
		
		bram_en_wr <= rd_fifo;
		
		if(bram_en_wr)  //FIFO读出来存到BRAM
		begin
			if(addr_wr==15)
			begin
				addr_wr <= 0;
			end
			else
			begin
			addr_wr <= addr_wr + 1;
			end
		end
		
		if(rd_wait_cnt_flag)
		begin
			if(rd_wait_cnt == 31*16-1)
			begin
				rd_wait_cnt <= 0;
				rd_wait_cnt_flag <= 0;

				rd_fifo <= 1;

			end
			else
			begin
				rd_wait_cnt <= rd_wait_cnt + 1;
			end
		end
		else;
		
		if(rd_en)
		begin
			if(addr_rd_i==15) // 0-15 cir
			begin
				addr_rd_i <= 0;
				addr_rd_q <= 0;
				if(cnt130X32 == 130*32-1)// padding two 0（128channels）  
				begin
					cnt130X32 <= 0;
					pading_flag_tmp <=1;   //  可以在else里归零么？待解决
				end
				else
				begin
					cnt130X32 <= cnt130X32 + 1;
				end
				
			end
			else
			begin
				addr_rd_i <= addr_rd_i + 1;
				addr_rd_q <= addr_rd_q + 1;
			end
			
			if(ram_shift_flag)
			begin
				ram_shift_flag <= 0;
				ram_wr_sel <= {ram_wr_sel[1:0],ram_wr_sel[2]};
			end
			
		end
		else
		begin
			addr_rd_i <= 0;
			addr_rd_q <= 0;
			cnt130X32 <= 0; 
			ram_wr_sel <= 3'b001 ;
		end
		
		
		

		{pading_flag,tmp_delay3clk} <= {tmp_delay3clk,pading_flag_tmp};
		
		
		{buf_begin,rden_tmp} <= {rden_tmp,rd_en};
				
		if(buf_begin)
		begin
			if(cnt512==32*16-1)
			begin
				state0 <= {state0[1:0],state0[2]};
				cnt512 <= 0;
			end
			else
			begin
				cnt512 <= cnt512 + 1;
			end
			
			case(state0)
			3'b001: begin 
						case(zp012)
						3'b100: begin
									I0 <= 128'd0;	I1 <= 128'd0;	I2 <= dout_i0;
									Q0 <= 128'd0;	Q1 <= 128'd0;	Q2 <= dout_q0;
								end
						3'b010: begin
									I0 <= 128'd0;	I1 <= dout_i2;	I2 <= dout_i0;
							        Q0 <= 128'd0;	Q1 <= dout_q2;	Q2 <= dout_q0;
								end
						default: begin
									I0 <= dout_i1;	I1 <= dout_i2;	I2 <= dout_i0;
									Q0 <= dout_q1;	Q1 <= dout_q2;	Q2 <= dout_q0;
								 end
						endcase
				    end
			3'b010: begin 
						case(zp012)
						3'b100: begin
									I0 <= 128'd0;	I1 <= 128'd0;	I2 <= dout_i1;
						            Q0 <= 128'd0;	Q1 <= 128'd0;	Q2 <= dout_q1;
								end
						3'b010: begin
									I0 <= 128'd0;	I1 <= dout_i0;	I2 <= dout_i1;
						            Q0 <= 128'd0;	Q1 <= dout_q0;	Q2 <= dout_q1;
								end						  
						default: begin
									I0 <= dout_i2;	I1 <= dout_i0;	I2 <= dout_i1;
						            Q0 <= dout_q2;	Q1 <= dout_q0;	Q2 <= dout_q1;
								end	
						endcase
					end
			3'b100:	begin 
						case(zp012)
			            3'b100: begin
			            			I0 <= 128'd0;	I1 <= 128'd0;	I2 <= dout_i2;
			                        Q0 <= 128'd0;	Q1 <= 128'd0;	Q2 <= dout_q2;
			            		end
			            3'b010: begin
			            			I0 <= 128'd0;	I1 <= dout_i1;	I2 <= dout_i2;
			                        Q0 <= 128'd0;	Q1 <= dout_q1;	Q2 <= dout_q2;
			            		end						  
			            default:begin //001   不需要补零的情况
			            			I0 <= dout_i0;	I1 <= dout_i1;	I2 <= dout_i2;
			                        Q0 <= dout_q0;	Q1 <= dout_q1;	Q2 <= dout_q2;
			            		end	
						endcase
					end
			default:;
			endcase
			
		end
		else
		begin
			cnt512 <=0;
		end

		if(pading_flag)
		begin
			if(cnt16X32 ==512 )
			begin
				I0_tmp <= I0;
				I1_tmp <= 0;
				I2_tmp <= 0;
				Q0_tmp <= Q0;
				Q1_tmp <= 0;
				Q2_tmp <= 0;
				
			end
			else
			begin
				cnt16X32 <= cnt16X32 + 1;
				I0_tmp <= I0;
				I1_tmp <= I1;
				I2_tmp <= 0;
				Q0_tmp <= Q0;
				Q1_tmp <= Q1;
				Q2_tmp <= 0;
			end
		end
		else
		begin
			cnt16X32 <=0;
			I0_tmp <= I0;
			I1_tmp <= I1;
			I2_tmp <= I2;
			Q0_tmp <= Q0;
			Q1_tmp <= Q1;
			Q2_tmp <= Q2;
			
		end

		if(buf_begin)
		begin

			if(cnt512forzero==1024)
			begin
				zp012 <= 3'b001;
				cnt512forzero <= cnt512forzero;
			end
			else
			begin
				if(cnt512forzero == 512)
				begin
					zp012 <= 3'b010;//
				end
				cnt512forzero <= cnt512forzero + 1 ;
			end
			
		end
		else
		begin
			zp012 <= 3'b100;
			cnt512forzero <= 0;
		end
		
		
		
		if(buf_begin)
		begin
			if(cnt46 ==44-16)
			begin
				output_flag <= 1;  // add to 46
			end
			else
			begin
				cnt46 <= cnt46 + 1;
			end

			if(output_flag)
			begin
				if(out_cnt16==15)
				begin
					out_cnt16 <= 0;
					output_conv2_vld_reg <= 1;
				end
				else
				begin
					out_cnt16 <= out_cnt16 + 1;
					output_conv2_vld_reg <= 0;
				end
			end
			else
			begin
				output_conv2_vld_reg <= 0;
			end
			
			
			addr_weight <= addr_weight + 1;  //read weight 
			if(cnt_43clk==40-16)
			begin
				cnt16_flag <= 1;
			end
			else
			begin
				cnt_43clk <= cnt_43clk + 1;
			end
			
			if(cnt16_flag)
			begin
				if(cnt16_1==15)
				begin
					
					cnt16_1 <= 0;
					addr_bias_flag <= 1;
				end
				else
				begin
					cnt16_1 <= cnt16_1 + 1;
					addr_bias_flag <= 0;
				end
			end
		end
		else
		begin
			output_flag <= 0;
			cnt_43clk <= 0;
			cnt46 <=0;
			out_cnt16 <= 0;
			cnt16_flag <= 0;
			cnt16_1 <= 0;
			addr_bias_flag <= 0;
			addr_weight <= 0;
		
		end
		
		
		
		if(addr_bias_flag)
		begin
			if(addr_bias==31)  // 拉出去 少写个if
			begin
				addr_bias <= 0;
			end
			else
			begin
				addr_bias <= addr_bias + 1;
			end
		end
		else
		begin
			addr_bias <= 0;
		end
		
		
	end
end
reg [21:0]	sum6_1_dly1	= 0; // sum6_1 delay 1 clk 
reg [22:0]	sum7_dly1 = 0;		//sum7 delay 1 clk 
reg [22:0]	sum7_dly2 = 0;			//sum7 delay 2 clk 	

reg [23:0]	sum8_dly4 = 0;			// sum8 delay 4clk 
reg [24*3-1:0]	sum8_dly123 = 0;
reg [25*7-1:0]	sum9_dly1_7 = 0;
reg [24:0]	sum9_dly8 = 0;
		
always@(posedge clk)
begin
	if(!rst_n)
	begin
		sum6_1_dly1	<= 0;
		sum7_dly1 	<= 0;	
		sum7_dly2 	<= 0;	
		sum8_dly4 	<= 0;	
		sum8_dly123 <= 0;
	end
	else
	begin
		sum6_1_dly1 <= sum6_1 ;
		{sum7_dly2,sum7_dly1} <= {sum7_dly1,sum7};
		{sum8_dly4,sum8_dly123} <= {sum8_dly123,sum8};
		{sum9_dly8,sum9_dly1_7} <= {sum9_dly1_7,sum9};
	end
end


//  for test 
wire [15:0] input_i0;
wire [15:0] weight0;
wire [31:0] p000;
assign input_i0 = I0_tmp[15:0];
assign weight0 = w00[15:0];
assign p000 = p00[31:0];
wire [15:0] p00_16_1;
wire [15:0] p00_16_5;
wire [16:0] sum1_1_1;
assign p00_16_1 = p00[0*32+30:0*32+15];
assign p00_16_5 = p00[4*32+30:4*32+15];
assign sum1_1_1 = sum1_1[17*0+16-:17];

genvar m1;  
generate
	for (m1 = 0 ; m1 < 8 ; m1 = m1 + 1) 	// cnn2 weights size = (2,3) 
	begin	:g1								// A B: 1 1 14 ,P 2 2 28
		MULT_16X16 product_i00 (.CLK(clk), .A(I0_tmp[m1*16+15:m1*16]), .B(w00[m1*16+15:m1*16]), .CE(CE), .P(p00[m1*32+31:m1*32]) );
		MULT_16X16 product_i01 (.CLK(clk), .A(I1_tmp[m1*16+15:m1*16]), .B(w01[m1*16+15:m1*16]), .CE(CE), .P(p01[m1*32+31:m1*32]) );
		MULT_16X16 product_i02 (.CLK(clk), .A(I2_tmp[m1*16+15:m1*16]), .B(w02[m1*16+15:m1*16]), .CE(CE), .P(p02[m1*32+31:m1*32]) );	                                       
		MULT_16X16 product_i10 (.CLK(clk), .A(Q0_tmp[m1*16+15:m1*16]), .B(w10[m1*16+15:m1*16]), .CE(CE), .P(p10[m1*32+31:m1*32]) );
		MULT_16X16 product_i11 (.CLK(clk), .A(Q1_tmp[m1*16+15:m1*16]), .B(w11[m1*16+15:m1*16]), .CE(CE), .P(p11[m1*32+31:m1*32]) );
		MULT_16X16 product_i12 (.CLK(clk), .A(Q2_tmp[m1*16+15:m1*16]), .B(w12[m1*16+15:m1*16]), .CE(CE), .P(p12[m1*32+31:m1*32]) );
	end 
endgenerate


genvar s1;
generate
	for(s1 = 0; s1 < 4; s1= s1 + 1)
	begin:round1   				// A B cutbit 1 2 13 , S  1 3 13
		ADDER_16_16_17 SUM1_1 (.A(p00[s1*32+30:s1*32+15]),.B(p00[(4+s1)*32+30-:16]),.CLK(clk),.CE(CE),.S(sum1_1[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_2 (.A(p01[s1*32+30:s1*32+15]),.B(p01[(4+s1)*32+30-:16]),.CLK(clk),.CE(CE),.S(sum1_2[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_3 (.A(p02[s1*32+30:s1*32+15]),.B(p02[(4+s1)*32+30-:16]),.CLK(clk),.CE(CE),.S(sum1_3[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_4 (.A(p10[s1*32+30:s1*32+15]),.B(p10[(4+s1)*32+30-:16]),.CLK(clk),.CE(CE),.S(sum1_4[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_5 (.A(p11[s1*32+30:s1*32+15]),.B(p11[(4+s1)*32+30-:16]),.CLK(clk),.CE(CE),.S(sum1_5[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_6 (.A(p12[s1*32+30:s1*32+15]),.B(p12[(4+s1)*32+30-:16]),.CLK(clk),.CE(CE),.S(sum1_6[17*s1+16-:17])  );
		/*
		// A B cutbit 1 1 14 , S  1 2 14
		ADDER_16_16_17 SUM1_1 (.A({p00[s1*32+30],p00[s1*32+28-:15]}),.B({p00[(4+s1)*32+30],p00[(4+s1)*32+28-:15]}),.CLK(clk),.CE(CE),.S(sum1_1[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_2 (.A({p01[s1*32+30],p01[s1*32+28-:15]}),.B({p01[(4+s1)*32+30],p01[(4+s1)*32+28-:15]}),.CLK(clk),.CE(CE),.S(sum1_2[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_3 (.A({p02[s1*32+30],p02[s1*32+28-:15]}),.B({p02[(4+s1)*32+30],p02[(4+s1)*32+28-:15]}),.CLK(clk),.CE(CE),.S(sum1_3[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_4 (.A({p10[s1*32+30],p10[s1*32+28-:15]}),.B({p10[(4+s1)*32+30],p10[(4+s1)*32+28-:15]}),.CLK(clk),.CE(CE),.S(sum1_4[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_5 (.A({p11[s1*32+30],p11[s1*32+28-:15]}),.B({p11[(4+s1)*32+30],p11[(4+s1)*32+28-:15]}),.CLK(clk),.CE(CE),.S(sum1_5[17*s1+16-:17])  );
		ADDER_16_16_17 SUM1_6 (.A({p12[s1*32+30],p12[s1*32+28-:15]}),.B({p12[(4+s1)*32+30],p12[(4+s1)*32+28-:15]}),.CLK(clk),.CE(CE),.S(sum1_6[17*s1+16-:17])  );
		*/
	end
endgenerate

genvar s2;
generate
	for(s2 = 0; s2 < 2; s2= s2 + 1)
	begin:round2   				
		ADDER_17_17_18 SUM2_1 (.A(sum1_1[s2*17+16-:17]),.B(sum1_1[(2+s2)*17+16-:17]),.CLK(clk),.CE(CE),.S(sum2_1[18*s2+17-:18])  );
		ADDER_17_17_18 SUM2_2 (.A(sum1_2[s2*17+16-:17]),.B(sum1_2[(2+s2)*17+16-:17]),.CLK(clk),.CE(CE),.S(sum2_2[18*s2+17-:18])  );
		ADDER_17_17_18 SUM2_3 (.A(sum1_3[s2*17+16-:17]),.B(sum1_3[(2+s2)*17+16-:17]),.CLK(clk),.CE(CE),.S(sum2_3[18*s2+17-:18])  );
		ADDER_17_17_18 SUM2_4 (.A(sum1_4[s2*17+16-:17]),.B(sum1_4[(2+s2)*17+16-:17]),.CLK(clk),.CE(CE),.S(sum2_4[18*s2+17-:18])  );
		ADDER_17_17_18 SUM2_5 (.A(sum1_5[s2*17+16-:17]),.B(sum1_5[(2+s2)*17+16-:17]),.CLK(clk),.CE(CE),.S(sum2_5[18*s2+17-:18])  );
		ADDER_17_17_18 SUM2_6 (.A(sum1_6[s2*17+16-:17]),.B(sum1_6[(2+s2)*17+16-:17]),.CLK(clk),.CE(CE),.S(sum2_6[18*s2+17-:18])  );
	end
endgenerate


ADDER_18_18_19 SUM3_1 (.A(sum2_1[17+18:18]),.B(sum2_1[17:0]),.CLK(clk),.CE(CE),.S(sum3_1[18:0])  );  //  8个值的和
ADDER_18_18_19 SUM3_2 (.A(sum2_2[17+18:18]),.B(sum2_2[17:0]),.CLK(clk),.CE(CE),.S(sum3_2[18:0])  );
ADDER_18_18_19 SUM3_3 (.A(sum2_3[17+18:18]),.B(sum2_3[17:0]),.CLK(clk),.CE(CE),.S(sum3_3[18:0])  );
ADDER_18_18_19 SUM3_4 (.A(sum2_4[17+18:18]),.B(sum2_4[17:0]),.CLK(clk),.CE(CE),.S(sum3_4[18:0])  );
ADDER_18_18_19 SUM3_5 (.A(sum2_5[17+18:18]),.B(sum2_5[17:0]),.CLK(clk),.CE(CE),.S(sum3_5[18:0])  );
ADDER_18_18_19 SUM3_6 (.A(sum2_6[17+18:18]),.B(sum2_6[17:0]),.CLK(clk),.CE(CE),.S(sum3_6[18:0])  );


ADDER_19_19_20 SUM4_1 (.A(sum3_1[18:0]),.B(sum3_2[18:0]),.CLK(clk),.CE(CE),.S(sum4_1[19:0])  );
ADDER_19_19_20 SUM4_2 (.A(sum3_3[18:0]),.B(sum3_4[18:0]),.CLK(clk),.CE(CE),.S(sum4_2[19:0])  );
ADDER_19_19_20 SUM4_3 (.A(sum3_5[18:0]),.B(sum3_6[18:0]),.CLK(clk),.CE(CE),.S(sum4_3[19:0])  );


ADDER_20_20_21 SUM5_1 (.A(sum4_1[19:0]),.B(sum4_2[19:0]),.CLK(clk),.CE(CE),.S(sum5_1[20:0])  );
ADDER_20_20_21 SUM5_2 (.A(sum4_3[19:0]),.B(20'b0)		,.CLK(clk),.CE(CE),.S(sum5_2[20:0])  );


ADDER_21_21_22 SUM6_1 (.A(sum5_1[20:0]),.B(sum5_2[20:0]),.CLK(clk),.CE(CE),.S(sum6_1[21:0])  );  //8x6=48 个数的和
/*
a	b	c	d	e	f	g	h	i	j	k	l	m	n	o	p	                    //  A  
	a	b	c	d	e	f	g	h	i	j	k	l	m	n	o	p	  													//  B = A delay  1 clk 
			ab	bc	cd	de	ef	fg	gh  hi	ij	jk	kl	lm	mn	no	op														// A + B 
					ab	bc	cd	de	ef	fg	gh 	hi	ij	jk	kl	lm	mn	no	op																	// A + B  delay 2 clk 
							abcd			efgh 			ijkl			mnop
											abcd			efgh 			ijkl			mnop 
														abcdefgh							ijklmnop
																							abcdefgh							ijklmnop
*/													

ADDER_22_22_23 SUM7 (.A(sum6_1[21:0]),.B(sum6_1_dly1[21:0]),.CLK(clk),.CE(CE),.S(sum7[22:0])  );													
ADDER_23_23_24 SUM8 (.A(sum7[22:0]),.B(sum7_dly2[22:0]),.CLK(clk),.CE(CE),.S(sum8[23:0])  );
ADDER_24_24_25 SUM9 (.A(sum8[23:0]),.B(sum8_dly4[23:0]),.CLK(clk),.CE(CE),.S(sum9[24:0])  );  
ADDER_24_24_25 SUM10 (.A(sum9[23:0]),.B({sum9_dly8[24],sum9_dly8[22:0]}),.CLK(clk),.CE(CE),.S(sum10[24:0])  );
ADDER_24_24_25 SUM11 (.A({sum10[24],sum10[22:0]}),.B(cnn2_bias),.CLK(clk),.CE(CE),.S(sum11[24:0])  );  // for test cnn2_bias=0

								
FIFO_CNN1_OUTPUT CNN1_OUTPUT_I_BUFFER (
  .clk(clk),      // input wire clk
  .srst(!rst_n),    // input wire srst
  .din(conv2_in_i),      // input wire [127 : 0] din
  .wr_en(conv2_in_valid),  // input wire wr_en
  .rd_en(rd_fifo),  // input wire rd_en
  .dout(dout_cnn1_i),    // output wire [127 : 0] dout
  .full(full_cnn1_i),    // output wire full
  .empty(empty_cnn1_i)  // output wire empty
);


FIFO_CNN1_OUTPUT CNN1_OUTPUT_Q_BUFFER (
  .clk(clk),      // input wire clk
  .srst(!rst_n),    // input wire srst
  .din(conv2_in_q),      // input wire [127 : 0] din
  .wr_en(conv2_in_valid),  // input wire wr_en
  .rd_en(rd_fifo),  // input wire rd_en
  .dout(dout_cnn1_q),    // output wire [127 : 0] dout
  .full(full_cnn1_q),    // output wire full
  .empty(empty_cnn1_q)  // output wire empty
);




BRAM_128X512 I0_BUFFER (
  .clka(clk),    // input wire clka
  .ena(bram_en_wr),      // input wire ena
  .wea(ram_wr_sel[0]),      // input wire [0 : 0] wea
  .addra(addr_wr),  // input wire [8 : 0] addra
  .dina(dout_cnn1_i),    // input wire [127 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(rd_en),      // input wire enb
  .addrb(addr_rd_i),  // input wire [8 : 0] addrb
  .doutb(dout_i0)  // output wire [127 : 0] doutb
);

BRAM_128X512 I1_BUFFER (
  .clka(clk),    // input wire clka
  .ena(bram_en_wr),      // input wire ena
  .wea(ram_wr_sel[1]),      // input wire [0 : 0] wea
  .addra(addr_wr),  // input wire [8 : 0] addra
  .dina(dout_cnn1_i),    // input wire [127 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(rd_en),      // input wire enb
  .addrb(addr_rd_i),  // input wire [8 : 0] addrb
  .doutb(dout_i1)  // output wire [127 : 0] doutb
);

BRAM_128X512 I2_BUFFER (
  .clka(clk),    // input wire clka
  .ena(bram_en_wr),      // input wire ena
  .wea(ram_wr_sel[2]),      // input wire [0 : 0] wea
  .addra(addr_wr),  // input wire [8 : 0] addra
  .dina(dout_cnn1_i),    // input wire [127 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(rd_en),      // input wire enb
  .addrb(addr_rd_i),  // input wire [8 : 0] addrb
  .doutb(dout_i2)  // output wire [127 : 0] doutb
);

BRAM_128X512 Q0_BUFFER (
  .clka(clk),    // input wire clka
  .ena(bram_en_wr),      // input wire ena
  .wea(ram_wr_sel[0]),      // input wire [0 : 0] wea
  .addra(addr_wr),  // input wire [8 : 0] addra
  .dina(dout_cnn1_q),    // input wire [127 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(rd_en),      // input wire enb
  .addrb(addr_rd_q),  // input wire [8 : 0] addrb
  .doutb(dout_q0)  // output wire [127 : 0] doutb
); 
BRAM_128X512 Q1_BUFFER (
  .clka(clk),    // input wire clka
  .ena(bram_en_wr),      // input wire ena
  .wea(ram_wr_sel[1]),      // input wire [0 : 0] wea
  .addra(addr_wr),  // input wire [8 : 0] addra
  .dina(dout_cnn1_q),    // input wire [127 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(rd_en),      // input wire enb
  .addrb(addr_rd_q),  // input wire [8 : 0] addrb
  .doutb(dout_q1)  // output wire [127 : 0] doutb
); 

BRAM_128X512 Q2_BUFFER (
  .clka(clk),    // input wire clka
  .ena(bram_en_wr),      // input wire ena
  .wea(ram_wr_sel[2]),      // input wire [0 : 0] wea
  .addra(addr_wr),  // input wire [8 : 0] addra
  .dina(dout_cnn1_q),    // input wire [127 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(rd_en),      // input wire enb
  .addrb(addr_rd_q),  // input wire [8 : 0] addrb
  .doutb(dout_q2)  // output wire [127 : 0] doutb
); 


// cnn2 weights buffer, size = (2,3) 
BRAM_CNN2_W0 W00_BUFFER (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_weight),  // input wire [8 : 0] addra
  .douta(w00)  // output wire [127 : 0] douta     16bit*8 =128
);
BRAM_CNN2_W1 W01_BUFFER (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_weight),  // input wire [8 : 0] addra
  .douta(w01)  // output wire [127 : 0] douta
);
BRAM_CNN2_W2 W02_BUFFER (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_weight),  // input wire [8 : 0] addra
  .douta(w02)  // output wire [127 : 0] douta
);
BRAM_CNN2_W3 W10_BUFFER (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_weight),  // input wire [8 : 0] addra
  .douta(w10)  // output wire [127 : 0] douta
);
BRAM_CNN2_W4 W11_BUFFER (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_weight),  // input wire [8 : 0] addra
  .douta(w11)  // output wire [127 : 0] douta
);
BRAM_CNN2_W5 W12_BUFFER (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_weight),  // input wire [8 : 0] addra
  .douta(w12)  // output wire [127 : 0] douta
);


BRAM_CNN2_BIAS BIAS_BUFFER (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_bias),  // input wire [4 : 0] addra
  .douta(cnn2_bias)  // output wire [23 : 0] douta
);



/*
genvar c;
generate 
	for (c = 0;c < 32; c = c + 1)
	begin :relu_conv2
		assign conv2_map_out[c*16+15:c*16] = sum10[c*17+16]?16'b0:sum10[c*17+16-:16];
	end
endgenerate
*/
//assign conv2_map_ready = conv2_map_ready_tmp;


endmodule
