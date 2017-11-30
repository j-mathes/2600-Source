/*****************************************************************************
Melody Driver - (C) Chris Walton 2012
File: flash.h
Description: Flash memory functions (IAP wrappers)
WARNING: These operations can only be used by code running in SRAM!!!
******************************************************************************/

#ifndef FLASH_H
#define FLASH_H

// Melody Clock Speed (kHz)
#define MELODY_CLOCK 70000

// Flash Size (32K)
#define FLASHSIZE     0x00008000

// IAP memory address
#define IAP_ADDRESS   0x7FFFFFF1

// IAP return codes
#define IAP_CMD_SUCCESS           0
#define IAP_INVALID_COMMAND       1
#define IAP_SRC_ADDR_ERROR        2
#define IAP_DST_ADDR_ERROR        3
#define IAP_SRC_ADDR_NOT_MAPPED   4
#define IAP_DST_ADDR_NOT_MAPPED   5
#define IAP_COUNT_ERROR           6
#define IAP_INVALID_SECTOR        7
#define IAP_SECTOR_NOT_BLANK      8
#define IAP_SECTOR_NOT_PREPARED   9
#define IAP_COMPARE_ERROR         10
#define IAP_BUSY                  11

// IAP function type
typedef void (*IAP)(unsigned int [], unsigned int[]);

// IAP Command Structure
typedef struct _IAPCmd
{
  // Command data
  unsigned int command[5];
  // Response data
  unsigned int result[3];
} IAPCmd;

// Erase flash sector
extern int FLASH_EraseSector(IAPCmd *pFlash, unsigned int sector);

// Verify/Write flash memory
extern int FLASH_WriteBlock(IAPCmd *pFlash, 
                            unsigned int flashaddress,
                            unsigned char *pData);

// Flash Entry Point
extern void FLASH_Main(void);

#endif // FLASH_H
