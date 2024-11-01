#define CONFIG_FS_SIZE                  512
#define CONFIG_FS_START                 272
#define CONFIG_FS_BLOCK_SIZE            2
#define CONFIG_FS_FILE_TABLE_SIZE       128

#define MAX_BUFFER_SIZE 32

#define ATR_LEN_ADDR    0x0001
#define ATR_ADDR        0x0002
#define ATR_MAXLEN      24

#define PIN_ADDR                ATR_ADDR+ATR_MAXLEN //2+24=26
#define PIN_LEN                 4
#define PIN_RETRIES_ADDR        PIN_ADDR+PIN_LEN //30
#define PIN_RETRIES_LEN         1

#define PIN_MAX_RETRIES         3

#define SERNUM_ADDR             PIN_RETRIES_ADDR + PIN_RETRIES_LEN //31
#define SERNUM_LEN              8

#define RAND_STATE_ADDR         (SERNUM_ADDR + SERNUM_LEN) //39 27x
#define RAND_STATE_LEN          32

#define EXT_AUTH_KEY_ADDR       (RAND_STATE_ADDR + RAND_STATE_LEN) //71
#define EXT_AUTH_KEY_LEN        16

#define EXT_AUTH_RETRIES_ADDR   (EXT_AUTH_KEY_ADDR + EXT_AUTH_KEY_LEN) //87 x57
#define EXT_AUTH_RETRIES_LEN    1

#define EXT_AUTH_MAX_RETRIES         3

#define KEY_ECC_ADDR_SC (EXT_AUTH_RETRIES_ADDR+EXT_AUTH_RETRIES_LEN) //88
#define KEY_ECC_SZ 60

#define KEY_ECC_ADDR_RD (KEY_ECC_ADDR_SC+KEY_ECC_SZ) //148


#define PIN_HASH_ADDR (KEY_ECC_ADDR_RD+KEY_ECC_SZ) //208 //D0
#define PIN_HASH_LEN 32

