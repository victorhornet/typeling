; ModuleID = 'swift_types.ll'
source_filename = "swift_types.ll"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx13.0.0"

%swift.enum_vwtable = type { i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i64, i64, i32, i32, i8*, i8*, i8* }
%swift.type_metadata_record = type { i32 }
%swift.type = type { i64 }
%swift.opaque = type opaque
%T11swift_types8EnumTypeO = type <{ [16 x i8], [1 x i8] }>
%swift.bridge = type opaque
%swift.metadata_response = type { %swift.type*, i64 }

@"\01l_entry_point" = private constant { i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (i32 (i32, i8**)* @main to i64), i64 ptrtoint ({ i32, i32 }* @"\01l_entry_point" to i64)) to i32), i32 0 }, section "__TEXT, __swift5_entry, regular, no_dead_strip", align 4
@"$s11swift_types8EnumTypeOWV" = internal constant %swift.enum_vwtable { i8* bitcast (%swift.opaque* ([24 x i8]*, [24 x i8]*, %swift.type*)* @"$s11swift_types8EnumTypeOwCP" to i8*), i8* bitcast (void (%swift.opaque*, %swift.type*)* @"$s11swift_types8EnumTypeOwxx" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s11swift_types8EnumTypeOwcp" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s11swift_types8EnumTypeOwca" to i8*), i8* bitcast (i8* (i8*, i8*, %swift.type*)* @__swift_memcpy17_8 to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s11swift_types8EnumTypeOwta" to i8*), i8* bitcast (i32 (%swift.opaque*, i32, %swift.type*)* @"$s11swift_types8EnumTypeOwet" to i8*), i8* bitcast (void (%swift.opaque*, i32, i32, %swift.type*)* @"$s11swift_types8EnumTypeOwst" to i8*), i64 17, i64 24, i32 2162695, i32 254, i8* bitcast (i32 (%swift.opaque*, %swift.type*)* @"$s11swift_types8EnumTypeOwug" to i8*), i8* bitcast (void (%swift.opaque*, %swift.type*)* @"$s11swift_types8EnumTypeOwup" to i8*), i8* bitcast (void (%swift.opaque*, i32, %swift.type*)* @"$s11swift_types8EnumTypeOwui" to i8*) }, align 8
@.str.11.swift_types = private constant [12 x i8] c"swift_types\00"
@"$s11swift_typesMXM" = linkonce_odr hidden constant <{ i32, i32, i32 }> <{ i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([12 x i8]* @.str.11.swift_types to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32 }>, <{ i32, i32, i32 }>* @"$s11swift_typesMXM", i32 0, i32 2) to i64)) to i32) }>, section "__TEXT,__const", align 4
@.str.8.EnumType = private constant [9 x i8] c"EnumType\00"
@"$s11swift_types8EnumTypeOMn" = hidden constant <{ i32, i32, i32, i32, i32, i32, i32 }> <{ i32 82, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32 }>* @"$s11swift_typesMXM" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s11swift_types8EnumTypeOMn", i32 0, i32 1) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([9 x i8]* @.str.8.EnumType to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s11swift_types8EnumTypeOMn", i32 0, i32 2) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (%swift.metadata_response (i64)* @"$s11swift_types8EnumTypeOMa" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s11swift_types8EnumTypeOMn", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMF" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s11swift_types8EnumTypeOMn", i32 0, i32 4) to i64)) to i32), i32 2, i32 0 }>, section "__TEXT,__const", align 4
@"$s11swift_types8EnumTypeOMf" = internal constant <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>* }> <{ i8** getelementptr inbounds (%swift.enum_vwtable, %swift.enum_vwtable* @"$s11swift_types8EnumTypeOWV", i32 0, i32 0), i64 513, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s11swift_types8EnumTypeOMn" }>, align 8
@"symbolic _____ 11swift_types8EnumTypeO" = linkonce_odr hidden constant <{ i8, i32, i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s11swift_types8EnumTypeOMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 11swift_types8EnumTypeO", i32 0, i32 1) to i64)) to i32), i8 0 }>, section "__TEXT,__swift5_typeref, regular", align 2
@"$s11swift_types8EnumTypeOMB" = internal constant { i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 11swift_types8EnumTypeO" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMB" to i64)) to i32), i32 17, i32 65544, i32 24, i32 254 }, section "__TEXT,__swift5_builtin, regular", align 4
@"\01l__swift5_reflection_descriptor" = private constant { i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 11swift_types8EnumTypeO" to i64), i64 ptrtoint ({ i32, i32 }* @"\01l__swift5_reflection_descriptor" to i64)) to i32), i32 65536 }, section "__TEXT,__swift5_mpenum, regular", align 4
@"symbolic SJ4char_t" = linkonce_odr hidden constant <{ [9 x i8], i8 }> <{ [9 x i8] c"SJ4char_t", i8 0 }>, section "__TEXT,__swift5_typeref, regular", align 2
@0 = private constant [5 x i8] c"char\00", section "__TEXT,__swift5_reflstr, regular"
@"symbolic Si1i_t" = linkonce_odr hidden constant <{ [6 x i8], i8 }> <{ [6 x i8] c"Si1i_t", i8 0 }>, section "__TEXT,__swift5_typeref, regular", align 2
@1 = private constant [4 x i8] c"int\00", section "__TEXT,__swift5_reflstr, regular"
@"$s11swift_types8EnumTypeOMF" = internal constant { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 11swift_types8EnumTypeO" to i64), i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMF" to i64)) to i32), i32 0, i16 3, i16 12, i32 2, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ [9 x i8], i8 }>* @"symbolic SJ4char_t" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMF", i32 0, i32 6) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([5 x i8]* @0 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMF", i32 0, i32 7) to i64)) to i32), i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ [6 x i8], i8 }>* @"symbolic Si1i_t" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMF", i32 0, i32 9) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([4 x i8]* @1 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMF", i32 0, i32 10) to i64)) to i32) }, section "__TEXT,__swift5_fieldmd, regular", align 4
@"$s11swift_types8EnumTypeOHn" = private constant %swift.type_metadata_record { i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s11swift_types8EnumTypeOMn" to i64), i64 ptrtoint (%swift.type_metadata_record* @"$s11swift_types8EnumTypeOHn" to i64)) to i32) }, section "__TEXT, __swift5_types, regular", align 4
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@llvm.used = appending global [7 x i8*] [i8* bitcast (i32 (i32, i8**)* @main to i8*), i8* bitcast ({ i32, i32 }* @"\01l_entry_point" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMB" to i8*), i8* bitcast ({ i32, i32 }* @"\01l__swift5_reflection_descriptor" to i8*), i8* bitcast ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMF" to i8*), i8* bitcast (%swift.type_metadata_record* @"$s11swift_types8EnumTypeOHn" to i8*), i8* bitcast (i16* @__swift_reflection_version to i8*)], section "llvm.metadata"
@llvm.compiler.used = appending global [2 x i8*] [i8* bitcast (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>* }>* @"$s11swift_types8EnumTypeOMf" to i8*), i8* bitcast (%swift.type* @"$s11swift_types8EnumTypeON" to i8*)], section "llvm.metadata"

