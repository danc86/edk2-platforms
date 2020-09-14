/** @file
  Differentiated System Description Table Fields (DSDT)

  Copyright (c) 2014, ARM Ltd. All rights reserved.<BR>
  Copyright (c) 2015, Linaro Limited. All rights reserved.<BR>
  Copyright 2017-2020 NXP
  Copyright 2020 Puresoftware Ltd

  SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#include "Platform-Cex7.h"

DefinitionBlock("DsdtTable.aml", "DSDT", 2, "NXP  ", "LX2160  ", EFI_ACPI_ARM_OEM_REVISION) {
  include ("Com.asl")
  include ("../Dsdt/CPU.asl")
  include ("Clk.asl")
  include ("../Dsdt/Esdhc.asl")
  include ("../Dsdt/FSPI.asl")
  include ("../Dsdt/Ftm.asl")
  include ("Guts.asl")
  include ("I2c.asl")
  include ("Mc.asl")
  include ("Mdio.asl")
  include ("../Dsdt/Pci.asl")
  include ("Pwrb.asl")
  include ("../Dsdt/Rcpm.asl")
  include ("../Dsdt/Sata.asl")
  include ("../Dsdt/SPI.asl")
  include ("Tmu.asl")
  include ("../Dsdt/Usb.asl")
}
