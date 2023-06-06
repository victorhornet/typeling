use std::{collections::HashMap, hash::Hash};

use crate::ast::Type;

use super::size_of;

#[derive(Debug, PartialEq, Clone)]
pub struct GADT {
    pub name: String,
    pub generics: Vec<String>,
    pub constructors: HashMap<String, GADTConstructor>,
}

impl GADT {
    pub fn new(
        name: String,
        generics: Vec<String>,
        constructors: HashMap<String, GADTConstructor>,
    ) -> Self {
        Self {
            name,
            generics,
            constructors,
        }
    }
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
    pub fn generics(mut self, names: Vec<String>) -> Self {
        self.gadt.generics.extend(names);
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
    pub fn new(name: &str, fields: GADTConstructorFields) -> Self {
        Self {
            name: name.to_owned(),
            fields,
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
            constructor: GADTConstructor::new(name, GADTConstructorFields::Unit),
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
        self.constructor.fields = GADTConstructorFields::from(fields);
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
    Struct(Vec<Type>, HashMap<String, usize>),
}

impl From<HashMap<String, Type>> for GADTConstructorFields {
    fn from(fields: HashMap<String, Type>) -> Self {
        let params = fields.values().cloned().collect();
        let fields = fields
            .into_iter()
            .enumerate()
            .map(|(i, (name, _))| (name, i))
            .collect();
        Self::Struct(params, fields)
    }
}

impl From<&[(&str, Type)]> for GADTConstructorFields {
    fn from(fields: &[(&str, Type)]) -> Self {
        let params = fields.iter().map(|(_, t)| t.clone()).collect();
        let fields = fields
            .iter()
            .enumerate()
            .map(|(i, (name, _))| (name.to_string(), i))
            .collect();
        Self::Struct(params, fields)
    }
}

impl From<Vec<Type>> for GADTConstructorFields {
    fn from(params: Vec<Type>) -> Self {
        Self::Tuple(params)
    }
}

impl GADTConstructorFields {
    pub fn get_size(&self) -> u64 {
        match self {
            GADTConstructorFields::Unit => 0,
            GADTConstructorFields::Tuple(params) => params.iter().map(size_of).sum::<u64>(),
            GADTConstructorFields::Struct(params, _fields) => {
                params.iter().map(size_of).sum::<u64>()
            }
        }
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_gadt_constructor_builder() {
        use super::*;
        let constructor = GADTConstructorBuilder::new("A").unit_fields().build();
        assert_eq!(
            constructor,
            GADTConstructor {
                name: "A".to_owned(),
                fields: GADTConstructorFields::Unit,
                size: 64,
            }
        );
        let constructor = GADTConstructorBuilder::new("A")
            .tuple_fields(&[Type::Int, Type::Float])
            .build();
        assert_eq!(
            constructor,
            GADTConstructor {
                name: "A".to_owned(),
                fields: GADTConstructorFields::Tuple(vec![Type::Int, Type::Float]),
                size: 64 * 3,
            }
        );
        let constructor = GADTConstructorBuilder::new("A")
            .struct_fields(&[("a", Type::Int), ("b", Type::Float)])
            .build();
        assert_eq!(
            constructor,
            GADTConstructor {
                name: "A".to_owned(),
                fields: GADTConstructorFields::Struct(
                    vec![Type::Int, Type::Float],
                    vec![("a".to_owned(), 0usize), ("b".to_owned(), 1usize)]
                        .iter()
                        .map(|a| a.to_owned())
                        .collect()
                ),
                size: 64 * 3,
            }
        );
    }

    #[test]
    fn test_gadt_builder() {
        use super::*;
        let gadt = GADTBuilder::new("A")
            .generic("a")
            .generic("b")
            .unit_constructor("A")
            .tuple_constructor("B", &[Type::Int, Type::Float])
            .struct_constructor("C", &[("a", Type::Int), ("b", Type::Float)])
            .build();
        assert_eq!(
            gadt,
            GADT {
                name: "A".to_owned(),
                generics: vec!["a".to_owned(), "b".to_owned()],
                constructors: vec![
                    (
                        "A".to_owned(),
                        GADTConstructor {
                            name: "A".to_owned(),
                            fields: GADTConstructorFields::Unit,
                            size: 64,
                        }
                    ),
                    (
                        "B".to_owned(),
                        GADTConstructor {
                            name: "B".to_owned(),
                            fields: GADTConstructorFields::Tuple(vec![Type::Int, Type::Float]),
                            size: 64 * 3,
                        }
                    ),
                    (
                        "C".to_owned(),
                        GADTConstructor {
                            name: "C".to_owned(),
                            fields: GADTConstructorFields::Struct(
                                vec![Type::Int, Type::Float],
                                vec![("a".to_owned(), 0usize), ("b".to_owned(), 1usize)]
                                    .into_iter()
                                    .collect::<HashMap<String, usize>>()
                            ),
                            size: 64 * 3,
                        }
                    ),
                ]
                .into_iter()
                .collect::<HashMap<String, GADTConstructor>>(),
            }
        );
    }
}
