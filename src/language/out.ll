; ModuleID = 'main'
source_filename = "main"

%List = type { i64, %constructor_Node }
%constructor_Node = type { i64, %List* }
%constructor_Empty = type {}
%Option = type { i64, %constructor_Some }
%constructor_Some = type { i64 }
%constructor_None = type {}

@string = private unnamed_addr constant [10 x i8] c"x = %lli\0A\00", align 1
@string.1 = private unnamed_addr constant [10 x i8] c"z = %lli\0A\00", align 1
@string.2 = private unnamed_addr constant [19 x i8] c"head(list) = %lli\0A\00", align 1
@string.3 = private unnamed_addr constant [16 x i8] c"list[4] = %lli\0A\00", align 1

declare i64 @printf(i8*, ...)

define i64 @main() {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 0
  store i64 2, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 1
  %malloccall2 = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt3 = bitcast i8* %malloccall2 to %List*
  %tag_ptr4 = getelementptr inbounds %List, %List* %gadt3, i32 0, i32 0
  store i64 1, i64* %tag_ptr4, align 4
  %temp_inner_ptr5 = getelementptr inbounds %List, %List* %gadt3, i32 0, i32 1
  %param6 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr5, i32 0, i32 0
  store i64 3, i64* %param6, align 4
  %param7 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr5, i32 0, i32 1
  %malloccall8 = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt9 = bitcast i8* %malloccall8 to %List*
  %tag_ptr10 = getelementptr inbounds %List, %List* %gadt9, i32 0, i32 0
  store i64 0, i64* %tag_ptr10, align 4
  %temp_inner_ptr11 = getelementptr inbounds %List, %List* %gadt9, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Node* %temp_inner_ptr11 to %constructor_Empty*
  store %List* %gadt9, %List** %param7, align 8
  store %List* %gadt3, %List** %param1, align 8
  %list = alloca %List*, align 8
  store %List* %gadt, %List** %list, align 8
  %load = load %List*, %List** %list, align 8
  %call = call %Option* @head(%List* %load)
  %x = alloca %Option*, align 8
  store %Option* %call, %Option** %x, align 8
  %string_ptr = alloca i8*, align 8
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @string, i32 0, i32 0), i8** %string_ptr, align 8
  %load12 = load i8*, i8** %string_ptr, align 8
  %load13 = load %Option*, %Option** %x, align 8
  %call14 = call i64 @unwrap_or_default(%Option* %load13)
  %call15 = call i64 (i8*, ...) @printf(i8* %load12, i64 %call14)
  %load16 = load %List*, %List** %list, align 8
  %call17 = call %List* @tail(%List* %load16)
  %y = alloca %List*, align 8
  store %List* %call17, %List** %y, align 8
  %load18 = load %List*, %List** %y, align 8
  %call19 = call %Option* @head(%List* %load18)
  %z = alloca %Option*, align 8
  store %Option* %call19, %Option** %z, align 8
  %string_ptr20 = alloca i8*, align 8
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @string.1, i32 0, i32 0), i8** %string_ptr20, align 8
  %load21 = load i8*, i8** %string_ptr20, align 8
  %load22 = load %Option*, %Option** %z, align 8
  %call23 = call i64 @unwrap_or_default(%Option* %load22)
  %call24 = call i64 (i8*, ...) @printf(i8* %load21, i64 %call23)
  %malloccall25 = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt26 = bitcast i8* %malloccall25 to %List*
  %tag_ptr27 = getelementptr inbounds %List, %List* %gadt26, i32 0, i32 0
  store i64 1, i64* %tag_ptr27, align 4
  %temp_inner_ptr28 = getelementptr inbounds %List, %List* %gadt26, i32 0, i32 1
  %param29 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr28, i32 0, i32 0
  store i64 1, i64* %param29, align 4
  %param30 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr28, i32 0, i32 1
  %load31 = load %List*, %List** %list, align 8
  store %List* %load31, %List** %param30, align 8
  store %List* %gadt26, %List** %list, align 8
  %string_ptr32 = alloca i8*, align 8
  store i8* getelementptr inbounds ([19 x i8], [19 x i8]* @string.2, i32 0, i32 0), i8** %string_ptr32, align 8
  %load33 = load i8*, i8** %string_ptr32, align 8
  %load34 = load %List*, %List** %list, align 8
  %call35 = call %Option* @head(%List* %load34)
  %call36 = call i64 @unwrap_or_default(%Option* %call35)
  %call37 = call i64 (i8*, ...) @printf(i8* %load33, i64 %call36)
  %load38 = load %List*, %List** %list, align 8
  %call39 = call %List* @append(i64 4, %List* %load38)
  store %List* %call39, %List** %list, align 8
  %string_ptr40 = alloca i8*, align 8
  store i8* getelementptr inbounds ([16 x i8], [16 x i8]* @string.3, i32 0, i32 0), i8** %string_ptr40, align 8
  %load41 = load i8*, i8** %string_ptr40, align 8
  %load42 = load %List*, %List** %list, align 8
  %call43 = call %Option* @get(i64 4, %List* %load42)
  %call44 = call i64 @unwrap_or_default(%Option* %call43)
  %call45 = call i64 (i8*, ...) @printf(i8* %load41, i64 %call44)
  %case_result_ptr = alloca i64, align 8
  switch i64 11, label %case_else [
    i64 11, label %value_branch
  ]