@"$s11swift_types8EnumTypeON" = hidden alias %swift.type, bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>* }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>* }>* @"$s11swift_types8EnumTypeOMf", i32 0, i32 1) to %swift.type*)

define i32 @main(i32 %0, i8** %1) #0 {
entry:
  %2 = bitcast i8** %1 to i8*
  ret i32 0
}

; Function Attrs: nounwind
define internal %swift.opaque* @"$s11swift_types8EnumTypeOwCP"([24 x i8]* noalias %dest, [24 x i8]* noalias %src, %swift.type* %EnumType) #1 {
entry:
  %0 = bitcast [24 x i8]* %dest to %T11swift_types8EnumTypeO*
  %1 = bitcast [24 x i8]* %src to %T11swift_types8EnumTypeO*
  %2 = bitcast %T11swift_types8EnumTypeO* %1 to { i64, i64 }*
  %3 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %2, i32 0, i32 0
  %4 = load i64, i64* %3, align 8
  %5 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %2, i32 0, i32 1
  %6 = load i64, i64* %5, align 8
  %7 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %1, i32 0, i32 1
  %8 = bitcast [1 x i8]* %7 to i1*
  %9 = load i1, i1* %8, align 8
  call void @"$s11swift_types8EnumTypeOWOy"(i64 %4, i64 %6, i1 %9)
  %10 = bitcast %T11swift_types8EnumTypeO* %0 to { i64, i64 }*
  %11 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 0
  store i64 %4, i64* %11, align 8
  %12 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 1
  store i64 %6, i64* %12, align 8
  %13 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %14 = bitcast [1 x i8]* %13 to i1*
  store i1 %9, i1* %14, align 8
  %15 = bitcast %T11swift_types8EnumTypeO* %0 to %swift.opaque*
  ret %swift.opaque* %15
}

