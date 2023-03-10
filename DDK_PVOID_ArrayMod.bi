'保持BASIC习惯数组序号从0开始
type PVOID_List_Type
   sCount   as ulong      '数组维度
   sLenght  as ulong      '每个元素容量长度
   sStep    as ulong      '指针偏移   
   sList    as PVOID      '数组指针
end type

'创建一个宽字符数组指针(数组元素数量,每个元素字节容量)
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

'释放数组
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

'数组扩容
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

'返回数组内数据总容量(不算chr(0))
function PVOID_List_GetSize(wList as PVOID_List_Type) as long
   function = wList.sCount * wList.sLenght
end function

'返回元素指针
function PVOID_List_GetPtr(wList as PVOID_List_Type,byval Index as ulong) as PVOID
   if Index >= 0 and Index < wList.sCount then function = wList.sList + (Index * wList.sStep)' else messagebox 0,"!!!!!|" & Index,"",0
end function

'设置一个元素内容
function PVOID_List_Set(wList as PVOID_List_Type,byval Index as ulong,byval sInfo as PVOID) as long
   DIM mInfo as PVOID = PVOID_List_GetPtr(wList,Index)
   if mInfo = NULL then return -1 else RtlCopyMemory mInfo,sInfo,wList.sLenght
   'memcpy mInfo,sInfo,wList.sLenght
   function = Index
end function

'返回元素内容
function PVOID_List_Get(wList as PVOID_List_Type,byval Index as ulong,byval sInfo as PVOID) as long
   DIM mInfo as PVOID = PVOID_List_GetPtr(wList,Index)
   if mInfo = NULL then return -1 else RtlCopyMemory sInfo,mInfo,wList.sLenght
   'memcpy sInfo,mInfo,wList.sLenght
   function = Index
end function