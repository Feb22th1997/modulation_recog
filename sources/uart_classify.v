module uart_classify 
#(parameter CLK_FRE = 60,     //clock frequency(Mhz)        ÐÞ¸Ä
  parameter BAUD_RATE = 115200 //serial baud rate
)
(
    input clk,
    input rst_n,
    input [7:0]classify_result,
    input classify_result_vld,
    output uart_tx
);

wire [7:0]write_data;
wire [7:0]read_data;
wire wr_en;
reg rd_en;
wire full,empty;

assign write_data = classify_result;
assign wr_en = (~full)&(classify_result_vld);

FIFO_8X1024 uart_buffer (
  .clk  (clk       ),   // input wire clk
  .srst (~rst_n     ),   // input wire srst
  .din  (write_data),   // input wire [7 : 0] din
  .wr_en(wr_en     ),   // input wire wr_en
  .rd_en(rd_en     ),   // input wire rd_en
  .dout (read_data ),   // output wire [7 : 0] dout
  .full (full      ),   // output wire full
  .empty(empty     )    // output wire empty
);

wire tx_data_ready;
wire [7:0]tx_data;
reg tx_data_valid;
reg [1:0]tx_stage;

assign tx_data = read_data;

always @(posedge clk) begin
    if(~rst_n) begin
        rd_en <= 1'b0;
        tx_stage <= 2'b00;
    end
    else begin
        case(tx_stage)
        2'b00: begin
            if(tx_data_ready==1'b1 && empty==1'b0) begin
                tx_stage <= 2'b01;
            end
            tx_data_valid <= 1'b0;
            rd_en <= 1'b0;
        end
        2'b01: begin
            rd_en <= 1'b1;
            tx_stage <= 2'b10;
        end
        2'b10: begin
            rd_en <= 1'b0;
            tx_data_valid <= 1'b1;
            tx_stage <= 2'b11;
        end
        2'b11: begin
            tx_data_valid <= 1'b0;
            if(tx_data_ready==1'b0) tx_stage <= 2'b00;
        end
        default: ;
        endcase
    end
end

my_uart_tx
#(
	.CLK_FRE   (CLK_FRE  ),     //clock frequency(Mhz)        ÐÞ¸Ä
	.BAUD_RATE (BAUD_RATE) //serial baud rate
)
(
.clk           (clk            ),   //clock input                                input         clk            
.rst_n         (rst_n          ),   //asynchronous reset input, low active       input         rst_n          
.tx_data       (tx_data        ),  //data to send                                input[7:0]    tx_data        
.tx_data_valid (tx_data_valid  ),   //data to be sent is valid                   input         tx_data_valid  
.tx_data_ready (tx_data_ready  ),   //send ready                                 output reg    tx_data_ready  
.tx_pin        (uart_tx        )   //serial data output                        output        tx_pin         
);

endmodule