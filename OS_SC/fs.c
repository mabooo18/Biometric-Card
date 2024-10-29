#include "fs.h"
#include "config.h"
#include "memory.h"
#include "state.h"	
#include "transmission.h"

unsigned int FS_Init(){
	FSSelectMF();
	return FS_OK;
}

unsigned int FSSelectMF(){
	State_SetCurrent(FS_FILE_TABLE_OFFSET);
	return 0;
}

unsigned char FS_GetAC(){
	unsigned int header, body;
	unsigned char ac;

	header = State_GetCurrent();

	FS_GET_HEADER_BODY_POINTER(header,&body);

	FS_GET_BODY_AC(body, &ac);
	
	return ac;
}

unsigned char FS_CheckAC(unsigned int op){
	unsigned char ac;
	unsigned char current = State_GetCurrentSecurity();

	ac = FS_GetAC();
	
	switch(op){
		case FS_OP_READ:
		{
			if( (ac&0x81)==0x81 )
				return FS_OK;
			else
				return FS_ERROR_SECURITY_STATUS;
			break;
		}
		case FS_OP_UPDATE:
		{
			if( (ac&0x82)==0x82 )
				return FS_OK;
			else
				return FS_ERROR_SECURITY_STATUS;
			break;
		}
		case FS_OP_WRITE:
		{
			if( (ac&0x84)==0x84 )
				return FS_OK;
			else
				return FS_ERROR_SECURITY_STATUS;
			break;
		}
		default:
		{
			return FS_ERROR_SECURITY_STATUS;
		}
	}
	 

	
}
unsigned int FS_CheckChildSibling_FID(unsigned int fid, unsigned int current){
	unsigned int tempFID, child,tempChild, sibling, tempSibling;
	unsigned char tempTag;

	FS_GET_HEADER_FID(current, &tempFID);
	if(tempFID==fid){
		return current;
	}

	// ===== Check Child =====
	// Check if current tag is DF or MF, because EF don't have child
	FS_GET_HEADER_TAG(current, &tempTag);
	if(tempTag == FS_TAG_DF || tempTag == FS_TAG_MF) {
		FS_GET_HEADER_CHILD(current, &child);
		if(child != FS_NONE){
			tempChild = FS_CheckChildSibling_FID(fid, child);
			if(tempChild != 0x0FFF){
				return tempChild;
			}
		}
	}

	FS_GET_HEADER_SIBLING(current, &sibling);
	if(sibling != FS_NONE){
		tempSibling = FS_CheckChildSibling_FID(fid, sibling);
		if(tempSibling != 0x0FFF){
			return tempSibling;
		}
	}

	return 0x0FFF;
}

unsigned int FS_SearchAllFID(unsigned int fid){
	unsigned int current, result;

	current = FS_FILE_TABLE_OFFSET;
	result = FS_CheckChildSibling_FID(fid, current);

	return result;
}

unsigned int FSSearchFID(unsigned int fid){
	unsigned int current, parent, sibling, child;
	unsigned int tempFID;
	unsigned char  tempTag;

	current = State_GetCurrent();

	// ===== Check Parent =====
	// Get Address of Header Parent
	FS_GET_HEADER_PARENT(current, &parent);
	// Get Parent FID from header parent
	FS_GET_HEADER_FID(parent, &tempFID);
	// Check if FID match or not
	if(tempFID == fid){
		return parent;
  	}

	// ==== Check Sibling ====
	// Get Address of Header Sibling form parent's child
	FS_GET_HEADER_CHILD(parent, &sibling);
	// 
	while(sibling != FS_NONE) {
		FS_GET_HEADER_FID(sibling, &tempFID);
		if(tempFID == fid){
			return sibling;
		}
		FS_GET_HEADER_SIBLING(sibling, &sibling);
	}

	// ===== Check Child =====
	// Check if current tag is DF or MF, because EF don't have child
	FS_GET_HEADER_TAG(current, &tempTag);
	if(tempTag == FS_TAG_DF || tempTag == FS_TAG_MF) {
		// Get Child FID from header child
		FS_GET_HEADER_CHILD(current, &child);

		while (child != FS_NONE) {
			FS_GET_HEADER_FID(child, &tempFID);
			if(tempFID == fid){
				return child;
			}
			FS_GET_HEADER_SIBLING(child, &child);
		}
	}
	return FS_NONE;
}

