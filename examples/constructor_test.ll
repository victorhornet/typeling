; ModuleID = 'unit_test'
source_filename = "unit_test"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

%Enum = type { i64, %constructor_Tuple }
%constructor_Tuple = type { i64, i1, i64 }
%SomeType = type { i64, %constructor_SomeType }
%constructor_SomeType = type { %Enum* }

define void @unit_test() {
entry:
  %enum_value = alloca %Enum, align 8
  %some_gadt_value = alloca %SomeType, align 8
  ret void
}

; bitcast %union.vals* %inner_ptr to %my_struct*