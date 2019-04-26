 member()
  include('excel.inc')
  include('keycodes.clw'),once
 map
 end

ExcelLink.Init  PROCEDURE
CurrentWindow &WINDOW
  CODE
  CurrentWindow &= SYSTEM{PROP:Target}
  Return SELF.Init(CurrentWindow)

ExcelLink.Init  PROCEDURE(Window TWindow)
ReturnValue byte
 code
 ReturnValue = 1
 Self.OleWindow &= TWindow
 SetTarget(Self.OleWindow)
 Self.OleControl = CREATE(0,CREATE:OLE)
 Self.OleControl{prop:create}='Excel.Sheet'
 Self.OleControl{PROP:ReportException} = True ! Set on checking OLE errors
 Self.OleControl{prop:language}=409H
 if Self.OleControl{'Application.Name'}='No ole automation interface'
  ReturnValue = 0
 end
 ! Default settings
 Self.ExportHeader       =1
 Self.FirstRowNum        =1
 Self.FirstColNum        =1
 Self.ChangeDecimal      =0
 Self.DocumentMode 	 =1
 return ReturnValue

ExcelLink.Close PROCEDURE
 code
 Self.OleWindow $ Self.OleControl{'Application.Quit'}

ExcelLink.Kill  PROCEDURE
ostr cstring(50)
 code
 SetTarget(Self.OleWindow)
 OStr = Self.OleControl{prop:object}
 Self.OleControl{prop:release}=OStr
 Self.OleControl{prop:deactivate}
 Destroy(Self.OleControl)
 SetTarget

ExcelLink.Construct PROCEDURE
 code
 Self.Columns &= new(ColumnsQueue)

ExcelLink.Destruct  PROCEDURE
 code
 free(Self.Columns)
 dispose(Self.Columns)

ExcelLink.SetVisible PROCEDURE(byte Visible,<long ApplicationWindowState>,<long ActiveWindowState>)
 code
 Self.OleWindow $ Self.OleControl{'Application.Visible'}=Visible
 if ApplicationWindowState <> 0
   Self.OleWindow $ Self.OleControl{'Application.WindowState'}=ApplicationWindowState
 end
 if ActiveWindowState <>0
   Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.WindowState'}=ActiveWindowState
 end

ExcelLink.CreateNewDoc  PROCEDURE
 code
 
 Self.OleWindow $ Self.OleControl{'Application.WorkBooks.Add'}
 Self.SheetName = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.ActiveSheet.Name'}
 !Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.ActivatePrevious'}
 !Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.Close'}

ExcelLink.OpenDoc       PROCEDURE(string TFileName)
 code
 Self.OleWindow $ Self.OleControl{'Application.WorkBooks.Open(' & clip(TFileName) & ')'}
 Self.SheetName = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.ActiveSheet.Name'}

ExcelLink.SetCurrentDoc PROCEDURE
SaveWin  string(100)
 code
 ! go to previous window
 !Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.Visible'}= 0
 SaveWin = Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.Caption'}
  loop
    Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.ActivatePrevious'}
    if ~instring('Object',Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.Caption'},1,1) or Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.Caption'} = SaveWin then
     break
    end
  end
 ! if window is absent, create new workbook
 if instring('Object',Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.Caption'},1,1)
   Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.Visible'}= 0
   Self.OleWindow $ Self.OleControl{'Application.WorkBooks.Add'}
 end
 Self.SheetName = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.ActiveSheet.Name'}

ExcelLink.SaveDoc    PROCEDURE
 code
 Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.Save'}

ExcelLink.SaveAsDoc  PROCEDURE(string FileName)
 code
 Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.SaveAs("' & clip(FileName)& '")'}

ExcelLink.PutToExcel   PROCEDURE(any TValue,short TRow,short TCol,<string TPicture>)
  code
 if TPicture <>''
   Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '").Cells('& TRow & ','& TCol & ').Value'}=Format(clip(TValue),clip(TPicture))
 else
   Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '").Cells('& TRow & ','& TCol & ').Value'}=TValue
 end


ExcelLink.GetFromExcel PROCEDURE(short TRow,short TCol,<string Tpicture>)
ReturnValue string(255)
 code
 if Tpicture <>''
  ReturnValue = format(Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '").Cells('& TRow & ','& TCol & ').Value'},clip(TPicture))
 else
  ReturnValue = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '").Cells('& TRow & ','& TCol & ').Value'}
 end
 return ReturnValue

