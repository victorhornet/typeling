; ModuleID = 'main'
source_filename = "main"

%BinTree = type { i64, %constructor_BNode }
%constructor_BNode = type { i64, %BinTree*, %BinTree* }
%List = type { i64, %constructor_Node }
%constructor_Node = type { i64, %List* }
%Option = type { i64, %constructor_Some }
%constructor_Some = type { i64 }

@string.2 = private unnamed_addr constant [10 x i8] c"x = %lli\0A\00", align 1
@string.3 = private unnamed_addr constant [10 x i8] c"z = %lli\0A\00", align 1
@string.4 = private unnamed_addr constant [19 x i8] c"head(list) = %lli\0A\00", align 1
@string.5 = private unnamed_addr constant [16 x i8] c"list[4] = %lli\0A\00", align 1
@string.6 = private unnamed_addr constant [12 x i8] c"min = %lli\0A\00", align 1

; Function Attrs: nofree nounwind
declare noundef i64 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #0

; Function Attrs: nofree nounwind
define void @main() local_unnamed_addr #0 {
entry:
  tail call void @list_demo()
  tail call void @benchmark()
  %call = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([10 x i8], [10 x i8]* @string.2, i64 0, i64 0), i64 10)
  ret void
}

; Function Attrs: nofree nounwind
define void @benchmark() local_unnamed_addr #0 {
entry:
  %malloccall = tail call dereferenceable_or_null(32) i8* @malloc(i32 32)
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i64 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  br label %body

body:                                             ; preds = %entry, %body
  %tree.024 = phi %BinTree* [ %gadt, %entry ], [ %call5, %body ]
  %i.023 = phi i64 [ 1000, %entry ], [ %sub, %body ]
  %call = tail call %BinTree* @insert(i64 %i.023, %BinTree* %tree.024)
  %neg = sub nsw i64 0, %i.023
  %call5 = tail call %BinTree* @insert(i64 %neg, %BinTree* %call)
  %sub = add nsw i64 %i.023, -1
  %gt = icmp ugt i64 %i.023, 1
  br i1 %gt, label %body, label %merge

merge:                                            ; preds = %body
  %call8 = tail call %BinTree* @insert(i64 5, %BinTree* %call5)
  %call10 = tail call %BinTree* @insert(i64 3, %BinTree* %call8)
  %call12 = tail call %BinTree* @insert(i64 7, %BinTree* %call10)
  %call14 = tail call %BinTree* @insert(i64 4, %BinTree* %call12)
  %call16 = tail call %BinTree* @insert(i64 6, %BinTree* %call14)
  %call18 = tail call %BinTree* @insert(i64 2, %BinTree* %call16)
  %call21 = tail call i64 @get_min(%BinTree* %call18)
  %call22 = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([12 x i8], [12 x i8]* @string.6, i64 0, i64 0), i64 %call21)
  ret void
}

