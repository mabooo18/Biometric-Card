
#line 1 "command.c" /0
  
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
 
 
#line 1 "command.c" /0
 
  
#line 1 "C:\KEIL\C51\INC\STRING.H" /0






 
 
 
 
 
 
 
 typedef unsigned int size_t;
 
 
 
 
 
 
 #pragma SAVE
 #pragma REGPARMS
 extern char *strcat (char *s1, char *s2);
 extern char *strncat (char *s1, char *s2, int n);
 
 extern char strcmp (char *s1, char *s2);
 extern char strncmp (char *s1, char *s2, int n);
 
 extern char *strcpy (char *s1, char *s2);
 extern char *strncpy (char *s1, char *s2, int n);
 
 extern int strlen (char *);
 
 extern char *strchr (const char *s, char c);
 extern int strpos (const char *s, char c);
 extern char *strrchr (const char *s, char c);
 extern int strrpos (const char *s, char c);
 
 extern int strspn (char *s, char *set);
 extern int strcspn (char *s, char *set);
 extern char *strpbrk (char *s, char *set);
 extern char *strrpbrk (char *s, char *set);
 extern char *strstr  (char *s, char *sub);
 extern char *strtok  (char *str, const char *set);
 
 extern char memcmp (void *s1, void *s2, int n);
 extern void *memcpy (void *s1, void *s2, int n);
 extern void *memchr (void *s, char val, int n);
 extern void *memccpy (void *s1, void *s2, char val, int n);
 extern void *memmove (void *s1, void *s2, int n);
 extern void *memset  (void *s, char val, int n);
 #pragma RESTORE
 
 
#line 2 "command.c" /0
 
  
#line 1 "config.h" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#line 3 "command.c" /0
 
  
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
 
#line 4 "command.c" /0
 
  
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
 
#line 5 "command.c" /0
 
  
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
 
 
 
#line 6 "command.c" /0
 
  
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
 
#line 7 "command.c" /0
 
  
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
 
#line 8 "command.c" /0
 
  
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
 
 
#line 9 "command.c" /0
 
  
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
 
