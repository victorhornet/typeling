; ModuleID = 'main'
source_filename = "main"

%Tuple = type { i64, %constructor_Tuple }
%constructor_Tuple = type { i64, i64 }
%BinTree = type { i64, %constructor_BNode }
%constructor_BNode = type { i64, %BinTree*, %BinTree* }
%constructor_BEmpty = type {}
%List = type { i64, %constructor_Node }
%constructor_Node = type { i64, %List* }
%constructor_Empty = type {}
%Option = type { i64, %constructor_Some }
%constructor_Some = type { i64 }
%constructor_None = type {}

@string = private unnamed_addr constant [10 x i8] c"x = %lli\0A\00", align 1
@string.1 = private unnamed_addr constant [12 x i8] c"min = %lli\0A\00", align 1
@string.2 = private unnamed_addr constant [10 x i8] c"x = %lli\0A\00", align 1
@string.3 = private unnamed_addr constant [10 x i8] c"z = %lli\0A\00", align 1
@string.4 = private unnamed_addr constant [19 x i8] c"head(list) = %lli\0A\00", align 1
@string.5 = private unnamed_addr constant [16 x i8] c"list[4] = %lli\0A\00", align 1
@string.6 = private unnamed_addr constant [12 x i8] c"min = %lli\0A\00", align 1

declare i64 @printf(i8*, ...)

define void @main() {
entry:
  call void @list_demo()
  call void @benchmark()
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%Tuple* getelementptr (%Tuple, %Tuple* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %Tuple*
  %tag_ptr = getelementptr inbounds %Tuple, %Tuple* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Tuple, %Tuple* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %temp_inner_ptr, i32 0, i32 0
  store i64 10, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %temp_inner_ptr, i32 0, i32 1
  store i64 20, i64* %param1, align 4
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %Tuple, %Tuple* %gadt, i32 0, i32 1
  %tag_ptr5 = getelementptr inbounds %Tuple, %Tuple* %gadt, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr5, align 4
  switch i64 %tag, label %case_else [
    i64 0, label %Tuple_block
  ]

after_case:                                       ; preds = %case_else, %Tuple_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  %x = alloca i64, align 8
  store i64 %case_result, i64* %x, align 4
  %string_ptr = alloca i8*, align 8
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @string, i32 0, i32 0), i8** %string_ptr, align 8
  %load6 = load i8*, i8** %string_ptr, align 8
  %load7 = load i64, i64* %x, align 4
  %call = call i64 (i8*, ...) @printf(i8* %load6, i64 %load7)
  ret void

case_else:                                        ; preds = %entry, %Tuple_block2
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case

Tuple_block:                                      ; preds = %entry
  %param3 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %inner_ptr, i32 0, i32 0
  %param4 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %inner_ptr, i32 0, i32 1
  %load = load i64, i64* %param3, align 4
  store i64 %load, i64* %case_result_ptr, align 4
  br label %after_case

Tuple_block2:                                     ; No predecessors!
  br label %case_else
}

