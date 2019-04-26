 OMIT('_EndOfInclude_',_FreeDiskSpaceClassIncluded_)
_FreeDiskSpaceClassIncluded_ EQUATE(1)

  INCLUDE('LoadLib.inc'),ONCE

!Unsigned 64 bit integer Intel order;
!range 0 to 18,446,744,073,709,551,615
ULARGE_INTEGER GROUP,TYPE 
LowDw            ULONG
HighDw           ULONG
               END

ULARGE_DECIMALSIZE  EQUATE(21)

DISK_SPACE      GROUP,TYPE
szDirectoryName     CSTRING(FILE:MaxFilePath)
TotalBytes          DECIMAL(ULARGE_DECIMALSIZE)
TotalFreeBytes      DECIMAL(ULARGE_DECIMALSIZE)
FreeBytesAvailable  DECIMAL(ULARGE_DECIMALSIZE)
                END

!=======================================================================
! DiskInfoClass
!=======================================================================
DiskInfoClass   CLASS, TYPE, MODULE('DiskInfo.clw'), |
                               LINK('DiskInfo.clw',_ABCLinkMode_), |
                                DLL(_ABCDllMode_)

Init                   PROCEDURE(),LONG
GetDiskSpace           PROCEDURE(*DISK_SPACE DiskSpace),LONG

Kernel                 &LoadLibClass,PROTECTED

DiGetDiskFreeSpaceEx   PROCEDURE(*DISK_SPACE pDiskSpace),LONG,PROTECTED
DiGetDiskFreeSpace     PROCEDURE(*DISK_SPACE pDiskSpace),LONG,PROTECTED
Destruct               PROCEDURE(),PROTECTED
                END

_EndOfInclude_