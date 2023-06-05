; ModuleID = 'unit_test'
source_filename = "unit_test"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

%Enum = type { i64, %Tuple }
%Tuple = type { i64, i1, i64 }

define void @unit_test() {
entry:
  %enum_value = alloca %Enum, align 8
  ret void
}
