
#line 1 "i2c.c" /0
  
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
 
 
#line 1 "i2c.c" /0
 
  
#line 1 "i2c.h" /0
 
 
 
 
 
 void I2C_delay(void);
 void I2C_start(void);
 void I2C_stop(void);
 bit I2C_write(unsigned char dat);
 unsigned char I2C_read(void);
 
 
#line 2 "i2c.c" /0
 
 
 sbit SDA = P1^0;
 sbit SCL = P1^1;
 
 void I2C_delay(void)
 {
 
 
 
 }
 
 
 void I2C_start(void)
 {
 SCL = 0;
 SDA = 1;         
 I2C_delay();
 I2C_delay();
 SCL = 1;		 
 I2C_delay();
 I2C_delay();
 SDA = 0;         
 I2C_delay();
 I2C_delay();
 SCL = 0;         
 I2C_delay();
 }
 
 void I2C_stop(void)
 {
 SCL = 0;
 SDA = 0;			 
 I2C_delay();
 I2C_delay();
 SCL = 1;			 
 I2C_delay();
 I2C_delay();
 SDA = 1;			 
 I2C_delay();
 I2C_delay();
 }
 
 bit I2C_write(unsigned char dat)
 {
 bit data_bit;		
 unsigned char i;	
 
 for(i=0;i<8;i++)				 
 {
 SCL = 0;
 data_bit = dat & 0x80;		 
 SDA = data_bit;				 
 I2C_delay();	
 SCL = 1;
 dat = dat<<1;  
 I2C_delay();
 I2C_delay();
 SCL = 0;
 I2C_delay();	
 }
 SDA = 1;			 
 SCL = 0;			 
 I2C_delay();	
 SCL = 1;			 
 data_bit = SDA;   	 
 I2C_delay();
 I2C_delay();
 SCL = 0;			 
 I2C_delay();
 return data_bit;	 
 }
 
 unsigned char I2C_read(void)
 {
 bit rd_bit;	
 unsigned char i, dat;
 
 dat = 0x00;	
 SDA = 1;
 for(i=0;i<8;i++)		 
 {
 SCL = 0;			 
 I2C_delay();
 SCL = 1;			 
 
 I2C_delay(); 
 I2C_delay();
 rd_bit = SDA;		 
 dat = dat<<1;		
 dat = dat | rd_bit;	 
 SCL = 0;			 
 I2C_delay();
 
 }
 SDA = 1;
 SCL = 0;
 I2C_delay(); 
 SCL =1;
 I2C_delay();
 I2C_delay();
 SCL =0;
 I2C_delay();
 return dat;
 }
 
