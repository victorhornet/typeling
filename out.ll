; ModuleID = 'main'
source_filename = "main"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

%Enum = type { i64, %constructor_C }
%constructor_C = type { i64, i64 }
%constructor_A = type {}
%constructor_B = type { i64 }
%Tuple = type { i64, %constructor_Tuple }
%constructor_Tuple = type { i64, i64 }

declare i64 @printf(i8*, ...)

define i64 @main() {
entry:
  %a = alloca %Enum, align 8
  %gadt = alloca %Enum, align 8
  %tag_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 0
  %temp_inner_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %inner_ptr = bitcast %constructor_C* %temp_inner_ptr to %constructor_A*
  %gadt_value = load %Enum, %Enum* %gadt, align 4
  store %Enum %gadt_value, %Enum* %a, align 4
  %b = alloca %Enum, align 8
  %gadt1 = alloca %Enum, align 8
  %tag_ptr2 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 0
  %temp_inner_ptr3 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 1
  %inner_ptr4 = bitcast %constructor_C* %temp_inner_ptr3 to %constructor_B*
  %param = getelementptr inbounds %constructor_B, %constructor_B* %inner_ptr4, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %gadt_value5 = load %Enum, %Enum* %gadt1, align 4
  store %Enum %gadt_value5, %Enum* %b, align 4
  %c = alloca %Enum, align 8
  %gadt6 = alloca %Enum, align 8
  %tag_ptr7 = getelementptr inbounds %Enum, %Enum* %gadt6, i32 0, i32 0
  %temp_inner_ptr8 = getelementptr inbounds %Enum, %Enum* %gadt6, i32 0, i32 1
  %param9 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr8, i32 0, i32 0
  store i64 10, i64* %param9, align 4
  %param10 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr8, i32 0, i32 1
  store i64 20, i64* %param10, align 4
  %gadt_value11 = load %Enum, %Enum* %gadt6, align 4
  store %Enum %gadt_value11, %Enum* %c, align 4
  %y = alloca %Tuple, align 8
  %gadt12 = alloca %Tuple, align 8
  %tag_ptr13 = getelementptr inbounds %Tuple, %Tuple* %gadt12, i32 0, i32 0
  %temp_inner_ptr14 = getelementptr inbounds %Tuple, %Tuple* %gadt12, i32 0, i32 1
  %param15 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %temp_inner_ptr14, i32 0, i32 0
  store i64 1, i64* %param15, align 4
  %param16 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %temp_inner_ptr14, i32 0, i32 1
  store i64 2, i64* %param16, align 4
  %gadt_value17 = load %Tuple, %Tuple* %gadt12, align 4
  store %Tuple %gadt_value17, %Tuple* %y, align 4
  ret i64 0
}
