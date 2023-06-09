; ModuleID = 'main'
source_filename = "main"

%Enum = type { i64, %constructor_C }
%constructor_C = type { i64, i64 }
%constructor_A = type {}
%constructor_B = type { i64 }
%List = type { i64, %constructor_Cons }
%constructor_Cons = type { i64, %List* }
%constructor_Nil = type {}
%BinTree = type { i64, %constructor_Node }
%constructor_Node = type { i64, %BinTree*, %BinTree* }
%constructor_Leaf = type {}
%Infinite = type { i64, %constructor_Infinite }
%constructor_Infinite = type { i64, %Infinite* }
%constructor_Temp = type {}

declare i64 @printf(i8*, ...)

define i64 @enums() {
entry:
  %gadt = alloca %Enum, align 8
  %tag_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 0
  %temp_inner_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %inner_ptr = bitcast %constructor_C* %temp_inner_ptr to %constructor_A*
  %gadt1 = alloca %Enum, align 8
  %tag_ptr2 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 0
  %temp_inner_ptr3 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 1
  %inner_ptr4 = bitcast %constructor_C* %temp_inner_ptr3 to %constructor_B*
  %param = getelementptr inbounds %constructor_B, %constructor_B* %inner_ptr4, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %gadt5 = alloca %Enum, align 8
  %tag_ptr6 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 0
  %temp_inner_ptr7 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %param8 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr7, i32 0, i32 0
  store i64 10, i64* %param8, align 4
  %param9 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr7, i32 0, i32 1
  store i64 20, i64* %param9, align 4
  %gadt10 = alloca %Enum, align 8
  %tag_ptr11 = getelementptr inbounds %Enum, %Enum* %gadt10, i32 0, i32 0
  %temp_inner_ptr12 = getelementptr inbounds %Enum, %Enum* %gadt10, i32 0, i32 1
  %param13 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr12, i32 0, i32 0
  store i64 10, i64* %param13, align 4
  %param14 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr12, i32 0, i32 1
  store i64 20, i64* %param14, align 4
  %temp_inner_ptr15 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %member_access = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr15, i32 0, i32 0
  %temp_inner_ptr16 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %member_access17 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr16, i32 0, i32 1
  %load = load i64, i64* %member_access, align 4
  %load18 = load i64, i64* %member_access17, align 4
  %add = add i64 %load, %load18
  %z = alloca i64, align 8
  store i64 %add, i64* %z, align 4
  %load19 = load i64, i64* %z, align 4
  %load20 = load i64, i64* %member_access17, align 4
  %add21 = add i64 %load19, %load20
  store i64 %add21, i64* %z, align 4
  %gadt22 = alloca %Enum, align 8
  %tag_ptr23 = getelementptr inbounds %Enum, %Enum* %gadt22, i32 0, i32 0
  %temp_inner_ptr24 = getelementptr inbounds %Enum, %Enum* %gadt22, i32 0, i32 1
  %param25 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr24, i32 0, i32 1
  store i64 100, i64* %param25, align 4
  %param26 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr24, i32 0, i32 0
  %temp_inner_ptr27 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %member_access28 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr27, i32 0, i32 0
  %load29 = load i64, i64* %member_access28, align 4
  store i64 %load29, i64* %param26, align 4
  %load30 = load %Enum, %Enum* %gadt22, align 4
  store %Enum %load30, %Enum* %gadt5, align 4
  %temp_inner_ptr31 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %member_access32 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr31, i32 0, i32 0
  %load33 = load i64, i64* %member_access32, align 4
  %temp_inner_ptr34 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %member_access35 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr34, i32 0, i32 1
  %load36 = load i64, i64* %member_access35, align 4
  %add37 = add i64 %load33, %load36
  ret i64 %add37
}

define i64 @list() {
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
  %load = load i64, i64* %member_access, align 4
  %deref = load %List*, %List** %member_access17, align 8
  %temp_inner_ptr18 = getelementptr inbounds %List, %List* %deref, i32 0, i32 1
  %member_access19 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr18, i32 0, i32 0
  %load20 = load i64, i64* %member_access19, align 4
  %add = add i64 %load, %load20
  %z = alloca i64, align 8
  store i64 %add, i64* %z, align 4
  %load21 = load i64, i64* %z, align 4
  ret i64 %load21
}

