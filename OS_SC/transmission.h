#ifndef TRANSMISSION_HEADER_FILE
#define TRANSMISSION_HEADER_FILE 1

extern unsigned char header[5];
extern unsigned int sw;

void send_ATR();
void send_ATR_direct();
void Transmission_GetHeader(); 
void Transmission_SendSW();
void Transmission_SendDebug();
char Transmission_GetByte ();
void Transmission_SendByte (char c);


#endif