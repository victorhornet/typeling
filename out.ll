; ModuleID = 'main'
source_filename = "main"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

@string = private unnamed_addr constant [28 x i8] c"Hello \22world\22 '!'\0A num: %d\0A\00", align 1
@string.1 = private unnamed_addr constant [26 x i8] c"\09this is a tabbed string\0A\00", align 1
@string.2 = private unnamed_addr constant [21 x i8] c"fib(50) = %llu (%d)\0A\00", align 1

declare i64 @printf(i8*, ...)

define void @function1() {
entry:
  %x = alloca double, align 8
  %y = alloca i64, align 8
  store i64 47, i64* %y, align 8
  %z = alloca i64, align 8
  store i64 6, i64* %z, align 8
  store i64 10, i64* %z, align 8
  ret void
}

define i64 @function2() {
entry:
  %x = alloca i64, align 8
  store i64 4, i64* %x, align 8
  %z = alloca i64, align 8
  %x1 = load i64, i64* %x, align 8
  %add = add i64 1, %x1
  store i64 %add, i64* %z, align 8
  %z2 = load i64, i64* %z, align 8
  %x3 = load i64, i64* %x, align 8
  %mul = mul i64 %z2, %x3
  ret i64 %mul
}

define double @function3() {
entry:
  %t = alloca i1, align 1
  store i1 true, i1* %t, align 1
  %f = alloca i1, align 1
  store i1 false, i1* %f, align 1
  ret double 1.000000e+01
}

define void @i64_comparisons() {
entry:
  %x = alloca i64, align 8
  store i64 4, i64* %x, align 8
  %y = alloca i64, align 8
  store i64 5, i64* %y, align 8
  %c1 = alloca i1, align 1
  %c2 = alloca i1, align 1
  %c3 = alloca i1, align 1
  %c4 = alloca i1, align 1
  %c5 = alloca i1, align 1
  %c6 = alloca i1, align 1
  %x1 = load i64, i64* %x, align 8
  %y2 = load i64, i64* %y, align 8
  %eq = icmp eq i64 %x1, %y2
  store i1 %eq, i1* %c1, align 1
  %x3 = load i64, i64* %x, align 8
  %y4 = load i64, i64* %y, align 8
  %neq = icmp ne i64 %x3, %y4
  store i1 %neq, i1* %c2, align 1
  %x5 = load i64, i64* %x, align 8
  %y6 = load i64, i64* %y, align 8
  %lt = icmp slt i64 %x5, %y6
  store i1 %lt, i1* %c3, align 1
  %x7 = load i64, i64* %x, align 8
  %y8 = load i64, i64* %y, align 8
  %gt = icmp sgt i64 %x7, %y8
  store i1 %gt, i1* %c4, align 1
  %x9 = load i64, i64* %x, align 8
  %y10 = load i64, i64* %y, align 8
  %lte = icmp sle i64 %x9, %y10
  store i1 %lte, i1* %c5, align 1
  %x11 = load i64, i64* %x, align 8
  %y12 = load i64, i64* %y, align 8
  %gte = icmp sge i64 %x11, %y12
  store i1 %gte, i1* %c6, align 1
  ret void
}

define i1 @bool_operations() {
entry:
  %t = alloca i1, align 1
  store i1 true, i1* %t, align 1
  %f = alloca i1, align 1
  store i1 false, i1* %f, align 1
  %t1 = load i1, i1* %t, align 1
  %f2 = load i1, i1* %f, align 1
  %and = and i1 %t1, %f2
  %t3 = load i1, i1* %t, align 1
  %or = or i1 %and, %t3
  ret i1 %or
}

define i1 @function_call() {
entry:
  %x = alloca i64, align 8
  %call = call i64 @function2()
  store i64 %call, i64* %x, align 8
  ret i1 true
}

define void @unops() {
entry:
  %x = alloca i64, align 8
  store i64 4, i64* %x, align 8
  %nx = alloca i64, align 8
  %x1 = load i64, i64* %x, align 8
  %neg = sub i64 0, %x1
  store i64 %neg, i64* %nx, align 8
  %y = alloca double, align 8
  store double 4.000000e+00, double* %y, align 8
  %ny = alloca double, align 8
  %y2 = load double, double* %y, align 8
  %neg3 = fneg double %y2
  store double %neg3, double* %ny, align 8
  %t = alloca i1, align 1
  store i1 true, i1* %t, align 1
  %f = alloca i1, align 1
  %t4 = load i1, i1* %t, align 1
  %not = xor i1 %t4, true
  store i1 %not, i1* %f, align 1
  ret void
}

