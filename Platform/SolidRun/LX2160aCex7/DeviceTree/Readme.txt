These dts/dtsi files have been copied from MainLine Linux 5.7

branch : master 
Linux Version : 5.7.5 

Following changes have been done in these files
1. Tab has been converted to two spaces.
2. The file end of line has been changed to Windows
3. #include <dt-bindings/interrupt-controller/arm-gic.h> and #include <dt-bindings/thermal/thermal.h>
   these header files have been removed and the values of macros defined in these files has been used directly
4. The include files' location has been changed.
   The common dts/dtsi files are in Silicon/NXP/Include/DeviceTreeInclude/
   SOC specific dts/dtsi files are in Silicon/NXP/<SOC>/Include/DeviceTreeInclude/
   Platform specific dts/dtsi files are in Platform/SolidRun/LX2160aCex7/DeviceTree/

   Their path in dts/dtsi files have been fixed accordingly
5. The enable-method = "psci" has been added to all cpu nodes. no fixups are done by UEFI regarding this
6. The psci node has been added. no fixups are done by UEFI regarding this
7. Job ring 3 has been deleted from crypto node
11. The devices that are controlled by serdes protocol like mac devices and pcie and sata device have been
    disabled using status = "disabled"; property in main SOC dtsi file and have been enabled in board dts
    file.

