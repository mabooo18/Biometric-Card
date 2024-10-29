#ifndef STATE_H
#define STATE_H

//! Length of key in octets.
#define CRYPT_KEY_LEN	16
//! Length of cipher block in octets.
#define CRYPT_BLOCK_LEN	8
//! Single block encryption function.
#define crypt_enc(v,k) BC3_enc((unsigned long int *)(v),(unsigned long int *)(k))
//! Single block decryption function.
#define crypt_dec(v,k) BC3_dec((unsigned long int *)(v),(unsigned long int *)(k))

#define STATE_OK                0
#define STATE_ERROR             1
#define STATE_WRONG             2
#define STATE_BLOCKED           3

#define KEY_SIZE               4

/********************************/
/*        Data Structure        */
/********************************/

struct state_struct
{
  unsigned int        current;     ///< pointer to current DF header
  unsigned int        currentKey;    ///< pointer to current Key EF header
  unsigned int        currentRecord;  ///< Record number of currently selected EF
  unsigned char         securityState;  ///< security state currently active
  unsigned char         challenge[CRYPT_BLOCK_LEN];
};

/**************************/
/*        Variable        */
/**************************/


/**************************/
/*        Function        */
/**************************/


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

#endif