after_case:                                       ; preds = %case_else, %value_branch
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry
  store i64 200, i64* %case_result_ptr, align 4
  br label %after_case

value_branch:                                     ; preds = %entry
  store i64 404, i64* %case_result_ptr, align 4
  br label %after_case
}

define %Option* @get(i64 %i, %List* %l) {
entry:
  %i1 = alloca i64, align 8
  store i64 %i, i64* %i1, align 4
  %l2 = alloca %List*, align 8
  store %List* %l, %List** %l2, align 8
  %load = load %List*, %List** %l2, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 1
  %tag_ptr21 = getelementptr inbounds %List, %List* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr21, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %Node_block
  ]

after_case:                                       ; preds = %case_else, %after_case7
  %case_result22 = load i64, i64* %case_result_ptr, align 4
  %case_result_adt_ptr23 = inttoptr i64 %case_result22 to %Option*
  ret %Option* %case_result_adt_ptr23

case_else:                                        ; preds = %entry, %Node_block3
  %malloccall15 = tail call i8* @malloc(i32 ptrtoint (%Option* getelementptr (%Option, %Option* null, i32 1) to i32))
  %gadt16 = bitcast i8* %malloccall15 to %Option*
  %tag_ptr17 = getelementptr inbounds %Option, %Option* %gadt16, i32 0, i32 0
  store i64 1, i64* %tag_ptr17, align 4
  %temp_inner_ptr18 = getelementptr inbounds %Option, %Option* %gadt16, i32 0, i32 1
  %inner_ptr19 = bitcast %constructor_Some* %temp_inner_ptr18 to %constructor_None*
  %ptr_value20 = ptrtoint %Option* %gadt16 to i64
  store i64 %ptr_value20, i64* %case_result_ptr, align 4
  br label %after_case

Node_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Node, %constructor_Node* %inner_ptr, i32 0, i32 0
  %param4 = getelementptr inbounds %constructor_Node, %constructor_Node* %inner_ptr, i32 0, i32 1
  %load5 = load i64, i64* %i1, align 4
  %case_result_ptr6 = alloca i64, align 8
  switch i64 %load5, label %case_else8 [
    i64 0, label %value_branch
  ]

Node_block3:                                      ; No predecessors!
  br label %case_else

after_case7:                                      ; preds = %case_else8, %value_branch
  %case_result = load i64, i64* %case_result_ptr6, align 4
  %case_result_adt_ptr = inttoptr i64 %case_result to %Option*
  %ptr_value14 = ptrtoint %Option* %case_result_adt_ptr to i64
  store i64 %ptr_value14, i64* %case_result_ptr, align 4
  br label %after_case

case_else8:                                       ; preds = %Node_block
  %load11 = load i64, i64* %i1, align 4
  %sub = sub i64 %load11, 1
  %load12 = load %List*, %List** %param4, align 8
  %call = call %Option* @get(i64 %sub, %List* %load12)
  %ptr_value13 = ptrtoint %Option* %call to i64
  store i64 %ptr_value13, i64* %case_result_ptr6, align 4
  br label %after_case7

