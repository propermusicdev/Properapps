MaxShelvesCount        Equate(12)
BinLoc:MaxBays         Equate(24)		!CANNOT I REPEAT CANNOT BE MORE THAN 24. I SWEAR. IF YOU CHANGE IT...
BinLoc:DefaultMaxBays  Equate(14)

MOVELIST_Entered   Equate(0)
MOVELIST_Processed Equate(1)

TBayQueue            QUEUE,Type
BayBoxControl           LONG
ShelfSpaced             Byte,Dim(12)
ShelfStored             String(12)
ShelfCodes              String(12)
BinWidth                BYTE,DIM(12,9)
BinCapacity             LONG,DIM(12,9)
BinProductID            ULONG,DIM(12,9)
BinQty                  LONG,DIM(12,9)
BayCode                 CSTRING(4)
RowCode                 CSTRING(3)
BayX                    Long
BayY                    Long
BayW                    Long
BayH                    Long
BinType                 Byte
BinRestock              BYTE,DIM(12,9)
BinMinLevel             Long,DIM(12,9)
BinMulti                BYTE,DIM(12,9)
Stretched               Byte
BinLocked               BYTE,DIM(12,9)
                     END

TBinProductQueue  Queue,Type
SrcBinCode           CString(6)
ProductName          CString(61)
Qty                  Long
DstBinCode           CString(6)
ProductID            ULong
Removelink           Byte
                  End

! To pick Product from bins
TProductBinsQueue Queue,Type
ID                   ULong ! Any ID to identify line (for example OrderLineID)
ProductID            ULong
RequiredQty          Long
PickedQty            Long
BinCodes             CString(1025)
                  End

! For a work with update of WH bin location stock
TwOrderLineId	   Queue
wOrderLineId         ULONG
                   End

! For a work with bincodes and qantuties in pick list line
TPickingBinsQueue  Queue
BinCode              CString(6)
QtyToPick            Long
QtyPicked            Long
                   End

! For getting product stock history
TProductStockHistoryQueue  Queue
DocType                       CString(21)
Icon                          Short
DocDate                       Date
Description_1		      CString(61)
Description                   CString(61)
SrcBinCode                    CString(6)
DstBinCode                    CString(6)
Qty                           Long
SpareText1                    CString(61)
SpareText2                    CString(61)
SpareText3                    CString(61)
SpareText4                    CString(61)
SpareText5                    CString(61)
DocTime                       Time
                           End

TBinHistoryQu			QUEUE, TYPE
DocType					CSTRING(21)
DocType_Icon				LONG
DocDate					DATE
DocTime					TIME
SupplierCat				CSTRING(21)
Artist					CSTRING(41)
Title					CSTRING(41)
Description_1				CSTRING(255)
Description_2				CSTRING(255)
SrcBinCode				CSTRING(6)
DstBinCode				CSTRING(6)
SignedQty				LONG
UnsignedQty				LONG
SpareText1                    		CSTRING(61)
SpareText2                    		CSTRING(61)
SpareText3                    		CSTRING(61)
SpareText4                    		CSTRING(61)
SpareText5                    		CSTRING(61)
ProductId				LONG
				END

TBinQueue  	Queue,Type
BinCode       		CString(6)
MinQty        		Long
MaxQty        		Long
Qty           		Long
Type          		CString(11)
TempQty1      		Long
FromMulti     		Byte
SortBincode   		CString(11)
TempQty2      		Long
ReturnsSortOrder	LONG
           	End

TEditShelfGroup Group,Type
Spaced             Byte,Dim(12)
Stored             Byte,Dim(12)
BinWidth           Byte,Dim(12,9)
BinCapacity        Long,Dim(12,9)
BinRestock         Byte,Dim(12,9)
BinMinLevel        Long,Dim(12,9)
BinType            Byte
BinMulti           Byte,Dim(12,9)
Stretched          Byte
BinLocked	   Byte,Dim(12,9)
                End

TEnumSector     Queue
Spaced             Byte
Chars              Cstring(128)
Back               Byte
                End

TMultiProductQueue  Queue
Rec                    Like(WHBP:Record)
                    End

TBayCodeQueue       Queue
BayCode                CString(4)
                    End

TBaySortOrder     Queue,Type
RowandBay             CString(3)
BayOrder              CSTring(5)
                   End