; Function Attrs: noinline nounwind
define linkonce_odr hidden void @"$s11swift_types8EnumTypeOWOy"(i64 %0, i64 %1, i1 %2) #2 {
entry:
  br i1 %2, label %6, label %3

3:                                                ; preds = %entry
  %4 = inttoptr i64 %1 to %swift.bridge*
  %5 = call %swift.bridge* @swift_bridgeObjectRetain(%swift.bridge* returned %4) #3
  br label %6

6:                                                ; preds = %3, %entry
  ret void
}

; Function Attrs: nounwind
declare %swift.bridge* @swift_bridgeObjectRetain(%swift.bridge* returned) #3

; Function Attrs: nounwind
define internal void @"$s11swift_types8EnumTypeOwxx"(%swift.opaque* noalias %object, %swift.type* %EnumType) #1 {
entry:
  %0 = bitcast %swift.opaque* %object to %T11swift_types8EnumTypeO*
  %1 = bitcast %T11swift_types8EnumTypeO* %0 to { i64, i64 }*
  %2 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %1, i32 0, i32 0
  %3 = load i64, i64* %2, align 8
  %4 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %1, i32 0, i32 1
  %5 = load i64, i64* %4, align 8
  %6 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %7 = bitcast [1 x i8]* %6 to i1*
  %8 = load i1, i1* %7, align 8
  call void @"$s11swift_types8EnumTypeOWOe"(i64 %3, i64 %5, i1 %8)
  ret void
}

; Function Attrs: noinline nounwind
define linkonce_odr hidden void @"$s11swift_types8EnumTypeOWOe"(i64 %0, i64 %1, i1 %2) #2 {
entry:
  br i1 %2, label %5, label %3

3:                                                ; preds = %entry
  %4 = inttoptr i64 %1 to %swift.bridge*
  call void @swift_bridgeObjectRelease(%swift.bridge* %4) #3
  br label %5

5:                                                ; preds = %3, %entry
  ret void
}

; Function Attrs: nounwind
declare void @swift_bridgeObjectRelease(%swift.bridge*) #3

; Function Attrs: nounwind
define internal %swift.opaque* @"$s11swift_types8EnumTypeOwcp"(%swift.opaque* noalias %dest, %swift.opaque* noalias %src, %swift.type* %EnumType) #1 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T11swift_types8EnumTypeO*
  %1 = bitcast %swift.opaque* %src to %T11swift_types8EnumTypeO*
  %2 = bitcast %T11swift_types8EnumTypeO* %1 to { i64, i64 }*
  %3 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %2, i32 0, i32 0
  %4 = load i64, i64* %3, align 8
  %5 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %2, i32 0, i32 1
  %6 = load i64, i64* %5, align 8
  %7 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %1, i32 0, i32 1
  %8 = bitcast [1 x i8]* %7 to i1*
  %9 = load i1, i1* %8, align 8
  call void @"$s11swift_types8EnumTypeOWOy"(i64 %4, i64 %6, i1 %9)
  %10 = bitcast %T11swift_types8EnumTypeO* %0 to { i64, i64 }*
  %11 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 0
  store i64 %4, i64* %11, align 8
  %12 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 1
  store i64 %6, i64* %12, align 8
  %13 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %14 = bitcast [1 x i8]* %13 to i1*
  store i1 %9, i1* %14, align 8
  %15 = bitcast %T11swift_types8EnumTypeO* %0 to %swift.opaque*
  ret %swift.opaque* %15
}

