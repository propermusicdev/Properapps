!SortHeader method implementations

  MEMBER()

  INCLUDE('Keycodes.Clw'),ONCE
  INCLUDE('SortHead.Inc'),ONCE

  MAP
    MODULE('WinAPI')
      SetCapture(UNSIGNED),UNSIGNED,PASCAL
      ReleaseCapture(),SIGNED,PASCAL
    END
  END

!=========================== Public Methods ===================================
SortHeaderClassType.Initialize PROCEDURE(QUEUE ListQueue,SIGNED ListControl,LONG RowSortDefault = 0,<STRING IniFileName>,<STRING ProcedureName>)

Loc:lLoopIndex      LONG,AUTO
Loc:stSortOrder     STRING(100),AUTO
Loc:lRowSort        LONG,AUTO

  CODE
  IF SELF.RegionControl
    RETURN
  END

  SELF.QueueListHeader  &= NEW(QueueListHeaderType)
  SELF.QueueListSort    &= NEW(QueueListSortType)

  SELF.RegionControl               = CREATE(0,CREATE:Region)
  SELF.RegionControl{PROP:Width}   = 1
  SELF.RegionControl{PROP:Height}  = 1
  SELF.RegionControl{PROP:Disable} = False
  SELF.RegionControl{PROP:Imm}     = True
  SELF.SetRegionUp()

  SELF.ListQueue   &= ListQueue
  SELF.ListControl  = ListControl

  SELF.ForceChangeSignOrder = False
  SELF.LastKeyCode = CtrlMouseLeft
  CLEAR(SELF.FirstSortField)

  SELF.PrevSortOrder = 0
  SELF.SortOrder     = 0

  SELF.ListControl{PROP:Alrt,254} = CtrlMouseLeft
  SELF.ListControl{PROP:Alrt,255} = MouseLeft

  Loc:lLoopIndex = 1
  LOOP
    IF SELF.ListControl{PROPLIST:Exists,Loc:lLoopIndex} 
      SELF.QueueListHeader.ListHeaderText = SELF.ListControl{PROPLIST:Header,Loc:lLoopIndex} 
      ADD(SELF.QueueListHeader)
      Loc:lLoopIndex += 1
    ELSE
      BREAK
    END
  END

  SELF.MouseRegionStatus = RegionStatus:MouseReleased

  IF ~OMITTED(5) AND IniFileName AND ~OMITTED(6) AND ProcedureName
    SELF.IniFileName   = IniFileName
    SELF.ProcedureName = ProcedureName
    Loc:lLoopIndex = 1
    LOOP
      Loc:stSortOrder = GETINI(CLIP(SELF.ProcedureName),'CurrentSortRow:' & SELF.ListControl & ':' & Loc:lLoopIndex,'?',SELF.IniFileName)
      IF CLIP(Loc:stSortOrder) <> '?'
        Loc:lRowSort = Loc:stSortOrder
        IF SELF.ListControl{PROPLIST:Exists,ABS(Loc:lRowSort)}
          SELF.PrevSortOrder = Loc:lRowSort
          SELF.SortOrder     = ABS(Loc:lRowSort)
          SELF.SetPrevSortOrder()
          IF Loc:lRowSort < 0
            SELF.ForceChangeSignOrder = True
            SELF.SetPrevSortOrder()
          END
          SELF.SortQueue()
        END
      ELSE
        BREAK
      END
      Loc:lLoopIndex += 1
    END
  END
  IF SELF.SortOrder = 0 AND RowSortDefault
    IF SELF.ListControl{PROPLIST:Exists,ABS(RowSortDefault)}
      SELF.PrevSortOrder = RowSortDefault
      SELF.SortOrder     = ABS(RowSortDefault)
    ELSE
      SELF.PrevSortOrder = 1
      SELF.SortOrder     = 1
    END
    SELF.SetPrevSortOrder()
    SELF.SortQueue()
  END
  RETURN
