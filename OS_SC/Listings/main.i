
#line 1 "main.c" /0
  
#line 1 "C:\KEIL\C51\INC\REG51.H" /0






 
 
 
 
 
 
 sfr P0   = 0x80;
 sfr P1   = 0x90;
 sfr P2   = 0xA0;
 sfr P3   = 0xB0;
 sfr PSW  = 0xD0;
 sfr ACC  = 0xE0;
 sfr B    = 0xF0;
 sfr SP   = 0x81;
 sfr DPL  = 0x82;
 sfr DPH  = 0x83;
 sfr PCON = 0x87;
 sfr TCON = 0x88;
 sfr TMOD = 0x89;
 sfr TL0  = 0x8A;
 sfr TL1  = 0x8B;
 sfr TH0  = 0x8C;
 sfr TH1  = 0x8D;
 sfr IE   = 0xA8;
 sfr IP   = 0xB8;
 sfr SCON = 0x98;
 sfr SBUF = 0x99;
 
 
 
 
 sbit CY   = 0xD7;
 sbit AC   = 0xD6;
 sbit F0   = 0xD5;
 sbit RS1  = 0xD4;
 sbit RS0  = 0xD3;
 sbit OV   = 0xD2;
 sbit P    = 0xD0;
 
 
 sbit TF1  = 0x8F;
 sbit TR1  = 0x8E;
 sbit TF0  = 0x8D;
 sbit TR0  = 0x8C;
 sbit IE1  = 0x8B;
 sbit IT1  = 0x8A;
 sbit IE0  = 0x89;
 sbit IT0  = 0x88;
 
 
 sbit EA   = 0xAF;
 sbit ES   = 0xAC;
 sbit ET1  = 0xAB;
 sbit EX1  = 0xAA;
 sbit ET0  = 0xA9;
 sbit EX0  = 0xA8;
 
 
 sbit PS   = 0xBC;
 sbit PT1  = 0xBB;
 sbit PX1  = 0xBA;
 sbit PT0  = 0xB9;
 sbit PX0  = 0xB8;
 
 
 sbit RD   = 0xB7;
 sbit WR   = 0xB6;
 sbit T1   = 0xB5;
 sbit T0   = 0xB4;
 sbit INT1 = 0xB3;
 sbit INT0 = 0xB2;
 sbit TXD  = 0xB1;
 sbit RXD  = 0xB0;
 
 
 sbit SM0  = 0x9F;
 sbit SM1  = 0x9E;
 sbit SM2  = 0x9D;
 sbit REN  = 0x9C;
 sbit TB8  = 0x9B;
 sbit RB8  = 0x9A;
 sbit TI   = 0x99;
 sbit RI   = 0x98;
 
 
#line 1 "main.c" /0
 
  
#line 1 "hal.h" /0
 
 
 
 void init_HW(void);
 
#line 2 "main.c" /0
 
  
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
 
 
 