; Function Attrs: nofree nounwind
define void @list_demo() local_unnamed_addr #0 {
entry:
  %malloccall = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i64 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %param = getelementptr inbounds %List, %List* %gadt, i64 0, i32 1, i32 0
  store i64 2, i64* %param, align 4
  %param1 = getelementptr inbounds %List, %List* %gadt, i64 0, i32 1, i32 1
  %malloccall2 = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt3 = bitcast i8* %malloccall2 to %List*
  %tag_ptr4 = getelementptr inbounds %List, %List* %gadt3, i64 0, i32 0
  store i64 1, i64* %tag_ptr4, align 4
  %param6 = getelementptr inbounds %List, %List* %gadt3, i64 0, i32 1, i32 0
  store i64 3, i64* %param6, align 4
  %param7 = getelementptr inbounds %List, %List* %gadt3, i64 0, i32 1, i32 1
  %malloccall8 = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt9 = bitcast i8* %malloccall8 to %List*
  %tag_ptr10 = getelementptr inbounds %List, %List* %gadt9, i64 0, i32 0
  store i64 0, i64* %tag_ptr10, align 4
  %0 = bitcast %List** %param7 to i8**
  store i8* %malloccall8, i8** %0, align 8
  %1 = bitcast %List** %param1 to i8**
  store i8* %malloccall2, i8** %1, align 8
  %call = tail call %Option* @head(%List* %gadt)
  %call14 = tail call i64 @unwrap_or_default(%Option* %call)
  %call15 = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([10 x i8], [10 x i8]* @string.2, i64 0, i64 0), i64 %call14)
  %call17 = tail call %List* @tail(%List* %gadt)
  %call19 = tail call %Option* @head(%List* %call17)
  %call23 = tail call i64 @unwrap_or_default(%Option* %call19)
  %call24 = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([10 x i8], [10 x i8]* @string.3, i64 0, i64 0), i64 %call23)
  %malloccall25 = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt26 = bitcast i8* %malloccall25 to %List*
  %tag_ptr27 = getelementptr inbounds %List, %List* %gadt26, i64 0, i32 0
  store i64 1, i64* %tag_ptr27, align 4
  %param29 = getelementptr inbounds %List, %List* %gadt26, i64 0, i32 1, i32 0
  store i64 1, i64* %param29, align 4
  %param30 = getelementptr inbounds %List, %List* %gadt26, i64 0, i32 1, i32 1
  %2 = bitcast %List** %param30 to i8**
  store i8* %malloccall, i8** %2, align 8
  %call35 = tail call %Option* @head(%List* %gadt26)
  %call36 = tail call i64 @unwrap_or_default(%Option* %call35)
  %call37 = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([19 x i8], [19 x i8]* @string.4, i64 0, i64 0), i64 %call36)
  %call39 = tail call %List* @push(i64 4, %List* %gadt26)
  %call43 = tail call %Option* @get(i64 4, %List* %call39)
  %call44 = tail call i64 @unwrap_or_default(%Option* %call43)
  %call45 = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @string.5, i64 0, i64 0), i64 %call44)
  ret void
}

; Function Attrs: nofree nounwind
define %Option* @get(i64 %i, %List* nocapture readonly %l) local_unnamed_addr #0 {
entry:
  %tag_ptr21 = getelementptr inbounds %List, %List* %l, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr21, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %Node_block, label %case_else

after_case:                                       ; preds = %value_branch, %case_else8, %case_else
  %case_result_ptr.0 = phi i64 [ %ptr_value20, %case_else ], [ %ptr_value, %value_branch ], [ %ptr_value13, %case_else8 ]
  %case_result_adt_ptr23 = inttoptr i64 %case_result_ptr.0 to %Option*
  ret %Option* %case_result_adt_ptr23

case_else:                                        ; preds = %entry
  %malloccall15 = tail call dereferenceable_or_null(16) i8* @malloc(i32 16)
  %gadt16 = bitcast i8* %malloccall15 to %Option*
  %tag_ptr17 = getelementptr inbounds %Option, %Option* %gadt16, i64 0, i32 0
  store i64 1, i64* %tag_ptr17, align 4
  %ptr_value20 = ptrtoint i8* %malloccall15 to i64
  br label %after_case

Node_block:                                       ; preds = %entry
  %cond24 = icmp eq i64 %i, 0
  br i1 %cond24, label %value_branch, label %case_else8

case_else8:                                       ; preds = %Node_block
  %param4 = getelementptr inbounds %List, %List* %l, i64 0, i32 1, i32 1
  %sub = add i64 %i, -1
  %load12 = load %List*, %List** %param4, align 8
  %call = tail call %Option* @get(i64 %sub, %List* %load12)
  %ptr_value13 = ptrtoint %Option* %call to i64
  br label %after_case

