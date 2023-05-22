use inkwell::{builder::Builder, context::Context, module::Module};

#[derive(Debug)]
pub struct CodeGen<'input, 'ctx> {
    pub input: &'input str,
    pub context: &'ctx Context,
    pub module: Module<'ctx>,
    pub builder: Builder<'ctx>,
}

impl<'input, 'ctx> CodeGen<'input, 'ctx> {
    pub fn new(input: &'input str, context: &'ctx Context) -> Self {
        let module = context.create_module("main");
        let builder = context.create_builder();
        Self {
            input,
            context,
            module,
            builder,
        }
    }
}