unsigned int FS_SelectFID(unsigned int fid){
	unsigned int file;
	// Search FID is exist or not
	file = FSSearchFID(fid);
	if( file == FS_NONE )
		return FS_ERROR_NOT_FOUND;
	// If found, set current state to address of found file
	State_SetCurrent(file);
	return FS_OK;
}

unsigned int FSAccessBinary(unsigned int op, unsigned  int offset, unsigned int length, unsigned char *databyte){
	unsigned int header, body;

	header = State_GetCurrent();
	FS_GET_HEADER_BODY_POINTER(header,&body);
	
	if(op == FS_OP_READ) {
		if(length == 0)
			FS_GET_BODY_SIZE(body, &length);

		if(length > 256)
			length = 256;

		FS_GET_BODY_BODY(body, length, databyte);
	}else
	if(op == FS_OP_UPDATE) {
		FS_SET_BODY_BODY(body, length, databyte);
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
		//read allocation table (byte -> 8 block)
		temp = Memory_ReadByte(FS_START + FS_ALLOC_TABLE_OFFSET + i);

		startSearchBit = (i == startBlock/8) ? startBlock%8 : 0;
		stopSearchBit  = (i == (endBlock/8)-1) ? endBlock%8 : 8;

		// bit per bit operation
		for(j = startSearchBit; j < stopSearchBit; j++) {
			//check if MSB = 0
			if((temp & 0x80) == 0X80) {
				//check if this the first 0
				if(cont == 0) {
					//make a mark and save the address
					cont = 1;
					tempAddress = (i*8)+j;
					startbyte = i;
					startbit = j;
				}

				//increment free block
				free ++;

				//if free block is sufficient
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
							temp = Memory_ReadByte(FS_START + FS_ALLOC_TABLE_OFFSET + k);
							temp = temp & ~((unsigned char)128>>m);
							Memory_WriteByte(FS_START + FS_ALLOC_TABLE_OFFSET + k, temp);
						}
						k++;
				  	}

					//return the first address of free block
					*address = tempAddress;
					return FS_OK;
				}
			} else {
				//if the MSB == 1 and continue
				if(cont == 1) {
					cont = 0;
					free = 0;
				}
			}
			temp = temp << 1;
		}
	}
  	return FS_ERROR_INSUFFICIENT_SPACE;
}

unsigned int FSFormat() {
	unsigned int i;
	unsigned int headerBlock;
	unsigned int none16 = FS_NONE;
	unsigned int fidMF  = 0x3F00;
	unsigned char  tagMF  = FS_TAG_MF;
	unsigned  int status;

	//Initialize Block Allocation Table
	for(i=FS_ALLOC_TABLE_OFFSET; i<(FS_FILE_TABLE_OFFSET*FS_BLOCK_SIZE); i++){ //i =0 ; i<(16*2 =32)
		Memory_WriteByte(FS_START + i, 0xFF); //64
	}
	status = FS_ALLOC_HEADER(&headerBlock);

	if(status == FS_OK && headerBlock == FS_FILE_TABLE_OFFSET){
		FS_SET_HEADER_TAG(headerBlock, &tagMF);
		FS_SET_HEADER_FID(headerBlock, &fidMF);
		FS_SET_HEADER_PARENT(headerBlock, &headerBlock);
		FS_SET_HEADER_CHILD(headerBlock, &none16);
		FS_SET_HEADER_SIBLING(headerBlock, &none16);
		return FS_OK;
	} else {
		return FS_ERROR;
	}
}