value_branch:                                     ; preds = %Node_block
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%Option* getelementptr (%Option, %Option* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %Option*
  %tag_ptr = getelementptr inbounds %Option, %Option* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Option, %Option* %gadt, i32 0, i32 1
  %param9 = getelementptr inbounds %constructor_Some, %constructor_Some* %temp_inner_ptr, i32 0, i32 0
  %load10 = load i64, i64* %param, align 4
  store i64 %load10, i64* %param9, align 4
  %ptr_value = ptrtoint %Option* %gadt to i64
  store i64 %ptr_value, i64* %case_result_ptr6, align 4
  br label %after_case7
}

define %List* @prepend(i64 %x, %List* %xs) {
entry:
  %x1 = alloca i64, align 8
  store i64 %x, i64* %x1, align 4
  %xs2 = alloca %List*, align 8
  store %List* %xs, %List** %xs2, align 8
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 0
  %load = load i64, i64* %x1, align 4
  store i64 %load, i64* %param, align 4
  %param3 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 1
  %load4 = load %List*, %List** %xs2, align 8
  store %List* %load4, %List** %param3, align 8
  ret %List* %gadt
}

define %List* @append(i64 %x, %List* %xs) {
entry:
  %x1 = alloca i64, align 8
  store i64 %x, i64* %x1, align 4
  %xs2 = alloca %List*, align 8
  store %List* %xs, %List** %xs2, align 8
  %load = load %List*, %List** %xs2, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 1
  %tag_ptr23 = getelementptr inbounds %List, %List* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr23, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %Node_block
  ]

after_case:                                       ; preds = %case_else, %Node_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  %case_result_adt_ptr = inttoptr i64 %case_result to %List*
  ret %List* %case_result_adt_ptr

case_else:                                        ; preds = %entry, %Node_block3
  %malloccall10 = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt11 = bitcast i8* %malloccall10 to %List*
  %tag_ptr12 = getelementptr inbounds %List, %List* %gadt11, i32 0, i32 0
  store i64 1, i64* %tag_ptr12, align 4
  %temp_inner_ptr13 = getelementptr inbounds %List, %List* %gadt11, i32 0, i32 1
  %param14 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr13, i32 0, i32 0
  %load15 = load i64, i64* %x1, align 4
  store i64 %load15, i64* %param14, align 4
  %param16 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr13, i32 0, i32 1
  %malloccall17 = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt18 = bitcast i8* %malloccall17 to %List*
  %tag_ptr19 = getelementptr inbounds %List, %List* %gadt18, i32 0, i32 0
  store i64 0, i64* %tag_ptr19, align 4
  %temp_inner_ptr20 = getelementptr inbounds %List, %List* %gadt18, i32 0, i32 1
  %inner_ptr21 = bitcast %constructor_Node* %temp_inner_ptr20 to %constructor_Empty*
  store %List* %gadt18, %List** %param16, align 8
  %ptr_value22 = ptrtoint %List* %gadt11 to i64
  store i64 %ptr_value22, i64* %case_result_ptr, align 4
  br label %after_case

Node_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Node, %constructor_Node* %inner_ptr, i32 0, i32 0
  %param4 = getelementptr inbounds %constructor_Node, %constructor_Node* %inner_ptr, i32 0, i32 1
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %param5 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 0
  %load6 = load i64, i64* %param, align 4
  store i64 %load6, i64* %param5, align 4
  %param7 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 1
  %load8 = load i64, i64* %x1, align 4
  %load9 = load %List*, %List** %param4, align 8
  %call = call %List* @append(i64 %load8, %List* %load9)
  store %List* %call, %List** %param7, align 8
  %ptr_value = ptrtoint %List* %gadt to i64
  store i64 %ptr_value, i64* %case_result_ptr, align 4
  br label %after_case

Node_block3:                                      ; No predecessors!
  br label %case_else
}

define i64 @is_empty(%List* %l) {
entry:
  %l1 = alloca %List*, align 8
  store %List* %l, %List** %l1, align 8
  %load = load %List*, %List** %l1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 0, label %Empty_block
  ]

after_case:                                       ; preds = %case_else, %Empty_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %Empty_block2
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case

