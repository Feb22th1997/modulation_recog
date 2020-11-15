`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/12 19:06:36
// Design Name: 
// Module Name: dense_mult
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


module dense_mult(
    input clk,
    input rst_n,
    input [10:0]addr_weights,
    input [15:0]x,     
    output [15:0]wx
    );
    
    wire [15:0]w;
    wire [31:0]wxReg;
    
    blk_mem_dense_weights dense_weights_rom (
      .clka(clk),    // input wire clka
      .addra(addr_weights),  // input wire [10 : 0] addra
      .douta(w)  // output wire [15 : 0] douta
    );
    mult_dense_u0 dense_wx_mult (
      .CLK(clk),  // input wire CLK
      .A(x),      // input wire [15 : 0] A  		 (1,3,12)
      .B(w),      // input wire [15 : 0] B			(1,3,12)
      .P(wxReg)      // output wire [31 : 0] P
    );
    
    //assign wx = {wxReg[31],wxReg[26:24],wxReg[23:12]};  //(1,3,12)
	assign wx = {wxReg[31],wxReg[29:24],wxReg[23:15]};   // (1,6,9)
    
endmodule
