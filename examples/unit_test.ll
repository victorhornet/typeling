; ModuleID = 'unit_test'
source_filename = "unit_test"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

%unit = type { i64 }

define i64 @unit_test() {
entry:
  %unit_struct = alloca %unit, align 8
  %tag = getelementptr inbounds %unit, %unit* %unit_struct, i32 0, i32 0
  store i64 10, i64* %tag, align 8
  ret i64 ptrtoint ({ i64 }* getelementptr ({ i64 }, { i64 }* null, i32 1) to i64)
}
