  MEMBER

  MAP
    INCLUDE('samUtil.inc'), ONCE
    cheese PROCEDURE()	
  END

samnum	LONG

samQuote      PROCEDURE(STRING pQuoteMeOnThat)

  CODE

    RETURN '"' & CLIP(LEFT(pQuoteMeOnThat)) & '"'

