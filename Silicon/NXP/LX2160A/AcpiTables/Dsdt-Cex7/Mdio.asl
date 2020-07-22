/** @file
  Differentiated System Description Table Fields (DSDT)

  Copyright 2019-2020 NXP
  SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#include <AcpiTablesInclude/Dsdt/Mdio.asl>

Scope(\_SB.MDI0)
{
  Device(PHY1) {
    Name (_ADR, 0x1)
    Name (_UID, 0x1)
    Name (_DSD, Package () {
      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
      Package () {
        Package (2) {"phy-channel", 1},
        Package (2) {"compatible", "ethernet-phy-id004d.d072"}
      }
    })
  } // end of PHY1
} // end of MDI0
