
#ifndef FS_H

#define FS_H

// FS_RESPONSE TO COMMAND
#define FS_OK							0
#define FS_ERROR						30
#define FS_ERROR_INSUFFICIENT_SPACE		31
#define FS_ERROR_NOT_FOUND				32
#define FS_ERROR_DUPLICATE_FID			33
#define FS_ERROR_SECURITY_STATUS		34
#define FS_ERROR_WRONG_FS_STRUCTURE		35
#define FS_NONE							0XFF

// FS_TAG ID
#define FS_TAG_MF						0x3F
#define FS_TAG_DF						0x4F
#define FS_TAG_EF						0x5F

#define FS_EF_STRUCTURE_TRANSPARENT		0x01
#define FS_EF_STRUCTURE_RECORD_FIXED	0x02
#define FS_EF_STRUCTURE_RECORD_VAR		0x04
#define FS_EF_STRUCTURE_CYCLIC			0x06

#define FS_EF_TYPE_WORKING		0
#define FS_EF_TYPE_INTERNAL		1

#define FS_OP_READ		0
#define FS_OP_UPDATE	1
#define FS_OP_WRITE		2

// OFFSET FILE
#define FS_START        CONFIG_FS_START //272
#define FS_BLOCK_SIZE   CONFIG_FS_BLOCK_SIZE //2
#define FS_SIZE         CONFIG_FS_SIZE //512

// HEADER DEFINITION
#define FS_HEADER_TAG_SIZE			1
#define FS_HEADER_FID_SIZE			2
#define FS_HEADER_PARENT_SIZE		2
#define FS_HEADER_CHILD_SIZE		2
#define FS_HEADER_SIBLING_SIZE		2
#define FS_HEADER_BODY_POINTER_SIZE	2

#define FS_HEADER_SIZE		FS_HEADER_TAG_SIZE + \
							FS_HEADER_FID_SIZE + \
			   				FS_HEADER_PARENT_SIZE + \
			   				FS_HEADER_CHILD_SIZE + \
			   				FS_HEADER_SIBLING_SIZE + \
							FS_HEADER_BODY_POINTER_SIZE


#define FS_HEADER_TAG_OFFSET			0
#define FS_HEADER_FID_OFFSET			FS_HEADER_TAG_OFFSET + FS_HEADER_TAG_SIZE
#define FS_HEADER_PARENT_OFFSET			FS_HEADER_FID_OFFSET + FS_HEADER_FID_SIZE
#define FS_HEADER_CHILD_OFFSET			FS_HEADER_PARENT_OFFSET + FS_HEADER_PARENT_SIZE
#define FS_HEADER_SIBLING_OFFSET		FS_HEADER_CHILD_OFFSET + FS_HEADER_CHILD_SIZE
#define FS_HEADER_BODY_POINTER_OFFSET	FS_HEADER_SIBLING_OFFSET + FS_HEADER_SIBLING_SIZE

// BODY HEADER DEFINITION
#define FS_BODY_STRUCTURE_OFFSET	0
#define FS_BODY_STRUCTURE_SIZE		1
#define FS_BODY_TYPE_SIZE			1
#define FS_BODY_AC_SIZE				1
#define FS_BODY_SIZE_SIZE			2
#define FS_BODY_RECORD_LENGTH_SIZE	1

#define FS_BODY_TYPE_OFFSET		FS_BODY_STRUCTURE_OFFSET 	+ FS_BODY_STRUCTURE_SIZE
#define FS_BODY_AC_OFFSET		FS_BODY_TYPE_OFFSET 		+ FS_BODY_TYPE_SIZE
#define FS_BODY_SIZE_OFFSET 	FS_BODY_AC_OFFSET 			+ FS_BODY_AC_SIZE
#define FS_BODY_BODY_OFFSET		FS_BODY_SIZE_OFFSET 		+ FS_BODY_SIZE_SIZE