; Function Attrs: nounwind
define internal %swift.opaque* @"$s11swift_types8EnumTypeOwca"(%swift.opaque* %dest, %swift.opaque* %src, %swift.type* %EnumType) #1 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T11swift_types8EnumTypeO*
  %1 = bitcast %swift.opaque* %src to %T11swift_types8EnumTypeO*
  %2 = bitcast %T11swift_types8EnumTypeO* %1 to { i64, i64 }*
  %3 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %2, i32 0, i32 0
  %4 = load i64, i64* %3, align 8
  %5 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %2, i32 0, i32 1
  %6 = load i64, i64* %5, align 8
  %7 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %1, i32 0, i32 1
  %8 = bitcast [1 x i8]* %7 to i1*
  %9 = load i1, i1* %8, align 8
  call void @"$s11swift_types8EnumTypeOWOy"(i64 %4, i64 %6, i1 %9)
  %10 = bitcast %T11swift_types8EnumTypeO* %0 to { i64, i64 }*
  %11 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 0
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 1
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %16 = bitcast [1 x i8]* %15 to i1*
  %17 = load i1, i1* %16, align 8
  %18 = bitcast %T11swift_types8EnumTypeO* %0 to { i64, i64 }*
  %19 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %18, i32 0, i32 0
  store i64 %4, i64* %19, align 8
  %20 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %18, i32 0, i32 1
  store i64 %6, i64* %20, align 8
  %21 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %22 = bitcast [1 x i8]* %21 to i1*
  store i1 %9, i1* %22, align 8
  call void @"$s11swift_types8EnumTypeOWOe"(i64 %12, i64 %14, i1 %17)
  %23 = bitcast %T11swift_types8EnumTypeO* %0 to %swift.opaque*
  ret %swift.opaque* %23
}

; Function Attrs: nounwind
define linkonce_odr hidden i8* @__swift_memcpy17_8(i8* %0, i8* %1, %swift.type* %2) #1 {
entry:
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %0, i8* align 8 %1, i64 17, i1 false)
  ret i8* %0
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: nounwind
define internal %swift.opaque* @"$s11swift_types8EnumTypeOwta"(%swift.opaque* noalias %dest, %swift.opaque* noalias %src, %swift.type* %EnumType) #1 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T11swift_types8EnumTypeO*
  %1 = bitcast %swift.opaque* %src to %T11swift_types8EnumTypeO*
  %2 = bitcast %T11swift_types8EnumTypeO* %1 to { i64, i64 }*
  %3 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %2, i32 0, i32 0
  %4 = load i64, i64* %3, align 8
  %5 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %2, i32 0, i32 1
  %6 = load i64, i64* %5, align 8
  %7 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %1, i32 0, i32 1
  %8 = bitcast [1 x i8]* %7 to i1*
  %9 = load i1, i1* %8, align 8
  %10 = bitcast %T11swift_types8EnumTypeO* %0 to { i64, i64 }*
  %11 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 0
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %10, i32 0, i32 1
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %16 = bitcast [1 x i8]* %15 to i1*
  %17 = load i1, i1* %16, align 8
  %18 = bitcast %T11swift_types8EnumTypeO* %0 to { i64, i64 }*
  %19 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %18, i32 0, i32 0
  store i64 %4, i64* %19, align 8
  %20 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %18, i32 0, i32 1
  store i64 %6, i64* %20, align 8
  %21 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %22 = bitcast [1 x i8]* %21 to i1*
  store i1 %9, i1* %22, align 8
  call void @"$s11swift_types8EnumTypeOWOe"(i64 %12, i64 %14, i1 %17)
  %23 = bitcast %T11swift_types8EnumTypeO* %0 to %swift.opaque*
  ret %swift.opaque* %23
}

