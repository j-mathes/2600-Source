///////////////////////////////////////////////////////////////////////////////
// STAR CASTLE - Game Image Tool - Copyright (C) Chris Walton 2012
///////////////////////////////////////////////////////////////////////////////

// STL functions
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

// Asserts
#include <assert.h>

// SimpleOpt CLI parser (from http://code.jellycan.com/simpleopt/)
#include "SimpleOpt.h"
#include "SimpleGlob.h"

// Command line options
enum
{
  OPT_HELP,
  OPT_BOOTLOADER,
  OPT_GAME,
  OPT_OUTPUT
};

// Command line specification
CSimpleOpt::SOption cli[] = {
  {OPT_HELP,              "-?",               SO_NONE},
  {OPT_HELP,              "--help",           SO_NONE},
  {OPT_BOOTLOADER,        "-b",               SO_REQ_SEP},
  {OPT_BOOTLOADER,        "--bootloader",     SO_REQ_SEP},
  {OPT_GAME,              "-g",               SO_REQ_SEP},
  {OPT_GAME,              "--game",           SO_REQ_SEP},
  {OPT_OUTPUT,            "-o",               SO_REQ_SEP},
  {OPT_OUTPUT,            "--output",         SO_REQ_SEP},
  SO_END_OF_OPTIONS
};

// Show command line usage
void showUsage(void)
{
  std::cout << "Usage: makebin [OPTIONS]" << std::endl <<
  "-b FILE    --bootloader FILE     Bootloader (12KB)." << std::endl <<
  "-g FILE    --game FILE           Game (28KB)." << std::endl <<
  "-o FILE    --output FILE         Output image." << std::endl <<
  "-?         --help                Show this help." << std::endl;
}

// Show command line error type
const std::string GetLastErrorText(int error) 
{
  switch (error) 
  {
    case SO_SUCCESS:                return "Success";
    case SO_OPT_INVALID:            return "Unrecognized option";
    case SO_OPT_MULTIPLE:           return "Option matched multiple strings";
    case SO_ARG_INVALID:            return "Option does not accept argument";
    case SO_ARG_INVALID_TYPE:       return "Invalid argument format";
    case SO_ARG_MISSING:            return "Required argument is missing";
    case SO_ARG_INVALID_DATA:       return "Invalid argument data";
    default:                        return "Unknown error";
  }
}

int main(int argc, char **argv)
{
  // Error variable
  bool error = false;
  
  // File variables
  std::string bootloader="", game="", output="";
  std::ifstream bootfile, gamefile;
  std::ofstream outfile;
  std::streamsize bootlen, gamelen;
  
  // ROM image (32K)
  const unsigned int romlen = 32*1024;
  char rom[romlen];
  memset(rom, 0, romlen);

  // Bootloader image (12K)
  const unsigned int loaderlen = 12*1024;
  char loader[loaderlen];
  memset(loader, 0, loaderlen);

  // Rom pointer
  unsigned int imglen = 0;
  unsigned int i;
  
  // Default output file
  output = "out.img";
  
  // Process command line args
  CSimpleOpt args(argc, argv, cli);
  while (args.Next())
  {
    if (args.LastError() == SO_SUCCESS)
    {
      switch (args.OptionId()) 
      {
        case OPT_HELP:
          showUsage();
          return EXIT_SUCCESS;
          break;
        case OPT_BOOTLOADER:
          bootloader = args.OptionArg();
          break;
        case OPT_GAME:
          game = args.OptionArg();
          break;
        case OPT_OUTPUT:
          output = args.OptionArg();
          break;
        default:
          // Show argument error
          std::cerr << "ERROR: Unexpected argument " << args.OptionText() << std::endl;
          std::cerr << "(use --help to get command line help)" << std::endl;
          return EXIT_FAILURE;
      }
    }
    else
    {
      // Show argument error
      std::cerr << GetLastErrorText(args.LastError()) << 
        ": '" << args.OptionText() <<
        "' (use --help to get command line help)" << std::endl;
      return EXIT_FAILURE;
    }
  }

  // Check for errors
  error = 0;

  // Check that bootloader file was supplied
  if (bootloader.size() == 0) 
  {
    std::cerr << "ERROR: no bootloader file supplied." <<  std::endl;
    error = 1;
  }

  // Check that game file was supplied
  if (game.size() == 0) 
  {
    std::cerr << "ERROR: no game file supplied." <<  std::endl;
    error = 1;
  }

  // Check for errors
  if (error == 1)
  {
    std::cerr << "(use --help to get command line help)" << std::endl;
    return EXIT_FAILURE;
  }
  
  // Read game file
  gamefile.open(game.c_str(), std::ios::in | std::ios::binary | std::ios::ate);
  if (!gamefile.is_open())
  {
    std::cerr << "ERROR: game file " << game << " could not be opened." <<  std::endl;
    return EXIT_FAILURE;
  }
  gamelen = gamefile.tellg();
  if (gamelen != (28 * 1024))
  {
    std::cerr << "ERROR: game size must be 28KB (actual length " << gamelen << " bytes)." << std::endl;
    gamefile.close();
    return EXIT_FAILURE;
  }
  std::cout << "INFO: Reading game file (" << gamelen << " bytes)." << std::endl;
  gamefile.seekg(0, std::ios::beg);
  gamefile.read(&rom[0], gamelen);
  gamefile.close();
  
  // Read bootloader file
  bootfile.open(bootloader.c_str(), std::ios::in | std::ios::binary | std::ios::ate);
  if (!bootfile.is_open())
  {
    std::cerr << "ERROR: bootloader file " << bootloader << " could not be opened." <<  std::endl;
    return EXIT_FAILURE;
  }
  bootlen = bootfile.tellg();
  if (bootlen <= 0 || bootlen > loaderlen)
  {
    std::cerr << "ERROR: invalid bootloader size " << bootlen << " bytes (max " << loaderlen << " bytes)." << std::endl;
    bootfile.close();
    return EXIT_FAILURE;
  }
  std::cout << "INFO: Reading bootloader file (" << bootlen << " bytes)." << std::endl;
  bootfile.seekg(0, std::ios::beg);
  bootfile.read(&loader[0], bootlen);
  bootfile.close();

  // Splice bootloader into game binary
  for (i = 0; i < 512; i++)
  {
    rom[i] = loader[i];
    rom[(4*1024)+i] = loader[(4*1024)+i];
    rom[(8*1024)+i] = loader[(8*1024)+i];
  }
  for (i = 512; i < 4096; i++)
  {
    if (loader[i] != 0 || loader[(4*1024)+i] != 0 || loader[(8*1024)+i] != 0)
    {
      std::cerr << "ERROR: Loader contains non-zero data outside 512 byte region." << std::endl;
      return EXIT_FAILURE;
    }
  }

  // End of binary
  imglen = 32*1024;

  // Write output file
  outfile.open(output.c_str(), std::ios::out | std::ios::binary);
  if (!outfile.is_open())
  {
    std::cerr << "ERROR: output file " << output << " could not be opened for writing." <<  std::endl;
    return EXIT_FAILURE;
  }
  std::cout << "INFO: Writing image " << output << " (" << imglen << " bytes)" << std::endl;
  outfile.seekp(0, std::ios::beg);
  outfile.write(rom, std::streamsize(imglen));
  outfile.close();
  
  return EXIT_SUCCESS;
}