!------------------------------------------------------------------------------
SortHeaderClassType.TakeEvents PROCEDURE
  CODE
  IF SELF.RegionControl = 0
    RETURN(0)
  END
  IF EVENT() = EVENT:PreAlertKey
    SELF.LastKeyCode = KEYCODE()
    IF SELF.LastKeyCode = MouseLeft OR SELF.LastKeyCode = CtrlMouseLeft
      RETURN(1)
    END
  END
  IF FIELD() = SELF.ListControl
    CASE EVENT()
    OF EVENT:NewSelection
    OROF EVENT:Accepted
      GET(SELF.ListQueue,CHOICE(SELF.ListControl))
      SELF.FirstSortField = WHAT(SELF.ListQueue,SELF.ListControl{PROPLIST:FieldNo,ABS(SELF.GetSortOrder())})
    END
  END
  IF SELF.ListControl{PROPLIST:MouseDownRow} > 0 OR |
     SELF.ListControl{PROPLIST:MouseDownField} = 0 OR |
     SELF.ListControl{PROPLIST:MouseDownZone} = LISTZONE:right then
    RETURN(0)
  END
  IF EVENT() = EVENT:AlertKey
    SELF.LastKeyCode = KEYCODE()
    IF (SELF.LastKeyCode = MouseLeft OR SELF.LastKeyCode = CtrlMouseLeft) AND FIELD() = SELF.ListControl
      SELF.MousePressed()
      Err# = SetCapture(SELF.RegionControl{PROP:Handle})
      SELF.MouseRegionStatus = RegionStatus:MousePressedAndInRegion
      RETURN(0)
    END
  END
  IF FIELD() = SELF.RegionControl
    CASE EVENT()
    OF EVENT:MouseUp
      Err# = ReleaseCapture()
      IF SELF.MouseRegionStatus = RegionStatus:MousePressedAndInRegion
        SELF.MouseReleased()
      ELSE
        SELF.ListControl{PROP:Edit,SELF.SortOrder} = 0
        SELF.RegionControl{PROP:Hide} = True
      END
      SELF.MouseRegionStatus = RegionStatus:MouseReleased
    OF EVENT:MouseOut
      IF SELF.MouseRegionStatus = RegionStatus:MousePressedAndInRegion
        IF ~SELF.CheckRangeRegion()
          SELF.SetRegionUp()
          SELF.MouseRegionStatus = RegionStatus:MousePressedAndOutRegion
        END
      END
    OF EVENT:MouseIn
    OROF EVENT:MouseMove
      IF SELF.MouseRegionStatus = RegionStatus:MousePressedAndOutRegion
        IF SELF.CheckRangeRegion()
          SELF.SetRegionDown()
          SELF.MouseRegionStatus = RegionStatus:MousePressedAndInRegion
        END
      END
    END
  END
  RETURN(0)
!------------------------------------------------------------------------------
SortHeaderClassType.SetSortOrder PROCEDURE(<LONG SortOrder>)
  CODE
  IF SELF.RegionControl
    IF ~OMITTED(2)
      SELF.SortOrder = SortOrder
    END
    IF SELF.SortOrder
      SELF.SetPrevSortOrder()
      SELF.SortQueue()
    END
  END
  RETURN
!------------------------------------------------------------------------------
SortHeaderClassType.GetSortOrder PROCEDURE
  CODE
  IF SELF.RegionControl
    IF RECORDS(SELF.QueueListSort)
      GET(SELF.QueueListSort,1)
      IF ABS(SELF.QueueListSort.PrevListSortColumn) = SELF.QueueListSort.ListSortColumn AND SELF.QueueListSort.PrevListSortColumn < 0
        RETURN(-SELF.QueueListSort.ListSortColumn)
      ELSE
        RETURN(SELF.QueueListSort.ListSortColumn)
      END
    ELSE
      RETURN(SELF.SortOrder)
    END
  ELSE
    RETURN(0)
  END
!------------------------------------------------------------------------------
SortHeaderClassType.Kill PROCEDURE

