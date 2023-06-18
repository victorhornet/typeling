use std::{collections::HashMap, error::Error, path::Path};

// globals definer -> type checker -> code generation

use cfgrammar::{span, Span};
use inkwell::{
    basic_block::BasicBlock,
    builder::Builder,
    context::Context,
    execution_engine::JitFunction,
    module::Module,
    types::{BasicMetadataTypeEnum, BasicType, BasicTypeEnum},
    values::{
        BasicMetadataValueEnum, BasicValue, BasicValueEnum, FunctionValue, IntValue, PointerValue,
    },
    AddressSpace, IntPredicate, OptimizationLevel,
};
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;

use crate::{
    ast::*,
    compiler::CompilerContext,
    type_system::{gadt_to_type, GADTConstructorFields, GADT},
    Args,
};

use crate::visitors::Visitor;

pub struct CodeGen<'input, 'lexer, 'ctx> {
    pub lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
    pub llvm_ctx: &'ctx Context,
    pub compiler_ctx: CompilerContext<'input, 'ctx>,
    pub module: Module<'ctx>,
    pub builder: Builder<'ctx>,
    pub current_function: Option<FunctionValue<'ctx>>,
}

impl<'input, 'lexer, 'ctx> CodeGen<'input, 'lexer, 'ctx> {
    pub fn new(
        lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        llvm_ctx: &'ctx Context,
        compiler_ctx: CompilerContext<'input, 'ctx>,
    ) -> Self {
        let module = llvm_ctx.create_module("main");
        let builder = llvm_ctx.create_builder();

        //declare printf
        let i64_type = llvm_ctx.i64_type();
        let ptr_type = llvm_ctx.i8_type().ptr_type(AddressSpace::from(0));
        let fn_type = i64_type.fn_type(&[BasicMetadataTypeEnum::PointerType(ptr_type)], true);
        let printf = module.add_function("printf", fn_type, None);

        let mut compiler_ctx = compiler_ctx;
        compiler_ctx.function_values.insert("printf", printf);

        Self {
            lexer,
            llvm_ctx,
            compiler_ctx,
            module,
            builder,
            current_function: None,
        }
    }
    pub fn compile(&mut self, file: &File, args: &Args) {
        self.define_types(file);
        self.define_functions(file);
        self.walk_file(file);

        if !args.no_verify {
            self.module.verify().unwrap();
        }

        if args.emit_llvm {
            self.module.print_to_file(Path::new("out.ll")).unwrap();
            return;
        }

        if args.show_ir {
            self.module.print_to_stderr();
        }

        let execution_engine = self
            .module
            .create_jit_execution_engine(OptimizationLevel::Aggressive)
            .unwrap();

        unsafe {
            type Main = unsafe extern "C" fn() -> i64;
            let jit_function: JitFunction<Main> = execution_engine.get_function("main").unwrap();
            let res = jit_function.call();
            println!("Returned from main: {}", res)
        }
    }

    fn load_ptr_or_read(&self, var: BasicValueEnum<'ctx>) -> BasicValueEnum<'ctx> {
        //TODO if shit breaks, revert these changes
        if var.is_pointer_value()
            && !var
                .into_pointer_value()
                .get_type()
                .get_element_type()
                .is_struct_type()
        {
            self.builder.build_load(var.into_pointer_value(), "load")
        } else {
            var
        }
    }

    fn _build_sizeof(&self, t: &dyn BasicType<'ctx>) -> IntValue<'ctx> {
        unsafe {
            let ptr = t.ptr_type(AddressSpace::default()).const_null();

            let size = self.builder.build_gep(
                ptr,
                &[self.llvm_ctx.i32_type().const_int(1, false)],
                "size_ptr",
            );
            self.builder
                .build_ptr_to_int(size, self.llvm_ctx.i32_type(), "size_int")
        }
    }
    fn extract_value(
        &mut self,
        expr_value_or_pointer: BasicValueEnum<'ctx>,
        expr: &Expr,
    ) -> BasicValueEnum<'ctx> {
        // println!("expr_value_or_pointer: {:?}", expr_value_or_pointer);
        let val = match expr {
            Expr::Var { .. } | Expr::MemberAccess { .. } => {
                //todo extract this to function
                let ptr = expr_value_or_pointer.into_pointer_value();
                if !ptr.get_type().get_element_type().is_struct_type() {
                    self.builder
                        .build_load(expr_value_or_pointer.into_pointer_value(), "assign_deref")
                } else {
                    expr_value_or_pointer
                }
            }
            _ => expr_value_or_pointer,
        };
        // println!("val: {:?}", val);
        val
    }
    fn _build_offsetof(&self, t: &dyn BasicType<'ctx>, i: u64) -> IntValue<'ctx> {
        unsafe {
            let ptr = t.ptr_type(AddressSpace::default()).const_null();
            let offset2 = self.builder.build_gep(
                ptr,
                &[
                    self.llvm_ctx.i32_type().const_int(0, false),
                    self.llvm_ctx.i32_type().const_int(i, false),
                ],
                "offset_ptr",
            );
            self.builder
                .build_ptr_to_int(offset2, self.llvm_ctx.i32_type(), "offset_int")
        }
    }

    fn read_expr_value(&mut self, expr: &Expr) -> CodeGenResult<'ctx> {
        let op = self.visit_expr(expr)?;
        let res = op.map(|val| self.load_ptr_or_read(val));
        Ok(res)
    }

    fn define_types(&mut self, file: &File) {
        for item in &file.items {
            match item {
                Item::TypeDecl(type_decl) => {
                    self.visit_type_decl(type_decl).unwrap();
                }
                _ => continue,
            }
        }
    }

    fn define_functions(&mut self, file: &File) {
        for item in &file.items {
            match item {
                Item::FunctionDecl(function_decl) => {
                    let fn_name = self.lexer.span_str(function_decl.function_sig.name);
                    if self.compiler_ctx.function_values.contains_key(fn_name) {
                        panic!("function {} already exists", fn_name)
                    }
                    self.compiler_ctx.basic_value_stack.push();
                    let params: Vec<BasicMetadataTypeEnum> = function_decl
                        .function_sig
                        .proto
                        .params
                        .iter()
                        .map(|param| {
                            let param_type: BasicMetadataTypeEnum = match &param.param_type {
                                Type::Unit => panic!("cant have unit type argument"), //todo return error
                                Type::Int => {
                                    BasicMetadataTypeEnum::IntType(self.llvm_ctx.i64_type())
                                }
                                Type::Float => {
                                    todo!("future work: float type");
                                }
                                Type::Bool => {
                                    todo!("future work: bool type")
                                }
                                Type::String(_) => todo!("future work: constant string type"),
                                Type::Ident(name) => self
                                    .llvm_ctx
                                    .get_struct_type(name.as_str())
                                    .unwrap_or_else(|| panic!("type {} not found", name))
                                    .ptr_type(AddressSpace::default())
                                    .into(),
                                _ => unimplemented!(),
                            };
                            param_type
                        })
                        .collect();

                    let fn_type = match &function_decl.function_sig.proto.return_type {
                        Type::Unit => self.llvm_ctx.void_type().fn_type(&params, false),
                        Type::Int => self.llvm_ctx.i64_type().fn_type(&params, false),
                        Type::Float => self.llvm_ctx.f64_type().fn_type(&params, false),
                        Type::Bool => self.llvm_ctx.bool_type().fn_type(&params, false),
                        Type::String(_) => todo!("string type"),
                        Type::Ident(name) => self
                            .llvm_ctx
                            .get_struct_type(name.as_str())
                            .unwrap_or_else(|| panic!("type {} not found", name))
                            .ptr_type(AddressSpace::default())
                            .fn_type(&params, false),
                        _ => unimplemented!(),
                    };
                    let fn_value = self.module.add_function(fn_name, fn_type, None);
                    self.compiler_ctx.function_values.insert(fn_name, fn_value);
                }
                _ => continue,
            }
        }
    }

    fn get_basic_type(&self, ty: &Type) -> BasicTypeEnum<'ctx> {
        //todo return error

        match ty {
            Type::Unit => panic!("cant convert unit type to basic type"),
            Type::Int => self.llvm_ctx.i64_type().as_basic_type_enum(),
            Type::Float => self.llvm_ctx.f64_type().as_basic_type_enum(),
            Type::Bool => self.llvm_ctx.bool_type().as_basic_type_enum(),
            Type::String(size) => self
                .llvm_ctx
                .i8_type()
                .array_type(*size as u32)
                .as_basic_type_enum(),
            Type::Ident(name) => self
                .llvm_ctx
                .get_struct_type(name)
                .unwrap_or_else(|| panic!("type {} not found", name))
                .as_basic_type_enum(),
            _ => unimplemented!(),
        }
    }

