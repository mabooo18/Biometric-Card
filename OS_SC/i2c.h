#ifndef I2C_H
#define I2C_H

#define I2C_DELAY 0x01	/* For delay i2c bus */

void I2C_delay(void);
void I2C_start(void);
void I2C_stop(void);
bit I2C_write(unsigned char dat);
unsigned char I2C_read(void);

#endif