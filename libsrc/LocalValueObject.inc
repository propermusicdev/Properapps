localValueObject 	CLASS, TYPE, MODULE('localValueObject.clw'), LINK('localValueObject.clw', 1), DLL(0)
Construct			PROCEDURE()
Destruct			PROCEDURE()
SetValue			PROCEDURE(STRING, STRING)
GetValue			PROCEDURE(STRING),STRING
GetNextValue		PROCEDURE(STRING),LONG, PROC
EmptyQu				PROCEDURE()
Records				PROCEDURE(),LONG
GetRecord			PROCEDURE(LONG, *STRING, *STRING),BYTE,PROC
GetQu				PROCEDURE(), *TLocalValueObjectQu
ValueQu				&TLocalValueObjectQu, PRIVATE

			END
					
TLocalValueObjectQu	QUEUE, TYPE
PropertyName			STRING(255)
PropertyValue			STRING(255)
			END
