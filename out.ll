; ModuleID = 'main'
source_filename = "main"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

%Enum = type { i64, %constructor_Unit }
%constructor_Unit = type {}

declare i64 @printf(i8*, ...)

define void @main() {
entry:
  %x = alloca %Enum, align 8
  %gadt = alloca %Enum, align 8
  store %Enum* %gadt, %Enum* %x, align 8
  %y = alloca %Enum, align 8
  %gadt1 = alloca %Enum, align 8
  %param = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 0
  store i64 1, i64* %param, align 8
  %param2 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 1
  store i64 2, %constructor_Unit* %param2, align 8
  store %Enum* %gadt1, %Enum* %y, align 8
  %z = alloca %Enum, align 8
  %gadt3 = alloca %Enum, align 8
  %field = getelementptr inbounds %Enum, %Enum* %gadt3, i32 0, i32 0
  store i64 2, i64* %field, align 8
  %field4 = getelementptr inbounds %Enum, %Enum* %gadt3, i32 0, i32 1
  store i64 1, %constructor_Unit* %field4, align 8
  store %Enum* %gadt3, %Enum* %z, align 8
  ret void
}
