`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 11:50:42
// Design Name: 
// Module Name: tanh
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

//  ax+b

//
//1)a*x+b    四十段均分段
//2)输入数据18位，输出数据18位，中间变量18位；  参数ab 量化 1bit符号位,0bit整数位，17bit小数位
//												tanh_in 量化 (1,5,12)   
//												tanh_out 量化 (1,0,17)  
//3)pipline = 5

module tanh (
    input clk,
    input [17:0] tanh_in,  // (1,5,12)
    output [17:0] tanh_out//(1,0,17)  
    );
    
parameter WL=18 ;
reg [WL-1:0] add_in_reg = 0;
reg [WL-1:0] tanh_in_reg = 0;
reg [WL-1:0] tanh_in_reg1 = 0;
reg [WL-1:0] add_in = 0;
reg [WL-1:0] mult_in = 0;
wire [2*WL-1:0] mult_out;
wire [WL-1:0] mult_out_reg;

reg [WL-1:0]  a0=18'h000D8,  a1=18'h00142,  a2=18'h001E0,  a3=18'h002CC,  a4=18'h0042B,  a5=18'h00634, a6=18'h0093A, a7=18'h00DB4, a8=18'h0144E, a9=18'h01DFE;
reg [WL-1:0] a10=18'h02C16, a11=18'h0405A, a12=18'h05CF8, a13=18'h08458, a14=18'h0B879, a15=18'h0F9BF,a16=18'h14516,a17=18'h1922D,a18=18'h1D363,a19=18'h1F947;
reg [WL-1:0] a20=18'h1F947, a21=18'h1D363, a22=18'h1922D, a23=18'h14516, a24=18'h0F9BF, a25=18'h0B879,a26=18'h08458,a27=18'h05CF8,a28=18'h0405A,a29=18'h02C16;
reg [WL-1:0] a30=18'h01DFE, a31=18'h0144E, a32=18'h00DB4, a33=18'h0093A, a34=18'h00634, a35=18'h0042B,a36=18'h002CC,a37=18'h001E0,a38=18'h00142,a39=18'h000D8;
reg [WL-1:0]  b0=18'h203B9,  b1=18'h2054D,  b2=18'h20786,  b3=18'h20AA7,  b4=18'h20F09,  b5=18'h21525, b6=18'h21D9C, b7=18'h22940, b8=18'h23918, b9=18'h24E68;
reg [WL-1:0] b10=18'h26A98, b11=18'h28F12, b12=18'h2BCDD, b13=18'h2F3FC, b14=18'h3328A, b15=18'h373D0,b16=18'h3B015,b17=18'h3DE56,b18=18'h3F86C,b19=18'h00000;
reg [WL-1:0] b20=18'h00000, b21=18'h00794, b22=18'h021AA, b23=18'h04FEB, b24=18'h08C30, b25=18'h0CD76,b26=18'h10C04,b27=18'h14323,b28=18'h170EE,b29=18'h19568;
reg [WL-1:0] b30=18'h1B198, b31=18'h1C6E8, b32=18'h1D6C0, b33=18'h1E264, b34=18'h1EADB, b35=18'h1F0F7,b36=18'h1F559,b37=18'h1F87A,b38=18'h1FAB3,b39=18'h1FC47;
reg flag0    = 0;       reg flag20   = 0;
reg flag1    = 0;       reg flag21   = 0;
reg flag2    = 0;       reg flag22   = 0;
reg flag3    = 0;       reg flag23   = 0;
reg flag4    = 0;       reg flag24   = 0;
reg flag5    = 0;       reg flag25   = 0;
reg flag6    = 0;       reg flag26   = 0;
reg flag7    = 0;       reg flag27   = 0;
reg flag8    = 0;       reg flag28   = 0;
reg flag9    = 0;       reg flag29   = 0;
reg flag10   = 0;       reg flag30   = 0;
reg flag11   = 0;       reg flag31   = 0;
reg flag12   = 0;       reg flag32   = 0;
reg flag13   = 0;       reg flag33   = 0;
reg flag14   = 0;       reg flag34   = 0;
reg flag15   = 0;       reg flag35   = 0;
reg flag16   = 0;       reg flag36   = 0;
reg flag17   = 0;       reg flag37   = 0;
reg flag18   = 0;       reg flag38   = 0;
reg flag19   = 0;       reg flag39   = 0;
wire [19:0] flag_n,flag_p;  // negetive positive
assign flag_n = {flag0,flag1,flag2,flag3,flag4,flag5,flag6 ,flag7 ,flag8 ,flag9 ,
				flag10,flag11,flag12,flag13,flag14,flag15,flag16,flag17,flag18,flag19};
assign flag_p = {flag20,flag21,flag22,flag23,flag24,flag25,flag26,flag27,flag28,flag29,
				flag30,flag31,flag32,flag33,flag34,flag35,flag36,flag37,flag38,flag39};
reg [17:0] mult_in1 = 0;
reg [17:0] mult_in2 = 0;
reg [17:0] add_in1  = 0;
reg [17:0] add_in2  = 0;
reg pn_flag = 0;
always @(posedge clk) begin
    {tanh_in_reg,tanh_in_reg1} <={tanh_in_reg1,tanh_in};
	add_in_reg <= add_in;  
	pn_flag <= tanh_in[17] ;
    if(tanh_in[17] == 1) begin
        if(tanh_in >= 18'd245760) begin
			flag0 <= 1;
        end
		else begin
			flag0 <= 0;
		end
        if(tanh_in >= 18'd246579) begin
			flag1 <= 1;
        end
		else begin
			flag1 <= 0;
		end
        if(tanh_in >= 18'd247399) begin
			flag2 <= 1;
        end
		else begin
			flag2 <= 0;
		end
        if(tanh_in >= 18'd248218) begin
			flag3 <= 1;
        end
		else begin
			flag3 <= 0;
		end
        if(tanh_in >= 18'd249037) begin
			flag4 <= 1;
        end
		else begin
			flag4 <= 0;
		end
        if(tanh_in >= 18'd249856) begin
			flag5 <= 1;
        end
		else begin
			flag5 <= 0;
		end
        if(tanh_in >= 18'd250675) begin
			flag6 <= 1;
        end
		else begin
			flag6 <= 0;
		end
        if(tanh_in >= 18'd251494) begin
			flag7 <= 1;
        end
		else begin
			flag7 <= 0;
		end
        if(tanh_in >= 18'd252314) begin
			flag8 <= 1;
        end
		else begin
			flag8 <= 0;
		end
        if(tanh_in >= 18'd253133) begin
			flag9 <= 1;
        end
		else begin
			flag9 <= 0;
		end
        if(tanh_in >= 18'd253952) begin
			flag10 <= 1;
        end
		else begin
			flag10 <= 0;
		end
        if(tanh_in >= 18'd254771) begin
			flag11 <= 1;
        end
		else begin
			flag11 <= 0;
		end
        if(tanh_in >= 18'd255590) begin
			flag12 <= 1;
        end
		else begin
			flag12 <= 0;
		end
        if(tanh_in >= 18'd256410) begin
			flag13 <= 1;
        end
		else begin
			flag13 <= 0;
		end
        if(tanh_in >= 18'd257229) begin
			flag14 <= 1;
        end
		else begin
			flag14 <= 0;
		end
        if(tanh_in >= 18'd258048) begin
			flag15 <= 1;
        end
		else begin
			flag15 <= 0;
		end
        if(tanh_in >= 18'd258867) begin
			flag16 <= 1;
        end
		else begin
			flag16 <= 0;
		end
        if(tanh_in >= 18'd259686) begin
			flag17 <= 1;
        end
		else begin
			flag17 <= 0;
		end
        if(tanh_in >= 18'd260506) begin
			flag18 <= 1;
        end
		else begin
			flag18 <= 0;
		end
        if(tanh_in >= 18'd261325) begin
			flag19 <= 1;
        end
		else begin
			flag19 <= 0;
		end	
    end
    else begin
        if(tanh_in >= 18'd819) begin
			flag20 <= 1;
        end
		else begin
			flag20 <= 0;
		end
		if(tanh_in >= 18'd1638 ) begin
			flag21 <= 1;
        end
		else begin
			flag21 <= 0;
		end
        if(tanh_in >= 18'd2458) begin
			flag22 <= 1;
        end
		else begin
			flag22 <= 0;
		end
		if(tanh_in >= 18'd3277 ) begin
			flag23 <= 1;
        end
		else begin
			flag23 <= 0;
		end
        if(tanh_in >= 18'd4096 )begin
			flag24 <= 1;
        end
		else begin
			flag24 <= 0;
		end
		if(tanh_in >= 18'd4915 ) begin
			flag25 <= 1;
        end
		else begin
			flag25 <= 0;
		end
        if(tanh_in >= 18'd5734 )begin
			flag26 <= 1;
        end
		else begin
			flag26 <= 0;
		end
		if(tanh_in >= 18'd6554 ) begin
			flag27 <= 1;
        end
		else begin
			flag27 <= 0;
		end
        if(tanh_in >= 18'd7373 )begin
			flag28 <= 1;
        end
		else begin
			flag28 <= 0;
		end
		if(tanh_in >= 18'd8192 ) begin
			flag29 <= 1;
        end
		else begin
			flag29 <= 0;
		end
        if(tanh_in >= 18'd9011 )begin
			flag30 <= 1;
        end
		else begin
			flag30 <= 0;
		end
		
		if(tanh_in >= 18'd9830 ) begin
			flag31 <= 1;
        end
		else begin
			flag31 <= 0;
		end
        if(tanh_in >= 18'd10650 )begin
			flag32 <= 1;
        end
		else begin
			flag32 <= 0;
		end
		
		if(tanh_in >= 18'd11469 ) begin
			flag33 <= 1;
        end
		else begin
			flag33 <= 0;
		end
        if(tanh_in >= 18'd12288 )begin
			flag34 <= 1;
        end
		else begin
			flag34 <= 0;
		end
		if(tanh_in >= 18'd13107 ) begin
			flag35 <= 1;
        end
		else begin
			flag35 <= 0;
		end
        if(tanh_in >= 18'd13926 )begin
			flag36 <= 1;
        end
		else begin
			flag36 <= 0;
		end
	    if(tanh_in >= 18'd14745 ) begin
			flag37 <= 1;
        end
		else begin
			flag37 <= 0;
		end
        if(tanh_in >= 18'd15565 )begin
			flag38 <= 1;
        end
		else begin
			flag38 <= 0;
		end
		if(tanh_in >= 18'd16384 )begin
			flag39 <= 1;
        end
		else begin
			flag39 <= 0;
		end
    end
end

always @(posedge clk) begin
    if(pn_flag)  //  -
	begin
		case(flag_n)
		20'b0000_0000_0000_0000_0000:begin mult_in <= 18'd0; add_in <= 18'h20001;end
		20'b1000_0000_0000_0000_0000:begin mult_in <= a0 ; add_in <= b0 ;end
		20'b1100_0000_0000_0000_0000:begin mult_in <= a1 ; add_in <= b1 ;end
		20'b1110_0000_0000_0000_0000:begin mult_in <= a2 ; add_in <= b2 ;end
		20'b1111_0000_0000_0000_0000:begin mult_in <= a3 ; add_in <= b3 ;end
		20'b1111_1000_0000_0000_0000:begin mult_in <= a4 ; add_in <= b4 ;end
		20'b1111_1100_0000_0000_0000:begin mult_in <= a5 ; add_in <= b5 ;end
		20'b1111_1110_0000_0000_0000:begin mult_in <= a6 ; add_in <= b6 ;end
		20'b1111_1111_0000_0000_0000:begin mult_in <= a7 ; add_in <= b7 ;end
		20'b1111_1111_1000_0000_0000:begin mult_in <= a8 ; add_in <= b8 ;end
		20'b1111_1111_1100_0000_0000:begin mult_in <= a9 ; add_in <= b9 ;end
		20'b1111_1111_1110_0000_0000:begin mult_in <= a10; add_in <= b10;end
		20'b1111_1111_1111_0000_0000:begin mult_in <= a11; add_in <= b11;end
		20'b1111_1111_1111_1000_0000:begin mult_in <= a12; add_in <= b12;end
		20'b1111_1111_1111_1100_0000:begin mult_in <= a13; add_in <= b13;end
		20'b1111_1111_1111_1110_0000:begin mult_in <= a14; add_in <= b14;end
		20'b1111_1111_1111_1111_0000:begin mult_in <= a15; add_in <= b15;end
		20'b1111_1111_1111_1111_1000:begin mult_in <= a16; add_in <= b16;end
		20'b1111_1111_1111_1111_1100:begin mult_in <= a17; add_in <= b17;end
		20'b1111_1111_1111_1111_1110:begin mult_in <= a18; add_in <= b18;end
		20'b1111_1111_1111_1111_1111:begin mult_in <= a19; add_in <= b19;end
		default : begin  mult_in <= 18'b0; add_in <= 18'b0; end
		endcase
	end
	else  // +
	begin
		case(flag_p)
		20'b0000_0000_0000_0000_0000:begin mult_in <= a20; add_in <= b20;end
		20'b1000_0000_0000_0000_0000:begin mult_in <= a21; add_in <= b21;end
		20'b1100_0000_0000_0000_0000:begin mult_in <= a22; add_in <= b22;end
		20'b1110_0000_0000_0000_0000:begin mult_in <= a23; add_in <= b23;end
		20'b1111_0000_0000_0000_0000:begin mult_in <= a24; add_in <= b24;end
		20'b1111_1000_0000_0000_0000:begin mult_in <= a25; add_in <= b25;end
		20'b1111_1100_0000_0000_0000:begin mult_in <= a26; add_in <= b26;end
		20'b1111_1110_0000_0000_0000:begin mult_in <= a27; add_in <= b27;end
		20'b1111_1111_0000_0000_0000:begin mult_in <= a28; add_in <= b28;end
		20'b1111_1111_1000_0000_0000:begin mult_in <= a29; add_in <= b29;end
		20'b1111_1111_1100_0000_0000:begin mult_in <= a30; add_in <= b30;end
		20'b1111_1111_1110_0000_0000:begin mult_in <= a31; add_in <= b31;end
		20'b1111_1111_1111_0000_0000:begin mult_in <= a32; add_in <= b32;end
		20'b1111_1111_1111_1000_0000:begin mult_in <= a33; add_in <= b33;end
		20'b1111_1111_1111_1100_0000:begin mult_in <= a34; add_in <= b34;end
		20'b1111_1111_1111_1110_0000:begin mult_in <= a35; add_in <= b35;end
		20'b1111_1111_1111_1111_0000:begin mult_in <= a36; add_in <= b36;end
		20'b1111_1111_1111_1111_1000:begin mult_in <= a37; add_in <= b37;end
		20'b1111_1111_1111_1111_1100:begin mult_in <= a38; add_in <= b38;end
		20'b1111_1111_1111_1111_1110:begin mult_in <= a39; add_in <= b39;end
		20'b1111_1111_1111_1111_1111:begin mult_in <= 18'd0;add_in <=18'h1ffff;end
		default : begin  mult_in <= 18'b0; add_in <= 18'b0; end
		endcase	
	end
end
assign mult_out_reg = {mult_out[34], mult_out[28:12]};
wire [18:0] tanh_out_reg;
assign tanh_out = {tanh_out_reg[18],tanh_out_reg[16:0]};

MULT_18X18 AX (
  .CLK(clk),  // input wire CLK
  .A(mult_in),      // input wire [17 : 0] A
  .B(tanh_in_reg),      // input wire [17 : 0] B
  .P(mult_out)      // output wire [35 : 0] P    (1,0,17)*(1,5,12) =(2,5,29)
);


ADDER_18_18_19 PLUSB (
  .A(add_in_reg),      // input wire [17 : 0] A
  .B(mult_out_reg),      // input wire [17 : 0] B
  .CLK(clk),  // input wire CLK
  .CE(1'b1),
  .S(tanh_out_reg)      // output wire [18 : 0] S
);

endmodule
