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
%Loop = type { i64, %constructor_Loop }
%constructor_Loop = type { i64, %Loop* }
%constructor_Temp = type {}
%OptionalInt = type { i64, %constructor_SomeI }
%constructor_SomeI = type { i64 }
%constructor_NoneI = type {}
%OptionalTuple = type { i64, %constructor_SomeT }
%constructor_SomeT = type { %Tuple* }
%Tuple = type { i64, %constructor_Tuple }
%constructor_Tuple = type { i64, i64 }

declare i64 @printf(i8*, ...)

define i64 @enums() {
entry:
  %gadt = alloca %Enum, align 8
  %tag_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %inner_ptr = bitcast %constructor_C* %temp_inner_ptr to %constructor_A*
  %gadt1 = alloca %Enum, align 8
  %tag_ptr2 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 0
  store i64 2, i64* %tag_ptr2, align 4
  %temp_inner_ptr3 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 1
  %inner_ptr4 = bitcast %constructor_C* %temp_inner_ptr3 to %constructor_B*
  %param = getelementptr inbounds %constructor_B, %constructor_B* %inner_ptr4, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %gadt5 = alloca %Enum, align 8
  %tag_ptr6 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 0
  store i64 0, i64* %tag_ptr6, align 4
  %temp_inner_ptr7 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %param8 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr7, i32 0, i32 1
  store i64 20, i64* %param8, align 4
  %param9 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr7, i32 0, i32 0
  store i64 10, i64* %param9, align 4
  %gadt10 = alloca %Enum, align 8
  %tag_ptr11 = getelementptr inbounds %Enum, %Enum* %gadt10, i32 0, i32 0
  store i64 0, i64* %tag_ptr11, align 4
  %temp_inner_ptr12 = getelementptr inbounds %Enum, %Enum* %gadt10, i32 0, i32 1
  %param13 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr12, i32 0, i32 0
  store i64 10, i64* %param13, align 4
  %param14 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr12, i32 0, i32 1
  store i64 20, i64* %param14, align 4
  %temp_inner_ptr15 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %tag = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 0
  %member_access = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr15, i32 0, i32 0
  %temp_inner_ptr16 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %tag17 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 0
  %member_access18 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr16, i32 0, i32 1
  %load = load i64, i64* %member_access, align 4
  %load19 = load i64, i64* %member_access18, align 4
  %add = add i64 %load, %load19
  %z = alloca i64, align 8
  store i64 %add, i64* %z, align 4
  %load20 = load i64, i64* %z, align 4
  %load21 = load i64, i64* %member_access18, align 4
  %add22 = add i64 %load20, %load21
  store i64 %add22, i64* %z, align 4
  %gadt23 = alloca %Enum, align 8
  %tag_ptr24 = getelementptr inbounds %Enum, %Enum* %gadt23, i32 0, i32 0
  store i64 0, i64* %tag_ptr24, align 4
  %temp_inner_ptr25 = getelementptr inbounds %Enum, %Enum* %gadt23, i32 0, i32 1
  %param26 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr25, i32 0, i32 1
  store i64 100, i64* %param26, align 4
  %param27 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr25, i32 0, i32 0
  %temp_inner_ptr28 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %tag29 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 0
  %member_access30 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr28, i32 0, i32 0
  %load31 = load i64, i64* %member_access30, align 4
  store i64 %load31, i64* %param27, align 4
  %load32 = load %Enum, %Enum* %gadt23, align 4
  store %Enum %load32, %Enum* %gadt5, align 4
  %temp_inner_ptr33 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %tag34 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 0
  %member_access35 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr33, i32 0, i32 0
  %load36 = load i64, i64* %member_access35, align 4
  %temp_inner_ptr37 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %tag38 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 0
  %member_access39 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr37, i32 0, i32 1
  %load40 = load i64, i64* %member_access39, align 4
  %add41 = add i64 %load36, %load40
  ret i64 %add41
}