#line 3 "main.c" /0
 
  
#line 1 "response.h" /0
 
 
 
 
 typedef enum
 {
 Response_OK,
 Response_Normal,
 Response_Auth_Success,
 Response_Warning_Unchanged,
 Response_Warning_DataCorrupt,
 Response_Warning_EndOfFile,
 Response_Warning_FileDeactivated,
 Response_Warning_Changed,
 Response_Warning_FilledUp,
 Response_Warning_Counter,
 Response_Error_Unchanged,
 Response_Error_Changed,
 Response_WrongLength,
 Response_NotSupported,
 Response_NotSupported_LogicalChannel,
 Response_NotSupported_SecureMessaging,
 Response_NotSupported_LastCommandExpected,
 Response_NotSupported_CommandChain,
 Response_CmdNotAllowed,
 Response_CmdNotAllowed_Incompatible_FS,
 Response_CmdNotAllowed_SecurityStatus,
 Response_CmdNotAllowed_AuthBlocked,
 Response_CmdNotAllowed_RefDataNotUsable,
 Response_CmdNotAllowed_ConditionNotSatisfied,
 Response_CmdNotAllowed_NoCurrentEF,
 Response_CmdNotAllowed_ExpectSecureMsg,
 Response_CmdNotAllowed_IncorrectSecureMsg,
 Response_WrongP1P2,
 Response_WrongP1P2_IncorrectData,
 Response_WrongP1P2_FuncNotSupported,
 Response_WrongP1P2_FileNotFound,
 Response_WrongP1P2_RecordNotFound,
 Response_WrongP1P2_NotEnoughMem,
 Response_WrongP1P2_NCInconsistentTLV,
 Response_WrongP1P2_IncorrectP1P2,
 Response_WrongP1P2_NCInconsistentP1P2,
 Response_WrongP1P2_RefDataNotFound,
 Response_WrongP1P2_FileExist,
 Response_WrongP1P2_DFNameExist,
 Response_INSNotSupported,
 Response_CLANotSupported,
 Response_FatalError,
 } rspn_type;
 
 
 void Response_SetSW(unsigned char response, unsigned char extra);
 
#line 4 "main.c" /0
 
  
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
 
#line 5 "main.c" /0
 
  
#line 1 "i2c.h" /0
 
 
 
 
 
 void I2C_delay(void);
 void I2C_start(void);
 void I2C_stop(void);
 bit I2C_write(unsigned char dat);
 unsigned char I2C_read(void);
 
 
#line 6 "main.c" /0
 
  
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
 
#line 7 "main.c" /0
 
  
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
 
#line 8 "main.c" /0
 
  
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
 
 
#line 9 "main.c" /0
 
  
#line 1 "fs.h" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 





 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 



 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 struct EF_st
 {
 unsigned int	FID;		 
 unsigned char	structure;	 
 unsigned char	type;		 
 unsigned char	AC;			 
 unsigned char	*ptr_body;	 
 unsigned int 	file_size;	 
 unsigned char	record_le;	 
 } ;
 
 struct DF_st
 {
 unsigned int	FID;                     
 char			DFname[16];              
 char			asc_flag;                
 int				(* asc)(int);            
 } ;
 
 
 
 
 
 
 
 
 
 unsigned int FS_Init();
 unsigned int FSAlloc(unsigned int size_alloc, unsigned int startBlock, unsigned int endBlock, unsigned int * address);
 int FSGetHeader(unsigned int block_addr, unsigned char offset, unsigned char * dest);
 
 unsigned char FS_CheckAC(unsigned int op);
 
 unsigned char FS_GetAC();
 unsigned int FSFormat();
 
 unsigned int FS_SelectFID(unsigned int fid);
 unsigned int FSSelectMF();
 unsigned int FS_SearchAllFID(unsigned int fid);
 
 unsigned int FSAccessBinary(unsigned int op, unsigned int offset, unsigned int length, unsigned char *databyte);
 unsigned int FSCreateHeader(unsigned char tag, unsigned int fid, unsigned int * addr);
 unsigned int FSCreateBodyEF(struct EF_st * desc, unsigned int * addr);
 unsigned int FSCreateFile(unsigned int tag, void * desc);
 
 unsigned int FSDeleteFile(unsigned int fid);
 unsigned int FSFree(unsigned int address, unsigned int length);
 unsigned int FS_CheckChildSibling_FID(unsigned int fid, unsigned int current);
 
#line 10 "main.c" /0
 
 
 sbit ATR_START = P1^3;
 sbit ATR_DONE = P1^4;
 unsigned char buf[8];
 
 void main(void){
 ATR_START = 1;
 ATR_DONE = 1;
 init_HW();
 
 send_ATR_direct();
 State_Init();
 FS_Init();
 
 ATR_DONE = 0;
 while(1){
 Transmission_GetHeader();
 Command_Interpreter();
 Transmission_SendSW();
 }
 
 }