Empty_block:                                      ; preds = %entry
  store i64 -1, i64* %case_result_ptr, align 4
  br label %after_case

Empty_block2:                                     ; No predecessors!
  br label %case_else
}

define %Option* @head(%List* %l) {
entry:
  %l1 = alloca %List*, align 8
  store %List* %l, %List** %l1, align 8
  %load = load %List*, %List** %l1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 1
  %tag_ptr12 = getelementptr inbounds %List, %List* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr12, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %Node_block
  ]

after_case:                                       ; preds = %case_else, %Node_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  %case_result_adt_ptr = inttoptr i64 %case_result to %Option*
  ret %Option* %case_result_adt_ptr

case_else:                                        ; preds = %entry, %Node_block2
  %malloccall6 = tail call i8* @malloc(i32 ptrtoint (%Option* getelementptr (%Option, %Option* null, i32 1) to i32))
  %gadt7 = bitcast i8* %malloccall6 to %Option*
  %tag_ptr8 = getelementptr inbounds %Option, %Option* %gadt7, i32 0, i32 0
  store i64 1, i64* %tag_ptr8, align 4
  %temp_inner_ptr9 = getelementptr inbounds %Option, %Option* %gadt7, i32 0, i32 1
  %inner_ptr10 = bitcast %constructor_Some* %temp_inner_ptr9 to %constructor_None*
  %ptr_value11 = ptrtoint %Option* %gadt7 to i64
  store i64 %ptr_value11, i64* %case_result_ptr, align 4
  br label %after_case

Node_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Node, %constructor_Node* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_Node, %constructor_Node* %inner_ptr, i32 0, i32 1
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%Option* getelementptr (%Option, %Option* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %Option*
  %tag_ptr = getelementptr inbounds %Option, %Option* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Option, %Option* %gadt, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_Some, %constructor_Some* %temp_inner_ptr, i32 0, i32 0
  %load5 = load i64, i64* %param, align 4
  store i64 %load5, i64* %param4, align 4
  %ptr_value = ptrtoint %Option* %gadt to i64
  store i64 %ptr_value, i64* %case_result_ptr, align 4
  br label %after_case

Node_block2:                                      ; No predecessors!
  br label %case_else
}

define %List* @tail(%List* %l) {
entry:
  %l1 = alloca %List*, align 8
  store %List* %l, %List** %l1, align 8
  %load = load %List*, %List** %l1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %List, %List* %load, i32 0, i32 1
  %tag_ptr7 = getelementptr inbounds %List, %List* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr7, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %Node_block
  ]

after_case:                                       ; preds = %case_else, %Node_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  %case_result_adt_ptr = inttoptr i64 %case_result to %List*
  ret %List* %case_result_adt_ptr

case_else:                                        ; preds = %entry, %Node_block2
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%List* getelementptr (%List, %List* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %inner_ptr5 = bitcast %constructor_Node* %temp_inner_ptr to %constructor_Empty*
  %ptr_value6 = ptrtoint %List* %gadt to i64
  store i64 %ptr_value6, i64* %case_result_ptr, align 4
  br label %after_case

Node_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Node, %constructor_Node* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_Node, %constructor_Node* %inner_ptr, i32 0, i32 1
  %load4 = load %List*, %List** %param3, align 8
  %ptr_value = ptrtoint %List* %load4 to i64
  store i64 %ptr_value, i64* %case_result_ptr, align 4
  br label %after_case

Node_block2:                                      ; No predecessors!
  br label %case_else
}

define i64 @unwrap_or_default(%Option* %x) {
entry:
  %x1 = alloca %Option*, align 8
  store %Option* %x, %Option** %x1, align 8
  %load = load %Option*, %Option** %x1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Option, %Option* %load, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %Option, %Option* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 0, label %Some_block
  ]

after_case:                                       ; preds = %case_else, %Some_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %Some_block2
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case

Some_block:                                       ; preds = %entry
  %param = getelementptr inbounds %constructor_Some, %constructor_Some* %inner_ptr, i32 0, i32 0
  %load3 = load i64, i64* %param, align 4
  store i64 %load3, i64* %case_result_ptr, align 4
  br label %after_case

Some_block2:                                      ; No predecessors!
  br label %case_else
}

declare noalias i8* @malloc(i32)
