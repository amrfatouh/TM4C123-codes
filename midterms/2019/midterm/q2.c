#define SYSCTL_RCGCGPIO_R		  (*((volatile unsigned long*) 0x400FE608))
#define SYSCTL_PRGPIO_R		    (*((volatile unsigned long*) 0x400FEA08))
#define GPIO_PORTF_CR_R     	(*((volatile unsigned long*) 0x40025524))
#define GPIO_PORTF_DEN_R    	(*((volatile unsigned long*) 0x4002551C))
#define GPIO_PORTF_DIR_R    	(*((volatile unsigned long*) 0x40025400))
#define GPIO_PORTF_PUR_R    	(*((volatile unsigned long*) 0x40025510))
#define GPIO_PORTF_DATA_R    	(*((volatile unsigned long*) 0x400253FC))

#define GPIO_PORTF_AFSEL_R    (*((volatile unsigned long*) 0x40025420))
#define GPIO_PORTF_AMSEL_R    (*((volatile unsigned long*) 0x40025528))
#define GPIO_PORTF_LOCK_R			(*((volatile unsigned long*) 0x40025520))
#define GPIO_PORTF_PCTL_R			(*((volatile unsigned long*) 0x4002552C))
#define SYSCTL_RCGC2_R			  (*((volatile unsigned long*) 0x400FE108))

#define NVIC_ST_CTRL_R        (*((volatile unsigned long*) 0xE000E010))
#define NVIC_ST_RELOAD_R      (*((volatile unsigned long*) 0xE000E014))
#define NVIC_ST_CURRENT_R     (*((volatile unsigned long*) 0xE000E018))

#define GPIO_LOCK_KEY			    (*((volatile unsigned long*) 0x4C4F434B))

// initialize Port F:
// activate Port F
// enable writing to Port F (commit)
// DEN
// DIR
// PUR

// initializing Port B
void initPortB() {
  SYSCTL_RCGCGPIO_R |= 0x02; //0000_0010  //activating port F
  while (SYSCTL_PRGPIO_R & 0x2 == 0); //waiting till activation
  GPIO_PORTF_CR_R = 0xFF; //enable writing (commit)
  GPIO_PORTF_DEN_R = 0xFF; //digital enable
  // setting inputs and outputs
  GPIO_PORTF_DIR_R |= 0x12; //0001_0010
  GPIO_PORTF_DIR_R &= ~0x24; //~0010_0100 -> 1101_1011
  GPIO_PORTF_PUR_R |= 0x24; //pull up resistors
}

int readSwitches() {
  int x = GPIO_PORTF_DATA_R;
  if (x & 0x24 == 0x24) return 3;
  else if (x & 0x04 == 0x04) return 2;
  else if (x & 0x20 == 0x20) return 1;
  else return 0; 
}