#define FS_BODY_HEADER_SIZE		FS_BODY_STRUCTURE_SIZE + \
								FS_BODY_TYPE_SIZE + \
								FS_BODY_AC_SIZE + \
								FS_BODY_SIZE_SIZE


#define FS_BLOCKS								FS_SIZE/FS_BLOCK_SIZE //512/2 =256
#define FS_ALLOC_TABLE_SIZE						(FS_BLOCKS/8)/FS_BLOCK_SIZE //(256/8)/2 = 32
#define FS_FILE_TABLE_SIZE 						CONFIG_FS_FILE_TABLE_SIZE/FS_BLOCK_SIZE // 128/2 = 64


#define FS_ALLOC_TABLE_OFFSET					0
#define FS_FILE_TABLE_OFFSET					FS_ALLOC_TABLE_OFFSET + FS_ALLOC_TABLE_SIZE //0+16 = 16 0x10
#define FS_FILE_BODY_OFFSET						FS_FILE_TABLE_OFFSET + FS_FILE_TABLE_SIZE // 16+64 = 80 = 0x50

#define FS_ALLOC_HEADER(address)				FSAlloc(CEIL((FS_HEADER_SIZE),FS_BLOCK_SIZE), FS_FILE_TABLE_OFFSET, FS_FILE_BODY_OFFSET, address)
#define FS_ALLOC_BODY(address, length)			FSAlloc(CEIL((FS_BODY_HEADER_SIZE + length),FS_BLOCK_SIZE), FS_FILE_BODY_OFFSET, FS_BLOCKS, address);

#define FS_SET_HEADER_TAG(block, src) 			Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_TAG_OFFSET, FS_HEADER_TAG_SIZE, (unsigned char *)src)
#define FS_GET_HEADER_TAG(block, dest) 			Memory_ReadBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_TAG_OFFSET, FS_HEADER_TAG_SIZE, (unsigned char *)dest)
#define FS_SET_HEADER_FID(block, src) 			Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_FID_OFFSET, FS_HEADER_FID_SIZE, (unsigned char *)src)
#define FS_GET_HEADER_FID(block, dest) 			Memory_ReadBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_FID_OFFSET, FS_HEADER_FID_SIZE, (unsigned char *)dest)
#define FS_GET_HEADER_PARENT(block, dest) 		Memory_ReadBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_PARENT_OFFSET, FS_HEADER_PARENT_SIZE, (unsigned char *)dest)
#define FS_SET_HEADER_PARENT(block, src) 		Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_PARENT_OFFSET, FS_HEADER_PARENT_SIZE, (unsigned char *)src)
#define FS_GET_HEADER_CHILD(block, dest) 		Memory_ReadBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_CHILD_OFFSET, FS_HEADER_CHILD_SIZE, (unsigned char *)dest)
#define FS_SET_HEADER_CHILD(block, src) 		Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_CHILD_OFFSET, FS_HEADER_CHILD_SIZE, (unsigned char *)src)
#define FS_GET_HEADER_SIBLING(block, dest) 		Memory_ReadBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_SIBLING_OFFSET, FS_HEADER_SIBLING_SIZE, (unsigned char *)dest)
#define FS_SET_HEADER_SIBLING(block, src) 		Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_SIBLING_OFFSET, FS_HEADER_SIBLING_SIZE, (unsigned char *)src)
#define FS_GET_HEADER_BODY_POINTER(block, dest) Memory_ReadBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_BODY_POINTER_OFFSET, FS_HEADER_BODY_POINTER_SIZE, (unsigned char *)dest)
#define FS_SET_HEADER_BODY_POINTER(block, src) 	Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_HEADER_BODY_POINTER_OFFSET, FS_HEADER_BODY_POINTER_SIZE, (unsigned char *)src)


