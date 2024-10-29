
#line 1 "state.c" /0
  
#line 1 "C:\KEIL\C51\INC\STRING.H" /0






 
 
 
 
 
 
 
 typedef unsigned int size_t;
 
 
 
 
 
 
 #pragma SAVE
 #pragma REGPARMS
 extern char *strcat (char *s1, char *s2);
 extern char *strncat (char *s1, char *s2, int n);
 
 extern char strcmp (char *s1, char *s2);
 extern char strncmp (char *s1, char *s2, int n);
 
 extern char *strcpy (char *s1, char *s2);
 extern char *strncpy (char *s1, char *s2, int n);
 
 extern int strlen (char *);
 
 extern char *strchr (const char *s, char c);
 extern int strpos (const char *s, char c);
 extern char *strrchr (const char *s, char c);
 extern int strrpos (const char *s, char c);
 
 extern int strspn (char *s, char *set);
 extern int strcspn (char *s, char *set);
 extern char *strpbrk (char *s, char *set);
 extern char *strrpbrk (char *s, char *set);
 extern char *strstr  (char *s, char *sub);
 extern char *strtok  (char *str, const char *set);
 
 extern char memcmp (void *s1, void *s2, int n);
 extern void *memcpy (void *s1, void *s2, int n);
 extern void *memchr (void *s, char val, int n);
 extern void *memccpy (void *s1, void *s2, char val, int n);
 extern void *memmove (void *s1, void *s2, int n);
 extern void *memset  (void *s, char val, int n);
 #pragma RESTORE
 
 
#line 1 "state.c" /0
 
  
#line 1 "config.h" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#line 2 "state.c" /0
 
  
#line 1 "memory.h" /0
 
 
 
 extern char eeprom_ID_write;
 extern char eeprom_ID_read;
 extern char LSB_address;
 
 unsigned char Memory_ReadByte(unsigned int address);
 unsigned char Memory_ReadByte_Ext(unsigned int address);
 void Memory_WriteByte_Ext(unsigned int address, char data_to_send);
 void Memory_WriteByte(unsigned int address, char data_to_send);
 int Memory_ReadBlock(unsigned int address, unsigned int read_size, unsigned char * databyte);
 int Memory_WriteBlock(unsigned int address, unsigned int write_size, unsigned char * databyte);
 
#line 3 "state.c" /0
 
  
#line 1 "state.h" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 struct state_struct
 {
 unsigned int        current;      
 unsigned int        currentKey;     
 unsigned int        currentRecord;   
 unsigned char         securityState;   
 unsigned char         challenge[8];
 };
 
 
 
 
 
 
 
 
 
 
 
 int State_Init();
 
 int State_Verify();
 
 void State_GetChallenge();
 
 unsigned char State_VerifyAuth();
 
 int State_SetCurrent(unsigned int newfile);
 
 int State_SetCurrentRecord(unsigned int record_num);
 
 int State_SetCurrentKey(unsigned int newKey);
 
 unsigned int State_GetCurrent();
 
 unsigned int State_GetCurrentRecord();
 
 unsigned char State_GetCurrentSecurity();
 
 void State_GetCurrentChallenge();
 
 
#line 4 "state.c" /0
 
  
#line 1 "krisna.h" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 sfr COPBC3 		= 0xE8;
 sfr COPSTATR 	= 0xF8;
 sfr COPMOSI 	= 0xF9;
 sfr COPMISO 	= 0xFA;
 sfr COPTH 		= 0xFB;
 sfr COPSRC 		= 0xFC;
 sfr COPDST 		= 0xFD;
 sfr COPCOM 		= 0xFF;
 
 sbit s_Empty = 0xF8;
 sbit s_Full = 0xF9;
 sbit s_TR = 0xFA;
 sbit s_ACK = 0xFB;
 sbit s_SM = 0xFC;
 sbit s_HASH = 0xFD;
 sbit s_BC3 = 0xFE;
 sbit s_ECC = 0xFF;
 
 sbit s_Done = 0xD8;
 sbit s_6 = 0xD9;
 sbit s_5 = 0xDA;
 sbit s_4 = 0xDB;
 sbit s_3 = 0xDC;
 sbit s_2 = 0xDD;
 sbit s_1 = 0xDE;
 sbit s_0 = 0xDF;
 
 void coprocessor_init();
 
 
 void copy_data_block_sequential(unsigned char source_address, unsigned char destination_address, unsigned int length);
 
 void copy_data_block_independent(unsigned char source_address, unsigned char destination_address, unsigned int length);
 
 void write_data_independent(unsigned char destination_address, unsigned copdata);
 
 
 void write_data_sequential(unsigned char destination_address, unsigned copdata);
 
 void write_block_sequential(unsigned copdata);
 
 
 unsigned read_data_sequential(unsigned char source_address);
 
 unsigned read_data_independent(unsigned char source_address);
 
 void copy_data_sequential(unsigned char source_address, unsigned char destination_address);
 
 void copy_data_independent(unsigned char source_address, unsigned char destination_address);
 
 void ECC_sequential();
 
 void ECC_independent();
 
 void HASH_sequential();
 
 void HASH_independent();
 
 void BC3_encrypt_k_sequential();
 
 void BC3_encrypt_k_independent();
 
 void BC3_encrypt_sequential();
 
 void BC3_encrypt_independent();
 
 void BC3_decrypt_k_independent();
 
 void BC3_decrypt_k_sequential();
 
 void BC3_decrypt_independent();
 
 void BC3_decrypt_sequential();
 
