#include "Fw_global_config.h"   // This defines application specific charactersitics
#include "qf_hardwaresetup.h"

#include "s3x_clock.h"

#include "FreeRTOS.h"

#include "cli.h"

#include "generated/csr.h" // LiteX header

#define LED_BLUE  (1 << 0)
#define LED_GREEN (1 << 1)
#define LED_RED   (1 << 2)

void Delay(uint32_t nCount) {
	volatile uint32_t count = nCount;
	for (; count != 0; count--) __asm__("nop");
}

static void cfg_red(const struct cli_cmd_entry *pEntry)
{
	uint32_t leds = leds_out_read() ^ LED_RED;
	leds_out_write(leds);
}

static void cfg_green(const struct cli_cmd_entry *pEntry)
{
	uint32_t leds = leds_out_read() ^ LED_GREEN;
	leds_out_write(leds);
}

static void cfg_blue(const struct cli_cmd_entry *pEntry)
{
	uint32_t leds = leds_out_read() ^ LED_BLUE;
	leds_out_write(leds);
}

static void cfg_custom(const struct cli_cmd_entry *pEntry)
{
	uint32_t leds;
	/* get command param */
	CLI_uint32_getshow( "value", &leds);
	leds_out_write(leds);
}

const struct cli_cmd_entry my_main_menu[] = {
    CLI_CMD_SIMPLE("red",    cfg_red,    "toggle red led"),
    CLI_CMD_SIMPLE("green",  cfg_green,  "toggle green led"),
    CLI_CMD_SIMPLE("blue",   cfg_blue,   "toggle blue led"),
    CLI_CMD_SIMPLE("custom", cfg_custom, "direct led write"),
    CLI_CMD_TERMINATE()
};

const char *SOFTWARE_VERSION_STR;

int main(void)
{
	SOFTWARE_VERSION_STR = "litex-basic";
    qf_hardwareSetup();

	/* required to received user instructions */
    NVIC_SetPriority(Uart_IRQn, configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY);

	S3x_Clk_Enable(S3X_FB_21_CLK); // Start FPGA clock
	S3x_Clk_Enable(S3X_FB_16_CLK);

	CLI_start_task(my_main_menu);

	vTaskStartScheduler();
      
	while(1);
}

//needed for startup_EOSS3b.s asm file
void SystemInit(void) {}
