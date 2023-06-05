use std::collections::HashMap;

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
                    for constructor in gadt.constructors.keys() {
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
                            if let Some(expr) = &var_decl.value {
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
    use super::*;

    #[test]
    fn test_gadt() {
        let unit1_name = "Unit1";
        let mut unit1 = GADT {
            name: unit1_name.to_owned(),
            generics: vec![],
            constructors: HashMap::new(),
        };
        unit1.constructors.insert(
            unit1_name.to_owned(),
            GADTConstructor::Unit {
                name: unit1_name.to_owned(),
            },
        );
        println!("{:?}", unit1);
    }

    #[test]
    fn test_llvm_type_generation() {
        let mut unit_type = GADT {
            name: "Unit".to_owned(),
            generics: vec![],
            constructors: HashMap::new(),
        };
        unit_type.constructors.insert(
            "Unit".to_owned(),
            GADTConstructor::Unit {
                name: "Unit".to_owned(),
            },
        );

        for (name, constructor) in unit_type.constructors.iter() {
            match constructor {
                GADTConstructor::Unit { name: _ } => {
                    println!("{}: %struct.{}", name, name);
                }
                _ => continue,
            }
        }
    }
}