define i64 @blocks() {
entry:
  %x = alloca i64, align 8
  store i64 4, i64* %x, align 8
  %y = alloca i64, align 8
  store i64 5, i64* %y, align 8
  store i64 5, i64* %x, align 8
  store i64 6, i64* %y, align 8
  %x1 = alloca i64, align 8
  store i64 10, i64* %x1, align 8
  %y2 = alloca i64, align 8
  store i64 11, i64* %y2, align 8
  %x3 = load i64, i64* %x, align 8
  %y4 = load i64, i64* %y, align 8
  %add = add i64 %x3, %y4
  ret i64 %add
}

define i64 @func_with_params(i64 %x, i64 %y) {
entry:
  %add = add i64 %x, %y
  ret i64 %add
}

define i64 @fib(i64 %n) {
entry:
  %eq = icmp eq i64 %n, 0
  br i1 %eq, label %then, label %else

then:                                             ; preds = %entry
  ret i64 0

else:                                             ; preds = %entry
  br label %merge

merge:                                            ; preds = %else
  %eq3 = icmp eq i64 %n, 1
  br i1 %eq3, label %then1, label %else2

then1:                                            ; preds = %merge
  ret i64 1

else2:                                            ; preds = %merge
  br label %merge4

merge4:                                           ; preds = %else2
  %sub = sub i64 %n, 1
  %call = call i64 @fib(i64 %sub)
  %sub5 = sub i64 %n, 2
  %call6 = call i64 @fib(i64 %sub5)
  %add = add i64 %call, %call6
  ret i64 %add
}

define i64 @random_while(i64 %n) {
entry:
  %x = alloca i64, align 8
  store i64 0, i64* %x, align 8
  %y = alloca i64, align 8
  store i64 0, i64* %y, align 8
  br label %while

while:                                            ; preds = %body, %entry
  %x1 = load i64, i64* %x, align 8
  %lt = icmp slt i64 %x1, %n
  br i1 %lt, label %body, label %merge

body:                                             ; preds = %while
  %x2 = load i64, i64* %x, align 8
  %add = add i64 %x2, 1
  store i64 %add, i64* %x, align 8
  %y3 = load i64, i64* %y, align 8
  %x4 = load i64, i64* %x, align 8
  %add5 = add i64 %y3, %x4
  store i64 %add5, i64* %y, align 8
  br label %while

merge:                                            ; preds = %while
  %y6 = load i64, i64* %y, align 8
  ret i64 %y6
}

define i64 @fib_while(i64 %n) {
entry:
  %x = alloca i64, align 8
  store i64 0, i64* %x, align 8
  %y = alloca i64, align 8
  store i64 1, i64* %y, align 8
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %while

while:                                            ; preds = %body, %entry
  %i1 = load i64, i64* %i, align 8
  %lt = icmp slt i64 %i1, %n
  br i1 %lt, label %body, label %merge

body:                                             ; preds = %while
  %z = alloca i64, align 8
  %x2 = load i64, i64* %x, align 8
  %y3 = load i64, i64* %y, align 8
  %add = add i64 %x2, %y3
  store i64 %add, i64* %z, align 8
  %y4 = load i64, i64* %y, align 8
  store i64 %y4, i64* %x, align 8
  %z5 = load i64, i64* %z, align 8
  store i64 %z5, i64* %y, align 8
  %i6 = load i64, i64* %i, align 8
  %add7 = add i64 %i6, 1
  store i64 %add7, i64* %i, align 8
  br label %while

merge:                                            ; preds = %while
  %x8 = load i64, i64* %x, align 8
  ret i64 %x8
}

define i64 @fn_def_test1() {
entry:
  %call = call i64 @fn_def_test2()
  ret i64 %call
}

define i64 @fn_def_test2() {
entry:
  ret i64 10
}

define void @hello() {
entry:
  %call = call i64 (i8*, ...) @printf(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @string, i32 0, i32 0), i64 1)
  %call1 = call i64 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @string.1, i32 0, i32 0))
  ret void
}

define i64 @main() {
entry:
  call void @hello()
  %x = alloca i64, align 8
  %call = call i64 @fib_while(i64 50)
  store i64 %call, i64* %x, align 8
  %check = alloca i1, align 1
  %x1 = load i64, i64* %x, align 8
  %eq = icmp eq i64 %x1, 12586269025
  store i1 %eq, i1* %check, align 1
  %x2 = load i64, i64* %x, align 8
  %check3 = load i1, i1* %check, align 1
  %call4 = call i64 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @string.2, i32 0, i32 0), i64 %x2, i1 %check3)
  ret i64 0
}