Loc:lLoopIndex  LONG,AUTO
Loc:stSortOrder STRING(100),AUTO

  CODE
  IF SELF.RegionControl
    IF SELF.IniFileName AND SELF.ProcedureName
      Loc:lLoopIndex = 1
      LOOP
        Loc:stSortOrder = GETINI(CLIP(SELF.ProcedureName),'CurrentSortRow:' & SELF.ListControl & ':' & Loc:lLoopIndex,'?',SELF.IniFileName)
        IF CLIP(Loc:stSortOrder) = '?'
          BREAK
        ELSE
          PUTINI(CLIP(SELF.ProcedureName),'CurrentSortRow:' & SELF.ListControl & ':' & Loc:lLoopIndex,,SELF.IniFileName)
        END
        Loc:lLoopIndex += 1
      END
      LOOP Loc:lLoopIndex = 1 TO RECORDS(SELF.QueueListSort)
        GET(SELF.QueueListSort,Loc:lLoopIndex)
        IF ABS(SELF.QueueListSort.PrevListSortColumn) = SELF.QueueListSort.ListSortColumn AND SELF.QueueListSort.PrevListSortColumn < 0
          PUTINI(CLIP(SELF.ProcedureName),'CurrentSortRow:' & SELF.ListControl & ':' & Loc:lLoopIndex,'-' & SELF.QueueListSort.ListSortColumn,SELF.IniFileName)
        ELSE
          PUTINI(CLIP(SELF.ProcedureName),'CurrentSortRow:' & SELF.ListControl & ':' & Loc:lLoopIndex,SELF.QueueListSort.ListSortColumn,SELF.IniFileName)
        END
      END
    END
    LOOP Loc:lLoopIndex = 1 TO RECORDS(SELF.QueueListHeader)
      GET(SELF.QueueListHeader,Loc:lLoopIndex)
      SELF.ListControl{PROPLIST:Header,Loc:lLoopIndex} = SELF.QueueListHeader.ListHeaderText
    END
    FREE(SELF.QueueListHeader)
    DISPOSE(SELF.QueueListHeader)
    FREE(SELF.QueueListSort)
    DISPOSE(SELF.QueueListSort)
    DESTROY(SELF.RegionControl)
    SELF.RegionControl = 0
  END
  RETURN
!------------------------------------------------------------------------------

!=========================== Private Methods ==================================
SortHeaderClassType.SetPrevSortOrder PROCEDURE
  CODE
  CASE SELF.LastKeyCode
  OF MouseLeft
    IF ABS(SELF.PrevSortOrder) = SELF.SortOrder AND SELF.ForceChangeSignOrder = True
      SELF.PrevSortOrder = -1 * SELF.PrevSortOrder
    END
    FREE(SELF.QueueListSort)
    CLEAR(SELF.QueueListSort)
    SELF.QueueListSort.ListSortColumn = SELF.SortOrder
    SELF.QueueListSort.PrevListSortColumn = SELF.PrevSortOrder
    ADD(SELF.QueueListSort)
    SELF.FirstSortField = WHAT(SELF.ListQueue,SELF.ListControl{PROPLIST:FieldNo,SELF.QueueListSort.ListSortColumn})
  OF CtrlMouseLeft
    CLEAR(SELF.QueueListSort)
    SELF.QueueListSort.ListSortColumn = SELF.SortOrder
    GET(SELF.QueueListSort,+SELF.QueueListSort.ListSortColumn)
    IF ~ERRORCODE()
      IF SELF.ForceChangeSignOrder = True
        SELF.QueueListSort.PrevListSortColumn = -1 * SELF.QueueListSort.PrevListSortColumn
        PUT(SELF.QueueListSort)
      END
    ELSE
      SELF.QueueListSort.PrevListSortColumn = SELF.SortOrder
      ADD(SELF.QueueListSort)
      IF RECORDS(SELF.QueueListSort) = 2
        GET(SELF.QueueListSort,1)
        SELF.QueueListSort.PrevListSortColumn = SELF.PrevSortOrder
      END
    END
  END
  RETURN
