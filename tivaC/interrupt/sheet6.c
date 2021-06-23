#include "stdint.h"
#include "C:/Keil/EE319Kware/inc/tm4c123gh6pm.h"

// Q1
// initializing PF4 as digital input
// with negative edge triggered interrupt with priority 2
// write ISR (handler) for the interrupt

void EnableInterrupts(void);
uint8_t counter = 0;
uint32_t RGB_color[8] = {0x00, 0x02, 0x04, 0x06, 0x08, 0x0A, 0x0C, 0x0E};
//                       0000  0010  0100  0110  1000  1010  1100  1110
//                       off   red   blue  pink  green yellw cyan  white

void PortF_init(void)
{
  // SWITCH INITIALIZATION
  // initialize Port F as digital output
  SYSCTL_RCGCGPIO_R |= 0x20; //0010_0000
  while ((SYSCTL_PRGPIO_R & 0x20) == 0)
    ; //wait till port F initialized
  GPIO_PORTF_LOCK_R = GPIO_LOCK_KEY;
  GPIO_PORTF_CR_R |= 0x10; //0b0001_0000
  GPIO_PORTF_DEN_R |= 0x10;
  GPIO_PORTF_DIR_R &= ~0x10;
  GPIO_PORTF_AFSEL_R &= ~0x10;
  GPIO_PORTF_AMSEL_R &= ~0x10;
  GPIO_PORTF_PUR_R |= 0x10;

  // INTERRUPT INITIALIZATION

  // in GPIO_PORTF_IS_R (Interrupt State):
  // bits(0-7): pins (0-7) in Port F
  // if bit set to 0: interrupt of the pin is edge sensitive
  // if bit set to 1: interrupt of the pin is level sensitive

  // in GPIO_PORTF_IBE_R (Interrupt Both Edges):
  // bits(0-7): pins (0-7) in Port F
  // if bit set to 0: pin is sensitive to 1 edge
  // if bit set to 1: pin is sensitive to both edges

  // in GPIO_PORTF_IEV_R (Interrupt Edge Event)
  // bits(0-7): pins (0-7) in Port F
  // if GPIO_PORTF_IS_R is set to edge sensitive:
  // - if bit set to 0: interrupt event of the pin is falling edge
  // - if bit set to 1: interrupt event of the pin is rising edge
  // if GPIO_PORTF_IS_R is set to level sensitive:
  // - if bit set to 0: interrupt event of the pin is low level
  // - if bit set to 1: interrupt event of the pin is high level

  // in GPIO_PORTF_ICR_R (Interrupt Clear):
  // bits(0-7): pins (0-7) in Port F
  // if bit set to 0: don't clear interrupt of that pin
  // if bit set to 1: clear interrupt of that pin

  // in GPIO_PORTF_IM_R (Interrupt Mask) (arming interrupts on pins):
  // bits(0-7): pins (0-7) in Port F
  // if bit set to 0: no mask (no interrupt is armed on the pin)
  // if bit set to 1: pin is masked (interrupt is armed on the pin)

  // in NVIC_PRI7_R (priority 7 register):
  // bits(21-23): priority of Port F
  // bits(29-31): priority of Port G
  // write in bits(21-23) the priority number(0-7) of Port F
  // in NVIC_PRI0_R, priority of Port A(bits 5-7), Port B(bits 13-15), Port C(bits 21-23), Port D(bits 29-31) exist
  // bits other than bits mentioned are reserved, so you can't write on them even if you write the instruction to do so
  // in NVIC_SYS_PRI3_R, bits(29-31) represents Systick priority

  // in NVIC_EN0_R (enable register):
  // bits(0-4): enable bits for Ports A,B,C,D,E interrupts respectively
  // bits(30,31): enable bits for Ports F,G interrupts respectively

  // in interrupt initialization for a pin:
  // - set interrupt state register [GPIO_PORTF_IS_R] (edge or level sensitive)
  // - set interrupt both edges regisiter [GPIO_PORTF_IBE_R] (single edge or both edges)
  // - set interrupt event register [GPIO_PORTF_IEV_R] (falling/rising edge for edge sensitive interrupts - low/high level for level sensitive interrupts)
  // - clear interrupt [GPIO_PORTF_ICR_R]
  // - arm interrupt on the pin [GPIO_PORTF_IM_R]
  // - set priority of the interrupt [NVIC_PRI7_R]
  // - enable the interrupt for Port F [NVIC_EN0_R]
  // - enable interrupts globally using function EnableInterrupts()
  // - write the handler for the interrupt [GPIOF_Handler()]

  // negative edge triggered (falling) configuration
  GPIO_PORTF_IS_R &= ~0x10;  //edge sensitive interrupt
  GPIO_PORTF_IBE_R &= ~0x10; //single edge
  GPIO_PORTF_IEV_R &= ~0x10; //falling edge
  GPIO_PORTF_ICR_R |= 0x10;  //clear interrupt signal of PF4 (switch)
  GPIO_PORTF_IM_R |= 0x10;   // arm interrupt on PF4 (switch)

  // setting Port F priority (setting priority to 2)
  NVIC_PRI7_R = (NVIC_PRI7_R & 0xFF00FFFF) | 0x00400000;
  /*or*/ NVIC_PRI7_R = (NVIC_PRI7_R & 0xFF00FFFF) | (2 << 21);
  /*or*/ NVIC_PRI7_R = (NVIC_PRI7_R & 0xFF00FFFF) | (1 << 22);

  NVIC_EN0_R |= (1 << 30); // enable IRQ from Port F (bit 30 of EN0 register)

  EnableInterrupts(); //enable interrupts
}

