use inkwell::{
    builder::Builder, context::Context, execution_engine::JitFunction, module::Module,
    values::AnyValue, OptimizationLevel,
};
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;

use crate::ast::{File, Item};

use super::Visitor;

pub struct CodeGen<'input, 'lexer, 'ctx> {
    pub lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
    pub context: &'ctx Context,
    pub module: Module<'ctx>,
    pub builder: Builder<'ctx>,
}

impl<'input, 'lexer, 'ctx> CodeGen<'input, 'lexer, 'ctx> {
    pub fn new(
        lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        context: &'ctx Context,
    ) -> Self {
        let module = context.create_module("main");
        let builder = context.create_builder();
        Self {
            lexer,
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

        self.walk_file(file);

        let i32_type = self.context.i32_type();
        let fn_type = i32_type.fn_type(&[], false);

        let function = self.module.add_function("add", fn_type, None);
        let basic_block = self.context.append_basic_block(function, "entry");

        self.builder.position_at_end(basic_block);
        let return_value = i32_type.const_int(42, false);
        self.builder.build_return(Some(&return_value));
        println!(
            "Generated LLVM IR: {}",
            self.module.print_to_string().to_string()
        );

        unsafe {
            type Addition = unsafe extern "C" fn() -> i32;
            let jit_function: JitFunction<Addition> = execution_engine.get_function("add").unwrap();

            let x = jit_function.call();
            println!("Result: {}", x);
        }
    }
}

#[allow(unused_variables)]
impl<'input, 'lexer, 'ctx> Visitor<Option<()>> for CodeGen<'input, 'lexer, 'ctx> {
    fn visit_file(&mut self, file: &File) -> Option<()> {
        self.walk_file(file);
        None
    }
    fn visit_item(&mut self, item: &Item) -> Option<()> {
        match item {
            Item::FunctionDecl(function_decl) => self.visit_function_decl(function_decl),
            Item::TypeDecl(type_decl) => self.visit_type_decl(type_decl),
        };
        None
    }
    fn visit_function_decl(&mut self, function_decl: &crate::ast::FunctionDecl) -> Option<()> {
        let fn_type = self.context.i32_type().fn_type(&[], false);
        let fn_name = self.lexer.span_str(function_decl.function_sig.name);
        let fn_value = self.module.add_function(fn_name, fn_type, None);
        let basic_block = self.context.append_basic_block(fn_value, "entry");
        self.builder.position_at_end(basic_block);
        let value = self.context.i32_type().const_int(10, false);
        self.builder.build_return(Some(&value));
        println!("fn_name: {}", fn_name);
        None
    }
    fn visit_function_sig(&mut self, function_sig: &crate::ast::FunctionSig) -> Option<()> {
        unimplemented!();
    }
    fn visit_param(&mut self, param: &crate::ast::Param) -> Option<()> {
        unimplemented!();
    }
    fn visit_type(&mut self, type_: &crate::ast::Type) -> Option<()> {
        unimplemented!();
    }
    fn visit_type_decl(&mut self, type_decl: &crate::ast::TypeDecl) -> Option<()> {
        let type_name = self.lexer.span_str(type_decl.name);

        println!("type_name: {}", type_name);
        None
    }
    fn visit_type_def(&mut self, type_def: &crate::ast::TypeDef) -> Option<()> {
        unimplemented!();
    }
    fn visit_struct_field(&mut self, struct_field: &crate::ast::StructField) -> Option<()> {
        unimplemented!();
    }
    fn visit_enum_variant(&mut self, enum_variant: &crate::ast::EnumVariant) -> Option<()> {
        unimplemented!();
    }
    fn visit_alias(&mut self, alias: &crate::ast::Alias) -> Option<()> {
        unimplemented!();
    }
    fn visit_block(&mut self, block: &crate::ast::Block) -> Option<()> {
        unimplemented!();
    }
    fn visit_statement(&mut self, statement: &crate::ast::Statement) -> Option<()> {
        unimplemented!();
    }
    fn visit_print(&mut self, print: &crate::ast::Print) -> Option<()> {
        unimplemented!();
    }
    fn visit_return(&mut self, return_: &crate::ast::Return) -> Option<()> {
        unimplemented!();
    }
    fn visit_if(&mut self, if_: &crate::ast::If) -> Option<()> {
        unimplemented!();
    }
    fn visit_while(&mut self, while_: &crate::ast::While) -> Option<()> {
        unimplemented!();
    }
    fn visit_var_decl(&mut self, var_decl: &crate::ast::VarDecl) -> Option<()> {
        unimplemented!();
    }
    fn visit_assign(&mut self, assign: &crate::ast::Assign) -> Option<()> {
        unimplemented!();
    }
    fn visit_function_call(&mut self, function_call: &crate::ast::FunctionCall) -> Option<()> {
        unimplemented!();
    }
    fn visit_expr(&mut self, expression: &crate::ast::Expr) -> Option<()> {
        unimplemented!();
    }
    fn visit_bin_op(&mut self, binary_op: &crate::ast::BinOp) -> Option<()> {
        unimplemented!();
    }
    fn visit_un_op(&mut self, unary_op: &crate::ast::UnOp) -> Option<()> {
        unimplemented!();
    }
}
