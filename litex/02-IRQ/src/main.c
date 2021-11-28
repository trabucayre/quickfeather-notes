#include "Fw_global_config.h"   // This defines application specific charactersitics
#include "qf_hardwaresetup.h"

#include "eoss3_hal_def.h"  // FPGA interrupts

#include "dbg_uart.h"

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

static void cfg_status(const struct cli_cmd_entry *pEntry)
{
	uint32_t uxValue;
	uint32_t reg;

	/* get command param */
	CLI_uint32_getshow( "value", &uxValue );

	uint32_t pend = gpio_ev_pending_read();
	uint32_t status = gpio_ev_status_read();
	dbg_str("in ");
	dbg_hex32(gpio_in_read());
	dbg_str(" mode ");
	dbg_hex32(gpio_mode_read());
	dbg_str(" edge ");
	dbg_hex32(gpio_edge_read());
	dbg_str(" status ");
	dbg_hex32(status);
	dbg_str(" pending ");
	dbg_hex32(pend);
	dbg_str(" enable ");
	dbg_hex32(gpio_ev_enable_read());
	dbg_nl();
}

const struct cli_cmd_entry my_main_menu[] = {
    CLI_CMD_SIMPLE("red",    cfg_red,    "toggle red led"),
    CLI_CMD_SIMPLE("green",  cfg_green,  "toggle green led"),
    CLI_CMD_SIMPLE("blue",   cfg_blue,   "toggle blue led"),
    CLI_CMD_SIMPLE("custom", cfg_custom, "direct led write"),
    CLI_CMD_SIMPLE("status", cfg_status, "show state of user button"),
    CLI_CMD_TERMINATE()
};

const char *SOFTWARE_VERSION_STR;

static void fb_timer_isr(void)
{
	uint32_t pend = gpio_ev_pending_read();
	uint32_t status = gpio_ev_status_read();
	gpio_ev_enable_write(0);
	gpio_ev_pending_write(1);
	dbg_str("gpio fired ");
	dbg_nl();
	dbg_str("in ");
	dbg_hex32(gpio_in_read());
	dbg_str(" mode ");
	dbg_hex32(gpio_mode_read());
	dbg_str(" edge ");
	dbg_hex32(gpio_edge_read());
	dbg_str(" status ");
	dbg_hex32(status);
	dbg_str(" pending ");
	dbg_hex32(pend);
	dbg_str(" enable ");
	dbg_hex32(gpio_ev_enable_read());
	dbg_nl();
	gpio_ev_enable_write(1);
}

int main(void)
{
	SOFTWARE_VERSION_STR = "LiteX_IRQ";
    qf_hardwareSetup();

	/* required to received user instructions */
    NVIC_SetPriority(Uart_IRQn, configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY);

	S3x_Clk_Enable(S3X_FB_21_CLK); // Start FPGA clock
	S3x_Clk_Enable(S3X_FB_16_CLK);

	/* enable interrupt 1 (GPIOIn) */
	FB_RegisterISR(FB_INTERRUPT_1, fb_timer_isr);
	FB_ConfigureInterrupt(FB_INTERRUPT_1, FB_INTERRUPT_TYPE_LEVEL,
						FB_INTERRUPT_POL_LEVEL_HIGH,
						FB_INTERRUPT_DEST_AP_DISBLE, FB_INTERRUPT_DEST_M4_ENABLE);
	NVIC_ClearPendingIRQ(FbMsg_IRQn);
	NVIC_EnableIRQ(FbMsg_IRQn);

	/* configure GPIOIn */
	gpio_mode_write(1);
	gpio_edge_write(0);
	gpio_ev_enable_write(1);

	CLI_start_task(my_main_menu);

	vTaskStartScheduler();
      
	while(1);
}

//needed for startup_EOSS3b.s asm file
void SystemInit(void) {}
