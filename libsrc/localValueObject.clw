	!PROGRAM
	MEMBER
	MAP.
	
	INCLUDE('LocalValueObject.inc'), ONCE
LocalValueObject.Construct 	PROCEDURE()
	CODE
	
		Self.ValueQu &= NEW TLocalValueObjectQu

LocalValueObject.Destruct	PROCEDURE()
	CODE
		FREE(Self.ValueQu)
		IF NOT Self.ValueQu &= NULL
			DISPOSE(Self.ValueQu)
		END
		
LocalValueObject.Records	PROCEDURE()

	CODE
		RETURN RECORDS(Self.ValueQu)
LocalValueObject.EmptyQu	PROCEDURE()

	CODE
		FREE(Self.ValueQu)
	
LocalValueObject.SetValue	PROCEDURE(STRING pPropertyName, STRING pPropertyValue)

	CODE
		Self.ValueQu.PropertyName = CLIP(LEFT(UPPER(pPropertyName)))
		GET(Self.ValueQu, Self.ValueQu.PropertyName)
		IF ~ERRORCODE()
			Self.ValueQu.PropertyValue = pPropertyValue
			PUT(Self.ValueQu)
		ELSE
			Self.ValueQu.PropertyName = CLIP(LEFT(UPPER(pPropertyName)))
			Self.ValueQu.PropertyValue = pPropertyValue
			ADD(Self.ValueQu, Self.ValueQu.PropertyName)
		END
		
LocalValueObject.GetValue	PROCEDURE(STRING pPropertyName)

	CODE
		Self.ValueQu.PropertyName = CLIP(LEFT(UPPER(pPropertyName)))
		GET(Self.ValueQu, Self.ValueQu.PropertyName)
		IF ~ERRORCODE()
			RETURN CLIP(Self.ValueQu.PropertyValue)
		ELSE
			RETURN ' '
		END	
		
LocalValueObject.GetNextValue	PROCEDURE(STRING pPropertyName)
lpReturnValue	LONG
	CODE
		Self.ValueQu.PropertyName = CLIP(LEFT(UPPER(pPropertyName)))
		GET(Self.ValueQu, Self.ValueQu.PropertyName)
		IF ~ERRORCODE()
			IF NUMERIC(Self.ValueQu.PropertyValue)
				Self.ValueQu.PropertyValue += 1
			ELSE
				Self.ValueQu.PropertyValue = 1
			END
			lpReturnValue = Self.ValueQu.PropertyValue
			PUT(Self.ValueQu)
		ELSE
			Self.ValueQu.PropertyName = CLIP(LEFT(UPPER(pPropertyName)))
			Self.ValueQu.PropertyValue = 1
			ADD(Self.ValueQu, Self.ValueQu.PropertyName) 
			lpReturnValue = 1
		END
		
		RETURN lpReturnValue
		
LocalValueObject.GetQu				PROCEDURE()!, *TLocalValueObjectQu
	CODE
		RETURN Self.ValueQu

LocalValueObject.GetRecord	PROCEDURE(LONG pRecordNumber, *STRING pPropertyName, *STRING pPropertyValue)

lpReturnValue	BYTE

	CODE


		GET(Self.ValueQu, pRecordNumber)
		IF ERRORCODE()
			pPropertyName = ' '
			pPropertyValue = ' '
			lpReturnValue = 0
		ELSE
			pPropertyName = Self.ValueQu.PropertyName
			pPropertyValue = Self.ValueQu.PropertyValue
			lpReturnValue = 1
		END	
		
		RETURN lpReturnValue


