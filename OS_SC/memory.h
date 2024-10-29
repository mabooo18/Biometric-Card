#ifndef __MEMORY_H__
#define __MEMORY_H__

extern char eeprom_ID_write;
extern char eeprom_ID_read;
extern char LSB_address;

unsigned char Memory_ReadByte(unsigned int address);
unsigned char Memory_ReadByte_Ext(unsigned int address);
void Memory_WriteByte_Ext(unsigned int address, char data_to_send);
void Memory_WriteByte(unsigned int address, char data_to_send);
int Memory_ReadBlock(unsigned int address, unsigned int read_size, unsigned char * databyte);
int Memory_WriteBlock(unsigned int address, unsigned int write_size, unsigned char * databyte);
#endif