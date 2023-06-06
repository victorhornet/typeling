use std::collections::HashMap;

use crate::ast::Type;

use super::size_of;

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

pub struct GADTBuilder {
    gadt: GADT,
}

impl GADTBuilder {
    pub fn new(name: &str) -> Self {
        Self {
            gadt: GADT {
                name: name.to_owned(),
                generics: vec![],
                constructors: HashMap::new(),
            },
        }
    }
    pub fn generic(mut self, name: &str) -> Self {
        self.gadt.generics.push(name.to_owned());
        self
    }
    pub fn unit_constructor(mut self, name: &str) -> Self {
        self.gadt.add_constructor(
            name.to_owned(),
            GADTConstructorBuilder::new(name).unit_fields().build(),
        );
        self
    }
    pub fn tuple_constructor(mut self, name: &str, params: &[Type]) -> Self {
        self.gadt.add_constructor(
            name.to_owned(),
            GADTConstructorBuilder::new(name)
                .tuple_fields(params)
                .build(),
        );
        self
    }
    pub fn struct_constructor(mut self, name: &str, fields: &[(&str, Type)]) -> Self {
        self.gadt.add_constructor(
            name.to_owned(),
            GADTConstructorBuilder::new(name)
                .struct_fields(fields)
                .build(),
        );
        self
    }
    pub fn build(mut self) -> GADT {
        self.gadt.replace_shorthand().unwrap();
        self.gadt
    }
}

#[derive(Debug, PartialEq, Clone)]
pub struct GADTConstructor {
    name: String,
    fields: GADTConstructorFields,
    size: u64,
}

impl GADTConstructor {
    pub fn new(name: &str) -> Self {
        Self {
            name: name.to_owned(),
            fields: GADTConstructorFields::Unit,
            size: 0,
        }
    }
    pub fn llvm_name(&self) -> String {
        "constructor_".to_string() + self.name.as_str()
    }
    pub fn get_name(&self) -> &str {
        &self.name
    }
    pub fn set_name(&mut self, name: &str) {
        self.name = name.to_owned();
    }
    pub fn get_size(&self) -> u64 {
        self.size
    }
    fn compute_size(&mut self) {
        self.size = self.fields.get_size() + 64;
    }
    pub fn get_fields(&self) -> &GADTConstructorFields {
        &self.fields
    }
}

pub struct GADTConstructorBuilder {
    constructor: GADTConstructor,
}

impl GADTConstructorBuilder {
    pub fn new(name: &str) -> Self {
        Self {
            constructor: GADTConstructor::new(name),
        }
    }
    pub fn unit_fields(mut self) -> Self {
        self.constructor.fields = GADTConstructorFields::Unit;
        self
    }
    pub fn tuple_fields(mut self, params: &[Type]) -> Self {
        self.constructor.fields = GADTConstructorFields::Tuple(params.to_owned());
        self
    }
    pub fn struct_fields(mut self, fields: &[(&str, Type)]) -> Self {
        let fields = fields
            .to_owned()
            .into_iter()
            .map(|(name, ty)| (name.into(), ty))
            .collect::<HashMap<String, Type>>();
        self.constructor.fields = GADTConstructorFields::Struct(fields);
        self
    }
    pub fn build(mut self) -> GADTConstructor {
        self.constructor.compute_size();
        self.constructor
    }
}

#[derive(Debug, PartialEq, Clone)]
pub enum GADTConstructorFields {
    Unit,
    Tuple(Vec<Type>),
    Struct(HashMap<String, Type>),
}

impl GADTConstructorFields {
    pub fn get_size(&self) -> u64 {
        match self {
            GADTConstructorFields::Unit => 0,
            GADTConstructorFields::Tuple(params) => params.iter().map(size_of).sum::<u64>(),
            GADTConstructorFields::Struct(fields) => fields.values().map(size_of).sum::<u64>(),
        }
    }
}