    fn assign_adt_field(
        &mut self,
        param: &Expr,
        inner_ptr: PointerValue,
        i: usize,
    ) -> Result<(), Box<dyn Error>> {
        let ptr = self
            .builder
            .build_struct_gep(inner_ptr, i as u32, "param")
            .expect("type check should have caught this");
        let elem_type = ptr.get_type().get_element_type();
        let param = match param {
            e @ Expr::Var { .. } | e @ Expr::MemberAccess { .. } => {
                let res = self
                    .visit_expr(e)?
                    .expect("expr should return a value")
                    .into_pointer_value();
                if elem_type.is_pointer_type() {
                    res.as_basic_value_enum()
                } else {
                    self.builder.build_load(res, "load")
                }
            }
            e @ Expr::ConstructorCall { .. } => {
                self.visit_expr(e)?.expect("expr should return a value")
            }
            _ => self
                .read_expr_value(param)?
                .expect("expr should return a value"),
        };

        self.builder.build_store(ptr, param);
        Ok(())
    }

    fn get_member_index(&mut self, member: &MemberAccessType) -> u32 {
        let index = match member {
            MemberAccessType::Field(span) => {
                let field_name = self.lexer.span_str(*span);
                todo!("member access by field")
            }
            MemberAccessType::Index(span) => self
                .lexer
                .span_str(*span)
                .parse::<u32>()
                .expect("should be a valid index"),
        };
        index
    }

    fn build_adt_case(
        &mut self,
        patterns: &[(Pattern, CaseBranchBody)],
        value: PointerValue<'ctx>,
    ) -> CodeGenResult<'ctx> {
        //todo detect return type
        let case_result_ptr = self
            .builder
            .build_alloca(self.llvm_ctx.i64_type(), "case_return");
        let exit_block = self
            .llvm_ctx
            .append_basic_block(self.current_function.unwrap(), "after_case");
        let else_block = self
            .llvm_ctx
            .append_basic_block(self.current_function.unwrap(), "case_else");
        let current_block = self.builder.get_insert_block().unwrap();
        let inner_ptr = self
            .builder
            .build_struct_gep(value, 1, "inner_ptr")
            .expect("type check should have caught this");

        let mut pattern_blocks = HashMap::new();
        for (pattern, _) in patterns.iter() {
            if let Pattern::TypeIdent(span, _) = pattern {
                let patname = self.lexer.span_str(*span);
                //todo check if pattern matches existing constructor of type
                if !self.compiler_ctx.type_constructors.contains_key(patname) {
                    panic!("type constructor {} not found", patname);
                }
                if pattern_blocks.contains_key(patname) {
                    continue;
                }
                let block = self.llvm_ctx.append_basic_block(
                    self.current_function.unwrap(),
                    &format!("{patname}_block"),
                );
                pattern_blocks.insert(patname, block);
            }
        }
        let cases = pattern_blocks
            .iter()
            .map(|(tag, block)| {
                let (_, tag) = *self.compiler_ctx.constructor_signatures.get(*tag).unwrap();
                (
                    self.llvm_ctx.i64_type().const_int(tag as u64, false),
                    block.to_owned(),
                )
            })
            .collect::<Vec<_>>();