define i64 @list() {
entry:
  %gadt = alloca %List, align 8
  %tag_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr, i32 0, i32 1
  %gadt2 = alloca %List, align 8
  %tag_ptr3 = getelementptr inbounds %List, %List* %gadt2, i32 0, i32 0
  store i64 1, i64* %tag_ptr3, align 4
  %temp_inner_ptr4 = getelementptr inbounds %List, %List* %gadt2, i32 0, i32 1
  %param5 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr4, i32 0, i32 0
  store i64 2, i64* %param5, align 4
  %param6 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr4, i32 0, i32 1
  %gadt7 = alloca %List, align 8
  %tag_ptr8 = getelementptr inbounds %List, %List* %gadt7, i32 0, i32 0
  store i64 1, i64* %tag_ptr8, align 4
  %temp_inner_ptr9 = getelementptr inbounds %List, %List* %gadt7, i32 0, i32 1
  %param10 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr9, i32 0, i32 0
  store i64 3, i64* %param10, align 4
  %param11 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr9, i32 0, i32 1
  %gadt12 = alloca %List, align 8
  %tag_ptr13 = getelementptr inbounds %List, %List* %gadt12, i32 0, i32 0
  store i64 0, i64* %tag_ptr13, align 4
  %temp_inner_ptr14 = getelementptr inbounds %List, %List* %gadt12, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Cons* %temp_inner_ptr14 to %constructor_Nil*
  store %List* %gadt12, %List** %param11, align 8
  store %List* %gadt7, %List** %param6, align 8
  store %List* %gadt2, %List** %param1, align 8
  %temp_inner_ptr15 = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %tag = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  %member_access = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr15, i32 0, i32 0
  %temp_inner_ptr16 = getelementptr inbounds %List, %List* %gadt, i32 0, i32 1
  %tag17 = getelementptr inbounds %List, %List* %gadt, i32 0, i32 0
  %member_access18 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr16, i32 0, i32 1
  %load = load i64, i64* %member_access, align 4
  %deref = load %List*, %List** %member_access18, align 8
  %temp_inner_ptr19 = getelementptr inbounds %List, %List* %deref, i32 0, i32 1
  %tag20 = getelementptr inbounds %List, %List* %deref, i32 0, i32 0
  %member_access21 = getelementptr inbounds %constructor_Cons, %constructor_Cons* %temp_inner_ptr19, i32 0, i32 0
  %load22 = load i64, i64* %member_access21, align 4
  %add = add i64 %load, %load22
  %z = alloca i64, align 8
  store i64 %add, i64* %z, align 4
  %load23 = load i64, i64* %z, align 4
  ret i64 %load23
}

define i64 @tree() {
entry:
  %gadt = alloca %BinTree, align 8
  %tag_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 0
  store i64 20, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 1
  %gadt2 = alloca %BinTree, align 8
  %tag_ptr3 = getelementptr inbounds %BinTree, %BinTree* %gadt2, i32 0, i32 0
  store i64 0, i64* %tag_ptr3, align 4
  %temp_inner_ptr4 = getelementptr inbounds %BinTree, %BinTree* %gadt2, i32 0, i32 1
  %param5 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr4, i32 0, i32 0
  store i64 10, i64* %param5, align 4
  %param6 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr4, i32 0, i32 1
  %gadt7 = alloca %BinTree, align 8
  %tag_ptr8 = getelementptr inbounds %BinTree, %BinTree* %gadt7, i32 0, i32 0
  store i64 1, i64* %tag_ptr8, align 4
  %temp_inner_ptr9 = getelementptr inbounds %BinTree, %BinTree* %gadt7, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Node* %temp_inner_ptr9 to %constructor_Leaf*
  store %BinTree* %gadt7, %BinTree** %param6, align 8
  %param10 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr4, i32 0, i32 2
  %gadt11 = alloca %BinTree, align 8
  %tag_ptr12 = getelementptr inbounds %BinTree, %BinTree* %gadt11, i32 0, i32 0
  store i64 1, i64* %tag_ptr12, align 4
  %temp_inner_ptr13 = getelementptr inbounds %BinTree, %BinTree* %gadt11, i32 0, i32 1
  %inner_ptr14 = bitcast %constructor_Node* %temp_inner_ptr13 to %constructor_Leaf*
  store %BinTree* %gadt11, %BinTree** %param10, align 8
  store %BinTree* %gadt2, %BinTree** %param1, align 8
  %param15 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr, i32 0, i32 2
  %gadt16 = alloca %BinTree, align 8
  %tag_ptr17 = getelementptr inbounds %BinTree, %BinTree* %gadt16, i32 0, i32 0
  store i64 0, i64* %tag_ptr17, align 4
  %temp_inner_ptr18 = getelementptr inbounds %BinTree, %BinTree* %gadt16, i32 0, i32 1
  %param19 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr18, i32 0, i32 0
  store i64 30, i64* %param19, align 4
  %param20 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr18, i32 0, i32 1
  %gadt21 = alloca %BinTree, align 8
  %tag_ptr22 = getelementptr inbounds %BinTree, %BinTree* %gadt21, i32 0, i32 0
  store i64 1, i64* %tag_ptr22, align 4
  %temp_inner_ptr23 = getelementptr inbounds %BinTree, %BinTree* %gadt21, i32 0, i32 1
  %inner_ptr24 = bitcast %constructor_Node* %temp_inner_ptr23 to %constructor_Leaf*
  store %BinTree* %gadt21, %BinTree** %param20, align 8
  %param25 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr18, i32 0, i32 2
  %gadt26 = alloca %BinTree, align 8
  %tag_ptr27 = getelementptr inbounds %BinTree, %BinTree* %gadt26, i32 0, i32 0
  store i64 1, i64* %tag_ptr27, align 4
  %temp_inner_ptr28 = getelementptr inbounds %BinTree, %BinTree* %gadt26, i32 0, i32 1
  %inner_ptr29 = bitcast %constructor_Node* %temp_inner_ptr28 to %constructor_Leaf*
  store %BinTree* %gadt26, %BinTree** %param25, align 8
  store %BinTree* %gadt16, %BinTree** %param15, align 8
  %temp_inner_ptr30 = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %tag = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  %member_access = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr30, i32 0, i32 1
  %temp_inner_ptr31 = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %tag32 = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  %member_access33 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr31, i32 0, i32 2
  %deref = load %BinTree*, %BinTree** %member_access, align 8
  %temp_inner_ptr34 = getelementptr inbounds %BinTree, %BinTree* %deref, i32 0, i32 1
  %tag35 = getelementptr inbounds %BinTree, %BinTree* %deref, i32 0, i32 0
  %member_access36 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr34, i32 0, i32 0
  %load = load i64, i64* %member_access36, align 4
  %temp_inner_ptr37 = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 1
  %tag38 = getelementptr inbounds %BinTree, %BinTree* %gadt, i32 0, i32 0
  %member_access39 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr37, i32 0, i32 0
  %load40 = load i64, i64* %member_access39, align 4
  %add = add i64 %load, %load40
  %deref41 = load %BinTree*, %BinTree** %member_access33, align 8
  %temp_inner_ptr42 = getelementptr inbounds %BinTree, %BinTree* %deref41, i32 0, i32 1
  %tag43 = getelementptr inbounds %BinTree, %BinTree* %deref41, i32 0, i32 0
  %member_access44 = getelementptr inbounds %constructor_Node, %constructor_Node* %temp_inner_ptr42, i32 0, i32 0
  %load45 = load i64, i64* %member_access44, align 4
  %add46 = add i64 %add, %load45
  ret i64 %add46
}