; Function Attrs: nounwind readonly
define internal i32 @"$s11swift_types8EnumTypeOwet"(%swift.opaque* noalias %value, i32 %numEmptyCases, %swift.type* %EnumType) #5 {
entry:
  %0 = bitcast %swift.opaque* %value to %T11swift_types8EnumTypeO*
  %1 = icmp eq i32 0, %numEmptyCases
  br i1 %1, label %44, label %2

2:                                                ; preds = %entry
  %3 = icmp ugt i32 %numEmptyCases, 254
  br i1 %3, label %4, label %35

4:                                                ; preds = %2
  %5 = sub i32 %numEmptyCases, 254
  %6 = bitcast %T11swift_types8EnumTypeO* %0 to i8*
  %7 = getelementptr inbounds i8, i8* %6, i32 17
  br i1 false, label %8, label %9

8:                                                ; preds = %4
  br label %23

9:                                                ; preds = %4
  br i1 true, label %10, label %13

10:                                               ; preds = %9
  %11 = load i8, i8* %7, align 1
  %12 = zext i8 %11 to i32
  br label %23

13:                                               ; preds = %9
  br i1 false, label %14, label %18

14:                                               ; preds = %13
  %15 = bitcast i8* %7 to i16*
  %16 = load i16, i16* %15, align 1
  %17 = zext i16 %16 to i32
  br label %23

18:                                               ; preds = %13
  br i1 false, label %19, label %22

19:                                               ; preds = %18
  %20 = bitcast i8* %7 to i32*
  %21 = load i32, i32* %20, align 1
  br label %23

22:                                               ; preds = %18
  unreachable

23:                                               ; preds = %19, %14, %10, %8
  %24 = phi i32 [ 0, %8 ], [ %12, %10 ], [ %17, %14 ], [ %21, %19 ]
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %35, label %26

26:                                               ; preds = %23
  %27 = sub i32 %24, 1
  %28 = shl i32 %27, 136
  %29 = select i1 true, i32 0, i32 %28
  %30 = bitcast i8* %6 to i136*
  %31 = load i136, i136* %30, align 1
  %32 = trunc i136 %31 to i32
  %33 = or i32 %32, %29
  %34 = add i32 254, %33
  br label %45

35:                                               ; preds = %23, %2
  %36 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %37 = bitcast [1 x i8]* %36 to i1*
  %38 = bitcast i1* %37 to i8*
  %39 = load i8, i8* %38, align 8
  %40 = zext i8 %39 to i32
  %41 = sub i32 255, %40
  %42 = icmp ult i32 %41, 254
  %43 = select i1 %42, i32 %41, i32 -1
  br label %45

44:                                               ; preds = %entry
  br label %45

45:                                               ; preds = %44, %35, %26
  %46 = phi i32 [ %43, %35 ], [ %34, %26 ], [ -1, %44 ]
  %47 = add i32 %46, 1
  ret i32 %47
}

; Function Attrs: nounwind
define internal void @"$s11swift_types8EnumTypeOwst"(%swift.opaque* noalias %value, i32 %whichCase, i32 %numEmptyCases, %swift.type* %EnumType) #1 {
entry:
  %0 = bitcast %swift.opaque* %value to %T11swift_types8EnumTypeO*
  %1 = bitcast %T11swift_types8EnumTypeO* %0 to i8*
  %2 = getelementptr inbounds i8, i8* %1, i32 17
  %3 = icmp ugt i32 %numEmptyCases, 254
  br i1 %3, label %4, label %6

4:                                                ; preds = %entry
  %5 = sub i32 %numEmptyCases, 254
  br label %6

6:                                                ; preds = %4, %entry
  %7 = phi i32 [ 0, %entry ], [ 1, %4 ]
  %8 = icmp ule i32 %whichCase, 254
  br i1 %8, label %9, label %33

9:                                                ; preds = %6
  %10 = icmp eq i32 %7, 0
  br i1 %10, label %11, label %12

11:                                               ; preds = %9
  br label %24

12:                                               ; preds = %9
  %13 = icmp eq i32 %7, 1
  br i1 %13, label %14, label %15