TPickingTicketQu         QUEUE,Type
PT:CatNo                   STRING(21)
PT:CatNo_NormalFG          LONG !Normal forground color
PT:CatNo_NormalBG          LONG !Normal background color
PT:CatNo_SelectedFG        LONG !Selected forground color
PT:CatNo_SelectedBG        LONG !Selected background color
PT:ArtistTitle             STRING(30)
PT:ArtistTitle_NormalFG    LONG !Normal forground color
PT:ArtistTitle_NormalBG    LONG !Normal background color
PT:ArtistTitle_SelectedFG  LONG !Selected forground color
PT:ArtistTitle_SelectedBG  LONG !Selected background color
PT:QtyOrdered              USHORT
PT:QtyOrdered_NormalFG     LONG !Normal forground color
PT:QtyOrdered_NormalBG     LONG !Normal background color
PT:QtyOrdered_SelectedFG   LONG !Selected forground color
PT:QtyOrdered_SelectedBG   LONG !Selected background color
PT:QtyPicked               USHORT
PT:QtyPicked_NormalFG      LONG !Normal forground color
PT:QtyPicked_NormalBG      LONG !Normal background color
PT:QtyPicked_SelectedFG    LONG !Selected forground color
PT:QtyPicked_SelectedBG    LONG !Selected background color
PT:QtyPacked               USHORT
PT:QtyPacked_NormalFG      LONG !Normal forground color
PT:QtyPacked_NormalBG      LONG !Normal background color
PT:QtyPacked_SelectedFG    LONG !Selected forground color
PT:QtyPacked_SelectedBG    LONG !Selected background color
PT:StockLocations          STRING(1024)
PT:Barcode                 STRING(30)
PT:ProductId               LONG
PT:PickListId              ULONG
PT:CAuditId                ULONG
                         END

TShortageReportQu	QUEUE(TPickingTicketQu),TYPE
PT:SpareField1		   STRING(1024)
PT:SpareField2		   STRING(1024)
PT:SpareField3		   STRING(1024)
			END


TPrintingPicklistQu		QUEUE, TYPE
wOrderLineId				ULONG
BinCodes				STRING(1024)
QtyToPick				LONG
QtyPicked				LONG
ProgressQtyPicked			LONG
BinCode                 		CSTRING(6)
SortBinCode             		CSTRING(11)
ProductID               		LONG
wOrderID                		ULONG
Artist                  		STRING(50)
Title					STRING(50)
Barcode					STRING(13)
SupplierCat				STRING(50)
PickZoneSort            		CSTRING(255)
Zone:PickingZoneId      		ULONG
Zone:Name               		STRING(255)
Zone:SortOrder          		LONG
Zone:PrintingGroup      		STRING(20)
Format:WarehouseFormatGroup 		STRING(20)
BarcodeId				ULONG
				END



TMoveListQu		QUEUE, TYPE
ProductId			LONG
SupplierCat			STRING(40)
SrcBin				STRING(5)
DstBin				STRING(5)
Qty				LONG
RemoveLink			BYTE
MoveListType			BYTE !Only applies the first one it comes to.
			END

TExtendedBinQu	QUEUE(TBinQueue), TYPE
Zone              STRING(10)
Category          STRING(20)
External          BYTE
BinType           BYTE
PickOrder         BYTE
QtyAdjusted       LONG
Category2	  STRING(20)
Category3	  STRING(20)
Category4	  STRING(20)
Category5	  STRING(20)
AllCategories	  STRING(150)
                END


!--Stock work and stock work movements
STOCKWORK::LOCTYPE::ZONE			EQUATE(0)
STOCKWORK::LOCTYPE::LOCATION			EQUATE(1)
STOCKWORK::LOCTYPE::CATEGORY			EQUATE(2)
STOCKWORK::LOCTYPE::BIN				EQUATE(3)

STOCKWORK::STATUS::ENTERED			EQUATE(0)
STOCKWORK::STATUS::WAITING			EQUATE(1)
STOCKWORK::STATUS::MOVES_CREATED		EQUATE(2)
STOCKWORK::STATUS::COMPLETED			EQUATE(3)
STOCKWORK::STATUS::EXPIRED			EQUATE(4)

STOCKWORKMOVE::STATUS::CREATED			EQUATE(0)
STOCKWORKMOVE::STATUS::WAITING			EQUATE(1)
STOCKWORKMOVE::STATUS::READY			EQUATE(2)
STOCKWORKMOVE::STATUS::ON_MOVELIST		EQUATE(3)
STOCKWORKMOVE::STATUS::MOVELIST_PROCESSED	EQUATE(4)


