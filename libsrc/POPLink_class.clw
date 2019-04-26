!Generated .CLW file (by the Easy COM generator v 1.13)

  MEMBER
  INCLUDE('svcomdef.inc'),ONCE
  MAP
    MODULE('WinAPI')
      ecg_DispGetParam(LONG pdispparams,LONG dwPosition,VARTYPE vtTarg,*VARIANT pvarResult,*SIGNED uArgErr),HRESULT,RAW,PASCAL,NAME('DispGetParam')
      ecg_VariantInit(*VARIANT pvarg),HRESULT,PASCAL,PROC,NAME('VariantInit')
      ecg_VariantClear(*VARIANT pvarg),HRESULT,PASCAL,PROC,NAME('VariantClear')
      ecg_VariantCopy(*VARIANT vargDest,*VARIANT vargSrc),HRESULT,PASCAL,PROC,NAME('VariantCopy')
      memcpy(LONG lpDest,LONG lpSource,LONG nCount),LONG,PROC,NAME('_memcpy')
      GetErrorInfo(ULONG dwReserved,LONG pperrinfo),HRESULT,PASCAL,PROC
    END
    INCLUDE('svapifnc.inc')
    Dec2Hex(ULONG),STRING
    INCLUDE('getvartype.inc', 'DECLARATIONS')
  END
  INCLUDE('PopLink_class.inc')

Dec2Hex                         PROCEDURE(ULONG pDec)
locHex                          STRING(30)
  CODE
  LOOP UNTIL(~pDec)
    locHex = SUB('0123456789ABCDEF',1+pDec % 16,1) & CLIP(locHex)
    pDec = INT(pDec / 16)
  END
  RETURN CLIP(locHex)

  INCLUDE('getvartype.inc', 'CODE')
!========================================================!
! _PurchaseOrderCSVLoadClass implementation              !
!========================================================!
_PurchaseOrderCSVLoadClass.Construct    PROCEDURE()
  CODE
  SELF.debug=true

_PurchaseOrderCSVLoadClass.Destruct    PROCEDURE()
  CODE
  IF SELF.IsInitialized=true THEN SELF.Kill() END

_PurchaseOrderCSVLoadClass.Init PROCEDURE()
loc:lpInterface                 LONG
  CODE
  SELF.HR=CoCreateInstance(ADDRESS(IID_PurchaseOrderCSVLoad),0,SELF.dwClsContext,ADDRESS(IID__PurchaseOrderCSVLoad),loc:lpInterface)
  IF SELF.HR=S_OK
    RETURN SELF.Init(loc:lpInterface)
  ELSE
    SELF.IsInitialized=false
    SELF._ShowErrorMessage('_PurchaseOrderCSVLoadClass.Init: CoCreateInstance',SELF.HR)
  END
  RETURN SELF.HR

_PurchaseOrderCSVLoadClass.Init PROCEDURE(LONG lpInterface)
  CODE
  IF PARENT.Init(lpInterface) = S_OK
    SELF._PurchaseOrderCSVLoadObj &= (lpInterface)
  END
  RETURN SELF.HR

_PurchaseOrderCSVLoadClass.Kill PROCEDURE()
  CODE
  IF PARENT.Kill() = S_OK
    SELF._PurchaseOrderCSVLoadObj &= NULL
  END
  RETURN SELF.HR

_PurchaseOrderCSVLoadClass.GetInterfaceObject    PROCEDURE()
  CODE
  RETURN SELF._PurchaseOrderCSVLoadObj

_PurchaseOrderCSVLoadClass.GetInterfaceAddr    PROCEDURE()
  CODE
  RETURN ADDRESS(SELF._PurchaseOrderCSVLoadObj)
  !RETURN INSTANCE(SELF._PurchaseOrderCSVLoadObj, 0)

_PurchaseOrderCSVLoadClass.GetLibLocation    PROCEDURE()
  CODE
  RETURN GETREG(REG_CLASSES_ROOT,'CLSID\{{8C578BBA-FF41-45DA-9980-4F0728F5C69E}\InprocServer32')

_PurchaseOrderCSVLoadClass.TestLogin    PROCEDURE(BSTRING pMMSName,BSTRING pMMSPassword,long pMMSCompanyNumber,*BSTRING ppRetVal)
HR                              HRESULT(S_OK)

  CODE
  IF SELF.IsInitialized=false THEN SELF.HR=E_FAIL;RETURN(SELF.HR) END
  HR=SELF._PurchaseOrderCSVLoadObj.TestLogin(pMMSName,pMMSPassword,pMMSCompanyNumber,ppRetVal)
  SELF.HR=HR
  IF HR < S_OK
    SELF._ShowErrorMessage('_PurchaseOrderCSVLoadClass.TestLogin',HR)
  END
  RETURN HR

_PurchaseOrderCSVLoadClass.PostPurchaseOrders    PROCEDURE(BSTRING pMMSName,BSTRING pMMSPassword,long pMMSCompanyNumber,BSTRING pCSVFileName,VARIANT_BOOL pbValidate,BSTRING pDelimeter,*VARIANT_BOOL ppRetVal)
HR                              HRESULT(S_OK)

  CODE
  IF SELF.IsInitialized=false THEN SELF.HR=E_FAIL;RETURN(SELF.HR) END
  HR=SELF._PurchaseOrderCSVLoadObj.PostPurchaseOrders(pMMSName,pMMSPassword,pMMSCompanyNumber,pCSVFileName,pbValidate,pDelimeter,ppRetVal)
  SELF.HR=HR
  IF HR < S_OK
    SELF._ShowErrorMessage('_PurchaseOrderCSVLoadClass.PostPurchaseOrders',HR)
  END
  RETURN HR

