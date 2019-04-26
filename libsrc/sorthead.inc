!Declarations of SortHeader Class and Type

OMIT('_EndOfInclude_',_SortHeaderPresent_)
_SortHeaderPresent_ EQUATE(1)

RegionStatus:MouseReleased            EQUATE(0)
RegionStatus:MousePressedAndInRegion  EQUATE(1)
RegionStatus:MousePressedAndOutRegion EQUATE(2)

QueueListHeaderType    QUEUE,TYPE
ListHeaderText           STRING(512)
                       END
QueueListSortType      QUEUE,TYPE
ListSortColumn           LONG
PrevListSortColumn       LONG
                       END

SortHeaderClassType  CLASS,TYPE,MODULE('SortHead.Clw'),LINK('SortHead.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
!----------- Private Members -------------
ListQueue              &QUEUE,PRIVATE
QueueListHeader        &QueueListHeaderType,PRIVATE
QueueListSort          &QueueListSortType,PRIVATE
ListControl            SIGNED,PRIVATE
RegionControl          SIGNED,PRIVATE
IniFileName            STRING(255),PRIVATE
ProcedureName          STRING(255),PRIVATE
SortOrder              SHORT,PRIVATE
PrevSortOrder          SHORT,PRIVATE
MouseRegionStatus      BYTE,PRIVATE
ForceChangeSignOrder   BYTE,PRIVATE
LastKeyCode            LONG,PRIVATE
FirstSortField         STRING(1024),PRIVATE

!----------- Public Methods --------------
Initialize             PROCEDURE(QUEUE ListQueue,SIGNED ListControl,LONG RowSortDefault = 0,<STRING IniFileName>,<STRING ProcedureName>)
TakeEvents             PROCEDURE,BYTE,PROC
SetSortOrder           PROCEDURE(<LONG SortOrder>)
GetSortOrder           PROCEDURE,LONG
SortQueue              PROCEDURE
Kill                   PROCEDURE


!----------- Private Methods -------------
SetPrevSortOrder       PROCEDURE,PRIVATE
MouseReleased          PROCEDURE,PRIVATE
MousePressed           PROCEDURE,PRIVATE
FieldInGroup           FUNCTION,BYTE,PRIVATE
SetRegionUp            PROCEDURE,PRIVATE
SetRegionDown          PROCEDURE,PRIVATE
CheckRangeRegion       PROCEDURE,BYTE,PRIVATE
FindRecord             PROCEDURE,LONG,PRIVATE

!----------- Vitrual Methods -------------
QueueResorted          PROCEDURE,VIRTUAL
                     END
!--------------------------------------------------

_EndOfInclude_