!------------------------------------------------------------------------------
SortHeaderClassType.MousePressed PROCEDURE

Loc:lDelta   LONG,AUTO
Loc:byPixels BYTE,AUTO

  CODE
  SELF.SortOrder = SELF.ListControl{PROPLIST:MouseDownField}
  SELF.ListControl{PROP:Edit,SELF.SortOrder} = SELF.RegionControl
  Loc:byPixels = TARGET{PROP:Pixels}
  TARGET{PROP:Pixels} = True
  IF SELF.FieldInGroup()
    SELF.RegionControl{PROP:YPos} = SELF.ListControl{PROP:HeaderHeight} / 2 - 1
    SELF.RegionControl{PROP:Height} = SELF.ListControl{PROP:HeaderHeight} / 2 - 1
  ELSE
    SELF.RegionControl{PROP:YPos} = 0
    SELF.RegionControl{PROP:Height} = SELF.ListControl{PROP:HeaderHeight} - 1
  END
  IF SELF.ListControl{PROPLIST:Icon,SELF.SortOrder}
    Loc:lDelta = SELF.ListControl{PROPLIST:Width,SELF.SortOrder} - SELF.RegionControl{PROP:Width}
    SELF.RegionControl{PROP:XPos} = SELF.RegionControl{PROP:XPos} - Loc:lDelta
    SELF.RegionControl{PROP:Width} = SELF.RegionControl{PROP:Width} + Loc:lDelta
  END
  SELF.RegionControl{PROP:XPos} = SELF.RegionControl{PROP:XPos} - 1
  SELF.RegionControl{PROP:Width} = SELF.RegionControl{PROP:Width} + 2
  TARGET{PROP:Pixels} = Loc:byPixels
  SELF.SetRegionDown()
  SELF.RegionControl{PROP:Hide} = False
  RETURN
!------------------------------------------------------------------------------
SortHeaderClassType.MouseReleased PROCEDURE

Loc:lPointer LONG,AUTO

  CODE
  SELF.SortOrder = SELF.ListControl{PROPLIST:MouseDownField}
  SELF.ListControl{PROP:Edit,SELF.SortOrder} = 0
  SELF.RegionControl{PROP:Hide} = True
  SELF.ForceChangeSignOrder = True
  SELF.SetPrevSortOrder()
  GET(SELF.ListQueue,CHOICE(SELF.ListControl))
  SELF.SortQueue()
  IF ABS(SELF.PrevSortOrder) <> SELF.SortOrder
    SELF.PrevSortOrder = SELF.SortOrder
  END
  SELF.SetRegionUp()
  Loc:lPointer = SELF.FindRecord()
  IF Loc:lPointer
    SELECT(SELF.ListControl,Loc:lPointer)
  ELSE
    SELECT(SELF.ListControl)
  END
  POST(EVENT:NewSelection,SELF.ListControl)
  RETURN
!------------------------------------------------------------------------------
SortHeaderClassType.FieldInGroup FUNCTION

Loc:stFilterString &STRING,AUTO
Loc:lFilterLenght   LONG,AUTO
Loc:lLoopIndex      LONG,AUTO
Loc:lFieldCounter   LONG,AUTO
Loc:byFieldInGroup  BYTE,AUTO

  CODE
  Loc:lFieldCounter = 0
  Loc:byFieldInGroup = 0
  Loc:lFilterLenght = LEN(CLIP(SELF.ListControl{PROP:Format}))
  Loc:stFilterString &= NEW(STRING(Loc:lFilterLenght + 1))
  Loc:stFilterString = SELF.ListControl{PROP:Format}
  LOOP Loc:lLoopIndex = 1 TO Loc:lFilterLenght
    CASE Loc:stFilterString[Loc:lLoopIndex]
    OF '|'
      Loc:lFieldCounter += 1
      IF Loc:lFieldCounter = SELF.SortOrder
        BREAK
      END
    OF '['
      Loc:byFieldInGroup += 1
    OF ']'
      Loc:byFieldInGroup -= 1
    END
  END
  DISPOSE(Loc:stFilterString)
  RETURN(Loc:byFieldInGroup)
