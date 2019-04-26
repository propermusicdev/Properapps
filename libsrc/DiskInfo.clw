  MEMBER

 OMIT('*endomit*',_C55_)
_ABCDllMode_    EQUATE(0)
_ABCLinkMode_   EQUATE(1)
 *endomit*

  INCLUDE('DiskInfo.inc')

  MAP
    MODULE('Win32API')
      GetDiskFreeSpaceEx(LONG pszDirectoryName=0,                  | directory name
                         *ULARGE_INTEGER lpFreeBytesAvailable,    | bytes available to caller
                         *ULARGE_INTEGER lpTotalNumberOfBytes,    | bytes on disk
                         *ULARGE_INTEGER lpTotalNumberOfFreeBytes | free bytes on disk
                        ),BOOL,RAW,PASCAL,DLL(_fp_)

      GetDiskFreeSpace( LONG pszDirectoryName=0,         | root path
                        *ULONG lpSectorsPerCluster,     | sectors per cluster
                        *ULONG lpBytesPerSector,        | bytes per sector
                        *ULONG lpNumberOfFreeClusters,  | free clusters
                        *ULONG lpTotalNumberOfClusters  | total clusters
                      ),BOOL,RAW,PASCAL,DLL(_fp_)
    END

ULIntToDec PROCEDURE(*DECIMAL dResult, *ULARGE_INTEGER I64)
  END

! Function pointer variables to receive the address of the api function.
! You must assign a valid address BEFORE you attempt to call the function.
fpGetDiskFreeSpaceEx    LONG,AUTO,NAME('GetDiskFreeSpaceEx')
fpGetDiskFreeSpace      LONG,AUTO,NAME('GetDiskFreeSpace')



!===================================================================
! Destruct()
!===================================================================
DiskInfoClass.Destruct   PROCEDURE() 
  CODE
  DISPOSE(SELF.Kernel)
  RETURN

!===================================================================
! Init()
!===================================================================
DiskInfoClass.Init   PROCEDURE()
RetVal  LONG,AUTO
  CODE
  RetVal = 1
  SELF.Kernel &= NEW LoadLibClass
  IF NOT SELF.Kernel &= NULL
    ! GetDiskFreeSpaceEx() and GetDiskFreeSpace() are exported from kernel32.dll.
    ! The kernel is always mapped into the address space of your process.
    ! Therefore, it's not necessary to use LoadLibrary(), Instead specify that the
    ! LoadLibrary() method use GetModuleHandle().
    RetVal = SELF.Kernel.LlcLoadLibrary('kernel32.dll', Method:GetModuleHandle)
    IF SELF.Kernel.LibraryLoaded()
      fpGetDiskFreeSpaceEx = SELF.Kernel.LlcGetProcAddress('GetDiskFreeSpaceExA')
      fpGetDiskFreeSpace = SELF.Kernel.LlcGetProcAddress('GetDiskFreeSpaceA')
    ELSE
      fpGetDiskFreeSpaceEx = 0
      fpGetDiskFreeSpace   = 0
    END
  END
  RETURN RetVal


!===================================================================
! GetDiskSpace()
!===================================================================
DiskInfoClass.GetDiskSpace  PROCEDURE(*DISK_SPACE pDiskSpace)

RetVal                  LONG,AUTO
  CODE
  ASSERT(NOT SELF.Kernel &= NULL)

  IF SELF.Kernel.LibraryLoaded()
    RetVal = SELF.DiGetDiskFreeSpaceEx(pDiskSpace)
    IF RetVal
      RetVal = SELF.DiGetDiskFreeSpace(pDiskSpace)
    END
  ELSE
    RetVal = 1
  END

  RETURN RetVal

!===================================================================
! DiGetDiskFreeSpaceEx()
!===================================================================
DiskInfoClass.DiGetDiskFreeSpaceEx   PROCEDURE(*DISK_SPACE pDiskSpace)
i64FreeBytesAvailable   LIKE(ULARGE_INTEGER),AUTO
i64TotalBytes           LIKE(ULARGE_INTEGER),AUTO
i64TotalFreeBytes       LIKE(ULARGE_INTEGER),AUTO

RetVal                  LONG,AUTO
pszDirectoryName        LONG,AUTO
  CODE
  RetVal = 0
  pDiskSpace.FreeBytesAvailable = 0
  pDiskSpace.TotalBytes         = 0
  pDiskSpace.TotalFreeBytes     = 0

! fpGetDiskFreeSpaceEx = 0
  IF fpGetDiskFreeSpaceEx
    pszDirectoryName = CHOOSE(pDiskSpace.szDirectoryName <> '', |
                             ADDRESS(pDiskSpace.szDirectoryName), 0)
    IF GetDiskFreeSpaceEx(pszDirectoryName,      |
                          i64FreeBytesAvailable,|
                          i64TotalBytes,        |
                          i64TotalFreeBytes)

      !Convert the 64bit integers into decimals
      ULIntToDec(pDiskSpace.FreeBytesAvailable, |
                 i64FreeBytesAvailable)
      ULIntToDec(pDiskSpace.TotalBytes, |
                 i64TotalBytes)
      ULIntToDec(pDiskSpace.TotalFreeBytes, |
                 i64TotalFreeBytes)
    ELSE
      RetVal = SELF.Kernel.GetLastAPIError()
    END
  ELSE
    RetVal = 1
  END
  RETURN RetVal

!===================================================================
! DiGetDiskFreeSpace()
!===================================================================
DiskInfoClass.DiGetDiskFreeSpace  PROCEDURE(*DISK_SPACE pDiskSpace)

SectorsPerCluster       ULONG,AUTO
BytesPerSector          ULONG,AUTO
FreeClusters            ULONG,AUTO
Clusters                ULONG,AUTO

RetVal                  LONG,AUTO
pszDirectoryName        LONG,AUTO
  CODE
  RetVal = 0
  pDiskSpace.FreeBytesAvailable = 0
  pDiskSpace.TotalBytes         = 0
  pDiskSpace.TotalFreeBytes     = 0

  ! This function may not work correctly under Windows 95.  Even on
  ! volumes < 2GB capacity (per MSDN)
  IF fpGetDiskFreeSpace
    pszDirectoryName = CHOOSE(pDiskSpace.szDirectoryName<>'', |
                             ADDRESS(pDiskSpace.szDirectoryName), 0)
    IF GetDiskFreeSpace(pszDirectoryName, |
                        SectorsPerCluster,|
                        BytesPerSector,   |
                        FreeClusters,     |
                        Clusters)

      pDiskSpace.TotalFreeBytes = BytesPerSector *    |
                                  SectorsPerCluster * |
                                  FreeClusters

      pDiskSpace.FreeBytesAvailable = pDiskSpace.TotalFreeBytes

      pDiskSpace.TotalBytes = BytesPerSector *    |
                              SectorsPerCluster * |
                              Clusters

    ELSE
      RetVal = SELF.Kernel.GetLastAPIError()
    END
  END

  RETURN RetVal



!===================================================================
! ULIntToDec()
!
! Convert a 64 bit integer stored in a group of two ULONG's
! to a decimal.  The 64 bit integer is stored low double word first
! or Intel (little endian) order.
!
! The dResult decimal must be at least ULARGE_DECIMALSIZE
! DECIMAL(21).
!===================================================================
ULIntToDec  PROCEDURE(*DECIMAL dResult, *ULARGE_INTEGER I64)

TWO_TO_32           EQUATE(4294967296) !2^32
  CODE
  dResult = I64.HighDw * TWO_TO_32 + I64.LowDw
  RETURN