#line 10 "command.c" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 unsigned char response[90];
 unsigned char resplen;
 unsigned char buffer[8];
 unsigned char pin[4];
 unsigned char encrypted[8];
 
 void Command_Write() 
 {
 unsigned int i;  
 unsigned int length;  
 unsigned char data_to_write; 
 unsigned int address_EEPROM; 
 
 address_EEPROM = (header[2]<<8)+header[3];  
 
 length = (unsigned int) header[4]; 
 
 for( i=0; i<length; i++)  
 {
 
 Transmission_SendByte( ~header[1] );
 
 
 data_to_write = Transmission_GetByte();
 
 Memory_WriteByte( address_EEPROM+i, data_to_write );
 }
 
 
 Response_SetSW( Response_OK, 0);
 }
 
 
 void Command_Read()  
 {
 
 unsigned char i;  
 unsigned int length; 
 unsigned int address_EEPROM; 
 unsigned char data_to_read; 
 
 length = (unsigned int) header[4];  
 address_EEPROM = (header[2]<<8)+header[3]; 
 
 
 Transmission_SendByte( header[1] );
 
 for( i=0; i<length; i++ )  
 {
 data_to_read = Memory_ReadByte( address_EEPROM+i);  
 Transmission_SendByte( data_to_read ); 
 }
 
 
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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 void Command_GetCurrent() 
 {
 unsigned int current, body, length, record_num;
 unsigned char ac, structure, tag, record_current_addr, record_next_addr;
 
 record_num = State_GetCurrentRecord();
 current = State_GetCurrent();
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
  Memory_ReadBlock(272 + (current * 2) + 0, 1, (unsigned char *)&tag);
  Memory_ReadBlock (272 + (body * 2) + 0, 1, (unsigned char *)&structure);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&length);
 ac=FS_GetAC();
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + record_num-1, 1, (unsigned char *)&record_current_addr);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + record_num, 1, (unsigned char *)&record_next_addr);
 
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
 
 void Command_GetSecurity()  
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
 if (!(FSFormat() == 0)) {
 Response_SetSW( Response_FatalError , 0);
 return;
 }
 
 Response_SetSW( Response_OK , 0);
 }
 
 
 void Command_Encrypt() {
 unsigned int i;
 unsigned char temp;
 if (header[4] == 8){
 for(i=0; i<header[4]; i++) {
 Transmission_SendByte( ~header[1] );
 
 temp = Transmission_GetByte();
 write_data_independent((0x62+i),temp);
 temp = Memory_ReadByte((0x0002+24+4 + 1 + 8) + i);
 write_data_independent((0x5A+i),temp);
 }
 BC3_encrypt_k_sequential();
 resplen = 8;
 for (i=0; i<resplen; i++) {
 response[i] = read_data_sequential(0xAA+i);
 Memory_WriteByte(0x01AA+i, response[i]);
 }
 for(i=0; i<header[4]; i++) {		
 write_data_independent((0x62+i),response[i]);
 temp = Memory_ReadByte((0x0002+24+4 + 1 + 8) + i);
 write_data_independent((0x5A+i),temp);
 }
 BC3_decrypt_k_sequential();
 resplen = 8;
 for (i=0; i<resplen; i++){
 response[i+8] = read_data_sequential(0xAA+i);
 }
 }
 
 if (header[4] == 90) {
 for(i=0; i<60; i++){
 Transmission_SendByte( ~header[1] );
 temp = Transmission_GetByte();
 write_data_independent((0x00+i),temp);
 }
 
 for(i=0; i<30; i++) {
 Transmission_SendByte( ~header[1] );
 temp = Transmission_GetByte();
 write_data_independent((0x3C+i),temp);
 Memory_WriteByte((((((0x0002+24+4 + 1 + 8) + 32) + 16)+1)+60) + i, temp);
 }
 ECC_sequential();
 for (i=0; i<60; i++){
 response[i] = read_data_sequential(0xB2+i);
 Memory_WriteByte(0x01B2+i, response[i]);
 }
 }
 
 if (header[4] == 64) {
 for(i=0; i<64; i++){
 Transmission_SendByte( ~header[1] );
 temp = Transmission_GetByte();
 write_data_independent((0x6A+i),temp);
 }
 HASH_sequential();
 for(i=0; i<32; i++){
 temp = read_data_sequential(0x8A+i);
 Memory_WriteByte(0x016A+i, temp);			
 }
 }
 
 Response_SetSW(Response_OK, 0);
 }
 
 
 void Command_GetCurrentChallenge() {
 unsigned char i, buf[8];
 if( !(header[4] == 8 ) ){
 Response_SetSW( Response_WrongLength , 0);
 return;
 }
 
 
 Transmission_SendByte( header[1] );
 State_GetCurrentChallenge();
 
 for( i=0; i<8; i++ ){
 Transmission_SendByte( buf[i] );
 }
 Response_SetSW( Response_OK , 0);
 }
 
 
 void Command_CreateFile()  
 {
 unsigned char tag;
 unsigned int file_size, fid;
 unsigned char ac, record_le;
 unsigned char result;
 struct DF_st df;
 struct EF_st ef;
 unsigned char filetype, rfu1, rfu2;  
 
 Transmission_SendByte( ~header[1] );
 rfu1 = (unsigned int)(Transmission_GetByte());
 Transmission_SendByte( ~header[1] );
 rfu2 = (unsigned int) (Transmission_GetByte());
 
 
 Transmission_SendByte( ~header[1] );
 file_size = (unsigned int)(Transmission_GetByte()) <<8;
 Transmission_SendByte( ~header[1] );
 file_size |= (unsigned int)(Transmission_GetByte());
 
 
 Transmission_SendByte( ~header[1] );
 fid = (unsigned int) (Transmission_GetByte()) << 8;
 Transmission_SendByte( ~header[1] );
 fid |= (unsigned int) (Transmission_GetByte());
 
 
 Transmission_SendByte( ~header[1] );
 filetype = (unsigned int) (Transmission_GetByte());
 
 
 Transmission_SendByte( ~header[1] );
 ac= (unsigned int) (Transmission_GetByte());
 
 
 if( !((State_GetCurrentSecurity())>=0x01)) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 
 if (filetype == 0x38) {
 tag = 0x4F;
 } else
 if ((filetype == 0x01)||(filetype == 0x02)||(filetype == 0x04)||(filetype == 0x06)) {
 tag = 0x5F;
 } else {
 tag = 0;
 }
 
 switch( tag ) {
 case 0x4F:
 df.FID = fid;
 result = FSCreateFile(tag,&df);
 break;
 case 0x5F:
 ef.FID = fid;
 ef.type = 0;
 ef.AC = ac;  
 ef.file_size = file_size;
 switch(filetype){
 case 0x01: { 
 ef.structure = 0x01;
 break;
 }
 case 0x02: {
 ef.structure = 0x02;
 
 Transmission_SendByte( ~header[1] );
 record_le = (unsigned int) (Transmission_GetByte());
 ef.record_le = record_le;
 break;
 }
 case 0x04: 
 ef.structure = 0x04;
 break;
 case 0x06:
 ef.structure = 0x06;
 break;
 default: 
 ef.structure = 0x01;
 }
 result = FSCreateFile(tag,&ef);
 
 break;
 default:
 result = 30;
 }
 
 switch ( result ) {
 case 0:
 Response_SetSW( Response_OK , 0);
 break;
 case 33:
 Response_SetSW( Response_WrongP1P2_FileExist , 0);
 break;
 case 31:
 Response_SetSW( Response_WrongP1P2_NotEnoughMem , 0);
 break;
 case 35:
 Response_SetSW( Response_CmdNotAllowed_Incompatible_FS , 0);
 break;
 case 30:
 Response_SetSW( Response_FatalError , 0);
 break;
 default:
 Response_SetSW( Response_Normal , 0);
 break;
 }
 }
 
 void Command_Select()  
 {
 unsigned int current,body, length;
 unsigned int fid;
 unsigned int record_num;
 unsigned char structure;
 
 
 if( !((State_GetCurrentSecurity())>=0x01)) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 
 if( header[2] == 0x00 ) {
 
 if(header[4] == 0) {
 FSSelectMF();
 Response_SetSW(Response_OK, 0);
 } else {
 Transmission_SendByte( ~header[1] );
 fid = (unsigned int)(Transmission_GetByte()) << 8;
 
 Transmission_SendByte( ~header[1] );
 fid |= Transmission_GetByte();
 
 switch( FS_SelectFID(fid) ) {
 case 0: {
 Response_SetSW(Response_OK, 0);
 break;
 }
 case 32: 
 Response_SetSW( Response_WrongP1P2_FileNotFound, 0);
 return;
 break; 
 }
 }
 } else {
 Response_SetSW( Response_WrongP1P2_IncorrectP1P2, 0);
 return;
 }
 
 
 current = State_GetCurrent();
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&length);
  Memory_ReadBlock (272 + (body * 2) + 0, 1, (unsigned char *)&structure);
 
 if((structure==0x02) || (structure==0x04)) {
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
 case 0:
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
 
 
 security = State_GetCurrentSecurity();
 if( !( security >= 0x01 )) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return 2;
 }
 
 if( header[2]&0x80 == 0x80 ) {
 fid=header[2]&0x1F;  
 switch( FS_SelectFID(fid) ){
 case 0:
 break;
 case 32:
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
  Memory_ReadBlock(272 + (current * 2) + 0, 1, (unsigned char *)&tag);
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&tempLength);
 *length = tempLength;
 
 
 if(tag == 0x4F) {
 Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
 return 2;
 }
 
 
 if (*offset>tempLength) {
 Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
 return 2;
 }
 
 
  Memory_ReadBlock (272 + (body * 2) + 0, 1, (unsigned char *)&structure);
 if(!(structure==0x01)) {
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
 
 
 ac=FS_GetAC();
 if(!( ac&0x01 == 0x01 )) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 le = header[4];
 
 Transmission_SendByte( header[1] );
 Transmission_SendByte( length );
 Transmission_SendByte( offset );
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 Response_SetSW( Response_OK, 0 );
 }
 
 void Command_UpdateBinary(){
 unsigned int offset, length, le;
 unsigned char data_binary;
 unsigned char i, ac;
 
 if(Initial_Binary_Check(&length, &offset) != 0){
 return;
 }
 
 
 ac=FS_GetAC();
 if(!( ac&0x01 == 0x01 )){
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 le = (unsigned int) header[4];
 
 
 if((le+offset)>length) {
 for( i=0; i<(length-offset); i++) {
 Transmission_SendByte( ~header[1] );
 
 data_binary = Transmission_GetByte();
 
 FSAccessBinary(1,offset+i,1,&data_binary);
 }	
 Response_SetSW(Response_Warning_EndOfFile, 0);
 return;
 } else {
 
 for( i=0; i<le; i++) {
 Transmission_SendByte( ~header[1] );
 
 data_binary = Transmission_GetByte();
 
 FSAccessBinary(1,offset+i,1,&data_binary);
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
 
 
 ac=FS_GetAC();
 if(!( ac&0x01 == 0x01 )){
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 le = (unsigned int) header[4];
 
 
 if((le+offset)>length){
 for( i=0; i<(length-offset); i++) {
 FSAccessBinary(1,offset+i,1,0xFF);
 }	
 Response_SetSW(Response_Warning_EndOfFile, 0);
 return;
 } else {
 
 for( i=0; i<le; i++) {
 FSAccessBinary(1,offset+i,1,0xFF);
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
 
 
 ac=FS_GetAC();
 if(!( ac&0x01 == 0x01 )){
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 le = (unsigned int) header[4];
 
 
 if((le+offset)>length) {
 for( i=0; i<(length-offset); i++) {
 Transmission_SendByte( ~header[1] );
 
 data_write = Transmission_GetByte();
 
 FSAccessBinary(0,offset+i,1,&data_read);
 
 data_binary = data_write & data_read;
 
 FSAccessBinary(1,offset+i,1,&data_binary);
 }	
 Response_SetSW(Response_Warning_EndOfFile, 0);
 return;
 } else {
 
 for( i=0; i<le; i++) {
 Transmission_SendByte( ~header[1] );
 
 data_write = Transmission_GetByte();
 
 FSAccessBinary(0,offset+i,1,&data_read);
 
 data_binary = data_write & data_read;
 
 FSAccessBinary(1,offset+i,1,&data_binary);
 }	
 }
 
 Response_SetSW( Response_OK , 0);
 }
 
 
 void Read_One_Record(unsigned char structure, unsigned int body, unsigned int size, unsigned int record_num){
 unsigned char record_le;
 unsigned char databyte;
 unsigned char record_current_addr, record_next_addr;
 unsigned int offset, i;
 
 if(structure==0x02){
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2, 1, (unsigned char *)&record_le);
 offset = record_le*(record_num-1)+1;
 for(i = 0; i<record_le;i++) {
 FSAccessBinary(0,offset+i,1,&databyte);
 Transmission_SendByte(databyte);
 }
 } else {
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + record_num-1, 1, (unsigned char *)&record_current_addr);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + record_num, 1, (unsigned char *)&record_next_addr);
 record_le=record_next_addr-record_current_addr;
 offset=record_current_addr+size+1;
 
 for(i = 0; i<record_le;i++) {
 FSAccessBinary(0,offset+i,1,&databyte);
 Transmission_SendByte(databyte);
 }
 }
 }
 
 unsigned char Update_One_Record(unsigned char structure, unsigned int body, unsigned int size, unsigned int record_num, unsigned char length){
 unsigned char record_le;
 unsigned char databyte, i;
 unsigned char record_current_addr, record_next_addr;
 unsigned int offset;
 
 if(structure==0x02){
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2, 1, (unsigned char *)&record_le);
 offset = record_le*(record_num-1)+1;
 if( length == record_le ){
 for(i = 0; i<record_le;i++) {
 Transmission_SendByte( ~header[1] );
 databyte = Transmission_GetByte();
 FSAccessBinary(1,offset+i,1,&databyte);
 }
 } else {
 return record_le;
 }
 } else {
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + record_num-1, 1, (unsigned char *)&record_current_addr);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + record_num, 1, (unsigned char *)&record_next_addr);
 record_le=record_next_addr-record_current_addr;
 offset=record_current_addr+size+1;
 if( length == record_le ){		
 for(i = 0; i<record_le;i++) {
 Transmission_SendByte( ~header[1] );
 databyte = Transmission_GetByte();
 FSAccessBinary(1,offset+i,1,&databyte);
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
 
 if(structure==0x02){
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2, 1, (unsigned char *)&record_le);
 offset = record_le*(record_num-1)+1;
 if( length == record_le ){
 for(i = 0; i<record_le;i++) {
 Transmission_SendByte( ~header[1] );
 data_write = Transmission_GetByte();
 
 FSAccessBinary(0,offset+i,1,&data_read);
 
 databyte = data_write & data_read;
 FSAccessBinary(1,offset+i,1,&databyte);
 }
 } else {
 return record_le;
 }
 } else {
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + record_num-1, 1, (unsigned char *)&record_current_addr);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + record_num, 1, (unsigned char *)&record_next_addr);
 record_le=record_next_addr-record_current_addr;
 offset=record_current_addr+size+1;
 if( length == record_le ){		
 for(i = 0; i<record_le;i++) {
 Transmission_SendByte( ~header[1] );
 data_write = Transmission_GetByte();
 
 FSAccessBinary(0,offset+i,1,&data_read);
 
 databyte = data_write & data_read;
 FSAccessBinary(1,offset+i,1,&databyte);
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
 
 
 security = State_GetCurrentSecurity();
 if( !( security >= 0x01 )) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 
 if ((header[3]&0xF8) == 0x00){
 
 current = State_GetCurrent();
 if ( current == 0x00 ) {
 Response_SetSW(Response_CmdNotAllowed_NoCurrentEF, 0);
 return;
 }
 } else {
 Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
 return;
 }
 
  Memory_ReadBlock(272 + (current * 2) + 0, 1, (unsigned char *)&tag);
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&size);
 
 
 if(tag == 0x4F) {
 Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
 return;
 }
 
 
  Memory_ReadBlock (272 + (body * 2) + 0, 1, (unsigned char *)&structure);
 if( !( (structure==0x02) || (structure==0x04) ) ) {
 Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
 return;
 }
 
 
 ac=FS_GetAC();
 if(!( ac&0x01 == 0x01 )) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 
 if(header[2]==0x00){
 record_num = State_GetCurrentRecord();
 } else{
 record_num = header[2];
 }
 
 
 if(record_num>size){
 Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
 return;
 }
 
 
 
 Transmission_SendByte( header[1] );
 if((header[3]&0x04)==0x04){ 
 
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
 
 
 security = State_GetCurrentSecurity();
 if( !( security >= 0x01 )) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 
 if ( (header[3]&0xF8) == 0x00){
 
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
  Memory_ReadBlock(272 + (current * 2) + 0, 1, (unsigned char *)&tag);
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&size);
 
 
 if(tag == 0x4F) {
 Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
 return;
 }
 
 
  Memory_ReadBlock (272 + (body * 2) + 0, 1, (unsigned char *)&structure);
 if( !( (structure==0x02) || (structure==0x04) ) ) {
 Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
 return;
 }
 
 
 ac=FS_GetAC();
 if(!( ac&0x01 == 0x01 )) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 
 if(header[2]==0x00){
 record_num = State_GetCurrentRecord();
 } else {
 record_num = header[2];
 }
 
 
 if(record_num>size){
 Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
 return;
 }
 
 
 if( (header[3]&0x04) == 0x04 ){ 
 status = Update_One_Record(structure,body,size,record_num,header[4]);
 } else {
 
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
 
 
 security = State_GetCurrentSecurity();
 if( !( security >= 0x01 )) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 
 if ( (header[3]&0xF8) == 0x00){
 
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
  Memory_ReadBlock(272 + (current * 2) + 0, 1, (unsigned char *)&tag);
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&size);
 
 
 if(tag == 0x4F) {
 Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
 return;
 }
 
 
  Memory_ReadBlock (272 + (body * 2) + 0, 1, (unsigned char *)&structure);
 if( !( (structure==0x02) || (structure==0x04) ) ) {
 Response_SetSW(Response_CmdNotAllowed_Incompatible_FS, 0);
 return;
 }
 
 
 ac=FS_GetAC();
 if(!( ac&0x01 == 0x01 )) {
 Response_SetSW( Response_CmdNotAllowed_SecurityStatus , 0);
 return;
 }
 
 
 if(header[2]==0x00){
 record_num = State_GetCurrentRecord();
 } else {
 record_num = header[2];
 }
 
 
 if(record_num>size){
 Response_SetSW(Response_WrongP1P2_IncorrectP1P2, 0);
 return;
 }
 
 
 if( (header[3]&0x04) == 0x04 ){ 
 status = Update_One_Record(structure,body,size,record_num,header[4]);
 } else {
 
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
 
 
 
 void Command_Verify() {
 unsigned char i;
 unsigned char retries;
 
 if( header[4] != 4 ) {
 Response_SetSW( Response_WrongLength , 0);
 return;
 }
 
 for( i=0; i<4; i++ ) {
 Transmission_SendByte( ~header[1] );
 pin[i] = Transmission_GetByte();
 }
 Transmission_SendByte( header[1] );
 
 switch( State_Verify() ) {
 case 0:
 Response_SetSW( Response_OK , 0);
 break;
 case 3:
 Response_SetSW( Response_CmdNotAllowed_AuthBlocked , 0);
 break;
 case 2:
 retries = Memory_ReadByte(0x0002+24+4);
 Response_SetSW( Response_Warning_Counter  , retries & 0x0F);
 }
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 void Command_Interpreter() {
 if ( (header[0]&0xFC)==0x80 ) {
 switch( header[1]&0xFE ) {
 case 0x02:
 Command_Write();
 break;
 case 0x04:
 Command_Read();
 break;
 case 0x22:
 Command_GetCurrent();
 break;
 case 0x24:
 Command_GetSecurity();
 break;
 case 0x0a:
 Command_Format();
 break;
 case 0x26:
 Command_Encrypt();
 break;
 case 0x28:
 Command_GetCurrentChallenge();
 break;
 case 0xA4:
 Command_Select();
 break;
 case 0xB0:
 Command_ReadBinary();
 break;
 case 0xD6:
 Command_UpdateBinary();
 break;
 case 0x0E:
 Command_EraseBinary();
 break;
 case 0xE0:
 Command_CreateFile();
 break;
 case 0xE4:
 Command_DeleteFile();
 break;
 case 0x20:
 Command_Verify();
 break;
 case 0x84:
 Command_GetChallenge();
 break;
 case 0x82:
 Command_ExternalAuth();
 break;
 case 0xC0:
 Command_GetResponse();
 break;
 case 0x06:
 Command_ReadSHM();
 break;
 case 0xB2:
 Command_ReadRecord();
 break;
 case 0xDC:
 Command_UpdateRecord();
 break;
 case 0xD2:
 Command_WriteRecord();
 break;
 case 0xD0:
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
 
