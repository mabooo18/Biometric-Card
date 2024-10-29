#include <reg51.h>
#include <string.h>
#include "hal.h"
#include "i2c.h"
#include "krisna.h"
#include "memory.h"


char eeprom_ID_write;
char eeprom_ID_read;
char LSB_address;

// sbit FL_WREN_O = P1^5;

// sbit FL_ADDR_O_17 = P1^7;
// sbit FL_ADDR_O_16 = P1^6;
// sbit FL_ADDR_O_15 = P2^7;
// sbit FL_ADDR_O_14 = P2^6;
// sbit FL_ADDR_O_13 = P2^5;
// sbit FL_ADDR_O_12 = P2^4;
// sbit FL_ADDR_O_11 = P2^3;
// sbit FL_ADDR_O_10 = P2^2;
// sbit FL_ADDR_O_09 = P2^1;
// sbit FL_ADDR_O_08 = P2^0;
// sbit FL_ADDR_O_07 = P3^7;
// sbit FL_ADDR_O_06 = P3^6;
// sbit FL_ADDR_O_05 = P3^5;
// sbit FL_ADDR_O_04 = P3^4;
// sbit FL_ADDR_O_03 = P3^3;
// sbit FL_ADDR_O_02 = P3^2;
// sbit FL_ADDR_O_01 = P3^1;
// sbit FL_ADDR_O_00 = P3^0;

// //sbit FL_DATA_IO = P0;
// sbit FL_DATA_IO_07 = P0^7;
// sbit FL_DATA_IO_06 = P0^6;
// sbit FL_DATA_IO_05 = P0^5;
// sbit FL_DATA_IO_04 = P0^4;
// sbit FL_DATA_IO_03 = P0^3;
// sbit FL_DATA_IO_02 = P0^2;
// sbit FL_DATA_IO_01 = P0^1;
// sbit FL_DATA_IO_00 = P0^0;

unsigned char Memory_ReadByte(unsigned int address){
	char dat_byte;
	unsigned char address_high_eeprom;
	unsigned char address_low_eeprom;
	bit acknowledge = 0;

	address_high_eeprom = address >> 8;
	address_low_eeprom = address & 0xFF;
	do{
		I2C_start();
		acknowledge = I2C_write(0xA0);
	}while(acknowledge);

	I2C_write(address_high_eeprom);
	I2C_write(address_low_eeprom);
	I2C_start();
	I2C_write(0xA1);
	dat_byte = I2C_read();
	I2C_stop();
	return dat_byte;
}

// unsigned char Memory_ReadByte_Ext(unsigned int address){
// 	unsigned char dat_byte = (char)0x00;
// 	int i;

// 	FL_DATA_IO_07 = 1;
// 	FL_DATA_IO_06 = 1;
// 	FL_DATA_IO_05 = 1;
// 	FL_DATA_IO_04 = 1;
// 	FL_DATA_IO_03 = 1;
// 	FL_DATA_IO_02 = 1;
// 	FL_DATA_IO_01 = 1;
// 	FL_DATA_IO_00 = 1;

// 	FL_ADDR_O_17 = (address >> 17) & 0x01;
// 	FL_ADDR_O_16 = (address >> 16) & 0x01;
// 	FL_ADDR_O_15 = (address >> 15) & 0x01;
// 	FL_ADDR_O_14 = (address >> 14) & 0x01;
// 	FL_ADDR_O_13 = (address >> 13) & 0x01;
// 	FL_ADDR_O_12 = (address >> 12) & 0x01;
// 	FL_ADDR_O_11 = (address >> 11) & 0x01;
// 	FL_ADDR_O_10 = (address >> 10) & 0x01;
// 	FL_ADDR_O_09 = (address >>  9) & 0x01;
// 	FL_ADDR_O_08 = (address >>  8) & 0x01;
// 	FL_ADDR_O_07 = (address >>  7) & 0x01;
// 	FL_ADDR_O_06 = (address >>  6) & 0x01;
// 	FL_ADDR_O_05 = (address >>  5) & 0x01;
// 	FL_ADDR_O_04 = (address >>  4) & 0x01;
// 	FL_ADDR_O_03 = (address >>  3) & 0x01;
// 	FL_ADDR_O_02 = (address >>  2) & 0x01;
// 	FL_ADDR_O_01 = (address >>  1) & 0x01;
// 	FL_ADDR_O_00 = (address) & 0x01;

// 	FL_WREN_O = 1;

// 	for(i=0; i<10000; i++);

// 	dat_byte |= (FL_DATA_IO_07 & 0x01);
// 	dat_byte = dat_byte << 1;
// 	dat_byte |= (FL_DATA_IO_06 & 0x01);
// 	dat_byte = dat_byte << 1;
// 	dat_byte |= (FL_DATA_IO_05 & 0x01);
// 	dat_byte = dat_byte << 1;
// 	dat_byte |= (FL_DATA_IO_04 & 0x01);
// 	dat_byte = dat_byte << 1;
// 	dat_byte |= (FL_DATA_IO_03 & 0x01);
// 	dat_byte = dat_byte << 1;
// 	dat_byte |= (FL_DATA_IO_02 & 0x01);
// 	dat_byte = dat_byte << 1;
// 	dat_byte |= (FL_DATA_IO_01 & 0x01);
// 	dat_byte = dat_byte << 1;
// 	dat_byte |= (FL_DATA_IO_00 & 0x01);

