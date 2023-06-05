use std::collections::HashMap;

use inkwell::{context::Context, AddressSpace};

use crate::ast::Type;

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