define i64 @tree() {
entry:
  %gadt = alloca %BinTree, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  %temp_inner_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 0
  store i64 20, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 1
  %gadt2 = alloca %BinTree, align 8
  %tag_ptr3 = getelementptr inbounds %BinTree, %BinTree* %gadt2, i32 0, i32 0
  %temp_inner_ptr4 = getelementptr inbounds %BinTree, %BinTree* %gadt2, i32 0, i32 1
  %param5 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr4, i32 0, i32 0
  store i64 10, i64* %param5, align 4
  %param6 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr4, i32 0, i32 1
  %gadt7 = alloca %BinTree, align 8
  %tag_ptr8 = getelementptr inbounds %BinTree, %BinTree* %gadt7, i32 0, i32 0
  %temp_inner_ptr9 = getelementptr inbounds %BinTree, %BinTree* %gadt7, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Node* %temp_inner_ptr9 to %constructor_Leaf*
  store %BinTree* %gadt7, %BinTree** %param6, align 8
  %param10 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr4, i32 0, i32 2
  %gadt11 = alloca %BinTree, align 8
  %tag_ptr12 = getelementptr inbounds %BinTree, %BinTree* %gadt11, i32 0, i32 0
  %temp_inner_ptr13 = getelementptr inbounds %BinTree, %BinTree* %gadt11, i32 0, i32 1
  %inner_ptr14 = bitcast %constructor_Node* %temp_inner_ptr13 to %constructor_Leaf*
  store %BinTree* %gadt11, %BinTree** %param10, align 8
  store %BinTree* %gadt2, %BinTree** %param1, align 8
  %param15 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 2
  %gadt16 = alloca %BinTree, align 8
  %tag_ptr17 = getelementptr inbounds %BinTree, %BinTree* %gadt16, i32 0, i32 0
  %temp_inner_ptr18 = getelementptr inbounds %BinTree, %BinTree* %gadt16, i32 0, i32 1
  %param19 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr18, i32 0, i32 0
  store i64 30, i64* %param19, align 4
  %param20 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr18, i32 0, i32 1
  %gadt21 = alloca %BinTree, align 8
  %tag_ptr22 = getelementptr inbounds %BinTree, %BinTree* %gadt21, i32 0, i32 0
  %temp_inner_ptr23 = getelementptr inbounds %BinTree, %BinTree* %gadt21, i32 0, i32 1
  %inner_ptr24 = bitcast %constructor_Node* %temp_inner_ptr23 to %constructor_Leaf*
  store %BinTree* %gadt21, %BinTree** %param20, align 8
  %param25 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr18, i32 0, i32 2
  %gadt26 = alloca %BinTree, align 8
  %tag_ptr27 = getelementptr inbounds %BinTree, %BinTree* %gadt26, i32 0, i32 0
  %temp_inner_ptr28 = getelementptr inbounds %BinTree, %BinTree* %gadt26, i32 0, i32 1
  %inner_ptr29 = bitcast %constructor_Node* %temp_inner_ptr28 to %constructor_Leaf*
  store %BinTree* %gadt26, %BinTree** %param25, align 8
  store %BinTree* %gadt16, %BinTree** %param15, align 8
  %temp_inner_ptr30 = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %member_access = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr30, i32 0, i32 1
  %temp_inner_ptr31 = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %member_access32 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr31, i32 0, i32 2
  %deref = load %BinTree*, %BinTree** %member_access, align 8
  %temp_inner_ptr33 = getelementptr inbounds %BinTree, %BinTree* %deref, i32 0, i32 1
  %member_access34 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr33, i32 0, i32 0
  %load = load i64, i64* %member_access34, align 4
  %temp_inner_ptr35 = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %member_access36 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr35, i32 0, i32 0
  %load37 = load i64, i64* %member_access36, align 4
  %add = add i64 %load, %load37
  %deref38 = load %BinTree*, %BinTree** %member_access32, align 8
  %temp_inner_ptr39 = getelementptr inbounds %BinTree, %BinTree* %deref38, i32 0, i32 1
  %member_access40 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr39, i32 0, i32 0
  %load41 = load i64, i64* %member_access40, align 4
  %add42 = add i64 %add, %load41
  ret i64 %add42
}

define i64 @infinite() {
entry:
  %gadt = alloca %Infinite, align 8
  %tag_ptr = getelementptr inbounds %Infinite, %Infinite* %gadt, i32 0, i32 0
  %temp_inner_ptr = getelementptr inbounds %Infinite, %Infinite* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Infinite, %constructor_Infinite* %temp_inner_ptr, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_Infinite, %constructor_Infinite* %temp_inner_ptr, i32 0, i32 1
  %gadt2 = alloca %Infinite, align 8
  %tag_ptr3 = getelementptr inbounds %Infinite, %Infinite* %gadt2, i32 0, i32 0
  %temp_inner_ptr4 = getelementptr inbounds %Infinite, %Infinite* %gadt2, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Infinite* %temp_inner_ptr4 to %constructor_Temp*
  store %Infinite* %gadt2, %Infinite** %param1, align 8
  %gadt5 = alloca %Infinite, align 8
  %tag_ptr6 = getelementptr inbounds %Infinite, %Infinite* %gadt5, i32 0, i32 0
  %temp_inner_ptr7 = getelementptr inbounds %Infinite, %Infinite* %gadt5, i32 0, i32 1
  %param8 = getelementptr inbounds %constructor_Infinite, %constructor_Infinite* %temp_inner_ptr7, i32 0, i32 0
  store i64 1, i64* %param8, align 4
  %param9 = getelementptr inbounds %constructor_Infinite, %constructor_Infinite* %temp_inner_ptr7, i32 0, i32 1
  store %Infinite* %gadt, %Infinite** %param9, align 8
  %load = load %Infinite, %Infinite* %gadt5, align 8
  store %Infinite %load, %Infinite* %gadt, align 8
  %temp_inner_ptr10 = getelementptr inbounds %Infinite, %Infinite* %gadt, i32 0, i32 1
  %member_access = getelementptr inbounds %constructor_Infinite, %constructor_Infinite* %temp_inner_ptr10, i32 0, i32 0
  %load11 = load i64, i64* %member_access, align 4
  ret i64 %load11
}

define i64 @main() {
entry:
  %call = call i64 @enums()
  %call1 = call i64 @list()
  %call2 = call i64 @tree()
  ret i64 0
}
