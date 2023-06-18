; ModuleID = 'main'
source_filename = "main"

%Wrapper = type { i64, %constructor_Wrapper }
%constructor_Wrapper = type { %Test* }
%Test = type { i64, %constructor_Test }
%constructor_Test = type { i64, i64 }
%Option = type { i64, %constructor_Some }
%constructor_Some = type { i64 }

declare i64 @printf(i8*, ...)

define i64 @main() {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%Wrapper* getelementptr (%Wrapper, %Wrapper* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %Wrapper*
  %tag_ptr = getelementptr inbounds %Wrapper, %Wrapper* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Wrapper, %Wrapper* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Wrapper, %constructor_Wrapper* %temp_inner_ptr, i32 0, i32 0
  %malloccall1 = tail call i8* @malloc(i32 ptrtoint (%Test* getelementptr (%Test, %Test* null, i32 1) to i32))
  %gadt2 = bitcast i8* %malloccall1 to %Test*
  %tag_ptr3 = getelementptr inbounds %Test, %Test* %gadt2, i32 0, i32 0
  store i64 0, i64* %tag_ptr3, align 4
  %temp_inner_ptr4 = getelementptr inbounds %Test, %Test* %gadt2, i32 0, i32 1
  %param5 = getelementptr inbounds %constructor_Test, %constructor_Test* %temp_inner_ptr4, i32 0, i32 0
  store i64 4, i64* %param5, align 4
  %param6 = getelementptr inbounds %constructor_Test, %constructor_Test* %temp_inner_ptr4, i32 0, i32 1
  store i64 6, i64* %param6, align 4
  store %Test* %gadt2, %Test** %param, align 8
  %call = call i64 @wrapper(%Wrapper* %gadt)
  ret i64 %call
}

define i64 @wrapper(%Wrapper* %w) {
entry:
  %case_return = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Wrapper, %Wrapper* %w, i32 0, i32 1
  %tag_ptr36 = getelementptr inbounds %Wrapper, %Wrapper* %w, i32 0, i32 0
  %tag37 = load i64, i64* %tag_ptr36, align 4
  switch i64 %tag37, label %case_else [
    i64 0, label %Wrapper_block
  ]

after_case:                                       ; preds = %case_else, %Wrapper_block1821, %then_132, %then_119, %then_1
  %case_result = load i64, i64* %case_return, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %Wrapper_block182134
  store i64 -1, i64* %case_return, align 4
  br label %after_case

Wrapper_block:                                    ; preds = %entry
  %param = getelementptr inbounds %constructor_Wrapper, %constructor_Wrapper* %inner_ptr, i32 0, i32 0
  %deref_param = load %Test*, %Test** %param, align 8
  %tag_ptr = getelementptr inbounds %Test, %Test* %deref_param, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %then_0, label %Wrapper_block1

Wrapper_block1:                                   ; preds = %then_04, %then_0, %Wrapper_block
  %param9 = getelementptr inbounds %constructor_Wrapper, %constructor_Wrapper* %inner_ptr, i32 0, i32 0
  %deref_param9 = load %Test*, %Test** %param9, align 8
  %tag_ptr10 = getelementptr inbounds %Test, %Test* %deref_param9, i32 0, i32 0
  %tag11 = load i64, i64* %tag_ptr10, align 4
  %cond12 = icmp eq i64 %tag11, 0
  br i1 %cond12, label %then_013, label %Wrapper_block18

then_0:                                           ; preds = %Wrapper_block
  %param_ptr = getelementptr inbounds %Test, %Test* %deref_param, i32 0, i32 1
  %param2 = getelementptr inbounds %constructor_Test, %constructor_Test* %param_ptr, i32 0, i32 0
  %load = load i64, i64* %param2, align 4
  %cond3 = icmp eq i64 3, %load
  br i1 %cond3, label %then_04, label %Wrapper_block1

then_04:                                          ; preds = %then_0
  %param5 = getelementptr inbounds %constructor_Test, %constructor_Test* %param_ptr, i32 0, i32 1
  %load6 = load i64, i64* %param5, align 4
  %cond7 = icmp eq i64 6, %load6
  br i1 %cond7, label %then_1, label %Wrapper_block1

then_1:                                           ; preds = %then_04
  store i64 1000, i64* %case_return, align 4
  br label %after_case

Wrapper_block18:                                  ; preds = %then_013, %Wrapper_block1
  %param22 = getelementptr inbounds %constructor_Wrapper, %constructor_Wrapper* %inner_ptr, i32 0, i32 0
  %deref_param22 = load %Test*, %Test** %param22, align 8
  %tag_ptr23 = getelementptr inbounds %Test, %Test* %deref_param22, i32 0, i32 0
  %tag24 = load i64, i64* %tag_ptr23, align 4
  %cond25 = icmp eq i64 %tag24, 0
  br i1 %cond25, label %then_026, label %Wrapper_block1821

then_013:                                         ; preds = %Wrapper_block1
  %param_ptr14 = getelementptr inbounds %Test, %Test* %deref_param9, i32 0, i32 1
  %param15 = getelementptr inbounds %constructor_Test, %constructor_Test* %param_ptr14, i32 0, i32 0
  %param16 = getelementptr inbounds %constructor_Test, %constructor_Test* %param_ptr14, i32 0, i32 1
  %load17 = load i64, i64* %param16, align 4
  %cond18 = icmp eq i64 69, %load17
  br i1 %cond18, label %then_119, label %Wrapper_block18

then_119:                                         ; preds = %then_013
  %load20 = load i64, i64* %param15, align 4
  store i64 %load20, i64* %case_return, align 4
  br label %after_case

Wrapper_block1821:                                ; preds = %then_026, %Wrapper_block18
  %param35 = getelementptr inbounds %constructor_Wrapper, %constructor_Wrapper* %inner_ptr, i32 0, i32 0
  store i64 -404, i64* %case_return, align 4
  br label %after_case

then_026:                                         ; preds = %Wrapper_block18
  %param_ptr27 = getelementptr inbounds %Test, %Test* %deref_param22, i32 0, i32 1
  %param28 = getelementptr inbounds %constructor_Test, %constructor_Test* %param_ptr27, i32 0, i32 0
  %param29 = getelementptr inbounds %constructor_Test, %constructor_Test* %param_ptr27, i32 0, i32 1
  %load30 = load i64, i64* %param29, align 4
  %cond31 = icmp eq i64 100, %load30
  br i1 %cond31, label %then_132, label %Wrapper_block1821

then_132:                                         ; preds = %then_026
  %load33 = load i64, i64* %param28, align 4
  %mul = mul i64 %load33, 2
  store i64 %mul, i64* %case_return, align 4
  br label %after_case

Wrapper_block182134:                              ; No predecessors!
  br label %case_else
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
    i64 1, label %None_block
    i64 0, label %Some_block
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
    i64 0, label %Some_block
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
    i64 1, label %None_block
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
    i64 0, label %Some_block
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
    i64 1, label %None_block
    i64 0, label %Some_block
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