value_branch:                                     ; preds = %Node_block
  %param = getelementptr inbounds %List, %List* %l, i64 0, i32 1, i32 0
  %malloccall = tail call dereferenceable_or_null(16) i8* @malloc(i32 16)
  %gadt = bitcast i8* %malloccall to %Option*
  %tag_ptr = getelementptr inbounds %Option, %Option* %gadt, i64 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %param9 = getelementptr inbounds %Option, %Option* %gadt, i64 0, i32 1, i32 0
  %load10 = load i64, i64* %param, align 4
  store i64 %load10, i64* %param9, align 4
  %ptr_value = ptrtoint i8* %malloccall to i64
  br label %after_case
}

; Function Attrs: mustprogress nofree nounwind willreturn
define noalias %List* @prepend(i64 %x, %List* %xs) local_unnamed_addr #1 {
entry:
  %malloccall = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i64 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %param = getelementptr inbounds %List, %List* %gadt, i64 0, i32 1, i32 0
  store i64 %x, i64* %param, align 4
  %param3 = getelementptr inbounds %List, %List* %gadt, i64 0, i32 1, i32 1
  store %List* %xs, %List** %param3, align 8
  ret %List* %gadt
}

; Function Attrs: mustprogress nofree nounwind willreturn
define %List* @pop(%List* nocapture readonly %xs) local_unnamed_addr #1 {
entry:
  %tag_ptr7 = getelementptr inbounds %List, %List* %xs, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr7, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %Node_block, label %case_else

after_case:                                       ; preds = %case_else, %Node_block
  %case_result_ptr.0 = phi i64 [ %ptr_value, %Node_block ], [ %ptr_value6, %case_else ]
  %case_result_adt_ptr = inttoptr i64 %case_result_ptr.0 to %List*
  ret %List* %case_result_adt_ptr

case_else:                                        ; preds = %entry
  %malloccall = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i64 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %ptr_value6 = ptrtoint i8* %malloccall to i64
  br label %after_case

Node_block:                                       ; preds = %entry
  %param3 = getelementptr inbounds %List, %List* %xs, i64 0, i32 1, i32 1
  %load4 = load %List*, %List** %param3, align 8
  %ptr_value = ptrtoint %List* %load4 to i64
  br label %after_case
}

; Function Attrs: nofree nounwind
define noalias %List* @push(i64 %x, %List* nocapture readonly %xs) local_unnamed_addr #0 {
entry:
  %tag_ptr23 = getelementptr inbounds %List, %List* %xs, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr23, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %Node_block, label %case_else

after_case:                                       ; preds = %case_else, %Node_block
  %case_result_adt_ptr.pre-phi = phi %List* [ %gadt11, %case_else ], [ %gadt, %Node_block ]
  ret %List* %case_result_adt_ptr.pre-phi

case_else:                                        ; preds = %entry
  %malloccall10 = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt11 = bitcast i8* %malloccall10 to %List*
  %tag_ptr12 = getelementptr inbounds %List, %List* %gadt11, i64 0, i32 0
  store i64 1, i64* %tag_ptr12, align 4
  %param14 = getelementptr inbounds %List, %List* %gadt11, i64 0, i32 1, i32 0
  store i64 %x, i64* %param14, align 4
  %param16 = getelementptr inbounds %List, %List* %gadt11, i64 0, i32 1, i32 1
  %malloccall17 = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt18 = bitcast i8* %malloccall17 to %List*
  %tag_ptr19 = getelementptr inbounds %List, %List* %gadt18, i64 0, i32 0
  store i64 0, i64* %tag_ptr19, align 4
  %0 = bitcast %List** %param16 to i8**
  store i8* %malloccall17, i8** %0, align 8
  br label %after_case