!------------------------------------------------------------------------------
SortHeaderClassType.SortQueue PROCEDURE

Loc:lLoopIndex   LONG,AUTO
Loc:stSortString STRING(10 * 1024),AUTO
Loc:stSign       STRING(1),AUTO

  CODE
  IF SELF.ListControl{PROPLIST:Exists,SELF.SortOrder} = 0
    SELF.SortOrder = ABS(SELF.PrevSortOrder)
    RETURN
  END
  LOOP Loc:lLoopIndex = 1 TO RECORDS(SELF.QueueListHeader)
    GET(SELF.QueueListHeader,Loc:lLoopIndex)
    SELF.ListControl{PROPLIST:Header,Loc:lLoopIndex} = SELF.QueueListHeader.ListHeaderText
  END
  CLEAR(Loc:stSortString)
  LOOP Loc:lLoopIndex = 1 TO RECORDS(SELF.QueueListSort)
    GET(SELF.QueueListSort,Loc:lLoopIndex)
    IF ABS(SELF.QueueListSort.PrevListSortColumn) = SELF.QueueListSort.ListSortColumn AND SELF.QueueListSort.PrevListSortColumn < 0
      Loc:stSign = '-'
    ELSE
      Loc:stSign = '+'
    END
    SELF.ListControl{PROPLIST:Header,SELF.QueueListSort.ListSortColumn} = CLIP(SELF.ListControl{PROPLIST:Header,SELF.QueueListSort.ListSortColumn}) & '[' & Loc:stSign & CHOOSE(RECORDS(SELF.QueueListSort) = 1,'',CLIP(Loc:lLoopIndex)) & ']'
    Loc:stSortString = CLIP(Loc:stSortString) & CHOOSE(LEN(CLIP(Loc:stSortString)) = 0,'',',') & Loc:stSign & WHO(SELF.ListQueue,SELF.ListControl{PROPLIST:FieldNo,SELF.QueueListSort.ListSortColumn})
  END
  SORT(SELF.ListQueue,Loc:stSortString)
  SELF.QueueResorted()
  SELF.ForceChangeSignOrder = False
  RETURN
!------------------------------------------------------------------------------
SortHeaderClassType.SetRegionUp PROCEDURE
  CODE
  SELF.RegionControl{PROP:BevelInner} = 0
  SELF.RegionControl{PROP:BevelOuter} = 0
  IF SELF.ListControl{PROPLIST:HeaderLeft,SELF.SortOrder}
    SELF.ListControl{PROPLIST:HeaderLeftOffset,SELF.SortOrder} = SELF.ListControl{PROPLIST:HeaderLeftOffset,SELF.SortOrder} - 1
  END
  IF SELF.ListControl{PROPLIST:HeaderRight,SELF.SortOrder}
    SELF.ListControl{PROPLIST:HeaderRightOffset,SELF.SortOrder} = SELF.ListControl{PROPLIST:HeaderRightOffset,SELF.SortOrder} + 1
  END
  IF SELF.ListControl{PROPLIST:HeaderCenter,SELF.SortOrder}
    SELF.ListControl{PROPLIST:HeaderCenterOffset,SELF.SortOrder} = SELF.ListControl{PROPLIST:HeaderCenterOffset,SELF.SortOrder} - 1
  END
  IF SELF.ListControl{PROPLIST:HeaderDecimal,SELF.QueueListSort.ListSortColumn}
    SELF.ListControl{PROPLIST:HeaderDecimalOffset,SELF.SortOrder} = SELF.ListControl{PROPLIST:HeaderDecimalOffset,SELF.SortOrder} + 1
  END
  RETURN
