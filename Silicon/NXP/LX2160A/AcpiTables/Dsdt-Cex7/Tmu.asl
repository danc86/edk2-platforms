/** @file
*  Differentiated System Description Table Fields (DSDT)
*  Implement ACPI Thermal Management
*
*  Copyright 2020 NXP
*  Copyright 2020 Puresoftware Ltd
*  Copyright 2020 SolidRun Ltd.
*
*  SPDX-License-Identifier: BSD-2-Clause-Patent
*
*  Based on the files under Platform/ARM/JunoPkg/AcpiTables/
*
**/

Scope(_SB.I2C0)
{
  Name (SDB0, ResourceTemplate() {
    I2CSerialBus(0x77, ControllerInitiated, 100000, AddressingMode7Bit,
                 "\\_SB.I2C0", 0, ResourceConsumer, ,)
  })

  Name (SDB1, ResourceTemplate() { // SA56004AD temperature sensor
    I2CSerialBus(0x48, ControllerInitiated, 100000, AddressingMode7Bit,
                 "\\_SB.I2C0", 0, ResourceConsumer, ,)
  })

  Name (SDB2, ResourceTemplate() { //fan controller with temp sensor
    I2CSerialBus(0x18, ControllerInitiated, 100000, AddressingMode7Bit,
                 "\\_SB.I2C0", 0, ResourceConsumer, ,)
  })  

  Name (AVBL, Zero)
  // _REG: Region Availability
  Method (_REG, 2, NotSerialized) {
    If (LEqual (Arg0, 0x09)) {
       Store (Arg1, AVBL)
    }
  }

  OperationRegion(OPR1, GenericSerialBus, 0x00, 0x100)
  Field(OPR1, BufferAcc, NoLock, Preserve) {
    Connection(SDB0),                     
    AccessAs (BufferAcc, AttribByte),
    FLD0, 8,                           // Virtual register at command value 0x00 for mux
    Connection(SDB1),                  // sa56004fd remote sensor temperature register offset
    offset(0x01),                      // sa56004fd remote sensor temperature register offset
    AccessAs (BufferAcc, AttribByte),
    FLD1, 8                            // Virtual register at command value 0x01 for sa56004d sensor
  }

  OperationRegion(OPR2, GenericSerialBus, 0x00, 0x100)
  Field(OPR2, BufferAcc, NoLock, Preserve) {
    Connection(SDB2),
    offset(0x00),                      
    AccessAs (BufferAcc, AttribByte),
    FLD2, 8,                           // amc6821 fan config register
    Connection(SDB2),
    offset(0x0b),                      
    AccessAs (BufferAcc, AttribByte),
    FLD3, 8,                          // amc6821 temperature register  
    Connection(SDB2),
    offset(0x22),               
    AccessAs (BufferAcc, AttribByte),
    FLD4, 8                           // amc6821 fan duty cyle setting offset       
  }  


  Name(BUFF, Buffer(34){})
  CreateByteField(BUFF, 0x00, STAT)
  CreateByteField(BUFF, 0x01, LEN)
  CreateByteField(BUFF, 0x02, DATA)

  Method (FSEL, 1, Serialized){
    Switch (Arg0){
      case (0){
        Store(0xd5, DATA) //auto fan mode
      }
      case (1){
        Store(0x95, DATA) //software dcy mode
      }
      Default {
        Store(0x95, DATA)
      }            
    }
    Store(One, LEN)
    Store(BUFF, FLD2) 
    Return (STAT)    
  }

// Method to set pca9547 channel id
  Method (SCHN, 1, Serialized) {
    Switch (Arg0) {
      case (0) {
        Store(0x08, DATA)
      }
      case (1) {
        Store(0x09, DATA)
      }
      case (2) {
        Store(0x0A, DATA)
      }
      case (3) {
        Store(0x0B, DATA)
      }
      case (4) {
        Store(0x0C, DATA)
      }
      case (5) {
        Store(0x0D, DATA)
      }
      case (6) {
        Store(0x0E, DATA)
      }
      case (7) {
        Store(0x0F, DATA)
      }
      Default {
        Store(0x09, DATA)
      }
    }
    Store(One, LEN)
    Store(BUFF, FLD0)
    Return (STAT)
  }

// Method to read temperature from remote sensor
  Method (STMP, 1, Serialized) {
    Store(Zero, Local0)
    If (LEqual (\_SB.I2C0.AVBL, One)) {
      If (LEqual(Arg0, Zero)) {
        SCHN(I2C0_MUX_CHANNEL_1) //FAN CONTROLLER SENSOR
        Store(One, LEN)
        Store(FLD3, BUFF)
      } Else {
        SCHN(I2C0_MUX_CHANNEL_3) //SA56004AD
        Store(One, LEN)
        Store(FLD1, BUFF)
      }
      If (LEqual(STAT, 0x00)) {
        Local0 = DATA
      }
    }
    Return (Local0)
  }

  // Method to get fan status
  Method(FSTA, 1, Serialized) {
    Store(Zero, Local0)
    SCHN(I2C0_MUX_CHANNEL_1)
    Store(One, LEN)
    Store(FLD4, BUFF)
    If (LEqual(STAT, 0x00)) {
      Local0 = DATA
    }
    Return (Local0)
  }

// Method to turn fan OFF
  Method(FOFF, 1, Serialized) {
    SCHN(I2C0_MUX_CHANNEL_1)
    Store(One, LEN)
    Store(TMU_FAN_OFF_SPEED, DATA)
    Store(BUFF, FLD4)
    Return (STAT)
  }

  // Method to turn fan ON at Low speed
  Method(FONL, 1, Serialized) {
    SCHN(I2C0_MUX_CHANNEL_1)
    Store(One, LEN)
    Store(TMU_FAN_LOW_SPEED, DATA)
    Store(BUFF, FLD4)
    Return (STAT)
  }

  // Method to turn fan ON at high speed
  Method(FONH, 1, Serialized) {
    SCHN(I2C0_MUX_CHANNEL_1)
    Store(One, LEN)
    Store(TMU_FAN_HIGH_SPEED, DATA)
    Store(BUFF, FLD4)
    Return (STAT)
  }
}

