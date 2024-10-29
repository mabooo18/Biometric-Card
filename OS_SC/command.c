#include <reg51.h>
#include <string.h>
#include "config.h"
#include "command.h"
#include "response.h"
#include "transmission.h"
#include "memory.h"
#include "fs.h"
#include "state.h"
#include "krisna.h"

#define ECC_ADDR	0x01B2
#define BC3_ADDR		0x01AA
#define SHA_ADDR		0x016A

#define REC3_ADDR 0x0200
#define REC4_ADDR 0x0210
#define REC5_ADDR 0x0220
#define KEY_AUTH 0x0240
#define EXP_AUTH 0x0230


unsigned char response[90];
unsigned char resplen;
unsigned char buffer[8];
unsigned char pin[PIN_LEN];
unsigned char encrypted[CRYPT_BLOCK_LEN];

void Command_Write()//verified
{
	unsigned int i; //variabel untuk iterasi penulisan data
	unsigned int length; //panjang data yang akan ditulis
	unsigned char data_to_write;//data yang akan ditulis
	unsigned int address_EEPROM;//alamat data 

	address_EEPROM = (header[2]<<8)+header[3]; //alamat data diperoleh dari P1 dan P2

	length = (unsigned int) header[4];//panjang data yang akan ditulis diperoleh dari P3

	for( i=0; i<length; i++) //mengulang proses penulisan sebanyak length
	{
		//ack
		Transmission_SendByte( ~header[1] );
		
		//mendapatkan data yang akan ditulis
		data_to_write = Transmission_GetByte();
		//menulis data ke EEPROM
		Memory_WriteByte( address_EEPROM+i, data_to_write );
	}
	
	//mengirimkan respons OK setelah selesai penulisan
	Response_SetSW( Response_OK, 0);
}


void Command_Read() // verified 8 April 2016
{

	unsigned char i; // variabel untuk iterasi pembacaan data
	unsigned int length;//panjang data yang akan dibaca
	unsigned int address_EEPROM;//alamat data pertama yang akan dibaca
	unsigned char data_to_read;//data yang dibaca

	length = (unsigned int) header[4]; //panjang data diperoleh dari P3
	address_EEPROM = (header[2]<<8)+header[3];//

	/* ACK untuk mengirimkan banyak byte berturut-turut*/
	Transmission_SendByte( header[1] );

	for( i=0; i<length; i++ ) //mengulang proses pembacaan data sebanyak length
	{
		data_to_read = Memory_ReadByte( address_EEPROM+i); //membaca data dari EEPROM
		Transmission_SendByte( data_to_read );//mentransmisikan data yang dibaca
	}
		
	//mengirimkan respons OK setelah selesai pengiriman seluruh data
	Response_SetSW( Response_OK , 0);

}

void Command_Tes() {
	unsigned int result;

	

	result = FS_SearchAllFID(((unsigned int)(header[2])<<8)+(unsigned int)header[3]);

	Transmission_SendByte( header[1] );
	Transmission_SendByte( (result>>8) );
	Transmission_SendByte( result );

	Response_SetSW( Response_OK, 0);

}

void Command_ReadSHM(){
	unsigned char data_to_read;
	unsigned char address_SHM;
	Transmission_SendByte( ~header[1] );
	address_SHM = header[3];
	data_to_read = read_data_independent( address_SHM );
	Transmission_SendByte(data_to_read);
	Response_SetSW( Response_OK, 0);
}



// void Command_ReadSHM(){
// 	unsigned int current, body, size, record_num, offset;
// 	unsigned char record_le, i, record_current_addr, record_next_addr;
// 	unsigned char databyte;

// 	record_num = header[2];
// 	current = State_GetCurrent();

// 	FS_GET_HEADER_BODY_POINTER(current,&body);
// 	FS_GET_RECORD_FIXED_LENGTH(body, &record_le);
// 	FS_GET_BODY_SIZE(body, &size);

// 	FS_GET_RECORD_VAR_LENGTH(body, record_num-1, &record_current_addr);
// 	FS_GET_RECORD_VAR_LENGTH(body, record_num, &record_next_addr);
// 	record_le=record_next_addr-record_current_addr;
// 	offset=record_current_addr+size+1;
	
// 	// Send ACK
// 	Transmission_SendByte( header[1] );
// 	for(i = 0; i<record_le;i++) {
// 		FSAccessBinary(FS_OP_READ,offset+i,1,&databyte);
// 		Transmission_SendByte(databyte);
// 	}
// 	Response_SetSW( Response_OK, 0);
// }