define i64 @fake_infinite() {
entry:
  %gadt = alloca %Loop, align 8
  %tag_ptr = getelementptr inbounds %Loop, %Loop* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Loop, %Loop* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Loop, %constructor_Loop* %temp_inner_ptr, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_Loop, %constructor_Loop* %temp_inner_ptr, i32 0, i32 1
  %gadt2 = alloca %Loop, align 8
  %tag_ptr3 = getelementptr inbounds %Loop, %Loop* %gadt2, i32 0, i32 0
  store i64 1, i64* %tag_ptr3, align 4
  %temp_inner_ptr4 = getelementptr inbounds %Loop, %Loop* %gadt2, i32 0, i32 1
  %inner_ptr = bitcast %constructor_Loop* %temp_inner_ptr4 to %constructor_Temp*
  store %Loop* %gadt2, %Loop** %param1, align 8
  %gadt5 = alloca %Loop, align 8
  %tag_ptr6 = getelementptr inbounds %Loop, %Loop* %gadt5, i32 0, i32 0
  store i64 0, i64* %tag_ptr6, align 4
  %temp_inner_ptr7 = getelementptr inbounds %Loop, %Loop* %gadt5, i32 0, i32 1
  %param8 = getelementptr inbounds %constructor_Loop, %constructor_Loop* %temp_inner_ptr7, i32 0, i32 0
  store i64 1, i64* %param8, align 4
  %param9 = getelementptr inbounds %constructor_Loop, %constructor_Loop* %temp_inner_ptr7, i32 0, i32 1
  store %Loop* %gadt, %Loop** %param9, align 8
  %load = load %Loop, %Loop* %gadt5, align 8
  store %Loop %load, %Loop* %gadt, align 8
  %inner_ptr10 = getelementptr inbounds %Loop, %Loop* %gadt, i32 0, i32 1
  %member_access = getelementptr inbounds %constructor_Loop, %constructor_Loop* %inner_ptr10, i32 0, i32 0
  store i64 100, i64* %member_access, align 4
  %temp_inner_ptr11 = getelementptr inbounds %Loop, %Loop* %gadt, i32 0, i32 1
  %tag = getelementptr inbounds %Loop, %Loop* %gadt, i32 0, i32 0
  %member_access12 = getelementptr inbounds %constructor_Loop, %constructor_Loop* %temp_inner_ptr11, i32 0, i32 0
  %load13 = load i64, i64* %member_access12, align 4
  ret i64 %load13
}

