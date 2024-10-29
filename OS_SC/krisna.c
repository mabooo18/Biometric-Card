#include "krisna.h"


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