define void @benchmark() {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %inner_ptr = bitcast %constructor_BNode* %temp_inner_ptr to %constructor_BEmpty*
  %tree = alloca %BinTree*, align 8
  store %BinTree* %gadt, %BinTree** %tree, align 8
  %i = alloca i64, align 8
  store i64 1000, i64* %i, align 4
  br label %while

while:                                            ; preds = %body, %entry
  %load = load i64, i64* %i, align 4
  %gt = icmp sgt i64 %load, 0
  %gt_i64 = sext i1 %gt to i64
  %condition = trunc i64 %gt_i64 to i1
  br i1 %condition, label %body, label %merge

body:                                             ; preds = %while
  %load1 = load i64, i64* %i, align 4
  %load2 = load %BinTree*, %BinTree** %tree, align 8
  %call = call %BinTree* @insert(i64 %load1, %BinTree* %load2)
  store %BinTree* %call, %BinTree** %tree, align 8
  %load3 = load i64, i64* %i, align 4
  %neg = sub i64 0, %load3
  %load4 = load %BinTree*, %BinTree** %tree, align 8
  %call5 = call %BinTree* @insert(i64 %neg, %BinTree* %load4)
  store %BinTree* %call5, %BinTree** %tree, align 8
  %load6 = load i64, i64* %i, align 4
  %sub = sub i64 %load6, 1
  store i64 %sub, i64* %i, align 4
  br label %while

merge:                                            ; preds = %while
  %load7 = load %BinTree*, %BinTree** %tree, align 8
  %call8 = call %BinTree* @insert(i64 5, %BinTree* %load7)
  store %BinTree* %call8, %BinTree** %tree, align 8
  %load9 = load %BinTree*, %BinTree** %tree, align 8
  %call10 = call %BinTree* @insert(i64 3, %BinTree* %load9)
  store %BinTree* %call10, %BinTree** %tree, align 8
  %load11 = load %BinTree*, %BinTree** %tree, align 8
  %call12 = call %BinTree* @insert(i64 7, %BinTree* %load11)
  store %BinTree* %call12, %BinTree** %tree, align 8
  %load13 = load %BinTree*, %BinTree** %tree, align 8
  %call14 = call %BinTree* @insert(i64 4, %BinTree* %load13)
  store %BinTree* %call14, %BinTree** %tree, align 8
  %load15 = load %BinTree*, %BinTree** %tree, align 8
  %call16 = call %BinTree* @insert(i64 6, %BinTree* %load15)
  store %BinTree* %call16, %BinTree** %tree, align 8
  %load17 = load %BinTree*, %BinTree** %tree, align 8
  %call18 = call %BinTree* @insert(i64 2, %BinTree* %load17)
  store %BinTree* %call18, %BinTree** %tree, align 8
  %string_ptr = alloca i8*, align 8
  store i8* getelementptr inbounds ([12 x i8], [12 x i8]* @string.1, i32 0, i32 0), i8** %string_ptr, align 8
  %load19 = load i8*, i8** %string_ptr, align 8
  %load20 = load %BinTree*, %BinTree** %tree, align 8
  %call21 = call i64 @get_min(%BinTree* %load20)
  %call22 = call i64 (i8*, ...) @printf(i8* %load19, i64 %call21)
  ret void
}

define void @list_demo() {
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
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @string.2, i32 0, i32 0), i8** %string_ptr, align 8
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
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @string.3, i32 0, i32 0), i8** %string_ptr20, align 8
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
  store i8* getelementptr inbounds ([19 x i8], [19 x i8]* @string.4, i32 0, i32 0), i8** %string_ptr32, align 8
  %load33 = load i8*, i8** %string_ptr32, align 8
  %load34 = load %List*, %List** %list, align 8
  %call35 = call %Option* @head(%List* %load34)
  %call36 = call i64 @unwrap_or_default(%Option* %call35)
  %call37 = call i64 (i8*, ...) @printf(i8* %load33, i64 %call36)
  %load38 = load %List*, %List** %list, align 8
  %call39 = call %List* @push(i64 4, %List* %load38)
  store %List* %call39, %List** %list, align 8
  %string_ptr40 = alloca i8*, align 8
  store i8* getelementptr inbounds ([16 x i8], [16 x i8]* @string.5, i32 0, i32 0), i8** %string_ptr40, align 8
  %load41 = load i8*, i8** %string_ptr40, align 8
  %load42 = load %List*, %List** %list, align 8
  %call43 = call %Option* @get(i64 4, %List* %load42)
  %call44 = call i64 @unwrap_or_default(%Option* %call43)
  %call45 = call i64 (i8*, ...) @printf(i8* %load41, i64 %call44)
  ret void
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

