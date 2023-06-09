; ModuleID = 'main'
source_filename = "main"

%List = type { i64, %constructor_Cons }
%constructor_Cons = type { i64, %List* }
%constructor_Nil = type {}

declare i64 @printf(i8*, ...)

define i64 @main() {
entry:
  %gadt = alloca %List, align 8
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  %temp_inner_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr, i32 0, i32 1
  %gadt2 = alloca %List, align 8
  %tag_ptr3 = getelementptr inbounds %List, %List* %gadt2, i32 0, i32 0
  %temp_inner_ptr4 = getelementptr inbounds %List, %List* %gadt2, i32 0, i32 1
  %param5 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr4, i32 0, i32 0
  store i64 2, i64* %param5, align 4
  %param6 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr4, i32 0, i32 1
  %gadt7 = alloca %List, align 8
  %tag_ptr8 = getelementptr inbounds %List, %List* %gadt7, i32 0, i32 0
  %temp_inner_ptr9 = getelementptr inbounds %List, %List* %gadt7, i32 0, i32 1
  %param10 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr9, i32 0, i32 0
  store i64 3, i64* %param10, align 4
  %param11 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr9, i32 0, i32 1
  %gadt12 = alloca %List, align 8
  %tag_ptr13 = getelementptr inbounds %List, %List* %gadt12, i32 0, i32 0
  %temp_inner_ptr14 = getelementptr inbounds %List, %List* %gadt12, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Cons* %temp_inner_ptr14 to %constructor_Nil*
  store %List* %gadt12, %List** %param11, align 8
  store %List* %gadt7, %List** %param6, align 8
  store %List* %gadt2, %List** %param1, align 8
  %temp_inner_ptr15 = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %member_access = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr15, i32 0, i32 0
  %temp_inner_ptr16 = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %member_access17 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr16, i32 0, i32 1
  %deref = load %List*, %List** %member_access17, align 8
  %temp_inner_ptr18 = getelementptr inbounds %List, %List* %deref, i32 0, i32 1
  %member_access19 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr18, i32 0, i32 1
  %load = load %List*, %List** %member_access19, align 8
  store %List* %load, %List** %member_access17, align 8
  %deref20 = load %List*, %List** %member_access17, align 8
  %temp_inner_ptr21 = getelementptr inbounds %List, %List* %deref20, i32 0, i32 1
  %member_access22 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr21, i32 0, i32 0
  %load23 = load i64, i64* %member_access22, align 4
  ret i64 %load23
}
