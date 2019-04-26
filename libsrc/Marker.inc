!A B C I n c l u d e F i l e
_MarkerLinkMode_ Equate(1)
_MarkerDllMode_  Equate(0)

TMarkedLines   Queue,Type
ID                CString(41)
               End

TColorColumns  Queue,Type
NFG               Any
NBG               Any
SFG               Any
SBG               Any
               End


! **********************************************************************************************
! Marker Class
! **********************************************************************************************

MarkerClass CLASS,Type,MODULE('Marker.CLW'),LINK('Marker.CLW',_MarkerLinkMode_),DLL(_MarkerDllMode_)

              ! Properties -----------------------------------------------------------------------

ListCtrl         Long
QList           &Queue
QMark           &TMarkedLines
QColumn         &TColorColumns
UniqueField      Any
MarkField        Any
MarkCount        Long

Mark_NFG         Long
Mark_NBG         Long
Mark_SFG         Long
Mark_SBG         Long

Unmark_NFG       Any
Unmark_NBG       Any
Unmark_SFG       Any
Unmark_SBG       Any

              ! Methods -------------------------------------------------------------------------

Init               Procedure(Long ListCtrl,Queue QList,*? UniqueField,*? MarkField),Proc
Kill               Procedure(),Proc
AddColumn          Procedure(*? NFG,*? NBG,*? SFG,*? SBG),Proc
SetUnmarkColumn    Procedure(*? NFG,*? NBG,*? SFG,*? SBG),Proc
SyncQMark          Procedure(),Proc
SetColors          Procedure(),Proc
IsMarked           Procedure(*? UniqueField),Byte
Marks              Procedure(),Long,Proc
MarkAll            Procedure(),Proc
UnmarkAll          Procedure(),Proc
InvertMark         Procedure(),Proc
TakeEvent          Procedure(),Byte,Proc

                End
