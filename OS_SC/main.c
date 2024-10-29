#include <reg51.h>  
#include "hal.h"
#include "transmission.h"
#include "response.h"
#include "command.h"
#include "i2c.h"
#include "krisna.h"
#include "memory.h"
#include "state.h"
#include "fs.h"

sbit ATR_START = P1^3;
sbit ATR_DONE = P1^4;
unsigned char buf[CRYPT_BLOCK_LEN];

void main(void){
	ATR_START = 1;
	ATR_DONE = 1;
	init_HW();
	
	send_ATR_direct();
	State_Init();
	FS_Init();

		ATR_DONE = 0;
	while(1){
		Transmission_GetHeader();
		Command_Interpreter();
		Transmission_SendSW();
	}

}