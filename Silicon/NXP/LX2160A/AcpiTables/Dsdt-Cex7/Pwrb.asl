/** @file
*  Differentiated System Description Table Fields (DSDT)
*  Implement ACPI Power Button
*
*  Copyright 2020 Puresoftware Ltd
*
*  SPDX-License-Identifier: BSD-2-Clause-Patent
*
**/
Scope(_SB) {
  //Generic Event Device
  Device (GED1) {
    Name (_HID, "ACPI0013")
    Name (_UID, 0)

    Name (_CRS, ResourceTemplate () {
      Interrupt(ResourceConsumer, Edge, ActiveHigh,
                ExclusiveAndWake) { GPIO3_IT }
    })

    OperationRegion (PHO, SystemMemory, GPIO3_BASE, GPIO3_LEN)
    Field (PHO, DWordAcc, NoLock, Preserve) { 
      offset(0xc),
      GIER, 32,
      GIMR, 32,
      GICR, 32,
      GBER, 32
    }

    Method (_INI, 0, NotSerialized) {
      Store (PWRBTN_PIN_MASK, GBER)
      Store (PWRBTN_PIN_MASK, GICR)
      Store (PWRBTN_PIN_MASK, GIMR)
      Store (PWRBTN_PIN_MASK, GIER)
    }

    Method (_EVT, 1) {
      If (ToInteger(Arg0) == GPIO3_IT) {
        Store (PWRBTN_PIN_MASK, GIER)
        Notify (\_SB.PWRB, 0x80)   // sleep/off request
      }
    }
  }

  //Power Button
  Device (PWRB) {
    Name (_HID, "PNP0C0C")
    Name (_UID, Zero)
    Method (_STA, 0x0, NotSerialized) {
      Return(0xF)
    }
  }
}