        for (pattern, branch) in patterns.iter() {
            match pattern {
                Pattern::TypeIdent(span, args) => {
                    let patname = self.lexer.span_str(*span);
                    let block = pattern_blocks
                        .get(patname)
                        .expect("block must exist because of previous pass");
                    self.builder.position_at_end(*block);

                    // todo!("adt patmatch: branch according to patterns");
                    let fail_block = self.llvm_ctx.append_basic_block(
                        self.current_function.unwrap(),
                        block.get_name().to_str().unwrap(),
                    );

                    match args {
                        TypePatternArgs::None => {}
                        TypePatternArgs::Tuple(patterns) => {
                            for (i, pattern) in patterns.iter().enumerate() {
                                let ptr = self
                                    .builder
                                    .build_struct_gep(inner_ptr, i as u32, "param")
                                    .expect("type check should have caught this");
                                match pattern {
                                    Pattern::Wildcard => {}
                                    Pattern::Ident(span) => {
                                        let name = self.lexer.span_str(*span);
                                        self.compiler_ctx
                                            .basic_value_stack
                                            .insert(name, (ptr.into(), true));
                                    }
                                    Pattern::Value(pat_val) => {
                                        let pat_val = self
                                            .read_expr_value(pat_val)?
                                            .expect("expr should return a value");
                                        let ptr_val = self.builder.build_load(ptr, "load");
                                        let cond = match (pat_val, ptr_val) {
                                            (
                                                BasicValueEnum::IntValue(pat_val),
                                                BasicValueEnum::IntValue(ptr_val),
                                            ) => self.builder.build_int_compare(
                                                IntPredicate::EQ,
                                                pat_val,
                                                ptr_val,
                                                "cond",
                                            ),
                                            _ => unimplemented!(
                                                "tuple pattern match on value or adt"
                                            ),
                                        };

                                        let then_block = self.llvm_ctx.append_basic_block(
                                            self.current_function.unwrap(),
                                            &format!("then_{}", i),
                                        );
                                        self.builder
                                            .build_conditional_branch(cond, then_block, fail_block);
                                        self.builder.position_at_end(then_block);
                                    }
                                    Pattern::TypeIdent(_, _) => {
                                        unimplemented!("nested adt pattern match")
                                    }
                                }
                            }
                        }

                        TypePatternArgs::Struct(_patterns) => {
                            unimplemented!("struct pattern match")
                        }
                    }
                    let result_value = match branch {
                        CaseBranchBody::Expr(expr) => self
                            .read_expr_value(expr)?
                            .expect("expr should return a value"),
                        CaseBranchBody::Block(block) => {
                            self.visit_block(block)?;
                            todo!("return value from block")
                        }
                    };
                    self.builder.build_store(case_result_ptr, result_value);
                    self.builder.build_unconditional_branch(exit_block);
                    self.builder.position_at_end(fail_block);
                    pattern_blocks.insert(patname, fail_block);
                }
                Pattern::Ident(span) => {
                    self.build_ident_case_branch(
                        else_block,
                        span,
                        value.into(),
                        branch,
                        case_result_ptr,
                        exit_block,
                    )?;
                    break;
                }
                Pattern::Wildcard => {
                    self.build_wildcard_case_branch(
                        else_block,
                        branch,
                        case_result_ptr,
                        exit_block,
                    )?;
                    break;
                }
                p => {
                    panic!("unsupported pattern in case expression for i64: {p:?}",)
                }
            }
        }

        for block in pattern_blocks.values() {
            self.builder.position_at_end(*block);
            self.builder.build_unconditional_branch(else_block);
        }

        self.builder.position_at_end(current_block);
        let tag_ptr = self
            .builder
            .build_struct_gep(value, 0, "tag_ptr")
            .expect("type check should have caught this");
        let tag_value = self.builder.build_load(tag_ptr, "tag").into_int_value();
        self.builder.build_switch(tag_value, else_block, &cases);

        self.builder.position_at_end(exit_block);
        let result_value = self.builder.build_load(case_result_ptr, "case_result");
        Ok(Some(result_value))
    }

    fn build_int_case(
        &mut self,
        patterns: &[(Pattern, CaseBranchBody)],
        value: IntValue<'ctx>,
    ) -> CodeGenResult<'ctx> {
        let case_result_ptr = self
            .builder
            .build_alloca(self.llvm_ctx.i64_type(), "case_return");
        let exit_block = self
            .llvm_ctx
            .append_basic_block(self.current_function.unwrap(), "after_case");
        let else_block = self
            .llvm_ctx
            .append_basic_block(self.current_function.unwrap(), "case_else");
        let current_block = self.builder.get_insert_block().unwrap();
        let mut cases = vec![];
        for (pattern, branch) in patterns.iter() {
            match pattern {
                Pattern::Value(inner_expr) => {
                    let branch_block = self
                        .llvm_ctx
                        .append_basic_block(self.current_function.unwrap(), "value_branch");
                    self.builder.position_at_end(branch_block);
                    let branch_res = match branch {
                        CaseBranchBody::Block(block) => self.visit_block(block)?,
                        CaseBranchBody::Expr(expr) => self.visit_expr(expr)?,
                    };
                    self.builder.build_store(
                        case_result_ptr,
                        branch_res
                            .expect("branch should return a value, block doesn't do that yet"),
                    );
                    self.builder.build_unconditional_branch(exit_block);
                    self.builder.position_at_end(exit_block);
                    let inner_value = self
                        .read_expr_value(inner_expr)?
                        .expect("expr should return a value");
                    if !inner_value.is_int_value() {
                        panic!(
                            "pattern value should be an int, got {}",
                            inner_value.get_type()
                        );
                    }
                    cases.push((inner_value.into_int_value(), branch_block));
                }
                Pattern::Ident(span) => {
                    self.build_ident_case_branch(
                        else_block,
                        span,
                        value.into(),
                        branch,
                        case_result_ptr,
                        exit_block,
                    )?;
                    break;
                }
                Pattern::Wildcard => {
                    self.build_wildcard_case_branch(
                        else_block,
                        branch,
                        case_result_ptr,
                        exit_block,
                    )?;
                    break;
                }
                p => {
                    panic!("unsupported pattern in case expression for i64: {p:?}",)
                }
            }
        }
        self.builder.position_at_end(current_block);
        self.builder.build_switch(value, else_block, &cases);
        self.builder.position_at_end(exit_block);
        let result = self
            .builder
            .build_load(case_result_ptr, "case_result_value");
        Ok(Some(result))
    }

    fn build_ident_case_branch(
        &mut self,
        else_block: BasicBlock<'ctx>,
        span: &Span,
        value: BasicValueEnum<'ctx>,
        branch: &CaseBranchBody,
        case_result_ptr: PointerValue<'ctx>,
        exit_block: BasicBlock<'ctx>,
    ) -> Result<(), Box<dyn Error>> {
        self.builder.position_at_end(else_block);
        let ident = self.lexer.span_str(*span);
        let ident_ptr = self.builder.build_alloca(value.get_type(), ident);
        self.builder.build_store(ident_ptr, value);
        self.compiler_ctx
            .basic_value_stack
            .insert(ident, (ident_ptr.into(), true));

        let branch_res = match branch {
            CaseBranchBody::Block(block) => self.visit_block(block)?,
            CaseBranchBody::Expr(expr) => self.read_expr_value(expr)?,
        };
        self.builder.build_store(
            case_result_ptr,
            branch_res.expect("branch should return a value, block doesn't do that yet"),
        );
        self.builder.build_unconditional_branch(exit_block);
        self.builder.position_at_end(exit_block);
        Ok(())
    }

    fn build_wildcard_case_branch(
        &mut self,
        else_block: BasicBlock<'_>,
        branch: &CaseBranchBody,
        case_result_ptr: PointerValue<'_>,
        exit_block: BasicBlock<'_>,
    ) -> Result<(), Box<dyn Error>> {
        self.builder.position_at_end(else_block);
        let branch_res = match branch {
            CaseBranchBody::Block(block) => self.visit_block(block)?,
            CaseBranchBody::Expr(expr) => self.visit_expr(expr)?,
        };
        self.builder.build_store(
            case_result_ptr,
            branch_res.expect("branch should return a value, block doesn't do that yet"),
        );
        self.builder.build_unconditional_branch(exit_block);
        self.builder.position_at_end(exit_block);
        Ok(())
    }

    fn build_case_on(
        &mut self,
        expr_value: BasicValueEnum<'ctx>,
        patterns: &Vec<(Pattern, CaseBranchBody)>,
    ) -> Result<Option<BasicValueEnum<'_>>, Box<dyn Error>> {
        let res = match expr_value {
            BasicValueEnum::IntValue(value) => self.build_int_case(patterns, value),
            BasicValueEnum::PointerValue(value) => self.build_adt_case(patterns, value),
            t => panic!("unsupported case expr type: {t}"),
        };
        res
    }
}

