#change PLATFORM_NAME, OUTPUT_DIRECTORY, [Components] section

[Defines]
  PLATFORM_NAME                  = UefiLogInAppPkg
  PLATFORM_GUID                  = F4B23A83-3009-4DEE-8113-BE7B62FCA9AA
  PLATFORM_VERSION               = 1.0
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/UefiLogInAppPkg
  SUPPORTED_ARCHITECTURES        = X64
  BUILD_TARGETS                  = DEBUG|RELEASE
  SKUID_IDENTIFIER               = DEFAULT

[LibraryClasses]
  RegisterFilterLib|MdePkg/Library/RegisterFilterLibNull/RegisterFilterLibNull.inf
  #
  # Entry point
  #
  PeiCoreEntryPoint|MdePkg/Library/PeiCoreEntryPoint/PeiCoreEntryPoint.inf
  PeimEntryPoint|MdePkg/Library/PeimEntryPoint/PeimEntryPoint.inf
  DxeCoreEntryPoint|MdePkg/Library/DxeCoreEntryPoint/DxeCoreEntryPoint.inf
  UefiDriverEntryPoint|MdePkg/Library/UefiDriverEntryPoint/UefiDriverEntryPoint.inf
  UefiApplicationEntryPoint|MdePkg/Library/UefiApplicationEntryPoint/UefiApplicationEntryPoint.inf

  #
  # Basic
  #
  BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
  BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf  # <--- FIXED THIS
  SynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
  PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
  IoLib|MdePkg/Library/BaseIoLibIntrinsic/BaseIoLibIntrinsic.inf
  PciLib|MdePkg/Library/BasePciLibCf8/BasePciLibCf8.inf
  PciCf8Lib|MdePkg/Library/BasePciCf8Lib/BasePciCf8Lib.inf
  PciSegmentLib|MdePkg/Library/BasePciSegmentLibPci/BasePciSegmentLibPci.inf
  CacheMaintenanceLib|MdePkg/Library/BaseCacheMaintenanceLib/BaseCacheMaintenanceLib.inf
  PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf
  PeCoffGetEntryPointLib|MdePkg/Library/BasePeCoffGetEntryPointLib/BasePeCoffGetEntryPointLib.inf
  SortLib|MdeModulePkg/Library/BaseSortLib/BaseSortLib.inf
  GptLib|MdeModulePkg/Library/GptLib/GptLib.inf

  #
  # UEFI & PI
  #
  UefiBootServicesTableLib|MdePkg/Library/UefiBootServicesTableLib/UefiBootServicesTableLib.inf
  UefiRuntimeServicesTableLib|MdePkg/Library/UefiRuntimeServicesTableLib/UefiRuntimeServicesTableLib.inf
  UefiRuntimeLib|MdePkg/Library/UefiRuntimeLib/UefiRuntimeLib.inf
  UefiLib|MdePkg/Library/UefiLib/UefiLib.inf
  UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf
  HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf
  DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf
  UefiDecompressLib|MdePkg/Library/BaseUefiDecompressLib/BaseUefiDecompressLib.inf
  PeiServicesTablePointerLib|MdePkg/Library/PeiServicesTablePointerLib/PeiServicesTablePointerLib.inf
  PeiServicesLib|MdePkg/Library/PeiServicesLib/PeiServicesLib.inf
  DxeServicesLib|MdePkg/Library/DxeServicesLib/DxeServicesLib.inf
  DxeServicesTableLib|MdePkg/Library/DxeServicesTableLib/DxeServicesTableLib.inf
  UefiBootManagerLib|MdeModulePkg/Library/UefiBootManagerLib/UefiBootManagerLib.inf
  VariablePolicyLib|MdeModulePkg/Library/VariablePolicyLib/VariablePolicyLib.inf

  #
  # Generic Modules & Misc
  #
  UefiUsbLib|MdePkg/Library/UefiUsbLib/UefiUsbLib.inf
  UefiScsiLib|MdePkg/Library/UefiScsiLib/UefiScsiLib.inf
  SecurityManagementLib|MdeModulePkg/Library/DxeSecurityManagementLib/DxeSecurityManagementLib.inf
  SerialPortLib|MdePkg/Library/BaseSerialPortLibNull/BaseSerialPortLibNull.inf
  CapsuleLib|MdeModulePkg/Library/DxeCapsuleLibNull/DxeCapsuleLibNull.inf
  PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
  CustomizedDisplayLib|MdeModulePkg/Library/CustomizedDisplayLib/CustomizedDisplayLib.inf
  FrameBufferBltLib|MdeModulePkg/Library/FrameBufferBltLib/FrameBufferBltLib.inf
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
  DebugPrintErrorLevelLib|MdePkg/Library/BaseDebugPrintErrorLevelLib/BaseDebugPrintErrorLevelLib.inf
  ReportStatusCodeLib|MdePkg/Library/BaseReportStatusCodeLibNull/BaseReportStatusCodeLibNull.inf
  PeCoffExtraActionLib|MdePkg/Library/BasePeCoffExtraActionLibNull/BasePeCoffExtraActionLibNull.inf
  PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
  DebugAgentLib|MdeModulePkg/Library/DebugAgentLibNull/DebugAgentLibNull.inf
  PlatformHookLib|MdeModulePkg/Library/BasePlatformHookLibNull/BasePlatformHookLibNull.inf
  ResetSystemLib|MdeModulePkg/Library/BaseResetSystemLibNull/BaseResetSystemLibNull.inf
  SmbusLib|MdePkg/Library/DxeSmbusLib/DxeSmbusLib.inf
  S3BootScriptLib|MdeModulePkg/Library/PiDxeS3BootScriptLib/DxeS3BootScriptLib.inf
  CpuExceptionHandlerLib|MdeModulePkg/Library/CpuExceptionHandlerLibNull/CpuExceptionHandlerLibNull.inf
  PlatformBootManagerLib|MdeModulePkg/Library/PlatformBootManagerLibNull/PlatformBootManagerLibNull.inf
  PciHostBridgeLib|MdeModulePkg/Library/PciHostBridgeLibNull/PciHostBridgeLibNull.inf
  AuthVariableLib|MdeModulePkg/Library/AuthVariableLibNull/AuthVariableLibNull.inf
  VarCheckLib|MdeModulePkg/Library/VarCheckLib/VarCheckLib.inf
  FileExplorerLib|MdeModulePkg/Library/FileExplorerLib/FileExplorerLib.inf
  NonDiscoverableDeviceRegistrationLib|MdeModulePkg/Library/NonDiscoverableDeviceRegistrationLib/NonDiscoverableDeviceRegistrationLib.inf
  ImagePropertiesRecordLib|MdeModulePkg/Library/ImagePropertiesRecordLib/ImagePropertiesRecordLib.inf
  FmpAuthenticationLib|MdeModulePkg/Library/FmpAuthenticationLibNull/FmpAuthenticationLibNull.inf
  BmpSupportLib|MdeModulePkg/Library/BaseBmpSupportLib/BaseBmpSupportLib.inf
  SafeIntLib|MdePkg/Library/BaseSafeIntLib/BaseSafeIntLib.inf
  DisplayUpdateProgressLib|MdeModulePkg/Library/DisplayUpdateProgressLibGraphics/DisplayUpdateProgressLibGraphics.inf
  VariablePolicyHelperLib|MdeModulePkg/Library/VariablePolicyHelperLib/VariablePolicyHelperLib.inf
  MmUnblockMemoryLib|MdePkg/Library/MmUnblockMemoryLib/MmUnblockMemoryLibNull.inf
  VariableFlashInfoLib|MdeModulePkg/Library/BaseVariableFlashInfoLib/BaseVariableFlashInfoLib.inf
  IpmiCommandLib|MdeModulePkg/Library/BaseIpmiCommandLibNull/BaseIpmiCommandLibNull.inf
  SpiHcPlatformLib|MdeModulePkg/Library/BaseSpiHcPlatformLibNull/BaseSpiHcPlatformLibNull.inf
  TpmMeasurementLib|MdeModulePkg/Library/TpmMeasurementLibNull/TpmMeasurementLibNull.inf
  TdxMeasurementLib|MdeModulePkg/Library/TdxMeasurementLibNull/TdxMeasurementLibNull.inf
  RngLib|MdePkg/Library/BaseRngLib/BaseRngLib.inf

  #
  # Crypto
  #
  BaseCryptLib|CryptoPkg/Library/BaseCryptLib/BaseCryptLib.inf
  OpensslLib|CryptoPkg/Library/OpensslLib/OpensslLib.inf
  IntrinsicLib|CryptoPkg/Library/IntrinsicLib/IntrinsicLib.inf

  StackCheckLib|MdePkg/Library/StackCheckLibNull/StackCheckLibNull.inf
