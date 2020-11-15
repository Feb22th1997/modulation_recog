`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/12 16:56:59
// Design Name: 
// Module Name: denseLayer_sim
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

//  input(1,3,12)
// weights  
//bias   (1,3,12)
//output (1,3,12)
module denseLayer_sim(

    );
    parameter clk_period = 10;
    parameter data_length = 128000;
    
    reg clk,rst_n;
    reg [15:0]din;
    reg din_valid;
    wire [15:0]dout;
    wire dout_valid;
    
    denseLayer denseLayer_test(
        .clk(clk),
        .rst_n(rst_n),
        .dense_din(din),    //输入：[1,3,12]--(符号位，整数位，小数�?)
        .dense_din_vld(din_valid),    //128个输入的�?始标�?
        .dout(dout), //输出：[1,3,12]
        .dout_valid(dout_valid)  //11个输出的�?始标�?
    );
    
    always #5 clk = ~clk;
    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        din = 16'd0;
        din_valid = 1'b0;
        #500
        rst_n = 1'b1;
    end
    
    integer Pattern;
    integer cnt;
    reg [15:0]stimulus[1:data_length];
    initial begin
        $readmemh("D:/Modulation_recognition/dense/weights/forSIm/dense_inputv1.txt",stimulus);
        #1000
        din_valid = 1'b1;
        Pattern = 0;
        cnt = 1;
        repeat(data_length) 
        begin
            din_valid = 1'b1;
            Pattern = Pattern + 1;
            din = stimulus[Pattern];
            #clk_period;
            if(Pattern==(cnt*128)) begin
                din_valid = 1'b0;
                #15000
                cnt = cnt + 1;
            end
        end
        din_valid = 1'b0;
        
        // #14200
        // din_valid = 1'b1;
        // Pattern = 0;
        // repeat(data_length) 
        // begin
            // Pattern = Pattern + 1;
            // din = stimulus[Pattern];
            // #clk_period;
        // end
        // din_valid = 1'b0;
    end
    
endmodule
