       Member
!_ABCDllMode_  EQUATE(0)
!_ABCLinkMode_ EQUATE(1)
 map
 .

 include('mymark.inc'),once
 include('aberror.inc'),once
 include('keycodes.clw'),once


! ��������� ������� �.��������� 20.09.98. � MarkClass :
! - ����� � ����� Ref_Marked ����� ���� ���������� � Table_Mark
!   ��� ������ ���� ��������� � mybrowse.inc
! - ������ AddMark, DeleteMark � ClearMark ��������� ������������
! - ������ AddMark � DeleteMark ������ ���������� Level:Benign ���
!   Level:Notify � ����������� �� ����������
! - ����� AdddeleteMark ���������� � ������� AddMark � DeleteMark
! � MybrowseClass :
! - ������� �������� ������ MarkInHeap = True,
!   ���� MarkClass ���������� � ����
! - � ������ Kill ������ dispose � ����������� �� MarkInHeap
! - ����� SetMarkInQueue ��������� ������ ���������� ���������
!   �� ���������������� MarkClass (���������, ������� �������
!   MarkClass � ��������� �����)
! 27.12.98 �������� Event:InvertMark � ����� ���� '�������� ���������'
!
! ����� MarkClass ��������� ��������� ��� ��������, ���������� �
! ������� ������� ������ (���� � ��������� ������ �� ��������������)
!
! 07.06.99 MarkClass ������� �� MyBrowse � ���� mymark


! ********************************************************
! ������ ������ MarkClass                                *
! ********************************************************

MarkClass.Init        Procedure()
   code
      Self.Ref_Marked  &= new(Table_Mark)
   
   return


MarkClass.Kill     Procedure()
   code
      if (Self.Ref_Marked &=NULL)
        Free(Self.Ref_Marked)
        Dispose(Self.Ref_Marked)
        Self.Ref_Marked &=NULL
      end
   return


!�����������, ��� �������������� �������� �� ���������
MarkClass.AddMark    Procedure(Value_Mark)
Ret byte
   code
      Self.Ref_Marked.Ptr_Marked = Value_Mark
      Get(Self.Ref_Marked,Self.Ref_Marked.Ptr_Marked)
      if errorcode()
        Self.Ref_Marked.Ptr_Marked = Value_Mark
        Add(Self.Ref_Marked,Self.Ref_Marked.Ptr_Marked)
        Ret = Level:Benign
        !message('���������� - ' & Value_Mark) !debugMessage
      else
        !message('������ ����������- ' & errorcode()) !debugMessage
       Ret = Level:Notify
      .
   return(Ret)


MarkClass.AddDeleteMark    Procedure(Value_Mark)
   code
      if Self.AddMark(Value_Mark) then Self.DeleteMark(Value_Mark) .
   return


!�����������, ��� �������������� �������� �� ������ ���������
MarkClass.DeleteMark Procedure(Value_Mark)
Ret byte
   code
      !message('�������� - ' & Value_Mark) !debugMessage
      Self.Ref_Marked.Ptr_Marked = Value_Mark
      Get(Self.Ref_Marked,Self.Ref_Marked.Ptr_Marked)
      if ~errorcode()
         Delete(Self.Ref_Marked)
         Ret = Level:Benign
      else
         Ret = Level:Notify
      .
      !message('������ �������� - ' & errorcode()) !debugMessage
   return(Ret)


MarkClass.CheckMark  Function(Value_Mark)
Ret byte
   code
      Self.Ref_Marked.Ptr_Marked = Value_Mark
      Get(Self.Ref_Marked,Self.Ref_Marked.Ptr_Marked)
      !message('������ �������� - ' & errorcode()) !debugMessage
      if ~errorcode()
           ret=1
         else
           ret=0
      .
      return(ret)


! ����������� �����, ����� ����� ���� ���������
! ����������� "���������" � ���������
MarkClass.ClearMark  Procedure()
   code
      Free(Self.Ref_Marked)
   return

MarkClass.HowManyMark  Function()
   code
   return(records(Self.Ref_Marked))

