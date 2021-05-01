`timescale 1ns / 10ps

module pwm_core (
	input             clk_i,
	input             rst_i,
	input             WBs_CLK_i, // FPGA Clock     from FPGA
	input             WBs_RST_i, // FPGA Reset     to   FPGA
	input      [1:0]  WBs_ADR_i, // Address Bus    to   FPGA
	input             WBs_CYC_i, // Cycle CS       to   FPGA
	input             WBs_WE_i,  // Write Enable   to   FPGA
	input             WBs_STB_i, // Strobe Signal  to   FPGA
	input      [31:0] WBs_DAT_i, // Write Data Bus to   FPGA
	output     [31:0] WBs_DAT_o, // Read Data Bus  from FPGA
	output reg        WBs_ACK_o, // Tx Ack         from FPGA

	output pwm_o /* J8.13 */
);

/* pwm control
 * 24bits @ 1MHz -> 10s
 */
localparam PWM_CPT_SZ = 24;

reg [PWM_CPT_SZ-1:0] pwm_duty_s, pwm_period_s;
reg [ 1:0] pwm_cfg_s;
reg [PWM_CPT_SZ-1:0] pwm_cpt;

wire pwm_en = pwm_cfg_s[0];
wire pwm_inv = pwm_cfg_s[1];

always @(posedge clk_i) begin
	if (rst_i || pwm_cpt == pwm_period_s -1) begin
		pwm_cpt <= {PWM_CPT_SZ, {1'b0}};
	end else begin
		pwm_cpt <= pwm_cpt + 1'b1;
	end
end

/* set pwm_o to high when pwm_cpt < duty cyle and pwm_en is set
 * invert the signal if pwm_inv is set
 */
assign pwm_o = ((pwm_cpt < pwm_duty_s -1) & pwm_en) ^ pwm_inv;

/* wishbone control */
wire wbs_ack_q = WBs_CYC_i & WBs_STB_i & (~WBs_ACK_o);
wire wbs_wen   = wbs_ack_q & WBs_WE_i;
reg  [PWM_CPT_SZ-1:0] WBs_DAT_q;

assign WBs_DAT_o = {{32-PWM_CPT_SZ{1'b0}}, WBs_DAT_q};

always @(posedge WBs_CLK_i) begin
	/* ack */
	WBs_ACK_o <= wbs_ack_q;

	/* write request */
	if (WBs_RST_i) begin
		pwm_duty_s <= {PWM_CPT_SZ, {1'b0}};
		pwm_period_s <= {PWM_CPT_SZ, {1'b0}};
		pwm_cfg_s <= 2'b0;
	end else if (wbs_wen) begin
		case (WBs_ADR_i)
		2'b00:
			pwm_duty_s <= WBs_DAT_i[PWM_CPT_SZ-1:0];
		2'b01:
			pwm_period_s <= WBs_DAT_i[PWM_CPT_SZ-1:0];
		2'b10:
			pwm_cfg_s <= WBs_DAT_i[1:0];
		endcase
	end

	/* read */
	case (WBs_ADR_i)
	2'b00:
		WBs_DAT_q <= pwm_duty_s;
	2'b01:
		WBs_DAT_q <= pwm_period_s;
	2'b10:
		WBs_DAT_q <= {{PWM_CPT_SZ-2{1'b0}}, pwm_cfg_s};
	default:
		WBs_DAT_q <= 0;
	endcase
end

endmodule
