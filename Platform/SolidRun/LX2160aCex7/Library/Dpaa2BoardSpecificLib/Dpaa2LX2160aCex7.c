/** Dpaa2LX2160aCex7.c
  DPAA2 definitions specific for the LX2160aCex7 based boards

  Copyright 2017-2018 NXP

  This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution. The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#include <Library/Dpaa2BoardSpecificLib.h>
#include <Library/Dpaa2EthernetMacLib.h>
#include <Library/Dpaa2EthernetPhyLib.h>
#include <Library/DpaaDebugLib.h>

/**
 * Mapping of WRIOP DPMACs to Ethernet PHYs
 */
typedef struct _DPMAC_PHY_MAPPING {
  /**
   * Pointer to the MDIO bus that connects a DPMAC to a PHY
   */
  DPAA2_PHY_MDIO_BUS *MdioBus;

  /**
   * PHY address of the associated PHY
   */
  UINT8 PhyAddress;

  /**
   * PHY media type:
   */
  PHY_MEDIA_TYPE PhyMediaType;

  /**
   * PHY Id of the associated PHY
   */
  UINT8 PhyId;
} DPMAC_PHY_MAPPING;

/**
 * PHY MDIO buses
 */
DPAA2_PHY_MDIO_BUS gDpaa2MdioBuses[] = {
  [0] = {
    .Signature = DPAA2_PHY_MDIO_BUS_SIGNATURE,
    .IoRegs = (MEMAC_MDIO_BUS_REGS *)DPAA2_WRIOP1_MDIO1_ADDR,
  },

  [1] = {
    .Signature = DPAA2_PHY_MDIO_BUS_SIGNATURE,
    .IoRegs = (MEMAC_MDIO_BUS_REGS *)DPAA2_WRIOP1_MDIO2_ADDR,
  },
};

/**
 * Table of mappings of WRIOP DPMACs to PHYs
 */
// 17 for rgmii

static const DPMAC_PHY_MAPPING gDpmacToPhyMap[] = {
  [WRIOP_DPMAC17] = {
    .MdioBus = &gDpaa2MdioBuses[0],
    .PhyAddress = QC_PHY_ADDR1,
    .PhyMediaType = COPPER_PHY,
    .PhyId        = QC_PHY,
  },
};

VOID ProbeDpaaLanes (
  VOID *Arg
  )
{
  WRIOP_DPMAC_ID DpmacId = WRIOP_DPMAC17;
  // Init AR8035 Phy via RGMII 
  WriopDpmacInit (DpmacId,
                 PHY_INTERFACE_RGMII,
                 gDpmacToPhyMap[DpmacId].MdioBus,
                 gDpmacToPhyMap[DpmacId].PhyAddress,
                 gDpmacToPhyMap[DpmacId].PhyMediaType,
                 gDpmacToPhyMap[DpmacId].PhyId,
                 Arg);
}

