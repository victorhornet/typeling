; ModuleID = 'main'
source_filename = "main"

%Option = type { i64, %constructor_Some }
%constructor_Some = type { i64 }
%constructor_None = type {}
%Test = type { i64, %constructor_Test }
%constructor_Test = type { i64, i64 }

declare i64 @printf(i8*, ...)

define i64 @main() {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%Option* getelementptr (%Option, %Option* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %Option*
  %tag_ptr = getelementptr inbounds %Option, %Option* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Option, %Option* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Some, %constructor_Some* %temp_inner_ptr, i32 0, i32 0
  store i64 420, i64* %param, align 4
  %s = alloca %Option*, align 8
  store %Option* %gadt, %Option** %s, align 8
  %malloccall1 = tail call i8* @malloc(i32 ptrtoint (%Option* getelementptr (%Option, %Option* null, i32 1) to i32))
  %gadt2 = bitcast i8* %malloccall1 to %Option*
  %tag_ptr3 = getelementptr inbounds %Option, %Option* %gadt2, i32 0, i32 0
  store i64 0, i64* %tag_ptr3, align 4
  %temp_inner_ptr4 = getelementptr inbounds %Option, %Option* %gadt2, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Some* %temp_inner_ptr4 to %constructor_None*
  %n = alloca %Option*, align 8
  store %Option* %gadt2, %Option** %n, align 8
  %malloccall5 = tail call i8* @malloc(i32 ptrtoint (%Test* getelementptr (%Test, %Test* null, i32 1) to i32))
  %gadt6 = bitcast i8* %malloccall5 to %Test*
  %tag_ptr7 = getelementptr inbounds %Test, %Test* %gadt6, i32 0, i32 0
  store i64 0, i64* %tag_ptr7, align 4
  %temp_inner_ptr8 = getelementptr inbounds %Test, %Test* %gadt6, i32 0, i32 1
  %param9 = getelementptr inbounds %constructor_Test, %constructor_Test* %temp_inner_ptr8, i32 0, i32 0
  store i64 8, i64* %param9, align 4
  %call = call i64 @ten_or_else(%Test* %gadt6)
  ret i64 %call
}

define i64 @ten_or_else(%Test* %t) {
entry:
  %case_return = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Test, %Test* %t, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %Test, %Test* %t, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 0, label %Test_block
  ]

after_case:                                       ; preds = %case_else, %then_07, %then_0
  %case_result = load i64, i64* %case_return, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %Test_block13
  store i64 0, i64* %case_return, align 4
  br label %after_case

Test_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Test, %constructor_Test* %inner_ptr, i32 0, i32 0
  %load = load i64, i64* %param, align 4
  %cond = icmp eq i64 10, %load
  br i1 %cond, label %then_0, label %Test_block1

Test_block1:                                      ; preds = %Test_block
  %param4 = getelementptr inbounds %constructor_Test, %constructor_Test* %inner_ptr, i32 0, i32 0
  %load5 = load i64, i64* %param4, align 4
  %cond6 = icmp eq i64 8, %load5
  br i1 %cond6, label %then_07, label %Test_block13

then_0:                                           ; preds = %Test_block
  %param2 = getelementptr inbounds %constructor_Test, %constructor_Test* %inner_ptr, i32 0, i32 1
  store i64 10, i64* %case_return, align 4
  br label %after_case

Test_block13:                                     ; preds = %Test_block1
  br label %case_else

then_07:                                          ; preds = %Test_block1
  %param8 = getelementptr inbounds %constructor_Test, %constructor_Test* %inner_ptr, i32 0, i32 1
  %load9 = load i64, i64* %param8, align 4
  store i64 %load9, i64* %case_return, align 4
  br label %after_case
}

define i64 @unwrap_or(%Option* %o, i64 %d) {
entry:
  %case_return = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %Some_block
    i64 0, label %None_block
  ]

after_case:                                       ; preds = %case_else, %None_block, %Some_block
  %case_result = load i64, i64* %case_return, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %None_block2, %Some_block1
  store i64 0, i64* %case_return, align 4
  br label %after_case