// 	for(i=0; i<10000; i++);

// 	FL_DATA_IO_07 = 1;
// 	FL_DATA_IO_06 = 1;
// 	FL_DATA_IO_05 = 1;
// 	FL_DATA_IO_04 = 1;
// 	FL_DATA_IO_03 = 1;
// 	FL_DATA_IO_02 = 1;
// 	FL_DATA_IO_01 = 1;
// 	FL_DATA_IO_00 = 1;

// 	return dat_byte;
// }
/*
unsigned char Memory_ReadByte(unsigned int address){
		EECR = 0x00;
		EEARH = address >> 8;
		EEARL = address & 0xFF;
	  EECR = 0x0C;
	return (EEMISO);    
}*/

void Memory_WriteByte(unsigned int address, char data_to_send){
	//eeprom_ID_write = ((0xA0 +((address & 0xF0)>>7))+0);
	unsigned char address_high_eeprom;
	unsigned char address_low_eeprom;
	bit acknowledge = 0;

	address_high_eeprom = address >> 8;
	address_low_eeprom = address & 0xFF;
	do{
		I2C_start();
		acknowledge = I2C_write(0xA0); //command
	}while(acknowledge);
	I2C_write(address_high_eeprom); //address high
	I2C_write(address_low_eeprom);
	I2C_write(data_to_send);
	I2C_stop();
	I2C_delay();
}

// void Memory_WriteByte_Ext(unsigned int address, char data_to_send){
// 	int i;

// 	FL_ADDR_O_17 = (address >> 17) & 0x01;
// 	FL_ADDR_O_16 = (address >> 16) & 0x01;
// 	FL_ADDR_O_15 = (address >> 15) & 0x01;
// 	FL_ADDR_O_14 = (address >> 14) & 0x01;
// 	FL_ADDR_O_13 = (address >> 13) & 0x01;
// 	FL_ADDR_O_12 = (address >> 12) & 0x01;
// 	FL_ADDR_O_11 = (address >> 11) & 0x01;
// 	FL_ADDR_O_10 = (address >> 10) & 0x01;
// 	FL_ADDR_O_09 = (address >>  9) & 0x01;
// 	FL_ADDR_O_08 = (address >>  8) & 0x01;
// 	FL_ADDR_O_07 = (address >>  7) & 0x01;
// 	FL_ADDR_O_06 = (address >>  6) & 0x01;
// 	FL_ADDR_O_05 = (address >>  5) & 0x01;
// 	FL_ADDR_O_04 = (address >>  4) & 0x01;
// 	FL_ADDR_O_03 = (address >>  3) & 0x01;
// 	FL_ADDR_O_02 = (address >>  2) & 0x01;
// 	FL_ADDR_O_01 = (address >>  1) & 0x01;
// 	FL_ADDR_O_00 = (address) & 0x01;
// 	FL_WREN_O = 0;

// 	for(i=0; i<10000; i++);

// 	FL_DATA_IO_07 = (data_to_send >>  7) & 0x01;
// 	FL_DATA_IO_06 = (data_to_send >>  6) & 0x01;
// 	FL_DATA_IO_05 = (data_to_send >>  5) & 0x01;
// 	FL_DATA_IO_04 = (data_to_send >>  4) & 0x01;
// 	FL_DATA_IO_03 = (data_to_send >>  3) & 0x01;
// 	FL_DATA_IO_02 = (data_to_send >>  2) & 0x01;
// 	FL_DATA_IO_01 = (data_to_send >>  1) & 0x01;
// 	FL_DATA_IO_00 = (data_to_send) & 0x01;

// 	for(i=0; i<10000; i++);

// 	FL_WREN_O = 1;
			
// 	FL_DATA_IO_07 = 1;
// 	FL_DATA_IO_06 = 1;
// 	FL_DATA_IO_05 = 1;
// 	FL_DATA_IO_04 = 1;
// 	FL_DATA_IO_03 = 1;
// 	FL_DATA_IO_02 = 1;
// 	FL_DATA_IO_01 = 1;
// 	FL_DATA_IO_00 = 1;

// }

/*
void Memory_WriteByte(unsigned int address, char data_to_send){
		EECR = 0xFF;
		EEARH = address >> 8;
		EEARL = address & 0xFF;
		EEMOSI = data_to_send;
		EECR = 0x00;
}*/

int Memory_ReadBlock(unsigned int address, unsigned int read_size, unsigned char * databyte){
	unsigned int count;
	for( count=0; count < read_size; count++){
	  *(databyte+count) = Memory_ReadByte(address+count);
	}
	return count;
}

int Memory_WriteBlock(unsigned int address, unsigned int write_size, unsigned char * databyte) {
	unsigned int count;
	for( count=0; count < write_size; count++){
		Memory_WriteByte(address+count, *(databyte+count));
	}
	return count;
}