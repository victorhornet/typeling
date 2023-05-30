	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 13, 0
	.globl	_function1                      ; -- Begin function function1
	.p2align	2
_function1:                             ; @function1
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	mov	w8, #47
	mov	w9, #10
	stp	x9, x8, [sp, #8]
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_function2                      ; -- Begin function function2
	.p2align	2
_function2:                             ; @function2
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	w8, #4
	mov	w9, #5
	mov	w0, #20
	stp	x9, x8, [sp], #16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_function3                      ; -- Begin function function3
	.p2align	2
_function3:                             ; @function3
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	w8, #1
	fmov	d0, #10.00000000
	strb	wzr, [sp, #14]
	strb	w8, [sp, #15]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_i64_comparisons                ; -- Begin function i64_comparisons
	.p2align	2
_i64_comparisons:                       ; @i64_comparisons
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	mov	w8, #4
	mov	w9, #5
	mov	w10, #1
	strb	wzr, [sp, #15]
	strb	wzr, [sp, #12]
	stp	x9, x8, [sp, #16]
	strb	w10, [sp, #14]
	strb	w10, [sp, #13]
	strb	w10, [sp, #11]
	strb	wzr, [sp, #10]
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_bool_operations                ; -- Begin function bool_operations
	.p2align	2
_bool_operations:                       ; @bool_operations
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	w8, #1
	mov	w0, #1
	strb	wzr, [sp, #14]
	strb	w8, [sp, #15]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_function_call                  ; -- Begin function function_call
	.p2align	2
_function_call:                         ; @function_call
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	_function2
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	mov	x8, x0
	mov	w0, #1
	str	x8, [sp, #8]
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_unops                          ; -- Begin function unops
	.p2align	2
_unops:                                 ; @unops
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	mov	w8, #4
	mov	x9, #-4
	mov	x10, #4616189618054758400
	mov	x11, #-4607182418800017408
	strb	wzr, [sp, #14]
	stp	x9, x8, [sp, #32]
	mov	w8, #1
	stp	x11, x10, [sp, #16]
	strb	w8, [sp, #15]
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_blocks                         ; -- Begin function blocks
	.p2align	2
_blocks:                                ; @blocks
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	mov	w8, #5
	mov	w9, #6
	mov	w10, #10
	mov	w11, #11
	mov	w0, #11
	stp	x9, x8, [sp, #16]
	stp	x11, x10, [sp], #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_func_with_params               ; -- Begin function func_with_params
	.p2align	2
_func_with_params:                      ; @func_with_params
	.cfi_startproc
; %bb.0:                                ; %entry
	add	x0, x0, x1
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_fib                            ; -- Begin function fib
	.p2align	2
_fib:                                   ; @fib
	.cfi_startproc
; %bb.0:                                ; %entry
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	subs	x0, x0, #1
	b.eq	LBB9_3
; %bb.1:                                ; %entry
	cbz	x19, LBB9_4
; %bb.2:                                ; %merge4
	bl	_fib
	mov	x20, x0
	sub	x0, x19, #2
	bl	_fib
	add	x19, x20, x0
	b	LBB9_4
LBB9_3:                                 ; %then1
	mov	w19, #1
LBB9_4:                                 ; %common.ret
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	mov	x0, x19
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_random_while                   ; -- Begin function random_while
	.p2align	2
_random_while:                          ; @random_while
	.cfi_startproc
; %bb.0:                                ; %entry
	.cfi_def_cfa_offset 16
	stp	xzr, xzr, [sp, #-16]!
LBB10_1:                                ; %while
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x8, [sp, #8]
	cmp	x8, x0
	b.ge	LBB10_3
; %bb.2:                                ; %body
                                        ;   in Loop: Header=BB10_1 Depth=1
	ldp	x9, x8, [sp]
	add	x8, x8, #1
	add	x9, x9, x8
	stp	x9, x8, [sp]
	b	LBB10_1
LBB10_3:                                ; %merge
	ldr	x0, [sp], #16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_fib_while                      ; -- Begin function fib_while
	.p2align	2
_fib_while:                             ; @fib_while
	.cfi_startproc
; %bb.0:                                ; %entry
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	sub	sp, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w8, #1
	stur	xzr, [x29, #-24]
	stp	x8, xzr, [x29, #-16]
LBB11_1:                                ; %while
                                        ; =>This Inner Loop Header: Depth=1
	ldur	x8, [x29, #-24]
	cmp	x8, x0
	b.ge	LBB11_3
; %bb.2:                                ; %body
                                        ;   in Loop: Header=BB11_1 Depth=1
	mov	x8, sp
	sub	x9, x8, #16
	mov	sp, x9
	ldp	x10, x9, [x29, #-16]
	ldur	x11, [x29, #-24]
	add	x9, x9, x10
	stp	x9, x10, [x29, #-16]
	add	x10, x11, #1
	stur	x9, [x8, #-16]
	stur	x10, [x29, #-24]
	b	LBB11_1
LBB11_3:                                ; %merge
	ldur	x0, [x29, #-8]
	mov	sp, x29
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_fn_def_test1                   ; -- Begin function fn_def_test1
	.p2align	2
_fn_def_test1:                          ; @fn_def_test1
	.cfi_startproc
; %bb.0:                                ; %entry
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	_fn_def_test2
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_fn_def_test2                   ; -- Begin function fn_def_test2
	.p2align	2
_fn_def_test2:                          ; @fn_def_test2
	.cfi_startproc
; %bb.0:                                ; %entry
	mov	w0, #10
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_hello                          ; -- Begin function hello
	.p2align	2
_hello:                                 ; @hello
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh0:
	adrp	x0, l_string@PAGE
	mov	w8, #1
Lloh1:
	add	x0, x0, l_string@PAGEOFF
	str	x8, [sp]
	bl	_printf
Lloh2:
	adrp	x0, l_string.1@PAGE
Lloh3:
	add	x0, x0, l_string.1@PAGEOFF
	bl	_printf
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 48
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	_hello
	mov	w0, #50
	bl	_fib_while
	mov	x9, #14689
	mov	x8, x0
	movk	x9, #60979, lsl #16
	str	x0, [sp, #24]
	movk	x9, #2, lsl #32
	cmp	x0, x9
Lloh4:
	adrp	x0, l_string.2@PAGE
	cset	w9, eq
Lloh5:
	add	x0, x0, l_string.2@PAGEOFF
	strb	w9, [sp, #23]
	stp	x8, x9, [sp]
	bl	_printf
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	mov	x0, xzr
	add	sp, sp, #48
	ret
	.loh AdrpAdd	Lloh4, Lloh5
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_string:                               ; @string
	.asciz	"Hello \"world\" '!'\n num: %d\n"

l_string.1:                             ; @string.1
	.asciz	"\tthis is a tabbed string\n"

l_string.2:                             ; @string.2
	.asciz	"fib(50) = %llu (%d)\n"

.subsections_via_symbols
