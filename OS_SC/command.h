#ifndef COMMAND_H

#define COMMAND_H

/* Command for CRYPTOPROCESSOR */
//#define DEBUG_ECDH        0x65

/* Command for Debug */
#define DEBUG_WRITE        0x02
#define DEBUG_READ         0x04
#define DEBUG_GETCURRENT   0x22
#define DEBUG_GETSECURITY  0x24
#define DEBUG_GETCHALLENGE 0x28
#define DEBUG_ENCRYPT      0x26
#define DEBUG_FORMAT       0x0a
#define Debug_SHM          0x06

/* File Operation */
#define	ISO_SELECT              0xA4      ///< ISO 7816-4 SELECT Instruction code
#define	ISO_READ_BINARY         0xB0      ///< ISO 7816-4 READ BINARY Instruction code
#define	ISO_UPDATE_BINARY       0xD6      ///< ISO 7816-4 UPDATE BINARY Instruction code
#define ISO_ERASEBINARY	   		0x0E
#define ISO_WRITEBINARY			0xD0
#define	ISO_READRECORD			0xB2      ///< ISO 7816-4 READ RECORD Instruction code
#define	ISO_UPDATE_RECORD		0xDC      ///< ISO 7816-4 UPDATE RECORD Instruction code
#define	ISO_APPEND_RECORD		0xE2      ///< ISO 7816-4 APPEND RECORD Instruction code
#define ISO_WRITERECORD			0xD2

/* File Management */
#define	ISO_CREATE_FILE         0xE0	///< ISO 7816-4 CREATE FILE Instruction code
#define	ISO_DELETE_FILE         0xE4	///< ISO 7816-4 DELETE FILE Instruction code

/* Security */
#define	ISO_VERIFY              0x20	///< ISO 7816-4 VERIFY Instruction code
#define	ISO_EXT_AUTH            0x82	///< ISO 7816-4 EXTERNAL_AUTH Instruction code
#define	ISO_INT_AUTH            0x88	///< ISO 7816-4 INTERNAL_AUTH Instruction code
#define ISO_GET_CHALLENGE		0x84	//!< INS byte: Get Challenge

/* Program Code Management */
#define	ISO_LOAD                0xDC      ///< ISO 7816-4 LOAD Instruction code
#define	ISO_INSTALL             0xDC      ///< ISO 7816-4 INSTALL Instruction code
#define	ISO_DELETE              0xDC      ///< ISO 7816-4 DELETE Instruction code

/* Data Transmission */
#define	ISO_GET_RESPONSE        0xC0  	///< ISO 7816-4 GET RESPONSE Instruction code

void Command_Write();
void Command_Read();
void Command_Format();
void Command_Encrypt();
void Command_GetCurrentChallenge();
void Command_GetChallenge();
void Command_ReadSHM();
void Command_Interpreter();

unsigned int fibo(unsigned int i);
#endif