STOCKWORK::WORKTYPE::WORKTYPE_MASK		EQUATE(0000000000000000000011111111b) !
STOCKWORK::WORKTYPE::OVERSTOCKS			EQUATE(0000000000000000000000000001b) !1
STOCKWORK::WORKTYPE::UNDERSTOCKS		EQUATE(0000000000000000000000000010b) !2
STOCKWORK::WORKTYPE::MOVE			EQUATE(0000000000000000000000000100b) !4
STOCKWORK::WORKTYPE::KEEP			EQUATE(0000000000000000000000001000b) !8
STOCKWORK::WORKTYPE::MAKE_SURE			EQUATE(0000000000000000000000010000b) !16
STOCKWORK::WORKTYPE::LEAVE_AT_SRC		EQUATE(0000000000000000000000100000b) !32

STOCKWORK::WORKTYPE::MOVETYPE_MASK		EQUATE(0000000000001111111100000000b) !
STOCKWORK::WORKTYPE::MOVE_ALL			EQUATE(0000000000000000000100000000b) !256
STOCKWORK::WORKTYPE::FILL_BINS			EQUATE(0000000000000000001000000000b) !512
STOCKWORK::WORKTYPE::USE_FIRST_BIN		EQUATE(0000000000000000010000000000b) !1024
STOCKWORK::WORKTYPE::DO_NOT_FIND_DST		EQUATE(0000000000000000100000000000b) !2048

STOCKWORK::WORKTYPE::OPTIONS_MASK		EQUATE(0000111111110000000000000000b) !
STOCKWORK::WORKTYPE::OPT:FAULTIES		EQUATE(0000000000010000000000000000b) !65536		
STOCKWORK::WORKTYPE::OPT:REFURB			EQUATE(0000000000100000000000000000b) !131072
STOCKWORK::WORKTYPE::OPT:FIND_EMPTY		EQUATE(0000000001000000000000000000b) !262144

TOffsiteStockQu     QUEUE,TYPE		!You spelled offsite wrong. You dumb-dumb.
StockLocation        CSTRING(21)                           !Stock Location
StockLocation_Icon   LONG
AccountName          CSTRING(31)                           !Name
Status		     STRING(50)
Options		     STRING(20)				   !E = Export, P = Priority
PickListDate         STRING(10)                            !
PickListTime         STRING(8)                             !
OrderReference       CSTRING(21)                           !OrderReference
SupplierCat          CSTRING(22)                           !Supplier Catalogue Number
Artist               CSTRING(31)                           !Artist
Title                CSTRING(31)                           !Title
Format		     CSTRING(6)
QtySupplied          USHORT                                !Quantity Supplied
QtyPicked            USHORT                                !
QtyOffsite           LONG                                  !
BinCodes             CSTRING(1025)                         !String of bin codes and qties in the followinf format: 1BDH2=26;2DEG5=23
PickingListNote      CSTRING(501)                          !
BinGroup	     CSTRING(256)
AllBinCodes          CSTRING(1025)                         !String of bin codes and qties in the followinf format: 1BDH2=26;2DEG5=23
TheirReference       CSTRING(31)                           !Their Reference - Exported into Sage
EAN                  STRING(13)                            !Barcode stored as a 13 digit EAN Barcode
Supplier             CSTRING(9)                            !Sage Supplier Code
AccountCode	     CSTRING(11)			   !Proper Order Headers. Account Code
RecordType	     STRING(1)
                   END 





	ITEMIZE, PRE(STOCKWORK:FETCHTYPE)
LOC_TYPE		EQUATE(0)
WORK_STATUS		EQUATE
MOVEMENT_STATUS		EQUATE
WORK_TYPE		EQUATE
	END

TPickListQueue  QUEUE,TYPE
PickListID        ULONG
                END

TDespatchQueue  QUEUE,TYPE
DespatchID         ULONG
                END

TPrintBinCodesQu	QUEUE, TYPE
BinCode				STRING(5)
SortOrder			DECIMAL(10,2)
			END	

TBinChecker::ConfirmItemGroup	GROUP, TYPE
CatNum               			STRING(22)                            !
Artist               			STRING(50)                            !
Title                			STRING(50)                            !
Qty                  			LONG                                  !
QtyChecked            			LONG
ProductID            			ULONG                                 !
Format               			CSTRING(6) 
				END


TArrowChoiceGroup     GROUP,TYPE 
Arrow1               BYTE                                  !
Arrow2               BYTE                                  !
Arrow3               BYTE                                  !
Arrow4               BYTE                                  !
Arrow5               BYTE(1)                               !
                     END 