void Command_GetCurrent()//verified 9 April 2016
{
	unsigned int current, body, length, record_num;
	unsigned char ac, structure, tag, record_current_addr, record_next_addr;

	record_num = State_GetCurrentRecord();
	current = State_GetCurrent();
	FS_GET_HEADER_BODY_POINTER(current,&body);
	FS_GET_HEADER_TAG(current,&tag);
	FS_GET_BODY_STRUCTURE(body, &structure);
	FS_GET_BODY_SIZE(body, &length);
	ac=FS_GetAC();
	FS_GET_RECORD_VAR_LENGTH(body, record_num-1, &record_current_addr);
	FS_GET_RECORD_VAR_LENGTH(body, record_num, &record_next_addr);
	
	Transmission_SendByte( header[1] );		
	Transmission_SendByte( (current>>8) );
	Transmission_SendByte( current );
	Transmission_SendByte( (body>>8) );
	Transmission_SendByte( body );
	Transmission_SendByte( (length>>8) );
	Transmission_SendByte( length );
	Transmission_SendByte( record_current_addr );
	Transmission_SendByte( record_next_addr );
	Transmission_SendByte( structure );
	Transmission_SendByte( tag );
	Transmission_SendByte( record_num );


	Response_SetSW( Response_OK, 0);
}

void Command_GetSecurity() //no acupdate verified 9 April 2016
{
	unsigned char security, acread;
	
	Transmission_SendByte( header[1] );
	security = State_GetCurrentSecurity();
	Transmission_SendByte( security );

	if( header[4]>1 ) {
		acread = FS_GetAC();
		Transmission_SendByte( acread );
	}	

	Response_SetSW(Response_OK, 0);
}

void Command_Format() {
	unsigned int i;
	if (!(FSFormat() == FS_OK)) {
		Response_SetSW( Response_FatalError , 0);
		return;
	}

	Response_SetSW( Response_OK , 0);
}

//verified 8 April 2016
void Command_Encrypt() {
	unsigned int i;
	unsigned char temp;
	if (header[4] == 8){
		for(i=0; i<header[4]; i++) {
			Transmission_SendByte( ~header[1] );

			temp = Transmission_GetByte();
			write_data_independent((addr_dati_BC3+i),temp);
			temp = Memory_ReadByte(RAND_STATE_ADDR + i);
			write_data_independent((addr_k_BC3+i),temp);
		}
		BC3_encrypt_k_sequential();
		resplen = 8;
		for (i=0; i<resplen; i++) {
			response[i] = read_data_sequential(addr_dato_BC3+i);
			Memory_WriteByte(BC3_ADDR+i, response[i]);
		}
		for(i=0; i<header[4]; i++) {		
			write_data_independent((addr_dati_BC3+i),response[i]);
			temp = Memory_ReadByte(RAND_STATE_ADDR + i);
			write_data_independent((addr_k_BC3+i),temp);
		}
		BC3_decrypt_k_sequential();
		resplen = 8;
		for (i=0; i<resplen; i++){
			response[i+8] = read_data_sequential(addr_dato_BC3+i);
		}
	}
	
	if (header[4] == 90) {
		for(i=0; i<60; i++){
			Transmission_SendByte( ~header[1] );
			temp = Transmission_GetByte();
			write_data_independent((addr_xi_ECC+i),temp);
		}
		
		for(i=0; i<30; i++) {
			Transmission_SendByte( ~header[1] );
			temp = Transmission_GetByte();
			write_data_independent((addr_k_ECC+i),temp);
			Memory_WriteByte(KEY_ECC_ADDR_RD + i, temp);
		}
		ECC_sequential();
		for (i=0; i<60; i++){
		response[i] = read_data_sequential(addr_xo_ECC+i);
			Memory_WriteByte(ECC_ADDR+i, response[i]);
		}
	}

	if (header[4] == 64) {
		for(i=0; i<64; i++){
			Transmission_SendByte( ~header[1] );
			temp = Transmission_GetByte();
			write_data_independent((addr_dati_HASH+i),temp);
		}
		HASH_sequential();
		for(i=0; i<32; i++){
			temp = read_data_sequential(addr_dato_HASH+i);
			Memory_WriteByte(SHA_ADDR+i, temp);			
		}
	}

	Response_SetSW(Response_OK, 0);
}

//Verified by mahendra 7 April 2016
void Command_GetCurrentChallenge() {
	unsigned char i, buf[CRYPT_BLOCK_LEN];
	if( !(header[4] == CRYPT_BLOCK_LEN ) ){
		Response_SetSW( Response_WrongLength , 0);
		return;
	}

	/* ACK */
	Transmission_SendByte( header[1] );
	State_GetCurrentChallenge();

	for( i=0; i<CRYPT_BLOCK_LEN; i++ ){
		Transmission_SendByte( buf[i] );
	}
	Response_SetSW( Response_OK , 0);
}