unsigned int FSCreateHeader(unsigned char tag, unsigned int fid, unsigned int * addr){
	unsigned int	current, currentChild, currentChildTemp;
	unsigned int	headerBlock;
	unsigned int	none16 = (unsigned int)FS_NONE;
	unsigned int	status;

	current = State_GetCurrent();

	// Alloc some space for header
	status = FS_ALLOC_HEADER(&headerBlock);

	if(status == FS_ERROR_INSUFFICIENT_SPACE){
		return status;
	}

	// Update header
	FS_SET_HEADER_TAG(headerBlock, &tag);
	FS_SET_HEADER_FID(headerBlock, &fid);
	FS_SET_HEADER_PARENT(headerBlock, &current);
	FS_SET_HEADER_CHILD(headerBlock, &none16);
	FS_SET_HEADER_SIBLING(headerBlock, &none16);

	// Update parent/sibling DF header
	FS_GET_HEADER_CHILD(current, &currentChild);

	if (currentChild == none16) {
		FS_SET_HEADER_CHILD(current, &headerBlock);
	} else {
		while (currentChild != FS_NONE){
			currentChildTemp = currentChild;
			FS_GET_HEADER_SIBLING(currentChild, &currentChild);
		}
		currentChild = currentChildTemp;
		FS_SET_HEADER_SIBLING(currentChild, &headerBlock);
	}
	*addr = headerBlock;
	return FS_OK;
}

// edited create body EF (only one byte ac is needed)
unsigned int FSCreateBodyEF(struct EF_st * desc, unsigned int * addr){
	unsigned int i, bodyBlock;
	unsigned int status;
	unsigned char var_length[255];	
	unsigned char sum=0;
	// unsigned char *var_length;
	// var_length=(char*)malloc((desc->file_size)*sizeof(char));

	switch(desc->structure){
		case FS_EF_STRUCTURE_TRANSPARENT: { 
			//alloc body
			status = FS_ALLOC_BODY(&bodyBlock, desc->file_size);
			if(status == FS_ERROR_INSUFFICIENT_SPACE){
				return status;
			}
			FS_SET_BODY_STRUCTURE(bodyBlock, &(desc->structure));
			FS_SET_BODY_TYPE(bodyBlock, &(desc->type));
			FS_SET_BODY_AC(bodyBlock, &(desc->AC));
			FS_SET_BODY_SIZE(bodyBlock, &(desc->file_size));

			*addr = bodyBlock;
			break;
		}
		case FS_EF_STRUCTURE_RECORD_FIXED: {
			//alloc body
			status = FS_ALLOC_BODY(&bodyBlock, (desc->file_size)*(desc->record_le)+FS_BODY_RECORD_LENGTH_SIZE);
			if(status == FS_ERROR_INSUFFICIENT_SPACE){
				return status;
			}

			FS_SET_BODY_STRUCTURE(bodyBlock, &(desc->structure));
			FS_SET_BODY_TYPE(bodyBlock, &(desc->type));
			FS_SET_BODY_AC(bodyBlock, &(desc->AC));
			FS_SET_BODY_SIZE(bodyBlock, &(desc->file_size));
			FS_SET_RECORD_FIXED_LENGTH(bodyBlock, &(desc->record_le));

			*addr = bodyBlock;
			break;
		}
		case FS_EF_STRUCTURE_RECORD_VAR: {
			for(i=0;i<(desc->file_size);i++){
				//ack
				Transmission_SendByte( ~header[1] );
				var_length[i]=Transmission_GetByte();
				sum=sum+var_length[i];
			}

			//alloc body
			status = FS_ALLOC_BODY(&bodyBlock, (desc->file_size)+sum+1);
			if(status == FS_ERROR_INSUFFICIENT_SPACE){
				return status;
			}

			FS_SET_BODY_STRUCTURE(bodyBlock, &(desc->structure));
			FS_SET_BODY_TYPE(bodyBlock, &(desc->type));
			FS_SET_BODY_AC(bodyBlock, &(desc->AC));
			FS_SET_BODY_SIZE(bodyBlock, &(desc->file_size));
			sum=0;
			for(i=0;i<(desc->file_size);i++){
				FS_SET_RECORD_VAR_LENGTH(bodyBlock,i,&(sum) );
				sum=sum+var_length[i];
			}
			FS_SET_RECORD_VAR_LENGTH(bodyBlock,(desc->file_size),&(sum) );
			*addr = bodyBlock;
			break;
		}
	}
	return FS_OK;
}

