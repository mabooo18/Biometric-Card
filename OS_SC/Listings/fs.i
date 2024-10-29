
#line 1 "fs.c" /0
  
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
 
#line 1 "fs.c" /0
 
  
#line 1 "config.h" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#line 2 "fs.c" /0
 
  
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
 
#line 3 "fs.c" /0
 
  
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
 
 
#line 4 "fs.c" /0
 
  
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
 
 
 
#line 5 "fs.c" /0
 
 
 unsigned int FS_Init(){
 FSSelectMF();
 return 0;
 }
 
 unsigned int FSSelectMF(){
 State_SetCurrent(0 + (512/2/8)/2);
 return 0;
 }
 
 unsigned char FS_GetAC(){
 unsigned int header, body;
 unsigned char ac;
 
 header = State_GetCurrent();
 
  Memory_ReadBlock(272 + (header * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
 
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1, 1, (unsigned char *)&ac);
 
 return ac;
 }
 
 unsigned char FS_CheckAC(unsigned int op){
 unsigned char ac;
 unsigned char current = State_GetCurrentSecurity();
 
 ac = FS_GetAC();
 
 switch(op){
 case 0:
 {
 if( (ac&0x81)==0x81 )
 return 0;
 else
 return 34;
 break;
 }
 case 1:
 {
 if( (ac&0x82)==0x82 )
 return 0;
 else
 return 34;
 break;
 }
 case 2:
 {
 if( (ac&0x84)==0x84 )
 return 0;
 else
 return 34;
 break;
 }
 default:
 {
 return 34;
 }
 }
 
 
 
 }
 unsigned int FS_CheckChildSibling_FID(unsigned int fid, unsigned int current){
 unsigned int tempFID, child,tempChild, sibling, tempSibling;
 unsigned char tempTag;
 
  Memory_ReadBlock(272 + (current * 2) + 0 + 1, 2, (unsigned char *)&tempFID);
 if(tempFID==fid){
 return current;
 }
 
 
 
  Memory_ReadBlock(272 + (current * 2) + 0, 1, (unsigned char *)&tempTag);
 if(tempTag == 0x4F || tempTag == 0x3F) {
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&child);
 if(child != 0XFF){
 tempChild = FS_CheckChildSibling_FID(fid, child);
 if(tempChild != 0x0FFF){
 return tempChild;
 }
 }
 }
 
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&sibling);
 if(sibling != 0XFF){
 tempSibling = FS_CheckChildSibling_FID(fid, sibling);
 if(tempSibling != 0x0FFF){
 return tempSibling;
 }
 }
 
 return 0x0FFF;
 }
 
 unsigned int FS_SearchAllFID(unsigned int fid){
 unsigned int current, result;
 
 current = 0 + (512/2/8)/2;
 result = FS_CheckChildSibling_FID(fid, current);
 
 return result;
 }
 
 unsigned int FSSearchFID(unsigned int fid){
 unsigned int current, parent, sibling, child;
 unsigned int tempFID;
 unsigned char  tempTag;
 
 current = State_GetCurrent();
 
 
 
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2, 2, (unsigned char *)&parent);
 
  Memory_ReadBlock(272 + (parent * 2) + 0 + 1, 2, (unsigned char *)&tempFID);
 
 if(tempFID == fid){
 return parent;
 }
 
 
 
  Memory_ReadBlock(272 + (parent * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&sibling);
 
 while(sibling != 0XFF) {
  Memory_ReadBlock(272 + (sibling * 2) + 0 + 1, 2, (unsigned char *)&tempFID);
 if(tempFID == fid){
 return sibling;
 }
  Memory_ReadBlock(272 + (sibling * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&sibling);
 }
 
 
 
  Memory_ReadBlock(272 + (current * 2) + 0, 1, (unsigned char *)&tempTag);
 if(tempTag == 0x4F || tempTag == 0x3F) {
 
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&child);
 
 while (child != 0XFF) {
  Memory_ReadBlock(272 + (child * 2) + 0 + 1, 2, (unsigned char *)&tempFID);
 if(tempFID == fid){
 return child;
 }
  Memory_ReadBlock(272 + (child * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&child);
 }
 }
 return 0XFF;
 }
 
 unsigned int FS_SelectFID(unsigned int fid){
 unsigned int file;
 
 file = FSSearchFID(fid);
 if( file == 0XFF )
 return 32;
 
 State_SetCurrent(file);
 return 0;
 }
 
 unsigned int FSAccessBinary(unsigned int op, unsigned  int offset, unsigned int length, unsigned char *databyte){
 unsigned int header, body;
 
 header = State_GetCurrent();
  Memory_ReadBlock(272 + (header * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
 
 if(op == 0) {
 if(length == 0)
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&length);
 
 if(length > 256)
 length = 256;
 
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + offset, length, (unsigned char *)databyte);
 }else
 if(op == 1) {
  Memory_WriteBlock(272 + (body * 2) + 0 + 1 + 1 + 1 + 2 + offset, length, (unsigned char *)databyte);
 }
 return length;
 }
 
 unsigned int FSAlloc(unsigned int size_alloc, unsigned int startBlock, unsigned int endBlock, unsigned int * address){
 unsigned int i, j, k, m, n;
 unsigned int startbyte, startbit, startSearchBit;
 unsigned int stopbyte, stopbit, stopSearchBit;
 unsigned int tempAddress;
 unsigned int free = 0;
 unsigned char temp = 0;
 bit cont = 0;
 
 for(i = (startBlock/8); i < (endBlock/8); i++) {
 
 temp = Memory_ReadByte(272 + 0 + i);
 
 startSearchBit = (i == startBlock/8) ? startBlock%8 : 0;
 stopSearchBit  = (i == (endBlock/8)-1) ? endBlock%8 : 8;
 
 
 for(j = startSearchBit; j < stopSearchBit; j++) {
 
 if((temp & 0x80) == 0X80) {
 
 if(cont == 0) {
 
 cont = 1;
 tempAddress = (i*8)+j;
 startbyte = i;
 startbit = j;
 }
 
 
 free ++;
 
 
 if(free == size_alloc) {
 stopbyte = i;
 stopbit = j;
 
 k = startbyte;
 while(k <= stopbyte) {
 m = 0;
 n = 8;
 if(k == startbyte) m = startbit;
 if(k == stopbyte) n = stopbit;
 
 for(m;m<=n;m++){
 temp = Memory_ReadByte(272 + 0 + k);
 temp = temp & ~((unsigned char)128>>m);
 Memory_WriteByte(272 + 0 + k, temp);
 }
 k++;
 }
 
 
 *address = tempAddress;
 return 0;
 }
 } else {
 
 if(cont == 1) {
 cont = 0;
 free = 0;
 }
 }
 temp = temp << 1;
 }
 }
 return 31;
 }
 
 unsigned int FSFormat() {
 unsigned int i;
 unsigned int headerBlock;
 unsigned int none16 = 0XFF;
 unsigned int fidMF  = 0x3F00;
 unsigned char  tagMF  = 0x3F;
 unsigned  int status;
 
 
 for(i=0; i<(0 + (512/2/8)/2*2); i++){  
 Memory_WriteByte(272 + i, 0xFF);  
 }
 status = FSAlloc((((1 + 2 + 2 + 2 + 2 + 2)%2)==0 ? ((1 + 2 + 2 + 2 + 2 + 2)/2) : ((1 + 2 + 2 + 2 + 2 + 2)/2 + 1)), 0 + (512/2/8)/2, 0 + (512/2/8)/2 + 128/2, &headerBlock);
 
 if(status == 0 && headerBlock == 0 + (512/2/8)/2){
  Memory_WriteBlock(272 + (headerBlock * 2) + 0, 1, (unsigned char *)&tagMF);
  Memory_WriteBlock(272 + (headerBlock * 2) + 0 + 1, 2, (unsigned char *)&fidMF);
  Memory_WriteBlock(272 + (headerBlock * 2) + 0 + 1 + 2, 2, (unsigned char *)&headerBlock);
  Memory_WriteBlock(272 + (headerBlock * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&none16);
  Memory_WriteBlock(272 + (headerBlock * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&none16);
 return 0;
 } else {
 return 30;
 }
 }
 
 unsigned int FSCreateHeader(unsigned char tag, unsigned int fid, unsigned int * addr){
 unsigned int	current, currentChild, currentChildTemp;
 unsigned int	headerBlock;
 unsigned int	none16 = (unsigned int)0XFF;
 unsigned int	status;
 
 current = State_GetCurrent();
 
 
 status = FSAlloc((((1 + 2 + 2 + 2 + 2 + 2)%2)==0 ? ((1 + 2 + 2 + 2 + 2 + 2)/2) : ((1 + 2 + 2 + 2 + 2 + 2)/2 + 1)), 0 + (512/2/8)/2, 0 + (512/2/8)/2 + 128/2, &headerBlock);
 
 if(status == 31){
 return status;
 }
 
 
  Memory_WriteBlock(272 + (headerBlock * 2) + 0, 1, (unsigned char *)&tag);
  Memory_WriteBlock(272 + (headerBlock * 2) + 0 + 1, 2, (unsigned char *)&fid);
  Memory_WriteBlock(272 + (headerBlock * 2) + 0 + 1 + 2, 2, (unsigned char *)&current);
  Memory_WriteBlock(272 + (headerBlock * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&none16);
  Memory_WriteBlock(272 + (headerBlock * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&none16);
 
 
  Memory_ReadBlock(272 + (current * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&currentChild);
 
 if (currentChild == none16) {
  Memory_WriteBlock(272 + (current * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&headerBlock);
 } else {
 while (currentChild != 0XFF){
 currentChildTemp = currentChild;
  Memory_ReadBlock(272 + (currentChild * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&currentChild);
 }
 currentChild = currentChildTemp;
  Memory_WriteBlock(272 + (currentChild * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&headerBlock);
 }
 *addr = headerBlock;
 return 0;
 }
 
 
 unsigned int FSCreateBodyEF(struct EF_st * desc, unsigned int * addr){
 unsigned int i, bodyBlock;
 unsigned int status;
 unsigned char var_length[255];	
 unsigned char sum=0;
 
 
 
 switch(desc->structure){
 case 0x01: { 
 
 status = FSAlloc((((1 + 1 + 1 + 2 + desc->file_size)%2)==0 ? ((1 + 1 + 1 + 2 + desc->file_size)/2) : ((1 + 1 + 1 + 2 + desc->file_size)/2 + 1)), 0 + (512/2/8)/2 + 128/2, 512/2, &bodyBlock);;
 if(status == 31){
 return status;
 }
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0, 1, (unsigned char *)&(desc->structure));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1, 1, (unsigned char *)&(desc->type));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1, 1, (unsigned char *)&(desc->AC));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&(desc->file_size));
 
 *addr = bodyBlock;
 break;
 }
 case 0x02: {
 
 status = FSAlloc((((1 + 1 + 1 + 2 + (desc->file_size)*(desc->record_le)+1)%2)==0 ? ((1 + 1 + 1 + 2 + (desc->file_size)*(desc->record_le)+1)/2) : ((1 + 1 + 1 + 2 + (desc->file_size)*(desc->record_le)+1)/2 + 1)), 0 + (512/2/8)/2 + 128/2, 512/2, &bodyBlock);;
 if(status == 31){
 return status;
 }
 
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0, 1, (unsigned char *)&(desc->structure));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1, 1, (unsigned char *)&(desc->type));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1, 1, (unsigned char *)&(desc->AC));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&(desc->file_size));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1 + 1 + 2, 1, (unsigned char *)&(desc->record_le));
 
 *addr = bodyBlock;
 break;
 }
 case 0x04: {
 for(i=0;i<(desc->file_size);i++){
 
 Transmission_SendByte( ~header[1] );
 var_length[i]=Transmission_GetByte();
 sum=sum+var_length[i];
 }
 
 
 status = FSAlloc((((1 + 1 + 1 + 2 + (desc->file_size)+sum+1)%2)==0 ? ((1 + 1 + 1 + 2 + (desc->file_size)+sum+1)/2) : ((1 + 1 + 1 + 2 + (desc->file_size)+sum+1)/2 + 1)), 0 + (512/2/8)/2 + 128/2, 512/2, &bodyBlock);;
 if(status == 31){
 return status;
 }
 
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0, 1, (unsigned char *)&(desc->structure));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1, 1, (unsigned char *)&(desc->type));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1, 1, (unsigned char *)&(desc->AC));
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&(desc->file_size));
 sum=0;
 for(i=0;i<(desc->file_size);i++){
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1 + 1 + 2 + i, 1, (unsigned char *)&(sum));
 sum=sum+var_length[i];
 }
  Memory_WriteBlock(272 + (bodyBlock * 2) + 0 + 1 + 1 + 1 + 2 + (desc->file_size), 1, (unsigned char *)&(sum));
 *addr = bodyBlock;
 break;
 }
 }
 return 0;
 }
 
 unsigned int FSCreateFile(unsigned int tag, void * desc){
 unsigned int header, body;
 unsigned int current;
 unsigned int fid;
 unsigned char currentTag;
 int status;
 
 if(tag == 0x4F){
 fid = ((struct DF_st *)desc)->FID;
 } else
 if (tag == 0x5F) {
 fid = ((struct EF_st *)desc)->FID;
 }
 
 
 current = State_GetCurrent();
  Memory_ReadBlock(272 + (current * 2) + 0, 1, (unsigned char *)(unsigned char *)&currentTag);
 if(currentTag == 0x5F){
 return 35;
 }
 
 
 
 
 
 
 
 
 
 status = FSCreateHeader((unsigned char)tag, fid, &header);
 if (status != 0){
 return status;
 }
 
 
 if(tag == 0x5F) {
 status = FSCreateBodyEF((struct EF_st *)desc, &body);
 if (status != 0){
 return status;
 }
  Memory_WriteBlock(272 + (header * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
 }
 State_SetCurrent(header);
 return 0;
 }
 
 
 unsigned int FSFree(unsigned int address, unsigned int length){
 unsigned int startbyte, stopbyte;
 unsigned char startbit, stopbit;
 unsigned char startXOR, stopXOR;
 unsigned char temp, tempXOR;
 unsigned int i,j;
 
 startbyte = address/8;
 startbit = address%8;
 stopbyte = (address+length)/8;
 stopbit = (address+length)%8;
 
 for(i = startbyte; i <= stopbyte; i++){
 temp = Memory_ReadByte(272 + 0 + i);
 
 startXOR = (i == startbyte) ? startbit : 0;
 stopXOR = (i == stopbyte) ? stopbit : 8;
 
 tempXOR = 0;
 
 for(j = startXOR; j < stopXOR; j++)
 tempXOR = tempXOR ^ (128 >> j);
 
 temp = temp ^ tempXOR;
 
 Memory_WriteByte(272 + 0 + i, temp);
 }
 return 0;
 }
 
 unsigned int FSDeleteFile(unsigned int fid){
 unsigned int header, parent, sibling, siblingBefore, siblingNext;
 unsigned int body, bodySize;
 unsigned char  tag;
 
 
 header = FSSearchFID(fid);
 
 if(header == 0XFF){
 return 32;
 }
 
 
 
  Memory_ReadBlock(272 + (header * 2) + 0 + 1 + 2, 2, (unsigned char *)&parent);
 
  Memory_ReadBlock(272 + (parent * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&sibling);
 
 if(sibling == header) {
  Memory_ReadBlock(272 + (header * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&sibling);
  Memory_WriteBlock(272 + (parent * 2) + 0 + 1 + 2 + 2, 2, (unsigned char *)&sibling);
 }
 
 else {
 while(sibling != header) {
 siblingBefore = sibling;
  Memory_ReadBlock(272 + (sibling * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&sibling);
 }
  Memory_ReadBlock(272 + (header * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&siblingNext);
  Memory_WriteBlock(272 + (siblingBefore * 2) + 0 + 1 + 2 + 2 + 2, 2, (unsigned char *)&siblingNext);
 }
 
 
  Memory_ReadBlock(272 + (header * 2) + 0, 1, (unsigned char *)&tag);
 
 if(tag == 0x5F){
  Memory_ReadBlock(272 + (header * 2) + 0 + 1 + 2 + 2 + 2 + 2, 2, (unsigned char *)&body);
  Memory_ReadBlock (272 + (body * 2) + 0 + 1 + 1 + 1, 2, (unsigned char *)&bodySize);
 FSFree(body, ((((1 + 1 + 1 + 2)+bodySize)%2)==0 ? (((1 + 1 + 1 + 2)+bodySize)/2) : (((1 + 1 + 1 + 2)+bodySize)/2 + 1)));
 }
 
 
 FSFree(header, (((1 + 2 + 2 + 2 + 2 + 2)%2)==0 ? ((1 + 2 + 2 + 2 + 2 + 2)/2) : ((1 + 2 + 2 + 2 + 2 + 2)/2 + 1)));
 return 0;
 }
