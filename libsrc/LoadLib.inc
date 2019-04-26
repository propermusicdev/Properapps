!========================================
! Copyright © 2001 by Sand & Associates
!
! removed IsBad...() function calls
! Changed ABCLink/DLLmode equates (you must set LLLink/DllMode defines in your project)
!========================================
 OMIT('_EndOfInclude_',_LLClassIncluded_)
_LLClassIncluded_ EQUATE(1)


SUCCESS     EQUATE(0)

Method      ITEMIZE(1),PRE()
LoadLibrary         EQUATE
GetModuleHandle     EQUATE
Last                EQUATE
            END

!============================================================
! LoadLibClass
!============================================================
LoadLibClass   CLASS,TYPE,MODULE('LoadLib.clw'),|
                          LINK('LoadLib.clw',_LLLinkMode_),|
                          DLL(_LLDllMode_)

LastError               ULONG          !Result of GetLastError()

LlcLoadLibrary          PROCEDURE(STRING sModuleFileName,|
                                  UNSIGNED LoadMethod=Method:LoadLibrary),LONG

LlcGetProcAddress       PROCEDURE(*CSTRING szProcedureName),LONG
LlcGetProcAddress       PROCEDURE(STRING sProcedureName),LONG
LlcFreeLibrary          PROCEDURE(),LONG,PROC

LibraryLoaded           PROCEDURE(),BOOL    !Returns True if the dll or exe was successfully loaded
GetLastAPIError         PROCEDURE(),ULONG   !Returns the last Windows Api Errorcode

!-- Protected--
LoadMethod              UNSIGNED,PROTECTED
hModule                 UNSIGNED(0),PROTECTED
szModuleFileName        &CSTRING,PROTECTED
szProcedureName         CSTRING(256),PROTECTED

OnLoadLibraryFailure    PROCEDURE(),VIRTUAL,PROTECTED
OnGetProcAddressFailure PROCEDURE(),VIRTUAL,PROTECTED
Destruct                PROCEDURE(),PROTECTED

               END

_EndOfInclude_

