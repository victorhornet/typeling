target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-darwin"
declare ccc i32 @memcmp(i8*, i8*, i64)
declare ccc i8* @memcpy(i8*, i8*, i64)
declare ccc i8* @memmove(i8*, i8*, i64)
declare ccc i8* @memset(i8*, i64, i64)
declare ccc i64 @newSpark(i8*, i8*)
!0 = !{!"root"}
!1 = !{!"top", !0}
!2 = !{!"stack", !1}
!3 = !{!"heap", !1}
!4 = !{!"rx", !3}
!5 = !{!"base", !1}

%Main_Leaf_closure_struct = type <{i64}>
@Main_Leaf_closure$def = internal global %Main_Leaf_closure_struct<{i64 ptrtoint (i8* @Main_Leaf_con_info to i64)}>
@Main_Leaf_closure = alias i8, bitcast (%Main_Leaf_closure_struct* @Main_Leaf_closure$def to i8*)
%Main_Branch_closure_struct = type <{i64}>
@Main_Branch_closure$def = internal global %Main_Branch_closure_struct<{i64 ptrtoint (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_Branch_info$def to i64)}>
@Main_Branch_closure = alias i8, bitcast (%Main_Branch_closure_struct* @Main_Branch_closure$def to i8*)
@Main_Branch_info = internal alias i8, bitcast (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_Branch_info$def to i8*)
define internal ghccc void @Main_Branch_info$def(i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %Hp_Arg, i64 %R1_Arg, i64 %R2_Arg, i64 %R3_Arg, i64 %R4_Arg, i64 %R5_Arg, i64 %R6_Arg, i64 %SpLim_Arg) align 8 nounwind prefix <{i64, i64, i32, i32}><{i64 12884901911, i64 0, i32 14, i32 0}>
{
nJ3:
  %lB2 = alloca i64, i32 1
  %lB1 = alloca i64, i32 1
  %lB0 = alloca i64, i32 1
  %Hp_Var = alloca i64*, i32 1
  store i64* %Hp_Arg, i64** %Hp_Var
  %lcIX = alloca i64, i32 1
  %R1_Var = alloca i64, i32 1
  store i64 %R1_Arg, i64* %R1_Var
  %R4_Var = alloca i64, i32 1
  store i64 %R4_Arg, i64* %R4_Var
  %R3_Var = alloca i64, i32 1
  store i64 %R3_Arg, i64* %R3_Var
  %R2_Var = alloca i64, i32 1
  store i64 %R2_Arg, i64* %R2_Var
  br label %cIY
cIY:
  %lnJ4 = load i64, i64* %R4_Var
  store i64 %lnJ4, i64* %lB2
  %lnJ5 = load i64, i64* %R3_Var
  store i64 %lnJ5, i64* %lB1
  %lnJ6 = load i64, i64* %R2_Var
  store i64 %lnJ6, i64* %lB0
  br label %cJ0
cJ0:
  %lnJ7 = load i64*, i64** %Hp_Var
  %lnJ8 = getelementptr inbounds i64, i64* %lnJ7, i32 4
  %lnJ9 = ptrtoint i64* %lnJ8 to i64
  %lnJa = inttoptr i64 %lnJ9 to i64*
  store i64* %lnJa, i64** %Hp_Var
  %lnJb = load i64*, i64** %Hp_Var
  %lnJc = ptrtoint i64* %lnJb to i64
  %lnJd = getelementptr inbounds i64, i64* %Base_Arg, i32 107
  %lnJe = bitcast i64* %lnJd to i64*
  %lnJf = load i64, i64* %lnJe, !tbaa !5
  %lnJg = icmp ugt i64 %lnJc, %lnJf
  %lnJi = call ccc i1 (i1, i1) @llvm.expect.i1( i1 %lnJg, i1 0 )
  br i1 %lnJi, label %cJ2, label %cJ1
cJ1:
  %lnJk = ptrtoint i8* @Main_Branch_con_info to i64
  %lnJj = load i64*, i64** %Hp_Var
  %lnJl = getelementptr inbounds i64, i64* %lnJj, i32 -3
  store i64 %lnJk, i64* %lnJl, !tbaa !3
  %lnJn = load i64, i64* %lB0
  %lnJm = load i64*, i64** %Hp_Var
  %lnJo = getelementptr inbounds i64, i64* %lnJm, i32 -2
  store i64 %lnJn, i64* %lnJo, !tbaa !3
  %lnJq = load i64, i64* %lB1
  %lnJp = load i64*, i64** %Hp_Var
  %lnJr = getelementptr inbounds i64, i64* %lnJp, i32 -1
  store i64 %lnJq, i64* %lnJr, !tbaa !3
  %lnJt = load i64, i64* %lB2
  %lnJs = load i64*, i64** %Hp_Var
  %lnJu = getelementptr inbounds i64, i64* %lnJs, i32 0
  store i64 %lnJt, i64* %lnJu, !tbaa !3
  %lnJw = load i64*, i64** %Hp_Var
  %lnJx = ptrtoint i64* %lnJw to i64
  %lnJy = add i64 %lnJx, -23
  store i64 %lnJy, i64* %lcIX
  %lnJz = load i64, i64* %lcIX
  store i64 %lnJz, i64* %R1_Var
  %lnJA = getelementptr inbounds i64, i64* %Sp_Arg, i32 0
  %lnJB = bitcast i64* %lnJA to i64*
  %lnJC = load i64, i64* %lnJB, !tbaa !2
  %lnJD = inttoptr i64 %lnJC to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnJE = load i64*, i64** %Hp_Var
  %lnJF = load i64, i64* %R1_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnJD( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %lnJE, i64 %lnJF, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
cJ2:
  %lnJG = getelementptr inbounds i64, i64* %Base_Arg, i32 113
  store i64 32, i64* %lnJG, !tbaa !5
  br label %cIZ
cIZ:
  %lnJH = load i64, i64* %lB2
  store i64 %lnJH, i64* %R4_Var
  %lnJI = load i64, i64* %lB1
  store i64 %lnJI, i64* %R3_Var
  %lnJJ = load i64, i64* %lB0
  store i64 %lnJJ, i64* %R2_Var
  %lnJK = ptrtoint %Main_Branch_closure_struct* @Main_Branch_closure$def to i64
  store i64 %lnJK, i64* %R1_Var
  %lnJL = getelementptr inbounds i64, i64* %Base_Arg, i32 -1
  %lnJM = bitcast i64* %lnJL to i64*
  %lnJN = load i64, i64* %lnJM, !tbaa !5
  %lnJO = inttoptr i64 %lnJN to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnJP = load i64*, i64** %Hp_Var
  %lnJQ = load i64, i64* %R1_Var
  %lnJR = load i64, i64* %R2_Var
  %lnJS = load i64, i64* %R3_Var
  %lnJT = load i64, i64* %R4_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnJO( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %lnJP, i64 %lnJQ, i64 %lnJR, i64 %lnJS, i64 %lnJT, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
}
declare ccc i1 @llvm.expect.i1(i1, i1)
%rFW_bytes_struct = type <{[8 x i8]}>
@rFW_bytes$def = internal constant %rFW_bytes_struct<{[8 x i8] [i8 39, i8 66, i8 114, i8 97, i8 110, i8 99, i8 104, i8 0]}>, align 1
@rFW_bytes = internal alias i8, bitcast (%rFW_bytes_struct* @rFW_bytes$def to i8*)
%rFX_closure_struct = type <{i64, i64}>
@rFX_closure$def = internal global %rFX_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_TrNameS_con_info to i64), i64 ptrtoint (%rFW_bytes_struct* @rFW_bytes$def to i64)}>
@rFX_closure = internal alias i8, bitcast (%rFX_closure_struct* @rFX_closure$def to i8*)
%rFR_bytes_struct = type <{[6 x i8]}>
@rFR_bytes$def = internal constant %rFR_bytes_struct<{[6 x i8] [i8 39, i8 76, i8 101, i8 97, i8 102, i8 0]}>, align 1
@rFR_bytes = internal alias i8, bitcast (%rFR_bytes_struct* @rFR_bytes$def to i8*)
%rFS_closure_struct = type <{i64, i64}>
@rFS_closure$def = internal global %rFS_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_TrNameS_con_info to i64), i64 ptrtoint (%rFR_bytes_struct* @rFR_bytes$def to i64)}>
@rFS_closure = internal alias i8, bitcast (%rFS_closure_struct* @rFS_closure$def to i8*)
%rFO_bytes_struct = type <{[8 x i8]}>
@rFO_bytes$def = internal constant %rFO_bytes_struct<{[8 x i8] [i8 66, i8 105, i8 110, i8 84, i8 114, i8 101, i8 101, i8 0]}>, align 1
@rFO_bytes = internal alias i8, bitcast (%rFO_bytes_struct* @rFO_bytes$def to i8*)
%rFP_closure_struct = type <{i64, i64}>
@rFP_closure$def = internal global %rFP_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_TrNameS_con_info to i64), i64 ptrtoint (%rFO_bytes_struct* @rFO_bytes$def to i64)}>
@rFP_closure = internal alias i8, bitcast (%rFP_closure_struct* @rFP_closure$def to i8*)
%rFN_closure_struct = type <{i64, i64, i64, i64}>
@rFN_closure$def = internal global %rFN_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_KindRepTyConApp_con_info to i64), i64 ptrtoint (i8* @ghczmprim_GHCziTypes_zdtcInt_closure to i64), i64 add (i64 ptrtoint (i8* @ghczmprim_GHCziTypes_ZMZN_closure to i64),i64 1), i64 0}>
@rFN_closure = internal alias i8, bitcast (%rFN_closure_struct* @rFN_closure$def to i8*)
%rFL_bytes_struct = type <{[5 x i8]}>
@rFL_bytes$def = internal constant %rFL_bytes_struct<{[5 x i8] [i8 77, i8 97, i8 105, i8 110, i8 0]}>, align 1
@rFL_bytes = internal alias i8, bitcast (%rFL_bytes_struct* @rFL_bytes$def to i8*)
%rFM_closure_struct = type <{i64, i64}>
@rFM_closure$def = internal global %rFM_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_TrNameS_con_info to i64), i64 ptrtoint (%rFL_bytes_struct* @rFL_bytes$def to i64)}>
@rFM_closure = internal alias i8, bitcast (%rFM_closure_struct* @rFM_closure$def to i8*)
%rFw_bytes_struct = type <{[5 x i8]}>
@rFw_bytes$def = internal constant %rFw_bytes_struct<{[5 x i8] [i8 109, i8 97, i8 105, i8 110, i8 0]}>, align 1
@rFw_bytes = internal alias i8, bitcast (%rFw_bytes_struct* @rFw_bytes$def to i8*)
%rFK_closure_struct = type <{i64, i64}>
@rFK_closure$def = internal global %rFK_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_TrNameS_con_info to i64), i64 ptrtoint (%rFw_bytes_struct* @rFw_bytes$def to i64)}>
@rFK_closure = internal alias i8, bitcast (%rFK_closure_struct* @rFK_closure$def to i8*)
%Main_zdtrModule_closure_struct = type <{i64, i64, i64, i64}>
@Main_zdtrModule_closure$def = internal global %Main_zdtrModule_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_Module_con_info to i64), i64 add (i64 ptrtoint (%rFK_closure_struct* @rFK_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFM_closure_struct* @rFM_closure$def to i64),i64 1), i64 3}>
@Main_zdtrModule_closure = alias i8, bitcast (%Main_zdtrModule_closure_struct* @Main_zdtrModule_closure$def to i8*)
%Main_zdtcBinTree_closure_struct = type <{i64, i64, i64, i64, i64, i64, i64, i64}>
@Main_zdtcBinTree_closure$def = internal global %Main_zdtcBinTree_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_TyCon_con_info to i64), i64 add (i64 ptrtoint (%Main_zdtrModule_closure_struct* @Main_zdtrModule_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFP_closure_struct* @rFP_closure$def to i64),i64 1), i64 ptrtoint (i8* @ghczmprim_GHCziTypes_krepzdzt_closure to i64), i64 -2445062076186093802, i64 6903462257480046109, i64 0, i64 0}>
@Main_zdtcBinTree_closure = alias i8, bitcast (%Main_zdtcBinTree_closure_struct* @Main_zdtcBinTree_closure$def to i8*)
%rFQ_closure_struct = type <{i64, i64, i64, i64}>
@rFQ_closure$def = internal global %rFQ_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_KindRepTyConApp_con_info to i64), i64 add (i64 ptrtoint (%Main_zdtcBinTree_closure_struct* @Main_zdtcBinTree_closure$def to i64),i64 1), i64 add (i64 ptrtoint (i8* @ghczmprim_GHCziTypes_ZMZN_closure to i64),i64 1), i64 0}>
@rFQ_closure = internal alias i8, bitcast (%rFQ_closure_struct* @rFQ_closure$def to i8*)
%rFT_closure_struct = type <{i64, i64, i64, i64}>
@rFT_closure$def = internal global %rFT_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_KindRepFun_con_info to i64), i64 add (i64 ptrtoint (%rFQ_closure_struct* @rFQ_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFQ_closure_struct* @rFQ_closure$def to i64),i64 1), i64 0}>
@rFT_closure = internal alias i8, bitcast (%rFT_closure_struct* @rFT_closure$def to i8*)
%rFU_closure_struct = type <{i64, i64, i64, i64}>
@rFU_closure$def = internal global %rFU_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_KindRepFun_con_info to i64), i64 add (i64 ptrtoint (%rFQ_closure_struct* @rFQ_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFT_closure_struct* @rFT_closure$def to i64),i64 4), i64 0}>
@rFU_closure = internal alias i8, bitcast (%rFU_closure_struct* @rFU_closure$def to i8*)
%rFV_closure_struct = type <{i64, i64, i64, i64}>
@rFV_closure$def = internal global %rFV_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_KindRepFun_con_info to i64), i64 add (i64 ptrtoint (%rFN_closure_struct* @rFN_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFU_closure_struct* @rFU_closure$def to i64),i64 4), i64 0}>
@rFV_closure = internal alias i8, bitcast (%rFV_closure_struct* @rFV_closure$def to i8*)
%Main_zdtczqLeaf_closure_struct = type <{i64, i64, i64, i64, i64, i64, i64, i64}>
@Main_zdtczqLeaf_closure$def = internal global %Main_zdtczqLeaf_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_TyCon_con_info to i64), i64 add (i64 ptrtoint (%Main_zdtrModule_closure_struct* @Main_zdtrModule_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFS_closure_struct* @rFS_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFQ_closure_struct* @rFQ_closure$def to i64),i64 1), i64 2429462324830996089, i64 3103893512769260469, i64 0, i64 0}>
@Main_zdtczqLeaf_closure = alias i8, bitcast (%Main_zdtczqLeaf_closure_struct* @Main_zdtczqLeaf_closure$def to i8*)
%Main_zdtczqBranch_closure_struct = type <{i64, i64, i64, i64, i64, i64, i64, i64}>
@Main_zdtczqBranch_closure$def = internal global %Main_zdtczqBranch_closure_struct<{i64 ptrtoint (i8* @ghczmprim_GHCziTypes_TyCon_con_info to i64), i64 add (i64 ptrtoint (%Main_zdtrModule_closure_struct* @Main_zdtrModule_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFX_closure_struct* @rFX_closure$def to i64),i64 1), i64 add (i64 ptrtoint (%rFV_closure_struct* @rFV_closure$def to i64),i64 4), i64 -7872746134045103564, i64 -3839579712851502114, i64 0, i64 0}>
@Main_zdtczqBranch_closure = alias i8, bitcast (%Main_zdtczqBranch_closure_struct* @Main_zdtczqBranch_closure$def to i8*)
%_uK8_srt_struct = type <{i64, i64, i64}>
%_uK9_srt_struct = type <{i64, i64, i64, i64, i64}>
%Main_main_closure_struct = type <{i64, i64, i64, i64}>
@_uK8_srt$def = internal global %_uK8_srt_struct<{i64 ptrtoint (i8* @stg_SRT_1_info to i64), i64 ptrtoint (i8* @base_SystemziIO_print_closure to i64), i64 0}>
@_uK8_srt = internal alias i8, bitcast (%_uK8_srt_struct* @_uK8_srt$def to i8*)
@_uK9_srt$def = internal global %_uK9_srt_struct<{i64 ptrtoint (i8* @stg_SRT_3_info to i64), i64 ptrtoint (i8* @base_GHCziShow_zdfShowChar_closure to i64), i64 ptrtoint (i8* @base_GHCziShow_zdfShowZMZN_closure to i64), i64 ptrtoint (i8* @_uK8_srt to i64), i64 0}>
@_uK9_srt = internal alias i8, bitcast (%_uK9_srt_struct* @_uK9_srt$def to i8*)
@Main_main_closure$def = internal global %Main_main_closure_struct<{i64 ptrtoint (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_main_info$def to i64), i64 0, i64 0, i64 0}>
@Main_main_closure = alias i8, bitcast (%Main_main_closure_struct* @Main_main_closure$def to i8*)
@Main_main_info = alias i8, bitcast (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_main_info$def to i8*)
define ghccc void @Main_main_info$def(i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %Hp_Arg, i64 %R1_Arg, i64 %R2_Arg, i64 %R3_Arg, i64 %R4_Arg, i64 %R5_Arg, i64 %R6_Arg, i64 %SpLim_Arg) align 8 nounwind prefix <{i64, i64, i32, i32}><{i64 add (i64 sub (i64 ptrtoint (%_uK9_srt_struct* @_uK9_srt$def to i64),i64 ptrtoint (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_main_info$def to i64)),i64 0), i64 0, i32 21, i32 1}>
{
nKa:
  %lrg1 = alloca i64, i32 1
  %lcJX = alloca i64, i32 1
  %R2_Var = alloca i64, i32 1
  store i64 undef, i64* %R2_Var
  %R1_Var = alloca i64, i32 1
  store i64 %R1_Arg, i64* %R1_Var
  %Sp_Var = alloca i64*, i32 1
  store i64* %Sp_Arg, i64** %Sp_Var
  br label %cK2
cK2:
  %lnKb = load i64, i64* %R1_Var
  store i64 %lnKb, i64* %lrg1
  %lnKc = load i64*, i64** %Sp_Var
  %lnKd = getelementptr inbounds i64, i64* %lnKc, i32 1
  %lnKe = ptrtoint i64* %lnKd to i64
  %lnKf = sub i64 %lnKe, 32
  %lnKg = icmp ult i64 %lnKf, %SpLim_Arg
  %lnKh = call ccc i1 (i1, i1) @llvm.expect.i1( i1 %lnKg, i1 0 )
  br i1 %lnKh, label %cK3, label %cK4
cK4:
  %lnKi = ptrtoint i64* %Base_Arg to i64
  %lnKj = inttoptr i64 %lnKi to i8*
  %lnKk = load i64, i64* %lrg1
  %lnKl = inttoptr i64 %lnKk to i8*
  %lnKm = bitcast i8* @newCAF to i8* (i8*, i8*)*
  %lnKn = call ccc i8* (i8*, i8*) %lnKm( i8* %lnKj, i8* %lnKl ) nounwind
  %lnKo = ptrtoint i8* %lnKn to i64
  store i64 %lnKo, i64* %lcJX
  %lnKp = load i64, i64* %lcJX
  %lnKq = icmp eq i64 %lnKp, 0
  br i1 %lnKq, label %cJZ, label %cJY
cJY:
  %lnKs = ptrtoint i8* @stg_bh_upd_frame_info to i64
  %lnKr = load i64*, i64** %Sp_Var
  %lnKt = getelementptr inbounds i64, i64* %lnKr, i32 -2
  store i64 %lnKs, i64* %lnKt, !tbaa !2
  %lnKv = load i64, i64* %lcJX
  %lnKu = load i64*, i64** %Sp_Var
  %lnKw = getelementptr inbounds i64, i64* %lnKu, i32 -1
  store i64 %lnKv, i64* %lnKw, !tbaa !2
  %lnKy = ptrtoint void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @cK0_info$def to i64
  %lnKx = load i64*, i64** %Sp_Var
  %lnKz = getelementptr inbounds i64, i64* %lnKx, i32 -3
  store i64 %lnKy, i64* %lnKz, !tbaa !2
  %lnKA = ptrtoint i8* @base_GHCziShow_zdfShowChar_closure to i64
  store i64 %lnKA, i64* %R2_Var
  %lnKB = ptrtoint i8* @base_GHCziShow_zdfShowZMZN_closure to i64
  store i64 %lnKB, i64* %R1_Var
  %lnKC = load i64*, i64** %Sp_Var
  %lnKD = getelementptr inbounds i64, i64* %lnKC, i32 -3
  %lnKE = ptrtoint i64* %lnKD to i64
  %lnKF = inttoptr i64 %lnKE to i64*
  store i64* %lnKF, i64** %Sp_Var
  %lnKG = bitcast i8* @stg_ap_p_fast to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnKH = load i64*, i64** %Sp_Var
  %lnKI = load i64, i64* %R1_Var
  %lnKJ = load i64, i64* %R2_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnKG( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %lnKH, i64* noalias nocapture %Hp_Arg, i64 %lnKI, i64 %lnKJ, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
cJZ:
  %lnKK = load i64, i64* %lrg1
  %lnKL = inttoptr i64 %lnKK to i64*
  %lnKM = load i64, i64* %lnKL, !tbaa !1
  %lnKN = inttoptr i64 %lnKM to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnKO = load i64*, i64** %Sp_Var
  %lnKP = load i64, i64* %R1_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnKN( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %lnKO, i64* noalias nocapture %Hp_Arg, i64 %lnKP, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
cK3:
  %lnKQ = load i64, i64* %lrg1
  store i64 %lnKQ, i64* %R1_Var
  %lnKR = getelementptr inbounds i64, i64* %Base_Arg, i32 -2
  %lnKS = bitcast i64* %lnKR to i64*
  %lnKT = load i64, i64* %lnKS, !tbaa !5
  %lnKU = inttoptr i64 %lnKT to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnKV = load i64*, i64** %Sp_Var
  %lnKW = load i64, i64* %R1_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnKU( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %lnKV, i64* noalias nocapture %Hp_Arg, i64 %lnKW, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
}
@cK0_info = internal alias i8, bitcast (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @cK0_info$def to i8*)
define internal ghccc void @cK0_info$def(i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %Hp_Arg, i64 %R1_Arg, i64 %R2_Arg, i64 %R3_Arg, i64 %R4_Arg, i64 %R5_Arg, i64 %R6_Arg, i64 %SpLim_Arg) align 8 nounwind prefix <{i64, i64, i32, i32}><{i64 add (i64 sub (i64 ptrtoint (%_uK8_srt_struct* @_uK8_srt$def to i64),i64 ptrtoint (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @cK0_info$def to i64)),i64 0), i64 0, i32 30, i32 1}>
{
nKX:
  %lsIS = alloca i64, i32 1
  %R3_Var = alloca i64, i32 1
  store i64 undef, i64* %R3_Var
  %R2_Var = alloca i64, i32 1
  store i64 undef, i64* %R2_Var
  %R1_Var = alloca i64, i32 1
  store i64 %R1_Arg, i64* %R1_Var
  %Sp_Var = alloca i64*, i32 1
  store i64* %Sp_Arg, i64** %Sp_Var
  br label %cK0
cK0:
  %lnKY = load i64, i64* %R1_Var
  store i64 %lnKY, i64* %lsIS
  %lnKZ = ptrtoint i8* @ghczmprim_GHCziTypes_ZMZN_closure to i64
  %lnL0 = add i64 %lnKZ, 1
  store i64 %lnL0, i64* %R3_Var
  %lnL1 = load i64, i64* %lsIS
  store i64 %lnL1, i64* %R2_Var
  %lnL2 = ptrtoint i8* @base_SystemziIO_print_closure to i64
  store i64 %lnL2, i64* %R1_Var
  %lnL3 = load i64*, i64** %Sp_Var
  %lnL4 = getelementptr inbounds i64, i64* %lnL3, i32 1
  %lnL5 = ptrtoint i64* %lnL4 to i64
  %lnL6 = inttoptr i64 %lnL5 to i64*
  store i64* %lnL6, i64** %Sp_Var
  %lnL7 = bitcast i8* @stg_ap_pp_fast to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnL8 = load i64*, i64** %Sp_Var
  %lnL9 = load i64, i64* %R1_Var
  %lnLa = load i64, i64* %R2_Var
  %lnLb = load i64, i64* %R3_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnL7( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %lnL8, i64* noalias nocapture %Hp_Arg, i64 %lnL9, i64 %lnLa, i64 %lnLb, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
}
%_uLl_srt_struct = type <{i64, i64, i64, i64}>
%ZCMain_main_closure_struct = type <{i64, i64, i64, i64}>
@_uLl_srt$def = internal global %_uLl_srt_struct<{i64 ptrtoint (i8* @stg_SRT_2_info to i64), i64 ptrtoint (i8* @base_GHCziTopHandler_runMainIO_closure to i64), i64 ptrtoint (%Main_main_closure_struct* @Main_main_closure$def to i64), i64 0}>
@_uLl_srt = internal alias i8, bitcast (%_uLl_srt_struct* @_uLl_srt$def to i8*)
@ZCMain_main_closure$def = internal global %ZCMain_main_closure_struct<{i64 ptrtoint (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @ZCMain_main_info$def to i64), i64 0, i64 0, i64 0}>
@ZCMain_main_closure = alias i8, bitcast (%ZCMain_main_closure_struct* @ZCMain_main_closure$def to i8*)
@ZCMain_main_info = alias i8, bitcast (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @ZCMain_main_info$def to i8*)
define ghccc void @ZCMain_main_info$def(i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %Hp_Arg, i64 %R1_Arg, i64 %R2_Arg, i64 %R3_Arg, i64 %R4_Arg, i64 %R5_Arg, i64 %R6_Arg, i64 %SpLim_Arg) align 8 nounwind prefix <{i64, i64, i32, i32}><{i64 add (i64 sub (i64 ptrtoint (%_uLl_srt_struct* @_uLl_srt$def to i64),i64 ptrtoint (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @ZCMain_main_info$def to i64)),i64 0), i64 0, i32 21, i32 1}>
{
nLm:
  %l01D = alloca i64, i32 1
  %lcLf = alloca i64, i32 1
  %R2_Var = alloca i64, i32 1
  store i64 undef, i64* %R2_Var
  %R1_Var = alloca i64, i32 1
  store i64 %R1_Arg, i64* %R1_Var
  %Sp_Var = alloca i64*, i32 1
  store i64* %Sp_Arg, i64** %Sp_Var
  br label %cLi
cLi:
  %lnLn = load i64, i64* %R1_Var
  store i64 %lnLn, i64* %l01D
  %lnLo = load i64*, i64** %Sp_Var
  %lnLp = getelementptr inbounds i64, i64* %lnLo, i32 1
  %lnLq = ptrtoint i64* %lnLp to i64
  %lnLr = sub i64 %lnLq, 24
  %lnLs = icmp ult i64 %lnLr, %SpLim_Arg
  %lnLt = call ccc i1 (i1, i1) @llvm.expect.i1( i1 %lnLs, i1 0 )
  br i1 %lnLt, label %cLj, label %cLk
cLk:
  %lnLu = ptrtoint i64* %Base_Arg to i64
  %lnLv = inttoptr i64 %lnLu to i8*
  %lnLw = load i64, i64* %l01D
  %lnLx = inttoptr i64 %lnLw to i8*
  %lnLy = bitcast i8* @newCAF to i8* (i8*, i8*)*
  %lnLz = call ccc i8* (i8*, i8*) %lnLy( i8* %lnLv, i8* %lnLx ) nounwind
  %lnLA = ptrtoint i8* %lnLz to i64
  store i64 %lnLA, i64* %lcLf
  %lnLB = load i64, i64* %lcLf
  %lnLC = icmp eq i64 %lnLB, 0
  br i1 %lnLC, label %cLh, label %cLg
cLg:
  %lnLE = ptrtoint i8* @stg_bh_upd_frame_info to i64
  %lnLD = load i64*, i64** %Sp_Var
  %lnLF = getelementptr inbounds i64, i64* %lnLD, i32 -2
  store i64 %lnLE, i64* %lnLF, !tbaa !2
  %lnLH = load i64, i64* %lcLf
  %lnLG = load i64*, i64** %Sp_Var
  %lnLI = getelementptr inbounds i64, i64* %lnLG, i32 -1
  store i64 %lnLH, i64* %lnLI, !tbaa !2
  %lnLJ = ptrtoint %Main_main_closure_struct* @Main_main_closure$def to i64
  store i64 %lnLJ, i64* %R2_Var
  %lnLK = ptrtoint i8* @base_GHCziTopHandler_runMainIO_closure to i64
  store i64 %lnLK, i64* %R1_Var
  %lnLL = load i64*, i64** %Sp_Var
  %lnLM = getelementptr inbounds i64, i64* %lnLL, i32 -2
  %lnLN = ptrtoint i64* %lnLM to i64
  %lnLO = inttoptr i64 %lnLN to i64*
  store i64* %lnLO, i64** %Sp_Var
  %lnLP = bitcast i8* @stg_ap_p_fast to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnLQ = load i64*, i64** %Sp_Var
  %lnLR = load i64, i64* %R1_Var
  %lnLS = load i64, i64* %R2_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnLP( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %lnLQ, i64* noalias nocapture %Hp_Arg, i64 %lnLR, i64 %lnLS, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
cLh:
  %lnLT = load i64, i64* %l01D
  %lnLU = inttoptr i64 %lnLT to i64*
  %lnLV = load i64, i64* %lnLU, !tbaa !1
  %lnLW = inttoptr i64 %lnLV to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnLX = load i64*, i64** %Sp_Var
  %lnLY = load i64, i64* %R1_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnLW( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %lnLX, i64* noalias nocapture %Hp_Arg, i64 %lnLY, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
cLj:
  %lnLZ = load i64, i64* %l01D
  store i64 %lnLZ, i64* %R1_Var
  %lnM0 = getelementptr inbounds i64, i64* %Base_Arg, i32 -2
  %lnM1 = bitcast i64* %lnM0 to i64*
  %lnM2 = load i64, i64* %lnM1, !tbaa !5
  %lnM3 = inttoptr i64 %lnM2 to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnM4 = load i64*, i64** %Sp_Var
  %lnM5 = load i64, i64* %R1_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnM3( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %lnM4, i64* noalias nocapture %Hp_Arg, i64 %lnM5, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
}
%iM7_str_struct = type <{[17 x i8]}>
@iM7_str$def = internal constant %iM7_str_struct<{[17 x i8] [i8 109, i8 97, i8 105, i8 110, i8 58, i8 77, i8 97, i8 105, i8 110, i8 46, i8 66, i8 114, i8 97, i8 110, i8 99, i8 104, i8 0]}>, align 1
@iM7_str = internal alias i8, bitcast (%iM7_str_struct* @iM7_str$def to i8*)
@Main_Branch_con_info = alias i8, bitcast (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_Branch_con_info$def to i8*)
define ghccc void @Main_Branch_con_info$def(i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %Hp_Arg, i64 %R1_Arg, i64 %R2_Arg, i64 %R3_Arg, i64 %R4_Arg, i64 %R5_Arg, i64 %R6_Arg, i64 %SpLim_Arg) align 8 nounwind prefix <{i64, i64, i32, i32}><{i64 add (i64 sub (i64 ptrtoint (%iM7_str_struct* @iM7_str$def to i64),i64 ptrtoint (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_Branch_con_info$def to i64)),i64 0), i64 3, i32 1, i32 0}>
{
nM8:
  %R1_Var = alloca i64, i32 1
  store i64 %R1_Arg, i64* %R1_Var
  br label %cM6
cM6:
  %lnMa = load i64, i64* %R1_Var
  %lnMb = add i64 %lnMa, 1
  store i64 %lnMb, i64* %R1_Var
  %lnMc = getelementptr inbounds i64, i64* %Sp_Arg, i32 0
  %lnMd = bitcast i64* %lnMc to i64*
  %lnMe = load i64, i64* %lnMd, !tbaa !2
  %lnMf = inttoptr i64 %lnMe to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnMg = load i64, i64* %R1_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnMf( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %Hp_Arg, i64 %lnMg, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
}
%iMi_str_struct = type <{[15 x i8]}>
@iMi_str$def = internal constant %iMi_str_struct<{[15 x i8] [i8 109, i8 97, i8 105, i8 110, i8 58, i8 77, i8 97, i8 105, i8 110, i8 46, i8 76, i8 101, i8 97, i8 102, i8 0]}>, align 1
@iMi_str = internal alias i8, bitcast (%iMi_str_struct* @iMi_str$def to i8*)
@Main_Leaf_con_info = alias i8, bitcast (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_Leaf_con_info$def to i8*)
define ghccc void @Main_Leaf_con_info$def(i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %Hp_Arg, i64 %R1_Arg, i64 %R2_Arg, i64 %R3_Arg, i64 %R4_Arg, i64 %R5_Arg, i64 %R6_Arg, i64 %SpLim_Arg) align 8 nounwind prefix <{i64, i64, i32, i32}><{i64 add (i64 sub (i64 ptrtoint (%iMi_str_struct* @iMi_str$def to i64),i64 ptrtoint (void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)* @Main_Leaf_con_info$def to i64)),i64 0), i64 4294967296, i32 3, i32 1}>
{
nMj:
  %R1_Var = alloca i64, i32 1
  store i64 %R1_Arg, i64* %R1_Var
  br label %cMh
cMh:
  %lnMl = load i64, i64* %R1_Var
  %lnMm = add i64 %lnMl, 2
  store i64 %lnMm, i64* %R1_Var
  %lnMn = getelementptr inbounds i64, i64* %Sp_Arg, i32 0
  %lnMo = bitcast i64* %lnMn to i64*
  %lnMp = load i64, i64* %lnMo, !tbaa !2
  %lnMq = inttoptr i64 %lnMp to void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64)*
  %lnMr = load i64, i64* %R1_Var
  tail call ghccc void (i64*, i64*, i64*, i64, i64, i64, i64, i64, i64, i64) %lnMq( i64* noalias nocapture %Base_Arg, i64* noalias nocapture %Sp_Arg, i64* noalias nocapture %Hp_Arg, i64 %lnMr, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 %SpLim_Arg ) nounwind
  ret void
}

@ghczmprim_GHCziTypes_TrNameS_con_info = external global i8
@ghczmprim_GHCziTypes_KindRepTyConApp_con_info = external global i8
@ghczmprim_GHCziTypes_zdtcInt_closure = external global i8
@ghczmprim_GHCziTypes_ZMZN_closure = external global i8
@ghczmprim_GHCziTypes_Module_con_info = external global i8
@ghczmprim_GHCziTypes_TyCon_con_info = external global i8
@ghczmprim_GHCziTypes_krepzdzt_closure = external global i8
@ghczmprim_GHCziTypes_KindRepFun_con_info = external global i8
@stg_SRT_1_info = external global i8
@base_SystemziIO_print_closure = external global i8
@stg_SRT_3_info = external global i8
@base_GHCziShow_zdfShowChar_closure = external global i8
@base_GHCziShow_zdfShowZMZN_closure = external global i8
@newCAF = external global i8
@stg_bh_upd_frame_info = external global i8
@stg_ap_p_fast = external global i8
@stg_ap_pp_fast = external global i8
@stg_SRT_2_info = external global i8
@base_GHCziTopHandler_runMainIO_closure = external global i8
@llvm.used = appending constant [28 x i8*] [i8* bitcast (%iMi_str_struct* @iMi_str$def to i8*), i8* bitcast (%iM7_str_struct* @iM7_str$def to i8*), i8* bitcast (%ZCMain_main_closure_struct* @ZCMain_main_closure$def to i8*), i8* bitcast (%_uLl_srt_struct* @_uLl_srt$def to i8*), i8* bitcast (%Main_main_closure_struct* @Main_main_closure$def to i8*), i8* bitcast (%_uK9_srt_struct* @_uK9_srt$def to i8*), i8* bitcast (%_uK8_srt_struct* @_uK8_srt$def to i8*), i8* bitcast (%Main_zdtczqBranch_closure_struct* @Main_zdtczqBranch_closure$def to i8*), i8* bitcast (%Main_zdtczqLeaf_closure_struct* @Main_zdtczqLeaf_closure$def to i8*), i8* bitcast (%rFV_closure_struct* @rFV_closure$def to i8*), i8* bitcast (%rFU_closure_struct* @rFU_closure$def to i8*), i8* bitcast (%rFT_closure_struct* @rFT_closure$def to i8*), i8* bitcast (%rFQ_closure_struct* @rFQ_closure$def to i8*), i8* bitcast (%Main_zdtcBinTree_closure_struct* @Main_zdtcBinTree_closure$def to i8*), i8* bitcast (%Main_zdtrModule_closure_struct* @Main_zdtrModule_closure$def to i8*), i8* bitcast (%rFK_closure_struct* @rFK_closure$def to i8*), i8* bitcast (%rFw_bytes_struct* @rFw_bytes$def to i8*), i8* bitcast (%rFM_closure_struct* @rFM_closure$def to i8*), i8* bitcast (%rFL_bytes_struct* @rFL_bytes$def to i8*), i8* bitcast (%rFN_closure_struct* @rFN_closure$def to i8*), i8* bitcast (%rFP_closure_struct* @rFP_closure$def to i8*), i8* bitcast (%rFO_bytes_struct* @rFO_bytes$def to i8*), i8* bitcast (%rFS_closure_struct* @rFS_closure$def to i8*), i8* bitcast (%rFR_bytes_struct* @rFR_bytes$def to i8*), i8* bitcast (%rFX_closure_struct* @rFX_closure$def to i8*), i8* bitcast (%rFW_bytes_struct* @rFW_bytes$def to i8*), i8* bitcast (%Main_Branch_closure_struct* @Main_Branch_closure$def to i8*), i8* bitcast (%Main_Leaf_closure_struct* @Main_Leaf_closure$def to i8*)], section "llvm.metadata"
