! ExcelLink wrapper class

 include('abbrowse.inc')
ColumnsQueue         QUEUE,type
FieldName            STRING(50)
Export               BYTE
FieldNo              SHORT
FieldWidth           SHORT
FieldPicture         STRING(20)
                     END

! Excel constants 
! line style and weight
xlNormal        equate(0)
xlDash          equate(-4115)
xlDashDot       equate(4)
xlDashDotDot    equate(5)
xlDot           equate(-4118)
xlDouble        equate(-4119)
xlLineStyleNone equate(-4142)
xlSlantDashDot  equate(13)

!Weight
xlHairLine equate(1)
xlThin     equate(2)
xlMedium   equate(-4138)
xlThick    equate(4)

! window state
xlMaximized       equate(-4137)
xlMinimized       equate(-4140)
xlNormalState     equate(-4143)

! print settings
! orientation
xlPortrait        equate(1)
xlLandscape       equate(2)
! paper size
xlPaperA4         equate(9)
xlPaperA5         equate(11)
xlPaperA3         equate(8)
xlPaperB4         equate(12)
xlPaperB5         equate(13)
xlPaperLetter     equate(1)
xlPaperLegal      equate(5)


ExcelLink class,type,module('excel.clw'),LINK('excel.CLW',1),DLL(_ABCDllMode_)
OleControl   unsigned      ! ole control for Excel
OleWindow         &Window       ! window where OLE control is created
DocumentMode   byte          ! 1 - create new, 2 - open using DocumentName, 3 - use current (opened in Excel)
DocumentName   cstring(200)  ! Excel filename
SheetName      cstring(50)   ! current Excel sheet
! these properties are used during BrowseToExcel
BRW             &BrowseClass
ProgressWindow  &Window
ProgressControl unsigned
Columns        &ColumnsQueue
BrowseWindow   &Window
BrowseQueue        &Queue
BrowseListControl  unsigned
ExportHeader   byte     ! true - export header's names
ChangeDecimal  byte
FirstRowNum    short    ! First row for export
FirstColNum    short    ! First col for export
ExportMode     byte     ! 1-
ActiveRange    string(50)
CurrentPosition byte
Init  PROCEDURE,byte,proc
Init  PROCEDURE(Window TWindow),byte,proc
Kill  PROCEDURE
Construct PROCEDURE,proc
Destruct  PROCEDURE,proc
SetVisible PROCEDURE(byte Visible,<long ApplicationWindowState>,<long ActiveWindowState>),proc
Close      PROCEDURE,proc
CreateNewDoc   PROCEDURE,proc
OpenDoc        PROCEDURE(string TFileName),proc
SetCurrentDoc  PROCEDURE,proc
SaveDoc        PROCEDURE,proc
SaveAsDoc      PROCEDURE(string FileName),proc
ProtectSheet   PROCEDURE(string password),proc
UnProtectSheet PROCEDURE(string password),proc
PrintOut     PROCEDURE(byte PrintSource,<short FromPage>,<short ToPage>,<short Copies>,<byte Preview>,<string ActivePrinter>),proc

ConvertCellNotation PROCEDURE(short TRow,short TCol),string ! convert from numbers to string (for example 1,1 to A1)
! these methods are used with single cell (get/put data/formula)
PutToExcel   PROCEDURE(any TValue,short TRow,short TCol,<string TPicture>),proc ! Put data to excel cell
GetFromExcel PROCEDURE(short TRow,short TCol,<string TPicture>),string            ! Get data from Excel Cell
SetFormula   PROCEDURE(short TRow,short Tcol,string Formulastring),proc ! set formula for the current cell
GetFormula   PROCEDURE(short TRow,short Tcol),string                    ! get formula for the current cell
! find first empty cells
FindFirstEmptyRow PROCEDURE(short StartRow,short StartCol),short ! find first empty row
FindFirstEmptyCol PROCEDURE(short StartRow,short StartCol),short ! find first empty col
! these methods are used for page setup before printing. All settings work for active sheet
SetMargins PROCEDURE(byte InchOrCm,real leftMargin,real RightMargin,real TopMargin,real BottomMargin),proc ! set paper's margins
SetPaperSize PROCEDURE(byte PaperSize),proc
SetFitToPages PROCEDURE(short FitToPagesWide,short FitToPagesTall),proc
SetOrientation PROCEDURE(byte PaperOrientation)
InchesToPoints PROCEDURE(real value),string ! convert to points from inches
CentimetersToPoints PROCEDURE(real value),string ! convert to points from centimeters
! these methods are used for setting the active range of the cells (or single cell)
SetRange     PROCEDURE(short FirstRow,short FirstCol,<short EndRow>,<short EndCol>) ! set range as numbers,for example 1,1,10,1
SetRange     PROCEDURE(string RangeString)  ! set range as string ,for example "a1:a10"
! these methods work with Active Range (format etc)
SetColor          PROCEDURE(<long BorderColor>,<long FontColor>,<long CellColor>),proc
SetBorder         PROCEDURE(long LineStyle,long LineWidth),proc
SetColumnWidth    PROCEDURE(short ColumnWidth),proc  ! set width for all columns in the current range
SetRowHeight      PROCEDURE(short RowHeight),proc ! set height for all rows in the current range
SetColumnAutoFit  PROCEDURE,proc ! set autofit for all columns in the current range
SetRowAutoFit     PROCEDURE,proc ! set autofit for all rows in the current range
SetFont           PROCEDURE(byte FontItalic,byte FontBold,byte FontSize,string FontName),proc
SetLocked         PROCEDURE,proc ! set locked property for the active range (all cells)
SetUnLocked       PROCEDURE,proc ! set ulocked property for the active range (all cells)
! these methods are used for Export from Browse
BrowseToExcelPrepare  PROCEDURE(byte ShowUI,byte ImportMode,Window TWindow,<BrowseClass BRW>,<Queue TBrowseQueue>,<short ListControl>),byte
BrowseToExcelStart    PROCEDURE,long,proc  ! start export from browse to excel
WriteBrowseRow        PROCEDURE(short CurrentRow,short CurrentCol),proc ! write current browse record to Excel
SetBrowseColumnName   PROCEDURE(byte ColNum,string HName),proc   ! set column's name for particular column
SetBrowseColumnFormat PROCEDURE(byte ColNum,string HFormat),proc ! set format for particular column
AddColForExport       PROCEDURE(byte ColNum),proc ! add column to excel export
RemoveColFromExport   PROCEDURE(byte ColNum),proc ! remove column from excel export
 end