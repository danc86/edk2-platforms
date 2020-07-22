/** @file
  Differentiated System Description Table Fields (DSDT)

  Copyright 2019-2020 NXP
  SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#include <AcpiTablesInclude/Dsdt/Mc.asl>

Scope(\_SB.MCE0.PR07) // 10G
{
  Name (_DSD, Package () {
    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
            Package () {"reg", 7},
            Package () {"managed", "in-band-status"},
    }
  })
}

Scope(\_SB.MCE0.PR08) // 10G
{
  Name (_DSD, Package () {
    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
            Package () {"reg", 8},
            Package () {"managed", "in-band-status"},
    }
  })
}

Scope(\_SB.MCE0.PR09) // 10G
{
  Name (_DSD, Package () {
    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
            Package () {"reg", 8},
            Package () {"managed", "in-band-status"},
    }
  })
}

Scope(\_SB.MCE0.PR10) // 10G
{
  Name (_DSD, Package () {
    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
            Package () {"reg", 10},
            Package () {"managed", "in-band-status"},
     }
  })
}

Scope(\_SB.MCE0.PR17) // 1G
{
  Name (_DSD, Package () {
     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
         Package () {
             Package () {"reg", 17},
             Package () {"phy-connection-type", "rgmii-id"},
             Package () {"phy-mode", "rgmii-id"},
             Package () {"phy-handle", Package (){\_SB.MDI0.PHY1}}
      }
   })
}
