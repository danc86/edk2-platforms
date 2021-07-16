#  LX2160aCex7.dsc
#
#  LX2160CEX7 ComExpress Type 7 package.
#
#  Copyright 2018-2020 NXP
#  Copyright 2020 SolidRun Ltd.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  #
  # Defines for default states.  These can be changed on the command line.
  # -D FLAG=VALUE
  #
  PLATFORM_NAME                  = LX2160aCex7
  PLATFORM_GUID                  = 7ebae358-ab16-11ea-bb37-0242ac130002
  OUTPUT_DIRECTORY               = Build/LX2160aCex7
  FLASH_DEFINITION               = Platform/SolidRun/LX2160aCex7/LX2160aCex7.fdf
  DEFINE MC_HIGH_MEM             = TRUE
  DEFINE CAPSULE_ENABLE          = FALSE
  DEFINE X64EMU_ENABLE           = FALSE
  DEFINE AARCH64_GOP_ENABLE      = FALSE
  DEFINE BIFURCATE_PCIE          = FALSE

!ifdef SECURE_BOOT
  DEFINE SECURE_BOOT_ENABLE      = TRUE
!else
  DEFINE SECURE_BOOT_ENABLE      = FALSE
!endif

  #
  # Network definition
  #
  DEFINE NETWORK_TLS_ENABLE             = TRUE
  DEFINE NETWORK_HTTP_BOOT_ENABLE       = TRUE
  DEFINE NETWORK_ISCSI_ENABLE           = TRUE

!include Platform/NXP/NxpQoriqLs.dsc
!include Silicon/NXP/Chassis/Chassis3V2/Chassis3V2.dsc
!include Silicon/NXP/LX2160A/LX2160A.dsc
!include MdePkg/MdeLibs.dsc.inc

[LibraryClasses.common]
  TpmMeasurementLib|SecurityPkg/Library/DxeTpmMeasurementLib/DxeTpmMeasurementLib.inf
  ArmPlatformLib|Platform/SolidRun/LX2160aCex7/Library/PlatformLib/ArmPlatformLib.inf
  ResetSystemLib|ArmPkg/Library/ArmSmcPsciResetSystemLib/ArmSmcPsciResetSystemLib.inf
  PL011UartLib|ArmPlatformPkg/Library/PL011UartLib/PL011UartLib.inf
  PL011UartClockLib|Silicon/NXP/Library/PL011UartClockLib/PL011UartClockLib.inf
  SerialPortLib|ArmPlatformPkg/Library/PL011SerialPortLib/PL011SerialPortLib.inf
  SocLib|Silicon/NXP/Chassis/LX2160aSocLib.inf
  BoardInfoLib|Platform/SolidRun/LX2160aCex7/Library/BoardInfoLib/BoardInfoLib.inf
  PciSegmentLib|Silicon/NXP/Library/PciSegmentLib/PciSegmentLib.inf
  PciHostBridgeLib|Silicon/NXP/Library/PciHostBridgeLib/PciHostBridgeLib.inf
  MmcLib|Silicon/NXP/Library/MmcLib/MmcLib.inf
  ItbParseLib|Silicon/NXP/Library/ItbParseLib/ItbParse.inf
  Dpaa2BoardSpecificLib|Platform/SolidRun/LX2160aCex7/Library/Dpaa2BoardSpecificLib/Dpaa2BoardSpecificLib.inf
  Dpaa2EthernetMacLib|Silicon/NXP/Library/Dpaa2EthernetMacLib/Dpaa2EthernetMacLib.inf
  Dpaa2EthernetPhyLib|Silicon/NXP/Library/Dpaa2EthernetPhyLib/Dpaa2EthernetPhyLib.inf
  Dpaa2ManagementComplexLib|Silicon/NXP/Library/Dpaa2ManagementComplexLib/Dpaa2ManagementComplexLib.inf
  Dpaa2McInterfaceLib|Silicon/NXP/Library/Dpaa2McInterfaceLib/Dpaa2McInterfaceLib.inf
  SecureMonRngLib|Silicon/NXP/Library/SecureMonRngLib/SecureMonRngLib.inf
  MemoryInitPeiLib|Silicon/NXP/Library/MemoryInitPei/MemoryInitPeiLib.inf
  UefiUsbLib|MdePkg/Library/UefiUsbLib/UefiUsbLib.inf

  BaseCryptLib|CryptoPkg/Library/BaseCryptLib/BaseCryptLib.inf
  OpensslLib|CryptoPkg/Library/OpensslLib/OpensslLib.inf