Node_block:                                       ; preds = %entry
  %param = getelementptr inbounds %List, %List* %xs, i64 0, i32 1, i32 0
  %param4 = getelementptr inbounds %List, %List* %xs, i64 0, i32 1, i32 1
  %malloccall = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i64 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %param5 = getelementptr inbounds %List, %List* %gadt, i64 0, i32 1, i32 0
  %load6 = load i64, i64* %param, align 4
  store i64 %load6, i64* %param5, align 4
  %param7 = getelementptr inbounds %List, %List* %gadt, i64 0, i32 1, i32 1
  %load9 = load %List*, %List** %param4, align 8
  %call = tail call %List* @push(i64 %x, %List* %load9)
  store %List* %call, %List** %param7, align 8
  br label %after_case
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly willreturn
define i64 @is_empty(%List* nocapture readonly %l) local_unnamed_addr #2 {
entry:
  %tag_ptr = getelementptr inbounds %List, %List* %l, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  %. = sext i1 %cond to i64
  ret i64 %.
}

; Function Attrs: mustprogress nofree nounwind willreturn
define noalias %Option* @head(%List* nocapture readonly %l) local_unnamed_addr #1 {
entry:
  %tag_ptr12 = getelementptr inbounds %List, %List* %l, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr12, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %Node_block, label %case_else

after_case:                                       ; preds = %case_else, %Node_block
  %case_result_adt_ptr.pre-phi = phi %Option* [ %gadt7, %case_else ], [ %gadt, %Node_block ]
  ret %Option* %case_result_adt_ptr.pre-phi

case_else:                                        ; preds = %entry
  %malloccall6 = tail call dereferenceable_or_null(16) i8* @malloc(i32 16)
  %gadt7 = bitcast i8* %malloccall6 to %Option*
  %tag_ptr8 = getelementptr inbounds %Option, %Option* %gadt7, i64 0, i32 0
  store i64 1, i64* %tag_ptr8, align 4
  br label %after_case

Node_block:                                       ; preds = %entry
  %param = getelementptr inbounds %List, %List* %l, i64 0, i32 1, i32 0
  %malloccall = tail call dereferenceable_or_null(16) i8* @malloc(i32 16)
  %gadt = bitcast i8* %malloccall to %Option*
  %tag_ptr = getelementptr inbounds %Option, %Option* %gadt, i64 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %param4 = getelementptr inbounds %Option, %Option* %gadt, i64 0, i32 1, i32 0
  %load5 = load i64, i64* %param, align 4
  store i64 %load5, i64* %param4, align 4
  br label %after_case
}

; Function Attrs: mustprogress nofree nounwind willreturn
define %List* @tail(%List* nocapture readonly %l) local_unnamed_addr #1 {
entry:
  %tag_ptr7 = getelementptr inbounds %List, %List* %l, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr7, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %Node_block, label %case_else

after_case:                                       ; preds = %case_else, %Node_block
  %case_result_ptr.0 = phi i64 [ %ptr_value, %Node_block ], [ %ptr_value6, %case_else ]
  %case_result_adt_ptr = inttoptr i64 %case_result_ptr.0 to %List*
  ret %List* %case_result_adt_ptr

case_else:                                        ; preds = %entry
  %malloccall = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt = bitcast i8* %malloccall to %List*
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i64 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %ptr_value6 = ptrtoint i8* %malloccall to i64
  br label %after_case

Node_block:                                       ; preds = %entry
  %param3 = getelementptr inbounds %List, %List* %l, i64 0, i32 1, i32 1
  %load4 = load %List*, %List** %param3, align 8
  %ptr_value = ptrtoint %List* %load4 to i64
  br label %after_case
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly willreturn
define i64 @unwrap_or_default(%Option* nocapture readonly %x) local_unnamed_addr #2 {
entry:
  %tag_ptr = getelementptr inbounds %Option, %Option* %x, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %Some_block, label %after_case

after_case:                                       ; preds = %entry, %Some_block
  %case_result_ptr.0 = phi i64 [ %load3, %Some_block ], [ 0, %entry ]
  ret i64 %case_result_ptr.0

Some_block:                                       ; preds = %entry
  %param = getelementptr inbounds %Option, %Option* %x, i64 0, i32 1, i32 0
  %load3 = load i64, i64* %param, align 4
  br label %after_case
}