#define FS_GET_BODY_STRUCTURE(block, dest) 		Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_STRUCTURE_OFFSET, FS_BODY_STRUCTURE_SIZE, (unsigned char *)dest)
#define FS_SET_BODY_STRUCTURE(block, src) 		Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_STRUCTURE_OFFSET, FS_BODY_STRUCTURE_SIZE, (unsigned char *)src)
#define FS_GET_BODY_TYPE(block, dest) 			Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_TYPE_OFFSET, FS_BODY_TYPE_SIZE, (unsigned char *)dest)
#define FS_SET_BODY_TYPE(block, src) 			Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_TYPE_OFFSET, FS_BODY_TYPE_SIZE, (unsigned char *)src)
#define FS_GET_BODY_AC(block, dest) 			Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_AC_OFFSET, FS_BODY_AC_SIZE, (unsigned char *)dest)
#define FS_SET_BODY_AC(block, src) 				Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_AC_OFFSET, FS_BODY_AC_SIZE, (unsigned char *)src)
#define FS_GET_BODY_ACUPDATE(block, dest) 		Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_ACUPDATE_OFFSET, FS_BODY_ACUPDATE_SIZE, (unsigned char *)dest)
#define FS_SET_BODY_ACUPDATE(block, src) 		Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_ACUPDATE_OFFSET, FS_BODY_ACUPDATE_SIZE, (unsigned char *)src)
#define FS_GET_BODY_SIZE(block, dest) 			Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_SIZE_OFFSET, FS_BODY_SIZE_SIZE, (unsigned char *)dest)
#define FS_SET_BODY_SIZE(block, src) 			Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_SIZE_OFFSET, FS_BODY_SIZE_SIZE, (unsigned char *)src)
#define FS_GET_BODY_BODY(block, length, dest) 	Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_BODY_OFFSET + offset, length, (unsigned char *)dest)
#define FS_SET_BODY_BODY(block, length, src) 	Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_BODY_OFFSET + offset, length, (unsigned char *)src)

#define FS_GET_RECORD_FIXED_LENGTH(block, dest) 					Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_BODY_OFFSET, FS_BODY_RECORD_LENGTH_SIZE, (unsigned char *)dest)
#define FS_SET_RECORD_FIXED_LENGTH(block, src) 						Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_BODY_OFFSET, FS_BODY_RECORD_LENGTH_SIZE, (unsigned char *)src)
#define FS_GET_RECORD_FIXED_DATA(block, length, record_num, dest) 	Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_BODY_OFFSET + FS_BODY_RECORD_LENGTH_SIZE + (record_num-1)*length, length, (unsigned char *)dest)
#define FS_SET_RECORD_FIXED_DATA(block, length, record_num, src) 	Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_BODY_OFFSET + FS_BODY_RECORD_LENGTH_SIZE + (record_num-1)*length, length, (unsigned char *)src)

#define FS_GET_RECORD_VAR_LENGTH(block, offset, dest) 				Memory_ReadBlock (FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_BODY_OFFSET + offset, FS_BODY_RECORD_LENGTH_SIZE, (unsigned char *)dest)
#define FS_SET_RECORD_VAR_LENGTH(block, offset, src) 				Memory_WriteBlock(FS_START + (block * FS_BLOCK_SIZE) + FS_BODY_BODY_OFFSET + offset, FS_BODY_RECORD_LENGTH_SIZE, (unsigned char *)src)

#define CEIL(A,B)       ((A%B)==0 ? (A/B) : (A/B + 1))


/*****************************/
/*        Enumeration        */
/*****************************/


/****************************/
/*      Data Structure      */
/****************************/

struct EF_st
{
	unsigned int	FID;		///< File identifier
	unsigned char	structure;	///< file structure : Transparent or Record
	unsigned char	type;		///< type of file : Working or Internal
	unsigned char	AC;			///< access control for read operation
	unsigned char	*ptr_body;	///< pointer to file body
	unsigned int 	file_size;	///< size of file
	unsigned char	record_le;	///< record length
} ;

struct DF_st
{
	unsigned int	FID;                    ///< File identifier
	char			DFname[16];             ///< DF name 
	char			asc_flag;               ///< indication to application specific code
	int				(* asc)(int);           ///< pointer to the ASC handler
} ;

/**************************/
/*        Variable        */
/**************************/


/**************************/
/*        Function        */
/**************************/
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
#endif
