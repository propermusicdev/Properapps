       Member
!_ABCDllMode_  EQUATE(0)
!_ABCLinkMode_ EQUATE(1)
 map
 .

 include('mymark.inc'),once
 include('aberror.inc'),once
 include('keycodes.clw'),once


! Изменения внесены В.Куличенко 20.09.98. В MarkClass :
! - Чтобы к через Ref_Marked можно было обратиться к Table_Mark
!   она должна быть объявлена в mybrowse.inc
! - Методы AddMark, DeleteMark и ClearMark объявлены виртуальными
! - Методы AddMark и DeleteMark теперь возвращают Level:Benign или
!   Level:Notify в зависимости от результата
! - Метод AdddeleteMark обращается к методам AddMark и DeleteMark
! В MybrowseClass :
! - Введено свойство класса MarkInHeap = True,
!   если MarkClass выделяется в куче
! - В методе Kill введен dispose в зависимости от MarkInHeap
! - Метод SetMarkInQueue принимает вторым параметром указатель
!   на переопределенный MarkClass (закрывает, удаляет текущий
!   MarkClass и иницирует новый)
! 27.12.98 добавлен Event:InvertMark и пункт меню 'Обратить выделение'
!
! Новый MarkClass полностью прозрачен для программ, написанных с
! прежней версией класса (если в программе методы не переписывались)
!
! 07.06.99 MarkClass отделен от MyBrowse в файл mymark


! ********************************************************
! Методы класса MarkClass                                *
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


!Виртуальный, для дополнительных действий по выделению
MarkClass.AddMark    Procedure(Value_Mark)
Ret byte
   code
      Self.Ref_Marked.Ptr_Marked = Value_Mark
      Get(Self.Ref_Marked,Self.Ref_Marked.Ptr_Marked)
      if errorcode()
        Self.Ref_Marked.Ptr_Marked = Value_Mark
        Add(Self.Ref_Marked,Self.Ref_Marked.Ptr_Marked)
        Ret = Level:Benign
        !message('Добавление - ' & Value_Mark) !debugMessage
      else
        !message('Ошибка добавления- ' & errorcode()) !debugMessage
       Ret = Level:Notify
      .
   return(Ret)


MarkClass.AddDeleteMark    Procedure(Value_Mark)
   code
      if Self.AddMark(Value_Mark) then Self.DeleteMark(Value_Mark) .
   return


!Виртуальный, для дополнительных действий по снятию выделения
MarkClass.DeleteMark Procedure(Value_Mark)
Ret byte
   code
      !message('Удаление - ' & Value_Mark) !debugMessage
      Self.Ref_Marked.Ptr_Marked = Value_Mark
      Get(Self.Ref_Marked,Self.Ref_Marked.Ptr_Marked)
      if ~errorcode()
         Delete(Self.Ref_Marked)
         Ret = Level:Benign
      else
         Ret = Level:Notify
      .
      !message('Ошибка удаления - ' & errorcode()) !debugMessage
   return(Ret)


MarkClass.CheckMark  Function(Value_Mark)
Ret byte
   code
      Self.Ref_Marked.Ptr_Marked = Value_Mark
      Get(Self.Ref_Marked,Self.Ref_Marked.Ptr_Marked)
      !message('Ошибка проверки - ' & errorcode()) !debugMessage
      if ~errorcode()
           ret=1
         else
           ret=0
      .
      return(ret)


! Виртуальный метод, чтобы можно было выполнить
! необходимую "подчистку" в программе
MarkClass.ClearMark  Procedure()
   code
      Free(Self.Ref_Marked)
   return

MarkClass.HowManyMark  Function()
   code
   return(records(Self.Ref_Marked))

