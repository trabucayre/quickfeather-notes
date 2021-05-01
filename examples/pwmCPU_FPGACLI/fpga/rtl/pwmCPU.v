`timescale 1ns / 10ps

module pwmCPU ( 
	output pwm_o /* J8.13 */
);

// FPGA Global Signals
//
wire WB_CLK;       // Selected FPGA Clock
wire WB_RST;      
wire WB_RST_FPGA; 

wire Sys_Clk0;     // Selected FPGA Clock
wire Sys_Clk0_Rst; // Selected FPGA Reset

wire Sys_Clk1;     // Selected FPGA Clock
wire Sys_Clk1_Rst; // Selected FPGA Reset

// CANDR
wire clk, reset;

// Determine the FPGA reset
// Note: Reset the FPGA IP on either the AHB or clock domain reset signals.

/* use clk0 as ref clock for wishbone */
gclkbuff u_gclkbuff_reset ( .A(Sys_Clk0_Rst | WB_RST), .Z(WB_RST_FPGA));
gclkbuff u_gclkbuff_clock ( .A(Sys_Clk0             ), .Z(WB_CLK     ));
/* use clk1 for the rest */
gclkbuff u_gclkbuff_reset1 (.A(Sys_Clk1_Rst), .Z(reset));
gclkbuff u_gclkbuff_clock1 (.A(Sys_Clk1    ), .Z(clk  ));

wire [16:0] WBs_ADR;
wire WBs_ACK, WBs_CYC, WBs_WE, WBs_STB;

wire [31:0] WBs_RD_DAT;
wire [31:0] WBs_WR_DAT;

pwm_core pwm_core_inst ( 
	.clk_i(clk),
	.rst_i(reset),
	.WBs_CLK_i(WB_CLK),
	.WBs_RST_i(WB_RST_FPGA),
	.WBs_ADR_i(WBs_ADR[3:2]),
	.WBs_CYC_i(WBs_CYC),
	.WBs_WE_i(WBs_WE),
	.WBs_STB_i(WBs_STB),
	.WBs_DAT_i(WBs_WR_DAT),
	.WBs_DAT_o(WBs_RD_DAT),
	.WBs_ACK_o(WBs_ACK),
	.pwm_o(pwm_o)
);

/* Empty Verilog model of QLAL4S3B */
qlal4s3b_cell_macro u_qlal4s3b_cell_macro (
    // AHB-To-FPGA Bridge
    .WBs_ADR(WBs_ADR),       // output [16:0] | Address Bus                to   FPGA
    .WBs_CYC(WBs_CYC),       // output        | Cycle Chip Select          to   FPGA
    .WBs_BYTE_STB(),         // output  [3:0] | Byte Select                to   FPGA
    .WBs_WE(WBs_WE),         // output        | Write Enable               to   FPGA
    .WBs_RD(),               // output        | Read  Enable               to   FPGA
    .WBs_STB(WBs_STB),       // output        | Strobe Signal              to   FPGA
    .WBs_WR_DAT(WBs_WR_DAT), // output [31:0] | Write Data Bus             to   FPGA
    .WB_CLK(WB_CLK),         // input         | FPGA Clock                 from FPGA
    .WB_RST(WB_RST),         // output        | FPGA Reset                 to   FPGA
    .WBs_RD_DAT(WBs_RD_DAT), // input  [31:0] | Read Data Bus              from FPGA
    .WBs_ACK(WBs_ACK),       // input         | Transfer Cycle Acknowledge from FPGA
    /* SDMA Signals */
    .SDMA_Req(4'b0000), .SDMA_Sreq(4'b0000), .SDMA_Done(), .SDMA_Active(),
    /* FB Interrupts */
    .FB_msg_out(4'b0000), .FB_Int_Clr(8'h0),
	.FB_Start(), .FB_Busy(1'b0),
    /* FB Clocks */
    .Sys_Clk0    (Sys_Clk0    ), // output
    .Sys_Clk0_Rst(Sys_Clk0_Rst), // output
    .Sys_Clk1    (Sys_Clk1    ), // output
    .Sys_Clk1_Rst(Sys_Clk1_Rst), // output
    /* Packet FIFO */
    .Sys_PKfb_Clk( 1'b0), .Sys_PKfb_Rst(), .FB_PKfbData(32'h0), .FB_PKfbPush(4'h0), 
    .FB_PKfbSOF(1'b0), .FB_PKfbEOF(1'b0), .FB_PKfbOverflow(),
	/* Sensor Interface */
    .Sensor_Int(), .TimeStamp(),
    /* SPI Master APB Bus */
    .Sys_Pclk(), .Sys_Pclk_Rst(), .Sys_PSel(1'b0), .SPIm_Paddr(16'h0),
    .SPIm_PEnable(1'b0), .SPIm_PWrite(1'b0), .SPIm_PWdata(32'h0),
    .SPIm_Prdata(), .SPIm_PReady(), .SPIm_PSlvErr(),
    /* Misc */
    .Device_ID(16'hCAFE),
    /* FBIO Signals */
    .FBIO_In(), .FBIO_In_En(), .FBIO_Out(), .FBIO_Out_En(),
	/* ??? */
    .SFBIO           (    ), // inout  [13:0]
    .Device_ID_6S    (1'b0), // input
    .Device_ID_4S    (1'b0), // input
    .SPIm_PWdata_26S (1'b0), // input
    .SPIm_PWdata_24S (1'b0), // input
    .SPIm_PWdata_14S (1'b0), // input
    .SPIm_PWdata_11S (1'b0), // input
    .SPIm_PWdata_0S  (1'b0), // input
    .SPIm_Paddr_8S   (1'b0), // input
    .SPIm_Paddr_6S   (1'b0), // input
    .FB_PKfbPush_1S  (1'b0), // input
    .FB_PKfbData_31S (1'b0), // input
    .FB_PKfbData_21S (1'b0), // input
    .FB_PKfbData_19S (1'b0), // input
    .FB_PKfbData_9S  (1'b0), // input
    .FB_PKfbData_6S  (1'b0), // input
    .Sys_PKfb_ClkS   (1'b0), // input
    .FB_BusyS        (1'b0), // input
    .WB_CLKS         (1'b0)  // input
);

endmodule
