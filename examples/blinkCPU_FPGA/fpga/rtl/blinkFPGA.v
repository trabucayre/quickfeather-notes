module blinkFPGA(
    output reg blueled
);
    wire clk, rst;
    /* CPU <-> FPGA interface
     * here only one of the two clock sources
     * and corresponding reset signal are used
	 * Sys_Clk0/Sys_Clk0_Rst: C16 clock domain
	 * Sys_Clk1/Sys_Clk1_Rst: C21 clock domain
	 */
    qlal4s3b_cell_macro u_qlal4s3b_cell_macro (
        .Sys_Clk0 (clk),
		.Sys_Clk0_Rst(rst),
		.Sys_Clk1     (),
		.Sys_Clk1_Rst ()
    );

    reg [23:0]  cnt;
	wire        rst_cnt = cnt == 6000000-1;

    always @(posedge clk) begin
        /* increment cnt until rst or rst_cnt
         * are asserted
         */
		if (rst || rst_cnt)
			cnt <= 0;
		else
    	    cnt <= cnt + 1;
        /* when rst is asserted set default LED state
         * and when rst_cnt is asserted change state
         */
		if (rst)
			blueled <= 1'b0;
		else if (rst_cnt)
			blueled <= ~blueled;
    end
endmodule
