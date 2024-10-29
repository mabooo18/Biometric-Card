
#ifndef KRISNA_H
#define KRISNA_H

#define addr_xi_ECC 		  0x00
#define addr_yi_ECC 		  0x1E
#define addr_xo_ECC 		  0xB2
#define addr_yo_ECC 		  0xD0
#define addr_k_ECC 		  0x3C
#define  addr_RNG	 		  0xEE
#define  addr_k_BC3 	  0x5A
#define addr_dati_BC3   0x62
#define addr_dati_HASH  0x6A
#define addr_dato_HASH  0x8A
#define addr_dato_BC3   0xAA

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
#endif