; Function Attrs: nounwind
define i64 @bintree_demo() local_unnamed_addr #3 {
entry:
  %malloccall = tail call dereferenceable_or_null(32) i8* @malloc(i32 32)
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i64 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %call = tail call %BinTree* @insert(i64 5, %BinTree* %gadt)
  %call2 = tail call %BinTree* @insert(i64 3, %BinTree* %call)
  %call4 = tail call %BinTree* @insert(i64 7, %BinTree* %call2)
  %call6 = tail call %BinTree* @insert(i64 4, %BinTree* %call4)
  %call8 = tail call %BinTree* @insert(i64 6, %BinTree* %call6)
  %call10 = tail call %BinTree* @insert(i64 2, %BinTree* %call8)
  %call13 = tail call i64 @get_min(%BinTree* %call10)
  %call14 = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([12 x i8], [12 x i8]* @string.6, i64 0, i64 0), i64 %call13)
  %call16 = tail call i64 @free_tree(%BinTree* %call10)
  ret i64 0
}

; Function Attrs: nounwind
define i64 @free_tree(%BinTree* nocapture %root) local_unnamed_addr #3 {
entry:
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %BNode_block, label %common.ret

common.ret:                                       ; preds = %entry, %BNode_block
  %common.ret.op = phi i64 [ %add, %BNode_block ], [ 0, %entry ]
  %call9 = tail call i64 @helper_free(%BinTree* nonnull %root)
  ret i64 %common.ret.op

BNode_block:                                      ; preds = %entry
  %param3 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 1
  %param4 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 2
  %load5 = load %BinTree*, %BinTree** %param3, align 8
  %call = tail call i64 @free_tree(%BinTree* %load5)
  %load6 = load %BinTree*, %BinTree** %param4, align 8
  %call7 = tail call i64 @free_tree(%BinTree* %load6)
  %add = add i64 %call7, %call
  br label %common.ret
}

; Function Attrs: mustprogress nofree nounwind willreturn
define %BinTree* @left(%BinTree* nocapture readonly %root) local_unnamed_addr #1 {
entry:
  %tag_ptr8 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr8, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %BNode_block, label %case_else

after_case:                                       ; preds = %case_else, %BNode_block
  %case_result_ptr.0 = phi i64 [ %ptr_value, %BNode_block ], [ %ptr_value7, %case_else ]
  %case_result_adt_ptr = inttoptr i64 %case_result_ptr.0 to %BinTree*
  ret %BinTree* %case_result_adt_ptr

case_else:                                        ; preds = %entry
  %malloccall = tail call dereferenceable_or_null(32) i8* @malloc(i32 32)
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i64 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %ptr_value7 = ptrtoint i8* %malloccall to i64
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param3 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 1
  %load5 = load %BinTree*, %BinTree** %param3, align 8
  %ptr_value = ptrtoint %BinTree* %load5 to i64
  br label %after_case
}

; Function Attrs: mustprogress nofree nounwind willreturn
define %BinTree* @right(%BinTree* nocapture readonly %root) local_unnamed_addr #1 {
entry:
  %tag_ptr8 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr8, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %BNode_block, label %case_else

after_case:                                       ; preds = %case_else, %BNode_block
  %case_result_ptr.0 = phi i64 [ %ptr_value, %BNode_block ], [ %ptr_value7, %case_else ]
  %case_result_adt_ptr = inttoptr i64 %case_result_ptr.0 to %BinTree*
  ret %BinTree* %case_result_adt_ptr

case_else:                                        ; preds = %entry
  %malloccall = tail call dereferenceable_or_null(32) i8* @malloc(i32 32)
  %gadt = bitcast i8* %malloccall to %BinTree*
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i64 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %ptr_value7 = ptrtoint i8* %malloccall to i64
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param4 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 2
  %load5 = load %BinTree*, %BinTree** %param4, align 8
  %ptr_value = ptrtoint %BinTree* %load5 to i64
  br label %after_case
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly willreturn
define i64 @get_value(%BinTree* nocapture readonly %root) local_unnamed_addr #2 {
entry:
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %BNode_block, label %after_case

