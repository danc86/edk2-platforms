/** Dpaa2EthernetPhyPrivate.h
  DPAA2 Ethernet PHY private common declarations

  Copyright 2017 NXP

  This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution. The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#ifndef __DPAA2_ETHERNET_PHY_PRIVATE_H__
#define __DPAA2_ETHERNET_PHY_PRIVATE_H__

#include <Library/Dpaa2EthernetMacLib.h>
#include <Library/Dpaa2EthernetPhyLib.h>
#include <Library/PhyCommon.h>
#include <Uefi.h>

/*
 * MDIO Device Address
 */
#define MDIO_PHY_DEV_ADDR               0

/*
 * MDIO control device addresses
 */
#define MDIO_CTL_DEVAD_NONE             (-1)

/**
 * Physical Medium Attachment/Physical Medium Dependent
 */
#define MDIO_CTL_DEV_PMAPMD             1

/**
 * Auto-Negotiation
 */
#define MDIO_CTL_DEV_AUTO_NEGOTIATION   7

/**
 * PHY control register
 */
#define PHY_CONTROL_REG      0x00

/*
 * Fields of the PHY control register
 */
#define PHY_CONTROL_RESET   0x8000

/**
 * PHY status register
 */
#define PHY_STATUS_REG      0x01

/*
 * Fields of the PHY status register
 */
#define PHY_STATUS_LINK_STATUS                  0x0004
#define PHY_STATUS_AUTO_NEGOTIATION_COMPLETE    0x0020

/**
 * PHY autonegotiation timeout (milliseconds)
 */
#define PHY_AUTO_NEGOTIATION_TIMEOUT  300

VOID
Dpaa2PhyRegisterWrite (
  IN DPAA2_PHY *Dpaa2Phy,
  IN INT8      MdioCtlDevAddr,
  IN UINT16    PhyRegNum,
  IN UINT16    Value
  );

UINT16
Dpaa2PhyRegisterRead (
  IN DPAA2_PHY *Dpaa2Phy,
  IN INT8      MdioCtlDevAddr,
  IN UINT16    PhyRegNum
  );

EFI_STATUS
AquantiaPhyConfig (
  DPAA2_PHY *Dpaa2Phy
  );

EFI_STATUS
AquantiaPhyStartup (
  DPAA2_PHY *Dpaa2Phy
  );

EFI_STATUS
CortinaPhyConfig (
  DPAA2_PHY *Dpaa2Phy
  );

EFI_STATUS
CortinaPhyStartup (
  DPAA2_PHY *Dpaa2Phy
  );

EFI_STATUS
Ar8035PhyConfig (
  DPAA2_PHY *Dpaa2Phy
  );

EFI_STATUS
Ar8035PhyStartup (
  DPAA2_PHY *Dpaa2Phy
  );

UINT32
Dpaa2PhyReadMmdIndirect (
  IN  DPAA2_PHY *Dpaa2Phy,
  IN  UINT32    PortAddr,
  IN  UINT32    DevAddr,
  IN  INT8      Addr
  );

VOID
Dpaa2PhyWriteMmdIndirect (
  IN  DPAA2_PHY *Dpaa2Phy,
  IN  UINT32    PortAddr,
  IN  UINT32    DevAddr,
  IN  INT8      Addr,
  IN  UINT32    Data
  );

CHAR8 *
FindNextSeparator (
  CHAR8 *Str
  );

CHAR8 *
SkipSeparators (
  CHAR8 *Str
  );

EFI_STATUS
In112525S03PhyConfig (
  DPAA2_PHY *Dpaa2Phy
  );

EFI_STATUS
In112525S03PhyStartup (
  DPAA2_PHY *Dpaa2Phy
  );

#endif /* __DPAA2_ETHERNET_PHY_PRIVATE_H__ */

