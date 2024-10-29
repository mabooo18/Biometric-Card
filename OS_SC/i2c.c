#include <reg51.h>
#include "i2c.h"

sbit SDA = P1^0;
sbit SCL = P1^1;

void I2C_delay(void)
{
//	unsigned char i;

//	for(i=0; i<I2C_DELAY; i++); //I2C max speed is only 400kHz
}


void I2C_start(void)
{
	SCL = 0;
	SDA = 1;        /* Set SDA */
	I2C_delay();
	I2C_delay();
	SCL = 1;		/* Set SCL */
	I2C_delay();
	I2C_delay();
	SDA = 0;        /* Clear SDA */
	I2C_delay();
	I2C_delay();
	SCL = 0;        /* Clear SCL */
	I2C_delay();
}

void I2C_stop(void)
{
	SCL = 0;
	SDA = 0;			/* Clear SDA */
	I2C_delay();
	I2C_delay();
	SCL = 1;			/* Clear SCL */
	I2C_delay();
	I2C_delay();
	SDA = 1;			/* Set SDA */
	I2C_delay();
	I2C_delay();
}

bit I2C_write(unsigned char dat)
{
	bit data_bit;		
	unsigned char i;	

	for(i=0;i<8;i++)				/* For loop 8 time(send data 1 byte) */
	{
		SCL = 0;
		data_bit = dat & 0x80;		/* Filter MSB bit keep to data_bit */
		SDA = data_bit;				/* Send data_bit to SDA */
		I2C_delay();	
		SCL = 1;
		dat = dat<<1;  
		I2C_delay();
		I2C_delay();
		SCL = 0;
		I2C_delay();	
	}
	SDA = 1;			/* Set SDA */
	SCL = 0;			/* Set SCL */
	I2C_delay();	
	SCL = 1;			/* Clear SCL */
	data_bit = SDA;   	/* Check acknowledge */
	I2C_delay();
	I2C_delay();
	SCL = 0;			/* Clear SCL */
	I2C_delay();
	return data_bit;	/* If data_bit = 0 i2c is valid */		 	
}

unsigned char I2C_read(void)
{
	bit rd_bit;	
	unsigned char i, dat;

	dat = 0x00;	
	SDA = 1;
	for(i=0;i<8;i++)		/* For loop read data 1 byte */
	{
		SCL = 0;			/* Clear SCL */
		I2C_delay();
		SCL = 1;			/* Set SCL */

		I2C_delay(); 
		I2C_delay();
		rd_bit = SDA;		/* Keep for check acknowledge	*/
		dat = dat<<1;		
		dat = dat | rd_bit;	/* Keep bit data in dat */
		SCL = 0;			/* Clear SCL */
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

