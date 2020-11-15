`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/14 14:55:19
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



//1)输入数据18位，输出数据18位，中间变量18位；  参数ab 量化：1bit符号位,3bit整数位,14bit小数位
//2)a*x+b    四十段均匀分段
//3)pipline = 2

module tanh (
    input clk,
    input [17:0] tanh_in,
    output [17:0] tanh_out
    );
    
parameter WL=18 ;
reg [WL-1:0] add_in_reg = 0;
reg [WL-1:0] tanh_in_reg = 0;
reg [WL-1:0] tanh_in_reg1 = 0;
reg [WL-1:0] add_in = 0;
reg [WL-1:0] mult_in = 0;
wire [2*WL-1:0] mult_out;
wire [WL-1:0] mult_out_reg;

reg [WL-1:0]  a0=18'h001B,  a1=18'h0028,  a2=18'h003C,  a3=18'h0059,  a4=18'h0085,  a5=18'h00C7, a6=18'h0127, a7=18'h01B6, a8=18'h028A, a9=18'h03C0;
reg [WL-1:0] a10=18'h0583, a11=18'h080B, a12=18'h0B9F, a13=18'h108B, a14=18'h170F, a15=18'h1F38,a16=18'h28A3,a17=18'h3246,a18=18'h3A6C,a19=18'h3F29;
reg [WL-1:0] a20=18'h3F29, a21=18'h3A6C, a22=18'h3246, a23=18'h28A3, a24=18'h1F38, a25=18'h170F,a26=18'h108B,a27=18'h0B9F,a28=18'h080B,a29=18'h0583;
reg [WL-1:0] a30=18'h03C0, a31=18'h028A, a32=18'h01B6, a33=18'h0127, a34=18'h00C7, a35=18'h0085,a36=18'h0059,a37=18'h003C,a38=18'h0028,a39=18'h001B;
reg [WL-1:0]  b0=18'h3C077,  b1=18'h3C0AA,  b2=18'h3C0F1,  b3=18'h3C155,  b4=18'h3C1E1,  b5=18'h3C2A5, b6=18'h3C3B4, b7=18'h3C528, b8=18'h3C723, b9=18'h3C9CD;
reg [WL-1:0] b10=18'h3CD53, b11=18'h3D1E2, b12=18'h3D79C, b13=18'h3DE7F, b14=18'h3E651, b15=18'h3EE7A,b16=18'h3F603,b17=18'h3FBCB,b18=18'h3FF0D,b19=18'h00000;
reg [WL-1:0] b20=18'h00000, b21=18'h000F3, b22=18'h00435, b23=18'h009FD, b24=18'h01186, b25=18'h019AF,b26=18'h02181,b27=18'h02864,b28=18'h02E1E,b29=18'h032AD;
reg [WL-1:0] b30=18'h03633, b31=18'h038DD, b32=18'h03AD8, b33=18'h03C4C, b34=18'h03D5B, b35=18'h03E1F,b36=18'h03EAB,b37=18'h03F0F,b38=18'h03F56,b39=18'h03F89;
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
        if(tanh_in >= 18'd196608) begin
			flag0 <= 1;
        end
		else begin
			flag0 <= 0;
		end
        if(tanh_in >= 18'd199885) begin
			flag1 <= 1;
        end
		else begin
			flag1 <= 0;
		end
        if(tanh_in >= 18'd203162) begin
			flag2 <= 1;
        end
		else begin
			flag2 <= 0;
		end
        if(tanh_in >= 18'd206439) begin
			flag3 <= 1;
        end
		else begin
			flag3 <= 0;
		end
        if(tanh_in >= 18'd209716) begin
			flag4 <= 1;
        end
		else begin
			flag4 <= 0;
		end
        if(tanh_in >= 18'd212992) begin
			flag5 <= 1;
        end
		else begin
			flag5 <= 0;
		end
        if(tanh_in >= 18'd216269) begin
			flag6 <= 1;
        end
		else begin
			flag6 <= 0;
		end
        if(tanh_in >= 18'd219546) begin
			flag7 <= 1;
        end
		else begin
			flag7 <= 0;
		end
        if(tanh_in >= 18'd222823) begin
			flag8 <= 1;
        end
		else begin
			flag8 <= 0;
		end
        if(tanh_in >= 18'd226099) begin
			flag9 <= 1;
        end
		else begin
			flag9 <= 0;
		end
        if(tanh_in >= 18'd229376) begin
			flag10 <= 1;
        end
		else begin
			flag10 <= 0;
		end
        if(tanh_in >= 18'd232653) begin
			flag11 <= 1;
        end
		else begin
			flag11 <= 0;
		end
        if(tanh_in >= 18'd235930) begin
			flag12 <= 1;
        end
		else begin
			flag12 <= 0;
		end
        if(tanh_in >= 18'd239207) begin
			flag13 <= 1;
        end
		else begin
			flag13 <= 0;
		end
        if(tanh_in >= 18'd242483) begin
			flag14 <= 1;
        end
		else begin
			flag14 <= 0;
		end
        if(tanh_in >= 18'd245760) begin
			flag15 <= 1;
        end
		else begin
			flag15 <= 0;
		end
        if(tanh_in >= 18'd249037) begin
			flag16 <= 1;
        end
		else begin
			flag16 <= 0;
		end
        if(tanh_in >= 18'd252314) begin
			flag17 <= 1;
        end
		else begin
			flag17 <= 0;
		end
        if(tanh_in >= 18'd255590) begin
			flag18 <= 1;
        end
		else begin
			flag18 <= 0;
		end
        if(tanh_in >= 18'd258867) begin
			flag19 <= 1;
        end
		else begin
			flag19 <= 0;
		end	
    end
    else begin
        if(tanh_in >= 18'd3277 begin
			flag20 <= 1;
        end
		else begin
			flag20 <= 0;
		end
		if(tanh_in >= 18'd6554 ) begin
			flag21 <= 1;
        end
		else begin
			flag21 <= 0;
		end
        if(tanh_in >= 18'd9830 begin
			flag22 <= 1;
        end
		else begin
			flag22 <= 0;
		end
		if(tanh_in >= 18'd13107 ) begin
			flag23 <= 1;
        end
		else begin
			flag23 <= 0;
		end
        if(tanh_in >= 18'd16384 begin
			flag24 <= 1;
        end
		else begin
			flag24 <= 0;
		end
		if(tanh_in >= 18'd19661 ) begin
			flag25 <= 1;
        end
		else begin
			flag25 <= 0;
		end
        if(tanh_in >= 18'd22937 begin
			flag26 <= 1;
        end
		else begin
			flag26 <= 0;
		end
		if(tanh_in >= 18'd26214 ) begin
			flag27 <= 1;
        end
		else begin
			flag27 <= 0;
		end
        if(tanh_in >= 18'd29491 begin
			flag28 <= 1;
        end
		else begin
			flag28 <= 0;
		end
		if(tanh_in >= 18'd32768 ) begin
			flag29 <= 1;
        end
		else begin
			flag29 <= 0;
		end
        if(tanh_in >= 18'd36045 begin
			flag30 <= 1;
        end
		else begin
			flag30 <= 0;
		end
		
		if(tanh_in >= 18'd39321 ) begin
			flag31 <= 1;
        end
		else begin
			flag31 <= 0;
		end
        if(tanh_in >= 18'd42598 begin
			flag32 <= 1;
        end
		else begin
			flag32 <= 0;
		end
		
		if(tanh_in >= 18'd45875 ) begin
			flag33 <= 1;
        end
		else begin
			flag33 <= 0;
		end
        if(tanh_in >= 18'd49152 begin
			flag34 <= 1;
        end
		else begin
			flag34 <= 0;
		end
		if(tanh_in >= 18'd52428 ) begin
			flag35 <= 1;
        end
		else begin
			flag35 <= 0;
		end
        if(tanh_in >= 18'd55705 begin
			flag36 <= 1;
        end
		else begin
			flag36 <= 0;
		end
	    if(tanh_in >= 18'd58982 ) begin
			flag37 <= 1;
        end
		else begin
			flag37 <= 0;
		end
        if(tanh_in >= 18'd62259 begin
			flag38 <= 1;
        end
		else begin
			flag38 <= 0;
		end
		if(tanh_in >= 18'd62259 begin
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
		20'b0000_0000_0000_0000_0000:begin mult_in <= 18'd0; add_in <= 18'd245772;end
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
		20'b1111_1111_1111_1111_1111:begin mult_in <= 18'd0;add_in <=18'd16372;end
		default : begin  mult_in <= 18'b0; add_in <= 18'b0; end
		endcase	
	end
end
assign mult_out_reg = {mult_out[34], mult_out[30:14]};

MULT_18X18 AX (
  .CLK(clk),  // input wire CLK
  .A(mult_in),      // input wire [17 : 0] A
  .B(tanh_in_reg),      // input wire [17 : 0] B
  .P(mult_out)      // output wire [35 : 0] P
);    

c_addsub_0 PLUSB (
  .A(add_in_reg),      // input wire [17 : 0] A
  .B(mult_out_reg),      // input wire [17 : 0] B
  .CLK(clk),  // input wire CLK
  .S(tanh_out)      // output wire [17 : 0] S
);

endmodule
