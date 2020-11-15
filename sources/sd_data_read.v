`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/21 15:24:24
// Design Name: 
// Module Name: sd_data_read
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


module sd_data_read(
    input clk,
    input rst_n,
    input outreq,
    input [7:0]outbyte,
    output reg [31:0]sd_data,
    output reg sd_data_valid
    );
    
    reg [31:0]read_data;
    
    reg trans_flag;
    reg [1:0]stage;
    reg[3:0]count;
    
    
    
    always @(posedge clk) begin
        if(~rst_n) begin
            trans_flag <= 1'b0;
            stage <= 2'b00;
            count <= 4'd0;
            read_data <= 32'd0;
        end
        else begin
            case(stage)
            2'b00: begin
                if(outreq==1 && outbyte==8'h0a) begin
                    stage <= 2'b01;
                end
            end
            2'b01: begin
                if(outreq==1) begin
                    if(outbyte==8'h2f)  begin //以"/"结尾，表示结束读取
                        stage <= 2'b00;
                    end
                    else if(outbyte==8'h2c) begin   //以","结尾，表示该行读取结束
                        stage <= 2'b10;
                        trans_flag <= 1'b1;
                    end
                    else begin
                        case(count)
                        4'd0: begin
                            case(outbyte)
                            8'h41: read_data[31:28] <= 4'hA;
                            8'h42: read_data[31:28] <= 4'hB;
                            8'h43: read_data[31:28] <= 4'hC;
                            8'h44: read_data[31:28] <= 4'hD;
                            8'h45: read_data[31:28] <= 4'hE;
                            8'h46: read_data[31:28] <= 4'hF;
                            default: read_data[31:28] <= outbyte[3:0];  //最高位和最低位与实际相反
                            endcase
                        end
                        4'd1: begin
                            case(outbyte)
                            8'h41: read_data[27:24] <= 4'hA;
                            8'h42: read_data[27:24] <= 4'hB;
                            8'h43: read_data[27:24] <= 4'hC;
                            8'h44: read_data[27:24] <= 4'hD;
                            8'h45: read_data[27:24] <= 4'hE;
                            8'h46: read_data[27:24] <= 4'hF;
                            default: read_data[27:24] <= outbyte[3:0];  //最高位和最低位与实际相反
                            endcase
                        end
                        4'd2: begin
                            case(outbyte)
                            8'h41: read_data[23:20] <= 4'hA;
                            8'h42: read_data[23:20] <= 4'hB;
                            8'h43: read_data[23:20] <= 4'hC;
                            8'h44: read_data[23:20] <= 4'hD;
                            8'h45: read_data[23:20] <= 4'hE;
                            8'h46: read_data[23:20] <= 4'hF;
                            default: read_data[23:20] <= outbyte[3:0];  //最高位和最低位与实际相反
                            endcase
                        end
                        4'd3: begin
                            case(outbyte)
                            8'h41: read_data[19:16] <= 4'hA;
                            8'h42: read_data[19:16] <= 4'hB;
                            8'h43: read_data[19:16] <= 4'hC;
                            8'h44: read_data[19:16] <= 4'hD;
                            8'h45: read_data[19:16] <= 4'hE;
                            8'h46: read_data[19:16] <= 4'hF;
                            default: read_data[19:16] <= outbyte[3:0];  //最高位和最低位与实际相反
                            endcase
                        end
                        4'd4: begin
                            case(outbyte)
                            8'h41: read_data[15:12] <= 4'hA;
                            8'h42: read_data[15:12] <= 4'hB;
                            8'h43: read_data[15:12] <= 4'hC;
                            8'h44: read_data[15:12] <= 4'hD;
                            8'h45: read_data[15:12] <= 4'hE;
                            8'h46: read_data[15:12] <= 4'hF;
                            default: read_data[15:12] <= outbyte[3:0];  //最高位和最低位与实际相反
                            endcase
                        end
                        4'd5: begin
                            case(outbyte)
                            8'h41: read_data[11:8] <= 4'hA;
                            8'h42: read_data[11:8] <= 4'hB;
                            8'h43: read_data[11:8] <= 4'hC;
                            8'h44: read_data[11:8] <= 4'hD;
                            8'h45: read_data[11:8] <= 4'hE;
                            8'h46: read_data[11:8] <= 4'hF;
                            default: read_data[11:8] <= outbyte[3:0];  //最高位和最低位与实际相反
                            endcase
                        end
                        4'd6: begin
                            case(outbyte)
                            8'h41: read_data[7:4] <= 4'hA;
                            8'h42: read_data[7:4] <= 4'hB;
                            8'h43: read_data[7:4] <= 4'hC;
                            8'h44: read_data[7:4] <= 4'hD;
                            8'h45: read_data[7:4] <= 4'hE;
                            8'h46: read_data[7:4] <= 4'hF;
                            default: read_data[7:4] <= outbyte[3:0];  //最高位和最低位与实际相反
                            endcase
                        end
                        4'd7: begin
                            case(outbyte)
                            8'h41: read_data[3:0] <= 4'hA;
                            8'h42: read_data[3:0] <= 4'hB;
                            8'h43: read_data[3:0] <= 4'hC;
                            8'h44: read_data[3:0] <= 4'hD;
                            8'h45: read_data[3:0] <= 4'hE;
                            8'h46: read_data[3:0] <= 4'hF;
                            default: read_data[3:0] <= outbyte[3:0];  //最高位和最低位与实际相反
                            endcase
                        end
                        default: ;
                        endcase
                        count <= count + 1;
                    end
                end
            end
            2'b10: begin
                trans_flag <= 1'b0;
                count <= 4'd0;
                read_data <= 32'd0;
                if((outreq==1) && (outbyte==8'h0a)) begin
                    stage <= 2'b01;
                end
            end
            default: ;
            endcase
        end
    end
    
    //数据输入
    always @(posedge clk) begin
        if(~rst_n) begin
            sd_data <= 32'd0;
        end
        else begin
            if(trans_flag==1'b1) begin
                sd_data <= read_data;
                sd_data_valid <= 1'b1;
            end
            else begin
                sd_data <= 32'd0;
                sd_data_valid <= 1'b0;
            end
        end
    end
    
endmodule
