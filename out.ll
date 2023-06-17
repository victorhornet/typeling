; ModuleID = 'main'
source_filename = "main"

%Unit = type { i64, %constructor_Unit }
%constructor_Unit = type {}
%Tuple = type { i64, %constructor_Tuple }
%constructor_Tuple = type { i64, i64 }
%Struct = type { i64, %constructor_Struct }
%constructor_Struct = type { i64, i64 }
%SList = type { i64, %constructor_Node }
%constructor_Node = type { i64, %SList* }
%constructor_Nil = type {}

declare i64 @printf(i8*, ...)

define i64 @main() {
entry:
  %gadt = alloca %Unit, align 8
  %tag_ptr = getelementptr inbounds %Unit, %Unit* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Unit, %Unit* %gadt, i32 0, i32 1
  %x = alloca %Unit*, align 8
  store %Unit* %gadt, %Unit** %x, align 8
  %gadt1 = alloca %Tuple, align 8
  %tag_ptr2 = getelementptr inbounds %Tuple, %Tuple* %gadt1, i32 0, i32 0
  store i64 0, i64* %tag_ptr2, align 4
  %temp_inner_ptr3 = getelementptr inbounds %Tuple, %Tuple* %gadt1, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %temp_inner_ptr3, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %param4 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %temp_inner_ptr3, i32 0, i32 1
  store i64 2, i64* %param4, align 4
  %y = alloca %Tuple*, align 8
  store %Tuple* %gadt1, %Tuple** %y, align 8
  %gadt5 = alloca %Struct, align 8
  %tag_ptr6 = getelementptr inbounds %Struct, %Struct* %gadt5, i32 0, i32 0
  store i64 0, i64* %tag_ptr6, align 4
  %temp_inner_ptr7 = getelementptr inbounds %Struct, %Struct* %gadt5, i32 0, i32 1
  %param8 = getelementptr inbounds %constructor_Struct, %constructor_Struct* %temp_inner_ptr7, i32 0, i32 0
  store i64 1, i64* %param8, align 4
  %param9 = getelementptr inbounds %constructor_Struct, %constructor_Struct* %temp_inner_ptr7, i32 0, i32 1
  store i64 2, i64* %param9, align 4
  %z = alloca %Struct*, align 8
  store %Struct* %gadt5, %Struct** %z, align 8
  %gadt10 = alloca %SList, align 8
  %tag_ptr11 = getelementptr inbounds %SList, %SList* %gadt10, i32 0, i32 0
  store i64 0, i64* %tag_ptr11, align 4
  %temp_inner_ptr12 = getelementptr inbounds %SList, %SList* %gadt10, i32 0, i32 1
  %param13 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr12, i32 0, i32 0
  store i64 10, i64* %param13, align 4
  %param14 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr12, i32 0, i32 1
  %gadt15 = alloca %SList, align 8
  %tag_ptr16 = getelementptr inbounds %SList, %SList* %gadt15, i32 0, i32 0
  store i64 0, i64* %tag_ptr16, align 4
  %temp_inner_ptr17 = getelementptr inbounds %SList, %SList* %gadt15, i32 0, i32 1
  %param18 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr17, i32 0, i32 0
  store i64 20, i64* %param18, align 4
  %param19 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr17, i32 0, i32 1
  %gadt20 = alloca %SList, align 8
  %tag_ptr21 = getelementptr inbounds %SList, %SList* %gadt20, i32 0, i32 0
  store i64 1, i64* %tag_ptr21, align 4
  %temp_inner_ptr22 = getelementptr inbounds %SList, %SList* %gadt20, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Node* %temp_inner_ptr22 to %constructor_Nil*
  store %SList* %gadt20, %SList** %param19, align 8
  store %SList* %gadt15, %SList** %param14, align 8
  %list2 = alloca %SList*, align 8
  store %SList* %gadt10, %SList** %list2, align 8
  %gadt23 = alloca %SList, align 8
  %tag_ptr24 = getelementptr inbounds %SList, %SList* %gadt23, i32 0, i32 0
  store i64 0, i64* %tag_ptr24, align 4
  %temp_inner_ptr25 = getelementptr inbounds %SList, %SList* %gadt23, i32 0, i32 1
  %param26 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr25, i32 0, i32 0
  store i64 10, i64* %param26, align 4
  %param27 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr25, i32 0, i32 1
  %gadt28 = alloca %SList, align 8
  %tag_ptr29 = getelementptr inbounds %SList, %SList* %gadt28, i32 0, i32 0
  store i64 0, i64* %tag_ptr29, align 4
  %temp_inner_ptr30 = getelementptr inbounds %SList, %SList* %gadt28, i32 0, i32 1
  %param31 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr30, i32 0, i32 0
  store i64 20, i64* %param31, align 4
  %param32 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr30, i32 0, i32 1
  %gadt33 = alloca %SList, align 8
  %tag_ptr34 = getelementptr inbounds %SList, %SList* %gadt33, i32 0, i32 0
  store i64 1, i64* %tag_ptr34, align 4
  %temp_inner_ptr35 = getelementptr inbounds %SList, %SList* %gadt33, i32 0, i32 1
  %inner_ptr36 = bitcast %constructor_Node* %temp_inner_ptr35 to %constructor_Nil*
  store %SList* %gadt33, %SList** %param32, align 8
  store %SList* %gadt28, %SList** %param27, align 8
  %list1 = alloca %SList*, align 8
  store %SList* %gadt23, %SList** %list1, align 8
  ret i64 0
}
