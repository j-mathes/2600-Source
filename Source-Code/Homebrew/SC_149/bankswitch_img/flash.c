/*****************************************************************************
Melody Driver - (C) Chris Walton 2012
File: flash.c
Description: Flash memory functions (IAP wrappers)
WARNING: These operations can only be used by code running from SRAM!
******************************************************************************/

#include "lpc2103.h"
#include "flash.h"

#define RAMDATA     0x40001000      // Atari Variables (256 bytes)
#define FLASHDATA   0x00007000      // Flash address for score table

// Prepare sectors for write or erase
static int FLASH_PrepareSector(IAPCmd *pFlash, unsigned int sector)
{
  IAP iap = (IAP)IAP_ADDRESS;
  unsigned int *cmd = pFlash->command;
  unsigned int *res = pFlash->result;
  
  // Send prepare command
  cmd[0] = 50;
  cmd[1] = sector;
  cmd[2] = sector;
  iap(cmd, res);
  
  // Check result
  if (res[0] != IAP_CMD_SUCCESS)
  {
    return 1;
  }
  return 0;
}

// Erase flash sector
int FLASH_EraseSector(IAPCmd *pFlash, unsigned int sector)
{
  IAP iap = (IAP)IAP_ADDRESS;
  unsigned int *cmd = pFlash->command;
  unsigned int *res = pFlash->result;
  
  // Check if sector already empty (to reduce wear)
  cmd[0] = 53;
  cmd[1] = sector;
  cmd[2] = sector;
  iap(cmd, res);
  
  // Sector not empty
  if (res[0] == IAP_SECTOR_NOT_BLANK)
  {
    // Prepare sector for erase
    if (FLASH_PrepareSector(pFlash, sector)) return 1;

    // Erase sector
    cmd[0] = 52;
    cmd[1] = sector;
    cmd[2] = sector;
    cmd[3] = MELODY_CLOCK;
    iap(cmd, res);
    if (res[0] != IAP_CMD_SUCCESS)
    {
      return 1;
    }
  }
  return 0;
}

// Write flash memory (if write is zero then a verify is performed instead)
int FLASH_WriteBlock(IAPCmd *pFlash, 
                     unsigned int flashaddress, 
                     unsigned char *pData)
{
  IAP iap = (IAP)IAP_ADDRESS;
  unsigned int *cmd = pFlash->command;
  unsigned int *res = pFlash->result;
  unsigned int memaddress = (unsigned int)pData;

  // Prepare sector for write
  if (FLASH_PrepareSector(pFlash, (flashaddress / 4096U))) return 1;

  // Write block
  cmd[0] = 51;
  cmd[1] = flashaddress;
  cmd[2] = memaddress;
  cmd[3] = 256U;
  cmd[4] = MELODY_CLOCK;
  iap(cmd, res);

  // Check for success
  if (res[0] != IAP_CMD_SUCCESS)
  {
    return 1;
  }
  return 0;
}

// Supported Operations
// 1 = Load Score Table
// 2 = Save Score Table

void FLASH_Main(void)
{
  unsigned char* ramdata = (unsigned char*)RAMDATA;
  unsigned char* flashdata = (unsigned char*)FLASHDATA;
  unsigned int operation = (ramdata[255]) & 0x0F;
  unsigned int i, result = 1;

  // Flash (IAP) command
  IAPCmd flashcmd;

  // Check or valid operation
  switch (operation)
  {
    case 1:   // Load Score Table
      for (i = 0; i < 256; i++)
      {
        // Copy data from Flash to RAM
        ramdata[i] = flashdata[i];
      }
      result = 0;
      break;
    case 2:   // Save Score Table
      result = (FLASH_EraseSector(&flashcmd, (FLASHDATA / 4096U)) ||
                FLASH_WriteBlock(&flashcmd, FLASHDATA, ramdata));
      break;
    default:  // Unsupported operation
      break;
  }

  // Store result
  ramdata[255] = (unsigned char)result;
}