// setting interrupt handler for Port F
void GPIOF_Handler(void)
{
  GPIO_PORTF_ICR_R |= 0x10; //clear interrupt signal of PF4 (switch)
  GPIO_PORTF_DATA_R = RGB_color[counter];
  counter++;
  if (counter == 8)
    counter = 0;
}

// Q2
// initialize systick with periodic interrupt every 10 ms with priority 1

#define PERIOD 800000 //period = freq * delay = (80 * 10 ^ 6) * (10 * 10 ^ -3)
uint32_t cnt10ms = 0;

// in NVIC_SYS_PRI3_R, bits(29-31) represents Systick priority

// to initialize systick with interrupt:
// - disable systick [NVIC_ST_CTRL_R]
// - set reload value [NVIC_ST_RELOAD_R] (reload = freq * delay (e.g. 80 MHz * 10ms = 800,000))
// - clear current [NVIC_ST_CURRENT_R] (set it to any value to clear it)
// - set priority of systic [NVIC_SYS_PRI3_R] (bits 29-31)
// - enable systick [NVIC_ST_CTRL_R]
// - enable interrupts globally [EnableInterrupts()]
// - set systick interrupt handler [Systick_Handler()]

void systick_interrupt_init(void)
{
  NVIC_ST_CTRL_R = 0;                                            //disable systick during configuration
  NVIC_ST_RELOAD_R = PERIOD - 1;                                 //reload
  NVIC_ST_CURRENT_R = 0;                                         //clear current
  NVIC_SYS_PRI3_R = (NVIC_SYS_PRI3_R & 0x00FFFFFF) | 0x20000000; //set priority to 1
  NVIC_ST_CTRL_R = 0x07;                                         //enable systick with interrupt & core clock
  EnableInterrupts();
}

// set systick handler
void Systick_Handler(void)
{
  cnt10ms += 1;
}

// Q3
// call task1() every 10ms, task2() every 20ms, task3() every 30ms
// use previous systick initialization

#include <stdbool.h>
uint32_t dummy1 = 0, dummy2 = 0, dummy3 = 0; //dummy variables for tasks
bool run_flag = true;

// set the systick interrupt handler (a line is added to the previous definition)
// the run flag is used in the main while so that it executes some functions when the interrupt comes
// in other words, run_flag is the way by which the main function knows that there is an interrupt
// we can user WaitForInterrupt() function instead
void Systick_Handler(void)
{
  cnt10ms += 1;
  run_flag = false;
}

void task1() { dummy1++; }
void task2() { dummy2++; }
void task3() { dummy3++; }

int main()
{
  PLL_init(); //??
  systick_init();
  while (1)
  {
    // if interrupt came, Systick_Handler() sets run_flag to true
    // the following if condition becomes true
    // the tasks are executed and run_flag is set to false again
    // the loop waits iterates continuously and waits for another interrupt
    if (run_flag)
    {
      task1();
      if (cnt10ms % 2 == 0)
        task2();
      if (cnt10ms % 3 == 0)
        task3();
      run_flag = false;
    }
  }
}