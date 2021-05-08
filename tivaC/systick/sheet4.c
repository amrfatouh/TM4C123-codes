#include "stdint.h"
#include "C:/Keil/EE319Kware/inc/tm4c123gh6pm.h"

void SystemInit() {}

// Q1
// initialize systick
// - disable systick [NVIC_ST_CTRL_R]
// - set reload to maximun [NVIC_ST_RELOAD_R]
// - clear current [NVIC_ST_CURRENT_R]
// - enable systick: with (0) for interrupt, (1) for clock type
void systickInit()
{
	NVIC_ST_CTRL_R = 0;
	NVIC_ST_RELOAD_R = 0xFFFFFF;
	NVIC_ST_CURRENT_R = 0;
	NVIC_ST_CTRL_R = 0x5;
}

// Q2
// wait 1 ms using systick
void wait1ms()
{
	NVIC_ST_RELOAD_R = 15999;
	NVIC_ST_CURRENT_R = 0;
	while ((NVIC_ST_CTRL_R & 0x00010000) == 0)
		; //0000_0000_0000_0001_0000_0000_0000_0000
}

// Q3
// wait for delay * 1 ms
void wait(int delay)
{
	int i;
	for (i = 0; i < delay; i++)
	{
		wait1ms();
	}
}

// Q4
// flash each led for 1 second
void portFInit()
{
	SYSCTL_RCGCGPIO_R |= 0x20; //0010_0000
	while ((SYSCTL_PRGPIO_R & 0x20) == 0)
		; //wait till port F initialized
	GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY;
	GPIO_PORTF_CR_R |= 0x0E; //0000_1110
	GPIO_PORTF_DEN_R |= 0x0E;
	GPIO_PORTF_DIR_R |= 0x0E;
}

void flashEach1Sec()
{
	GPIO_PORTF_DATA_R = 0x02; //0000_0010
	wait(1000);
	GPIO_PORTF_DATA_R = 0x04; //0000_0100
	wait(1000);
	GPIO_PORTF_DATA_R = 0x08; //0000_1000
	wait(1000);
	GPIO_PORTF_DATA_R = 0;
}

int main()
{
	systickInit();
	portFInit();
	flashEach1Sec();
	return 0;
}