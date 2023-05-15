use super::ast::{Expr, File, Function, FunctionCall, FunctionDecl, Ident, Item, Literal};
use inkwell::{
    builder::{self, Builder},
    context::{self, Context},
    module::Module,
    types::{BasicMetadataTypeEnum, FloatType},
};
pub trait Visitor {
    fn visit_file(&self, file: &File);
    fn visit_item(&self, item: &Item);
    fn visit_function_decl(&self, function_decl: &FunctionDecl);
    fn visit_function(&self, function: &Function);
    fn visit_expr(&self, expr: &Expr);
    fn visit_ident(&self, ident: &Ident);
    fn visit_literal(&self, literal: &Literal);
    fn visit_function_call(&self, function_call: &FunctionCall);
}

pub trait Codegen {
    fn codegen(&self, context: &Context, builder: &Builder, module: &Module);
}

#[derive(Debug)]
pub struct LLVMCodeGen<'ctx> {
    context: &'ctx Context,
    builder: Builder<'ctx>,
    module: Module<'ctx>,
}

impl<'ctx> LLVMCodeGen<'ctx> {
    pub fn new(context: &'ctx Context) -> Self {
        Self {
            context,
            builder: context.create_builder(),
            module: context.create_module("kaleidoscope"),
        }
    }
}
impl<'ctx> Visitor for LLVMCodeGen<'ctx> {
    fn visit_file(&self, file: &File) {
        println!("visit_file:\n\t{:?}", file);
        file.items.iter().for_each(|item| self.visit_item(item));
        println!("exit visit_file")
    }

    fn visit_item(&self, item: &Item) {
        println!("visit_item:\n\t{:?}", item);
        match item {
            Item::Extern(function_decl) => self.visit_function_decl(function_decl),
            Item::Function(function) => self.visit_function(function),
        }
        println!("exit visit_item")
    }

    fn visit_function_decl(&self, function_decl: &FunctionDecl) {
        println!("visit_function_decl:\n\t{:?}", function_decl);

        self.visit_ident(&function_decl.ident);
        let name = function_decl.ident.name.as_str();
        let f64_type = self.context.f64_type();

        let param_types: Vec<BasicMetadataTypeEnum> = function_decl
            .args
            .iter()
            .map(|_| BasicMetadataTypeEnum::FloatType(f64_type))
            .collect();
        let ty = f64_type.fn_type(&param_types, false);
        self.module.add_function(name, ty, None);

        println!("exit visit_function_decl")
    }

    fn visit_function(&self, function: &Function) {
        println!("visit_function:\n\t{:?}", function);
        self.visit_function_decl(&function.decl);
        self.visit_expr(&function.body);
        println!("exit visit_function")
    }

    fn visit_expr(&self, expr: &Expr) {
        println!("visit_expr:\n\t{:?}", expr);
        match expr {
            Expr::Ident(ident) => self.visit_ident(ident),
            Expr::Literal(literal) => self.visit_literal(literal),
            Expr::FunctionCall(function_call) => self.visit_function_call(function_call),
        }
        println!("exit visit_expr")
    }

    fn visit_ident(&self, ident: &Ident) {
        println!("visit_ident:\n\t{:?}", ident);
    }

    fn visit_literal(&self, literal: &Literal) {
        println!("visit_literal:\n\t{:?}", literal);
    }

    fn visit_function_call(&self, function_call: &FunctionCall) {
        println!("visit_function_call:\n\t{:?}", function_call);
        self.visit_ident(&function_call.ident);
        function_call
            .args
            .iter()
            .for_each(|arg| self.visit_expr(arg));
        println!("exit visit_function_call")
    }
}
