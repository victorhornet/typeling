use std::collections::HashMap;

#[allow(dead_code)]
#[derive(PartialEq, Debug)]
pub enum Type {
    Unit(String),
    Int(IntType),
    Float(FloatType),
    Bool,
    String,
    Function(Box<FunctionProto>),
    Tuple(Tuple),
    Struct(Struct),
    Enum(Enum),
}
#[derive(PartialEq, Debug)]
pub enum IntType {
    I8,
    I16,
    I32,
    I64,
    I128,
}
#[derive(PartialEq, Debug)]
pub enum FloatType {
    F32,
    F64,
}
#[derive(PartialEq, Debug)]
pub struct FunctionProto {
    pub params: Vec<Type>,
    pub return_type: Type,
}

#[derive(PartialEq, Debug)]
pub struct Tuple {
    elements: Vec<Type>,
}

impl Tuple {
    pub fn new() -> Self {
        Self { elements: vec![] }
    }
}
impl Default for Tuple {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(PartialEq, Debug)]
pub struct Struct {
    fields: HashMap<String, Type>,
}
impl Struct {
    pub fn new() -> Self {
        Self {
            fields: HashMap::new(),
        }
    }
}
impl Default for Struct {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(PartialEq, Debug)]
pub struct Enum {
    variants: HashMap<String, EnumVariant>,
}
impl Enum {
    pub fn new() -> Self {
        Self {
            variants: HashMap::new(),
        }
    }
}
impl Default for Enum {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(PartialEq, Debug)]
pub enum EnumVariant {
    Unit,
    Tuple(Tuple),
    Struct(Struct),
}

impl Type {
    pub fn new_tuple() -> Self {
        Self::Tuple(Tuple { elements: vec![] })
    }
    pub fn new_struct() -> Self {
        Self::Struct(Struct {
            fields: HashMap::new(),
        })
    }
    pub fn new_enum() -> Self {
        Self::Enum(Enum {
            variants: HashMap::new(),
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_adt() {
        let mut struct_type = Struct::new();
        struct_type
            .fields
            .insert("x".to_string(), Type::Int(IntType::I64));
        struct_type
            .fields
            .insert("y".to_string(), Type::Int(IntType::I64));
        let x = Type::Struct(struct_type);
        let y = Type::Struct(Struct {
            fields: vec![
                ("x".to_string(), Type::Int(IntType::I64)),
                ("y".to_string(), Type::Int(IntType::I64)),
            ]
            .into_iter()
            .collect(),
        });
        assert_eq!(x, y);
    }

    #[test]
    fn test_type_map() {
        let mut type_map = HashMap::new();
        type_map.insert("i64".to_string(), Type::Int(IntType::I64));
        type_map.insert("i32".to_string(), Type::Int(IntType::I32));
        let mut struct_type = Struct::new();
        struct_type
            .fields
            .insert("x".to_string(), Type::Int(IntType::I64));
        struct_type
            .fields
            .insert("y".to_string(), Type::Int(IntType::I64));
        type_map.insert("StructType".into(), Type::Struct(struct_type));

        let mut enum_type = Enum::new();
        enum_type
            .variants
            .insert("Unit".to_string(), EnumVariant::Unit);
        enum_type.variants.insert(
            "Tuple".to_string(),
            EnumVariant::Tuple(Tuple {
                elements: vec![Type::Int(IntType::I64), Type::Int(IntType::I64)],
            }),
        );
        type_map.insert("UnitType".into(), Type::Enum(enum_type));
        println!("{:?}", type_map);
    }
}
