 Member
 Include('Marker.inc'),Once
 Include('KeyCodes.clw'),Once
 Map
 End

MarkerClass.Init Procedure(Long ListCtrl,Queue QList,*? UniqueField,*? MarkField)
  Code
  self.ListCtrl       = ListCtrl
  self.QList         &= QList
  self.QMark         &= New TMarkedLines
  self.QColumn       &= New TColorColumns
  self.UniqueField   &= UniqueField
  self.MarkField     &= MarkField

  self.Mark_NFG = Color:White
  self.Mark_NBG = Color:Navy
  self.Mark_SFG = Color:Yellow
  self.Mark_SBG = -1

  self.Unmark_NFG &= Null
  self.Unmark_NBG &= Null
  self.Unmark_SFG &= Null
  self.Unmark_SBG &= Null

  self.ListCtrl{Prop:Alrt,255} = CtrlMouseLeft
  self.ListCtrl{Prop:Alrt,255} = ShiftMouseLeft

MarkerClass.Kill        Procedure()
  Code
  if ~(self.QMark &= Null)   then Free(self.QMark);   Dispose(self.QMark).
  if ~(self.QColumn &= Null) then Free(self.QColumn); Dispose(self.QColumn).

MarkerClass.AddColumn          Procedure(*? NFG,*? NBG,*? SFG,*? SBG)
  Code
  Clear(self.QColumn)
  self.QColumn.NFG &= NFG
  self.QColumn.NBG &= NBG
  self.QColumn.SFG &= SFG
  self.QColumn.SBG &= SBG
  Add(self.QColumn)

MarkerClass.SetUnmarkColumn    Procedure(*? NFG,*? NBG,*? SFG,*? SBG)
  Code
  self.Unmark_NFG &= NFG
  self.Unmark_NBG &= NBG
  self.Unmark_SFG &= SFG
  self.Unmark_SBG &= SBG

MarkerClass.SyncQMark        Procedure()
  Code
  self.QMark.ID = self.UniqueField
  Get(self.QMark,self.QMark.ID)
  if ~ErrorCode() then
     if self.MarkField = 0 then
        Delete(self.QMark)
     End
  else
     if self.MarkField then
        self.QMark.ID = self.UniqueField
        Add(self.QMark)
     End
  End


MarkerClass.SetColors        Procedure()
  Code
  if Records(self.QColumn) then
     Loop i# = 1 to Records(self.QColumn)
          Get(self.QColumn,i#)
          if self.QColumn.NFG = self.Mark_NFG then
             self.QColumn.NFG = Choose(self.Unmark_NFG &= Null,-1,self.Unmark_NFG)
          End
          self.QColumn.NBG = Choose(self.Unmark_NBG &= Null,-1,self.Unmark_NBG)
          self.QColumn.SFG = Choose(self.Unmark_SFG &= Null,-1,self.Unmark_SFG)
          self.QColumn.SBG = Choose(self.Unmark_SBG &= Null,-1,self.Unmark_SBG)
          if self.MarkField then
             if self.QColumn.NFG = Choose(self.Unmark_NFG &= Null,-1,self.Unmark_NFG) then
                self.QColumn.NFG = self.Mark_NFG
             End
             self.QColumn.NBG = self.Mark_NBG
             self.QColumn.SFG = self.Mark_SFG
             self.QColumn.SBG = self.Mark_SBG
          End
     End
  else
     Message('Color columns are not specified!')
  End

MarkerClass.IsMarked          Procedure(*? UniqueField)
  Code
  self.QMark.ID = UniqueField
  Get(self.QMark,self.QMark.ID)
  if ErrorCode() then
     Return False
  else
     Return True
  End

MarkerClass.Marks             Procedure()
  Code
  self.MarkCount = 0
  if ~Records(self.QMark) then
     Return self.MarkCount
  End
  !Loop i# = 1 to Records(self.QList)
  !     Get(self.QList,i#)
  !     if self.MarkField then
  !        self.MarkCount += 1
  !     End
  !End
  self.MarkCount = Records(self.QMark)
  Return self.MarkCount

MarkerClass.MarkAll            Procedure()
  Code
  Loop i# = 1 to Records(self.QList)
       Get(self.QList,i#)
       self.MarkField = 1
       self.SyncQMark
       self.SetColors
       Put(self.QList)
  End

MarkerClass.UnmarkAll          Procedure()
  Code
  Loop i# = 1 to Records(self.QList)
       Get(self.QList,i#)
       self.MarkField = 0
       self.SyncQMark
       self.SetColors
       Put(self.QList)
  End
  Free(self.QMark)

MarkerClass.InvertMark         Procedure()
  Code
  Loop i# = 1 to Records(self.QList)
       Get(self.QList,i#)
       if self.MarkField then
          self.MarkField = 0
       else
          self.MarkField = 1
       End
       self.SyncQMark
       self.SetColors
       Put(self.QList)
  End


MarkerClass.TakeEvent   Procedure()

  Code
  Case Event()
  of EVENT:AlertKey
     Case Field()
     of self.ListCtrl
        Case KeyCode()
        of CtrlMouseLeft
           mdr# = self.ListCtrl{PropList:MouseDownRow}
           if mdr# <= Records(self.QList)
              self.ListCtrl{Prop:Selected} = mdr#
              !BRW1.UpdateViewRecord
              Get(self.QList,Choice(self.ListCtrl))
              if ~ErrorCode() then
                 if self.MarkField then
                    self.MarkField = 0
                 else
                    self.MarkField = 1
                 End
                 self.SyncQMark
                 self.SetColors
                 Put(self.QList)
              End
           End
        of ShiftMouseLeft
           mdr# = self.ListCtrl{PropList:MouseDownRow}
           if mdr# <= Records(self.QList)
              Get(self.QList,mdr#)
              if self.MarkField then
                 NewMark# = 0
              else
                 NewMark# = 1
              End
              chc# = self.ListCtrl{Prop:Selected}
              self.ListCtrl{Prop:Selected} = mdr#
              !BRW1.UpdateViewRecord
              if chc# < mdr#
                 step# = 1
              else
                 step# = -1
              End
              Loop i# = chc# to mdr# by step#
                   Get(self.QList,i#)
                   self.MarkField = NewMark#
                   self.SyncQMark
                   self.SetColors
                   Put(self.QList)
              End
           End
        End
     End
  End
  Return 0