void Command_CreateFile() //verified 9 April 2016
{
	unsigned char tag;
	unsigned int file_size, fid;
	unsigned char ac, record_le;
	unsigned char result;
	struct DF_st df;
	struct EF_st ef;
	unsigned char filetype, rfu1, rfu2; //untuk menyimpan byte 1-2 data yang belum digunakan
	
	Transmission_SendByte( ~header[1] );
	rfu1 = (unsigned int)(Transmission_GetByte());
	Transmission_SendByte( ~header[1] );
	rfu2 = (unsigned int) (Transmission_GetByte());
	
	//get file size
	Transmission_SendByte( ~header[1] );
	file_size = (unsigned int)(Transmission_GetByte()) <<8;
	Transmission_SendByte( ~header[1] );
	file_size |= (unsigned int)(Transmission_GetByte());
	
	//get fid
	Transmission_SendByte( ~header[1] );
	fid = (unsigned int) (Transmission_GetByte()) << 8;
	Transmission_SendByte( ~header[1] );
	fid |= (unsigned int) (Transmission_GetByte());
	
	// get file type
	Transmission_SendByte( ~header[1] );
	filetype = (unsigned int) (Transmission_GetByte());
	
	//get ac status / acread
	Transmission_SendByte( ~header[1] );
	ac= (unsigned int) (Transmission_GetByte());

	//check security status
	if( !((State_GetCurrentSecurity())>=0x01)) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	//get tag
	if (filetype == 0x38) {
		tag = FS_TAG_DF;
	} else
	if ((filetype == 0x01)||(filetype == 0x02)||(filetype == 0x04)||(filetype == 0x06)) {
		tag = FS_TAG_EF;
	} else {
		tag = 0;
	}
	
	switch( tag ) {
		case FS_TAG_DF:
			df.FID = fid;
			result = FSCreateFile(tag,&df);
			break;
		case FS_TAG_EF:
			ef.FID = fid;
			ef.type = FS_EF_TYPE_WORKING;
			ef.AC = ac; //(ac && 0xf0) >> 4;
			ef.file_size = file_size;
			switch(filetype){
				case FS_EF_STRUCTURE_TRANSPARENT: { 
					ef.structure = FS_EF_STRUCTURE_TRANSPARENT;
					break;
				}
				case FS_EF_STRUCTURE_RECORD_FIXED: {
					ef.structure = FS_EF_STRUCTURE_RECORD_FIXED;
					//get record length / acupdate
					Transmission_SendByte( ~header[1] );
					record_le = (unsigned int) (Transmission_GetByte());
					ef.record_le = record_le;
					break;
				}
				case FS_EF_STRUCTURE_RECORD_VAR: 
					ef.structure = FS_EF_STRUCTURE_RECORD_VAR;
					break;
				case FS_EF_STRUCTURE_CYCLIC:
					ef.structure = FS_EF_STRUCTURE_CYCLIC;
					break;
				default: 
					ef.structure = FS_EF_STRUCTURE_TRANSPARENT;
			}
			result = FSCreateFile(tag,&ef);
			//result = FS_OK;
			break;
		default:
			result = FS_ERROR;
	}

	switch ( result ) {
		case FS_OK:
			Response_SetSW( Response_OK , 0);
			break;
		case FS_ERROR_DUPLICATE_FID:
			Response_SetSW( Response_WrongP1P2_FileExist , 0);
			break;
		case FS_ERROR_INSUFFICIENT_SPACE:
			Response_SetSW( Response_WrongP1P2_NotEnoughMem , 0);
			break;
		case FS_ERROR_WRONG_FS_STRUCTURE:
			Response_SetSW( Response_CmdNotAllowed_Incompatible_FS , 0);
			break;
		case FS_ERROR:
			Response_SetSW( Response_FatalError , 0);
			break;
		default:
			Response_SetSW( Response_Normal , 0);
			break;
	}
}

void Command_Select() //verified 10 April 2016
{
	unsigned int current,body, length;
	unsigned int fid;
	unsigned int record_num;
	unsigned char structure;
	
	//check security status
	if( !((State_GetCurrentSecurity())>=0x01)) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}

	// Check P1 for file selection
	if( header[2] == 0x00 ) {
		/* Select MF */
		if(header[4] == 0) {
			FSSelectMF();
			Response_SetSW(Response_OK, 0);
		} else {
			Transmission_SendByte( ~header[1] );
			fid = (unsigned int)(Transmission_GetByte()) << 8;

			Transmission_SendByte( ~header[1] );
			fid |= Transmission_GetByte();

			switch( FS_SelectFID(fid) ) {
				case FS_OK: {
					Response_SetSW(Response_OK, 0);
					break;
				}
				case FS_ERROR_NOT_FOUND: 
					Response_SetSW( Response_WrongP1P2_FileNotFound, 0);
					return;
					break; 
			}
		}
	} else {
		Response_SetSW( Response_WrongP1P2_IncorrectP1P2, 0);
		return;
	}

	// Check File Structure
	current = State_GetCurrent();
	FS_GET_HEADER_BODY_POINTER(current,&body);
	FS_GET_BODY_SIZE(body, &length);
	FS_GET_BODY_STRUCTURE(body, &structure);
	
	if((structure==FS_EF_STRUCTURE_RECORD_FIXED) || (structure==FS_EF_STRUCTURE_RECORD_VAR)) {
		if( header[3] == 0x00 ){
			record_num = 1;
			State_SetCurrentRecord(record_num);
		}else
		if ( header[3] == 0x01 ){
			record_num = length;
			State_SetCurrentRecord(record_num);
		}else
		if ( header[3] == 0x02 ){
			if( State_GetCurrentRecord() ==  length){
				Response_SetSW( Response_WrongP1P2_RecordNotFound, 0);
				return;
			}else{
				record_num = State_GetCurrentRecord() + 1;
				State_SetCurrentRecord(record_num);
			}
		}else
		if ( header[3] == 0x03 ){
			if( State_GetCurrentRecord() ==  1){
				Response_SetSW( Response_WrongP1P2_RecordNotFound, 0);
				return;
			}else{
				record_num = State_GetCurrentRecord() - 1;
				State_SetCurrentRecord(record_num);
			}
		}
	}
}

