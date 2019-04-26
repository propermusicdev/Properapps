  
  

  !PROGRAM
  
  MEMBER
  MAP.
  
  INCLUDE('permObject.inc'), ONCE
permObject.Init     PROCEDURE(Window w, SIGNED ctrl, *TUsersQu pUsersQu, *TPermissionQu pPermQu, *TUserPermissionsQu pUserPermQu)

  CODE

    Self.UsersQu     &= pUsersQu
    Self.PermQu      &= pPermQu
    Self.UserPermQu  &= pUserPermQu
  
    self.ctrl = ctrl

    w $ ctrl{PROP:VLBval} = ADDRESS(SELF)           !Must assign this first
    w $ ctrl{PROP:VLBproc} = ADDRESS(SELF.VLBproc)    ! then this
    w $ ctrl{PROP:Alrt, 1} = 0005H !Mouseleft2 
  
   Self.Initialised = TRUE
   
permObject.VLBProc  PROCEDURE(LONG row, SHORT col)

rUsersChanges      LONG
rPermsChanges      LONG
rUserPermsChanges  LONG
lReturnValue  STRING(255)

  CODE
    CASE row
      OF -1                    ! How many rows?
        RETURN RECORDS(Self.UsersQu) !RECORDS(SELF.Q)
      OF -2                    ! How many columns?
        RETURN RECORDS(Self.PermQu) + 1 !5

      OF -3
        rUsersChanges = CHANGES(Self.UsersQu)
        rPermsChanges = CHANGES(Self.PermQu)
        rUserPermsChanges = CHANGES(Self.UserPermQu)
        IF rUsersChanges ~= Self.UsersChanges OR rPermsChanges ~= Self.PermsChanges OR rUserPermsChanges ~= Self.UserPermsChanges
          Self.UsersChanges = rUsersChanges
          Self.PermsChanges = rPermsChanges
          Self.UserPermsChanges = rUserPermsChanges
          RETURN 1
        ELSE
          RETURN 0
        END

      ELSE
        CASE col
          OF 1
            GET(Self.UsersQu, row)
            
            RETURN Self.UsersQu.FullName
          ELSE
            GET(Self.PermQu, col -1)
            IF ~ERRORCODE()
              GET(Self.UsersQu, row)
              IF ~ERRORCODE()
                Self.UserPermQu.ItemCode = Self.PermQu.ItemCode
                Self.UserPermQu.UserId   = Self.UsersQu.No
                GET(Self.UserPermQu, Self.UserPermQu.ItemCode, Self.UserPermQu.UserId )
                IF ERRORCODE()
                  lReturnValue = ' '
                ELSE
                  IF Self.UserPermQu.Remove ~= TRUE
                    lReturnValue = 'Yes'
                  END
                END
              END
            END
        END
        RETURN lReturnValue
    END    


    

permObject.TakeEvent   PROCEDURE(LONG pEvent, LONG pField)
  
lReturnValue   BYTE(FALSE)
lRow           LONG
lColumn        LONG
  CODE
  
    IF ~Self.Initialised
      RETURN FALSE
    END
    CASE pEvent
      OF Event:AlertKey
        lRow = Self.Ctrl{Proplist:MouseDownRow}
        lColumn = Self.Ctrl{Proplist:MouseDownField}
        CASE pField
          OF Self.ctrl
            GET(Self.PermQu, lColumn -1)
            IF ~ERRORCODE()
              GET(Self.UsersQu, lRow)
              IF ~ERRORCODE()
                Self.UserPermQu.ItemCode = Self.PermQu.ItemCode
                Self.UserPermQu.UserId   = Self.UsersQu.No
                GET(Self.UserPermQu, Self.UserPermQu.ItemCode, Self.UserPermQu.UserId )
                IF ERRORCODE()
                  Self.UserPermQu.ItemCode = Self.PermQu.ItemCode
                  Self.UserPermQu.UserId   = Self.UsersQu.No          
                  Self.UserPermQu.Add = TRUE
                  Self.UserPermQu.Remove = FALSE
                  Self.UserPermQu.LinkId = 0
                  Self.UserPermQu.ItemName = Self.PermQu.ItemName
                  Self.UserPermQu.ColumnName = Self.PermQu.ColumnName
                  Self.UserPermQu.UserName   = Self.UsersQu.FullName
                  ADD(Self.UserPermQu)
                  lReturnValue = TRUE
                ELSE
                  IF Self.UserPermQu.Remove
                    Self.UserPermQu.Remove = FALSE
                    IF Self.UserPermQu.LinkId = 0
                      Self.UserPermQu.Add = TRUE
                    END
                    lReturnValue = TRUE
                  ELSE
                    Self.USerPermQu.Remove = TRUE
                    Self.UserPermQu.Add = FALSE
                    lReturnValue = TRUE
                  END
                  PUT(Self.UserPermQu)
                END
              END
            END
        END
       
    END
    
  
    RETURN lReturnValue
