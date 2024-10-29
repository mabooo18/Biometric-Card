
#line 1 "hal.c" /0
  
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
 
 
#line 1 "hal.c" /0
 
  
#line 1 "i2c.h" /0
 
 
 
 
 
 void I2C_delay(void);
 void I2C_start(void);
 void I2C_stop(void);
 bit I2C_write(unsigned char dat);
 unsigned char I2C_read(void);
 
 
#line 2 "hal.c" /0
 
  
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
 
#line 3 "hal.c" /0
 
 
 void init_HW(void){
 coprocessor_init();
 SCON  = 0xD0;                    
 TMOD |= 0x20;                    
 TH1   = 0xff;                    
 TR1   = 1;                       
 TI    = 1;                       
 I2C_stop();
 }
