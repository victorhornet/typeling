; ModuleID = 'test.cpp'
source_filename = "test.cpp"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx13.0.0"

%struct.tagUnion = type { i8, %union.vals }
%union.vals = type { %struct.a }
%struct.a = type { i32, i32, i32 }

; Function Attrs: mustprogress noinline norecurse nounwind optnone ssp uwtable
define noundef i32 @main(i32 noundef %0, i8** noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca %struct.tagUnion, align 4
  %7 = alloca %struct.tagUnion, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  %8 = getelementptr inbounds %struct.tagUnion, %struct.tagUnion* %6, i32 0, i32 0
  store i8 105, i8* %8, align 4
  %9 = getelementptr inbounds %struct.tagUnion, %struct.tagUnion* %6, i32 0, i32 1
  %10 = bitcast %union.vals* %9 to i32*
  store i32 10, i32* %10, align 4
  %11 = getelementptr inbounds %struct.tagUnion, %struct.tagUnion* %7, i32 0, i32 0
  store i8 99, i8* %11, align 4
  %12 = getelementptr inbounds %struct.tagUnion, %struct.tagUnion* %7, i32 0, i32 1
  %13 = bitcast %union.vals* %12 to i8*
  store i8 97, i8* %13, align 4
  ret i32 0
}

attributes #0 = { mustprogress noinline norecurse nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"branch-target-enforcement", i32 0}
!2 = !{i32 1, !"sign-return-address", i32 0}
!3 = !{i32 1, !"sign-return-address-all", i32 0}
!4 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 1}
!7 = !{i32 7, !"frame-pointer", i32 1}
!8 = !{!"Homebrew clang version 14.0.6"}
