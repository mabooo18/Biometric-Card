#include <reg51.h>
#include "transmission.h"

sbit SCOUT = P1^2;

unsigned char header[5];

// void send_ATR(void){ //verified
// 	unsigned char len;
// 	unsigned int len_address;
// 	unsigned char i;
// 	unsigned char atr;
// 	unsigned int ATR_ADDR;
// 	ATR_ADDR = 1;
// 	len_address = 1;
// 	len = Memory_ReadByte(len_address); //0x0f
// 	for( i=1; i<(len+1); i++ ) {
//     atr = Memory_ReadByte( ATR_ADDR+i );
// 		Transmission_SendByte( atr );
//   }
// }

void send_ATR_direct(){
	Transmission_SendByte(0x3B);	
	Transmission_SendByte(0xAA);	
	Transmission_SendByte(0x00);	
	Transmission_SendByte(0x40);	
	Transmission_SendByte(0x0A);	
	Transmission_SendByte(0x50);	
	Transmission_SendByte(0x69);	
	Transmission_SendByte(0x6E);	
	Transmission_SendByte(0x74);	
	Transmission_SendByte(0x61);	
	Transmission_SendByte(0x72);	
	Transmission_SendByte(0xEE);	
	Transmission_SendByte(0xDD);	
	Transmission_SendByte(0xCC);	
	Transmission_SendByte(0xBB);	
	Transmission_SendByte(0xAA);	
}

char Transmission_GetByte ()  {
	char c;
	while (!TI);
	SCOUT = 0;
	while (!RI);
	c = SBUF;
	RI = 0;
	SCOUT = 1;
	return (c);
}

bit get_parity (unsigned char uc)  {
	ACC = uc;
	return (P);
}

void guard_time(void){
	unsigned char i;
	for(i=0; i<5; i++); 
}

void Transmission_SendByte (char c)  {
	while (!TI);
	TB8 = get_parity(c);
	SCOUT = 1;
	SBUF = c;
	TI = 0;
}

void Transmission_GetHeader(){
	int i;
	for (i = 0; i < 5; i++){
		header[i] = Transmission_GetByte();
	}	
}

void Transmission_SendSW(){
	Transmission_SendByte((unsigned char)((sw>>8) & 0xFF));
	Transmission_SendByte( (unsigned char)(sw & 0xFF) );
}
/*
void Transmission_SendDebug(){
	int i;
	for (i = 0; i < n_Debug; n_Debug++){
	Transmission_SendByte(data_Debug[i]);
	}
}*/