ExcelLink.BrowseToExcelPrepare  PROCEDURE(byte ShowUI,byte ExportMode,Window TWindow,<BrowseClass BRW>,<Queue TBrowseQueue>,<short ListControl>)

TExportHeader   byte
TChangeDecimal  byte
TDocumentMode   byte
TFirstRowNum    short
TFirstColNum    short
TDocumentName   string(255)
TCurrentPosition byte


Window WINDOW('Export settings'),AT(,,265,191),FONT('MS Sans Serif',8,,FONT:regular,CHARSET:ANSI),CENTER, |
         SYSTEM,GRAY,DOUBLE,MODAL
       LIST,AT(3,6,257,77),USE(?List),VSCROLL,ALRT(MouseLeft2),FORMAT('300L(2)|I~Name~@s75@'),FROM(Self.Columns)
       OPTION('Document'),AT(3,87,157,64),USE(TDocumentMode),BOXED
         RADIO('Create new file'),AT(9,98),USE(?NewDocument:Radio),VALUE('1')
         RADIO('Current (opened) file'),AT(9,110),USE(?CurrentDocument:Radio),VALUE('3')
         RADIO('Open file'),AT(9,122,122,10),USE(?OpenDocument:Radio),VALUE('2')
       END
       GROUP('Starting position'),AT(164,87,97,64),USE(?Group1),BOXED
         PROMPT('Row:'),AT(173,119,31,10),USE(?PromptRow)
         SPIN(@n-7),AT(214,117,36,12),USE(TFirstRowNum),RANGE(1,32000),STEP(1)
         PROMPT('Col :'),AT(173,135),USE(?PromptCol)
         SPIN(@n-7),AT(214,133,36,12),USE(TFirstColNum),RANGE(1,32000),STEP(1)
         CHECK('Current'),AT(174,101,55,10),USE(TCurrentPosition)
       END
       BUTTON,AT(141,135,13,12),USE(?LookupFile),DISABLE,ICON(ICON:Open)
       GROUP,AT(3,151,157,36),USE(?Group3),BOXED
         CHECK('Replace decimal point by comma'),AT(9,172,144,10),USE(TChangeDecimal)
         CHECK('Export headers'),AT(9,161,145,10),USE(TExportHeader)
       END
       ENTRY(@s254),AT(9,135,127,11),USE(TDocumentName),DISABLE
       BUTTON('OK'),AT(164,173,47,14),USE(?OK)
       BUTTON('Cancel'),AT(214,173,47,14),USE(?Cancel)
     END