14:                                               ; preds = %12
  store i8 0, i8* %2, align 1
  br label %24

15:                                               ; preds = %12
  %16 = icmp eq i32 %7, 2
  br i1 %16, label %17, label %19

17:                                               ; preds = %15
  %18 = bitcast i8* %2 to i16*
  store i16 0, i16* %18, align 1
  br label %24

19:                                               ; preds = %15
  %20 = icmp eq i32 %7, 4
  br i1 %20, label %21, label %23

21:                                               ; preds = %19
  %22 = bitcast i8* %2 to i32*
  store i32 0, i32* %22, align 1
  br label %24

23:                                               ; preds = %19
  unreachable

24:                                               ; preds = %21, %17, %14, %11
  %25 = icmp eq i32 %whichCase, 0
  br i1 %25, label %62, label %26

26:                                               ; preds = %24
  %27 = sub i32 %whichCase, 1
  %28 = xor i32 %27, -1
  %29 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %30 = bitcast [1 x i8]* %29 to i1*
  %31 = bitcast i1* %30 to i8*
  %32 = trunc i32 %28 to i8
  store i8 %32, i8* %31, align 8
  br label %62

33:                                               ; preds = %6
  %34 = sub i32 %whichCase, 1
  %35 = sub i32 %34, 254
  br i1 true, label %40, label %36

36:                                               ; preds = %33
  %37 = lshr i32 %35, 136
  %38 = add i32 1, %37
  %39 = and i32 poison, %35
  br label %40

40:                                               ; preds = %36, %33
  %41 = phi i32 [ 1, %33 ], [ %38, %36 ]
  %42 = phi i32 [ %35, %33 ], [ %39, %36 ]
  %43 = zext i32 %42 to i136
  %44 = bitcast i8* %1 to i136*
  store i136 %43, i136* %44, align 8
  %45 = icmp eq i32 %7, 0
  br i1 %45, label %46, label %47

46:                                               ; preds = %40
  br label %61

47:                                               ; preds = %40
  %48 = icmp eq i32 %7, 1
  br i1 %48, label %49, label %51

49:                                               ; preds = %47
  %50 = trunc i32 %41 to i8
  store i8 %50, i8* %2, align 1
  br label %61

51:                                               ; preds = %47
  %52 = icmp eq i32 %7, 2
  br i1 %52, label %53, label %56

53:                                               ; preds = %51
  %54 = trunc i32 %41 to i16
  %55 = bitcast i8* %2 to i16*
  store i16 %54, i16* %55, align 1
  br label %61

56:                                               ; preds = %51
  %57 = icmp eq i32 %7, 4
  br i1 %57, label %58, label %60

58:                                               ; preds = %56
  %59 = bitcast i8* %2 to i32*
  store i32 %41, i32* %59, align 1
  br label %61

60:                                               ; preds = %56
  unreachable

61:                                               ; preds = %58, %53, %49, %46
  br label %62

62:                                               ; preds = %61, %26, %24
  ret void
}

; Function Attrs: nounwind
define internal i32 @"$s11swift_types8EnumTypeOwug"(%swift.opaque* noalias %value, %swift.type* %EnumType) #1 {
entry:
  %0 = bitcast %swift.opaque* %value to %T11swift_types8EnumTypeO*
  %1 = bitcast %T11swift_types8EnumTypeO* %0 to { i64, i64 }*
  %2 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %1, i32 0, i32 0
  %3 = load i64, i64* %2, align 8
  %4 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %1, i32 0, i32 1
  %5 = load i64, i64* %4, align 8
  %6 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %7 = bitcast [1 x i8]* %6 to i1*
  %8 = load i1, i1* %7, align 8
  %9 = zext i1 %8 to i32
  ret i32 %9
}

; Function Attrs: nounwind
define internal void @"$s11swift_types8EnumTypeOwup"(%swift.opaque* noalias %value, %swift.type* %EnumType) #1 {
entry:
  ret void
}

