/*****************************************************************************
Melody Driver - (C) Chris Walton 2012
File: flash.c
Description: Dummy Flash Functions
******************************************************************************/

#include "flash.h"

#define RAMDATA     0x40001400      // Atari Variables (256 bytes)
#define FLASHDATA   0x40001500      // Backup variables

// Supported Operations
// 1 = Load Score Table
// 2 = Save Score Table

void FLASH_Main(void)
{
  unsigned char* ramdata = (unsigned char*)RAMDATA;
  unsigned char* flashdata = (unsigned char*)FLASHDATA;
  unsigned int operation = (ramdata[255]) & 0x0F;
  unsigned int i, result = 1;

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
      for (i = 0; i < 256; i++)
      {
        flashdata[i] = ramdata[i];
      }
      result = 0;
      break;
    default:  // Unsupported operation
      break;
  }

  // Store result
  ramdata[255] = (unsigned char)result;
}