ReturnValue byte
Count       short

 code
 Self.BrowseWindow &=TWindow
 Self.ExportMode = ExportMode
 Self.BrowseQueue &= TBrowseQueue
 Self.BRW &=BRW
  if ExportMode = 1
    ! Export using BrowseClass
    Self.BrowseListControl  = BRW.ILC.GetControl()
  else
    ! Export using queue (handcoded browse)
    Self.BrowseListControl = ListControl
  end
  ! Build columns queue
  free(Self.Columns)
  count = 0
  SetTarget(Self.BrowseWindow)
  loop
    count+=1
    if ~Self.BrowseListControl{proplist:exists,count} then break.
    if Self.BrowseListControl{proplist:width,count} = 0
      Self.Columns.Export = 1
    else
      Self.Columns.Export = 2
    end
    Self.Columns.FieldName    = Self.BrowseListControl{proplist:header,Count}
    Self.Columns.FieldNo      = Self.BrowseListControl{proplist:FieldNo,Count}
    Self.Columns.FieldWidth   = Self.BrowseListControl{proplist:width,Count}
    Self.Columns.FieldPicture = Self.BrowseListControl{proplist:picture,Count}
    !if instring('@D',upper(ColumnsQueue.FieldPicture),1,1)
    ! Self.Columns.FieldPicture = '@d6.'
    !end
    Add(Self.Columns)
  end
  SetTarget
  if ShowUI
  ! show user interface for export settings
    TExportHeader    = Self.ExportHeader
    TChangeDecimal   = Self.ChangeDecimal
    TFirstRowNum     = Self.FirstRowNum
    TFirstColNum     = Self.FirstColNum
    TDocumentName    = Self.DocumentName
    TCurrentPosition = Self.CurrentPosition
    TDocumentMode    = Self.DocumentMode
    open(Window)
    ?List{Prop:IconList,1} = '~boxoff.ico'
    ?List{Prop:IconList,2} = '~boxon.ico'
    accept
      case event()
        of event:AlertKey
          if field()=?List
           get(Self.Columns,Choice(?list))
           if Self.Columns.Export = 2
            Self.Columns.Export = 1
           else
            Self.Columns.Export = 2
           end
           put(Self.Columns)
          end

        of event:accepted
          if TCurrentPosition
          disable(?TFirstRowNum)
          disable(?TFirstColNum)
          disable(?PromptRow)
          disable(?PromptCol)
        else
          enable(?TFirstRowNum)
          enable(?TFirstColNum)
          enable(?PromptRow)
          enable(?PromptCol)
        end
       if TDocumentMode=2
         enable(?TDocumentName)
         enable(?LookupFile)
       else
         disable(?TDocumentName)
         disable(?LookupFile)
       end
       case field()
         of ?LookupFile
           if FileDialog('Select Excel file',TDocumentName,,FILE:longname)
           end
         of ?OK
           Self.ExportHeader = TExportHeader
           Self.ChangeDecimal= TChangeDecimal
           Self.FirstRowNum  = TFirstRowNum
           Self.FirstColNum  = TFirstColNum
           Self.DocumentName = TDocumentName
           Self.CurrentPosition = TCurrentPosition
           Self.DocumentMode = TDocumentMode
           Case self.DocumentMode
            of 1
             Self.CreateNewDoc()
            of 2
             Self.OpenDoc(Self.DocumentName)
            of 3
             Self.SetCurrentDoc()
            end
           returnvalue = 1
           post(event:closewindow)
         of ?Cancel
           returnvalue = 0
           post(event:closewindow)
       end
       of event:closewindow
         break
      end
    end
    close(Window)
  else
    ReturnValue = 1
  end
  return ReturnValue


ExcelLink.BrowseToExcelStart    PROCEDURE
SavePosition string(1024)
CRow         short
CCol         short
ReturnValue  long
 code
 ReturnValue+=1
 if Self.CurrentPosition
  Self.FirstRowNum = Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.ActiveCell.Row'}
  Self.FirstColNum = Self.OleWindow $ Self.OleControl{'Application.ActiveWindow.ActiveCell.Column'}
 end
 CRow = Self.FirstRowNum
 if Self.ExportHeader
 CCol =Self.FirstColNum
   ReturnValue +=1
   loop i#=1 to records(Self.Columns)
     get(Self.Columns,i#)
     if Self.Columns.Export~=2 then cycle.
     Self.PutToExcel(clip(Self.Columns.FieldName),CRow,CCol)
     CCol+=1
   end
   CRow+=1
  end

 Case Self.ExportMode
   of 1
    ! export from BrowseClass
    Self.BRW.UpdateViewRecord
    SavePosition = position(Self.BRW.View)
    Self.BRW.Reset
    loop
      Res#=Self.BRW.Next()
      If Res#=Level:Notify or Res#=Level:Fatal then break.
      Self.BRW.SetQueueRecord
      Self.WriteBrowseRow(CRow,Self.FirstColNum)
      ReturnValue +=1
      Crow+=1
     end
     Reget(Self.BRW.View,Saveposition)
   of 2
    ! export from Queue
    loop i#=1 to records(Self.BrowseQueue)
      get(Self.BrowseQueue,i#)
      Self.WriteBrowseRow(CRow,Self.FirstColNum)
      ReturnValue +=1
      CRow+=1
    end
  end
  return Returnvalue


ExcelLink.WriteBrowseRow PROCEDURE(short CurrentRow,short CurrentCol)
WriteValue  string(255)
PPos        byte
TCol        short
  CODE
  TCol = CurrentCol
  loop k#=1 to records(Self.Columns)
    get(Self.Columns,k#)
    if Self.Columns.Export ~=2 then cycle.
    WriteValue = format(What(Self.BrowseQueue,Self.Columns.FieldNo),Self.Columns.FieldPicture)
    if numeric(clip(writeValue)) and Self.ChangeDecimal
    ! Change decimal point by decimal comma
      PPos = instring('.',clip(WriteValue),1,1)
      if PPos then WriteValue[PPos]=','.
    end
    if instring('@D',Upper(Self.Columns.FieldPicture),1,1)
      if day(WriteValue)<10
        WriteValue[1] ='0'
      end
    end
    Self.PutToExcel(clip(WriteValue),CurrentRow,TCol)
    TCol+=1
  end


ExcelLink.SetBrowseColumnName   PROCEDURE(byte ColNum,string HName)
 code
 get(Self.Columns,Colnum)
 if ~errorcode()
   Self.Columns.FieldName = HName
   put(Self.Columns)
 end

ExcelLink.SetBrowseColumnFormat PROCEDURE(byte ColNum,string HFormat)
 code
 get(Self.Columns,Colnum)
 if ~errorcode()
   Self.Columns.FieldPicture = HFormat
   put(Self.Columns)
 end

ExcelLink.AddColForExport      PROCEDURE(byte ColNum)
 code
 get(Self.Columns,Colnum)
 if ~errorcode()
   Self.Columns.Export = 2
   put(Self.Columns)
 end

ExcelLink.RemoveColFromExport   PROCEDURE(byte ColNum)
 code
 get(Self.Columns,Colnum)
 if ~errorcode()
   Self.Columns.Export = 1
   put(Self.Columns)
 end

ExcelLink.ProtectSheet   PROCEDURE(string password)
 code
 Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '").Protect(' & clip(password) & ')'}

ExcelLink.UnProtectSheet PROCEDURE(string password)
 code
 Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '").UnProtect(' & clip(password) & ')'}

ExcelLink.ConvertCellNotation PROCEDURE(short TRow,short TCol)
ReturnValue string(20)
FB          Decimal(10,2)
ABCString   string(26)
 code
 ABCString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 FB = round(TCol/26,1)
 if FB > 26
   ReturnValue = ABCString[FB] & ABCString[TCol-FB*26] & TRow
 else
   ReturnValue = ABCString[TCol-FB*26] & TRow
 end
 return ReturnValue

ExcelLink.SetFormula   PROCEDURE(short TRow,short Tcol,string Formulastring)
 code
 Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '").Cells('& TRow & ','& TCol & ').Formula'}=clip(FormulaString)

