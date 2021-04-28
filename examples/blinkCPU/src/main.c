#include "Fw_global_config.h" // This defines application specific characteristics
#include "qf_hardwaresetup.h" // hardware init (clk / GPIOs)

#include "eoss3_hal_gpio.h"   // GPIO driver

void Delay(uint32_t nCount) {
	volatile uint32_t count = nCount;
	for (; count != 0; count--) __asm__("nop");
}

int main(void) {
    qf_hardwareSetup();
      
    while(1) {
		HAL_GPIO_Write(6, 1);
		Delay(0x04FFFF);
		HAL_GPIO_Write(6, 0);
		Delay(0x04FFFF);
	}
}

//needed for startup_EOSS3b.s asm file
void SystemInit(void) {}