after_case:                                       ; preds = %entry, %BNode_block
  %case_result_ptr.0 = phi i64 [ %load5, %BNode_block ], [ 0, %entry ]
  ret i64 %case_result_ptr.0

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 0
  %load5 = load i64, i64* %param, align 4
  br label %after_case
}

; Function Attrs: mustprogress nounwind willreturn
define i64 @helper_free(%BinTree* nocapture %root) local_unnamed_addr #4 {
entry:
  %0 = bitcast %BinTree* %root to i8*
  tail call void @free(i8* %0)
  ret i64 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly willreturn
define i64 @has_left(%BinTree* nocapture readonly %root) local_unnamed_addr #2 {
entry:
  %tag_ptr5 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag6 = load i64, i64* %tag_ptr5, align 4
  %cond7 = icmp eq i64 %tag6, 1
  br i1 %cond7, label %BNode_block, label %after_case

after_case:                                       ; preds = %BNode_block, %entry
  %case_result_ptr.0 = phi i64 [ -1, %entry ], [ %., %BNode_block ]
  ret i64 %case_result_ptr.0

BNode_block:                                      ; preds = %entry
  %param3 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 1
  %deref_param3 = load %BinTree*, %BinTree** %param3, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp ne i64 %tag, 0
  %. = sext i1 %cond to i64
  br label %after_case
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly willreturn
define i64 @has_right(%BinTree* nocapture readonly %root) local_unnamed_addr #2 {
entry:
  %tag_ptr5 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag6 = load i64, i64* %tag_ptr5, align 4
  %cond7 = icmp eq i64 %tag6, 1
  br i1 %cond7, label %BNode_block, label %after_case

after_case:                                       ; preds = %BNode_block, %entry
  %case_result_ptr.0 = phi i64 [ -1, %entry ], [ %., %BNode_block ]
  ret i64 %case_result_ptr.0

BNode_block:                                      ; preds = %entry
  %param4 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 2
  %deref_param4 = load %BinTree*, %BinTree** %param4, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param4, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp ne i64 %tag, 0
  %. = sext i1 %cond to i64
  br label %after_case
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly willreturn
define i64 @is_leaf(%BinTree* nocapture readonly %root) local_unnamed_addr #2 {
entry:
  %tag_ptr9 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag10 = load i64, i64* %tag_ptr9, align 4
  %cond11 = icmp eq i64 %tag10, 1
  br i1 %cond11, label %BNode_block, label %after_case

after_case:                                       ; preds = %then_1, %BNode_block, %entry
  %case_result_ptr.0 = phi i64 [ 0, %entry ], [ 0, %BNode_block ], [ %spec.select, %then_1 ]
  ret i64 %case_result_ptr.0

BNode_block:                                      ; preds = %entry
  %param3 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 1
  %deref_param3 = load %BinTree*, %BinTree** %param3, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %then_1, label %after_case

then_1:                                           ; preds = %BNode_block
  %param4 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 2
  %deref_param4 = load %BinTree*, %BinTree** %param4, align 8
  %tag_ptr5 = getelementptr inbounds %BinTree, %BinTree* %deref_param4, i64 0, i32 0
  %tag6 = load i64, i64* %tag_ptr5, align 4
  %cond7 = icmp eq i64 %tag6, 0
  %spec.select = sext i1 %cond7 to i64
  br label %after_case
}

; Function Attrs: nofree nounwind
define noalias %BinTree* @insert(i64 %x, %BinTree* nocapture readonly %root) local_unnamed_addr #0 {
entry:
  %tag_ptr51 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr51, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %BNode_block, label %case_else