ExcelLink.GetFormula   PROCEDURE(short TRow,short Tcol)
ReturnValue string(100)
 code
 ReturnValue = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '").Cells('& TRow & ','& TCol & ').Formula'}
 return ReturnValue

ExcelLink.FindFirstEmptyRow PROCEDURE(short StartRow,short StartCol)
CurrentRow  short
ReturnValue short
 code
 CurrentRow = StartRow
 loop
   if Self.GetFromExcel(CurrentRow,StartCol)=''
     ReturnValue = CurrentRow
     break
   else
     CurrentRow+=1
   end
 end
 ReturnValue = CurrentRow
 return ReturnValue

ExcelLink.FindFirstEmptyCol PROCEDURE(short StartRow,short StartCol)
CurrentCol  short
ReturnValue short
 code
 CurrentCol = StartCol
 loop
   if Self.GetFromExcel(StartRow,CurrentCol)=''
     ReturnValue = CurrentCol
     break
   else
     CurrentCol+=1
   end
 end
 ReturnValue = CurrentCol
 return ReturnValue

ExcelLink.SetRange     PROCEDURE(short FirstRow,short FirstCol,<short EndRow>,<short EndCol>)
 code
 Self.ActiveRange = clip(Self.ConvertCellNotation(FirstRow,FirstCol)) & ':' & clip(Self.ConvertCellNotation(EndRow,EndCol))

ExcelLink.SetRange     PROCEDURE(string RangeString)
 code
 Self.ActiveRange = clip(RangeString)

ExcelLink.SetColumnWidth    PROCEDURE(short ColumnWidth)
Object  cstring(40)
 code
 if Self.ActiveRange <>''
  Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '").Columns'}
  if object <> ''
   Self.OleWindow $ Self.OleControl{clip(Object) & '.ColumnWidth'}=ColumnWidth
   Self.OleWindow $ Self.OleControl{prop:release}=object
  end
 end

