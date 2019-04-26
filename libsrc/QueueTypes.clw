! Consignment Order Process Queue
TConsignmentOrderQu      QUEUE,Type
Catalog                    STRING(21)
Catalog_NormalFG           LONG
Catalog_NormalBG           LONG
Catalog_SelectedFG         LONG
Catalog_SelectedBG         LONG
Artist                     STRING(30)
Title                      STRING(30)
OpenStock                  STRING(20)
OpenStock_NormalFG         LONG
OpenStock_NormalBG         LONG
OpenStock_SelectedFG       LONG
OpenStock_SelectedBG       LONG
Purchased                  STRING(20)
Purchased_NormalFG         LONG
Purchased_NormalBG         LONG
Purchased_SelectedFG       LONG
Purchased_SelectedBG       LONG
Sales                      STRING(20)
Sales_NormalFG             LONG
Sales_NormalBG             LONG
Sales_SelectedFG           LONG
Sales_SelectedBG           LONG
Returns                    STRING(20)
Returns_NormalFG           LONG
Returns_NormalBG           LONG
Returns_SelectedFG         LONG
Returns_SelectedBG         LONG
Promo                      STRING(20)
Promo_NormalFG             LONG
Promo_NormalBG             LONG
Promo_SelectedFG           LONG
Promo_SelectedBG           LONG
Returned                   STRING(20)
Returned_NormalFG          LONG
Returned_NormalBG          LONG
Returned_SelectedFG        LONG
Returned_SelectedBG        LONG
CloseStock                 STRING(20)
CloseStock_NormalFG        LONG
CloseStock_NormalBG        LONG
CloseStock_SelectedFG      LONG
CloseStock_SelectedBG      LONG
SalePrice                  STRING(20)
SalePrice_NormalFG         LONG
SalePrice_NormalBG         LONG
SalePrice_SelectedFG       LONG
SalePrice_SelectedBG       LONG
ReturnPrice                STRING(20)
ReturnPrice_NormalFG       LONG
ReturnPrice_NormalBG       LONG
ReturnPrice_SelectedFG     LONG
ReturnPrice_SelectedBG     LONG
SalesNet                   STRING(20)
SalesNet_NormalFG          LONG
SalesNet_NormalBG          LONG
SalesNet_SelectedFG        LONG
SalesNet_SelectedBG        LONG
BasilOpen		   STRING(20)
BasilClose		   STRING(20)
BasilClose_NormalFG        LONG
BasilClose_NormalBG        LONG
BasilClose_SelectedFG      LONG
BasilClose_SelectedBG      LONG
BasilSalesNet		   STRING(20)
DontLoadFlag		   LONG
ErrorMessage		   STRING(255)
ProductId		   LONG
ForceDiscountToApply	   BYTE
CreatedSourceId		   LONG
                         END

! EDI Manager Scaleout Queue
TScaleoutQu      	 QUEUE,Type
Marker                     BYTE
Selecter                   BYTE
Selecter_Icon              LONG
Status                     BYTE
Status_Icon                LONG !Entry's icon ID
Processed                  BYTE
Processed_Icon             LONG !Entry's icon ID
Account                    CSTRING(36)
ShowAccount                STRING(20)
Account_NormalFG           LONG !Normal forground color
Account_NormalBG           LONG !Normal background color
Account_SelectedFG         LONG !Selected forground color
Account_SelectedBG         LONG !Selected background color
TransRef                   CSTRING(21) !Transmission Reference
TransDate                  CSTRING(11)
TransTime                  CSTRING(11)
OrderNo                    CSTRING(18)
SplitComment               CSTRING(21)
ArtistTitle                CSTRING(31) !Artist-Title
CatNo                      CSTRING(31)
CatNo_NormalFG             LONG !Normal forground color
CatNo_NormalBG             LONG !Normal background color
CatNo_SelectedFG           LONG !Selected forground color
CatNo_SelectedBG           LONG !Selected background color
SPrice                     STRING(10)
Ordered                    LONG !Number Ordered
Stock                      LONG !Current Stock
QtyInOpenBatches	   LONG
PickType                   SHORT(0) !Replenishment (1), new release(2), campaign(3)
DeliveryType               SHORT
DisplayDeliveryType        STRING(12)
ReleaseDate                DATE
ReleaseDateAll		   DATE
Notes                      STRING(40)
Mark                       BYTE !Entry's marked status
                         END

! Inventory Exclusion List
TExcluListQu		 QUEUE,Type
ListItem                   STRING(20)
Active			   LONG
Active_Icon                LONG
Mark                       BYTE !Entry's marked status
ItemValue		   LONG
                         END

! Rovi info Overrides
TRoviOverrideQu		 QUEUE,Type
OverrideItem               STRING(20)
Active			   LONG
Active_Icon                LONG
Mark                       BYTE !Entry's marked status
                         END

