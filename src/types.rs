use std::collections::HashMap;

use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};

use crate::ast::{File, Type};

#[allow(dead_code)]
#[derive(Debug, PartialEq, Clone)]
pub struct GADT {
    pub name: String,
    pub generics: Vec<String>,
    pub constructors: HashMap<String, GADTConstructor>,
}

impl GADT {
    pub fn add_constructor(&mut self, name: String, constructor: GADTConstructor) {
        self.constructors.insert(name, constructor);
    }
}

impl GADT {
    pub fn replace_shorthand(&mut self) -> Result<(), String> {
        if let Some(ref mut shorthand_constructor) = self.constructors.remove("@") {
            if self.constructors.contains_key(&self.name) {
                return Err(self.name.to_owned());
            };
            shorthand_constructor.set_name(&self.name);
            self.constructors
                .insert(self.name.clone(), shorthand_constructor.clone());
        }
        Ok(())
    }
}

#[derive(Debug, PartialEq, Clone)]
pub enum GADTConstructor {
    Unit {
        name: String,
    },
    Tuple {
        name: String,
        params: Vec<Type>,
    },
    Struct {
        name: String,
        fields: HashMap<String, Type>,
    },
}

impl GADTConstructor {
    pub fn name(&self) -> &str {
        match self {
            GADTConstructor::Unit { name } => name,
            GADTConstructor::Tuple { name, .. } => name,
            GADTConstructor::Struct { name, .. } => name,
        }
    }
    pub fn set_name(&mut self, name: &str) {
        match self {
            GADTConstructor::Unit { name: n } => *n = name.into(),
            GADTConstructor::Tuple { name: n, .. } => *n = name.into(),
            GADTConstructor::Struct { name: n, .. } => *n = name.into(),
        }
    }
}

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

struct TypeSystem {
    types: HashMap<String, Type>,
    aliases: HashMap<String, String>,
}

impl<'lexer, 'input> TypeSystem {
    pub fn new() -> Self {
        Self {
            types: HashMap::new(),
            aliases: HashMap::new(),
        }
    }
    pub fn add_type(&mut self, name: impl Into<String>, ty: Type) {
        self.types.insert(name.into(), ty);
    }
    pub fn get_type(&self, name: impl Into<String>) -> Option<&Type> {
        self.types.get(&name.into())
    }

    pub fn type_definition_pass(
        &mut self,
        _lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        _file: &File,
    ) {
        unimplemented!("type definition pass")
    }
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
}
