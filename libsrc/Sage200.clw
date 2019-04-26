!Sage 200 equates and qu types
TProductUpdateQu	QUEUE,TYPE
ProductId		  LONG
UpdateFields		  BYTE(1)
DateReleased		  DATE
Artist			  STRING(30)
Title			  STRING(30)
AnalysisCode		  STRING(20)
Barcode			  STRING(30)
Commodity		  STRING(20)
UpdatePrices		  BYTE(1)
Price1			  DECIMAL(7,2)
Price2			  DECIMAL(7,2)
Price3			  DECIMAL(7,2)
Price4			  DECIMAL(7,2)
Price5			  DECIMAL(7,2)
LocalPrice 	          DECIMAL(7,2) !Sterling Buy Price
DeletionType		  BYTE(0)
UpdateNominals		  BYTE(0)
Nominal_1		  STRING(10)
Nominal_2		  STRING(10)
Nominal_3		  STRING(10)
MCPSPercentage		  DECIMAL(9,5)
PromoItem		  BYTE
			END


SAGE200_NOMINAL_1_USAGE_ID  	EQUATE(0)
SAGE200_NOMINAL_2_USAGE_ID  	EQUATE(3)
SAGE200_NOMINAL_3_USAGE_ID  	EQUATE(1)



	