; Function Attrs: nounwind
define internal void @"$s11swift_types8EnumTypeOwui"(%swift.opaque* noalias %value, i32 %tag, %swift.type* %EnumType) #1 {
entry:
  %0 = bitcast %swift.opaque* %value to %T11swift_types8EnumTypeO*
  %1 = trunc i32 %tag to i1
  %2 = getelementptr inbounds %T11swift_types8EnumTypeO, %T11swift_types8EnumTypeO* %0, i32 0, i32 1
  %3 = bitcast [1 x i8]* %2 to i1*
  store i1 %1, i1* %3, align 8
  ret void
}

; Function Attrs: noinline nounwind readnone
define hidden swiftcc %swift.metadata_response @"$s11swift_types8EnumTypeOMa"(i64 %0) #6 {
entry:
  ret %swift.metadata_response { %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>* }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>* }>* @"$s11swift_types8EnumTypeOMf", i32 0, i32 1) to %swift.type*), i64 0 }
}

attributes #0 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" }
attributes #1 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" }
attributes #2 = { noinline nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" }
attributes #3 = { nounwind }
attributes #4 = { argmemonly nofree nounwind willreturn }
attributes #5 = { nounwind readonly "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" }
attributes #6 = { noinline nounwind readnone "frame-pointer"="none" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-a12" "target-features"="+aes,+crc,+crypto,+fp-armv8,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.3a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5, !6, !7, !8, !9, !10, !11, !12, !13, !14, !15}
!swift.module.flags = !{!16}
!llvm.asan.globals = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27}
!llvm.linker.options = !{!28, !29, !30, !31, !32}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 13, i32 3]}
!1 = !{i32 1, !"Objective-C Version", i32 2}
!2 = !{i32 1, !"Objective-C Image Info Version", i32 0}
!3 = !{i32 1, !"Objective-C Image Info Section", !"__DATA,__objc_imageinfo,regular,no_dead_strip"}
!4 = !{i32 4, !"Objective-C Garbage Collection", i32 84412160}
!5 = !{i32 1, !"Objective-C Class Properties", i32 64}
!6 = !{i32 1, !"Objective-C Enforce ClassRO Pointer Signing", i8 0}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{i32 8, !"branch-target-enforcement", i32 0}
!9 = !{i32 8, !"sign-return-address", i32 0}
!10 = !{i32 8, !"sign-return-address-all", i32 0}
!11 = !{i32 8, !"sign-return-address-with-bkey", i32 0}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 1}
!14 = !{i32 7, !"frame-pointer", i32 1}
!15 = !{i32 1, !"Swift Version", i32 7}
!16 = !{!"standard-library", i1 false}
!17 = !{<{ i32, i32, i32 }>* @"$s11swift_typesMXM", null, null, i1 false, i1 true}
!18 = !{<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s11swift_types8EnumTypeOMn", null, null, i1 false, i1 true}
!19 = !{<{ i8, i32, i8 }>* @"symbolic _____ 11swift_types8EnumTypeO", null, null, i1 false, i1 true}
!20 = !{{ i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMB", null, null, i1 false, i1 true}
!21 = !{{ i32, i32 }* @"\01l__swift5_reflection_descriptor", null, null, i1 false, i1 true}
!22 = !{<{ [9 x i8], i8 }>* @"symbolic SJ4char_t", null, null, i1 false, i1 true}
!23 = !{[5 x i8]* @0, null, null, i1 false, i1 true}
!24 = !{<{ [6 x i8], i8 }>* @"symbolic Si1i_t", null, null, i1 false, i1 true}
!25 = !{[4 x i8]* @1, null, null, i1 false, i1 true}
!26 = !{{ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s11swift_types8EnumTypeOMF", null, null, i1 false, i1 true}
!27 = !{%swift.type_metadata_record* @"$s11swift_types8EnumTypeOHn", null, null, i1 false, i1 true}
!28 = !{!"-lswiftSwiftOnoneSupport"}
!29 = !{!"-lswiftCore"}
!30 = !{!"-lswift_Concurrency"}
!31 = !{!"-lswift_StringProcessing"}
!32 = !{!"-lobjc"}