void Command_DeleteFile() {
	unsigned int fid;

	Transmission_SendByte( ~header[1] );
	fid = (unsigned int)(Transmission_GetByte()) << 8;

	Transmission_SendByte( ~header[1] );
	fid |= Transmission_GetByte();

	switch ( FSDeleteFile(fid) ) {
		case FS_OK:
			Response_SetSW( Response_OK , 0);
			break;
		default:
			Response_SetSW( Response_WrongP1P2_FileNotFound , 0);
			break;
	}
}

unsigned char Initial_Binary_Check(unsigned int *length, unsigned int *offset){
	unsigned int current, body, fid, tag;
	unsigned int tempLength;
	unsigned char security, structure;

	// Check security status
	security = State_GetCurrentSecurity();
	if( !( security >= 0x01 )) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return 2;
	}

	if( header[2]&0x80 == 0x80 ) {
		fid=header[2]&0x1F; //get only bit4-07
		switch( FS_SelectFID(fid) ){
			case FS_OK:
				break;
			case FS_ERROR_NOT_FOUND:
				Response_SetSW( Response_WrongP1P2_FileNotFound, 0);
				return 2;
				break;
		}
		*offset = header[3];
	} else {
		current = State_GetCurrent();
		if ( current == 0x00 ) {
			Response_SetSW(Response_CmdNotAllowed_NoCurrentEF, 0);
			return 2;
		}
		*offset = (header[2] << 8) | header[3];
	}
	
	current = State_GetCurrent();
	FS_GET_HEADER_TAG(current,&tag);
	FS_GET_HEADER_BODY_POINTER(current,&body);
	FS_GET_BODY_SIZE(body, &tempLength);
	*length = tempLength;

	//Check tag file
	if(tag == FS_TAG_DF) {
		Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
		return 2;
	}
	
	// Check offset > file length
	if (*offset>tempLength) {
		Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
		return 2;
	}
	
	// Check file structure
	FS_GET_BODY_STRUCTURE(body, &structure);
	if(!(structure==FS_EF_STRUCTURE_TRANSPARENT)) {
		Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
		return 2;
	}

	return 0;
}

void Command_ReadBinary(){
	unsigned int offset, length, le;
	unsigned char data_binary;
	unsigned char i, ac;
	
	if(Initial_Binary_Check(&length, &offset) != 0){
		return;
	}
	
	//check access condition
	ac=FS_GetAC();
	if(!( ac&0x01 == 0x01 )) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	le = header[4];
	
	Transmission_SendByte( header[1] );
	Transmission_SendByte( length );
	Transmission_SendByte( offset );
	// If Le = 0, Read all data in file
	// if(le==0) {
	// 	for( i=0; i<length; i++ ) {
	// 		FSAccessBinary(FS_OP_READ,offset+i,1,&data_binary);
	// 		Transmission_SendByte(data_binary);
	// 	}
	// }else
	// // If Le + Offset > length of file, Read until EOF
	// if((le+offset)>length) {
	// 	for( i=0; i<(length-offset); i++ ) {
	// 		FSAccessBinary(FS_OP_READ,offset+i,1,&data_binary);
	// 		Transmission_SendByte(data_binary);
	// 	}
	// 	Response_SetSW(Response_Warning_EndOfFile, 0);
	// 	return;
	// } else {
	// // Read normally
	// 	for( i=0; i<le; i++ ) {
	// 		FSAccessBinary(FS_OP_READ,offset+i,1,&data_binary);
	// 		Transmission_SendByte(data_binary);
	// 	}
	// }
		
	Response_SetSW( Response_OK, 0 );
}

