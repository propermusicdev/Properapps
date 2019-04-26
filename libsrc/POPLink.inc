!Generated .INC file (by the EasyCOM2INC v 2.13)
!IDL filename: PopLink.idl

!*********** Interfaces ***********
!IDispatch
!IUnknown
!_PurchaseOrderCSVLoad
!*********** End of Interfaces ***********

!*********** Data types ***********
!*********** End of Data types ***********


!*********** interfaces ***********
IID__PurchaseOrderCSVLoad       GROUP
data1                             LONG(5056C927H)
data2                             SHORT(44A9H)
data3                             SHORT(4970H)
data4                             STRING('<0B7H><0BH><76H><0ACH><0E0H><97H><0CDH><4CH>')
                                END
_PurchaseOrderCSVLoad           INTERFACE(IDispatch),COM,TYPE
TestLogin                         PROCEDURE(BSTRING MMSName,BSTRING MMSPassword,long MMSCompanyNumber,*BSTRING pRetVal),HRESULT,PROC
PostPurchaseOrders                PROCEDURE(BSTRING MMSName,BSTRING MMSPassword,long MMSCompanyNumber,BSTRING CSVFileName,VARIANT_BOOL bValidate,BSTRING Delimeter,*VARIANT_BOOL pRetVal),HRESULT,PROC
                                END

!*********** Coclasses ***********
!coclass PurchaseOrderCSVLoad                                                                                
IID_PurchaseOrderCSVLoad        GROUP
data1                             LONG(8C578BBAH)
data2                             SHORT(0FF41H)
data3                             SHORT(45DAH)
data4                             STRING('<99H><80H><4FH><7H><28H><0F5H><0C6H><9EH>')
                                END
!PurchaseOrderCSVLoad            CLASS,TYPE
!_Object                           &_Object
!_PurchaseOrderCSVLoad             &_PurchaseOrderCSVLoad
!                                END
PurchaseOrderCSVLoad            INTERFACE(IUnknown),COM,TYPE
                                END
