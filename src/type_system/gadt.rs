use std::collections::HashMap;

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
    pub fn get_size(&self) -> u64 {
        self.get_max_constructor().get_size()
    }

    pub fn get_max_constructor(&self) -> &GADTConstructor {
        self.constructors
            .values()
            .max_by_key(|c| c.get_size())
            .unwrap()
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
    pub fn get_size(&self) -> u64 {
        match self {
            GADTConstructor::Unit { .. } => 64,
            GADTConstructor::Tuple { params, .. } => {
                64 + params.iter().map(Self::size_of).sum::<u64>()
            }
            GADTConstructor::Struct { fields, .. } => {
                64 + fields.values().map(Self::size_of).sum::<u64>()
            }
        }
    }
    fn size_of(ty: &Type) -> u64 {
        match ty {
            Type::Int => 64,
            Type::Float => 64,
            Type::Bool => 1,
            Type::String(size) => *size as u64 * 8,
            Type::Unit => 64,
            Type::Ident(_) => 64,
            Type::GADT(gadt) => gadt.get_size(),
        }
    }
}