define i64 @test_tags() {
entry:
  %gadt = alloca %Enum, align 8
  %tag_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 0
  store i64 1, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %inner_ptr = bitcast %constructor_C* %temp_inner_ptr to %constructor_A*
  %gadt1 = alloca %Enum, align 8
  %tag_ptr2 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 0
  store i64 2, i64* %tag_ptr2, align 4
  %temp_inner_ptr3 = getelementptr inbounds %Enum, %Enum* %gadt1, i32 0, i32 1
  %inner_ptr4 = bitcast %constructor_C* %temp_inner_ptr3 to %constructor_B*
  %param = getelementptr inbounds %constructor_B, %constructor_B* %inner_ptr4, i32 0, i32 0
  store i64 1, i64* %param, align 4
  %gadt5 = alloca %Enum, align 8
  %tag_ptr6 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 0
  store i64 0, i64* %tag_ptr6, align 4
  %temp_inner_ptr7 = getelementptr inbounds %Enum, %Enum* %gadt5, i32 0, i32 1
  %param8 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr7, i32 0, i32 0
  store i64 10, i64* %param8, align 4
  %param9 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr7, i32 0, i32 1
  store i64 20, i64* %param9, align 4
  ret i64 0
}

define i64 @optionals() {
entry:
  %gadt = alloca %OptionalInt, align 8
  %tag_ptr = getelementptr inbounds %OptionalInt, %OptionalInt* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %OptionalInt, %OptionalInt* %gadt, i32 0, i32 1
  %inner_ptr = bitcast %constructor_SomeI* %temp_inner_ptr to %constructor_NoneI*
  %gadt1 = alloca %OptionalInt, align 8
  %tag_ptr2 = getelementptr inbounds %OptionalInt, %OptionalInt* %gadt1, i32 0, i32 0
  store i64 1, i64* %tag_ptr2, align 4
  %temp_inner_ptr3 = getelementptr inbounds %OptionalInt, %OptionalInt* %gadt1, i32 0, i32 1
  %param = getelementptr inbounds %constructor_SomeI, %constructor_SomeI* %temp_inner_ptr3, i32 0, i32 0
  store i64 10, i64* %param, align 4
  %gadt4 = alloca %OptionalTuple, align 8
  %tag_ptr5 = getelementptr inbounds %OptionalTuple, %OptionalTuple* %gadt4, i32 0, i32 0
  store i64 0, i64* %tag_ptr5, align 4
  %temp_inner_ptr6 = getelementptr inbounds %OptionalTuple, %OptionalTuple* %gadt4, i32 0, i32 1
  %param7 = getelementptr inbounds %constructor_SomeT, %constructor_SomeT* %temp_inner_ptr6, i32 0, i32 0
  %gadt8 = alloca %Tuple, align 8
  %tag_ptr9 = getelementptr inbounds %Tuple, %Tuple* %gadt8, i32 0, i32 0
  store i64 0, i64* %tag_ptr9, align 4
  %temp_inner_ptr10 = getelementptr inbounds %Tuple, %Tuple* %gadt8, i32 0, i32 1
  %param11 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %temp_inner_ptr10, i32 0, i32 0
  store i64 10, i64* %param11, align 4
  %param12 = getelementptr inbounds %constructor_Tuple, %constructor_Tuple* %temp_inner_ptr10, i32 0, i32 1
  store i64 20, i64* %param12, align 4
  store %Tuple* %gadt8, %Tuple** %param7, align 8
  %temp_inner_ptr13 = getelementptr inbounds %OptionalInt, %OptionalInt* %gadt1, i32 0, i32 1
  %tag = getelementptr inbounds %OptionalInt, %OptionalInt* %gadt1, i32 0, i32 0
  %member_access = getelementptr inbounds %constructor_SomeI, %constructor_SomeI* %temp_inner_ptr13, i32 0, i32 0
  %load = load i64, i64* %member_access, align 4
  ret i64 %load
}

define i64 @main() {
entry:
  %gadt = alloca %Enum, align 8
  %tag_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr, i32 0, i32 0
  store i64 10, i64* %param, align 4
  %param1 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr, i32 0, i32 1
  store i64 69, i64* %param1, align 4
  %inner_ptr = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %member_access = getelementptr inbounds %constructor_C, %constructor_C* %inner_ptr, i32 0, i32 0
  store i64 100, i64* %member_access, align 4
  %temp_inner_ptr2 = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %tag = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 0
  %member_access3 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr2, i32 0, i32 0
  %load = load i64, i64* %member_access3, align 4
  %temp_inner_ptr4 = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 1
  %tag5 = getelementptr inbounds %Enum, %Enum* %gadt, i32 0, i32 0
  %member_access6 = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr4, i32 0, i32 1
  %load7 = load i64, i64* %member_access6, align 4
  %add = add i64 %load, %load7
  ret i64 %add
}