[Components]
  UefiLogInApp/UefiLogInApp.inf {
    <BuildOptions>
      # Base flags only for this driver
      GCC:*_*_X64_CC_FLAGS = -std=c23 -I$(MODULE_DIR)/include/ -fstrict-flex-arrays=3 -ftrivial-auto-var-init=zero -fzero-init-padding-bits=all -funsigned-char -fno-delete-null-pointer-checks -fno-finite-loops -fno-strict-aliasing
      GCC:*_*_X64_CC_FLAGS = -Wall -Wextra -Wpedantic -Wshadow -Wno-unused-parameter -Wpointer-arith -Wframe-larger-than=4096 -Wformat=2 -Wnull-dereference -Wswitch-enum -Wswitch-default -Wtrivial-auto-var-init -Wuseless-cast -Wstrict-flex-arrays -Wattribute-alias=2 -Wduplicated-branches -Wduplicated-cond -Wtrampolines -Wundef -Wcast-qual -Wwrite-strings -Wconversion -Wsign-conversion -Wflex-array-member-not-at-end -Wlogical-op -Wdeprecated-non-prototype -Wnested-externs -Winvalid-pch -Wvla-larger-than=1024 -Wno-error

      # When running Analyzer
      !if $(ANALYZER) == TRUE
        GCC:*_*_X64_CC_FLAGS = -fanalyzer -flto
      !endif

      # When dumping ASM
      #!if $(ASM_DUMP) == TRUE
      #  GCC:*_*_X64_CC_FLAGS = --save-temps -fverbose-asm -masm=intel -fno-asynchronous-unwind-tables -fno-lto
      #  GCC:*_*_X64_DLINK_FLAGS = -fno-lto
      #!endif
  }

[PcdsFixedAtBuild]
  !if $(TARGET) == DEBUG
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0xFFFFFFFF # DEBUG Build: Everything enabled (All 32 bits)
!else
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000002 # RELEASE Build: WARNING (0x02) and ERROR (0x80000000) only
!endif