#[allow(unused_variables)]
impl<'input, 'lexer, 'ctx> Visitor<CodeGenResult<'ctx>> for CodeGen<'input, 'lexer, 'ctx> {
    fn visit_file(&mut self, file: &File) -> CodeGenResult<'ctx> {
        self.walk_file(file);
        Ok(None)
    }
    fn visit_item(&mut self, item: &Item) -> CodeGenResult<'ctx> {
        match item {
            Item::FunctionDecl(function_decl) => self.visit_function_decl(function_decl)?,
            Item::AliasDecl(alias_decl) => self.visit_alias_decl(alias_decl)?,
            Item::TypeDecl(type_decl) => None,
        };
        Ok(None)
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> CodeGenResult<'ctx> {
        let fn_name = self.lexer.span_str(function_decl.function_sig.name);

        let fn_value = self
            .compiler_ctx
            .function_values
            .get(fn_name)
            .expect("function must exist");
        self.current_function = Some(*fn_value);

        for (i, param) in function_decl.function_sig.proto.params.iter().enumerate() {
            let param_name = self.lexer.span_str(param.name);
            let param_value = fn_value.get_nth_param(i as u32).unwrap();
            param_value.set_name(param_name);
            self.compiler_ctx
                .basic_value_stack
                .insert(param_name, (param_value, true));
        }

        let entry_basic_block = self.llvm_ctx.append_basic_block(*fn_value, "entry");
        self.builder.position_at_end(entry_basic_block);

        self.walk_block(&function_decl.body);

        if entry_basic_block.get_terminator().is_none() {
            if let Type::Unit = function_decl.function_sig.proto.return_type {
                self.builder.build_return(None);
            } else {
                //todo: return error
                panic!("function must return a value");
            }
        };
        self.compiler_ctx.basic_value_stack.pop();
        Ok(None)
    }
    fn visit_block(&mut self, block: &Block) -> CodeGenResult<'ctx> {
        self.compiler_ctx.basic_value_stack.push();
        self.walk_block(block);
        self.compiler_ctx.basic_value_stack.pop();
        Ok(None)
    }
    fn visit_statement(&mut self, statement: &Statement) -> CodeGenResult<'ctx> {
        match statement {
            Statement::Return(return_) => self.visit_return(return_),
            Statement::Expr(expr) => self.read_expr_value(expr),
            Statement::VarDecl(var_decl) => self.visit_var_decl(var_decl),
            Statement::Assign(assign) => self.visit_assign(assign),
            Statement::Block(block) => self.visit_block(block),
            Statement::If(if_) => self.visit_if(if_),
            Statement::While(while_) => self.visit_while(while_),
            Statement::Print(print) => todo!("codegen print"),
        }
    }

    fn visit_assign(&mut self, assign: &Assign) -> CodeGenResult<'ctx> {
        //todo change this
        let expr_value_or_pointer = self
            .visit_expr(&assign.value)?
            .expect("expr must return a value");

        let val = self.extract_value(expr_value_or_pointer, &assign.value);
        let var = match assign.target.clone() {
            Expr::Var { name, .. } => {
                let var_name = self.lexer.span_str(name);
                let (value, _) = self
                    .compiler_ctx
                    .basic_value_stack
                    .get(var_name)
                    .unwrap_or_else(|| panic!("variable {var_name} not found"));
                value.into_pointer_value()
            }
            Expr::MemberAccess { expr, member, .. } => {
                let mut ptr = self
                    .visit_expr(expr.as_ref())?
                    .expect("expr must return a pointer value")
                    .into_pointer_value();
                if !ptr.get_type().get_element_type().is_struct_type() {
                    ptr = self.builder.build_load(ptr, "deref").into_pointer_value();
                }
                let inner_ptr = self
                    .builder
                    .build_struct_gep(ptr, 1, "inner_ptr")
                    .expect("member does not exist");

                let index = self.get_member_index(&member);
                //todo bitcast inner_ptr to variant type

                let member_ptr = self
                    .builder
                    .build_struct_gep(inner_ptr, index, "member_access")
                    .expect("member should exist");

                member_ptr
            }
            _ => panic!("assign target not supported"),
        };

        self.builder.build_store(var, val);

        Ok(None)
    }
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> CodeGenResult<'ctx> {
        let var_name = self.lexer.span_str(var_decl.name);
        if self
            .compiler_ctx
            .basic_value_stack
            .frames
            .last()
            .unwrap()
            .variables
            .contains_key(var_name)
        {
            panic!("variable already declared")
        }
        // todo: add type inferenece
        let var_type: BasicTypeEnum = match &var_decl.var_type {
            Some(Type::Unit) => panic!("cannot declare a variable of type unit"),
            Some(Type::Int) => self.llvm_ctx.i64_type().into(),
            Some(Type::Float) => todo!("future work: f64 variables"),
            Some(Type::Bool) => todo!("future work: i1 variables"),
            Some(Type::String(_)) => todo!("future work: constant string variables"),
            Some(Type::Ident(name)) => self
                .llvm_ctx
                .get_struct_type(name)
                .unwrap_or_else(|| panic!("type {} does not exist", name))
                .ptr_type(AddressSpace::default())
                .into(),
            Some(t) => unimplemented!("{:?}", t),
            None => todo!("type inference"),
        };
        let res = match &var_decl.value {
            Some(expr) => {
                let value = self.visit_expr(expr)?.expect("expr must return a value");
                let val = self.extract_value(value, expr);

                let var_ptr = self.builder.build_alloca(var_type, var_name);
                self.builder.build_store(var_ptr, val);
                (var_ptr.as_basic_value_enum(), true)
            }
            None => {
                let var_ptr = self.builder.build_alloca(var_type, var_name);
                (var_ptr.as_basic_value_enum(), false)
            }
        };
        self.compiler_ctx.basic_value_stack.insert(var_name, res);
        Ok(None)
    }
    fn visit_return(&mut self, return_: &Return) -> CodeGenResult<'ctx> {
        match return_.value {
            Some(ref value) => {
                let val = self
                    .read_expr_value(value)?
                    .expect("expr must return a value");
                self.builder.build_return(Some(&val))
            }
            None => self.builder.build_return(None),
        };
        Ok(None)
    }
    fn visit_while(&mut self, while_: &While) -> CodeGenResult<'ctx> {
        let while_block = self.llvm_ctx.append_basic_block(
            self.current_function.expect("current_function must be set"),
            "while",
        );
        let body_block = self.llvm_ctx.append_basic_block(
            self.current_function.expect("current_function must be set"),
            "body",
        );
        let merge_block = self.llvm_ctx.append_basic_block(
            self.current_function.expect("current_function must be set"),
            "merge",
        );
        self.builder.build_unconditional_branch(while_block);
        self.builder.position_at_end(while_block);
        let comparison = self
            .read_expr_value(&while_.condition)?
            .expect("expr must return a value");
        if !comparison.is_int_value() {
            panic!("if condition must be an int value")
        }

        let condition = self.builder.build_int_truncate(
            comparison.into_int_value(),
            self.llvm_ctx.bool_type(),
            "condition",
        );
        self.builder
            .build_conditional_branch(condition, body_block, merge_block);
        self.builder.position_at_end(body_block);
        self.visit_block(&while_.body)?;
        self.builder.build_unconditional_branch(while_block);
        self.builder.position_at_end(merge_block);
        Ok(None)
    }
    fn visit_if(&mut self, if_: &If) -> CodeGenResult<'ctx> {
        let then_block = self.llvm_ctx.append_basic_block(
            self.current_function.expect("current_function must be set"),
            "then",
        );
        let else_block = self.llvm_ctx.append_basic_block(
            self.current_function.expect("current_function must be set"),
            "else",
        );
        let comparison = self
            .read_expr_value(&if_.condition)?
            .expect("expr must return a value");

        if !comparison.is_int_value() {
            panic!("if condition must be an int value")
        }

        let condition = self.builder.build_int_truncate(
            comparison.into_int_value(),
            self.llvm_ctx.bool_type(),
            "condition",
        );
        self.builder
            .build_conditional_branch(condition, then_block, else_block);
        let merge_block = self.llvm_ctx.append_basic_block(
            self.current_function.expect("current_function must be set"),
            "merge",
        );
        self.builder.position_at_end(then_block);
        self.visit_block(&if_.then_block)?;
        if then_block.get_terminator().is_none() {
            self.builder.build_unconditional_branch(merge_block);
        }
        self.builder.position_at_end(else_block);
        if let Some(ref else_) = if_.else_block {
            self.visit_block(else_)?;
        }
        self.builder.build_unconditional_branch(merge_block);
        self.builder.position_at_end(merge_block);
        Ok(None)
    }
    fn visit_expr(&mut self, expr: &Expr) -> CodeGenResult<'ctx> {
        match expr {
            Expr::BinOp { lhs, op, rhs, .. } => {
                let lhs = self
                    .read_expr_value(lhs)?
                    .expect("expr should return a value");
                let rhs = self
                    .read_expr_value(rhs)?
                    .expect("expr should return a value");
                //future work: support other types
                match op {
                    BinOp::Add(_) => {
                        let result = self.builder.build_int_add(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "add",
                        );
                        Ok(Some(result.as_basic_value_enum()))
                    }
                    BinOp::Sub(_) => {
                        let res = self.builder.build_int_sub(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "sub",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Mul(_) => {
                        let res = self.builder.build_int_mul(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "mul",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Div(_) => {
                        let res = self.builder.build_int_signed_div(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "div",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Mod(_) => {
                        let res = self.builder.build_int_signed_rem(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "mod",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Eq(_) => {
                        match (lhs, rhs) {
                            (BasicValueEnum::IntValue(lhs), BasicValueEnum::IntValue(rhs)) => {
                                let res = self.builder.build_int_compare(
                                    IntPredicate::EQ,
                                    lhs,
                                    rhs,
                                    "eq",
                                );
                                let res = self.builder.build_int_cast(
                                    res,
                                    self.llvm_ctx.i64_type(),
                                    "eq_i64",
                                );
                                Ok(Some(res.as_basic_value_enum()))
                            }
                            (
                                BasicValueEnum::PointerValue(lhs),
                                BasicValueEnum::PointerValue(rhs),
                            ) => {
                                //naive pointer equality
                                //todo equality for ADT, first comparing tag, then comparing fields
                                let lhs = self.builder.build_ptr_to_int(
                                    lhs,
                                    self.llvm_ctx.i64_type(),
                                    "lhs_ptr_to_int",
                                );
                                let rhs = self.builder.build_ptr_to_int(
                                    rhs,
                                    self.llvm_ctx.i64_type(),
                                    "rhs_ptr_to_int",
                                );
                                let res = self.builder.build_int_compare(
                                    IntPredicate::EQ,
                                    lhs,
                                    rhs,
                                    "eq",
                                );
                                let res = self.builder.build_int_cast(
                                    res,
                                    self.llvm_ctx.i64_type(),
                                    "eq_i64",
                                );
                                Ok(Some(res.as_basic_value_enum()))
                            }
                            _ => Ok(None),
                        }
                    }
                    BinOp::Neq(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::NE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "neq",
                        );
                        let res =
                            self.builder
                                .build_int_cast(res, self.llvm_ctx.i64_type(), "neq_i64");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Gt(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SGT,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "gt",
                        );
                        let res =
                            self.builder
                                .build_int_cast(res, self.llvm_ctx.i64_type(), "gt_i64");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Gte(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SGE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "gte",
                        );
                        let res =
                            self.builder
                                .build_int_cast(res, self.llvm_ctx.i64_type(), "gte_i64");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Lt(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SLT,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "lt",
                        );
                        let res =
                            self.builder
                                .build_int_cast(res, self.llvm_ctx.i64_type(), "lt_i64");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Lte(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SLE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "lte",
                        );
                        let res =
                            self.builder
                                .build_int_cast(res, self.llvm_ctx.i64_type(), "lte_i64");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    // bools
                    BinOp::And(_) => {
                        let res = self.builder.build_and(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "and",
                        );
                        let res =
                            self.builder
                                .build_int_cast(res, self.llvm_ctx.i64_type(), "and_i64");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Or(_) => {
                        let res =
                            self.builder
                                .build_or(lhs.into_int_value(), rhs.into_int_value(), "or");
                        let res =
                            self.builder
                                .build_int_cast(res, self.llvm_ctx.i64_type(), "or_i64");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                }
            }
            Expr::UnOp { op, expr, .. } => {
                let expr = self
                    .read_expr_value(expr)?
                    .expect("expr should return a value");
                match op {
                    UnOp::Neg(_) => {
                        let res = if expr.is_int_value() {
                            self.builder
                                .build_int_neg(expr.into_int_value(), "neg")
                                .as_basic_value_enum()
                        } else {
                            self.builder
                                .build_float_neg(expr.into_float_value(), "neg")
                                .as_basic_value_enum()
                        };
                        Ok(Some(res))
                    }
                    UnOp::Not(_) => {
                        let res = self.builder.build_not(expr.into_int_value(), "not");
                        let res =
                            self.builder
                                .build_int_cast(res, self.llvm_ctx.i64_type(), "not_i64");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                }
            }
            Expr::Int { value, .. } => Ok(Some(
                self.llvm_ctx
                    .i64_type()
                    .const_int(*value as u64, true)
                    .as_basic_value_enum(),
            )),
            Expr::Float { value, .. } => Ok(Some(
                self.llvm_ctx
                    .f64_type()
                    .const_float(*value)
                    .as_basic_value_enum(),
            )),
            Expr::Bool { value, .. } => Ok(Some(
                self.llvm_ctx
                    .bool_type()
                    .const_int(*value as u64, false)
                    .as_basic_value_enum(),
            )),
            Expr::Var { name, .. } => {
                let var_name = self.lexer.span_str(*name);
                let (var, initialized) = self
                    .compiler_ctx
                    .basic_value_stack
                    .get(var_name)
                    .unwrap_or_else(|| panic!("variable {var_name} not found"));
                Ok(Some(var))
            }
            Expr::String { value, .. } => {
                let val = &value[1..value.len() - 1]
                    .replace("\\\\", "\\")
                    .replace("\\n", "\n")
                    .replace("\\t", "\t")
                    .replace("\\r", "\r")
                    .replace("\\\"", "\"")
                    .replace("\\\'", "\'");
                let res;
                unsafe {
                    res = self
                        .builder
                        .build_global_string(val, "string")
                        .as_pointer_value();
                }
                let ptr = self.builder.build_pointer_cast(
                    res,
                    self.llvm_ctx.i8_type().ptr_type(AddressSpace::default()),
                    "string",
                );
                Ok(Some(ptr.as_basic_value_enum()))
            }
            Expr::FunctionCall { name, args, .. } => {
                let func_name = self.lexer.span_str(*name);

                let mut args = args
                    .iter()
                    .map(|arg| {
                        BasicMetadataValueEnum::from(
                            self.read_expr_value(arg)
                                .expect("expression resulted in error") //todo handle resulting error
                                .expect("expression should return a value"),
                        )
                    })
                    .collect::<Vec<_>>();

                let func = self
                    .compiler_ctx
                    .function_values
                    .get(func_name)
                    .expect("function not found");
                let res = self
                    .builder
                    .build_call(*func, args.as_mut_slice(), "call")
                    .try_as_basic_value()
                    .left();
                Ok(res)
            }
            Expr::ConstructorCall { name, args, .. } => {
                let constructor_name = self.lexer.span_str(*name);
                let err_msg = format!("constructor {} not found", constructor_name);

                let (constructor_sig, tag) = self
                    .compiler_ctx
                    .constructor_signatures
                    .get(constructor_name)
                    .expect(&err_msg);
                let llvm_constructor_name = "constructor_".to_owned() + constructor_name;
                let gadt = self
                    .compiler_ctx
                    .type_constructors
                    .get(constructor_name)
                    .expect(&err_msg);

                let gadt_name = &gadt.name;

                let llvm_struct_type = self.llvm_ctx.get_struct_type(gadt_name).unwrap();
                let llvm_inner_type = self
                    .llvm_ctx
                    .get_struct_type(&llvm_constructor_name)
                    .unwrap();
                let llvm_inner_ptr_type = llvm_inner_type.ptr_type(AddressSpace::default());

                // ! there is no memory management here yet, so the memory allocated for the struct is leaked
                // TODO implement garbage collection
                let struct_ptr = self.builder.build_malloc(llvm_struct_type, "gadt")?;

                let tag_ptr = self
                    .builder
                    .build_struct_gep(struct_ptr, 0, "tag_ptr")
                    .unwrap();

                let tag_value = self.llvm_ctx.i64_type().const_int(*tag as u64, false);
                self.builder.build_store(tag_ptr, tag_value);

                let temp_inner_ptr = self
                    .builder
                    .build_struct_gep(struct_ptr, 1, "temp_inner_ptr")
                    .unwrap();

                let inner_ptr = self
                    .builder
                    .build_bitcast(temp_inner_ptr, llvm_inner_ptr_type, "inner_ptr")
                    .into_pointer_value();

                let params: Vec<(usize, &Expr)> = match args {
                    ConstructorCallArgs::Tuple(params) => params.iter().enumerate().collect(),
                    ConstructorCallArgs::Struct(fields) => {
                        let constructor_fields = constructor_sig.get_fields().clone();
                        match constructor_fields
                        {
                            GADTConstructorFields::Struct(_, field_indices) => {
                                fields.iter().map(|(key, expr)| {
                                    let i = *field_indices.get(key).expect("constructor call field must exist");
                                    (i, expr)
                                }).collect()
                            }
                            _ => panic!("constructor must be a struct, type checker should have caught this"),
                        }
                    }
                    ConstructorCallArgs::None => vec![],
                };
                for (i, expr) in params {
                    self.assign_adt_field(expr, inner_ptr, i)?;
                }
                // let res_ptr = self.builder.build_alloca(struct_ptr.get_type(), "res_ptr");
                Ok(Some(struct_ptr.as_basic_value_enum()))
            }

            Expr::MemberAccess { expr, member, .. } => {
                // ? need to figure out how to get adt type, specific tag and llvm type from expr
                // match **expr {
                //     Expr::Var { name, .. } => todo!("var member access"),
                //     Expr::MemberAccess { .. } => todo!("member access"),
                //     _ => panic!("unsupported member access"),
                // };

                // type checker should ensure that this is a GADT
                // so the expr should be a pointer to a GADT
                let mut e = self
                    .visit_expr(expr)?
                    .expect("expr should return a pointer value")
                    .into_pointer_value();

                let index = self.get_member_index(member);

                if !e.get_type().get_element_type().is_struct_type() {
                    e = self.builder.build_load(e, "deref").into_pointer_value();
                }

                let temp_inner_ptr = self
                    .builder
                    .build_struct_gep(e, 1, "temp_inner_ptr")
                    .unwrap();

                //todo bitcast pointer to correct type before GEP
                let _tag = self.builder.build_struct_gep(e, 0, "tag").unwrap();
                let value = self
                    .builder
                    .build_struct_gep(temp_inner_ptr, index, "member_access")
                    .unwrap();
                Ok(Some(value.as_basic_value_enum()))
            }
            Expr::Case {
                expr,
                patterns,
                span,
            } => {
                let expr_value = self.read_expr_value(expr)?.unwrap();
                self.compiler_ctx.basic_value_stack.push();
                // println!("case expr value: {:?}", expr_value);
                let res = match expr_value {
                    BasicValueEnum::IntValue(value) => self.build_int_case(patterns, value),
                    BasicValueEnum::PointerValue(value) => self.build_adt_case(patterns, value),
                    t => panic!("unsupported case expr type: {t}"),
                };
                self.compiler_ctx.basic_value_stack.pop();
                res
            }
            e => unimplemented!("{e:?}"),
        }
    }
    fn visit_type_decl(&mut self, type_decl: &GADT) -> CodeGenResult<'ctx> {
        //todo map llvm_type -> gadt
        let llvm_type = gadt_to_type(type_decl, self.llvm_ctx);
        // ! this is also done in the first type_definition_pass
        for constructor in type_decl.get_tags().keys() {
            self.compiler_ctx
                .add_type_constructor(constructor, type_decl);
        }
        self.compiler_ctx.add_constructor_signatures(type_decl);
        Ok(None)
    }
    fn visit_alias_decl(&mut self, alias: &AliasDecl) -> CodeGenResult<'ctx> {
        Ok(None)
    }
    fn visit_print(&mut self, print: &Print) -> CodeGenResult<'ctx> {
        todo!("print");
    }
}

type CodeGenResult<'a> = Result<Option<BasicValueEnum<'a>>, Box<dyn Error>>;

#[cfg(test)]
pub mod tests {
    use std::path::Path;

    use inkwell::{execution_engine::JitFunction, AddressSpace};

    use crate::{ast::Type, type_system::GADTBuilder};

    use crate::type_system::gadt_to_type;

    #[test]
    fn test_struct_generation() {
        let context = inkwell::context::Context::create();
        let builder = context.create_builder();
        let module = context.create_module("test");
        let ty = context.i64_type();
        let name = "test";
        let fn_ty = ty.fn_type(&[], false);
        let test_fn = module.add_function(name, fn_ty, None);
        let block = context.append_basic_block(test_fn, "entry");
        builder.position_at_end(block);
        let s = context.struct_type(
            &[context.i64_type().into(), context.bool_type().into()],
            false,
        );

        let x = builder.build_alloca(s, "struct");
        unsafe {
            let ptr = builder.build_gep(x, &[context.i32_type().const_int(0, false)], name);
            builder.build_store(ptr, context.i64_type().const_int(15, false));
            let val2 = builder.build_load(ptr, "load");
            builder.build_return(Some(&val2));
        }

        unsafe {
            let execution_engine = module
                .create_jit_execution_engine(inkwell::OptimizationLevel::Aggressive)
                .unwrap();
            type Main = unsafe extern "C" fn() -> i64;
            let jit_function: JitFunction<Main> = execution_engine.get_function("test").unwrap();
            let res = jit_function.call();
            println!("Returned from main: {}", res)
        }
    }

    #[test]
    fn test_nested_structs() {
        let context = inkwell::context::Context::create();
        let builder = context.create_builder();
        let module = context.create_module("test");
        let execution_engine = module
            .create_jit_execution_engine(inkwell::OptimizationLevel::Aggressive)
            .unwrap();
        let ty = context.i64_type();
        let name = "test";
        let fn_ty = ty.fn_type(&[], false);
        let test_fn = module.add_function(name, fn_ty, None);
        let block = context.append_basic_block(test_fn, "entry");
        builder.position_at_end(block);

        let inner_type = context.struct_type(
            &[context.i64_type().into(), context.bool_type().into()],
            false,
        );
        let s = context.struct_type(&[context.i64_type().into(), inner_type.into()], false);
        let ptr = builder.build_alloca(s, "struct");

        let inner_ptr = builder.build_alloca(inner_type, "inner_ptr");
        let inner_0 = builder.build_struct_gep(inner_ptr, 0, "inner_0").unwrap();
        let inner_1 = builder.build_struct_gep(inner_ptr, 1, "inner_1").unwrap();

        builder.build_store(inner_0, context.i64_type().const_int(15, false));
        builder.build_store(inner_1, context.bool_type().const_int(1, false));

        let inner_val = builder.build_load(inner_ptr, "inner_val");

        let tag = builder.build_struct_gep(ptr, 0, "tag").unwrap();
        let inner = builder.build_struct_gep(ptr, 1, "inner").unwrap();

        builder.build_store(tag, context.i64_type().const_int(0, false));
        builder.build_store(inner, inner_val);

        let val2 = builder.build_load(tag, "load");

        builder.build_return(Some(&val2));
        module.verify().unwrap();

        unsafe {
            type Main = unsafe extern "C" fn() -> i64;
            let jit_function: JitFunction<Main> = execution_engine.get_function("test").unwrap();
            let res = jit_function.call();
            println!("Returned from main: {}", res)
        }
    }

    #[test]
    fn test_compute_enums_variant_size() {
        let context = inkwell::context::Context::create();
        let builder = context.create_builder();
        let module = context.create_module("test");
        let execution_engine = module
            .create_jit_execution_engine(inkwell::OptimizationLevel::None)
            .unwrap();
        let ty = context.i32_type();
        let name = "test";
        let fn_ty = ty.fn_type(&[], false);
        let test_fn = module.add_function(name, fn_ty, None);
        let block = context.append_basic_block(test_fn, "entry");
        builder.position_at_end(block);

        let s1 = context.struct_type(
            &[context.i64_type().into(), context.i32_type().into()],
            false,
        );
        let s2 = context.struct_type(&[context.i64_type().into(), s1.into()], false);

        let ptr1 = s1.ptr_type(AddressSpace::default()).const_null();
        let ptr2 = s2.ptr_type(AddressSpace::default()).const_null();

        unsafe {
            let size1 = builder.build_gep(ptr1, &[context.i32_type().const_int(1, false)], "Size");
            let val1 = builder.build_ptr_to_int(size1, context.i32_type(), "SizeInt");
            let val11 = s1.size_of().unwrap();
            val1.print_to_stderr();
            val11.print_to_stderr();

            let size2 = builder.build_gep(ptr2, &[context.i32_type().const_int(1, false)], "Size");
            let val2 = builder.build_ptr_to_int(size2, context.i32_type(), "SizeInt");
            val2.print_to_stderr();

            let offset2 = builder.build_gep(
                ptr2,
                &[
                    context.i32_type().const_int(0, false),
                    context.i32_type().const_int(1, false),
                ],
                "Offset",
            );
            let val3 = builder.build_ptr_to_int(offset2, context.i32_type(), "OffsetInt");
            val3.print_to_stderr();

            builder.build_return(Some(&val3));
        }
        module.verify().unwrap();
        module.print_to_stderr();

        unsafe {
            type Main = unsafe extern "C" fn() -> i64;
            let jit_function: JitFunction<Main> = execution_engine.get_function("test").unwrap();
            let res = jit_function.call();
            println!("Returned size: {}", res)
        }
    }

    #[test]
    fn test_unit_type() {
        let context = inkwell::context::Context::create();
        let builder = context.create_builder();
        let module = context.create_module("unit_test");
        let execution_engine = module
            .create_jit_execution_engine(inkwell::OptimizationLevel::None)
            .unwrap();
        let ty = context.i64_type();

        let name = "unit_test";
        let fn_ty = ty.fn_type(&[], false);
        let test_fn = module.add_function(name, fn_ty, None);
        let block = context.append_basic_block(test_fn, "entry");
        builder.position_at_end(block);

        let unit_struct = context.struct_type(&[context.i64_type().into()], false);
        let val = unit_struct.size_of().unwrap();

        let unit = context.opaque_struct_type("unit");
        unit.set_body(&[context.i64_type().into()], false);

        let ptr = builder.build_alloca(unit, "unit_struct");
        let tag = builder.build_struct_gep(ptr, 0, "tag").unwrap();
        builder.build_store(tag, context.i64_type().const_int(10, false));

        builder.build_return(Some(&val));
        module.verify().unwrap();
        module
            .print_to_file(Path::new("examples/unit_test.ll"))
            .unwrap();

        unsafe {
            type Main = unsafe extern "C" fn() -> i64;
            let jit_function: JitFunction<Main> =
                execution_engine.get_function("unit_test").unwrap();
            let res = jit_function.call();
            println!("Returned unit_test: {}", res)
        }
    }

    #[test]
    fn test_constructor_codegen() {
        let context = inkwell::context::Context::create();
        let builder = context.create_builder();
        let module = context.create_module("unit_test");
        let execution_engine = module
            .create_jit_execution_engine(inkwell::OptimizationLevel::None)
            .unwrap();

        let fn_ty = context.void_type().fn_type(&[], false);
        let test_fn = module.add_function("unit_test", fn_ty, None);
        let block = context.append_basic_block(test_fn, "entry");
        builder.position_at_end(block);

        let enum_gadt = GADTBuilder::new("Enum")
            .unit_constructor("Unit")
            .tuple_constructor("Tuple", &[Type::Int, Type::Bool, Type::Int])
            .struct_constructor("Struct", &[("x", Type::Int), ("y", Type::Bool)])
            .build();
        let enum_type = gadt_to_type(&enum_gadt, &context);
        let _enum_value = builder.build_alloca(enum_type, "enum_value");
        let _enum_size = enum_type.size_of().unwrap();

        // SomeType = SomeType Enum

        let some_gadt = GADTBuilder::new("SomeType")
            .tuple_constructor("SomeType", &[Type::Ident("Enum".to_string())])
            .build();

        let some_gadt_type = gadt_to_type(&some_gadt, &context);
        println!("SomeGADT: {}", some_gadt_type.print_to_string());
        let _some_gadt_value = builder.build_alloca(some_gadt_type, "some_gadt_value");

        builder.build_return(None);
        module.verify().unwrap();
        module
            .print_to_file(Path::new("examples/constructor_test.ll"))
            .unwrap();

        unsafe {
            type Main = unsafe extern "C" fn() -> ();
            let _jit_function: JitFunction<Main> =
                execution_engine.get_function("unit_test").unwrap();
            // jit_function.call();
        }
    }
}