after_case:                                       ; preds = %value_branch, %case_else10, %case_else
  %case_result_adt_ptr53.pre-phi = phi %BinTree* [ %gadt19, %value_branch ], [ %gadt19, %case_else10 ], [ %gadt33, %case_else ]
  ret %BinTree* %case_result_adt_ptr53.pre-phi

case_else:                                        ; preds = %entry
  %malloccall32 = tail call dereferenceable_or_null(32) i8* @malloc(i32 32)
  %gadt33 = bitcast i8* %malloccall32 to %BinTree*
  %tag_ptr34 = getelementptr inbounds %BinTree, %BinTree* %gadt33, i64 0, i32 0
  store i64 1, i64* %tag_ptr34, align 4
  %param36 = getelementptr inbounds %BinTree, %BinTree* %gadt33, i64 0, i32 1, i32 0
  store i64 %x, i64* %param36, align 4
  %param38 = getelementptr inbounds %BinTree, %BinTree* %gadt33, i64 0, i32 1, i32 1
  %malloccall39 = tail call dereferenceable_or_null(32) i8* @malloc(i32 32)
  %gadt40 = bitcast i8* %malloccall39 to %BinTree*
  %tag_ptr41 = getelementptr inbounds %BinTree, %BinTree* %gadt40, i64 0, i32 0
  store i64 0, i64* %tag_ptr41, align 4
  %0 = bitcast %BinTree** %param38 to i8**
  store i8* %malloccall39, i8** %0, align 8
  %param44 = getelementptr inbounds %BinTree, %BinTree* %gadt33, i64 0, i32 1, i32 2
  %malloccall45 = tail call dereferenceable_or_null(32) i8* @malloc(i32 32)
  %gadt46 = bitcast i8* %malloccall45 to %BinTree*
  %tag_ptr47 = getelementptr inbounds %BinTree, %BinTree* %gadt46, i64 0, i32 0
  store i64 0, i64* %tag_ptr47, align 4
  %1 = bitcast %BinTree** %param44 to i8**
  store i8* %malloccall45, i8** %1, align 8
  br label %after_case

BNode_block:                                      ; preds = %entry
  %param = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 0
  %param4 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 1
  %param5 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 1, i32 2
  %load7 = load i64, i64* %param, align 4
  %lt.not = icmp sgt i64 %load7, %x
  %malloccall18 = tail call dereferenceable_or_null(32) i8* @malloc(i32 32)
  %gadt19 = bitcast i8* %malloccall18 to %BinTree*
  %tag_ptr20 = getelementptr inbounds %BinTree, %BinTree* %gadt19, i64 0, i32 0
  store i64 1, i64* %tag_ptr20, align 4
  %param22 = getelementptr inbounds %BinTree, %BinTree* %gadt19, i64 0, i32 1, i32 0
  store i64 %load7, i64* %param22, align 4
  %param24 = getelementptr inbounds %BinTree, %BinTree* %gadt19, i64 0, i32 1, i32 1
  %load26 = load %BinTree*, %BinTree** %param4, align 8
  br i1 %lt.not, label %case_else10, label %value_branch

case_else10:                                      ; preds = %BNode_block
  %call27 = tail call %BinTree* @insert(i64 %x, %BinTree* %load26)
  store %BinTree* %call27, %BinTree** %param24, align 8
  %param28 = getelementptr inbounds %BinTree, %BinTree* %gadt19, i64 0, i32 1, i32 2
  %load29 = load %BinTree*, %BinTree** %param5, align 8
  store %BinTree* %load29, %BinTree** %param28, align 8
  br label %after_case

value_branch:                                     ; preds = %BNode_block
  store %BinTree* %load26, %BinTree** %param24, align 8
  %param15 = getelementptr inbounds %BinTree, %BinTree* %gadt19, i64 0, i32 1, i32 2
  %load17 = load %BinTree*, %BinTree** %param5, align 8
  %call = tail call %BinTree* @insert(i64 %x, %BinTree* %load17)
  store %BinTree* %call, %BinTree** %param15, align 8
  br label %after_case
}