ExcelLink.SetRowHeight      PROCEDURE(short RowHeight)
Object  cstring(40)
 code
 if Self.ActiveRange <>''
  Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '").Rows'}
  if object <> ''
    Self.OleWindow $ Self.OleControl{clip(Object) & '.RowHeight'}=RowHeight
    Self.OleWindow $ Self.OleControl{prop:release}=object
  end
 end

ExcelLink.SetColumnAutoFit  PROCEDURE
Object  cstring(40)
 code
 if Self.ActiveRange <>''
  Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '").Columns'}
  if object <> ''
   Self.OleWindow $ Self.OleControl{clip(Object) & '.AutoFit'}
   Self.OleWindow $ Self.OleControl{prop:release}=object
  end
 end

ExcelLink.SetRowAutoFit     PROCEDURE
Object  cstring(400)
 code
 if Self.ActiveRange <>''
  Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '").Rows'}
  if object <> ''
   Self.OleWindow $ Self.OleControl{clip(Object) & '.AutoFit'}
   Self.OleWindow $ Self.OleControl{prop:release}=object
  end
 end

ExcelLink.SetFont           PROCEDURE(byte FontItalic,byte FontBold,byte FontSize,string FontName)
object cstring(40)
 code
 if Self.ActiveRange <>''
  Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '").Font'}
  if object <>''
   Self.OleWindow $ Self.OleControl{clip(object) &'.Italic'} = FontItalic
   Self.OleWindow $ Self.OleControl{clip(object) &'.Bold'}   = FontBold
   Self.OleWindow $ Self.OleControl{clip(object) &'.Size'}   = Fontsize
   Self.OleWindow $ Self.OleControl{clip(object) &'.Name'}   = Fontname
   Self.OleWindow $ Self.OleControl{prop:release}=object
  end
 end

ExcelLink.SetLocked         PROCEDURE
object cstring(40)
 code
 if Self.ActiveRange <>''
  Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '")'}
  if object <> ''
   Self.OleWindow $ Self.OleControl{clip(Object) & '.Locked'} = 1
   Self.OleWindow $ Self.OleControl{prop:release}=object
  end
 end

ExcelLink.SetUnLocked       PROCEDURE
object cstring(40)
 code
 if Self.ActiveRange <>''
  Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '")'}
  if object <> ''
   Self.OleWindow $ Self.OleControl{clip(Object) & '.Locked'} = 0
   Self.OleWindow $ Self.OleControl{prop:release}=object
  end
 end

ExcelLink.SetColor          PROCEDURE(<long BorderColor>,<long FontColor>,<long CellColor>)
object cstring(40)
 code
 if Self.ActiveRange <>''
   Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '")'}
   if object <>''
     if ~omitted(1)
      Self.OleWindow $ Self.OleControl{clip(Object) & '.Borders.Color'}= BorderColor
     end
     if ~omitted(2)
      Self.OleWindow $ Self.OleControl{clip(Object) & '.Font.Color'}= FontColor
     end
     if ~omitted(3)
      Self.OleWindow $ Self.OleControl{clip(Object) & '.Interior.Color'}= CellColor
     end
     Self.OleWindow $ Self.OleControl{prop:release}=object
   end
 end

ExcelLink.SetBorder        PROCEDURE(long LineStyle,long LineWidth)
object cstring(40)
 code
 if Self.ActiveRange <>''
  Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '")'}
  if object <>''
   Self.OleWindow $ Self.OleControl{clip(Object) & '.Borders.LineStyle'}= LineStyle
   Self.OleWindow $ Self.OleControl{clip(Object) & '.Borders.Weight'}= LineWidth
   Self.OleWindow $ Self.OleControl{prop:release}=object
  end
 end