void Command_UpdateBinary(){
	unsigned int offset, length, le;
	unsigned char data_binary;
	unsigned char i, ac;
	
	if(Initial_Binary_Check(&length, &offset) != 0){
		return;
	}
	
	//check access condition
	ac=FS_GetAC();
	if(!( ac&0x01 == 0x01 )){
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	le = (unsigned int) header[4];

	//If Le+Offset > length of file, Write until EOF
	if((le+offset)>length) {
		for( i=0; i<(length-offset); i++) {
			Transmission_SendByte( ~header[1] );

			data_binary = Transmission_GetByte();

			FSAccessBinary(FS_OP_UPDATE,offset+i,1,&data_binary);
		}	
		Response_SetSW(Response_Warning_EndOfFile, 0);
		return;
	} else {
		//Read normally
		for( i=0; i<le; i++) {
			Transmission_SendByte( ~header[1] );

			data_binary = Transmission_GetByte();

			FSAccessBinary(FS_OP_UPDATE,offset+i,1,&data_binary);
		}	
	}

	Response_SetSW( Response_OK , 0);
}

void Command_EraseBinary() {
	unsigned int offset, length, le;
	unsigned char i, ac;
	
	if(Initial_Binary_Check(&length, &offset) != 0){
		return;
	}
	
	//check access condition
	ac=FS_GetAC();
	if(!( ac&0x01 == 0x01 )){
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	le = (unsigned int) header[4];

	//If Le+Offset > length of file, Write until EOF
	if((le+offset)>length){
		for( i=0; i<(length-offset); i++) {
			FSAccessBinary(FS_OP_UPDATE,offset+i,1,0xFF);
		}	
		Response_SetSW(Response_Warning_EndOfFile, 0);
		return;
	} else {
		//Read normally
		for( i=0; i<le; i++) {
			FSAccessBinary(FS_OP_UPDATE,offset+i,1,0xFF);
		}	
	}

	Response_SetSW( Response_OK , 0);
}

void Command_WriteBinary(){
	unsigned int offset, length, le;
	unsigned char data_binary, data_read, data_write;
	unsigned char i, ac;
	
	if(Initial_Binary_Check(&length, &offset) != 0){
		return;
	}
	
	//check access condition
	ac=FS_GetAC();
	if(!( ac&0x01 == 0x01 )){
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	le = (unsigned int) header[4];

	//If Le+Offset > length of file, Write until EOF
	if((le+offset)>length) {
		for( i=0; i<(length-offset); i++) {
			Transmission_SendByte( ~header[1] );

			data_write = Transmission_GetByte();
			
			FSAccessBinary(FS_OP_READ,offset+i,1,&data_read);
			
			data_binary = data_write & data_read;
			
			FSAccessBinary(FS_OP_UPDATE,offset+i,1,&data_binary);
		}	
		Response_SetSW(Response_Warning_EndOfFile, 0);
		return;
	} else {
		//Read normally
		for( i=0; i<le; i++) {
			Transmission_SendByte( ~header[1] );

			data_write = Transmission_GetByte();
			
			FSAccessBinary(FS_OP_READ,offset+i,1,&data_read);
			
			data_binary = data_write & data_read;

			FSAccessBinary(FS_OP_UPDATE,offset+i,1,&data_binary);
		}	
	}

	Response_SetSW( Response_OK , 0);
}


void Read_One_Record(unsigned char structure, unsigned int body, unsigned int size, unsigned int record_num){
	unsigned char record_le;
	unsigned char databyte;
	unsigned char record_current_addr, record_next_addr;
	unsigned int offset, i;

	if(structure==FS_EF_STRUCTURE_RECORD_FIXED){
		FS_GET_RECORD_FIXED_LENGTH(body, &record_le);
		offset = record_le*(record_num-1)+1;
		for(i = 0; i<record_le;i++) {
			FSAccessBinary(FS_OP_READ,offset+i,1,&databyte);
			Transmission_SendByte(databyte);
		}
	} else {
		FS_GET_RECORD_VAR_LENGTH(body, record_num-1, &record_current_addr);
		FS_GET_RECORD_VAR_LENGTH(body, record_num, &record_next_addr);
		record_le=record_next_addr-record_current_addr;
		offset=record_current_addr+size+1;
		
		for(i = 0; i<record_le;i++) {
			FSAccessBinary(FS_OP_READ,offset+i,1,&databyte);
			Transmission_SendByte(databyte);
		}
	}
}

unsigned char Update_One_Record(unsigned char structure, unsigned int body, unsigned int size, unsigned int record_num, unsigned char length){
	unsigned char record_le;
	unsigned char databyte, i;
	unsigned char record_current_addr, record_next_addr;
	unsigned int offset;

	if(structure==FS_EF_STRUCTURE_RECORD_FIXED){
		FS_GET_RECORD_FIXED_LENGTH(body, &record_le);
		offset = record_le*(record_num-1)+1;
		if( length == record_le ){
			for(i = 0; i<record_le;i++) {
				Transmission_SendByte( ~header[1] );
				databyte = Transmission_GetByte();
				FSAccessBinary(FS_OP_UPDATE,offset+i,1,&databyte);
			}
		} else {
			return record_le;
		}
	} else {
		FS_GET_RECORD_VAR_LENGTH(body, record_num-1, &record_current_addr);
		FS_GET_RECORD_VAR_LENGTH(body, record_num, &record_next_addr);
		record_le=record_next_addr-record_current_addr;
		offset=record_current_addr+size+1;
		if( length == record_le ){		
			for(i = 0; i<record_le;i++) {
				Transmission_SendByte( ~header[1] );
				databyte = Transmission_GetByte();
				FSAccessBinary(FS_OP_UPDATE,offset+i,1,&databyte);
			}
		} else {
			return record_le;
		}
	}
	return 0;
}

unsigned char Write_One_Record(unsigned char structure, unsigned int body, unsigned int size, unsigned int record_num, unsigned char length){
	unsigned char record_le;
	unsigned char databyte, i, data_write, data_read;
	unsigned char record_current_addr, record_next_addr;
	unsigned int offset;

	if(structure==FS_EF_STRUCTURE_RECORD_FIXED){
		FS_GET_RECORD_FIXED_LENGTH(body, &record_le);
		offset = record_le*(record_num-1)+1;
		if( length == record_le ){
			for(i = 0; i<record_le;i++) {
				Transmission_SendByte( ~header[1] );
				data_write = Transmission_GetByte();
			
				FSAccessBinary(FS_OP_READ,offset+i,1,&data_read);
			
				databyte = data_write & data_read;
				FSAccessBinary(FS_OP_UPDATE,offset+i,1,&databyte);
			}
		} else {
			return record_le;
		}
	} else {
		FS_GET_RECORD_VAR_LENGTH(body, record_num-1, &record_current_addr);
		FS_GET_RECORD_VAR_LENGTH(body, record_num, &record_next_addr);
		record_le=record_next_addr-record_current_addr;
		offset=record_current_addr+size+1;
		if( length == record_le ){		
			for(i = 0; i<record_le;i++) {
				Transmission_SendByte( ~header[1] );
				data_write = Transmission_GetByte();
			
				FSAccessBinary(FS_OP_READ,offset+i,1,&data_read);
			
				databyte = data_write & data_read;
				FSAccessBinary(FS_OP_UPDATE,offset+i,1,&databyte);
			}
		} else {
			return record_le;
		}
	}
	return 0;
}


void Command_ReadRecord(){
	unsigned int current, body, size, tag, record_num;
	unsigned char i, security, structure, ac;
	
	// Check security status
	security = State_GetCurrentSecurity();
	if( !( security >= 0x01 )) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	// File selection check
	if ((header[3]&0xF8) == 0x00){
		//select current file
		current = State_GetCurrent();
		if ( current == 0x00 ) {
			Response_SetSW(Response_CmdNotAllowed_NoCurrentEF, 0);
			return;
		}
	} else {
		Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
		return;
	}
	
	FS_GET_HEADER_TAG(current,&tag);
	FS_GET_HEADER_BODY_POINTER(current,&body);
	FS_GET_BODY_SIZE(body, &size);
	
	//Check tag file
	if(tag == FS_TAG_DF) {
		Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
		return;
	}
	
	// Check file structure
	FS_GET_BODY_STRUCTURE(body, &structure);
	if( !( (structure==FS_EF_STRUCTURE_RECORD_FIXED) || (structure==FS_EF_STRUCTURE_RECORD_VAR) ) ) {
		Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
		return;
	}
	
	// Check access condition
	ac=FS_GetAC();
	if(!( ac&0x01 == 0x01 )) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	// Check P1
	if(header[2]==0x00){
		record_num = State_GetCurrentRecord();
	} else{
		record_num = header[2];
	}
	
	// Check P1
		if(record_num>size){
			Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
			return;
		}
	
		// Check P2[2]
		// Send ACK
		Transmission_SendByte( header[1] );
		if((header[3]&0x04)==0x04){//P2[2]==1
			//check P2[1..0]
			if((header[3]&0x03)==0x00){
				Read_One_Record(structure,body,size,record_num);
			} else
			if((header[3]&0x03)==0x01){
				for(i=record_num;i<=size;i++){
					Read_One_Record(structure,body,size,i);
				}
			} else
			if((header[3]&0x03)==0x02){
				for(i=size;i>=record_num;i--){
					Read_One_Record(structure,body,size,i);
				}
			} else {
				Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
				return;
			}
		} else {
			//check P2[1..0]
			if((header[3]&0x03)==0x00){
				record_num = 1;
				Read_One_Record(structure,body,size,record_num);
			} else
			if((header[3]&0x03)==0x01){
				if(record_num!=size){
					record_num = record_num+1;
					Read_One_Record(structure,body,size,record_num);
				}else{
					Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
					return;
				}
			} else
			if((header[3]&0x03)==0x02){
				if(record_num!=1){
					record_num = record_num-1;
					Read_One_Record(structure,body,size,record_num);
				}else{
					Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
					return;
				}
			} else	
			if((header[3]&0x03)==0x03){
				record_num = size;
				Read_One_Record(structure,body,size,record_num);
			} else {
				Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
				return;
			}
		}
	
	Response_SetSW( Response_OK, 0 );
}

void Command_UpdateRecord(){
	unsigned int current, body, size, tag, record_num;
	unsigned char security, structure, ac, status;
	
	// Check security status
	security = State_GetCurrentSecurity();
	if( !( security >= 0x01 )) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	// File selection check
	if ( (header[3]&0xF8) == 0x00){
		//select current file
		current = State_GetCurrent();
		if ( current == 0x00 ) {
			Response_SetSW(Response_CmdNotAllowed_NoCurrentEF, 0);
			return;
		}
	} else {
		Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
		return;
	}
	
	current = State_GetCurrent();
	FS_GET_HEADER_TAG(current,&tag);
	FS_GET_HEADER_BODY_POINTER(current,&body);
	FS_GET_BODY_SIZE(body, &size);
	
	//Check tag file
	if(tag == FS_TAG_DF) {
		Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
		return;
	}
	
	// Check file structure
	FS_GET_BODY_STRUCTURE(body, &structure);
	if( !( (structure==FS_EF_STRUCTURE_RECORD_FIXED) || (structure==FS_EF_STRUCTURE_RECORD_VAR) ) ) {
		Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
		return;
	}
	
	//check access condition
	ac=FS_GetAC();
	if(!( ac&0x01 == 0x01 )) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	//check P1
	if(header[2]==0x00){
		record_num = State_GetCurrentRecord();
	} else {
		record_num = header[2];
	}

	//check P1
	if(record_num>size){
		Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
		return;
	}
	
	//check P2[2]
	if( (header[3]&0x04) == 0x04 ){//P2[2]==1
		status = Update_One_Record(structure,body,size,record_num,header[4]);
	} else {
		//check P2[1..0]
		if( (header[3] & 0x03) == 0x00 ){
			record_num = 1;
			status = Update_One_Record(structure,body,size,record_num,header[4]);
		} else
		if( (header[3] & 0x03) == 0x01 ){
			if(record_num!=size){
				record_num = record_num+1;
				status = Update_One_Record(structure,body,size,record_num,header[4]);
			}else{
				Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
				return;
			}
		} else
		if( (header[3] & 0x03) == 0x02 ){
			if(record_num!=1){
				record_num = record_num-1;
				status = Update_One_Record(structure,body,size,record_num,header[4]);
			}else{
				Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
				return;
			}
		} else {
			record_num = size;
			status = Update_One_Record(structure,body,size,record_num,header[4]);
		}
	}

	if(status != 0){
		Response_SetSW( Response_WrongLength, status );
		return;
	}

	Response_SetSW( Response_OK, 0 );
}

void Command_WriteRecord(){
	unsigned int current, body, size, tag, record_num;
	unsigned char security, structure, ac, status;
	
	// Check security status
	security = State_GetCurrentSecurity();
	if( !( security >= 0x01 )) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	// File selection check
	if ( (header[3]&0xF8) == 0x00){
		//select current file
		current = State_GetCurrent();
		if ( current == 0x00 ) {
			Response_SetSW(Response_CmdNotAllowed_NoCurrentEF, 0);
			return;
		}
	} else {
		Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
		return;
	}
	
	current = State_GetCurrent();
	FS_GET_HEADER_TAG(current,&tag);
	FS_GET_HEADER_BODY_POINTER(current,&body);
	FS_GET_BODY_SIZE(body, &size);
	
	//Check tag file
	if(tag == FS_TAG_DF) {
		Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
		return;
	}
	
	// Check file structure
	FS_GET_BODY_STRUCTURE(body, &structure);
	if( !( (structure==FS_EF_STRUCTURE_RECORD_FIXED) || (structure==FS_EF_STRUCTURE_RECORD_VAR) ) ) {
		Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
		return;
	}
	
	//check access condition
	ac=FS_GetAC();
	if(!( ac&0x01 == 0x01 )) {
		Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
		return;
	}
	
	//check P1
	if(header[2]==0x00){
		record_num = State_GetCurrentRecord();
	} else {
		record_num = header[2];
	}

	//check P1
	if(record_num>size){
		Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
		return;
	}
	
	//check P2[2]
	if( (header[3]&0x04) == 0x04 ){//P2[2]==1
		status = Update_One_Record(structure,body,size,record_num,header[4]);
	} else {
		//check P2[1..0]
		if( (header[3] & 0x03) == 0x00 ){
			record_num = 1;
			status = Write_One_Record(structure,body,size,record_num,header[4]);
		} else
		if( (header[3] & 0x03) == 0x01 ){
			if(record_num!=size){
				record_num = record_num+1;
				status = Update_One_Record(structure,body,size,record_num,header[4]);
			}else{
				Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
				return;
			}
		} else
		if( (header[3] & 0x03) == 0x02 ){
			if(record_num!=1){
				record_num = record_num-1;
				status = Update_One_Record(structure,body,size,record_num,header[4]);
			}else{
				Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
				return;
			}
		} else {
			record_num = size;
			status = Write_One_Record(structure,body,size,record_num,header[4]);
		}
	}

	if(status != 0){
		Response_SetSW( Response_WrongLength, status );
		return;
	}

	Response_SetSW( Response_OK, 0 );
}


//Verified Mahendra 07 april 2016
void Command_Verify() {
	unsigned char i;
	unsigned char retries;

	if( header[4] != PIN_LEN ) {
		Response_SetSW( Response_WrongLength , 0);
		return;
	}

	for( i=0; i<PIN_LEN; i++ ) {
		Transmission_SendByte( ~header[1] );
		pin[i] = Transmission_GetByte();
	}
	Transmission_SendByte( header[1] );

	switch( State_Verify() ) {
		case STATE_OK:
			Response_SetSW( Response_OK , 0);
			break;
		case STATE_BLOCKED:
			Response_SetSW( Response_CmdNotAllowed_AuthBlocked , 0);
			break;
		case STATE_WRONG:
			retries = Memory_ReadByte(PIN_RETRIES_ADDR);
			Response_SetSW( Response_Warning_Counter  , retries & 0x0F);
	}
}

// void Command_GetChallenge() {
// 	unsigned char i;

// 	if( !(header[4] == CRYPT_BLOCK_LEN ) ){
// 		Response_SetSW( Response_WrongLength , 0);
// 		return;
// 	}

// 	Transmission_SendByte( header[1] );

// 	State_GetChallenge();

// 	for( i=0; i<CRYPT_BLOCK_LEN; i++ ){
// 		Transmission_SendByte( buffer[i] );
// 	}

// 	Response_SetSW( Response_OK , 0);
// }

// void Command_ExternalAuth() {
// 	unsigned char i, temp;
// 	unsigned char retries;

// 	if( !(header[4] == 0x44) ) {
// 		Response_SetSW( Response_WrongLength , 0);
// 		return;
// 	}
	
// 	for( i=0; i<7; i++) {
// 	copy_data_block_independent(addr_RNG, addr_k_ECC+i+2, 4);
// 	Memory_WriteByte(KEY_ECC_ADDR_RD + i, temp);
// 	}
// 	ECC_sequential();
	
// 	for( i=0; i<CRYPT_BLOCK_LEN; i++ ) {
// 		Transmission_SendByte( ~header[1] );
// 		encrypted[i] = Transmission_GetByte();
// 	}

// 	for (i=0; i<60; i++){
// 		response[i] = read_data_sequential(addr_xo_ECC+i);
// 	}
		
// 	for(i=0; i<60; i++){
// 		Transmission_SendByte( ~header[1] );
// 		temp = Transmission_GetByte();
// 		write_data_sequential((addr_xi_ECC+i),temp);
// 	}
		
// 	for(i=0; i<30; i++){
// 		temp = read_data_independent(addr_RNG);
// 		write_data_sequential((addr_k_ECC+i),temp);
// 		Memory_WriteByte(KEY_ECC_ADDR_SC + i, temp);
// 	}
		
// 	ECC_sequential();
		
// 	for(i=0; i<60; i++){
// 		Memory_WriteByte(KEY_AUTH + i, response[i]);
// 	}
	
// 	for (i=0; i<60; i++){
// 		response[i] = read_data_sequential(addr_xo_ECC+i);
// 		Memory_WriteByte(ECC_ADDR+i, response[i]);
// 	}
		
// 	switch( State_VerifyAuth() ){
// 		case STATE_OK:
// 			Response_SetSW( Response_Auth_Success , 0);
// 			break;
// 		case STATE_BLOCKED:
// 			Response_SetSW( Response_CmdNotAllowed_ConditionNotSatisfied , 0);
// 			break;
// 		case STATE_WRONG:
// 			retries = Memory_ReadByte(EXT_AUTH_RETRIES_ADDR);
// 			Response_SetSW( Response_Warning_Counter | (retries & 0x0f) , 0);
// 	}

// }

// void Command_GetResponse(){
// 	unsigned char i;

// 	if( resplen==0 ) {
// 		Response_SetSW( Response_CmdNotAllowed_ConditionNotSatisfied , 0);
// 		return;
// 	}
	
// 	if( (header[4]>resplen) || (!header[4]) ) {
// 	Response_SetSW( Response_WrongLength , 0);
// 	return;
// 	}
// 	resplen=header[4];

// 	Transmission_SendByte( header[1] );

// 	for( i=0; i<resplen; i++ ){
// 		Transmission_SendByte(response[i]);
// 	}

// 	Response_SetSW( Response_OK , 0);
// }

void Command_Interpreter() {
	if ( (header[0]&0xFC)==0x80 ) {
		switch( header[1]&0xFE ) {
			case DEBUG_WRITE:
				Command_Write();
				break;
			case DEBUG_READ:
				Command_Read();
				break;
			case DEBUG_GETCURRENT:
				Command_GetCurrent();
				break;
			case DEBUG_GETSECURITY:
				Command_GetSecurity();
				break;
			case DEBUG_FORMAT:
				Command_Format();
				break;
			case DEBUG_ENCRYPT:
				Command_Encrypt();
				break;
			case DEBUG_GETCHALLENGE:
				Command_GetCurrentChallenge();
				break;
			case ISO_SELECT:
				Command_Select();
				break;
			case ISO_READ_BINARY:
				Command_ReadBinary();
				break;
			case ISO_UPDATE_BINARY:
				Command_UpdateBinary();
				break;
			case ISO_ERASEBINARY:
				Command_EraseBinary();
				break;
			case ISO_CREATE_FILE:
				Command_CreateFile();
				break;
			case ISO_DELETE_FILE:
				Command_DeleteFile();
				break;
			case ISO_VERIFY:
				Command_Verify();
				break;
			case ISO_GET_CHALLENGE:
				Command_GetChallenge();
				break;
			case ISO_EXT_AUTH:
				Command_ExternalAuth();
				break;
			case ISO_GET_RESPONSE:
				Command_GetResponse();
				break;
			case Debug_SHM:
				Command_ReadSHM();
				break;
			case ISO_READRECORD:
				Command_ReadRecord();
				break;
			case ISO_UPDATE_RECORD:
				Command_UpdateRecord();
				break;
			case ISO_WRITERECORD:
				Command_WriteRecord();
				break;
			case ISO_WRITEBINARY:
				Command_WriteBinary();
				break;
			default:
				Response_SetSW( Response_INSNotSupported, 0 );
				break;
		}
	} else {
		Response_SetSW( Response_CLANotSupported, 0);
	}
}