; Function Attrs: nofree nosync nounwind readonly
define i64 @get_min(%BinTree* nocapture readonly %root) local_unnamed_addr #5 {
entry:
  %tag_ptr11.phi.trans.insert = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag12.pre = load i64, i64* %tag_ptr11.phi.trans.insert, align 4
  br label %tailrecurse

tailrecurse:                                      ; preds = %BNode_block, %entry
  %tag12 = phi i64 [ %tag12.pre, %entry ], [ %tag, %BNode_block ]
  %root.tr = phi %BinTree* [ %root, %entry ], [ %deref_param3, %BNode_block ]
  %cond13 = icmp eq i64 %tag12, 1
  br i1 %cond13, label %BNode_block, label %after_case

after_case:                                       ; preds = %tailrecurse, %then_1
  %case_result_ptr.0 = phi i64 [ %load5, %then_1 ], [ 0, %tailrecurse ]
  ret i64 %case_result_ptr.0

BNode_block:                                      ; preds = %tailrecurse
  %param3 = getelementptr inbounds %BinTree, %BinTree* %root.tr, i64 0, i32 1, i32 1
  %deref_param3 = load %BinTree*, %BinTree** %param3, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %deref_param3, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %then_1, label %tailrecurse

then_1:                                           ; preds = %BNode_block
  %param = getelementptr inbounds %BinTree, %BinTree* %root.tr, i64 0, i32 1, i32 0
  %load5 = load i64, i64* %param, align 4
  br label %after_case
}

; Function Attrs: nofree nosync nounwind readonly
define i64 @insert_mut(i64 %x, %BinTree* nocapture readonly %root) local_unnamed_addr #5 {
entry:
  %tag_ptr3237 = getelementptr inbounds %BinTree, %BinTree* %root, i64 0, i32 0
  %tag38 = load i64, i64* %tag_ptr3237, align 4
  %cond39 = icmp eq i64 %tag38, 1
  br i1 %cond39, label %BNode_block, label %after_case

after_case:                                       ; preds = %BNode_block, %entry
  ret i64 0

BNode_block:                                      ; preds = %entry, %BNode_block
  %root.tr40 = phi %BinTree* [ %root.tr.be, %BNode_block ], [ %root, %entry ]
  %param = getelementptr inbounds %BinTree, %BinTree* %root.tr40, i64 0, i32 1, i32 0
  %load7 = load i64, i64* %param, align 4
  %lt.not = icmp sgt i64 %load7, %x
  %param4 = getelementptr inbounds %BinTree, %BinTree* %root.tr40, i64 0, i32 1, i32 1
  %param5 = getelementptr inbounds %BinTree, %BinTree* %root.tr40, i64 0, i32 1, i32 2
  %root.tr.be.in = select i1 %lt.not, %BinTree** %param4, %BinTree** %param5
  %root.tr.be = load %BinTree*, %BinTree** %root.tr.be.in, align 8
  %tag_ptr32 = getelementptr inbounds %BinTree, %BinTree* %root.tr.be, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr32, align 4
  %cond = icmp eq i64 %tag, 1
  br i1 %cond, label %BNode_block, label %after_case
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define i64 @helper_assign(%BinTree* nocapture readnone %root, %BinTree* nocapture readnone %new_root) local_unnamed_addr #6 {
entry:
  ret i64 0
}

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i32 noundef) local_unnamed_addr #7

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #8

attributes #0 = { nofree nounwind }
attributes #1 = { mustprogress nofree nounwind willreturn }
attributes #2 = { mustprogress nofree norecurse nosync nounwind readonly willreturn }
attributes #3 = { nounwind }
attributes #4 = { mustprogress nounwind willreturn }
attributes #5 = { nofree nosync nounwind readonly }
attributes #6 = { mustprogress nofree norecurse nosync nounwind readnone willreturn }
attributes #7 = { inaccessiblememonly mustprogress nofree nounwind willreturn }
attributes #8 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn }
