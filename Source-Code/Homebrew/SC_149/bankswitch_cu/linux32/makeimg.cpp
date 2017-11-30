///////////////////////////////////////////////////////////////////////////////
// STAR CASTLE- Custom Image Tool - Copyright (C) Chris Walton 2012
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
  "-b FILE    --bootloader FILE     Bootloader (<= 1KB)." << std::endl <<
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
  std::streamsize bootlength, gamelength;
  
  // ROM image (32K)
  const unsigned int romlength = 32*1024;
  char rom[romlength];
  memset(rom, 0, romlength);
  
  // Rom pointer
  unsigned int bankstart = 0;
  
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
          exit(EXIT_SUCCESS);
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
          exit(EXIT_FAILURE);
      }
    }
    else
    {
      // Show argument error
      std::cerr << GetLastErrorText(args.LastError()) << 
        ": '" << args.OptionText() <<
        "' (use --help to get command line help)" << std::endl;
      exit(EXIT_FAILURE);
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
    exit(EXIT_FAILURE);
  }
  
  // Reset load address
  bankstart = 1024;
  
  // Read game file
  gamefile.open(game.c_str(), std::ios::in | std::ios::binary | std::ios::ate);
  if (!gamefile.is_open())
  {
    std::cerr << "ERROR: game file " << game << " could not be opened." <<  std::endl;
    error = 1;
  }
  gamelength = gamefile.tellg();
  if (gamelength != (28 * 1024))
  {
    std::cerr << "ERROR: game size must be 28KB (actual length " << gamelength << " bytes)." << std::endl;
    gamefile.close();
    exit(EXIT_FAILURE);
  }
  std::cout << "INFO: Reading game file." << std::endl;
  gamefile.seekg(0, std::ios::beg);
  gamefile.read(&rom[bankstart], gamelength);
  gamefile.close();
  
  // Reset bank start
  bankstart = 0;
  
  // Read bootloader file
  bootfile.open(bootloader.c_str(), std::ios::in | std::ios::binary | std::ios::ate);
  if (!bootfile.is_open())
  {
    std::cerr << "ERROR: bootloader file " << bootloader << " could not be opened." <<  std::endl;
    exit(EXIT_FAILURE);
  }
  bootlength = bootfile.tellg();
  if (bootlength <= 0 || bootlength > 1024)
  {
    std::cerr << "ERROR: invalid bootloader size " << bootlength << " bytes (max 1KB)." << std::endl;
    bootfile.close();
    exit(EXIT_FAILURE);
  }
  std::cout << "INFO: Reading bootloader file (" << bootlength << " bytes)." << std::endl;
  bootfile.seekg(0, std::ios::beg);
  bootfile.read(&rom[bankstart], bootlength);
  bootfile.close();

  // End of binary
  bankstart = 32*1024;

  // Write output file
  outfile.open(output.c_str(), std::ios::out | std::ios::binary);
  if (!outfile.is_open())
  {
    std::cerr << "ERROR: output file " << output << " could not be opened for writing." <<  std::endl;
    error = 1;
  }
  std::cout << "INFO: Writing image " << output << " (" << bankstart << " bytes)" << std::endl;
  outfile.seekp(0, std::ios::beg);
  outfile.write(rom, std::streamsize(bankstart));
  outfile.close();
  
  return EXIT_SUCCESS;
}