unsigned int FSCreateFile(unsigned int tag, void * desc){
	unsigned int header, body;
	unsigned int current;
	unsigned int fid;
	unsigned char currentTag;
	int status;

	if(tag == FS_TAG_DF){
		fid = ((struct DF_st *)desc)->FID;
	} else
	if (tag == FS_TAG_EF) {
		fid = ((struct EF_st *)desc)->FID;
	}

	// Check if current is DF
	current = State_GetCurrent();
	FS_GET_HEADER_TAG(current, (unsigned char *)&currentTag);
	if(currentTag == FS_TAG_EF){
		return FS_ERROR_WRONG_FS_STRUCTURE;
	}

	// // Check consistency
	// // Check all FID of current DF
	// status = FSSearchFID(fid);
	// if(status != FS_NONE){
	// 	return FS_ERROR_DUPLICATE_FID;
	// }

	//create file header
	status = FSCreateHeader((unsigned char)tag, fid, &header);
	if (status != FS_OK){
		return status;
	}

	//create file body
	if(tag == FS_TAG_EF) {
		status = FSCreateBodyEF((struct EF_st *)desc, &body);
		if (status != FS_OK){
			return status;
		}
		FS_SET_HEADER_BODY_POINTER(header, &body);
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
		temp = Memory_ReadByte(FS_START + FS_ALLOC_TABLE_OFFSET + i);

		startXOR = (i == startbyte) ? startbit : 0;
		stopXOR = (i == stopbyte) ? stopbit : 8;

		tempXOR = 0;

		for(j = startXOR; j < stopXOR; j++)
			tempXOR = tempXOR ^ (128 >> j);

		temp = temp ^ tempXOR;

		Memory_WriteByte(FS_START + FS_ALLOC_TABLE_OFFSET + i, temp);
	}
	return FS_OK;
}

unsigned int FSDeleteFile(unsigned int fid){
	unsigned int header, parent, sibling, siblingBefore, siblingNext;
	unsigned int body, bodySize;
	unsigned char  tag;

	//check FID
	header = FSSearchFID(fid);

	if(header == FS_NONE){
		return FS_ERROR_NOT_FOUND;
	}

	//if DF, make sure it doesn't have any child
	//if first child, untie from parent, and change parent's child to sibling (if any)
	FS_GET_HEADER_PARENT(header, &parent);

	FS_GET_HEADER_CHILD(parent, &sibling);

	if(sibling == header) {
		FS_GET_HEADER_SIBLING(header, &sibling);
		FS_SET_HEADER_CHILD(parent, &sibling);
	}
	//else, change the sibling before to chain to sibling after
	else {
		while(sibling != header) {
		siblingBefore = sibling;
		FS_GET_HEADER_SIBLING(sibling, &sibling);
		}
		FS_GET_HEADER_SIBLING(header, &siblingNext);
		FS_SET_HEADER_SIBLING(siblingBefore, &siblingNext);
	}

	//free body
	FS_GET_HEADER_TAG(header, &tag);

	if(tag == FS_TAG_EF){
		FS_GET_HEADER_BODY_POINTER(header, &body);
		FS_GET_BODY_SIZE(body, &bodySize);
		FSFree(body, CEIL(((FS_BODY_HEADER_SIZE)+bodySize),FS_BLOCK_SIZE));
	}

	//free header
	FSFree(header, CEIL((FS_HEADER_SIZE),FS_BLOCK_SIZE));
	return FS_OK;
}
