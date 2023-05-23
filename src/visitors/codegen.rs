use inkwell::{
    builder::Builder, context::Context, execution_engine::JitFunction, module::Module,
    values::AnyValue, OptimizationLevel,
};

use crate::ast::File;

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
    pub fn compile(&mut self, file: &File) {
        let execution_engine = self
            .module
            .create_jit_execution_engine(OptimizationLevel::None)
            .unwrap();

        let i32_type = self.context.i32_type();
        let fn_type = i32_type.fn_type(&[], false);

        let function = self.module.add_function("add", fn_type, None);
        let basic_block = self.context.append_basic_block(function, "entry");

        self.builder.position_at_end(basic_block);
        let return_value = i32_type.const_int(42, false);
        self.builder.build_return(Some(&return_value));
        println!(
            "Generated LLVM IR: {}",
            function.print_to_string().to_string()
        );

        unsafe {
            type Addition = unsafe extern "C" fn() -> i32;
            let jit_function: JitFunction<Addition> = execution_engine.get_function("add").unwrap();

            let x = jit_function.call();
            println!("Result: {}", x);
        }
    }
}
