#include "Fw_global_config.h" // This defines application specific characteristics
#ifdef quickfeather
#include "qf_hardwaresetup.h" // hardware init (clk / GPIOs)
#define GREEN_PIN 6
#else
#include "qomu_hardwaresetup.h" // hardware init (clk / GPIOs)
#define GREEN_PIN 0
#endif

#include "s3x_clock.h"

void Delay(uint32_t nCount) {
	volatile uint32_t count = nCount;
	for (; count != 0; count--) __asm__("nop");
}

int main(void) {
#ifdef quickfeather
    qf_hardwareSetup();
#else
#ifdef qomu
	qomu_hardwaresetup();
#else
#error "unknown board"
#endif
#endif

	/* no need to disable and to load
	 * => automatic before start
	 */
	S3x_Clk_Enable(S3X_FB_21_CLK);
	S3x_Clk_Enable(S3X_FB_16_CLK);

    while(1) {
		/*HAL_GPIO_Write(GREEN_PIN, 1);
		Delay(0x04FFFF);
		HAL_GPIO_Write(GREEN_PIN, 0);
		Delay(0x04FFFF);*/
	}
}

//needed for startup_EOSS3b.s asm file
void SystemInit(void) {}