define %List* @pop(%List* %xs) {
entry:
  %xs1 = alloca %List*, align 8
  store %List* %xs, %List** %xs1, align 8
  %load = load %List*, %List** %xs1, align 8
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

define %List* @push(i64 %x, %List* %xs) {
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
  %call = call %List* @push(i64 %load8, %List* %load9)
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
  %bitcast_inner_ptr = bitcast %constructor_Node* %inner_ptr to %constructor_Empty*
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

define i64 @bintree_demo() {
entry:
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %inner_ptr = bitcast %constructor_BNode* %temp_inner_ptr to %constructor_BEmpty*
  %tree = alloca %BinTree*, align 8
  store %BinTree* %gadt, %BinTree** %tree, align 8
  %load = load %BinTree*, %BinTree** %tree, align 8
  %call = call %BinTree* @insert(i64 5, %BinTree* %load)
  store %BinTree* %call, %BinTree** %tree, align 8
  %load1 = load %BinTree*, %BinTree** %tree, align 8
  %call2 = call %BinTree* @insert(i64 3, %BinTree* %load1)
  store %BinTree* %call2, %BinTree** %tree, align 8
  %load3 = load %BinTree*, %BinTree** %tree, align 8
  %call4 = call %BinTree* @insert(i64 7, %BinTree* %load3)
  store %BinTree* %call4, %BinTree** %tree, align 8
  %load5 = load %BinTree*, %BinTree** %tree, align 8
  %call6 = call %BinTree* @insert(i64 4, %BinTree* %load5)
  store %BinTree* %call6, %BinTree** %tree, align 8
  %load7 = load %BinTree*, %BinTree** %tree, align 8
  %call8 = call %BinTree* @insert(i64 6, %BinTree* %load7)
  store %BinTree* %call8, %BinTree** %tree, align 8
  %load9 = load %BinTree*, %BinTree** %tree, align 8
  %call10 = call %BinTree* @insert(i64 2, %BinTree* %load9)
  store %BinTree* %call10, %BinTree** %tree, align 8
  %string_ptr = alloca i8*, align 8
  store i8* getelementptr inbounds ([12 x i8], [12 x i8]* @string.6, i32 0, i32 0), i8** %string_ptr, align 8
  %load11 = load i8*, i8** %string_ptr, align 8
  %load12 = load %BinTree*, %BinTree** %tree, align 8
  %call13 = call i64 @get_min(%BinTree* %load12)
  %call14 = call i64 (i8*, ...) @printf(i8* %load11, i64 %call13)
  %load15 = load %BinTree*, %BinTree** %tree, align 8
  %call16 = call i64 @free_tree(%BinTree* %load15)
  ret i64 0
}

define i64 @free_tree(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %load = load %BinTree*, %BinTree** %root1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %BNode_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %BNode_block2
  %load11 = load %BinTree*, %BinTree** %root1, align 8
  %call12 = call i64 @helper_free(%BinTree* %load11)
  store i64 %call12, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %load5 = load %BinTree*, %BinTree** %param3, align 8
  %call = call i64 @free_tree(%BinTree* %load5)
  %load6 = load %BinTree*, %BinTree** %param4, align 8
  %call7 = call i64 @free_tree(%BinTree* %load6)
  %add = add i64 %call, %call7
  %load8 = load %BinTree*, %BinTree** %root1, align 8
  %call9 = call i64 @helper_free(%BinTree* %load8)
  %add10 = add i64 %add, %call9
  store i64 %add10, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block2:                                     ; No predecessors!
  br label %case_else
}

define %BinTree* @left(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %load = load %BinTree*, %BinTree** %root1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr8 = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr8, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %BNode_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  %case_result_adt_ptr = inttoptr i64 %case_result to %BinTree*
  ret %BinTree* %case_result_adt_ptr

case_else:                                        ; preds = %entry, %BNode_block2
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %inner_ptr6 = bitcast %constructor_BNode* %temp_inner_ptr to %constructor_BEmpty*
  %ptr_value7 = ptrtoint %BinTree* %gadt to i64
  store i64 %ptr_value7, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %load5 = load %BinTree*, %BinTree** %param3, align 8
  %ptr_value = ptrtoint %BinTree* %load5 to i64
  store i64 %ptr_value, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block2:                                     ; No predecessors!
  br label %case_else
}

define %BinTree* @right(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %load = load %BinTree*, %BinTree** %root1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr8 = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr8, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %BNode_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  %case_result_adt_ptr = inttoptr i64 %case_result to %BinTree*
  ret %BinTree* %case_result_adt_ptr

case_else:                                        ; preds = %entry, %BNode_block2
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %inner_ptr6 = bitcast %constructor_BNode* %temp_inner_ptr to %constructor_BEmpty*
  %ptr_value7 = ptrtoint %BinTree* %gadt to i64
  store i64 %ptr_value7, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %load5 = load %BinTree*, %BinTree** %param4, align 8
  %ptr_value = ptrtoint %BinTree* %load5 to i64
  store i64 %ptr_value, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block2:                                     ; No predecessors!
  br label %case_else
}

define i64 @get_value(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %load = load %BinTree*, %BinTree** %root1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %BNode_block
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %BNode_block2
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %load5 = load i64, i64* %param, align 4
  store i64 %load5, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block2:                                     ; No predecessors!
  br label %case_else
}

define i64 @helper_free(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %free_target = load %BinTree*, %BinTree** %root1, align 8
  %0 = bitcast %BinTree* %free_target to i8*
  tail call void @free(i8* %0)
  ret i64 0
}

define i64 @has_left(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %load = load %BinTree*, %BinTree** %root1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr5 = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag6 = load i64, i64* %tag_ptr5, align 4
  switch i64 %tag6, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %then_1
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %BNode_block2
  store i64 -1, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %deref_param3 = load %BinTree*, %BinTree** %param3, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %then_1, label %BNode_block2

BNode_block2:                                     ; preds = %BNode_block
  br label %case_else

then_1:                                           ; preds = %BNode_block
  %param_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case
}

define i64 @has_right(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %load = load %BinTree*, %BinTree** %root1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr5 = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag6 = load i64, i64* %tag_ptr5, align 4
  switch i64 %tag6, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %then_2
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %BNode_block2
  store i64 -1, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %deref_param4 = load %BinTree*, %BinTree** %param4, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param4, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %then_2, label %BNode_block2

BNode_block2:                                     ; preds = %BNode_block
  br label %case_else

then_2:                                           ; preds = %BNode_block
  %param_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param4, i32 0, i32 1
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case
}

define i64 @is_leaf(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %load = load %BinTree*, %BinTree** %root1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr9 = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag10 = load i64, i64* %tag_ptr9, align 4
  switch i64 %tag10, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %then_2
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %BNode_block2
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %deref_param3 = load %BinTree*, %BinTree** %param3, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %then_1, label %BNode_block2

BNode_block2:                                     ; preds = %then_1, %BNode_block
  br label %case_else

then_1:                                           ; preds = %BNode_block
  %param_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %deref_param4 = load %BinTree*, %BinTree** %param4, align 8
  %tag_ptr5 = getelementptr inbounds %BinTree, %BinTree* %deref_param4, i32 0, i32 0
  %tag6 = load i64, i64* %tag_ptr5, align 4
  %cond7 = icmp eq i64 %tag6, 0
  br i1 %cond7, label %then_2, label %BNode_block2

then_2:                                           ; preds = %then_1
  %param_ptr8 = getelementptr inbounds %BinTree, %BinTree* %deref_param4, i32 0, i32 1
  store i64 -1, i64* %case_result_ptr, align 4
  br label %after_case
}

define %BinTree* @insert(i64 %x, %BinTree* %root) {
entry:
  %x1 = alloca i64, align 8
  store i64 %x, i64* %x1, align 4
  %root2 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root2, align 8
  %load = load %BinTree*, %BinTree** %root2, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr51 = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr51, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %after_case9
  %case_result52 = load i64, i64* %case_result_ptr, align 4
  %case_result_adt_ptr53 = inttoptr i64 %case_result52 to %BinTree*
  ret %BinTree* %case_result_adt_ptr53

case_else:                                        ; preds = %entry, %BNode_block3
  %malloccall32 = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt33 = bitcast i8* %malloccall32 to %BinTree*
  %tag_ptr34 = getelementptr inbounds %BinTree, %BinTree* %gadt33, i32 0, i32 0
  store i64 1, i64* %tag_ptr34, align 4
  %temp_inner_ptr35 = getelementptr inbounds %BinTree, %BinTree* %gadt33, i32 0, i32 1
  %param36 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr35, i32 0, i32 0
  %load37 = load i64, i64* %x1, align 4
  store i64 %load37, i64* %param36, align 4
  %param38 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr35, i32 0, i32 1
  %malloccall39 = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt40 = bitcast i8* %malloccall39 to %BinTree*
  %tag_ptr41 = getelementptr inbounds %BinTree, %BinTree* %gadt40, i32 0, i32 0
  store i64 0, i64* %tag_ptr41, align 4
  %temp_inner_ptr42 = getelementptr inbounds %BinTree, %BinTree* %gadt40, i32 0, i32 1
  %inner_ptr43 = bitcast %constructor_BNode* %temp_inner_ptr42 to %constructor_BEmpty*
  store %BinTree* %gadt40, %BinTree** %param38, align 8
  %param44 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr35, i32 0, i32 2
  %malloccall45 = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt46 = bitcast i8* %malloccall45 to %BinTree*
  %tag_ptr47 = getelementptr inbounds %BinTree, %BinTree* %gadt46, i32 0, i32 0
  store i64 0, i64* %tag_ptr47, align 4
  %temp_inner_ptr48 = getelementptr inbounds %BinTree, %BinTree* %gadt46, i32 0, i32 1
  %inner_ptr49 = bitcast %constructor_BNode* %temp_inner_ptr48 to %constructor_BEmpty*
  store %BinTree* %gadt46, %BinTree** %param44, align 8
  %ptr_value50 = ptrtoint %BinTree* %gadt33 to i64
  store i64 %ptr_value50, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %param5 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %load6 = load i64, i64* %x1, align 4
  %load7 = load i64, i64* %param, align 4
  %lt = icmp slt i64 %load6, %load7
  %lt_i64 = sext i1 %lt to i64
  %case_result_ptr8 = alloca i64, align 8
  switch i64 %lt_i64, label %case_else10 [
    i64 0, label %value_branch
  ]

BNode_block3:                                     ; No predecessors!
  br label %case_else

after_case9:                                      ; preds = %case_else10, %value_branch
  %case_result = load i64, i64* %case_result_ptr8, align 4
  %case_result_adt_ptr = inttoptr i64 %case_result to %BinTree*
  %ptr_value31 = ptrtoint %BinTree* %case_result_adt_ptr to i64
  store i64 %ptr_value31, i64* %case_result_ptr, align 4
  br label %after_case

case_else10:                                      ; preds = %BNode_block
  %malloccall18 = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt19 = bitcast i8* %malloccall18 to %BinTree*
  %tag_ptr20 = getelementptr inbounds %BinTree, %BinTree* %gadt19, i32 0, i32 0
  store i64 1, i64* %tag_ptr20, align 4
  %temp_inner_ptr21 = getelementptr inbounds %BinTree, %BinTree* %gadt19, i32 0, i32 1
  %param22 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr21, i32 0, i32 0
  %load23 = load i64, i64* %param, align 4
  store i64 %load23, i64* %param22, align 4
  %param24 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr21, i32 0, i32 1
  %load25 = load i64, i64* %x1, align 4
  %load26 = load %BinTree*, %BinTree** %param4, align 8
  %call27 = call %BinTree* @insert(i64 %load25, %BinTree* %load26)
  store %BinTree* %call27, %BinTree** %param24, align 8
  %param28 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr21, i32 0, i32 2
  %load29 = load %BinTree*, %BinTree** %param5, align 8
  store %BinTree* %load29, %BinTree** %param28, align 8
  %ptr_value30 = ptrtoint %BinTree* %gadt19 to i64
  store i64 %ptr_value30, i64* %case_result_ptr8, align 4
  br label %after_case9

value_branch:                                     ; preds = %BNode_block
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %param11 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr, i32 0, i32 0
  %load12 = load i64, i64* %param, align 4
  store i64 %load12, i64* %param11, align 4
  %param13 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr, i32 0, i32 1
  %load14 = load %BinTree*, %BinTree** %param4, align 8
  store %BinTree* %load14, %BinTree** %param13, align 8
  %param15 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr, i32 0, i32 2
  %load16 = load i64, i64* %x1, align 4
  %load17 = load %BinTree*, %BinTree** %param5, align 8
  %call = call %BinTree* @insert(i64 %load16, %BinTree* %load17)
  store %BinTree* %call, %BinTree** %param15, align 8
  %ptr_value = ptrtoint %BinTree* %gadt to i64
  store i64 %ptr_value, i64* %case_result_ptr8, align 4
  br label %after_case9
}

define i64 @get_min(%BinTree* %root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %load = load %BinTree*, %BinTree** %root1, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr11 = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag12 = load i64, i64* %tag_ptr11, align 4
  switch i64 %tag12, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %BNode_block2, %then_1
  %case_result = load i64, i64* %case_result_ptr, align 4
  ret i64 %case_result

case_else:                                        ; preds = %entry, %BNode_block26
  store i64 0, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param3 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %deref_param3 = load %BinTree*, %BinTree** %param3, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %then_1, label %BNode_block2

BNode_block2:                                     ; preds = %BNode_block
  %param7 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param8 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %param9 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %load10 = load %BinTree*, %BinTree** %param8, align 8
  %call = call i64 @get_min(%BinTree* %load10)
  store i64 %call, i64* %case_result_ptr, align 4
  br label %after_case

then_1:                                           ; preds = %BNode_block
  %param_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i32 0, i32 1
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %load5 = load i64, i64* %param, align 4
  store i64 %load5, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block26:                                    ; No predecessors!
  br label %case_else
}

define i64 @insert_mut(i64 %x, %BinTree* %root) {
entry:
  %x1 = alloca i64, align 8
  store i64 %x, i64* %x1, align 4
  %root2 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root2, align 8
  %load = load %BinTree*, %BinTree** %root2, align 8
  %case_result_ptr = alloca i64, align 8
  %inner_ptr = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 1
  %tag_ptr32 = getelementptr inbounds %BinTree, %BinTree* %load, i32 0, i32 0
  %tag = load i64, i64* %tag_ptr32, align 4
  switch i64 %tag, label %case_else [
    i64 1, label %BNode_block
  ]

after_case:                                       ; preds = %case_else, %after_case9
  %case_result33 = load i64, i64* %case_result_ptr, align 4
  ret i64 0

case_else:                                        ; preds = %entry, %BNode_block3
  %load16 = load %BinTree*, %BinTree** %root2, align 8
  %malloccall = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %param17 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr, i32 0, i32 0
  %load18 = load i64, i64* %x1, align 4
  store i64 %load18, i64* %param17, align 4
  %param19 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr, i32 0, i32 1
  %malloccall20 = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt21 = bitcast i8* %malloccall20 to %BinTree*
  %tag_ptr22 = getelementptr inbounds %BinTree, %BinTree* %gadt21, i32 0, i32 0
  store i64 0, i64* %tag_ptr22, align 4
  %temp_inner_ptr23 = getelementptr inbounds %BinTree, %BinTree* %gadt21, i32 0, i32 1
  %inner_ptr24 = bitcast %constructor_BNode* %temp_inner_ptr23 to %constructor_BEmpty*
  store %BinTree* %gadt21, %BinTree** %param19, align 8
  %param25 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %temp_inner_ptr, i32 0, i32 2
  %malloccall26 = tail call i8* @malloc(i32 ptrtoint (%BinTree* getelementptr (%BinTree, %BinTree* null, i32 1) to i32))
  %gadt27 = bitcast i8* %malloccall26 to %BinTree*
  %tag_ptr28 = getelementptr inbounds %BinTree, %BinTree* %gadt27, i32 0, i32 0
  store i64 0, i64* %tag_ptr28, align 4
  %temp_inner_ptr29 = getelementptr inbounds %BinTree, %BinTree* %gadt27, i32 0, i32 1
  %inner_ptr30 = bitcast %constructor_BNode* %temp_inner_ptr29 to %constructor_BEmpty*
  store %BinTree* %gadt27, %BinTree** %param25, align 8
  %call31 = call i64 @helper_assign(%BinTree* %load16, %BinTree* %gadt)
  store i64 %call31, i64* %case_result_ptr, align 4
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 0
  %param4 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 1
  %param5 = getelementptr inbounds %constructor_BNode, %constructor_BNode* %inner_ptr, i32 0, i32 2
  %load6 = load i64, i64* %x1, align 4
  %load7 = load i64, i64* %param, align 4
  %lt = icmp slt i64 %load6, %load7
  %lt_i64 = sext i1 %lt to i64
  %case_result_ptr8 = alloca i64, align 8
  switch i64 %lt_i64, label %case_else10 [
    i64 0, label %value_branch
  ]

BNode_block3:                                     ; No predecessors!
  br label %case_else

after_case9:                                      ; preds = %case_else10, %value_branch
  %case_result = load i64, i64* %case_result_ptr8, align 4
  store i64 %case_result, i64* %case_result_ptr, align 4
  br label %after_case

case_else10:                                      ; preds = %BNode_block
  %load13 = load i64, i64* %x1, align 4
  %load14 = load %BinTree*, %BinTree** %param4, align 8
  %call15 = call i64 @insert_mut(i64 %load13, %BinTree* %load14)
  store i64 %call15, i64* %case_result_ptr8, align 4
  br label %after_case9

value_branch:                                     ; preds = %BNode_block
  %load11 = load i64, i64* %x1, align 4
  %load12 = load %BinTree*, %BinTree** %param5, align 8
  %call = call i64 @insert_mut(i64 %load11, %BinTree* %load12)
  store i64 %call, i64* %case_result_ptr8, align 4
  br label %after_case9
}

define i64 @helper_assign(%BinTree* %root, %BinTree* %new_root) {
entry:
  %root1 = alloca %BinTree*, align 8
  store %BinTree* %root, %BinTree** %root1, align 8
  %new_root2 = alloca %BinTree*, align 8
  store %BinTree* %new_root, %BinTree** %new_root2, align 8
  %assign_deref = load %BinTree*, %BinTree** %new_root2, align 8
  store %BinTree* %assign_deref, %BinTree** %root1, align 8
  ret i64 0
}

declare noalias i8* @malloc(i32)

declare void @free(i8*)
