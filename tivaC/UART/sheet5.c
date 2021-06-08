#include "stdint.h"
#include "C:/Keil/EE319Kware/inc/tm4c123gh6pm.h"

#define GPIO_PA10_M 0x03

// Q3
// initialize UART 0:
// ACTIVATION
// - activate UART 0 [SYSCTL_RCGCUART_R]
// - activate Port A [SYSCTL_RCGCGPIO_R]
// UART CONFIGURATION
// - disable UART 0 [UART0_CTL_R]
// - set baud rate (integer & float) [UART0_IBRD_R] [UART0_FBRD_R]
// - set line control register (parity bit, 2nd stop bit, FIFO, frame width) [UART0_LCRH_R]
// - enable UART [UART0_CTL_R]
// CONFIGURE PINS OF PORT A
// - enable alternate function in bits 0,1 in Port A [GPIO_PORTA_AFSEL_R]
// - set the alternate function of bits 0,1 in Port A to be UART receiver and transmitter [GPIO_PORTA_PCTL_R]
// - digital enable bits 0,1 in Port A [GPIO_PORTA_DEN_R]

// in UART0_LCRH_R (line control register of UART):
// bit 1 => PEN: parity enable
// bit 3 => STP2: stop with 2 bits
// bit 4 => FIFO enable
// bit 5,6 => frame width: 5 or 6 or 7 or 8 bits

// in GPIO_PORTA_PCTL_R:
// bits (0-3) => set alternate function of bit 0 in Port A
// bits (4-7) => set alternate function of bit 1 in Port A
// if bits (0-3) are set to 0x01 & alternate function is enabled, bit 0 of Port A would operate as UART receiver
// if bits (4-7) are set to 0x01 & alternate function is enabled, bit 1 of Port A would operate as UART transmitter

void UART0_Init(void)
{
  SYSCTL_RCGCUART_R |= SYSCTL_RCGCUART_R0; //activate UART 0
  SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R0; //activate Port A

  UART0_CTL_R &= ~UART_CTL_UARTEN;                                //disable UART 0
  UART0_IBRD_R = 104;                                             //IBRD = int(16,000,000 / (16 * 9600)) = int(104.16666666666)
  UART0_FBRD_R = 11;                                              //FBRD = floor(0.16666666666 * 64 + 0.5) = 11
  UART0_LCRH_R = (UART_LCRH_WLEN_8 | UART_LCRH_FEN);              //disable parity - enable FIFO - 8 bits
  UART0_CTL_R |= (UART_CTL_RXE | UART_CTL_TXE | UART_CTL_UARTEN); //enable UART

  GPIO_PORTA_AFSEL_R |= GPIO_PA10_M; // enable alternate function
  GPIO_PORTA_PCTL_R = (GPIO_PORTA_PCTL_R & 0xFFFFFF00) | (GPIO_PCTL_PA1_U0TX | GPIO_PCTL_PA0_U0RX);
  GPIO_PORTA_DEN_R |= GPIO_PA10_M; //digital enable
}

// Q4
// check if there is data available to be received by UART 0:
// - check bit 4 (RXFE) in [UART0_FR_R], if 0 => data available, if 1 => data not available

// in UART0_FR_R:
// bit 4 => RXFE: reciver FIFO empty
// bit 5 => TXFF: transmitter FIFO full
// bit 6 => RXFF: receiver FIFO full
// bit 7 => TXFE: transmitter FIFO empty
uint8_t UART0_Available(void)
{
  return ((UART0_FR_R & UART_FR_RXFE) == UART_FR_RXFE) ? 0 : 1; //check if bit 4 is 0 (receiver FIFO not empty)
}

// Q5
// receive 1 byte from UART 0
// - read the byte from UART data register [UART0_DR_R]

// in UART0_DR_R:
// bits (0-7) => data bits
// bit 8 => FE: stop bit timing error
// bit 9 => PE: parity error
// bit 10 => BE: Tx signal held low for more than 1 frame
// bit 11 => OE: FIFO is full and a new frame arrived

// in UART0_RSR_R:
// bit 0 => FE
// bit 1 => PE
// bit 2 => BE
// bit 3 => OE
uint8_t UART0_Read(void)
{
  while (UART0_Available() != 1)
    ;
  return (uint8_t)(UART0_DR_R & 0xFF); //return only the 1st 8 bits (1 byte)
}

// Q6
// write 1 character using UART 0
// - put the character in the data register of UART 0 after checking that transmit FIFO is not full
void UART0_Write(uint8_t data)
{
  while ((UART0_FR_R & UART_FR_TXFF /*bit 5*/) != 0)
    ; //check that bit 5 (TXFF) is not 1 before writing into transitter FIFO
  UART0_DR_R = data;
}

// Q7
// receive a character from UART 0 and send its capital corresponding letter by UART 0 also
int main(void)
{
  uint8_t in;
  uint8_t out;
  UART0_Init();
  while (1)
  {
    in = UART0_Read();
    out = in - 0x20;
    UART0_Write(out);
  }
}