!if $(NETWORK_TLS_ENABLE) == TRUE
  TlsLib|CryptoPkg/Library/TlsLib/TlsLib.inf
  IntrinsicLib|CryptoPkg/Library/IntrinsicLib/IntrinsicLib.inf
!endif

!if $(BIFURCATE_PCIE) == TRUE
[BuildOptions]
  GCC:*_*_*_CC_FLAGS          = -DBIFURCATE_PCIE
  GCC:*_*_*_PP_FLAGS          = -DBIFURCATE_PCIE
  GCC:*_*_*_ASLPP_FLAGS       = -DBIFURCATE_PCIE
  GCC:*_*_*_ASLCC_FLAGS       = -DBIFURCATE_PCIE
  GCC:*_*_*_VFRPP_FLAGS       = -DBIFURCATE_PCIE
!endif

[PcdsFeatureFlag.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdInstallAcpiSdtProtocol|TRUE
!if $(SECURE_BOOT_ENABLE) == TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdEnableVariableRuntimeCache|FALSE
!else
  gEfiMdeModulePkgTokenSpaceGuid.PcdEnableVariableRuntimeCache|TRUE
!endif


[PcdsDynamicDefault.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|0
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|0
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|1024
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|768
  gEmbeddedTokenSpaceGuid.PcdDefaultDtPref|FALSE

[PcdsFixedAtBuild.common]
  # Hex value of degrees Kelvin.  (( Value - 2 ) / 10 ) - 273
  gNxpQoriqLsTokenSpaceGuid.PcdTmuActiveTempLow|0xCA0  # 50C
  gNxpQoriqLsTokenSpaceGuid.PcdTmuActiveTempHigh|0xD35 # 64C
  gNxpQoriqLsTokenSpaceGuid.PcdTmuActiveTempFull|0xDCC # 80C

  # Hex value of PWM Duty, 0 - 255, Value / 255 * 100
  gNxpQoriqLsTokenSpaceGuid.PcdTmuFanSpeedDefault|0x72 # 45%
  gNxpQoriqLsTokenSpaceGuid.PcdTmuFanSpeedLow|0x9A     # 60%
  gNxpQoriqLsTokenSpaceGuid.PcdTmuFanSpeedHigh|0xCC    # 80%

!if $(MC_HIGH_MEM) == TRUE                                        # Management Complex loaded at the end of DDR2
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2McHighRamSize|0x20000000      # 2GB (must be 512MB aligned)
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2McLowRamSize|0x0
  gNxpQoriqLsTokenSpaceGuid.PcdMcHighMemSupport|1
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x0080000000             # Actual base
  gArmTokenSpaceGuid.PcdSystemMemorySize|0x007BE00000             # 2G - 66MB (ATF)
!else
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2McHighRamSize|0x0             # 512MB (Fixed)
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2McLowRamSize|0x20000000       # 512MB (Fixed)
  gNxpQoriqLsTokenSpaceGuid.PcdMcHighMemSupport|0
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x0080000000
  gArmTokenSpaceGuid.PcdSystemMemorySize|0x0040000000             # 2G - 512MB - 66MB (ATF), 512 MB aligned
!endif
  gArmPlatformTokenSpaceGuid.PcdSystemMemoryUefiRegionSize|0x04000000
  gEfiSecurityPkgTokenSpaceGuid.PcdOptionRomImageVerificationPolicy|0x00000004
  gEfiMdeModulePkgTokenSpaceGuid.PcdImageProtectionPolicy|0x3
  #
  # Enable NX memory protection for all non-code regions, including OEM and OS
  # reserved ones, with the exception of LoaderData regions, of which OS loaders
  # (i.e., GRUB) may assume that its contents are executable.
  #
  gEfiMdeModulePkgTokenSpaceGuid.PcdDxeNxMemoryProtectionPolicy|0xC000000000007FD1
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetNxForStack|TRUE

  gEfiMdeModulePkgTokenSpaceGuid.PcdFirmwareVersionString|L"202105"
  gEfiMdeModulePkgTokenSpaceGuid.PcdFirmwareRevision|$(BUILD_NUMBER)

  #
  # SMBIOS entry point version
  #
  gEfiMdeModulePkgTokenSpaceGuid.PcdSmbiosVersion|0x0302
  gEfiMdeModulePkgTokenSpaceGuid.PcdSmbiosEntryPointProvideMethod|0x2
  gEfiMdeModulePkgTokenSpaceGuid.PcdSmbiosDocRev|0x0

  gEfiMdeModulePkgTokenSpaceGuid.PcdAcpiExposedTableVersions|0x20

  #
  # Board Specific Pcds
  #

  gNxpQoriqLsTokenSpaceGuid.PcdIn112525FwNorBaseAddr|0x20980000
  gNxpQoriqLsTokenSpaceGuid.PcdIn112525FwSize|0x40000

  # ARM SBSA WDT
  gArmTokenSpaceGuid.PcdGenericWatchdogControlBase|0x23A0000
  gArmTokenSpaceGuid.PcdGenericWatchdogRefreshBase|0x2390000
  gArmTokenSpaceGuid.PcdGenericWatchdogEl2IntrNum|91

  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterBase|0x21C0000
  gArmPlatformTokenSpaceGuid.PcdSerialDbgRegisterBase|0x21D0000
  gArmPlatformTokenSpaceGuid.PL011UartClkInHz|175000000
  gNxpQoriqLsTokenSpaceGuid.PcdSerdes2Enabled|TRUE
  gNxpQoriqLsTokenSpaceGuid.PcdPlatformFreqDiv|0x4
  gNxpQoriqLsTokenSpaceGuid.PcdDdrClk|100000000

  #
  # RTC Pcds
  #
  gNxpQoriqLsTokenSpaceGuid.PcdI2cBus|4
  gNxpQoriqLsTokenSpaceGuid.PcdI2cSpeed|100000
  gNxpQoriqLsTokenSpaceGuid.PcdI2cSlaveAddress|0x51

  gNxpQoriqLsTokenSpaceGuid.PcdSysEepromI2cBus|0
  gNxpQoriqLsTokenSpaceGuid.PcdSysEepromI2cAddress|0x57

  #
  # NV Storage PCDs.
  #
  gArmTokenSpaceGuid.PcdVFPEnabled|1

  #
  # PCI PCDs.
  #
  gNxpQoriqLsTokenSpaceGuid.PcdPciDebug|FALSE
  gNxpQoriqLsTokenSpaceGuid.PcdPcieLutBase|0x80000
  gNxpQoriqLsTokenSpaceGuid.PcdPcieLutDbg|0x407FC
  gNxpQoriqLsTokenSpaceGuid.PcdPcieExp1SysAddr|0x3400000
  gNxpQoriqLsTokenSpaceGuid.PcdPcieExp2SysAddr|0x3500000
  gNxpQoriqLsTokenSpaceGuid.PcdPcieExp3SysAddr|0x3600000
  gNxpQoriqLsTokenSpaceGuid.PcdPcieExp4SysAddr|0x3700000
  gNxpQoriqLsTokenSpaceGuid.PcdPcieExp5SysAddr|0x3800000
  gNxpQoriqLsTokenSpaceGuid.PcdPcieExp6SysAddr|0x3900000

  #
  # SATA Pcds
  #
  gNxpQoriqLsTokenSpaceGuid.PcdSataErratumA009185|TRUE

  #
  # DPAA2 Pcds
  #
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2Initialize|TRUE
  gNxpQoriqLsTokenSpaceGuid.PcdDisableMcLogging|FALSE
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2McFwSrc|0x02
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2McBootTimeoutMs|200000
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2UsedDpmacsMask|0xff00ff
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2McLogMcDramOffset|0x1000000

  # Valid values for PcdDpaa2McLogLevel:
  # - 0x01: LOG_LEVEL_DEBUG
  # - 0x02: LOG_LEVEL_INFO
  # - 0x03: LOG_LEVEL_WARNING
  # - 0x04: LOG_LEVEL_ERROR
  # - 0x05: LOG_LEVEL_CRITICAL
  # - 0x06: LOG_LEVEL_ASSERT
  # - 0xFF: LOG_LEVEL_DEFAULT (default from DPC)
  gNxpQoriqLsTokenSpaceGuid.PcdDpaa2McLogLevel|0xff

  # Valid values for PcdDpaaDebugFlags:
  # - 0x0      DPAA debug logs are disabled.
  # - 0x1      Enable DPAA debugging messages
  # - 0x2      Dump values of RAM words or registers
  # - 0x4      Trace commands sent to the MC
  # - 0x8      Dump MC log fragment
  # - 0x10     Dump contents of the root DPRC
  # - 0x20     Perform extra checks
  # - 0x40     Trace network packets sent/received
  gNxpQoriqLsTokenSpaceGuid.PcdDpaaDebugFlags|0x0

  # gNxpQoriqLsTokenSpaceGuid.PcdFdtAddress|0x20F00000
################################################################################
#
# Components Section - list of all EDK II Modules needed by this Platform
#
################################################################################
[Components.common]
  #
  # Architectural Protocols
  #
!if $(SECURE_BOOT_ENABLE) == TRUE
  ArmPkg/Drivers/MmCommunicationOpteeDxe/MmCommunication.inf {
    <LibraryClasses>
      OpteeLib|ArmPkg/Library/OpteeLib/OpteeLib.inf
      NULL|StandaloneMmPkg/Library/VariableMmDependency/VariableMmDependency.inf
      DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
  }
  MdeModulePkg/Universal/Variable/RuntimeDxe/VariableSmmRuntimeDxe.inf {
    <LibraryClasses>
      MmUnblockMemoryLib|MdePkg/Library/MmUnblockMemoryLib/MmUnblockMemoryLibNull.inf
      DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
  }
!else
  MdeModulePkg/Universal/FaultTolerantWriteDxe/FaultTolerantWriteDxe.inf
  MdeModulePkg/Universal/Variable/RuntimeDxe/VariableRuntimeDxe.inf{
    <LibraryClasses>
      NULL|EmbeddedPkg/Library/NvVarStoreFormattedLib/NvVarStoreFormattedLib.inf
      AuthVariableLib|MdeModulePkg/Library/AuthVariableLibNull/AuthVariableLibNull.inf
      NULL|MdeModulePkg/Library/VarCheckUefiLib/VarCheckUefiLib.inf
      VarCheckLib|MdeModulePkg/Library/VarCheckLib/VarCheckLib.inf
  }
!endif

  ArmPkg/Drivers/GenericWatchdogDxe/GenericWatchdogDxe.inf
  Silicon/NXP/Drivers/I2cDxe/I2cDxe.inf

  EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf {
    <LibraryClasses>
!if $(SECURE_BOOT_ENABLE) == TRUE
      RealTimeClockLib|Silicon/NXP/Library/Pcf2129RtcMmLib/Pcf2129RtcLib.inf
!else
      RealTimeClockLib|Silicon/NXP/Library/Pcf2129RtcLib/Pcf2129RtcLib.inf
!endif
      DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
  }
  Silicon/NXP/Drivers/UsbHcdInitDxe/UsbHcd.inf
  Silicon/NXP/Drivers/PciCpuIo2Dxe/PciCpuIo2Dxe.inf
  MdeModulePkg/Bus/Pci/PciHostBridgeDxe/PciHostBridgeDxe.inf {
    <PcdsFixedAtBuild>
      gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x8010004F
  }
  MdeModulePkg/Bus/Pci/PciBusDxe/PciBusDxe.inf
  MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
  MdeModulePkg/Bus/Usb/UsbKbDxe/UsbKbDxe.inf

  #
  # Networking stack
  #
!include NetworkPkg/Network.dsc.inc

  Silicon/NXP/Drivers/SataInitDxe/SataInitDxe.inf
  Silicon/NXP/Drivers/MmcHostDxe/MmcHostDxe.inf
  Silicon/NXP/Drivers/Dpaa2EthernetDxe/Dpaa2EthernetDxe.inf
  Silicon/NXP/Drivers/RngDxe/RngDxe.inf

  # Platform DXE Driver
  Silicon/NXP/Drivers/PlatformDxe/PlatformDxe.inf

  #
  # DT support
  #
  Platform/SolidRun/LX2160aCex7/DeviceTree/DeviceTree.inf

  Silicon/NXP/Drivers/DtInitDxe/DtInitDxe.inf {
    <LibraryClasses>
      FdtLib|EmbeddedPkg/Library/FdtLib/FdtLib.inf
      DtPlatformDtbLoaderLib|Silicon/NXP/Library/DtbLoaderLib/DtbLoaderLib.inf
  }
  EmbeddedPkg/Drivers/DtPlatformDxe/DtPlatformDxe.inf {
    <LibraryClasses>
      FdtLib|EmbeddedPkg/Library/FdtLib/FdtLib.inf
      DtPlatformDtbLoaderLib|Silicon/NXP/Library/DtbLoaderLib/DtbLoaderLib.inf
  }

  Silicon/NXP/Drivers/FlexSpiDxe/FspiDxe.inf
  Silicon/NXP/Drivers/SpiBusDxe/SpiBusDxe.inf
  Silicon/NXP/Drivers/SpiNorFlashDxe/SpiNorFlashDxe.inf
  Silicon/NXP/Drivers/SpiConfigurationDxe/SpiConfigurationDxe.inf

  #
  # Acpi Support
  #
  Silicon/NXP/Drivers/NxpAcpiPlatformDxe/AcpiPlatformDxe.inf

  #
  # Platform
  #
  Silicon/NXP/LX2160A/AcpiTables/LX2160aCex7.inf
  Silicon/NXP/LX2160A/AcpiTables/Icid.inf

 #
 #SMBIOS
 #
 MdeModulePkg/Universal/SmbiosDxe/SmbiosDxe.inf
 Platform/SolidRun/LX2160aCex7/SmbiosPlatformDxe/SmbiosPlatformDxe.inf

!if $(CAPSULE_ENABLE)
  #
  # Firmware update
  #
  Platform/SolidRun/LX2160aCex7/SystemFirmwareDescriptor/SystemFirmwareDescriptor.inf
!endif #$(CAPSULE_ENABLE)

  MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
  MdeModulePkg/Universal/Disk/RamDiskDxe/RamDiskDxe.inf
  EmbeddedPkg/Drivers/ConsolePrefDxe/ConsolePrefDxe.inf
  MdeModulePkg/Application/BootManagerMenuApp/BootManagerMenuApp.inf

  Platform/SolidRun/LX2160aCex7/Logo/LogoDxe.inf
  MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.inf

 #
 # GOP Support
 #
 Silicon/AMD/AMDGop/AMDGop.inf

 #
 # X86 Emulation Support
 #
 Emulator/X86EmulatorDxe/X86EmulatorDxe.inf
 ##
 ##
