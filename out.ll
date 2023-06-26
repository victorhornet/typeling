; ModuleID = 'main'
source_filename = "main"

%List = type { i64, %constructor_Cons }
%constructor_Cons = type { i64, %List* }

@string.2 = private unnamed_addr constant [5 x i8] c"%lli\00", align 1
@string.3 = private unnamed_addr constant [3 x i8] c", \00", align 1
@str = private unnamed_addr constant [2 x i8] c"]\00", align 1

; Function Attrs: nofree nounwind
declare noundef i64 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #0

; Function Attrs: nofree nounwind
define noalias %List* @zeros(i64 %size) local_unnamed_addr #0 {
entry:
  %eq = icmp eq i64 %size, 0
  %malloccall = tail call dereferenceable_or_null(24) i8* @malloc(i32 24)
  %gadt = bitcast i8* %malloccall to %List*
  br i1 %eq, label %then, label %merge

common.ret8:                                      ; preds = %merge, %then
  ret %List* %gadt

then:                                             ; preds = %entry
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i64 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  br label %common.ret8

merge:                                            ; preds = %entry
  %param6 = getelementptr inbounds %List, %List* %gadt, i64 0, i32 1, i32 1
  %sub = add i64 %size, -1
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %malloccall, i8 0, i64 16, i1 false)
  %call = tail call %List* @zeros(i64 %sub)
  store %List* %call, %List** %param6, align 8
  br label %common.ret8
}

; Function Attrs: nofree nounwind
define void @pprint_list(%List* nocapture readonly %list) local_unnamed_addr #0 {
entry:
  %putchar = tail call i32 @putchar(i32 91)
  %call3 = tail call i64 @print_list(%List* %list)
  %puts = tail call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([2 x i8], [2 x i8]* @str, i64 0, i64 0))
  ret void
}

; Function Attrs: nofree nounwind
define i64 @print_list(%List* nocapture readonly %list) local_unnamed_addr #0 {
entry:
  %tag_ptr = getelementptr inbounds %List, %List* %list, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 0
  br i1 %cond, label %Cons_block, label %after_case

after_case:                                       ; preds = %entry, %Cons_block
  ret i64 0

Cons_block:                                       ; preds = %entry
  %param = getelementptr inbounds %List, %List* %list, i64 0, i32 1, i32 0
  %param3 = getelementptr inbounds %List, %List* %list, i64 0, i32 1, i32 1
  %load4 = load i64, i64* %param, align 4
  %load5 = load %List*, %List** %param3, align 8
  %call = tail call i64 @print_cons(i64 %load4, %List* %load5)
  br label %after_case
}

; Function Attrs: nofree nounwind
define i64 @print_cons(i64 %head, %List* %tail) local_unnamed_addr #0 {
entry:
  %tag_ptr = getelementptr inbounds %List, %List* %tail, i64 0, i32 0
  %tag = load i64, i64* %tag_ptr, align 4
  %cond = icmp eq i64 %tag, 1
  %call = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @string.2, i64 0, i64 0), i64 %head)
  br i1 %cond, label %merge, label %then

then:                                             ; preds = %entry
  %call9 = tail call i64 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([3 x i8], [3 x i8]* @string.3, i64 0, i64 0))
  br label %merge

merge:                                            ; preds = %entry, %then
  %call11 = tail call i64 @print_list(%List* nonnull %tail)
  ret i64 0
}

; Function Attrs: nofree nounwind
define i64 @main() local_unnamed_addr #0 {
entry:
  %call = tail call %List* @zeros(i64 0)
  tail call void @pprint_list(%List* %call)
  %call1 = tail call %List* @zeros(i64 1)
  tail call void @pprint_list(%List* %call1)
  %call2 = tail call %List* @zeros(i64 20)
  tail call void @pprint_list(%List* %call2)
  ret i64 0
}

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i32 noundef) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) #0

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) #0

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

attributes #0 = { nofree nounwind }
attributes #1 = { inaccessiblememonly mustprogress nofree nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }
