/** BoardInfoLib.h
*  Header defining the LS2160a Board Info implementation specifics 
*
*  Copyright 2018 NXP
*
*  This program and the accompanying materials
*  are licensed and made available under the terms and conditions of the BSD License
*  which accompanies this distribution.  The full text of the license may be found at
*  http://opensource.org/licenses/bsd-license.php
*
*  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
*  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
*
**/

#ifndef __LX2160A_BOARDINFOLIB_H__
#define __LX2160A_BOARDINFOLIB_H__

typedef enum {
  CLK_66,
  CLK_83,
  CLK_100,
  CLK_125,
  CLK_133
} SYSTEM_CLOCK;

/**
   Function to get system clock frequency.
**/
UINTN
GetBoardSysClk (
  VOID
  );

/**
   Function to print board personality.
**/
VOID
PrintBoardPersonality (
  VOID
  );

//SYSCLK
#define SYSCLK_100_MHZ           100000000

#endif // __LS2160A_BOARDINFOLIB_H__