Scope(_TZ)
{
  // Thermal constant
  Name(TRPP, TMU_PASSIVE_THERSHOLD)
  Name(TRPC, TMU_CRITICAL_THERSHOLD)
  Name(TRP0, TMU_ACTIVE_HIGH_THERSHOLD)
  Name(TRP1, TMU_ACTIVE_LOW_THERSHOLD)
  Name(PLC0, TMU_PASSIVE)
  Name(PLC1, TMU_PASSIVE)
  Name(PLC2, TMU_PASSIVE)
  Name(PLC3, TMU_PASSIVE)
  Name(PLC4, TMU_PASSIVE)
  Name(PLC5, TMU_PASSIVE)
  Name(PLC6, TMU_PASSIVE)
  Name(PLC7, TMU_ACTIVE)
  Name(PLC8, TMU_ACTIVE)

  // TMU hardware registers
  OperationRegion(TMUR, SystemMemory, TMU_BASE, TMU_LEN)
  Field (TMUR, DWordAcc, NoLock, Preserve) {
    TMR,  32,
    TSR,  32,
    TMSR, 32,
    TMIR, 32,
    offset(0x20),
    TIER, 32,
    TIDR, 32,
    offset(0x30),
    TISC, 32,
    ASCR, 32,
    CSCR, 32,
    offset(0x40),
    HTCR, 32,
    LTCR, 32,
    TRCR, 32,
    TFCR, 32,
    TITR, 32,
    TATR, 32,
    ACTR, 32,
    offset(0x60),
    LITR, 32,
    LATR, 32,
    MCTR, 32,
    offset(0x70),
    RCTR, 32,
    FCTR, 32,
    offset(0x80),
    TCFG, 32,
    SCFG, 32,
    offset(0x100),
    ISR0, 32,
    ASR0, 32,
    offset(0x110),
    ISR1, 32,
    ASR1, 32,
    offset(0x120),
    ISR2, 32,
    ASR2, 32,
    offset(0x130),
    ISR3, 32,
    ASR3, 32,
    offset(0x140),
    ISR4, 32,
    ASR4, 32,
    offset(0x150),
    ISR5, 32,
    ASR5, 32,
    offset(0x160),
    ISR6, 32,
    ASR6, 32,
    offset(0x304),
    SAR0, 32,
    offset(0x314),
    SAR1, 32,
    offset(0x324),
    SAR2, 32,
    offset(0x334),
    SAR3, 32,
    offset(0x344),
    SAR4, 32,
    offset(0x354),
    SAR5, 32,
    offset(0x364),
    SAR6, 32,
    offset(0XF00),
    EMR0, 32,
    offset(0xF08),
    EMR1, 32,
    EMR2, 32,
    offset(0xF10),
    TCR0, 32,
    TCR1, 32,
    TCR2, 32,
    TCR3, 32
  }

  // Method to read the sensors current temperature
  Method(GTMP, 1, Serialized) {
    Switch (Arg0) {
      Case (0) {
        Local0 = ISR0
      }
      Case (1) {
        Local0 = ISR1
      }
      Case (2) {
        Local0 = ISR2
      }
      Case (3) {
        Local0 = ISR3
      }
      Case (4) {
        Local0 = ISR4
      }
      Case (5) {
        Local0 = ISR5
      }
      Case (6) {
        Local0 = ISR6
      }
      Default {
        Local0 = ISR0
      } 
    }
    // Adjustment according to the linux kelvin_offset(2732)
    Local0 = Local0 * 10 + 2
    Return (Local0)
  }

// FAN 1 power Resource at low speed
  PowerResource(FN1L, 0, 0) {
    Method (_STA) {
      Store(Zero, Local1)
      If (LEqual (\_SB.I2C0.AVBL, One)) {
        Store(\_SB.I2C0.FSTA(1), Local0)
        If (LGreater(Local0, TMU_FAN_OFF_SPEED)) {
          Store(One, Local1)
        } Else {
          Store(Zero, Local1)
        }
      }
      Return(Local1)
    }
    Method (_ON) {
      If (LEqual (\_SB.I2C0.AVBL, One)) {
        \_SB.I2C0.FONL(TMU_FAN_1)
      }
    }
    Method (_OFF) {
      If (LEqual (\_SB.I2C0.AVBL, One)) {
        \_SB.I2C0.FOFF(TMU_FAN_1)
      }
    }
  }

  // FAN 1 power resources at high speed
  PowerResource(FN1H, 0, 0) {
    Method (_STA) {
      Store(Zero, Local1)
      If (LEqual (\_SB.I2C0.AVBL, One)) {
        Store(\_SB.I2C0.FSTA(1), Local0)
        If (LGreater(Local0, TMU_FAN_LOW_SPEED)) {
          Store(One, Local1)
        } Else {
          Store(Zero, Local1)
        }
      }
      Return(Local1)
    }
    Method (_ON) {
      If (LEqual (\_SB.I2C0.AVBL, One)) {
        \_SB.I2C0.FONH(TMU_FAN_1)
      }
    }
    Method (_OFF) {
      If (LEqual (\_SB.I2C0.AVBL, One)) {
        \_SB.I2C0.FONL(TMU_FAN_1)
      }
    }
  }

  // FAN 0 device object
  Device (FAN0) {
   // Device ID for the FAN
   Name(_HID, EISAID("PNP0C0B"))
   Name(_UID, 0)
   Name(_PR0, Package() { FN1L })
  }

  // FAN 1 device object
  Device (FAN1) {
   // Device ID for the FAN
   Name(_HID, EISAID("PNP0C0B"))
   Name(_UID, 1)
   Name(_PR0, Package() { FN1L, FN1H })
  }

  Device(TMU) {
    Name(_HID, "NXP0012")
    Name(_UID, 0)

    Method(_INI, 0, NotSerialized) {
      // Disable interrupt, using polling instead
      Store(TMU_TIDR_DISABLE_ALL, TIDR)
      Store(TMU_TIER_DISABLE_ALL, TIER)
      // Disable monitoring
      Store(TMU_TMR_DISABLE, TMR)
      // Init temperature range registers
      Store(TMU_TEMP_RANGE_0, TCR0)
      Store(TMU_TEMP_RANGE_1, TCR1)
      // Init TMU configuration Table
      Store(TMU_POINT_0_TEMP_CFG, TCFG)
      Store(TMU_POINT_0_SENSOR_CFG, SCFG)
      Store(TMU_POINT_1_TEMP_CFG, TCFG)
      Store(TMU_POINT_1_SENSOR_CFG, SCFG)
      Store(TMU_ENGINEERING_MODE_0, EMR0)
      Store(TMU_ENGINEERING_MODE_2, EMR2)
      // Set update_interval
      Store(TMU_TMTMIR_DEFAULT, TMIR)
      Store(TMU_SENSOR_READ_ADJUST, SAR0)
      Store(TMU_SENSOR_READ_ADJUST, SAR1)
      Store(TMU_SENSOR_READ_ADJUST, SAR2)
      Store(TMU_SENSOR_READ_ADJUST, SAR3)
      Store(TMU_SENSOR_READ_ADJUST, SAR4)
      Store(TMU_SENSOR_READ_ADJUST, SAR5)
      Store(TMU_SENSOR_READ_ADJUST, SAR6)
      Store(TMU_SENSOR_ENABLE_ALL, TMSR)
      // Enable Monitoring
      Store(TMU_TMR_ENABLE, TMR)

      //Select mode of fan controller
      If (LEqual (\_SB.I2C0.AVBL, One)) {
        \_SB.I2C0.FSEL(1)
      }
    }
  }

  // ThermalZone for core cluster 6,7
  ThermalZone(THM0) {
    Name(_STR, Unicode("system-thermal-zone-0"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)
    // Passive cooling device list
    Name(_PSL, Package() {
      \_SB.CLU6.CP12,
      \_SB.CLU6.CP13,
      \_SB.CLU7.CP14,
      \_SB.CLU7.CP15
    })

    Method(_SCP, 1) {
      If (Arg0) {
        Store(1, PLC0)
      } Else {
        Store(0, PLC0)
      }
      Notify(\_TZ.THM0, 0x81)
    }

    Method(_TMP, 0) {
      Return(GTMP(0))
    }

    Method(_CRT, 0) {
      Return(TRPC)
    }

    Method(_PSV, 0) {
      Return(TRPP)
    }
  }

  // ThermalZone for core cluster 5
  ThermalZone(THM1) {
    Name(_STR, Unicode("system-thermal-zone-1"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)
    // Passive cooling device list
    Name(_PSL, Package() {
      \_SB.CLU5.CP10,
      \_SB.CLU5.CP11
    })

    Method(_SCP, 1) {
      If (Arg0) {
        Store(1, PLC1)
      } Else {
        Store(0, PLC1)
      }
      Notify(\_TZ.THM1, 0x81)
    }

    Method(_TMP, 0) {
      Return(GTMP(1))
    }

    Method(_CRT, 0) {
      Return(TRPC)
    }

    Method(_PSV, 0) {
      Return(TRPP)
    }
  }

  // ThermalZone for WRIOP
  ThermalZone(THM2) {
    Name(_STR, Unicode("system-thermal-zone-2"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)

    Method(_SCP, 1) {
      If (Arg0) {
        Store(1, PLC2)
      } Else {
        Store(0, PLC2)
      }
      Notify(\_TZ.THM1, 0x81)
    }

    Method(_TMP, 0) {
      Return(GTMP(2))
    }

    Method(_CRT, 0) {
      Return(TRPC)
    }

    Method(_PSV, 0) {
      Return(TRPP)
    }
  }

  // ThermalZone for DCE, QBMAN, HSIO3
  ThermalZone(THM3) {
    Name(_STR, Unicode("system-thermal-zone-3"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)

    Method(_SCP, 1) {
      If (Arg0) {
        Store(1, PLC3)
      } Else {
        Store(0, PLC3)
      }
      Notify(\_TZ.THM1, 0x81)
    }

    Method(_TMP, 0) {
      Return(GTMP(3))
    }

    Method(_CRT, 0) {
      Return(TRPC)
    }

    Method(_PSV, 0) {
      Return(TRPP)
    }
  }

  // ThermalZone for CCN508, DPAA, TBU
  ThermalZone(THM4) {
    Name(_STR, Unicode("system-thermal-zone-4"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)

    Method(_SCP, 1) {
      If (Arg0) {
        Store(1, PLC4)
      } Else {
        Store(0, PLC4)
      }
      Notify(\_TZ.THM1, 0x81)
    }

    Method(_TMP, 0) {
      Return(GTMP(4))
    }

    Method(_CRT, 0) {
      Return(TRPC)
    }

    Method(_PSV, 0) {
      Return(TRPP)
    }
  }

  // ThermalZone for core cluster 4
  ThermalZone(THM5) {
    Name(_STR, Unicode("system-thermal-zone-5"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)
    // Passive cooling device list
    Name(_PSL, Package() {
      \_SB.CLU4.CPU8,
      \_SB.CLU4.CPU9,
    })

    Method(_SCP, 1) {
      If (Arg0) {
        Store(1, PLC5)
      } Else {
        Store(0, PLC5)
      }
      Notify(\_TZ.THM2, 0x81)
    }

    Method(_TMP, 0) {
      Return(GTMP(5))
    }

    Method(_CRT, 0) {
      Return(TRPC)
    }

    Method(_PSV, 0) {
      Return(TRPP)
    }
  }

  // ThermalZone for core cluster 2,3
  ThermalZone(THM6) {
    Name(_STR, Unicode("system-thermal-zone-6"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)
    // Passive cooling device list
    Name(_PSL, Package() {
      \_SB.CLU2.CPU4,
      \_SB.CLU2.CPU5,
      \_SB.CLU3.CPU6,
      \_SB.CLU3.CPU7
    })

    Method(_SCP, 1) {
      If (Arg0) {
        Store(1, PLC6)
      } Else {
        Store(0, PLC6)
      }
      Notify(\_TZ.THM3, 0x81)
    }

    Method(_TMP, 0) {
      Return(GTMP(6))
    }

    Method(_CRT, 0) {
      Return(TRPC)
    }

    Method(_PSV, 0) {
      Return(TRPP)
    }
  }

  // ThermalZone for fan temperature sensor
  ThermalZone(THM7) {
    Name(_STR, Unicode("system-thermal-zone-7"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)

    Method(_AC0, 0, Serialized) { Return(TRP0) }
    Method(_AC1, 0, Serialized) { Return(TRP1) }
    Name(_AL0, Package() { FAN1 })
    Name(_AL1, Package() { FAN0 })
    
    Method(_SCP, 1) {
      If (LEqual (\_SB.I2C0.AVBL, One)) {
        \_SB.I2C0.FSEL(1)
        If (Arg0) {
          Store(1, PLC7)
        } Else {
          Store(0, PLC7)
        }
      }
    }

    Method(_TMP, 0, Serialized) {
      Store(\_SB.I2C0.STMP(0), Local0)
      //Adjustment to linux kelvin offset(2732)
      Local0 += 273
      Local0 = Local0 * 10 + 2
      Return (Local0)
    }

    Method(_CRT, 0, Serialized) {
      Return(TRPC)
    }
  }

  // ThermalZone for external sensor 2
  ThermalZone(THM8) {
    Name(_STR, Unicode("system-thermal-zone-8"))
    Name(_TZP, TMU_TZ_POLLING_PERIOD)
    Name(_TSP, TMU_TZ_SAMPLING_PERIOD)
    Name(_TC1, TMU_THERMAL_COFFICIENT_1)
    Name(_TC2, TMU_THERMAL_COFFICIENT_2)

    Method(_TMP, 0, Serialized) {
      Store(\_SB.I2C0.STMP(1), Local0)
      //Adjustment to linux kelvin offset(2732)
      Local0 += 273
      Local0 = Local0 * 10 + 2
      Return (Local0)
    }

    Method(_CRT, 0, Serialized) {
      Return(TRPC)
    }
  }
} //end of Scope _TZ
