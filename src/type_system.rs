use cfgrammar::Span;
use inkwell::{
    context::Context,
    module::Module,
    types::{BasicTypeEnum, StructType},
    AddressSpace,
};
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;

use crate::{ast::*, compiler::CompilerContext};

mod gadt;
mod typecheck;
pub use gadt::*;
pub use typecheck::{TypeCheckError, TypeChecker};

pub struct TypeSystem<'input, 'lctx> {
    pub compiler_ctx: CompilerContext<'input, 'lctx>,
    pub llvm_ctx: &'lctx Context,
    module: Module<'lctx>,
}

impl<'lexer, 'input, 'lctx> TypeSystem<'input, 'lctx> {
    pub fn new(compiler_ctx: CompilerContext<'input, 'lctx>, llvm_ctx: &'lctx Context) -> Self {
        Self {
            compiler_ctx,
            llvm_ctx,
            module: llvm_ctx.create_module("main"),
        }
    }
    pub fn add_type(&mut self, name: impl Into<String>, ty: Type) {
        self.compiler_ctx.types.insert(name.into(), ty);
    }
    pub fn get_type(&self, name: impl Into<String>) -> Option<&Type> {
        self.compiler_ctx.types.get(&name.into())
    }

    pub fn type_definition_pass(mut self, file: &File) -> Self {
        for item in file.items.iter() {
            match item {
                Item::TypeDecl(gadt) => {
                    //todo map llvm_type -> gadt
                    let llvm_type = gadt_to_type(gadt, self.llvm_ctx);
                    // ! this is also done in the first type_definition_pass
                    for constructor in gadt.get_tags().keys() {
                        self.compiler_ctx.add_type_constructor(constructor, gadt);
                    }
                    self.compiler_ctx.add_constructor_signatures(gadt);
                }
                _ => continue,
            }
        }

        self
    }

    pub fn function_definition_pass(
        mut self,
        lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        file: &File,
    ) -> Self {
        self.compiler_ctx.function_types.insert(
            "printf",
            FunctionProto {
                params: vec![], //todo args of printf
                return_type: Type::Int,
                span: Span::new(0, 0),
            },
        );

        for item in &file.items {
            match item {
                Item::FunctionDecl(function_decl) => {
                    let fn_name = lexer.span_str(function_decl.function_sig.name);
                    if self.compiler_ctx.function_values.contains_key(fn_name) {
                        //todo return as error
                        panic!("function {} already exists", fn_name)
                    }
                    self.compiler_ctx
                        .function_types
                        .insert(fn_name, function_decl.function_sig.proto.clone());
                }
                _ => continue,
            }
        }
        self
    }

    pub fn type_check_pass(
        self,
        lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        file: &File,
    ) -> Result<(CompilerContext<'input, 'lctx>, Module<'lctx>), Vec<TypeCheckError>> {
        match TypeChecker::new(lexer, self.compiler_ctx).check(file) {
            Ok(compiler_ctx) => Ok((compiler_ctx, self.module.clone())),
            Err(err) => Err(err),
        }
    }

    pub fn run(
        self,
        lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        file: &File,
    ) -> Result<(CompilerContext<'input, 'lctx>, Module<'lctx>), Vec<TypeCheckError>> {
        self.type_definition_pass(file)
            .function_definition_pass(lexer, file)
            .type_check_pass(lexer, file)
    }
}

#[cfg(test)]
mod tests {
    use std::collections::HashMap;

    use super::*;

    #[test]
    fn test_gadt() {
        let unit1_name = "Unit1";
        let mut unit1 = GADT::new(unit1_name.to_owned(), vec![], HashMap::new());
        unit1.add_constructor(
            unit1_name.to_owned(),
            GADTConstructorBuilder::new(unit1_name)
                .unit_fields()
                .build(),
        );
        println!("{:?}", unit1);
    }
}

pub fn constructor_to_type<'ctx>(
    constructor: &GADTConstructor,
    context: &'ctx Context,
) -> StructType<'ctx> {
    let t = context.opaque_struct_type(&constructor.llvm_name());
    match constructor.get_fields() {
        GADTConstructorFields::Unit => {
            t.set_body(&[], false);
        }
        GADTConstructorFields::Tuple(params) => {
            let f: Vec<BasicTypeEnum> = params.iter().map(ast_type_to_basic(context)).collect();
            t.set_body(&f, false);
        }
        GADTConstructorFields::Struct(params, _) => {
            let f: Vec<BasicTypeEnum> = params.iter().map(ast_type_to_basic(context)).collect();
            t.set_body(&f, false);
        }
    }
    t
}

pub fn gadt_to_type<'ctx>(gadt: &GADT, context: &'ctx Context) -> StructType<'ctx> {
    let t = context.opaque_struct_type(&gadt.name);
    for constructor in gadt.get_constructors().iter() {
        constructor_to_type(constructor, context);
    }
    let tag = context.i64_type();
    let max_constructor = gadt.get_max_constructor();
    let inner = context
        .get_struct_type(&max_constructor.llvm_name())
        .expect("type must have been created");
    t.set_body(&[tag.into(), inner.into()], false);
    t
}

pub fn ast_type_to_basic<'ctx>(context: &'ctx Context) -> impl Fn(&Type) -> BasicTypeEnum<'ctx> {
    |p| match p {
        Type::Unit => context.struct_type(&[], false).into(),
        Type::Bool => context.bool_type().into(),
        Type::Int => context.i64_type().into(),
        Type::Float => context.f64_type().into(),
        Type::String(size) => context.i8_type().array_type(*size as u32).into(),
        Type::Ident(name) => context
            .get_struct_type(name)
            .unwrap()
            .ptr_type(AddressSpace::default())
            .into(),
        _ => panic!("Not implemented"),
    }
}

pub fn size_of(ty: &Type) -> u64 {
    match ty {
        Type::Int => 64,
        Type::Float => 64,
        Type::Bool => 1,
        Type::String(size) => *size as u64 * 8,
        Type::Unit => 64,
        Type::Ident(_) => 64,
        _ => unimplemented!(),
    }
}
