; ModuleID = 'main'
source_filename = "main"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare i64 @printf(i8*, ...)

define void @function1() {
entry:
  %x = alloca double, align 8
  ret void
}

define i64 @function2() {
entry:
  ret i64 20
}

define double @function3() {
entry:
  ret i64 7
}

define void @i64_comparisons() {
entry:
  %c1 = alloca i1, align 1
  %c2 = alloca i1, align 1
  %c3 = alloca i1, align 1
  %c4 = alloca i1, align 1
  %c5 = alloca i1, align 1
  %c6 = alloca i1, align 1
  store i1 false, i1* %c1, align 1
  store i1 true, i1* %c2, align 1
  store i1 true, i1* %c3, align 1
  store i1 false, i1* %c4, align 1
  store i1 true, i1* %c5, align 1
  store i1 false, i1* %c6, align 1
  ret void
}

define i1 @bool_operations() {
entry:
  ret i1 true
}

define i1 @function_call() {
entry:
  %call = call double @function3()
  ret i1 true
}

define void @unops() {
entry:
  ret void
}

define i64 @blocks() {
entry:
  ret i64 9
}

define i64 @func_with_params(i64 %x, i64 %y) {
entry:
  %add = add i64 %x, %y
  ret i64 %add
}

define void @main() {
entry:
  ret void
}

