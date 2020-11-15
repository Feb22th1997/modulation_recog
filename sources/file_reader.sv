// this example runs on Digilent Nexys4-DDR board (Xilinx Artix-7)
// see http://www.digilent.com.cn/products/product-nexys-4-ddr-artix-7-fpga-trainer-board.html
//

module file_reader #(parameter FILE_NAME    = "example.txt",  
                     parameter CLK_DIV     = 2,
                     parameter UART_CLK_DIV = 868)
(
    // clock = 100MHz
    // input            sys_clk_p,   //system clock positive
    // input            sys_clk_n,   //system clock negative
    input                clk,
    output               [3:0]a7_led,
    output               [31:0]sd_data,
    output               sd_data_valid,
    // rst_n active-low, You can re-scan and re-read SDcard by pushing the reset button.
    input  logic         RESETN,
    // when SD_RESET = 0, SDcard power on
    //output logic         SD_RESET,
    // signals connect to SD bus
    output logic         SD_SCK,
    inout                SD_CMD,
    input  logic [ 3:0]  SD_DAT,
    // 8 bit LED to show the status of SDcard
    //output logic [15:0]  LED,
    // UART tx signal, connected to host-PC's UART-RXD, baud=115200
    output logic         UART_TX
);

wire       outreq;    // when outreq=1, a byte of file content is read out from outbyte
wire [7:0] outbyte;   // a byte of file content
wire [15:0]LED;
assign a7_led = ~({LED[15],LED[10:8]});
assign { LED[7:6], LED[11], LED[14] } = 4'b0;
assign SD_RESET = 1'b0;

// For input and output definitions of this module, see SDFileReader.sv
SDFileReader #(
    .FILE_NAME      ( FILE_NAME      ),  // file to read, ignore Upper and Lower Case
                                         // For example, if you want to read a file named HeLLo123.txt in the SD card,
                                         // the parameter here can be hello123.TXT, HELLO123.txt or HEllo123.Txt
                                         
    .CLK_DIV        ( CLK_DIV        )  // when clk = 0~25MHz   , set CLK_DIV to 0,
                                        // when clk = 25~50MHz  , set CLK_DIV to 1,
                                        // when clk = 50~100MHz , set CLK_DIV to 2,
                                        // when clk = 100~200MHz, set CLK_DIV to 3,
                                        // when clk = 200~400MHz, set CLK_DIV to 4,
) sd_file_reader_inst (
    .clk            ( clk      ),
    .rst_n          ( RESETN         ),  // rst_n active low, re-scan and re-read SDcard by reset
    
    // signals connect to SD bus
    .sdclk          ( SD_SCK         ),
    .sdcmd          ( SD_CMD         ),
    .sddat          ( SD_DAT         ),
    
    // display information on 12bit LED
    .sdcardstate    ( LED[ 3: 0]     ),
    .sdcardtype     ( LED[ 5: 4]     ),  // 0=Unknown, 1=SDv1.1 , 2=SDv2 , 3=SDHCv2
    .fatstate       ( LED[10: 8]     ),  // 3'd6 = DONE
    .filesystemtype ( LED[13:12]     ),  // 0=Unknown, 1=invalid, 2=FAT16, 3=FAT32
    .file_found     ( LED[15   ]     ),  // 0=file not found, 1=file found
    
    // file content output interface
    .outreq         ( outreq         ),
    .outbyte        ( outbyte        )
);


// send file content to UART
/*
uart_tx #(
    .UART_CLK_DIV   ( UART_CLK_DIV   ),  // UART baud rate = clk freq/(2*UART_TX_CLK_DIV)
                                         // modify UART_TX_CLK_DIV to change the UART baud
                                         // for example, when clk=100MHz, UART_TX_CLK_DIV=868, then baud=100MHz/868=115200
                                         // 115200 is a typical SPI baud rate for UART
                                        
    // .FIFO_ASIZE     ( 14             ),  // UART TX buffer size=2^FIFO_ASIZE bytes, Set it smaller if your FPGA doesn't have enough BRAM
    .FIFO_ASIZE     ( 100             ), 
    .BYTE_WIDTH     ( 1              ),
    .MODE           ( 1              )
) uart_tx_inst (
    .clk            ( clk      ),
    .rst_n          ( RESETN         ),
    
    .wreq           ( outreq         ),
    .wgnt           (                ),
    .wdata          ( outbyte        ),
    
    .o_uart_tx      ( UART_TX        )
);
*/

sd_data_read sd_data_read_inst0(
    .clk           (clk    ),
    .rst_n         (RESETN       ),
    .outreq        (outreq       ),
    .outbyte       (outbyte      ),
    .sd_data       (sd_data      ),
    .sd_data_valid (sd_data_valid)
    );

endmodule
