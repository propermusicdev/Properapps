  PROGRAM
    INCLUDE('DiskInfo.inc')

  MAP
  END

DiskSpace   LIKE(DISK_SPACE)
DI          DiskInfoClass
Result      LONG,AUTO
MSGTITLE    EQUATE('Disk free space')
  CODE

  DiskSpace.szDirectoryName = 'c:\'

  IF NOT DI.Init()
    Result = DI.GetDiskSpace(DiskSpace)
    CASE Result
    OF 0
      MESSAGE('Number of Bytes:<9>'& FORMAT(DiskSpace.TotalBytes, @n30)&'|'&|
              'Number of Free Bytes:<9>'& FORMAT(DiskSpace.TotalFreeBytes, @n30)&'||'&|
              'Free Bytes Available:<9>'& FORMAT(DiskSpace.FreeBytesAvailable, @n30),|
              MSGTITLE)

    OF 123
      MESSAGE('Invalid path.||Error code: '&Result,|
              MSGTITLE,ICON:Exclamation)
    ELSE
      MESSAGE('Couldn''t get disk information.||Error code: '&Result,|
              MSGTITLE,ICON:Exclamation)
    END
  END


  RETURN