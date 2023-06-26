; ModuleID = 'main'
source_filename = "main"

%List = type { i64, %constructor_Cons }
%constructor_Cons = type { i64, %List* }
%constructor_Nil = type {}

@string = private unnamed_addr constant [2 x i8] c"[\00", align 1
@string.1 = private unnamed_addr constant [3 x i8] c"]\0A\00", align 1
@string.2 = private unnamed_addr constant [5 x i8] c"%lli\00", align 1
@string.3 = private unnamed_addr constant [3 x i8] c", \00", align 1

declare i64 @printf(i8*, ...)

define %List* @zeros(i64 %size) {
entry:
  %size1 = alloca i64, align 8
  store i64 %size, i64* %size1, align 4
  %load = load i64, i64* %size1, align 4
  %eq = icmp eq i64 %load, 0
  %eq_i64 = sext i1 %eq to i64
  %condition = trunc i64 %eq_i64 to i1
  br i1 %condition, label %then, label %else

then:                                             ; preds = %entry
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Cons* %temp_inner_ptr to %constructor_Nil*
  ret %List* %gadt

else:                                             ; preds = %entry
  br label %merge

merge:                                            ; preds = %else
  %malloccall2 = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt3 = bitcast i8* %malloccall2 to %List*
  %tag_ptr4 = getelementptr inbounds %List, %List* %gadt3, i32 0, i32 0
  store i64 0, i64* %tag_ptr4, align 4
  %temp_inner_ptr5 = getelementptr inbounds %List, %List* %gadt3, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr5, i32 0, i32 0
  store i64 0, i64* %param, align 4
  %param6 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr5, i32 0, i32 1
  %load7 = load i64, i64* %size1, align 4
  %sub = sub i64 %load7, 1
  %call = call %List* @zeros(i64 %sub)
  store %List* %call, %List** %param6, align 8
  ret %List* %gadt3
}

define void @pprint_list(%List* %list) {
entry:
  %list1 = alloca %List*, align 8
  store %List* %list, %List** %list1, align 8
  %string_ptr = alloca i8*, align 8
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @string, i32 0, i32 0), i8** %string_ptr, align 8
  %load = load i8*, i8** %string_ptr, align 8
  %call = call i64 (i8*, ...) @printf(i8* %load)
  %load2 = load %List*, %List** %list1, align 8
  %call3 = call i64 @print_list(%List* %load2)
  %string_ptr4 = alloca i8*, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @string.1, i32 0, i32 0), i8** %string_ptr4, align 8
  %load5 = load i8*, i8** %string_ptr4, align 8
  %call6 = call i64 (i8*, ...) @printf(i8* %load5)
  ret void
}

define i64 @print_list(%List* %list) {
entry:
  %list1 = alloca %List*, align 8
  store %List* %list, %List** %list1, align 8
  %load = load %List*, %List** %list1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 0, label %Cons_block
  ]

after_case:                                       ; preds = %case_else, %Cons_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %Cons_block2
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case

Cons_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Cons, %constructor_Cons* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %inner_ptr, i32 0, i32 1
  %load4 = load i64, i64* %param, align 4
  %load5 = load %List*, %List** %param3, align 8
  %call = call i64 @print_cons(i64 %load4, %List* %load5)
  store i64 %call, i64* %case_result_ptr, align 4
  br label %after_case

Cons_block2:                                      ; No predecessors!
  br label %case_else
}

define i64 @print_cons(i64 %head, %List* %tail) {
entry:
  %head1 = alloca i64, align 8
  store i64 %head, i64* %head1, align 4
  %tail2 = alloca %List*, align 8
  store %List* %tail, %List** %tail2, align 8
  %load = load %List*, %List** %tail2, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %Nil_block
  ]

after_case:                                       ; preds = %case_else, %Nil_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  %is_last = alloca i64, align 8
  store i64 %case_result, i64* %is_last, align 4
  %string_ptr = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @string.2, i32 0, i32 0), i8** %string_ptr, align 8
  %load4 = load i8*, i8** %string_ptr, align 8
  %load5 = load i64, i64* %head1, align 4
  %call = call i64 (i8*, ...) @printf(i8* %load4, i64 %load5)
  %load6 = load i64, i64* %is_last, align 4
  %not = xor i64 %load6, -1
  %condition = trunc i64 %not to i1
  br i1 %condition, label %then, label %else

case_else:                                        ; preds = %entry, %Nil_block3
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case

Nil_block:                                        ; preds = %entry
  %bitcast_inner_ptr = bitcast %constructor_Cons* %inner_ptr to %constructor_Nil*
  store i64 -1, i64* %case_result_ptr, align 4
  br label %after_case

Nil_block3:                                       ; No predecessors!
  br label %case_else

then:                                             ; preds = %after_case
  %string_ptr7 = alloca i8*, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @string.3, i32 0, i32 0), i8** %string_ptr7, align 8
  %load8 = load i8*, i8** %string_ptr7, align 8
  %call9 = call i64 (i8*, ...) @printf(i8* %load8)
  br label %merge

else:                                             ; preds = %after_case
  br label %merge

merge:                                            ; preds = %else, %then
  %load10 = load %List*, %List** %tail2, align 8
  %call11 = call i64 @print_list(%List* %load10)
  ret i64 0
}

define i64 @main() {
entry:
  %call = call %List* @zeros(i64 0)
  call void @pprint_list(%List* %call)
  %call1 = call %List* @zeros(i64 1)
  call void @pprint_list(%List* %call1)
  %call2 = call %List* @zeros(i64 20)
  call void @pprint_list(%List* %call2)
  ret i64 0
}

declare noalias i8* @malloc(i32)
