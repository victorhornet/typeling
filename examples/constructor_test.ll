; ModuleID = 'unit_test'
source_filename = "unit_test"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

%Enum = type { i64, %Tuple }
%Tuple = type { i64, i1, i64 }
%SomeType = type { i64, %SomeType.0 }
%SomeType.0 = type { %Enum.1, %Enum }
%Enum.1 = type { i64, %Tuple.2 }
%Tuple.2 = type { i64, i1, i64 }

define void @unit_test() {
entry:
  %enum_value = alloca %Enum, align 8
  %some_gadt_value = alloca %SomeType, align 8
  ret void
}
