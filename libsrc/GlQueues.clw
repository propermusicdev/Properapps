!VAT Queue
VatQue  QUEUE,PRE(VATQ),external,dll(dll_mode)
Code      BYTE!LIKE(VAT:Code)
Vat       DECIMAL(5,2)!LIKE(VAT:Vat)
        END


!Discount Queue
DiscountQue QUEUE,PRE(DISQ),external,dll(dll_mode)
Code          CSTRING(2)!LIKE(DIS:Code)
Discount      DECIMAL(5,2)!LIKE(DIS:Discount)
            END


!Product Database Queue
DatabaseQue QUEUE,PRE(DATQ),external,dll(dll_mode)
Code          CSTRING(4)!LIKE(DAT:Code)
Name          CSTRING(21)!LIKE(DAT:Name)
DefaultDept   CSTRING(2)!LIKE(DAT:DefaultDept)
            END

! Markup Matrix
MarkupMatrixQue QUEUE,PRE(MARQ),external,dll(dll_mode)
SupplierCode   CSTRING(6)!LIKE(SUP:Code)
Rate           DECIMAL(10,4)!LIKE(MAR:ExchangeRate)
Shipping       DECIMAL(7,2)!LIKE(MAR:Shipping)
Margin         DECIMAL(6,2)!LIKE(MAR:Margin)
             END

! Format Exception Matrix
FormatExceptionMatrixQue QUEUE,PRE(FEMQ),external,dll(dll_mode)
SupplierCode   CSTRING(6)!LIKE(SUP:Code)
Format         CSTRING(6)!LIKE(FEM:Format)
Margin         DECIMAL(6,2)!LIKE(FEM:Margin)
             END
