#include <string.h>
#include "config.h"
#include "memory.h"
#include "state.h"
#include "krisna.h"
#include "command.h"
#include "transmission.h"

#define EXP_AUTH 0x0230

static struct state_struct     state_mng;              ///< state_manager
unsigned char key[8] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07};
extern unsigned char buffer[8];
extern unsigned char encrypted[CRYPT_BLOCK_LEN];
extern unsigned char pin[PIN_LEN];

int State_Init(){
	state_mng.current = 0;
	state_mng.currentKey = 0;
	state_mng.currentRecord = 1;
	state_mng.securityState = 0;

	return STATE_OK; 
}

int State_SetCurrent(unsigned int newFile) {
	state_mng.current = newFile;
	state_mng.currentRecord = 1;
	return STATE_OK;
}

int State_SetCurrentRecord(unsigned int record_num) {
	state_mng.currentRecord = record_num;
	return STATE_OK;
}

unsigned int State_GetCurrent() {
	return state_mng.current;
}

unsigned int State_GetCurrentRecord() {
	return state_mng.currentRecord;
}

void State_GetCurrentChallenge() {
	memcpy( buffer, state_mng.challenge, CRYPT_BLOCK_LEN );
}

unsigned char State_GetCurrentSecurity() {
	return state_mng.securityState;
}

int State_Verify() {
	unsigned char retries;
	unsigned char i, temp_card, temp_rd, diff=0;
	
	state_mng.securityState &= 0xfe;
	retries = Memory_ReadByte(PIN_RETRIES_ADDR);

	if (retries == 0) {
		return STATE_BLOCKED;
	}

	for( i=0; i<60; i++ ) {
		write_data_independent((addr_dati_HASH+i),(0x00+i));
	}
	for( i=0; i<PIN_LEN; i++ ) {
		write_data_independent((addr_dati_HASH+i+60),pin[i]);
	}
	HASH_sequential();

	for( i=0; i<PIN_HASH_LEN; i++ ) {
		temp_card = Memory_ReadByte(PIN_HASH_ADDR+i);
		temp_rd = read_data_sequential(addr_dato_HASH+i);
		diff |= temp_card^temp_rd;
	}

	if( diff>0 ){
		retries--;
	} else {
		retries=0x03;
	}
	
	Memory_WriteByte(PIN_RETRIES_ADDR, retries);

	if( diff>0 ) {
		state_mng.securityState = 0x00;
		return STATE_WRONG;
	}

	if (retries == 0) {
		return STATE_BLOCKED;
	}
	state_mng.securityState |= 0xFF;

	return STATE_OK;
}

unsigned char State_VerifyAuth()
{
	unsigned char retries,i;
//  unsigned long int key[4];
	unsigned char last_data[8];
	
	retries = Memory_ReadByte(EXT_AUTH_RETRIES_ADDR);

	if (retries > EXT_AUTH_MAX_RETRIES){
		return STATE_BLOCKED;
	}


 // Memory_ReadBlock( (unsigned int) EXT_AUTH_KEY_ADDR, (unsigned int) EXT_AUTH_KEY_LEN, (unsigned char *) key);
	for(i=0;i<CRYPT_BLOCK_LEN;i++){ 
		last_data[i] = Memory_ReadByte(RAND_STATE_ADDR + i);
		write_data_sequential(addr_k_BC3+i, key[i]);
		write_data_sequential(addr_dati_BC3+i, last_data[i]);
	}
//  crypt_enc( state_mng.challenge, key );
		BC3_encrypt_k_sequential();
		
	for(i=0;i<CRYPT_BLOCK_LEN;i++){ 
		last_data[i] = read_data_sequential(addr_dato_BC3+i);
		if (encrypted[i] != last_data[i]){
			retries++;
			Memory_WriteByte(EXT_AUTH_RETRIES_ADDR, retries);
			return STATE_WRONG;
		}
	}

  /* Compare result */
/*  if( memcmp( encrypted, state_mng.challenge, CRYPT_BLOCK_LEN ) ) {
	retries++;
	Memory_WriteByte(EXT_AUTH_RETRIES_ADDR, retries);

	return STATE_WRONG;
  }*/

	if(retries > 0) {
	  retries = 0;
	  Memory_WriteByte(EXT_AUTH_RETRIES_ADDR, retries);
	}

	state_mng.securityState |= 0x02;

	return STATE_OK;
}

/*
void State_GetChallenge( unsigned char * buffer )
{
  unsigned char block[2], key[4];

  Memory_ReadBlock( (unsigned int) SERNUM_ADDR, (unsigned int) SERNUM_LEN, (unsigned char *) block);
 
  Memory_ReadBlock( (unsigned int) RAND_STATE_ADDR, (unsigned int) sizeof(key), (unsigned char *) key);
 
  key[2]=key[1];
  key[3]=key[0]; //RNG

  crypt_enc( block, key );

  Memory_WriteBlock( (unsigned int) RAND_STATE_ADDR, (unsigned int) RAND_STATE_LEN, (unsigned char *) block);

  crypt_enc( block, key );

  memcpy( state_mng.challenge, block, sizeof(block) );

  memcpy( buffer, block, CRYPT_BLOCK_LEN );
}*/


void State_GetChallenge()
{
	unsigned char block[8],i;
	
	// copy_data_block_independent(addr_RNG, addr_dati_BC3, 8);

	// for(i=0;i<CRYPT_BLOCK_LEN;i++){
	// 	write_data_sequential(addr_k_BC3+i, key[i]);
	// }
	
	// BC3_encrypt_k_sequential();
	
	
	for(i=0;i<CRYPT_BLOCK_LEN;i++){ 
		buffer[i] = read_data_independent(addr_RNG);
		state_mng.challenge[i] = buffer[i];
		Memory_WriteByte(RAND_STATE_ADDR + i, buffer[i]);
		write_data_independent(addr_dati_BC3+i, buffer[i]);
		write_data_sequential(addr_k_BC3+i, key[i]);
	}
	
	BC3_encrypt_k_sequential();
	
	for(i=0;i<CRYPT_BLOCK_LEN;i++){ 
		block[i] = read_data_sequential(addr_dato_BC3+i);
		Memory_WriteByte(EXP_AUTH + i, block[i]);
	}
	
}