#ifndef RESPONSE_H

#define RESPONSE_H

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
#endif
