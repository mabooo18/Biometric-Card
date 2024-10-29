#include "reg51.h"
#include "i2c.h"
#include "krisna.h"

void init_HW(void){
	coprocessor_init();
	SCON  = 0xD0;                   /* SCON: mode 3, 9-bit UART, enable rcvr    */
	TMOD |= 0x20;                   /* TMOD: timer 1, mode 2, 8-bit reload      */
	TH1   = 0xff;                   /* TH1:  reload value for 9600 baud @ 3.58MHz  */
	TR1   = 1;                      /* TR1:  timer 1 run                        */
	TI    = 1;                      /* TI:   set TI to send first char of UART  */
	I2C_stop();
}