#include "Fw_global_config.h"   // This defines application specific charactersitics
#include "qf_hardwaresetup.h"

#include "fpga_loader.h"  // API for loading FPGA
#include "pwmCPU_bit.h"   // FPGA bitstream to load into FPGA

#include "s3x_clock.h"

#include "FreeRTOS.h"

#include "cli.h"

typedef struct fpga_pwm_regs {
    uint32_t    duty;   // 0x00
    uint32_t    period; // 0x04
    uint32_t    cfg;    // 0x08
} fpga_pwm_regs_t;


fpga_pwm_regs_t* pwm_regs = (fpga_pwm_regs_t*)(FPGA_PERIPH_BASE);

void Delay(uint32_t nCount) {
	volatile uint32_t count = nCount;
	for (; count != 0; count--) __asm__("nop");
}

static void cfg_period(const struct cli_cmd_entry *pEntry)
{
	uint32_t uxValue;
	CLI_uint32_getshow( "value", &uxValue );
	pwm_regs->period = uxValue;
}

static void cfg_duty(const struct cli_cmd_entry *pEntry)
{
	uint32_t uxValue;
	CLI_uint32_getshow( "value", &uxValue );
	pwm_regs->duty = uxValue;
}

static void cfg_invert(const struct cli_cmd_entry *pEntry)
{
	uint32_t uxValue;
	uint32_t reg;
	
	/* get command param */
	CLI_uint32_getshow( "value", &uxValue );

	/* read prev status, unset invert bit */
	reg = pwm_regs->cfg & (~(1 << 1));
	reg |= ((uxValue & 0x01) << 1);

	/* set new cfg */
	pwm_regs->cfg = reg;
}

static void cfg_enable(const struct cli_cmd_entry *pEntry)
{
	uint32_t uxValue;
	uint32_t reg;

	/* get command param */
	CLI_uint32_getshow( "value", &uxValue );

	/* read prev status, unset invert bit */
	reg = pwm_regs->cfg & ~(1 << 0);
	reg |= ((uxValue & 0x01) << 0);

	/* set new cfg */
	pwm_regs->cfg = reg;
}

const struct cli_cmd_entry my_main_menu[] = {
    CLI_CMD_SIMPLE("period", cfg_period, "toggle red led" ),
    CLI_CMD_SIMPLE("duty", cfg_duty, "toggle green led" ),
    CLI_CMD_SIMPLE("invert", cfg_invert, "toggle blue led" ),
    CLI_CMD_SIMPLE("enable", cfg_enable, "show state of user button" ),
    CLI_CMD_TERMINATE()
};

const char *SOFTWARE_VERSION_STR;

int main(void)
{
	SOFTWARE_VERSION_STR = "pwmCPU_FPGACLI";
    qf_hardwareSetup();

	/* required to received user instructions */
    NVIC_SetPriority(Uart_IRQn, configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY);

	S3x_Clk_Disable(S3X_FB_21_CLK);
	S3x_Clk_Disable(S3X_FB_16_CLK);

	load_fpga(sizeof(axFPGABitStream),axFPGABitStream);     // Load bitstrem into FPGA

	S3x_Clk_Enable(S3X_FB_21_CLK);                          // Start FPGA clock
	S3x_Clk_Enable(S3X_FB_16_CLK);

	pwm_regs->period = 1 * 1000 * 1000; // 1s
	pwm_regs->duty = 200 * 1000; // 0.2s
	pwm_regs->cfg = 1;

	CLI_start_task(my_main_menu);

	vTaskStartScheduler();
      
	while(1);
}

//needed for startup_EOSS3b.s asm file
void SystemInit(void) {}
