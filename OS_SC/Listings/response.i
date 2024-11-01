
#line 1 "response.c" /0
  
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
 
 
 
#line 1 "response.c" /0
 
  
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
 
#line 2 "response.c" /0
 
 
 unsigned int sw;
 
 void Response_SetSW( unsigned char response, unsigned char extra )
 {
 switch( response ) {
 case Response_OK:
 sw = 0x9000;
 break;
 case Response_Normal:
 sw = 0x6100;
 break;
 case Response_Auth_Success:
 sw = 0x6108;
 break;
 case Response_Warning_Unchanged:
 sw = 0x6200;
 break;
 case Response_Warning_DataCorrupt:
 sw = 0x6281;
 break;
 case Response_Warning_EndOfFile:
 sw = 0x6282;
 break;
 case Response_Warning_FileDeactivated:
 sw = 0x6283;
 break;
 case Response_Warning_Changed:
 sw = 0x6300;
 break;
 case Response_Warning_FilledUp:
 sw = 0x6381;
 break;
 case Response_Warning_Counter:
 sw = 0x63C0;
 break;
 case Response_Error_Unchanged:
 sw = 0x6400;
 break;
 case Response_Error_Changed:
 sw = 0x6500;
 break;
 case Response_WrongLength:
 sw = 0x6700;
 break;
 case Response_NotSupported:
 sw = 0x6800;
 break;
 case Response_NotSupported_LogicalChannel:
 sw = 0x6881;
 break;
 case Response_NotSupported_SecureMessaging:
 sw = 0x6882;
 break;
 case Response_NotSupported_LastCommandExpected:
 sw = 0x6883;
 break;
 case Response_NotSupported_CommandChain:
 sw = 0x6884;
 break;
 case Response_CmdNotAllowed:
 sw = 0x6900;
 break;
 case Response_CmdNotAllowed_Incompatible_FS:
 sw = 0x6981;
 break;
 case Response_CmdNotAllowed_SecurityStatus:
 sw = 0x6982;
 break;
 case Response_CmdNotAllowed_AuthBlocked:
 sw = 0x6983;
 break;
 case Response_CmdNotAllowed_RefDataNotUsable:
 sw = 0x6984;
 break;
 case Response_CmdNotAllowed_ConditionNotSatisfied:
 sw = 0x6985;
 break;
 case Response_CmdNotAllowed_NoCurrentEF:
 sw = 0x6986;
 break;
 case Response_CmdNotAllowed_ExpectSecureMsg:
 sw = 0x6981;
 break;
 case Response_CmdNotAllowed_IncorrectSecureMsg:
 sw = 0x6981;
 break;
 case Response_WrongP1P2:
 sw = 0x6A00;
 break;
 case Response_WrongP1P2_IncorrectData:
 sw = 0x6A80;
 break;
 case Response_WrongP1P2_FuncNotSupported:
 sw = 0x6A81;
 break;
 case Response_WrongP1P2_FileNotFound:
 sw = 0x6A82;
 break;
 case Response_WrongP1P2_RecordNotFound:
 sw = 0x6A83;
 break;
 case Response_WrongP1P2_NotEnoughMem:
 sw = 0x6A84;
 break;
 case Response_WrongP1P2_NCInconsistentTLV:
 sw = 0x6A85;
 break;
 case Response_WrongP1P2_IncorrectP1P2:
 sw = 0x6A86;
 break;
 case Response_WrongP1P2_NCInconsistentP1P2:
 sw = 0x6A87;
 break;
 case Response_WrongP1P2_RefDataNotFound:
 sw = 0x6A88;
 break;
 case Response_WrongP1P2_FileExist:
 sw = 0x6A89;
 break;
 case Response_WrongP1P2_DFNameExist:
 sw = 0x6A8A;
 break;
 case Response_INSNotSupported:
 sw = 0x6D00;
 break;
 case Response_CLANotSupported:
 sw = 0x6E00;
 break;
 case Response_FatalError:
 sw = 0x6F00;
 break;
 default :
 sw = 0xEEEE;
 break;
 }
 sw |= (unsigned int) extra;
 }
