; ModuleID = 'main'
source_filename = "main"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

%Enum = type { i64, %constructor_Struct }
%constructor_Struct = type { i64, i64 }
%Tuple = type { i64, %constructor_Tuple }
%constructor_Tuple = type { i64, i64 }

declare i64 @printf(i8*, ...)

define void @main() {
entry:
  %x = alloca %Enum, align 8
  %gadt = alloca %Enum, align 8
  %tag_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 0
  %inner_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %gadt_value = load %Enum, %Enum* %gadt, align 8
  store %Enum %gadt_value, %Enum* %x, align 8
  %y = alloca %Tuple, align 8
  %gadt1 = alloca %Tuple, align 8
  %tag_ptr2 = getelementptr inbounds %Tuple, %Tuple* %gadt1, i32 0, i32 0
  %inner_ptr3 = getelementptr inbounds %Tuple, %Tuple* %gadt1, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %inner_ptr3, i32 0, i32 0
  store i64 1, i64* %param, align 8
  %param4 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %inner_ptr3, i32 0, i32 1
  store i64 2, i64* %param4, align 8
  %gadt_value5 = load %Tuple, %Tuple* %gadt1, align 8
  store %Tuple %gadt_value5, %Tuple* %y, align 8
  ret void
}
