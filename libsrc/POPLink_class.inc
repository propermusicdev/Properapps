!Generated .INC file (by the Easy COM generator v 1.13)

    INCLUDE('ecom2inc.def'),ONCE
    INCLUDE('PopLink.inc'),ONCE
    INCLUDE('ecombase.inc'),ONCE

_PurchaseOrderCSVLoadClass      CLASS(EasyCOMClass),TYPE,MODULE('PopLink_class.clw'),LINK('PopLink_class.clw')
_PurchaseOrderCSVLoadObj          &_PurchaseOrderCSVLoad,PROTECTED
Construct                         PROCEDURE()
Destruct                          PROCEDURE(),DERIVED
Init                              PROCEDURE(),HRESULT,PROC,DERIVED
Init                              PROCEDURE(LONG lpInterface),HRESULT,PROC,DERIVED
Kill                              PROCEDURE(),HRESULT,PROC,DERIVED
GetInterfaceObject                PROCEDURE(),*_PurchaseOrderCSVLoad
GetInterfaceAddr                  PROCEDURE(),LONG
GetLibLocation                    PROCEDURE(),STRING,DERIVED
!Interface methods
TestLogin                         PROCEDURE(BSTRING MMSName,BSTRING MMSPassword,long MMSCompanyNumber,*BSTRING pRetVal),HRESULT,PROC,VIRTUAL
PostPurchaseOrders                PROCEDURE(BSTRING MMSName,BSTRING MMSPassword,long MMSCompanyNumber,BSTRING CSVFileName,  |
                                  VARIANT_BOOL bValidate,BSTRING Delimeter,*VARIANT_BOOL pRetVal),HRESULT,PROC,VIRTUAL
                                END