!------------------------------------------------------------------------------
SortHeaderClassType.SetRegionDown PROCEDURE
  CODE
  SELF.RegionControl{PROP:BevelInner} = 0
  SELF.RegionControl{PROP:BevelOuter} = -2
  IF SELF.ListControl{PROPLIST:HeaderLeft,SELF.SortOrder}
    SELF.ListControl{PROPLIST:HeaderLeftOffset,SELF.SortOrder} = SELF.ListControl{PROPLIST:HeaderLeftOffset,SELF.SortOrder} + 1
  END
  IF SELF.ListControl{PROPLIST:HeaderRight,SELF.SortOrder}
    SELF.ListControl{PROPLIST:HeaderRightOffset,SELF.SortOrder} = SELF.ListControl{PROPLIST:HeaderRightOffset,SELF.SortOrder} - 1
  END
  IF SELF.ListControl{PROPLIST:HeaderCenter,SELF.SortOrder}
    SELF.ListControl{PROPLIST:HeaderCenterOffset,SELF.SortOrder} = SELF.ListControl{PROPLIST:HeaderCenterOffset,SELF.SortOrder} + 1
  END
  IF SELF.ListControl{PROPLIST:HeaderDecimal,SELF.SortOrder}
    SELF.ListControl{PROPLIST:HeaderDecimalOffset,SELF.SortOrder} = SELF.ListControl{PROPLIST:HeaderDecimalOffset,SELF.SortOrder} - 1
  END
  RETURN
!------------------------------------------------------------------------------
SortHeaderClassType.CheckRangeRegion PROCEDURE
  CODE
  IF MOUSEX() > SELF.ListControl{PROP:Xpos} + SELF.RegionControl{PROP:Xpos}                                  AND |
     MOUSEX() < SELF.ListControl{PROP:Xpos} + SELF.RegionControl{PROP:Xpos} + SELF.RegionControl{PROP:Width} AND |
     MOUSEY() > SELF.ListControl{PROP:Ypos} + SELF.RegionControl{PROP:Ypos}                                  AND |
     MOUSEY() < SELF.ListControl{PROP:Ypos} + SELF.RegionControl{PROP:Ypos} + SELF.RegionControl{PROP:Height} 
    RETURN(1)
  ELSE
    RETURN(0)
  END
!------------------------------------------------------------------------------
SortHeaderClassType.FindRecord PROCEDURE

Loc:lCurrentColumn LONG,AUTO
Loc:lPointer       LONG,AUTO
Loc:stSortString   STRING(1024),AUTO
Loc:anyField       ANY,AUTO

  CODE
  Loc:lCurrentColumn = SELF.GetSortOrder()
  Loc:lPointer = 0
  CLEAR(SELF.ListQueue)
  Loc:anyField &= WHAT(SELF.ListQueue,SELF.ListControl{PROPLIST:FieldNo,SELF.QueueListSort.ListSortColumn})
  Loc:anyField = CLIP(SELF.FirstSortField)
  Loc:stSortString = CHOOSE(Loc:lCurrentColumn > 0,'+','-') & WHO(SELF.ListQueue,SELF.ListControl{PROPLIST:FieldNo,SELF.QueueListSort.ListSortColumn})
  GET(SELF.ListQueue,Loc:stSortString)
  IF ~ERRORCODE()
    Loc:lPointer = POINTER(SELF.ListQueue)
  ELSE
    ADD(SELF.ListQueue,Loc:stSortString)
    GET(SELF.ListQueue,Loc:stSortString)
    Loc:lPointer = POINTER(SELF.ListQueue)
    IF Loc:lCurrentColumn < 0
      IF Loc:lPointer > 1
        Loc:lPointer -= 1
      END
    END
    DELETE(SELF.ListQueue)
    IF Loc:lPointer > RECORDS(SELF.ListQueue)
      Loc:lPointer = RECORDS(SELF.ListQueue)
    END
  END
  Loc:anyField &= NULL
  RETURN(Loc:lPointer)
!------------------------------------------------------------------------------

!=========================== Virtual Methods ==================================
SortHeaderClassType.QueueResorted PROCEDURE
  CODE
  RETURN
!------------------------------------------------------------------------------