Some_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Some, %constructor_Some* %inner_ptr, i32 0, i32 0
  %load = load i64, i64* %param, align 4
  store i64 %load, i64* %case_return, align 4
  br label %after_case

None_block:                                       ; preds = %entry
  store i64 %d, i64* %case_return, align 4
  br label %after_case

Some_block1:                                      ; No predecessors!
  br label %case_else

None_block2:                                      ; No predecessors!
  br label %case_else
}

define i64 @is_some(%Option* %o) {
entry:
  %case_return = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %Some_block
  ]

after_case:                                       ; preds = %case_else, %Some_block
  %case_result = load i64, i64* %case_return, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %Some_block1
  store i64 0, i64* %case_return, align 4
  br label %after_case

Some_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Some, %constructor_Some* %inner_ptr, i32 0, i32 0
  store i64 -1, i64* %case_return, align 4
  br label %after_case

Some_block1:                                      ; No predecessors!
  br label %case_else
}

define i64 @is_none(%Option* %o) {
entry:
  %case_return = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 0, label %None_block
  ]

after_case:                                       ; preds = %case_else, %None_block
  %case_result = load i64, i64* %case_return, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %None_block1
  store i64 0, i64* %case_return, align 4
  br label %after_case

None_block:                                       ; preds = %entry
  store i64 -1, i64* %case_return, align 4
  br label %after_case

None_block1:                                      ; No predecessors!
  br label %case_else
}

define i64 @is_five(%Option* %o) {
entry:
  %case_return = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %Some_block
  ]

after_case:                                       ; preds = %case_else, %then_0
  %case_result = load i64, i64* %case_return, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %Some_block1
  store i64 0, i64* %case_return, align 4
  br label %after_case

Some_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Some, %constructor_Some* %inner_ptr, i32 0, i32 0
  %load = load i64, i64* %param, align 4
  %cond = icmp eq i64 5, %load
  br i1 %cond, label %then_0, label %Some_block1

Some_block1:                                      ; preds = %Some_block
  br label %case_else

then_0:                                           ; preds = %Some_block
  store i64 -1, i64* %case_return, align 4
  br label %after_case
}

define i64 @unwrap_or_default(%Option* %o) {
entry:
  %case_return = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 0, label %None_block
    i64 1, label %Some_block
  ]

after_case:                                       ; preds = %case_else, %None_block, %Some_block
  %case_result = load i64, i64* %case_return, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %Some_block1, %None_block2
  store i64 0, i64* %case_return, align 4
  br label %after_case

Some_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Some, %constructor_Some* %inner_ptr, i32 0, i32 0
  %load = load i64, i64* %param, align 4
  store i64 %load, i64* %case_return, align 4
  br label %after_case

None_block:                                       ; preds = %entry
  store i64 0, i64* %case_return, align 4
  br label %after_case

Some_block1:                                      ; No predecessors!
  br label %case_else

None_block2:                                      ; No predecessors!
  br label %case_else
}

define i64 @useless_case(%Option* %o) {
entry:
  %case_return = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %Option, %Option* %o, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
  ]

after_case:                                       ; preds = %case_else
  %case_result = load i64, i64* %case_return, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry
  %x = alloca %Option*, align 8
  store %Option* %o, %Option** %x, align 8
  store i64 0, i64* %case_return, align 4
  br label %after_case
}

define i64 @int_case(i64 %x) {
entry:
  %case_return = alloca i64, align 8
  switch i64 %x, label %case_else [
    i64 420, label %value_branch
    i64 32, label %value_branch1
  ]

after_case:                                       ; preds = %case_else, %value_branch1, %value_branch
  %case_result_value = load i64, i64* %case_return, align 4
  ret i64 %case_result_value

case_else:                                        ; preds = %entry
  %t = alloca i64, align 8
  store i64 %x, i64* %t, align 4
  %load = load i64, i64* %t, align 4
  store i64 %load, i64* %case_return, align 4
  br label %after_case

value_branch:                                     ; preds = %entry
  store i64 100, i64* %case_return, align 4
  br label %after_case

value_branch1:                                    ; preds = %entry
  store i64 142, i64* %case_return, align 4
  br label %after_case
}

declare noalias i8* @malloc(i32)
