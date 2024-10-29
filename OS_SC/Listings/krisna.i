
#line 1 "krisna.c" /0
  
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
 
#line 1 "krisna.c" /0
 
 
 
 void coprocessor_init(){
 COPMOSI 	= 0xFF;
 COPMISO 	= 0xFF;
 COPTH 		= 0xFF;
 COPSRC 	= 0xFF;
 COPDST 	= 0xFF;
 COPSTATR = 0xFF;
 COPCOM 	= 0xFF;
 }
 
 
 void copy_data_block_sequential(unsigned char source_address, unsigned char destination_address, unsigned int length){
 COPCOM = 0x84;
 COPSRC = source_address;
 COPDST = destination_address;
 COPTH = source_address+length-1;
 COPCOM = 0xFF;
 }
 
 void copy_data_block_independent(unsigned char source_address, unsigned char destination_address, unsigned int length){
 COPCOM = 0x04;
 COPSRC = source_address;
 COPDST = destination_address;
 COPTH = source_address+length-1;
 COPCOM = 0xFF;
 }
 
 void write_data_independent(unsigned char destination_address, unsigned copdata){
 COPCOM = 0x03;
 COPDST = destination_address;
 COPMOSI = copdata;
 COPCOM = 0xFF;
 }
 
 
 void write_data_sequential(unsigned char destination_address, unsigned copdata){
 COPCOM = 0x83;
 COPDST = destination_address;
 COPMOSI = copdata;
 COPCOM = 0xFF;
 }
 
 void write_block_sequential(unsigned copdata){
 COPCOM = 0x83;
 COPMOSI = copdata;
 COPCOM = 0xFF;
 }
 
 
 unsigned read_data_sequential(unsigned char source_address){
 COPCOM = 0x82;
 COPSRC = source_address;
 COPCOM = 0xFF;
 while (!s_TR);
 COPCOM = 0x00;
 return COPMISO;
 }
 
 unsigned read_data_independent(unsigned char source_address){
 COPCOM = 0x02;
 COPSRC = source_address;
 COPCOM = 0xFF;	
 while (!s_TR);
 COPCOM = 0x00;
 return COPMISO;
 }
 
 void copy_data_sequential(unsigned char source_address, unsigned char destination_address){
 COPCOM = 0x81;
 COPSRC = source_address;
 COPDST = destination_address;
 COPCOM = 0xFF;
 }
 
 void copy_data_independent(unsigned char source_address, unsigned char destination_address){
 COPCOM = 0x01;
 COPSRC = source_address;
 COPDST = destination_address;
 COPCOM = 0xFF;
 }
 
 void ECC_sequential(){
 COPCOM = 0x88;
 COPCOM = 0xFF;
 }
 
 void ECC_independent(){
 COPCOM = 0x08;
 COPCOM = 0xFF;
 }
 
 void HASH_sequential(){
 COPCOM = 0x85;
 COPCOM = 0xFF;
 }
 
 void HASH_independent(){
 COPCOM = 0x05;
 COPCOM = 0xFF;
 }
 
 void BC3_encrypt_k_sequential(){
 COPCOM = 0x86;
 COPCOM = 0xFF;
 }
 
 void BC3_encrypt_k_independent(){
 COPCOM = 0x06;
 COPCOM = 0xFF;
 }
 
 void BC3_encrypt_sequential(){
 COPCOM = 0x89;
 COPCOM = 0xFF;
 }
 
 void BC3_encrypt_independent(){
 COPCOM = 0x09;
 COPCOM = 0xFF;
 }
 
 void BC3_decrypt_k_independent(){
 COPCOM = 0x07;
 COPCOM = 0xFF;
 }
 
 void BC3_decrypt_k_sequential(){
 COPCOM = 0x87;
 COPCOM = 0xFF;
 }
 
 void BC3_decrypt_independent(){
 COPCOM = 0x0A;
 COPCOM = 0xFF;
 }
 
 void BC3_decrypt_sequential(){
 COPCOM = 0x8A;
 COPCOM = 0xFF;
 }
 
 
