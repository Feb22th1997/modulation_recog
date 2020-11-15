`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/15 09:57:28
// Design Name: 
// Module Name: CNNLayer_1_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:   µÚÒ»²ã¾í»ý²ã 1*8*2*16
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CONV1(
input  					clk,
input  					rst_n,
input 	[15:0]			din_i,       //  2*128*1   (sign_bitsnum,int_bitsnum, decimal_bitsnum)=(1,0,15)
input 	[15:0] 			din_q,
input  					din_valid,	//ÔÚ128¸öÊý¾ÝÆÚ¼äÒ»Ö±À­¸ß
//output					din_ready, 
//output [16*128-1 : 0]  	conv1_mapout_i,
//output [16*128-1 : 0]  	conv1_mapout_q,  // 2*130*128 
output					map_valid,
output	[16*8-1:0]		output_I,
output	[16*8-1:0]		output_Q
    );
	
	

	
//ÊäÈëÊý¾Ý¸ñÊ½ 16Î»  1 0 15   1Î»·ûºÅÎ» 0Î»ÕûÊýÎ» 15Î»Ð¡ÊýÎ»	
//È¨ÖØÊý¾Ý¸ñÊ½ 16Î»  1 1 14 

//pading size = 7,left = 7/2= 3,right = 7-3=4;


wire	[15:0]	w0 [0:127]  ; // 128¸ö 16Î»
wire	[15:0]	w1 [0:127]  ;
wire	[15:0]	w2 [0:127]  ;
wire	[15:0]	w_bias[0:127] ; 

assign w0[0  ] = 16'b1111101100000001; // È¨ÖØÊý¾Ý¸ñÊ½ 1 1 14
assign w0[1  ] = 16'b1100111100010000;
assign w0[2  ] = 16'b1110010110111101;
assign w0[3  ] = 16'b1100111010001100;
assign w0[4  ] = 16'b1101000001101001;
assign w0[5  ] = 16'b0011010000011001;
assign w0[6  ] = 16'b0000000101011100;
assign w0[7  ] = 16'b1111110100110000;
assign w0[8  ] = 16'b0001100011100011;
assign w0[9  ] = 16'b1111110011010110;
assign w0[10 ] = 16'b1101110001111001;
assign w0[11 ] = 16'b0010011111110011;
assign w0[12 ] = 16'b0010110010001010;
assign w0[13 ] = 16'b0010010010000101;
assign w0[14 ] = 16'b0010010010100111;
assign w0[15 ] = 16'b1101011100101011;
assign w0[16 ] = 16'b0010101000110011;
assign w0[17 ] = 16'b1111110011011011;
assign w0[18 ] = 16'b0000010110100011;
assign w0[19 ] = 16'b0011100110001100;
assign w0[20 ] = 16'b0000001011011011;
assign w0[21 ] = 16'b0010000010110000;
assign w0[22 ] = 16'b0011100101001111;
assign w0[23 ] = 16'b1111100110111111;
assign w0[24 ] = 16'b0000010000001101;
assign w0[25 ] = 16'b0010001110111010;
assign w0[26 ] = 16'b0010100101010001;
assign w0[27 ] = 16'b0010011111010111;
assign w0[28 ] = 16'b0000001011010000;
assign w0[29 ] = 16'b1111101010000001;
assign w0[30 ] = 16'b0011100001010000;
assign w0[31 ] = 16'b0011010100101101;
assign w0[32 ] = 16'b0000000101010000;
assign w0[33 ] = 16'b1101001010110011;
assign w0[34 ] = 16'b1101011011101101;
assign w0[35 ] = 16'b0000000110011000;
assign w0[36 ] = 16'b1101010111100001;
assign w0[37 ] = 16'b0010100000011111;
assign w0[38 ] = 16'b0010011100100101;
assign w0[39 ] = 16'b1101000010101000;
assign w0[40 ] = 16'b0010001001001000;
assign w0[41 ] = 16'b0011001100011101;
assign w0[42 ] = 16'b1100110101101010;
assign w0[43 ] = 16'b1101010110111100;
assign w0[44 ] = 16'b0010011110011111;
assign w0[45 ] = 16'b0001111101011011;
assign w0[46 ] = 16'b1011111110011010;
assign w0[47 ] = 16'b0001111111011101;
assign w0[48 ] = 16'b1101110110100011;
assign w0[49 ] = 16'b0001001010101010;
assign w0[50 ] = 16'b1111111011111111;
assign w0[51 ] = 16'b0011011110000010;
assign w0[52 ] = 16'b1100111111011100;
assign w0[53 ] = 16'b0010110010000110;
assign w0[54 ] = 16'b0001011010100011;
assign w0[55 ] = 16'b1100011100101111;
assign w0[56 ] = 16'b0000010000111001;
assign w0[57 ] = 16'b0001001101011111;
assign w0[58 ] = 16'b0010111010110111;
assign w0[59 ] = 16'b0011110000100001;
assign w0[60 ] = 16'b1111111110110110;
assign w0[61 ] = 16'b0000101010101101;
assign w0[62 ] = 16'b0011101001101001;
assign w0[63 ] = 16'b1111110100110010;
assign w0[64 ] = 16'b1111111000111101;
assign w0[65 ] = 16'b0000000101111111;
assign w0[66 ] = 16'b1100010110110110;
assign w0[67 ] = 16'b0001111101101011;
assign w0[68 ] = 16'b0000001000110111;
assign w0[69 ] = 16'b0010011000110010;
assign w0[70 ] = 16'b0010110000100111;
assign w0[71 ] = 16'b0001101010111011;
assign w0[72 ] = 16'b1101101011101000;
assign w0[73 ] = 16'b0010001011110100;
assign w0[74 ] = 16'b0011100110000101;
assign w0[75 ] = 16'b1111100101000100;
assign w0[76 ] = 16'b0010100110111011;
assign w0[77 ] = 16'b1111101001100010;
assign w0[78 ] = 16'b0000010111110101;
assign w0[79 ] = 16'b0001101011001000;
assign w0[80 ] = 16'b0001110110010011;
assign w0[81 ] = 16'b0010101100010010;
assign w0[82 ] = 16'b1100101000010001;
assign w0[83 ] = 16'b1100001011110001;
assign w0[84 ] = 16'b1111111101100100;
assign w0[85 ] = 16'b0001110011011101;
assign w0[86 ] = 16'b1111110100101100;
assign w0[87 ] = 16'b0000010100011110;
assign w0[88 ] = 16'b1100101001100000;
assign w0[89 ] = 16'b0010110000010100;
assign w0[90 ] = 16'b0010110000010000;
assign w0[91 ] = 16'b0000000100010001;
assign w0[92 ] = 16'b1101111100110001;
assign w0[93 ] = 16'b1101001010011010;
assign w0[94 ] = 16'b1100001101010100;
assign w0[95 ] = 16'b0010101000011101;
assign w0[96 ] = 16'b1111010111101011;
assign w0[97 ] = 16'b1100111111101100;
assign w0[98 ] = 16'b0000000000000111;
assign w0[99 ] = 16'b0000001110011001;
assign w0[100] = 16'b1101000011111101;
assign w0[101] = 16'b0010011101101111;
assign w0[102] = 16'b0010010001000000;
assign w0[103] = 16'b0001010011011101;
assign w0[104] = 16'b1111111101000011;
assign w0[105] = 16'b0000001110000000;
assign w0[106] = 16'b1110010001111010;
assign w0[107] = 16'b1111101110010110;
assign w0[108] = 16'b0000001011110011;
assign w0[109] = 16'b1111111010001111;
assign w0[110] = 16'b1100111101011110;
assign w0[111] = 16'b1101010001000100;
assign w0[112] = 16'b0000010100111111;
assign w0[113] = 16'b0010001110000011;
assign w0[114] = 16'b1100101000001000;
assign w0[115] = 16'b1111111110110010;
assign w0[116] = 16'b1111101111000110;
assign w0[117] = 16'b0010110000110100;
assign w0[118] = 16'b0001100000101001;
assign w0[119] = 16'b1101100000101110;
assign w0[120] = 16'b0010011001110111;
assign w0[121] = 16'b1110011001001110;
assign w0[122] = 16'b0000010101010011;
assign w0[123] = 16'b1101000011111011;
assign w0[124] = 16'b0101111001110001;
assign w0[125] = 16'b0010101100000010;
assign w0[126] = 16'b1111111101000100;
assign w0[127] = 16'b1101001100010100;
assign w1[0  ] = 16'b1111110101011101;
assign w1[1  ] = 16'b1101100110011111;
assign w1[2  ] = 16'b1110111110110011;
assign w1[3  ] = 16'b1110010111101000;
assign w1[4  ] = 16'b1110101010010010;
assign w1[5  ] = 16'b0011000100011100;
assign w1[6  ] = 16'b1111111010110111;
assign w1[7  ] = 16'b0000011101000100;
assign w1[8  ] = 16'b0001100011001100;
assign w1[9  ] = 16'b0000001011011110;
assign w1[10 ] = 16'b1110010110100000;
assign w1[11 ] = 16'b0010110011110101;
assign w1[12 ] = 16'b0001000100010000;
assign w1[13 ] = 16'b0001011010010010;
assign w1[14 ] = 16'b0010000001111111;
assign w1[15 ] = 16'b1101111110000000;
assign w1[16 ] = 16'b0001010101001000;
assign w1[17 ] = 16'b0000001000111000;
assign w1[18 ] = 16'b1111011101111111;
assign w1[19 ] = 16'b0010110101010110;
assign w1[20 ] = 16'b1111101011011010;
assign w1[21 ] = 16'b0010001011101011;
assign w1[22 ] = 16'b0010111010011010;
assign w1[23 ] = 16'b1111100011000000;
assign w1[24 ] = 16'b1111111111110010;
assign w1[25 ] = 16'b0001101011000000;
assign w1[26 ] = 16'b0001111001001111;
assign w1[27 ] = 16'b0010010000000110;
assign w1[28 ] = 16'b0000001010001001;
assign w1[29 ] = 16'b0000000101001001;
assign w1[30 ] = 16'b0011000111011001;
assign w1[31 ] = 16'b0011000101110010;
assign w1[32 ] = 16'b1111111110101111;
assign w1[33 ] = 16'b1110101110111110;
assign w1[34 ] = 16'b1101111000000110;
assign w1[35 ] = 16'b0000010010001000;
assign w1[36 ] = 16'b1110000010001001;
assign w1[37 ] = 16'b0010111111000000;
assign w1[38 ] = 16'b0010010000110010;
assign w1[39 ] = 16'b1100110001110101;
assign w1[40 ] = 16'b0010100110100101;
assign w1[41 ] = 16'b0010010110100000;
assign w1[42 ] = 16'b1101100000010010;
assign w1[43 ] = 16'b1110000111011110;
assign w1[44 ] = 16'b0010000100111011;
assign w1[45 ] = 16'b0001010110001110;
assign w1[46 ] = 16'b1011111000011000;
assign w1[47 ] = 16'b0010010100101011;
assign w1[48 ] = 16'b1101111001001011;
assign w1[49 ] = 16'b0001001001011011;
assign w1[50 ] = 16'b1111110001101101;
assign w1[51 ] = 16'b0010111001000111;
assign w1[52 ] = 16'b1110000011000010;
assign w1[53 ] = 16'b0001111101110000;
assign w1[54 ] = 16'b0001010111100111;
assign w1[55 ] = 16'b1100011011010110;
assign w1[56 ] = 16'b1111110011101001;
assign w1[57 ] = 16'b0010001001111100;
assign w1[58 ] = 16'b0010100101010010;
assign w1[59 ] = 16'b0010011101011011;
assign w1[60 ] = 16'b1111111001000000;
assign w1[61 ] = 16'b0000110000110010;
assign w1[62 ] = 16'b0011000100000110;
assign w1[63 ] = 16'b0000000011101000;
assign w1[64 ] = 16'b0000001000011110;
assign w1[65 ] = 16'b1111101010010011;
assign w1[66 ] = 16'b1110101011101110;
assign w1[67 ] = 16'b0010100001001011;
assign w1[68 ] = 16'b1111101001101101;
assign w1[69 ] = 16'b0001110100010000;
assign w1[70 ] = 16'b0010000010010011;
assign w1[71 ] = 16'b0001011010001111;
assign w1[72 ] = 16'b1110001001110101;
assign w1[73 ] = 16'b0001111011000101;
assign w1[74 ] = 16'b0100000010010010;
assign w1[75 ] = 16'b1111101111100010;
assign w1[76 ] = 16'b0001011100010110;
assign w1[77 ] = 16'b0000001010101110;
assign w1[78 ] = 16'b0000110110011111;
assign w1[79 ] = 16'b0001111110100000;
assign w1[80 ] = 16'b0001111000101001;
assign w1[81 ] = 16'b0010001111011110;
assign w1[82 ] = 16'b1101010111011010;
assign w1[83 ] = 16'b1100100001010011;
assign w1[84 ] = 16'b0000000110011001;
assign w1[85 ] = 16'b0001101110111100;
assign w1[86 ] = 16'b1111111101101001;
assign w1[87 ] = 16'b1111110001011110;
assign w1[88 ] = 16'b1101001101000101;
assign w1[89 ] = 16'b0010010111111000;
assign w1[90 ] = 16'b0001100110001011;
assign w1[91 ] = 16'b0000000100100011;
assign w1[92 ] = 16'b1101110111001010;
assign w1[93 ] = 16'b1101101101101110;
assign w1[94 ] = 16'b1100110010001110;
assign w1[95 ] = 16'b0001101011110000;
assign w1[96 ] = 16'b1111101110100010;
assign w1[97 ] = 16'b1110000010110010;
assign w1[98 ] = 16'b0000001001010001;
assign w1[99 ] = 16'b1111101000101001;
assign w1[100] = 16'b1110010010100110;
assign w1[101] = 16'b0001110010011001;
assign w1[102] = 16'b0001111011100000;
assign w1[103] = 16'b0001101111111011;
assign w1[104] = 16'b0000001011111001;
assign w1[105] = 16'b1111111010100100;
assign w1[106] = 16'b1110011001111001;
assign w1[107] = 16'b0000011010010101;
assign w1[108] = 16'b1111100111100010;
assign w1[109] = 16'b1111111000110110;
assign w1[110] = 16'b1110010000110011;
assign w1[111] = 16'b1110011011110001;
assign w1[112] = 16'b1111110001010100;
assign w1[113] = 16'b0010000110000110;
assign w1[114] = 16'b1101110010100000;
assign w1[115] = 16'b1111110111100010;
assign w1[116] = 16'b0000000010110100;
assign w1[117] = 16'b0010101110101011;
assign w1[118] = 16'b0010001000100001;
assign w1[119] = 16'b1101110100101101;
assign w1[120] = 16'b0001101111001110;
assign w1[121] = 16'b1110101110100101;
assign w1[122] = 16'b0000000001001101;
assign w1[123] = 16'b1101111010000000;
assign w1[124] = 16'b1011000001101011;
assign w1[125] = 16'b0010100011100111;
assign w1[126] = 16'b0000000100110110;
assign w1[127] = 16'b1110011010101010;
assign w2[0  ] = 16'b0000001100010111;
assign w2[1  ] = 16'b1101111011011100;
assign w2[2  ] = 16'b1110100100101001;
assign w2[3  ] = 16'b1100011100001011;
assign w2[4  ] = 16'b1101010110001000;
assign w2[5  ] = 16'b0100010100010010;
assign w2[6  ] = 16'b0000000010011011;
assign w2[7  ] = 16'b0000000001110100;
assign w2[8  ] = 16'b0001100000000011;
assign w2[9  ] = 16'b0000000111111011;
assign w2[10 ] = 16'b1100101100100101;
assign w2[11 ] = 16'b0011010001111100;
assign w2[12 ] = 16'b0010111000010001;
assign w2[13 ] = 16'b0010111100000011;
assign w2[14 ] = 16'b0010011100110000;
assign w2[15 ] = 16'b1101011000101000;
assign w2[16 ] = 16'b0010101011100111;
assign w2[17 ] = 16'b0000001011010110;
assign w2[18 ] = 16'b1111101010100011;
assign w2[19 ] = 16'b0011101000101110;
assign w2[20 ] = 16'b0000010101110110;
assign w2[21 ] = 16'b0010101010010011;
assign w2[22 ] = 16'b0010011110001000;
assign w2[23 ] = 16'b0000001101011011;
assign w2[24 ] = 16'b1111110011101110;
assign w2[25 ] = 16'b0010101101111001;
assign w2[26 ] = 16'b0010101111011101;
assign w2[27 ] = 16'b0010011111100011;
assign w2[28 ] = 16'b1111100110101111;
assign w2[29 ] = 16'b0000011001110101;
assign w2[30 ] = 16'b0011101100010111;
assign w2[31 ] = 16'b0011100101001010;
assign w2[32 ] = 16'b1111110110011001;
assign w2[33 ] = 16'b1101010011100111;
assign w2[34 ] = 16'b1101110001001101;
assign w2[35 ] = 16'b0000000110011111;
assign w2[36 ] = 16'b1101000000010001;
assign w2[37 ] = 16'b0001111101101011;
assign w2[38 ] = 16'b0010100110000011;
assign w2[39 ] = 16'b1100001110011010;
assign w2[40 ] = 16'b0010011111011001;
assign w2[41 ] = 16'b0001100111011101;
assign w2[42 ] = 16'b1101001111010110;
assign w2[43 ] = 16'b1101001110001011;
assign w2[44 ] = 16'b0010110000010101;
assign w2[45 ] = 16'b0001100101011111;
assign w2[46 ] = 16'b1011011101111100;
assign w2[47 ] = 16'b0010111101000110;
assign w2[48 ] = 16'b1100111000011000;
assign w2[49 ] = 16'b0000100100010110;
assign w2[50 ] = 16'b0000011010110000;
assign w2[51 ] = 16'b0011011101011100;
assign w2[52 ] = 16'b1101110100010100;
assign w2[53 ] = 16'b0010001011110011;
assign w2[54 ] = 16'b0000111111000000;
assign w2[55 ] = 16'b1100000010111111;
assign w2[56 ] = 16'b1111101010110010;
assign w2[57 ] = 16'b0010001010101100;
assign w2[58 ] = 16'b0010111100011111;
assign w2[59 ] = 16'b0011100100011011;
assign w2[60 ] = 16'b1111110100101110;
assign w2[61 ] = 16'b0000100000110000;
assign w2[62 ] = 16'b0011111011110101;
assign w2[63 ] = 16'b1111111111111110;
assign w2[64 ] = 16'b1111101011111111;
assign w2[65 ] = 16'b0000000110010001;
assign w2[66 ] = 16'b1101110010011100;
assign w2[67 ] = 16'b0010111110101000;
assign w2[68 ] = 16'b0000001011000100;
assign w2[69 ] = 16'b0010011111101111;
assign w2[70 ] = 16'b0010010110111010;
assign w2[71 ] = 16'b0000111100010010;
assign w2[72 ] = 16'b1100110111000100;
assign w2[73 ] = 16'b0010100001110100;
assign w2[74 ] = 16'b0100011110011110;
assign w2[75 ] = 16'b0000011111001001;
assign w2[76 ] = 16'b0010101100101101;
assign w2[77 ] = 16'b1111110111011101;
assign w2[78 ] = 16'b0000000001100000;
assign w2[79 ] = 16'b0011000011001110;
assign w2[80 ] = 16'b0011000011011100;
assign w2[81 ] = 16'b0010100100111010;
assign w2[82 ] = 16'b1101010010111001;
assign w2[83 ] = 16'b1011101111101011;
assign w2[84 ] = 16'b0000000011111010;
assign w2[85 ] = 16'b0001100100000110;
assign w2[86 ] = 16'b0000000110000010;
assign w2[87 ] = 16'b0000010011110010;
assign w2[88 ] = 16'b1100110011111000;
assign w2[89 ] = 16'b0010111011111100;
assign w2[90 ] = 16'b0010100111111111;
assign w2[91 ] = 16'b0000000010100011;
assign w2[92 ] = 16'b1100110011110111;
assign w2[93 ] = 16'b1101110001111010;
assign w2[94 ] = 16'b1100111011011010;
assign w2[95 ] = 16'b0010100100001100;
assign w2[96 ] = 16'b0000010100010101;
assign w2[97 ] = 16'b1100111001101010;
assign w2[98 ] = 16'b0000001100101000;
assign w2[99 ] = 16'b0000000110111101;
assign w2[100] = 16'b1101011001110100;
assign w2[101] = 16'b0010100110010110;
assign w2[102] = 16'b0011010110001011;
assign w2[103] = 16'b0001110110100001;
assign w2[104] = 16'b0000001110010001;
assign w2[105] = 16'b0000000101001101;
assign w2[106] = 16'b1110000111111111;
assign w2[107] = 16'b1111101110100000;
assign w2[108] = 16'b0000100100110010;
assign w2[109] = 16'b0000000001110011;
assign w2[110] = 16'b1100111101011000;
assign w2[111] = 16'b1100110010111010;
assign w2[112] = 16'b1111100011101011;
assign w2[113] = 16'b0010101010011101;
assign w2[114] = 16'b1110001010111101;
assign w2[115] = 16'b0000010010001111;
assign w2[116] = 16'b0000010101100001;
assign w2[117] = 16'b0010011110111101;
assign w2[118] = 16'b0011011011100011;
assign w2[119] = 16'b1101000001111101;
assign w2[120] = 16'b0010110011001100;
assign w2[121] = 16'b0000010011000101;
assign w2[122] = 16'b0000001011011111;
assign w2[123] = 16'b1101010111011011;
assign w2[124] = 16'b1111010111101010;
assign w2[125] = 16'b0010100001000001;
assign w2[126] = 16'b1111111111010110;
assign w2[127] = 16'b1101001010110000;

assign w_bias[0  ] = 16'b1111111011000001;
assign w_bias[1  ] = 16'b0000000011011110;
assign w_bias[2  ] = 16'b1111111011010001;
assign w_bias[3  ] = 16'b0000000001100001;
assign w_bias[4  ] = 16'b0000000100000100;
assign w_bias[5  ] = 16'b0000000010110110;
assign w_bias[6  ] = 16'b1111111110011110;
assign w_bias[7  ] = 16'b1111111100010010;
assign w_bias[8  ] = 16'b1111111010110011;
assign w_bias[9  ] = 16'b1111111110010011;
assign w_bias[10 ] = 16'b0000000011101111;
assign w_bias[11 ] = 16'b0000000010000100;
assign w_bias[12 ] = 16'b0000000011101110;
assign w_bias[13 ] = 16'b0000000100001000;
assign w_bias[14 ] = 16'b0000000011001110;
assign w_bias[15 ] = 16'b0000000011100101;
assign w_bias[16 ] = 16'b0000000011110011;
assign w_bias[17 ] = 16'b1111111110000110;
assign w_bias[18 ] = 16'b1111110100010101;
assign w_bias[19 ] = 16'b1111111100110101;
assign w_bias[20 ] = 16'b1111111101111100;
assign w_bias[21 ] = 16'b0000000011100000;
assign w_bias[22 ] = 16'b0000000001101001;
assign w_bias[23 ] = 16'b1111111001101100;
assign w_bias[24 ] = 16'b1111111100100011;
assign w_bias[25 ] = 16'b0000000100000111;
assign w_bias[26 ] = 16'b0000000100010001;
assign w_bias[27 ] = 16'b0000000100110010;
assign w_bias[28 ] = 16'b1111111100110001;
assign w_bias[29 ] = 16'b1111111101001000;
assign w_bias[30 ] = 16'b1111111111001101;
assign w_bias[31 ] = 16'b1111111111000010;
assign w_bias[32 ] = 16'b1111111110111111;
assign w_bias[33 ] = 16'b0000000011101000;
assign w_bias[34 ] = 16'b0000000011110111;
assign w_bias[35 ] = 16'b1111111011011101;
assign w_bias[36 ] = 16'b0000000011111001;
assign w_bias[37 ] = 16'b1111111011101110;
assign w_bias[38 ] = 16'b0000000010101100;
assign w_bias[39 ] = 16'b0000000010010000;
assign w_bias[40 ] = 16'b0000000000110100;
assign w_bias[41 ] = 16'b1111111010011000;
assign w_bias[42 ] = 16'b0000000001110111;
assign w_bias[43 ] = 16'b0000000011101010;
assign w_bias[44 ] = 16'b0000000100010001;
assign w_bias[45 ] = 16'b1111111110001010;
assign w_bias[46 ] = 16'b1111111110111010;
assign w_bias[47 ] = 16'b0000000100010011;
assign w_bias[48 ] = 16'b0000000011101110;
assign w_bias[49 ] = 16'b1111111000101011;
assign w_bias[50 ] = 16'b1111111011101111;
assign w_bias[51 ] = 16'b1111111110011111;
assign w_bias[52 ] = 16'b0000000011010011;
assign w_bias[53 ] = 16'b1111111100010111;
assign w_bias[54 ] = 16'b1111111011011100;
assign w_bias[55 ] = 16'b0000000000011010;
assign w_bias[56 ] = 16'b1111111101000111;
assign w_bias[57 ] = 16'b1111111100000001;
assign w_bias[58 ] = 16'b0000000001001010;
assign w_bias[59 ] = 16'b1111111101100011;
assign w_bias[60 ] = 16'b1111111011100100;
assign w_bias[61 ] = 16'b1111110101000100;
assign w_bias[62 ] = 16'b1111111111010011;
assign w_bias[63 ] = 16'b1111111110100110;
assign w_bias[64 ] = 16'b1111111101111000;
assign w_bias[65 ] = 16'b1111111110000001;
assign w_bias[66 ] = 16'b0000000011011101;
assign w_bias[67 ] = 16'b0000000100010000;
assign w_bias[68 ] = 16'b1111111110001010;
assign w_bias[69 ] = 16'b0000000011111110;
assign w_bias[70 ] = 16'b0000000100001010;
assign w_bias[71 ] = 16'b1111111011000001;
assign w_bias[72 ] = 16'b0000000010110001;
assign w_bias[73 ] = 16'b0000000100010010;
assign w_bias[74 ] = 16'b0000000001001000;
assign w_bias[75 ] = 16'b1111111001110101;
assign w_bias[76 ] = 16'b0000000011010111;
assign w_bias[77 ] = 16'b1111111011100101;
assign w_bias[78 ] = 16'b1111111001000111;
assign w_bias[79 ] = 16'b0000000011110001;
assign w_bias[80 ] = 16'b0000000100000101;
assign w_bias[81 ] = 16'b0000000100100111;
assign w_bias[82 ] = 16'b0000000100000101;
assign w_bias[83 ] = 16'b0000000000010100;
assign w_bias[84 ] = 16'b1111111110011111;
assign w_bias[85 ] = 16'b1111110101100110;
assign w_bias[86 ] = 16'b1111111101001111;
assign w_bias[87 ] = 16'b1111111100011000;
assign w_bias[88 ] = 16'b1111111110010010;
assign w_bias[89 ] = 16'b1111111110111111;
assign w_bias[90 ] = 16'b0000000011110100;
assign w_bias[91 ] = 16'b1111111110011010;
assign w_bias[92 ] = 16'b0000000011110100;
assign w_bias[93 ] = 16'b0000000011110100;
assign w_bias[94 ] = 16'b0000000000100010;
assign w_bias[95 ] = 16'b0000000100000101;
assign w_bias[96 ] = 16'b1111111000110011;
assign w_bias[97 ] = 16'b0000000001001111;
assign w_bias[98 ] = 16'b1111111011001101;
assign w_bias[99 ] = 16'b1111111011011011;
assign w_bias[100] = 16'b0000000011110000;
assign w_bias[101] = 16'b0000000100101001;
assign w_bias[102] = 16'b0000000011001111;
assign w_bias[103] = 16'b1111110110110101;
assign w_bias[104] = 16'b1111111100010010;
assign w_bias[105] = 16'b1111111100110100;
assign w_bias[106] = 16'b1111111001111001;
assign w_bias[107] = 16'b1111111101110000;
assign w_bias[108] = 16'b1111111011101101;
assign w_bias[109] = 16'b1111111110010101;
assign w_bias[110] = 16'b0000000001111010;
assign w_bias[111] = 16'b0000000011100000;
assign w_bias[112] = 16'b1111111100000010;
assign w_bias[113] = 16'b0000000011101100;
assign w_bias[114] = 16'b0000000011110001;
assign w_bias[115] = 16'b1111111110001100;
assign w_bias[116] = 16'b1111111101011101;
assign w_bias[117] = 16'b0000000100001000;
assign w_bias[118] = 16'b0000000011111110;
assign w_bias[119] = 16'b0000000011000001;
assign w_bias[120] = 16'b0000000011101110;
assign w_bias[121] = 16'b1111111010101111;
assign w_bias[122] = 16'b1111111011000111;
assign w_bias[123] = 16'b0000000001111110;
assign w_bias[124] = 16'b1111111111111001;
assign w_bias[125] = 16'b0000000010000000;
assign w_bias[126] = 16'b1111111110011111;
assign w_bias[127] = 16'b0000000011011101;




reg  	[15:0] 			state   = 16'd1;
reg		[16*3-1:0] 		weight0 = 48'h0;
reg		[16*3-1:0] 		weight1 = 48'b0;
reg		[16*3-1:0] 		weight2 = 48'b0;
reg		[16*3-1:0] 		weight3 = 48'b0;
reg		[16*3-1:0] 		weight4 = 48'b0;
reg		[16*3-1:0] 		weight5 = 48'b0;
reg		[16*3-1:0] 		weight6 = 48'b0;
reg		[16*3-1:0] 		weight7 = 48'b0;
reg		[16*3-1:0]		weight0_shift = 0;
reg		[16*3-1:0]		weight1_shift = 0;
reg		[16*3-1:0]		weight2_shift = 0;
reg		[16*3-1:0]		weight3_shift = 0;
reg		[16*3-1:0]		weight4_shift = 0;
reg		[16*3-1:0]		weight5_shift = 0;
reg		[16*3-1:0]		weight6_shift = 0;
reg		[16*3-1:0]		weight7_shift = 0;
reg		[15:0]			bias0   = 0;
reg		[15:0]			bias1   = 0;
reg		[15:0]			bias2   = 0;
reg		[15:0]			bias3   = 0;
reg		[15:0]			bias4   = 0;
reg		[15:0]			bias5   = 0;
reg		[15:0]			bias6   = 0;
reg		[15:0]			bias7   = 0;


reg  rd_en = 0;
(*mark_debug="true"*)
wire full ;
wire empty;
wire [31 : 0] dout;
(*mark_debug="true"*)
reg [20:0] 	clk_cnt = 0;
reg 		rd_begin = 0;
reg 		jump3_delay1 = 0;
reg 		shift_begin = 0;
reg			shift_begin1 = 0;
reg 		jump_per3clk = 0;
reg 		rd_delay1 = 0;  //rd_en delay 1 clk


reg 	[16*3-1:0] 	input_i = 48'h0;
reg 	[16*3-1:0] 	input_q = 48'h0;
reg 	[16*3-1:0] 	input_i_shift = 48'h0;
reg 	[16*3-1:0] 	input_q_shift = 48'h0;

wire 	[31:0]    	prdt1_i;
wire 	[31:0]    	prdt2_i;
wire 	[31:0]    	prdt3_i;
wire 	[31:0]    	prdt4_i;
wire 	[31:0]    	prdt5_i;
wire 	[31:0]    	prdt6_i;
wire 	[31:0]    	prdt7_i;
wire 	[31:0]    	prdt8_i;
wire 	[31:0]    	prdt1_q;
wire 	[31:0]    	prdt2_q;
wire 	[31:0]    	prdt3_q;
wire 	[31:0]    	prdt4_q;
wire 	[31:0]    	prdt5_q;
wire 	[31:0]    	prdt6_q;
wire 	[31:0]    	prdt7_q;
wire 	[31:0]    	prdt8_q;

reg 	[15:0]		prdt1_i_tmp1 = 0;      reg 	[15:0]		prdt1_q_tmp1 = 0;
reg 	[15:0]		prdt2_i_tmp1 = 0;      reg 	[15:0]		prdt2_q_tmp1 = 0;
reg 	[15:0]		prdt3_i_tmp1 = 0;      reg 	[15:0]		prdt3_q_tmp1 = 0;
reg 	[15:0]		prdt4_i_tmp1 = 0;      reg 	[15:0]		prdt4_q_tmp1 = 0;
reg 	[15:0]		prdt5_i_tmp1 = 0;      reg 	[15:0]		prdt5_q_tmp1 = 0;
reg 	[15:0]		prdt6_i_tmp1 = 0;      reg 	[15:0]		prdt6_q_tmp1 = 0;
reg 	[15:0]		prdt7_i_tmp1 = 0;      reg 	[15:0]		prdt7_q_tmp1 = 0;
reg 	[15:0]		prdt8_i_tmp1 = 0;      reg 	[15:0]		prdt8_q_tmp1 = 0;
                                                                  
reg 	[15:0]		prdt1_i_tmp2 = 0;      reg 	[15:0]		prdt1_q_tmp2 = 0;
reg 	[15:0]		prdt2_i_tmp2 = 0;      reg 	[15:0]		prdt2_q_tmp2 = 0;
reg 	[15:0]		prdt3_i_tmp2 = 0;      reg 	[15:0]		prdt3_q_tmp2 = 0;
reg 	[15:0]		prdt4_i_tmp2 = 0;      reg 	[15:0]		prdt4_q_tmp2 = 0;
reg 	[15:0]		prdt5_i_tmp2 = 0;      reg 	[15:0]		prdt5_q_tmp2 = 0;
reg 	[15:0]		prdt6_i_tmp2 = 0;      reg 	[15:0]		prdt6_q_tmp2 = 0;
reg 	[15:0]		prdt7_i_tmp2 = 0;      reg 	[15:0]		prdt7_q_tmp2 = 0;
reg 	[15:0]		prdt8_i_tmp2 = 0;      reg 	[15:0]		prdt8_q_tmp2 = 0;
                                                                  
reg 	[15:0]		prdt1_i_tmp3 = 0;      reg 	[15:0]		prdt1_q_tmp3 = 0;
reg 	[15:0]		prdt2_i_tmp3 = 0;      reg 	[15:0]		prdt2_q_tmp3 = 0;
reg 	[15:0]		prdt3_i_tmp3 = 0;      reg 	[15:0]		prdt3_q_tmp3 = 0;
reg 	[15:0]		prdt4_i_tmp3 = 0;      reg 	[15:0]		prdt4_q_tmp3 = 0;
reg 	[15:0]		prdt5_i_tmp3 = 0;      reg 	[15:0]		prdt5_q_tmp3 = 0;
reg 	[15:0]		prdt6_i_tmp3 = 0;      reg 	[15:0]		prdt6_q_tmp3 = 0;
reg 	[15:0]		prdt7_i_tmp3 = 0;      reg 	[15:0]		prdt7_q_tmp3 = 0;
reg 	[15:0]		prdt8_i_tmp3 = 0;      reg 	[15:0]		prdt8_q_tmp3 = 0;


wire	[16 : 0]	sum1_1i;
wire	[16 : 0]	sum2_1i;
wire	[16 : 0]	sum3_1i;
wire	[16 : 0]	sum4_1i;
wire	[16 : 0]	sum5_1i;
wire	[16 : 0]	sum6_1i;
wire	[16 : 0]	sum7_1i;
wire	[16 : 0]	sum8_1i;
wire	[16 : 0]	sum1_1q;
wire	[16 : 0]	sum2_1q;
wire	[16 : 0]	sum3_1q;
wire	[16 : 0]	sum4_1q;
wire	[16 : 0]	sum5_1q;
wire	[16 : 0]	sum6_1q;
wire	[16 : 0]	sum7_1q;
wire	[16 : 0]	sum8_1q;

wire	[16 : 0]	sum1_2i;
wire	[16 : 0]	sum2_2i;
wire	[16 : 0]	sum3_2i;
wire	[16 : 0]	sum4_2i;
wire	[16 : 0]	sum5_2i;
wire	[16 : 0]	sum6_2i;
wire	[16 : 0]	sum7_2i;
wire	[16 : 0]	sum8_2i;
wire	[16 : 0]	sum1_2q;
wire	[16 : 0]	sum2_2q;
wire	[16 : 0]	sum3_2q;
wire	[16 : 0]	sum4_2q;
wire	[16 : 0]	sum5_2q;
wire	[16 : 0]	sum6_2q;
wire	[16 : 0]	sum7_2q;
wire	[16 : 0]	sum8_2q;

wire	[16 : 0]	sum1i;
wire	[16 : 0]	sum2i;
wire	[16 : 0]	sum3i;
wire	[16 : 0]	sum4i;
wire	[16 : 0]	sum5i;
wire	[16 : 0]	sum6i;
wire	[16 : 0]	sum7i;
wire	[16 : 0]	sum8i;
wire	[16 : 0]	sum1q;
wire	[16 : 0]	sum2q;
wire	[16 : 0]	sum3q;
wire	[16 : 0]	sum4q;
wire	[16 : 0]	sum5q;
wire	[16 : 0]	sum6q;
wire	[16 : 0]	sum7q;
wire	[16 : 0]	sum8q;

reg 	[17 : 0] 	B = 18'b00_0000_0000_0000_0001;
reg  				CE = 1;
reg 	[15:0] 		bias0_delay7 = 0;
reg 	[15:0] 		bias1_delay7 = 0;
reg 	[15:0] 		bias2_delay7 = 0;
reg 	[15:0] 		bias3_delay7 = 0;
reg 	[15:0] 		bias4_delay7 = 0;
reg 	[15:0] 		bias5_delay7 = 0;
reg 	[15:0] 		bias6_delay7 = 0;
reg 	[15:0] 		bias7_delay7 = 0;

reg 	[16*6-1:0] 	bias0_tmp = 0;
reg 	[16*6-1:0] 	bias1_tmp = 0;
reg 	[16*6-1:0] 	bias2_tmp = 0;
reg 	[16*6-1:0] 	bias3_tmp = 0;
reg 	[16*6-1:0] 	bias4_tmp = 0;
reg 	[16*6-1:0] 	bias5_tmp = 0;
reg 	[16*6-1:0] 	bias6_tmp = 0;
reg 	[16*6-1:0] 	bias7_tmp = 0;

reg     [7:0]		input_cnt = 0;

reg 	[2:0] 		clk_cnt3  = 0;
reg  	[5:0] 		cnt48 = 0;


reg 	[9:0] 		shift_begin_tmp = 0;  // for  delay 15 clks
reg 				output_valid = 0;
reg 				output_valid_tmp = 0;
reg					output_valid_tmp1 = 0;
assign map_valid = output_valid_tmp1;

reg 	[15:0] 		output_tmp1i = 0;
reg 	[15:0] 		output_tmp2i = 0;
reg 	[15:0] 		output_tmp3i = 0;
reg 	[15:0] 		output_tmp4i = 0;
reg 	[15:0] 		output_tmp5i = 0;
reg 	[15:0] 		output_tmp6i = 0;
reg 	[15:0] 		output_tmp7i = 0;
reg 	[15:0] 		output_tmp8i = 0;

reg 	[15:0] 		output_tmp1q = 0;
reg 	[15:0] 		output_tmp2q = 0;
reg 	[15:0] 		output_tmp3q = 0;
reg 	[15:0] 		output_tmp4q = 0;
reg 	[15:0] 		output_tmp5q = 0;
reg 	[15:0] 		output_tmp6q = 0;
reg 	[15:0] 		output_tmp7q = 0;
reg 	[15:0] 		output_tmp8q = 0;

wire 	[15:0] 		cnn1_output1i;
wire 	[15:0] 		cnn1_output2i;
wire 	[15:0] 		cnn1_output3i;
wire 	[15:0] 		cnn1_output4i;
wire 	[15:0] 		cnn1_output5i;
wire 	[15:0] 		cnn1_output6i;
wire 	[15:0] 		cnn1_output7i;
wire 	[15:0] 		cnn1_output8i;

wire 	[15:0] 		cnn1_output1q;
wire 	[15:0] 		cnn1_output2q;
wire 	[15:0] 		cnn1_output3q;
wire 	[15:0] 		cnn1_output4q;
wire 	[15:0] 		cnn1_output5q;
wire 	[15:0] 		cnn1_output6q;
wire 	[15:0] 		cnn1_output7q;
wire 	[15:0] 		cnn1_output8q;

assign  cnn1_output1i[15:0] = output_tmp1i[15]?16'b0:output_tmp1i[15:0];
assign  cnn1_output2i[15:0] = output_tmp2i[15]?16'b0:output_tmp2i[15:0];
assign  cnn1_output3i[15:0] = output_tmp3i[15]?16'b0:output_tmp3i[15:0];
assign  cnn1_output4i[15:0] = output_tmp4i[15]?16'b0:output_tmp4i[15:0];
assign  cnn1_output5i[15:0] = output_tmp5i[15]?16'b0:output_tmp5i[15:0];
assign  cnn1_output6i[15:0] = output_tmp6i[15]?16'b0:output_tmp6i[15:0];
assign  cnn1_output7i[15:0] = output_tmp7i[15]?16'b0:output_tmp7i[15:0];
assign  cnn1_output8i[15:0] = output_tmp8i[15]?16'b0:output_tmp8i[15:0];

assign  cnn1_output1q[15:0] = output_tmp1q[15]?16'b0:output_tmp1q[15:0];
assign  cnn1_output2q[15:0] = output_tmp2q[15]?16'b0:output_tmp2q[15:0];
assign  cnn1_output3q[15:0] = output_tmp3q[15]?16'b0:output_tmp3q[15:0];
assign  cnn1_output4q[15:0] = output_tmp4q[15]?16'b0:output_tmp4q[15:0];
assign  cnn1_output5q[15:0] = output_tmp5q[15]?16'b0:output_tmp5q[15:0];
assign  cnn1_output6q[15:0] = output_tmp6q[15]?16'b0:output_tmp6q[15:0];
assign  cnn1_output7q[15:0] = output_tmp7q[15]?16'b0:output_tmp7q[15:0];
assign  cnn1_output8q[15:0] = output_tmp8q[15]?16'b0:output_tmp8q[15:0];

assign output_I={cnn1_output1i,cnn1_output2i,cnn1_output3i,cnn1_output4i,cnn1_output5i,cnn1_output6i,cnn1_output7i,cnn1_output8i};
assign output_Q={cnn1_output1q,cnn1_output2q,cnn1_output3q,cnn1_output4q,cnn1_output5q,cnn1_output6q,cnn1_output7q,cnn1_output8q};
//assign output_I={cnn1_output8i,cnn1_output7i,cnn1_output6i,cnn1_output5i,cnn1_output4i,cnn1_output3i,cnn1_output2i,cnn1_output1i};
//assign output_Q={cnn1_output8q,cnn1_output7q,cnn1_output6q,cnn1_output5q,cnn1_output4q,cnn1_output3q,cnn1_output2q,cnn1_output1q};
always@(posedge clk)
begin
	
	if(!rst_n)
	begin
		rd_en = 0;
		clk_cnt = 0;
		rd_begin = 0;
		jump3_delay1 = 0;
		shift_begin = 0;
		shift_begin1 = 0;
		jump_per3clk = 0;
		rd_delay1 = 0;  //rd_en delay 1 clk
		state <= 16'd1;
		input_i <= 0;
		input_q <= 0;
		input_cnt <= 0;
		clk_cnt3     <= 0;
	end
	else
	begin
		//clk_cnt <= clk_cnt + 1;
		//if(clk_cnt == 15'd64)  //开始时刻待定
		//begin
		//	rd_en	 <= 1;
		//	rd_begin <= 1;
		//	jump_per3clk <= 1;
		//end
		//else;
		if(din_valid)
		begin
			if(clk_cnt ==16)
			begin
			
				rd_en	 <= 1;
				rd_begin <= 1;
				jump_per3clk <= 1;
				clk_cnt <= clk_cnt + 1;
			end
			else if(clk_cnt==128)
			begin
				clk_cnt <= 1;
			end
			else
			begin
				clk_cnt <= clk_cnt + 1;
			end
			
		end
		
		
		
		rd_delay1 <= rd_en;
		jump3_delay1 <= jump_per3clk ;  //jump_per3clk delay 1 clk 
		shift_begin <= jump3_delay1 ;   //jump_per3clk delay 2 clk 
		
		{bias0_delay7,bias0_tmp} <= {bias0_tmp,bias0};
		{bias1_delay7,bias1_tmp} <= {bias1_tmp,bias1};
		{bias2_delay7,bias2_tmp} <= {bias2_tmp,bias2};
		{bias3_delay7,bias3_tmp} <= {bias3_tmp,bias3};
		{bias4_delay7,bias4_tmp} <= {bias4_tmp,bias4};
		{bias5_delay7,bias5_tmp} <= {bias5_tmp,bias5};
		{bias6_delay7,bias6_tmp} <= {bias6_tmp,bias6};
		{bias7_delay7,bias7_tmp} <= {bias7_tmp,bias7};
		
		if(rd_begin)  
		begin
			if(clk_cnt3 == 3'd2)
			begin
				jump_per3clk <= 1;
				clk_cnt3<= 0;
			end
			else
			begin
				jump_per3clk <= 0;
				clk_cnt3 <=  clk_cnt3 + 1;
			end
			
			if(cnt48 != 6'd47)  // read 1 data from fifo per 48 clk  
			begin
				rd_en <= 0;
				cnt48 <= cnt48 + 1;
			end
			else
			begin
				cnt48 <= 0;
				if(input_cnt ==130)
				begin
					rd_en <= 0;
					rd_begin <= 0;
					jump_per3clk <= 0;
					//clk_cnt <= 0;
					//jump_per3clk <= 0;
				end
				else
				begin
					rd_en <= 1;
				end
			end
			
			if(rd_delay1)
			begin
				if(input_cnt == 128)  // if every symbol(128) is continuous ,					   
				begin					//one symbol's the last  pading 2 zeros can be next symbol's first pading 2 zeros
					input_i <= {16'b0,input_i[16*3-1:16]} ;  //zero pading
					input_q <= {16'b0,input_q[16*3-1:16]} ; 
					input_cnt <= input_cnt + 1;
				end
				else if(input_cnt==129)
				begin
					input_i <= {16'b0,input_i[16*3-1:16]} ; //zero pading
					input_q <= {16'b0,input_q[16*3-1:16]} ; 
					input_cnt <= input_cnt + 1;
					//rd_en	 <= 0;		//test
					//rd_begin <= 0;
					//jump_per3clk <= 0;
				end
				//else if(input_cnt==130)
				//begin
				//	rd_en	 <= 0;			//test			
				//	rd_begin <= 0;				
				//	jump_per3clk <= 0;	
				//	input_cnt  <=0;	
				//end
				else
				begin
					input_cnt <= input_cnt + 1 ; 
					input_i <= {dout[15:0],input_i[3*16-1:16]};
					input_q <= {dout[31:16],input_q[16*3-1:16]} ; 
				end
			end
			else;			
		end
		else
		begin
			//jump_per3clk <= 0;
			clk_cnt3     <= 0;
			input_cnt    <= 0;
			input_i <= 0;
			input_q <= 0;
		end
		
		
		if(jump3_delay1)  // shift to reg  per 3 clk
		begin
			state <= {state[14:0],state[15]};
		end
		else;
		
		if(shift_begin)
		begin
			input_i_shift <= input_i;
			input_q_shift <= input_q;
			weight0_shift <= weight0;
			weight1_shift <= weight1;
			weight2_shift <= weight2;
			weight3_shift <= weight3;
			weight4_shift <= weight4;
			weight5_shift <= weight5;
			weight6_shift <= weight6;
			weight7_shift <= weight7;
			shift_begin1 <= 1;
		end
		else if(shift_begin1)
		begin
			input_i_shift <= {input_i_shift[15:0],input_i_shift[3*16-1:16]}; //shift right 
			input_q_shift <= {input_q_shift[15:0],input_q_shift[3*16-1:16]}; //shift right 
			weight0_shift <= {16'b0,weight0_shift[3*16-1:16]};
			weight1_shift <= {16'b0,weight1_shift[3*16-1:16]};
			weight2_shift <= {16'b0,weight2_shift[3*16-1:16]};
			weight3_shift <= {16'b0,weight3_shift[3*16-1:16]};
			weight4_shift <= {16'b0,weight4_shift[3*16-1:16]};
			weight5_shift <= {16'b0,weight5_shift[3*16-1:16]};
			weight6_shift <= {16'b0,weight6_shift[3*16-1:16]};
			weight7_shift <= {16'b0,weight7_shift[3*16-1:16]};
		end
		else;
		
		{output_valid,shift_begin_tmp} <= {shift_begin_tmp,shift_begin};
		output_valid_tmp <=	output_valid;
		output_valid_tmp1 <= output_valid_tmp;
		//
		if(output_valid)
		begin
			output_tmp1i <= {sum1i[16],sum1i[14:0]};
			output_tmp2i <= {sum2i[16],sum2i[14:0]};
			output_tmp3i <= {sum3i[16],sum3i[14:0]};
			output_tmp4i <= {sum4i[16],sum4i[14:0]};
			output_tmp5i <= {sum5i[16],sum5i[14:0]};
			output_tmp6i <= {sum6i[16],sum6i[14:0]};
			output_tmp7i <= {sum7i[16],sum7i[14:0]};
			output_tmp8i <= {sum8i[16],sum8i[14:0]};
			
			output_tmp1q <= {sum1q[16],sum1q[14:0]};
			output_tmp2q <= {sum2q[16],sum2q[14:0]};
			output_tmp3q <= {sum3q[16],sum3q[14:0]};
			output_tmp4q <= {sum4q[16],sum4q[14:0]};
			output_tmp5q <= {sum5q[16],sum5q[14:0]};
			output_tmp6q <= {sum6q[16],sum6q[14:0]};
			output_tmp7q <= {sum7q[16],sum7q[14:0]};
			output_tmp8q <= {sum8q[16],sum8q[14:0]};
		end
		else;
		
		prdt1_i_tmp1 <= {prdt1_i[30-:16]};      prdt1_q_tmp1 <= {prdt1_q[30-:16]};
		prdt2_i_tmp1 <= {prdt2_i[30-:16]};      prdt2_q_tmp1 <= {prdt2_q[30-:16]};
		prdt3_i_tmp1 <= {prdt3_i[30-:16]};      prdt3_q_tmp1 <= {prdt3_q[30-:16]};
		prdt4_i_tmp1 <= {prdt4_i[30-:16]};      prdt4_q_tmp1 <= {prdt4_q[30-:16]};
		prdt5_i_tmp1 <= {prdt5_i[30-:16]};      prdt5_q_tmp1 <= {prdt5_q[30-:16]};
		prdt6_i_tmp1 <= {prdt6_i[30-:16]};      prdt6_q_tmp1 <= {prdt6_q[30-:16]};
		prdt7_i_tmp1 <= {prdt7_i[30-:16]};      prdt7_q_tmp1 <= {prdt7_q[30-:16]};
		prdt8_i_tmp1 <= {prdt8_i[30-:16]};      prdt8_q_tmp1 <= {prdt8_q[30-:16]};
		                                        
		prdt1_i_tmp2 <= prdt1_i_tmp1;           prdt1_q_tmp2 <= prdt1_q_tmp1;
		prdt2_i_tmp2 <= prdt2_i_tmp1;           prdt2_q_tmp2 <= prdt2_q_tmp1;
		prdt3_i_tmp2 <= prdt3_i_tmp1;           prdt3_q_tmp2 <= prdt3_q_tmp1;
		prdt4_i_tmp2 <= prdt4_i_tmp1;           prdt4_q_tmp2 <= prdt4_q_tmp1;
		prdt5_i_tmp2 <= prdt5_i_tmp1;           prdt5_q_tmp2 <= prdt5_q_tmp1;
		prdt6_i_tmp2 <= prdt6_i_tmp1;           prdt6_q_tmp2 <= prdt6_q_tmp1;
		prdt7_i_tmp2 <= prdt7_i_tmp1;           prdt7_q_tmp2 <= prdt7_q_tmp1;
		prdt8_i_tmp2 <= prdt8_i_tmp1;           prdt8_q_tmp2 <= prdt8_q_tmp1;
  
		prdt1_i_tmp3 <= prdt1_i_tmp2;           prdt1_q_tmp3 <= prdt1_q_tmp2;
		prdt2_i_tmp3 <= prdt2_i_tmp2;           prdt2_q_tmp3 <= prdt2_q_tmp2;
		prdt3_i_tmp3 <= prdt3_i_tmp2;           prdt3_q_tmp3 <= prdt3_q_tmp2;
		prdt4_i_tmp3 <= prdt4_i_tmp2;           prdt4_q_tmp3 <= prdt4_q_tmp2;
		prdt5_i_tmp3 <= prdt5_i_tmp2;           prdt5_q_tmp3 <= prdt5_q_tmp2;
		prdt6_i_tmp3 <= prdt6_i_tmp2;           prdt6_q_tmp3 <= prdt6_q_tmp2;
		prdt7_i_tmp3 <= prdt7_i_tmp2;           prdt7_q_tmp3 <= prdt7_q_tmp2;
		prdt8_i_tmp3 <= prdt8_i_tmp2;           prdt8_q_tmp3 <= prdt8_q_tmp2;
		
		case(state) // 128 channels are divided into 16 parts.	 8 channel per part 
 		16'b0000_0000_0000_0001:begin
								weight0 <= {w2[0  ],w1[0  ],w0[0  ]};		bias0 <= w_bias[0] ;
								weight1 <= {w2[1  ],w1[1  ],w0[1  ]};		bias1 <= w_bias[1  ] ;
								weight2 <= {w2[2  ],w1[2  ],w0[2  ]};		bias2 <= w_bias[2  ] ;
								weight3 <= {w2[3  ],w1[3  ],w0[3  ]};		bias3 <= w_bias[3  ] ;
								weight4 <= {w2[4  ],w1[4  ],w0[4  ]};		bias4 <= w_bias[4  ] ;
								weight5 <= {w2[5  ],w1[5  ],w0[5  ]};		bias5 <= w_bias[5  ] ;
								weight6 <= {w2[6  ],w1[6  ],w0[6  ]};		bias6 <= w_bias[6  ] ;
								weight7 <= {w2[7  ],w1[7  ],w0[7  ]};		bias7 <= w_bias[7  ] ;
								end		                    
		16'b0000_0000_0000_0010:begin		                		         
								weight0 <= {w2[8  ],w1[8  ],w0[8  ]};		bias0 <= w_bias[8  ] ;
								weight1 <= {w2[9  ],w1[9  ],w0[9  ]};		bias1 <= w_bias[9  ] ;
								weight2 <= {w2[10 ],w1[10 ],w0[10 ]};		bias2 <= w_bias[10 ] ;
								weight3 <= {w2[11 ],w1[11 ],w0[11 ]};		bias3 <= w_bias[11 ] ;
								weight4 <= {w2[12 ],w1[12 ],w0[12 ]};		bias4 <= w_bias[12 ] ;
								weight5 <= {w2[13 ],w1[13 ],w0[13 ]};		bias5 <= w_bias[13 ] ;
								weight6 <= {w2[14 ],w1[14 ],w0[14 ]};		bias6 <= w_bias[14 ] ;
								weight7 <= {w2[15 ],w1[15 ],w0[15 ]};		bias7 <= w_bias[15 ] ;
								end		     
		16'b0000_0000_0000_0100:begin		 
								weight0 <= {w2[16 ],w1[16 ],w0[16 ]};		bias0 <= w_bias[16 ] ;
		                        weight1 <= {w2[17 ],w1[17 ],w0[17 ]};		bias1 <= w_bias[17 ] ;
		                        weight2 <= {w2[18 ],w1[18 ],w0[18 ]};		bias2 <= w_bias[18 ] ;
		                        weight3 <= {w2[19 ],w1[19 ],w0[19 ]};		bias3 <= w_bias[19 ] ;
		                        weight4 <= {w2[20 ],w1[20 ],w0[20 ]};		bias4 <= w_bias[20 ] ;
		                        weight5 <= {w2[21 ],w1[21 ],w0[21 ]};		bias5 <= w_bias[21 ] ;
		                        weight6 <= {w2[22 ],w1[22 ],w0[22 ]};		bias6 <= w_bias[22 ] ;
		                        weight7 <= {w2[23 ],w1[23 ],w0[23 ]};		bias7 <= w_bias[23 ] ;
								end		                    
		16'b0000_0000_0000_1000:begin		                
							    weight0 <= {w2[24 ],w1[24 ],w0[24 ]};		bias0 <= w_bias[24 ] ;
		                        weight1 <= {w2[25 ],w1[25 ],w0[25 ]};		bias1 <= w_bias[25 ] ;
		                        weight2 <= {w2[26 ],w1[26 ],w0[26 ]};		bias2 <= w_bias[26 ] ;
		                        weight3 <= {w2[27 ],w1[27 ],w0[27 ]};		bias3 <= w_bias[27 ] ;
		                        weight4 <= {w2[28 ],w1[28 ],w0[28 ]};		bias4 <= w_bias[28 ] ;
		                        weight5 <= {w2[29 ],w1[29 ],w0[29 ]};		bias5 <= w_bias[29 ] ;
		                        weight6 <= {w2[30 ],w1[30 ],w0[30 ]};		bias6 <= w_bias[30 ] ;
		                        weight7 <= {w2[31 ],w1[31 ],w0[31 ]};		bias7 <= w_bias[31 ] ;
								end		                    
		16'b0000_0000_0001_0000:begin		                
								weight0 <= {w2[32 ],w1[32 ],w0[32 ]};		bias0 <= w_bias[32 ] ;
		                        weight1 <= {w2[33 ],w1[33 ],w0[33 ]};		bias1 <= w_bias[33 ] ;
		                        weight2 <= {w2[34 ],w1[34 ],w0[34 ]};		bias2 <= w_bias[34 ] ;
		                        weight3 <= {w2[35 ],w1[35 ],w0[35 ]};		bias3 <= w_bias[35 ] ;
		                        weight4 <= {w2[36 ],w1[36 ],w0[36 ]};		bias4 <= w_bias[36 ] ;
		                        weight5 <= {w2[37 ],w1[37 ],w0[37 ]};		bias5 <= w_bias[37 ] ;
		                        weight6 <= {w2[38 ],w1[38 ],w0[38 ]};		bias6 <= w_bias[38 ] ;
		                        weight7 <= {w2[39 ],w1[39 ],w0[39 ]};		bias7 <= w_bias[39 ] ;
								end		     
		16'b0000_0000_0010_0000:begin		 
								weight0 <= {w2[40 ],w1[40 ],w0[40 ]};		bias0 <= w_bias[40 ] ;
		                        weight1 <= {w2[41 ],w1[41 ],w0[41 ]};		bias1 <= w_bias[41 ] ;
		                        weight2 <= {w2[42 ],w1[42 ],w0[42 ]};		bias2 <= w_bias[42 ] ;
		                        weight3 <= {w2[43 ],w1[43 ],w0[43 ]};		bias3 <= w_bias[43 ] ;
		                        weight4 <= {w2[44 ],w1[44 ],w0[44 ]};		bias4 <= w_bias[44 ] ;
		                        weight5 <= {w2[45 ],w1[45 ],w0[45 ]};		bias5 <= w_bias[45 ] ;
		                        weight6 <= {w2[46 ],w1[46 ],w0[46 ]};		bias6 <= w_bias[46 ] ;
		                        weight7 <= {w2[47 ],w1[47 ],w0[47 ]};		bias7 <= w_bias[47 ] ;
								end		                    
		16'b0000_0000_0100_0000:begin		                
								weight0 <= {w2[48 ],w1[48 ],w0[48 ]};		bias0 <= w_bias[48 ] ;
		                        weight1 <= {w2[49 ],w1[49 ],w0[49 ]};		bias1 <= w_bias[49 ] ;
		                        weight2 <= {w2[50 ],w1[50 ],w0[50 ]};		bias2 <= w_bias[50 ] ;
		                        weight3 <= {w2[51 ],w1[51 ],w0[51 ]};		bias3 <= w_bias[51 ] ;
		                        weight4 <= {w2[52 ],w1[52 ],w0[52 ]};		bias4 <= w_bias[52 ] ;
		                        weight5 <= {w2[53 ],w1[53 ],w0[53 ]};		bias5 <= w_bias[53 ] ;
		                        weight6 <= {w2[54 ],w1[54 ],w0[54 ]};		bias6 <= w_bias[54 ] ;
		                        weight7 <= {w2[55 ],w1[55 ],w0[55 ]};		bias7 <= w_bias[55 ] ;
								end		                   
		16'b0000_0000_1000_0000:begin		               
								weight0 <= {w2[56 ],w1[56 ],w0[56 ]};		bias0 <= w_bias[56 ] ;
		                        weight1 <= {w2[57 ],w1[57 ],w0[57 ]};		bias1 <= w_bias[57 ] ;
		                        weight2 <= {w2[58 ],w1[58 ],w0[58 ]};		bias2 <= w_bias[58 ] ;
		                        weight3 <= {w2[59 ],w1[59 ],w0[59 ]};		bias3 <= w_bias[59 ] ;
		                        weight4 <= {w2[60 ],w1[60 ],w0[60 ]};		bias4 <= w_bias[60 ] ;
		                        weight5 <= {w2[61 ],w1[61 ],w0[61 ]};		bias5 <= w_bias[61 ] ;
		                        weight6 <= {w2[62 ],w1[62 ],w0[62 ]};		bias6 <= w_bias[62 ] ;
		                        weight7 <= {w2[63 ],w1[63 ],w0[63 ]};		bias7 <= w_bias[63 ] ;
								end		                    
		16'b0000_0001_0000_0000:begin		                
								weight0 <= {w2[64 ],w1[64 ],w0[64 ]};		bias0 <= w_bias[64 ] ;
		                        weight1 <= {w2[65 ],w1[65 ],w0[65 ]};		bias1 <= w_bias[65 ] ;
		                        weight2 <= {w2[66 ],w1[66 ],w0[66 ]};		bias2 <= w_bias[66 ] ;
		                        weight3 <= {w2[67 ],w1[67 ],w0[67 ]};		bias3 <= w_bias[67 ] ;
		                        weight4 <= {w2[68 ],w1[68 ],w0[68 ]};		bias4 <= w_bias[68 ] ;
		                        weight5 <= {w2[69 ],w1[69 ],w0[69 ]};		bias5 <= w_bias[69 ] ;
		                        weight6 <= {w2[70 ],w1[70 ],w0[70 ]};		bias6 <= w_bias[70 ] ;
		                        weight7 <= {w2[71 ],w1[71 ],w0[71 ]};		bias7 <= w_bias[71 ] ;
								end		                    
		16'b0000_0010_0000_0000:begin		               
								weight0 <= {w2[72 ],w1[72 ],w0[72 ]};		bias0 <= w_bias[72 ] ;
		                        weight1 <= {w2[73 ],w1[73 ],w0[73 ]};		bias1 <= w_bias[73 ] ;
		                        weight2 <= {w2[74 ],w1[74 ],w0[74 ]};		bias2 <= w_bias[74 ] ;
		                        weight3 <= {w2[75 ],w1[75 ],w0[75 ]};		bias3 <= w_bias[75 ] ;
		                        weight4 <= {w2[76 ],w1[76 ],w0[76 ]};		bias4 <= w_bias[76 ] ;
		                        weight5 <= {w2[77 ],w1[77 ],w0[77 ]};		bias5 <= w_bias[77 ] ;
		                        weight6 <= {w2[78 ],w1[78 ],w0[78 ]};		bias6 <= w_bias[78 ] ;
		                        weight7 <= {w2[79 ],w1[79 ],w0[79 ]};		bias7 <= w_bias[79 ] ;
								end		                   
		16'b0000_0100_0000_0000:begin		                
								weight0 <= {w2[80 ],w1[80 ],w0[80 ]};		bias0 <= w_bias[80 ] ;
		                        weight1 <= {w2[81 ],w1[81 ],w0[81 ]};		bias1 <= w_bias[81 ] ;
		                        weight2 <= {w2[82 ],w1[82 ],w0[82 ]};		bias2 <= w_bias[82 ] ;
		                        weight3 <= {w2[83 ],w1[83 ],w0[83 ]};		bias3 <= w_bias[83 ] ;
		                        weight4 <= {w2[84 ],w1[84 ],w0[84 ]};		bias4 <= w_bias[84 ] ;
		                        weight5 <= {w2[85 ],w1[85 ],w0[85 ]};		bias5 <= w_bias[85 ] ;
		                        weight6 <= {w2[86 ],w1[86 ],w0[86 ]};		bias6 <= w_bias[86 ] ;
		                        weight7 <= {w2[87 ],w1[87 ],w0[87 ]};		bias7 <= w_bias[87 ] ;
								end		                    
		16'b0000_1000_0000_0000:begin		                
								weight0 <= {w2[88 ],w1[88 ],w0[88 ]};		bias0 <= w_bias[88 ] ;
		                        weight1 <= {w2[89 ],w1[89 ],w0[89 ]};		bias1 <= w_bias[89 ] ;
		                        weight2 <= {w2[90 ],w1[90 ],w0[90 ]};		bias2 <= w_bias[90 ] ;
		                        weight3 <= {w2[91 ],w1[91 ],w0[91 ]};		bias3 <= w_bias[91 ] ;
		                        weight4 <= {w2[92 ],w1[92 ],w0[92 ]};		bias4 <= w_bias[92 ] ;
		                        weight5 <= {w2[93 ],w1[93 ],w0[93 ]};		bias5 <= w_bias[93 ] ;
		                        weight6 <= {w2[94 ],w1[94 ],w0[94 ]};		bias6 <= w_bias[94 ] ;
		                        weight7 <= {w2[95 ],w1[95 ],w0[95 ]};		bias7 <= w_bias[95 ] ;
								end		                    
		16'b0001_0000_0000_0000:begin		                
							    weight0 <= {w2[96 ],w1[96 ],w0[96 ]};		bias0 <= w_bias[96 ] ;
		                        weight1 <= {w2[97 ],w1[97 ],w0[97 ]};		bias1 <= w_bias[97 ] ;
		                        weight2 <= {w2[98 ],w1[98 ],w0[98 ]};		bias2 <= w_bias[98 ] ;
		                        weight3 <= {w2[99 ],w1[99 ],w0[99 ]};		bias3 <= w_bias[99 ] ;
		                        weight4 <= {w2[100],w1[100],w0[100]};		bias4 <= w_bias[100] ;
		                        weight5 <= {w2[101],w1[101],w0[101]};		bias5 <= w_bias[101] ;
		                        weight6 <= {w2[102],w1[102],w0[102]};		bias6 <= w_bias[102] ;
		                        weight7 <= {w2[103],w1[103],w0[103]};		bias7 <= w_bias[103] ;
								end		                    
		16'b0010_0000_0000_0000:begin		                
								weight0 <= {w2[104],w1[104],w0[104]};		bias0 <= w_bias[104] ;
		                        weight1 <= {w2[105],w1[105],w0[105]};		bias1 <= w_bias[105] ;
		                        weight2 <= {w2[106],w1[106],w0[106]};		bias2 <= w_bias[106] ;
		                        weight3 <= {w2[107],w1[107],w0[107]};		bias3 <= w_bias[107] ;
		                        weight4 <= {w2[108],w1[108],w0[108]};		bias4 <= w_bias[108] ;
		                        weight5 <= {w2[109],w1[109],w0[109]};		bias5 <= w_bias[109] ;
		                        weight6 <= {w2[110],w1[110],w0[110]};		bias6 <= w_bias[110] ;
		                        weight7 <= {w2[111],w1[111],w0[111]};		bias7 <= w_bias[111] ;
								end		                    
		16'b0100_0000_0000_0000:begin		                
								weight0 <= {w2[112],w1[112],w0[112]};		bias0 <= w_bias[112] ;
		                        weight1 <= {w2[113],w1[113],w0[113]};		bias1 <= w_bias[113] ;
		                        weight2 <= {w2[114],w1[114],w0[114]};		bias2 <= w_bias[114] ;
		                        weight3 <= {w2[115],w1[115],w0[115]};		bias3 <= w_bias[115] ;
		                        weight4 <= {w2[116],w1[116],w0[116]};		bias4 <= w_bias[116] ;
		                        weight5 <= {w2[117],w1[117],w0[117]};		bias5 <= w_bias[117] ;
		                        weight6 <= {w2[118],w1[118],w0[118]};		bias6 <= w_bias[118] ;
		                        weight7 <= {w2[119],w1[119],w0[119]};		bias7 <= w_bias[119] ;
								end		                    
		16'b1000_0000_0000_0000:begin		               
								weight0 <= {w2[120],w1[120],w0[120]};		bias0 <= w_bias[120] ;
		                        weight1 <= {w2[121],w1[121],w0[121]};		bias1 <= w_bias[121] ;
		                        weight2 <= {w2[122],w1[122],w0[122]};		bias2 <= w_bias[122] ;
		                        weight3 <= {w2[123],w1[123],w0[123]};		bias3 <= w_bias[123] ;
		                        weight4 <= {w2[124],w1[124],w0[124]};		bias4 <= w_bias[124] ;
		                        weight5 <= {w2[125],w1[125],w0[125]};		bias5 <= w_bias[125] ;
		                        weight6 <= {w2[126],w1[126],w0[126]};		bias6 <= w_bias[126] ;
		                        weight7 <= {w2[127],w1[127],w0[127]};		bias7 <= w_bias[127] ;
								end
		default: ;
		endcase
		
	end
end
//  i 
MULT_16X16 product_1i (.CLK(clk), .A(weight0_shift[15:0]), .B(input_i_shift[15:0]), .CE(CE), .P(prdt1_i) );
MULT_16X16 product_2i (.CLK(clk), .A(weight1_shift[15:0]), .B(input_i_shift[15:0]), .CE(CE), .P(prdt2_i) );
MULT_16X16 product_3i (.CLK(clk), .A(weight2_shift[15:0]), .B(input_i_shift[15:0]), .CE(CE), .P(prdt3_i) );
MULT_16X16 product_4i (.CLK(clk), .A(weight3_shift[15:0]), .B(input_i_shift[15:0]), .CE(CE), .P(prdt4_i) );
MULT_16X16 product_5i (.CLK(clk), .A(weight4_shift[15:0]), .B(input_i_shift[15:0]), .CE(CE), .P(prdt5_i) );
MULT_16X16 product_6i (.CLK(clk), .A(weight5_shift[15:0]), .B(input_i_shift[15:0]), .CE(CE), .P(prdt6_i) );
MULT_16X16 product_7i (.CLK(clk), .A(weight6_shift[15:0]), .B(input_i_shift[15:0]), .CE(CE), .P(prdt7_i) );
MULT_16X16 product_8i (.CLK(clk), .A(weight7_shift[15:0]), .B(input_i_shift[15:0]), .CE(CE), .P(prdt8_i) );

ADDER_16_16_17 SUM1_1i (.A(prdt1_i_tmp1), .B(prdt1_i_tmp2), .CLK(clk), .CE(CE), .S(sum1_1i) );
ADDER_16_16_17 SUM2_1i (.A(prdt2_i_tmp1), .B(prdt2_i_tmp2), .CLK(clk), .CE(CE), .S(sum2_1i) );
ADDER_16_16_17 SUM3_1i (.A(prdt3_i_tmp1), .B(prdt3_i_tmp2), .CLK(clk), .CE(CE), .S(sum3_1i) );
ADDER_16_16_17 SUM4_1i (.A(prdt4_i_tmp1), .B(prdt4_i_tmp2), .CLK(clk), .CE(CE), .S(sum4_1i) );
ADDER_16_16_17 SUM5_1i (.A(prdt5_i_tmp1), .B(prdt5_i_tmp2), .CLK(clk), .CE(CE), .S(sum5_1i) );
ADDER_16_16_17 SUM6_1i (.A(prdt6_i_tmp1), .B(prdt6_i_tmp2), .CLK(clk), .CE(CE), .S(sum6_1i) );
ADDER_16_16_17 SUM7_1i (.A(prdt7_i_tmp1), .B(prdt7_i_tmp2), .CLK(clk), .CE(CE), .S(sum7_1i) );
ADDER_16_16_17 SUM8_1i (.A(prdt8_i_tmp1), .B(prdt8_i_tmp2), .CLK(clk), .CE(CE), .S(sum8_1i) );

ADDER_16_16_17 SUM1_2i (.A(prdt1_i_tmp3), .B(bias0_delay7), .CLK(clk), .CE(CE), .S(sum1_2i) );
ADDER_16_16_17 SUM2_2i (.A(prdt2_i_tmp3), .B(bias1_delay7), .CLK(clk), .CE(CE), .S(sum2_2i) );
ADDER_16_16_17 SUM3_2i (.A(prdt3_i_tmp3), .B(bias2_delay7), .CLK(clk), .CE(CE), .S(sum3_2i) );
ADDER_16_16_17 SUM4_2i (.A(prdt4_i_tmp3), .B(bias3_delay7), .CLK(clk), .CE(CE), .S(sum4_2i) );
ADDER_16_16_17 SUM5_2i (.A(prdt5_i_tmp3), .B(bias4_delay7), .CLK(clk), .CE(CE), .S(sum5_2i) );
ADDER_16_16_17 SUM6_2i (.A(prdt6_i_tmp3), .B(bias5_delay7), .CLK(clk), .CE(CE), .S(sum6_2i) );
ADDER_16_16_17 SUM7_2i (.A(prdt7_i_tmp3), .B(bias6_delay7), .CLK(clk), .CE(CE), .S(sum7_2i) );
ADDER_16_16_17 SUM8_2i (.A(prdt8_i_tmp3), .B(bias7_delay7), .CLK(clk), .CE(CE), .S(sum8_2i) );
                                                
ADDER_16_16_17 SUM1i   (.A({sum1_1i[16],sum1_1i[14:0]}), .B({sum1_2i[16],sum1_2i[14:0]}), .CLK(clk), .CE(CE), .S(sum1i) );
ADDER_16_16_17 SUM2i   (.A({sum2_1i[16],sum2_1i[14:0]}), .B({sum2_2i[16],sum2_2i[14:0]}), .CLK(clk), .CE(CE), .S(sum2i) );
ADDER_16_16_17 SUM3i   (.A({sum3_1i[16],sum3_1i[14:0]}), .B({sum3_2i[16],sum3_2i[14:0]}), .CLK(clk), .CE(CE), .S(sum3i) );
ADDER_16_16_17 SUM4i   (.A({sum4_1i[16],sum4_1i[14:0]}), .B({sum4_2i[16],sum4_2i[14:0]}), .CLK(clk), .CE(CE), .S(sum4i) );
ADDER_16_16_17 SUM5i   (.A({sum5_1i[16],sum5_1i[14:0]}), .B({sum5_2i[16],sum5_2i[14:0]}), .CLK(clk), .CE(CE), .S(sum5i) );
ADDER_16_16_17 SUM6i   (.A({sum6_1i[16],sum6_1i[14:0]}), .B({sum6_2i[16],sum6_2i[14:0]}), .CLK(clk), .CE(CE), .S(sum6i) );
ADDER_16_16_17 SUM7i   (.A({sum7_1i[16],sum7_1i[14:0]}), .B({sum7_2i[16],sum7_2i[14:0]}), .CLK(clk), .CE(CE), .S(sum7i) );
ADDER_16_16_17 SUM8i   (.A({sum8_1i[16],sum8_1i[14:0]}), .B({sum8_2i[16],sum8_2i[14:0]}), .CLK(clk), .CE(CE), .S(sum8i) );

// q 
MULT_16X16 product_1q (.CLK(clk), .A(weight0_shift[15:0]), .B(input_q_shift[15:0]), .CE(CE), .P(prdt1_q) );
MULT_16X16 product_2q (.CLK(clk), .A(weight1_shift[15:0]), .B(input_q_shift[15:0]), .CE(CE), .P(prdt2_q) );
MULT_16X16 product_3q (.CLK(clk), .A(weight2_shift[15:0]), .B(input_q_shift[15:0]), .CE(CE), .P(prdt3_q) );
MULT_16X16 product_4q (.CLK(clk), .A(weight3_shift[15:0]), .B(input_q_shift[15:0]), .CE(CE), .P(prdt4_q) );
MULT_16X16 product_5q (.CLK(clk), .A(weight4_shift[15:0]), .B(input_q_shift[15:0]), .CE(CE), .P(prdt5_q) );
MULT_16X16 product_6q (.CLK(clk), .A(weight5_shift[15:0]), .B(input_q_shift[15:0]), .CE(CE), .P(prdt6_q) );
MULT_16X16 product_7q (.CLK(clk), .A(weight6_shift[15:0]), .B(input_q_shift[15:0]), .CE(CE), .P(prdt7_q) );
MULT_16X16 product_8q (.CLK(clk), .A(weight7_shift[15:0]), .B(input_q_shift[15:0]), .CE(CE), .P(prdt8_q) );

ADDER_16_16_17 SUM1_1q (.A(prdt1_q_tmp1), .B(prdt1_q_tmp2), .CLK(clk), .CE(CE), .S(sum1_1q) );
ADDER_16_16_17 SUM2_1q (.A(prdt2_q_tmp1), .B(prdt2_q_tmp2), .CLK(clk), .CE(CE), .S(sum2_1q) );
ADDER_16_16_17 SUM3_1q (.A(prdt3_q_tmp1), .B(prdt3_q_tmp2), .CLK(clk), .CE(CE), .S(sum3_1q) );
ADDER_16_16_17 SUM4_1q (.A(prdt4_q_tmp1), .B(prdt4_q_tmp2), .CLK(clk), .CE(CE), .S(sum4_1q) );
ADDER_16_16_17 SUM5_1q (.A(prdt5_q_tmp1), .B(prdt5_q_tmp2), .CLK(clk), .CE(CE), .S(sum5_1q) );
ADDER_16_16_17 SUM6_1q (.A(prdt6_q_tmp1), .B(prdt6_q_tmp2), .CLK(clk), .CE(CE), .S(sum6_1q) );
ADDER_16_16_17 SUM7_1q (.A(prdt7_q_tmp1), .B(prdt7_q_tmp2), .CLK(clk), .CE(CE), .S(sum7_1q) );
ADDER_16_16_17 SUM8_1q (.A(prdt8_q_tmp1), .B(prdt8_q_tmp2), .CLK(clk), .CE(CE), .S(sum8_1q) );
                                                                                         
ADDER_16_16_17 SUM1_2q (.A(prdt1_q_tmp3), .B(bias0_delay7), .CLK(clk), .CE(CE), .S(sum1_2q) );
ADDER_16_16_17 SUM2_2q (.A(prdt2_q_tmp3), .B(bias1_delay7), .CLK(clk), .CE(CE), .S(sum2_2q) );
ADDER_16_16_17 SUM3_2q (.A(prdt3_q_tmp3), .B(bias2_delay7), .CLK(clk), .CE(CE), .S(sum3_2q) );
ADDER_16_16_17 SUM4_2q (.A(prdt4_q_tmp3), .B(bias3_delay7), .CLK(clk), .CE(CE), .S(sum4_2q) );
ADDER_16_16_17 SUM5_2q (.A(prdt5_q_tmp3), .B(bias4_delay7), .CLK(clk), .CE(CE), .S(sum5_2q) );
ADDER_16_16_17 SUM6_2q (.A(prdt6_q_tmp3), .B(bias5_delay7), .CLK(clk), .CE(CE), .S(sum6_2q) );
ADDER_16_16_17 SUM7_2q (.A(prdt7_q_tmp3), .B(bias6_delay7), .CLK(clk), .CE(CE), .S(sum7_2q) );
ADDER_16_16_17 SUM8_2q (.A(prdt8_q_tmp3), .B(bias7_delay7), .CLK(clk), .CE(CE), .S(sum8_2q) );
                                                
ADDER_16_16_17 SUM1q   (.A({sum1_1q[16],sum1_1q[14:0]}), .B({sum1_2q[16],sum1_2q[14:0]}), .CLK(clk), .CE(CE), .S(sum1q) );
ADDER_16_16_17 SUM2q   (.A({sum2_1q[16],sum2_1q[14:0]}), .B({sum2_2q[16],sum2_2q[14:0]}), .CLK(clk), .CE(CE), .S(sum2q) );
ADDER_16_16_17 SUM3q   (.A({sum3_1q[16],sum3_1q[14:0]}), .B({sum3_2q[16],sum3_2q[14:0]}), .CLK(clk), .CE(CE), .S(sum3q) );
ADDER_16_16_17 SUM4q   (.A({sum4_1q[16],sum4_1q[14:0]}), .B({sum4_2q[16],sum4_2q[14:0]}), .CLK(clk), .CE(CE), .S(sum4q) );
ADDER_16_16_17 SUM5q   (.A({sum5_1q[16],sum5_1q[14:0]}), .B({sum5_2q[16],sum5_2q[14:0]}), .CLK(clk), .CE(CE), .S(sum5q) );
ADDER_16_16_17 SUM6q   (.A({sum6_1q[16],sum6_1q[14:0]}), .B({sum6_2q[16],sum6_2q[14:0]}), .CLK(clk), .CE(CE), .S(sum6q) );
ADDER_16_16_17 SUM7q   (.A({sum7_1q[16],sum7_1q[14:0]}), .B({sum7_2q[16],sum7_2q[14:0]}), .CLK(clk), .CE(CE), .S(sum7q) );
ADDER_16_16_17 SUM8q   (.A({sum8_1q[16],sum8_1q[14:0]}), .B({sum8_2q[16],sum8_2q[14:0]}), .CLK(clk), .CE(CE), .S(sum8q) );



FIFO_32X256  INPUT_BUFFER(
  .clk			(clk),      // input wire clk
  .srst			(!rst_n),    // input wire srst
  .din			({din_q,din_i})  ,    // input wire [31 : 0] din
  .wr_en		(din_valid),  	// input wire wr_en
  .rd_en		(rd_en),  	// input wire rd_en
  .dout			(dout),    // output wire [31 : 0] dout
  .full			(full),    // output wire full
  .empty		(empty)  	// output wire empty
);




endmodule