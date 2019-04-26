!========================================
! Copyright © 2001 by Sand & Associates
!
! removed IsBad...() function calls
! Changed ABCLink/DLLmode equates (you must set LLLink/DllMode defines in your project)
!========================================
  MEMBER()

  INCLUDE('LoadLib.inc')

  MAP
   MODULE('Win32Api')
    LoadLibrary(*CSTRING pszModuleFileName), UNSIGNED, PASCAL, RAW, NAME('LoadLibraryA')
    FreeLibrary(UNSIGNED hModule), LONG, PASCAL, PROC
    GetModuleHandle(*CSTRING pszModuleName), UNSIGNED, PASCAL, RAW, NAME('GetModuleHandleA')
    GetProcAddress(UNSIGNED hModule,    | Handle returned by LoadLibrary()
                   *CSTRING pszProcName | Name of the procedure
                  ), LONG, PASCAL, RAW
    GetLastError(), ULONG, PASCAL, NAME('GetLastError')
   END

  END

!=====================================================================
! GetLastAPIError()
!=====================================================================
LoadLibClass.GetLastAPIError PROCEDURE()
  CODE
  RETURN GetLastError()

!=====================================================================
! LlcLoadLibrary()
!=====================================================================
LoadLibClass.LlcLoadLibrary     PROCEDURE(STRING sModuleFileName, |
                                          UNSIGNED LoadMethod = Method:LoadLibrary )
RetCode             LONG,AUTO
  CODE
  ASSERT(_WIDTH32_)

  RetCode = 1
  IF NOT SELF.LibraryLoaded()
    SELF.szModuleFileName &= NEW(CSTRING(LEN(CLIP(sModuleFileName))+1))
    ASSERT(NOT SELF.szModuleFileName &= NULL)
    IF NOT SELF.szModuleFileName &= NULL
      SELF.szModuleFileName = CLIP(sModuleFileName)

      SELF.LoadMethod = CHOOSE(LoadMethod < Method:Last AND LoadMethod > 0, |
                               LoadMethod, |
                               Method:LoadLibrary)

      EXECUTE SELF.LoadMethod
        SELF.hModule = LoadLibrary(SELF.szModuleFileName)
        SELF.hModule = GetModuleHandle(SELF.szModuleFileName)
      END

    END

    IF SELF.LibraryLoaded()
      RetCode = SUCCESS
    ELSE
      SELF.OnLoadLibraryFailure()
    END
  END
  RETURN RetCode


!=====================================================================
! OnLoadLibraryFailure()
!=====================================================================
LoadLibClass.OnLoadLibraryFailure         PROCEDURE()
  CODE
  SELF.LastError = GetLastError()
  RETURN


!=====================================================================
! LlcGetProcAddress()
!=====================================================================
LoadLibClass.LlcGetProcAddress       PROCEDURE(STRING sProcedureName)!,LONG
szProcedureName Cstring(256)
  Code
  szProcedureName = Clip(sProcedureName)
  Return Self.LlcGetProcAddress(szProcedureName)
  

!=====================================================================
! LlcGetProcAddress()
!=====================================================================
LoadLibClass.LlcGetProcAddress             PROCEDURE(*CSTRING szProcedureName)
lpProcedure     LONG,AUTO

  CODE
  IF SELF.LibraryLoaded()
    lpProcedure = GetProcAddress(SELF.hModule, szProcedureName)
    IF lpProcedure = 0
      Self.szProcedureName = szProcedureName
      SELF.OnGetProcAddressFailure()
      Self.szProcedureName = ''
    END
  ELSE 
    ASSERT(False) !'GetProcAddress("'&szProcedureName&'") failed, module not loaded'
    lpProcedure = 0
  END
  RETURN lpProcedure

!=====================================================================
! OnGetProcAddressFailure()
!=====================================================================
LoadLibClass.OnGetProcAddressFailure      PROCEDURE()

  CODE
  SELF.LastError = GetLastError()

  RETURN


!=====================================================================
! LlcFreeLibrary()
!=====================================================================
LoadLibClass.LlcFreeLibrary PROCEDURE()
RetVal  LONG,AUTO

  CODE
  DISPOSE(SELF.szModuleFileName)
  RetVal = SUCCESS

  IF SELF.LibraryLoaded()
    IF SELF.LoadMethod = Method:LoadLibrary
      IF NOT FreeLibrary(SELF.hModule)
        RetVal = 1
        SELF.LastError = GetLastError()
      END
    END
    SELF.hModule = 0
  END

  RETURN RetVal


!=====================================================================
! LibraryLoaded()
!=====================================================================
LoadLibClass.LibraryLoaded          PROCEDURE()
  CODE
  RETURN CHOOSE(SELF.hModule)


!=====================================================================
! Destruct()
!=====================================================================
LoadLibClass.Destruct PROCEDURE()
  CODE
  SELF.LlcFreeLibrary()
  RETURN

