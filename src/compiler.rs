use std::collections::HashMap;

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
