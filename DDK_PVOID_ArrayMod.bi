'����BASICϰ��������Ŵ�0��ʼ
type PVOID_List_Type
   sCount   as ulong      '����ά��
   sLenght  as ulong      'ÿ��Ԫ����������
   sStep    as ulong      'ָ��ƫ��   
   sList    as PVOID      '����ָ��
end type

'����һ�����ַ�����ָ��(����Ԫ������,ÿ��Ԫ���ֽ�����)
function PVOID_List_Create(byval Count as ulong,byval Lenght as ulong) as PVOID_List_Type
   dim wList as PVOID_List_Type

   wList.sCount  = Count
   wList.sLenght = Lenght 
   wList.sStep   = wList.sLenght + 1 '+CHR(0)
   wList.sList   = ExAllocatePoolWithTag(NonPagedPool,Count * wList.sStep, 80001)
   RtlZeroMemory wList.sList,Count * wList.sStep
   'wList.sList   = CAllocate(Count,wList.sStep)
   return wList
end function

'�ͷ�����
sub PVOID_List_Close(wList as PVOID_List_Type)
   wList.sCount  = 0
   wList.sLenght = 0
   wList.sStep   = 0

   if wList.sList <> null then 
      ExFreePool wList.sList
      wList.sList = null
   end if
   'Deallocate wList.sList
end sub

'��������
sub PVOID_List_Redim(wList as PVOID_List_Type,byval Count as ulong)
   dim sCount as ulong = wList.sCount
   dim sList  as PVOID = ExAllocatePoolWithTag(NonPagedPool,Count * wList.sStep, 80001)
   'dim sList  as PVOID = CAllocate(Count,wList.sStep)

   RtlCopyMemory sList,wList.sList,sCount * wList.sStep    
   ExFreePool wList.sList
   'memcpy sList,wList.sList,sCount * wList.sStep            
   'Deallocate wList.sList         
   wList.sList = sList
   wList.sCount = Count
end sub

'��������������������(����chr(0))
function PVOID_List_GetSize(wList as PVOID_List_Type) as long
   function = wList.sCount * wList.sLenght
end function

'����Ԫ��ָ��
function PVOID_List_GetPtr(wList as PVOID_List_Type,byval Index as ulong) as PVOID
   if Index >= 0 and Index < wList.sCount then function = wList.sList + (Index * wList.sStep)' else messagebox 0,"!!!!!|" & Index,"",0
end function

'����һ��Ԫ������
function PVOID_List_Set(wList as PVOID_List_Type,byval Index as ulong,byval sInfo as PVOID) as long
   DIM mInfo as PVOID = PVOID_List_GetPtr(wList,Index)
   if mInfo = NULL then return -1 else RtlCopyMemory mInfo,sInfo,wList.sLenght
   'memcpy mInfo,sInfo,wList.sLenght
   function = Index
end function

'����Ԫ������
function PVOID_List_Get(wList as PVOID_List_Type,byval Index as ulong,byval sInfo as PVOID) as long
   DIM mInfo as PVOID = PVOID_List_GetPtr(wList,Index)
   if mInfo = NULL then return -1 else RtlCopyMemory sInfo,mInfo,wList.sLenght
   'memcpy sInfo,mInfo,wList.sLenght
   function = Index
end function