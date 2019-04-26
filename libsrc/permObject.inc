


				   
permObject  CLASS, TYPE, MODULE('permObject.clw'), LINK('permObject.clw', 1), DLL(0)
Init          PROCEDURE(Window w, SIGNED ctrl, *TUsersQu, *TPermissionQu, *TUserPermissionsQu)
VLBproc       PROCEDURE(LONG row, SHORT col),STRING,PRIVATE
TakeEvent     PROCEDURE(LONG pEvent, LONG pField), BYTE, PROC
UsersQu       &TUsersQu, PRIVATE
PermQu        &TPermissionQu, PRIVATE
UserPermQu    &TUserPermissionsQu, PRIVATE
UsersChanges      LONG, PRIVATE
PermsChanges      LONG, PRIVATE
UserPermsChanges  LONG, PRIVATE
ctrl              LONG, PRIVATE
Initialised       BYTE, PRIVATE

            END


TUsersQu           QUEUE,TYPE!,PRE(USQ)                        !
No                   ULONG                                 !User Number
FirstName            CSTRING(16)                           !First Name (optional)
LastName             CSTRING(26)                           !Last Name
Initials             CSTRING(4)                            !User Initials
FullName             STRING(100)                           !
                   END       
				   !
TPermissionQu      QUEUE,TYPE!, PRE(PMQ)                        !
ItemCode             STRING(5)                             !
ItemName             STRING(50)       
ColumnName			 STRING(50)                     !
                   END
				   
TUserPermissionsQu	QUEUE, TYPE
UserName			  STRING(100)
ItemCode			  STRING(5)
ItemName			  STRING(100)
ColumnName 			  STRING(100)
UserId				  ULONG
Add					  BYTE
Remove				  BYTE
LinkId				  ULONG	
					END