; ModuleID = 'main'
source_filename = "main"

%Int = type { i64, %constructor_Int }
%constructor_Int = type { i64 }
%Enum = type { i64, %constructor_C }
%constructor_C = type { i64, i64 }

declare i64 @printf(i8*, ...)

define i64 @main() {
entry:
  %gadt = alloca %Int, align 8
  %tag_ptr = getelementptr inbounds %Int, %Int* %gadt, i32 0, i32 0
  store i64 0, i64* %tag_ptr, align 4
  %temp_inner_ptr = getelementptr inbounds %Int, %Int* %gadt, i32 0, i32 1
  %param = getelementptr inbounds %constructor_Int, %constructor_Int* %temp_inner_ptr, i32 0, i32 0
  store i64 100, i64* %param, align 4
  %x = alloca %Int*, align 8
  store %Int* %gadt, %Int** %x, align 8
  %load = load %Int*, %Int** %x, align 8
  call void @pass_by_ref(%Int* %load)
  %deref = load %Int*, %Int** %x, align 8
  %temp_inner_ptr1 = getelementptr inbounds %Int, %Int* %deref, i32 0, i32 1
  %tag = getelementptr inbounds %Int, %Int* %deref, i32 0, i32 0
  %member_access = getelementptr inbounds %constructor_Int, %constructor_Int* %temp_inner_ptr1, i32 0, i32 0
  %load2 = load i64, i64* %member_access, align 4
  ret i64 %load2
}

define void @pass_by_ref(%Int* %x) {
entry:
  %inner_ptr = getelementptr inbounds %Int, %Int* %x, i32 0, i32 1
  %member_access = getelementptr inbounds %constructor_Int, %constructor_Int* %inner_ptr, i32 0, i32 0
  store i64 10, i64* %member_access, align 4
  ret void
}

define i64 @check(i64 %x, %Enum* %z) {
entry:
  %temp_inner_ptr = getelementptr inbounds %Enum, %Enum* %z, i32 0, i32 1
  %tag = getelementptr inbounds %Enum, %Enum* %z, i32 0, i32 0
  %member_access = getelementptr inbounds %constructor_C, %constructor_C* %temp_inner_ptr, i32 0, i32 0
  %load = load i64, i64* %member_access, align 4
  %eq = icmp eq i64 %x, %load
  %eq_i64 = sext i1 %eq to i64
  ret i64 %eq_i64
}
