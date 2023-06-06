use std::error::Error;

// globals definer -> type checker -> code generation

use inkwell::{
    builder::Builder,
    context::Context,
    execution_engine::JitFunction,
    module::Module,
    types::{BasicMetadataTypeEnum, BasicType, BasicTypeEnum},
    values::{BasicMetadataValueEnum, BasicValue, BasicValueEnum, FunctionValue, IntValue},
    AddressSpace, IntPredicate, OptimizationLevel,
};
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;

use crate::{
    ast::*,
    compiler::CompilerContext,
    type_system::{gadt_to_type, GADT},
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
    pub fn compile(&mut self, file: &File) {
        let execution_engine = self
            .module
            .create_jit_execution_engine(OptimizationLevel::None)
            .unwrap();

        self.define_items(file);

        self.walk_file(file);

        self.module.verify().unwrap();

        unsafe {
            type Main = unsafe extern "C" fn() -> i64;
            let jit_function: JitFunction<Main> = execution_engine.get_function("main").unwrap();
            let _res = jit_function.call();
            // println!("Returned from main: {}", res)
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

    fn define_items(&mut self, file: &File) {
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
                                    BasicMetadataTypeEnum::FloatType(self.llvm_ctx.f64_type())
                                }
                                Type::Bool => {
                                    BasicMetadataTypeEnum::IntType(self.llvm_ctx.bool_type())
                                }
                                Type::String(_) => todo!("string type"),
                                Type::Ident(name) => self
                                    .llvm_ctx
                                    .get_struct_type(name.as_str())
                                    .unwrap_or_else(|| panic!("type {} not found", name))
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
                            .fn_type(&params, false),
                        _ => unimplemented!(),
                    };
                    let fn_value = self.module.add_function(fn_name, fn_type, None);
                    self.compiler_ctx.function_values.insert(fn_name, fn_value);
                }
                Item::TypeDecl(type_decl) => {
                    let _type_name = &type_decl.name;
                    todo!("type decl");
                }
                Item::AliasDecl(alias_decl) => {
                    let _alias_name = self.lexer.span_str(alias_decl.name);
                    let _alias_type = self.get_basic_type(&alias_decl.original);
                    // self.context.add_type_alias(alias_type, alias_name);
                    todo!("alias type")
                }
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
            Item::TypeDecl(type_decl) => self.visit_type_decl(type_decl)?,
            Item::AliasDecl(alias_decl) => self.visit_alias_decl(alias_decl)?,
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
                .insert(param_name, param_value);
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
            Statement::Expr(expr) => self.visit_expr(expr),
            Statement::VarDecl(var_decl) => self.visit_var_decl(var_decl),
            Statement::Assign(assign) => self.visit_assign(assign),
            Statement::Block(block) => self.visit_block(block),
            Statement::If(if_) => self.visit_if(if_),
            Statement::While(while_) => self.visit_while(while_),
            Statement::Print(print) => todo!("codegen print"),
        }
    }
    fn visit_assign(&mut self, assign: &Assign) -> CodeGenResult<'ctx> {
        let var_name = self.lexer.span_str(assign.name);
        let var = self
            .compiler_ctx
            .basic_value_stack
            .get(var_name)
            .unwrap_or_else(|| panic!("variable {var_name} not found"));
        let var_value = self
            .visit_expr(&assign.value)?
            .expect("expr must return a value");

        if var.is_pointer_value() {
            self.builder
                .build_store(var.into_pointer_value(), var_value);
        } else {
            self.compiler_ctx
                .basic_value_stack
                .insert(var_name, var_value);
        }
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
        let var_type = match &var_decl.var_type {
            Some(Type::Unit) => panic!("cannot declare a variable of type unit"),
            Some(Type::Int) => BasicTypeEnum::IntType(self.llvm_ctx.i64_type()),
            Some(Type::Float) => BasicTypeEnum::FloatType(self.llvm_ctx.f64_type()),
            Some(Type::Bool) => BasicTypeEnum::IntType(self.llvm_ctx.bool_type()),
            Some(Type::String(_)) => todo!("string type"),
            Some(Type::Ident(_)) => todo!("custom type"),
            Some(t) => unimplemented!("{:?}", t),
            None => todo!("type inference"),
        };
        let var_ptr = self
            .builder
            .build_alloca(var_type, var_name)
            .as_basic_value_enum();
        self.compiler_ctx
            .basic_value_stack
            .insert(var_name, var_ptr.as_basic_value_enum());

        if let Some(var_value) = &var_decl.value {
            let var_value = self
                .visit_expr(var_value)?
                .expect("expr must return a value")
                .as_basic_value_enum();
            self.builder
                .build_store(var_ptr.into_pointer_value(), var_value);
        };
        Ok(None)
    }
    fn visit_return(&mut self, return_: &Return) -> CodeGenResult<'ctx> {
        match return_.value {
            Some(ref value) => {
                let return_value = self
                    .visit_expr(value)?
                    .expect("return value should be a value");
                self.builder.build_return(Some(&return_value))
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
            .visit_expr(&while_.condition)?
            .expect("expr should return a value");
        self.builder
            .build_conditional_branch(comparison.into_int_value(), body_block, merge_block);
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
            .visit_expr(&if_.condition)?
            .expect("expr should return a value");
        self.builder
            .build_conditional_branch(comparison.into_int_value(), then_block, else_block);
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
                let lhs = self.visit_expr(lhs)?.expect("expr should return a value");
                let rhs = self.visit_expr(rhs)?.expect("expr should return a value");
                //todo support other types
                match op {
                    //ints, floats, strings
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
                    //ints, floats
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
                    // ints
                    BinOp::Mod(_) => {
                        let res = self.builder.build_int_signed_rem(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "mod",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    // ints, floats, bools, strings
                    BinOp::Eq(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::EQ,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "eq",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Neq(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::NE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "neq",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    // ints, floats
                    BinOp::Gt(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SGT,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "gt",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Gte(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SGE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "gte",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Lt(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SLT,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "lt",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Lte(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SLE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "lte",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    // bools
                    BinOp::And(_) => {
                        let res = self.builder.build_and(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "and",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Or(_) => {
                        let res =
                            self.builder
                                .build_or(lhs.into_int_value(), rhs.into_int_value(), "or");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                }
            }
            Expr::UnOp { op, expr, .. } => {
                let expr = self.visit_expr(expr)?.expect("expr should return a value");
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
                        Ok(Some(res.as_basic_value_enum()))
                    }
                }
            }
            Expr::Int { value, .. } => Ok(Some(
                self.llvm_ctx
                    .i64_type()
                    .const_int(*value as u64, false)
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
                let var = self
                    .compiler_ctx
                    .basic_value_stack
                    .get(var_name)
                    .expect("variable not found");
                let val = if var.is_pointer_value() {
                    self.builder.build_load(var.into_pointer_value(), var_name)
                } else {
                    var
                };
                Ok(Some(val))
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
            Expr::Struct { .. } => todo!("struct expr"),
            Expr::Enum { .. } => todo!("enum expr"),
            Expr::Array { .. } => todo!("array expr"),
            Expr::FunctionCall { name, args, .. } => {
                let func_name = self.lexer.span_str(*name);

                let mut args = args
                    .iter()
                    .map(|arg| {
                        BasicMetadataValueEnum::from(
                            self.visit_expr(arg)
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
            Expr::Function { .. } => todo!("anon function expr"),
            Expr::ConstructorCall { name, args, .. } => {
                let constructor_name = self.lexer.span_str(*name);
                let gadt_name = &self
                    .compiler_ctx
                    .type_constructors
                    .get(constructor_name)
                    .unwrap()
                    .name;

                let llvm_type = self.llvm_ctx.get_struct_type(gadt_name).unwrap();

                let struct_ptr = self.builder.build_alloca(llvm_type, "gadt");

                Ok(Some(struct_ptr.as_basic_value_enum()))

                // todo!("constructor call expr: set tag of gadt");

                // todo!("constructor call expr: set fields of gadt");
            }
        }
    }
    fn visit_type_decl(&mut self, type_decl: &GADT) -> CodeGenResult<'ctx> {
        let llvm_type = gadt_to_type(type_decl, self.llvm_ctx);
        for constructor in type_decl.constructors.keys() {
            self.compiler_ctx
                .add_type_constructor(&constructor, &type_decl)
        }
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
    use std::{collections::HashMap, path::Path};

    use inkwell::{execution_engine::JitFunction, AddressSpace};

    use crate::{
        ast::Type,
        type_system::{
            GADTBuilder, GADTConstructor, GADTConstructorBuilder, GADTConstructorFields, GADT,
        },
    };

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
        let enum_value = builder.build_alloca(enum_type, "enum_value");
        let _enum_size = enum_type.size_of().unwrap();

        // SomeType = SomeType Enum

        let some_gadt = GADTBuilder::new("SomeType")
            .tuple_constructor("SomeType", &[Type::Ident("Enum".to_string())])
            .build();

        let some_gadt_type = gadt_to_type(&some_gadt, &context);
        println!("SomeGADT: {}", some_gadt_type.print_to_string());
        let some_gadt_value = builder.build_alloca(some_gadt_type, "some_gadt_value");
        // let _some_gadt_size = some_gadt_type.size_of().unwrap();

        builder.build_return(None);
        module.verify().unwrap();
        module
            .print_to_file(Path::new("examples/constructor_test.ll"))
            .unwrap();

        unsafe {
            type Main = unsafe extern "C" fn() -> ();
            let jit_function: JitFunction<Main> =
                execution_engine.get_function("unit_test").unwrap();
            // jit_function.call();
        }
    }
}
