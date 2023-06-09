use inkwell::{
    context::Context,
    types::{BasicTypeEnum, StructType},
    AddressSpace,
};
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};

use crate::{ast::*, compiler::CompilerContext};

mod gadt;
mod typecheck;
pub use gadt::*;
pub use typecheck::{TypeCheckError, TypeChecker};

#[derive(PartialEq, Debug)]
pub enum IntType {
    // I8,
    // I16,
    // I32,
    I64,
    // I128,
}
#[derive(PartialEq, Debug)]
pub enum FloatType {
    // F32,
    F64,
}
#[derive(PartialEq, Debug)]
pub struct FunctionProto {
    pub params: Vec<Type>,
    pub return_type: Type,
}

pub struct TypeSystem<'input, 'ctx, 'a> {
    pub ctx: &'a mut CompilerContext<'input, 'ctx>,
}

impl<'lexer, 'input, 'ctx, 'a> TypeSystem<'input, 'ctx, 'a> {
    pub fn new(ctx: &'a mut CompilerContext<'input, 'ctx>) -> Self {
        Self { ctx }
    }
    pub fn add_type(&mut self, name: impl Into<String>, ty: Type) {
        self.ctx.types.insert(name.into(), ty);
    }
    pub fn get_type(&self, name: impl Into<String>) -> Option<&Type> {
        self.ctx.types.get(&name.into())
    }

    pub fn type_definition_pass(
        &mut self,
        _lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        file: &File,
    ) -> &mut Self {
        for item in file.items.iter() {
            match item {
                Item::TypeDecl(gadt) => {
                    for constructor in gadt.get_tags().keys() {
                        self.ctx.add_type_constructor(constructor, gadt);
                    }
                }
                _ => continue,
            }
        }
        self
    }
    pub fn type_check_pass(
        &mut self,
        lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        file: &File,
    ) -> &mut Self {
        let mut typechecker = TypeChecker::new(lexer);
        typechecker.check(file).expect("Type checking failed");
        self
    }
}

pub fn infer_types(file: &mut File) -> Result<(), Vec<()>> {
    for item in file.items.iter_mut() {
        match item {
            Item::FunctionDecl(f) => {
                for statement in &mut f.body.statements {
                    match statement {
                        Statement::VarDecl(var_decl) => {
                            if let Some(_expr) = &var_decl.value {
                                let ty = Type::Unit;
                                var_decl.var_type = Some(ty.clone());
                            }
                        }
                        _ => continue,
                    }
                }
            }
            _ => continue,
        }
    }
    Err(vec![])
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
            GADTConstructorBuilder::new(&unit1_name)
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
        GADTConstructorFields::Struct(params, fields) => {
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