#line 5 "state.c" /0
 
  
#line 1 "command.h" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 void Command_Write();
 void Command_Read();
 void Command_Format();
 void Command_Encrypt();
 void Command_GetCurrentChallenge();
 void Command_GetChallenge();
 void Command_ReadSHM();
 void Command_Interpreter();
 
 unsigned int fibo(unsigned int i);
 
#line 6 "state.c" /0
 
  
#line 1 "transmission.h" /0
 
 
 
 extern unsigned char header[5];
 extern unsigned int sw;
 
 void send_ATR();
 void send_ATR_direct();
 void Transmission_GetHeader(); 
 void Transmission_SendSW();
 void Transmission_SendDebug();
 char Transmission_GetByte ();
 void Transmission_SendByte (char c);
 
 
 
#line 7 "state.c" /0
 
 
 
 
 static struct state_struct     state_mng;               
 unsigned char key[8] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07};
 extern unsigned char buffer[8];
 extern unsigned char encrypted[8];
 extern unsigned char pin[4];
 
 int State_Init(){
 state_mng.current = 0;
 state_mng.currentKey = 0;
 state_mng.currentRecord = 1;
 state_mng.securityState = 0;
 
 return 0; 
 }
 
 int State_SetCurrent(unsigned int newFile) {
 state_mng.current = newFile;
 state_mng.currentRecord = 1;
 return 0;
 }
 
 int State_SetCurrentRecord(unsigned int record_num) {
 state_mng.currentRecord = record_num;
 return 0;
 }
 
 unsigned int State_GetCurrent() {
 return state_mng.current;
 }
 
 unsigned int State_GetCurrentRecord() {
 return state_mng.currentRecord;
 }
 
 void State_GetCurrentChallenge() {
 memcpy( buffer, state_mng.challenge, 8 );
 }
 
 unsigned char State_GetCurrentSecurity() {
 return state_mng.securityState;
 }
 
 int State_Verify() {
 unsigned char retries;
 unsigned char i, temp_card, temp_rd, diff=0;
 
 state_mng.securityState &= 0xfe;
 retries = Memory_ReadByte(0x0002+24+4);
 
 if (retries == 0) {
 return 3;
 }
 
 for( i=0; i<60; i++ ) {
 write_data_independent((0x6A+i),(0x00+i));
 }
 for( i=0; i<4; i++ ) {
 write_data_independent((0x6A+i+60),pin[i]);
 }
 HASH_sequential();
 
 for( i=0; i<32; i++ ) {
 temp_card = Memory_ReadByte(((((((0x0002+24+4 + 1 + 8) + 32) + 16)+1)+60)+60)+i);
 temp_rd = read_data_sequential(0x8A+i);
 diff |= temp_card^temp_rd;
 }
 
 if( diff>0 ){
 retries--;
 } else {
 retries=0x03;
 }
 
 Memory_WriteByte(0x0002+24+4, retries);
 
 if( diff>0 ) {
 state_mng.securityState = 0x00;
 return 2;
 }
 
 if (retries == 0) {
 return 3;
 }
 state_mng.securityState |= 0xFF;
 
 return 0;
 }
 
 unsigned char State_VerifyAuth()
 {
 unsigned char retries,i;
 
 unsigned char last_data[8];
 
 retries = Memory_ReadByte((((0x0002+24+4 + 1 + 8) + 32) + 16));
 
 if (retries > 3){
 return 3;
 }
 
 
 
 for(i=0;i<8;i++){ 
 last_data[i] = Memory_ReadByte((0x0002+24+4 + 1 + 8) + i);
 write_data_sequential(0x5A+i, key[i]);
 write_data_sequential(0x62+i, last_data[i]);
 }
 
 BC3_encrypt_k_sequential();
 
 for(i=0;i<8;i++){ 
 last_data[i] = read_data_sequential(0xAA+i);
 if (encrypted[i] != last_data[i]){
 retries++;
 Memory_WriteByte((((0x0002+24+4 + 1 + 8) + 32) + 16), retries);
 return 2;
 }
 }
 
 





 
 
 if(retries > 0) {
 retries = 0;
 Memory_WriteByte((((0x0002+24+4 + 1 + 8) + 32) + 16), retries);
 }
 
 state_mng.securityState |= 0x02;
 
 return 0;
 }
 





















 
 
 
 void State_GetChallenge()
 {
 unsigned char block[8],i;
 
 
 
 
 
 
 
 
 
 
 for(i=0;i<8;i++){ 
 buffer[i] = read_data_independent(0xEE);
 state_mng.challenge[i] = buffer[i];
 Memory_WriteByte((0x0002+24+4 + 1 + 8) + i, buffer[i]);
 write_data_independent(0x62+i, buffer[i]);
 write_data_sequential(0x5A+i, key[i]);
 }
 
 BC3_encrypt_k_sequential();
 
 for(i=0;i<8;i++){ 
 block[i] = read_data_sequential(0xAA+i);
 Memory_WriteByte(0x0230 + i, block[i]);
 }
 
 }
