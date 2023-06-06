use std::collections::HashMap;

use inkwell::{
    types::StructType,
    values::{BasicValueEnum, FunctionValue},
};

use crate::{
    ast::Type,
    type_system::{GADTConstructor, TypeCheckError, GADT},
};

#[allow(dead_code)]
struct Compiler;

pub struct Stack<'input, T: Copy> {
    pub frames: Vec<StackFrame<'input, T>>,
}
impl<'input, T: Copy> Stack<'input, T> {
    pub fn new() -> Self {
        Self { frames: vec![] }
    }
    pub fn push(&mut self) {
        self.frames.push(StackFrame::new());
    }
    pub fn pop(&mut self) {
        self.frames.pop();
    }
    pub fn insert(&mut self, name: &'input str, value: T) {
        self.frames
            .last_mut()
            .expect("stack must have at least one frame")
            .variables
            .insert(name, value);
    }
    pub fn get(&self, name: &'input str) -> Option<T> {
        for frame in self.frames.iter().rev() {
            if let Some(value) = frame.variables.get(name) {
                return Some(*value);
            }
        }
        None
    }
}

impl<'input, T: Copy> Default for Stack<'input, T> {
    fn default() -> Self {
        Self::new()
    }
}

pub struct StackFrame<'input, T: Copy> {
    pub variables: HashMap<&'input str, T>,
}
impl<'input, T: Copy> StackFrame<'input, T> {
    pub fn new() -> Self {
        Self {
            variables: HashMap::new(),
        }
    }
}

impl<'input, T: Copy> Default for StackFrame<'input, T> {
    fn default() -> Self {
        Self::new()
    }
}

pub enum CompileError {
    InvalidType(Box<TypeCheckError>),
    Unimplemented,
}

pub struct CompilerContext<'input, 'ctx> {
    pub type_constructors: HashMap<String, GADT>,
    pub constructor_signatures: HashMap<String, GADTConstructor>,
    pub types: HashMap<String, Type>,
    pub aliases: HashMap<String, String>,
    pub basic_value_stack: Stack<'input, BasicValueEnum<'ctx>>,
    pub function_values: HashMap<&'input str, FunctionValue<'ctx>>,
}

impl<'input, 'ctx> CompilerContext<'input, 'ctx> {
    pub fn new() -> Self {
        Self {
            type_constructors: HashMap::new(),
            types: HashMap::new(),
            aliases: HashMap::new(),
            basic_value_stack: Stack::new(),
            function_values: HashMap::new(),
            constructor_signatures: HashMap::new(),
        }
    }
    pub fn add_type_constructor(&mut self, name: &str, gadt: &GADT) {
        if self.type_constructors.contains_key(name) {
            panic!("Duplicate constructor name: {}", name);
        }
        self.type_constructors.insert(name.into(), gadt.clone());
    }

    pub fn add_constructor_signatures(
        &mut self,
        constructors: &HashMap<String, crate::type_system::GADTConstructor>,
    ) {
        for (name, cons) in constructors.iter() {
            if self.constructor_signatures.contains_key(name) {
                panic!("Duplicate constructor name: {}", name);
            }
            self.constructor_signatures
                .insert(name.to_owned(), cons.to_owned());
        }
    }
}

impl<'input, 'ctx> Default for CompilerContext<'input, 'ctx> {
    fn default() -> Self {
        Self::new()
    }
}