ExcelLink.PrintOut  PROCEDURE(byte PrintSource,<short FromPage>,<short ToPage>,<short Copies>,<byte Preview>,<string ActivePrinter>)
! PrintSource = 1 - print Workbook
! PrintSource = 2 - print Active sheet
! PrintSource = 3 - print Active Range
object cstring(40)
sPrintParameters cstring(100)
 code
 ! from page
 if FromPage <> 0
  sPrintParameters = clip(sPrintParameters) & FromPage
 else
 end
 ! to page
 if ToPage <> 0
  sPrintParameters = clip(sPrintParameters) & ',' & ToPage
 else
  sPrintParameters = clip(sPrintParameters) & ','
 end
 ! copies
 if copies <> 0
  sPrintParameters = clip(sPrintParameters) & ',' & Copies
 else
  sPrintParameters = clip(sPrintParameters) & ','
 end
 ! preview
 if ~omitted(5)
   sPrintParameters = clip(sPrintParameters) & ',' & Preview
 else
   sPrintParameters = clip(sPrintParameters) & ','
 end
 ! active printer
 if ~omitted(6) and ActivePrinter <>''
  sPrintParameters = clip(sPrintParameters) & ',' & ActivePrinter
 else
 end
 case PrintSource
   of 1
    Object = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook'}
   of 2
    Object = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.ActiveSheet'}
   of 3
    if Self.ActiveRange <> ''
      Object = Self.OleWindow $ Self.OleControl{'Application.WorkSheets("'& clip(Self.SheetName) & '")' & '.Range("' & clip(Self.ActiveRange) & '")'}
    end
 end
 if Object <> ''
  Self.OleWindow $ Self.OleControl{clip(object) & '.PrintOut('& sPrintParameters & ')'}
  Self.OleWindow $ Self.OleControl{prop:release}=object
 end

ExcelLink.SetMargins PROCEDURE(byte InchOrCm,real leftMargin,real RightMargin,real TopMargin,real BottomMargin)
! InchOrCm = 1 - inch
! InchOrCm = 2 - cm
s1  cstring(20)
s2  cstring(20)
s3  cstring(20)
s4  cstring(20)
object cstring(40)
 code 
 ! convert to points
 case InchorCm
   of 1  
    s1 = Self.InchesToPoints(LeftMargin)
    s2 = Self.InchesToPoints(RightMargin)
    s3 = Self.InchesToPoints(TopMargin)
    s4 = Self.InchesToPoints(BottomMargin)
   of 2
    s1 = Self.CentimetersToPoints(LeftMargin)
    s2 = Self.CentimetersToPoints(RightMargin)
    s3 = Self.CentimetersToPoints(TopMargin)
    s4 = Self.CentimetersToPoints(BottomMargin)
 end
 object = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.ActiveSheet.PageSetup'}
 if object <> ''
  Self.OleWindow $ Self.OleControl{clip(object) & '.LeftMargin'}=s1
  Self.OleWindow $ Self.OleControl{clip(object) & '.RightMargin'}=s2
  Self.OleWindow $ Self.OleControl{clip(object) & '.TopMargin'}=s3
  Self.OleWindow $ Self.OleControl{clip(object) & '.BottomMargin'}=s4
  Self.OleWindow $ Self.OleControl{prop:release}=object
 end


ExcelLink.InchesToPoints PROCEDURE(real value)
 code
 return Self.OleWindow $ Self.OleControl{'Application.InchesToPoints('& value & ')'}

ExcelLink.CentimetersToPoints PROCEDURE(real value)
 code
 return Self.OleWindow $ Self.OleControl{'Application.CentimetersToPoints('& value & ')'}


ExcelLink.SetPaperSize PROCEDURE(byte PaperSize)
object cstring(40)
 code
 object = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.ActiveSheet.PageSetup'}
 if object <>''
  Self.OleWindow $ Self.OleControl{clip(object) & '.PaperSize'}=PaperSize
  Self.OleWindow $ Self.OleControl{prop:release}=object
 end

ExcelLink.SetFitToPages PROCEDURE(short FitToPagesWide,short FitToPagesTall)
object cstring(40)
 code
 object = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.ActiveSheet.PageSetup'}
 if object <>'' and FitToPagesWide <> 0 and FitToPagesTall <> 0
  Self.OleWindow $ Self.OleControl{clip(object) & '.FitToPagesWide'}=FitToPagesWide
  Self.OleWindow $ Self.OleControl{clip(object) & '.FitToPagesTall'}=FitToPagesTall
  Self.OleWindow $ Self.OleControl{prop:release}=object
 end


ExcelLink.SetOrientation PROCEDURE(byte PaperOrientation)
object cstring(40)
 code
 object = Self.OleWindow $ Self.OleControl{'Application.ActiveWorkBook.ActiveSheet.PageSetup'}
 if object <>''
  Self.OleWindow $ Self.OleControl{clip(object) & '.Orientation'}=PaperOrientation
  Self.OleWindow $ Self.OleControl{prop:release}=object
 end