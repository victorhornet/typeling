use crate::ast::*;
pub trait Visitor<T> {
    fn visit_file(&mut self, file: &File) -> T;
    fn visit_item(&mut self, item: &Item) -> T;
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> T;
    fn visit_function_sig(&mut self, function_sig: &FunctionSig) -> T;
    fn visit_param(&mut self, param: &Param) -> T;
    fn visit_type(&mut self, type_: &Type) -> T;
    fn visit_type_decl(&mut self, type_decl: &TypeDecl) -> T;
    fn visit_type_def(&mut self, type_def: &TypeDef) -> T;
    fn visit_struct_field(&mut self, struct_field: &StructField) -> T;
    fn visit_enum_variant(&mut self, enum_variant: &EnumVariant) -> T;
    fn visit_alias(&mut self, alias: &Alias) -> T;
    fn visit_block(&mut self, block: &Block) -> T;
    fn visit_statement(&mut self, statement: &Statement) -> T;
    fn visit_print(&mut self, print: &Print) -> T;
    fn visit_return(&mut self, return_: &Return) -> T;
    fn visit_if(&mut self, if_: &If) -> T;
    fn visit_while(&mut self, while_: &While) -> T;
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> T;
    fn visit_assign(&mut self, assign: &Assign) -> T;
    fn visit_function_call(&mut self, function_call: &FunctionCall) -> T;
    fn visit_expr(&mut self, expr: &Expr) -> T;
    fn visit_bin_op(&mut self, binary_op: &BinOp) -> T;
    fn visit_un_op(&mut self, unary_op: &UnOp) -> T;
}

pub struct SpanPrinter {
    pub input: String,
}

impl SpanPrinter {
    pub fn new(input: &str) -> Self {
        Self {
            input: input.to_string(),
        }
    }
    pub fn print(&mut self, file: &File) {
        self.visit_file(file)
    }
}

impl Visitor<()> for SpanPrinter {
    fn visit_file(&mut self, file: &File) {
        for item in &file.items {
            self.visit_item(item);
        }
    }
    fn visit_item(&mut self, item: &Item) {
        match item {
            Item::FunctionDecl(function_decl) => self.visit_function_decl(function_decl),
            Item::TypeDecl(type_decl) => self.visit_type_decl(type_decl),
        }
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) {
        self.visit_function_sig(&function_decl.function_sig);
        self.visit_block(&function_decl.body);
    }
    fn visit_function_sig(&mut self, function_sig: &FunctionSig) {
        let ident = slice(&self.input, &function_sig.name);
        println!("Function signature: {}", ident);
        for param in &function_sig.params {
            self.visit_param(param);
        }
        self.visit_type(&function_sig.return_type);
    }
    fn visit_param(&mut self, param: &Param) {
        let ident = slice(&self.input, &param.name);
        println!("Param: {}", ident);
        self.visit_type(&param.param_type);
    }
    fn visit_type(&mut self, type_: &Type) {
        match type_ {
            Type::Unit => println!("Type: unit"),
            Type::Int => println!("Type: int"),
            Type::Float => println!("Type: float"),
            Type::Bool => println!("Type: bool"),
            Type::String => println!("Type: string"),
            Type::Array(element_type) => {
                println!("Type: array");
                self.visit_type(&element_type);
            }
            Type::Function(function_sig) => {
                println!("Type: function");
                self.visit_function_sig(&function_sig);
            }
            Type::Ident(ident) => {
                let ident = slice(&self.input, ident);
                println!("Type: {}", ident);
            }
        }
    }
    fn visit_type_decl(&mut self, type_decl: &TypeDecl) {
        let ident = slice(&self.input, &type_decl.name);
        println!("Type declaration: {}", ident);
        self.visit_type_def(&type_decl.def);
    }
    fn visit_type_def(&mut self, type_def: &TypeDef) {
        match type_def {
            TypeDef::Unit => println!("Type definition: unit"),
            TypeDef::Tuple(tuple_fields) => {
                println!("Type definition: tuple");
                for tuple_field in tuple_fields {
                    self.visit_type(&tuple_field);
                }
            }
            TypeDef::Struct(struct_fields) => {
                println!("Type definition: struct");
                for struct_field in struct_fields {
                    self.visit_struct_field(struct_field);
                }
            }
            TypeDef::Enum(enum_variants) => {
                println!("Type definition: enum");
                for enum_variant in enum_variants {
                    self.visit_enum_variant(enum_variant);
                }
            }
        }
    }
    fn visit_struct_field(&mut self, struct_field: &StructField) {
        let ident = slice(&self.input, &struct_field.key);
        println!("Struct field: {}", ident);
        self.visit_type(&struct_field.ty);
    }
    fn visit_enum_variant(&mut self, enum_variant: &EnumVariant) {
        let ident = slice(&self.input, &enum_variant.tag);
        println!("Enum variant: {}", ident);
        self.visit_type_def(&enum_variant.ty);
    }
    fn visit_alias(&mut self, alias: &Alias) {
        let ident = slice(&self.input, &alias.name);
        println!("Alias: {}", ident);
        self.visit_type(&alias.original);
    }
    fn visit_block(&mut self, block: &Block) {
        println!("Block");
        for statement in &block.statements {
            self.visit_statement(statement);
        }
    }
    fn visit_statement(&mut self, statement: &Statement) {
        match statement {
            Statement::Print(print) => self.visit_print(print),
            Statement::Return(return_) => self.visit_return(return_),
            Statement::If(if_) => self.visit_if(if_),
            Statement::While(while_) => self.visit_while(while_),
            Statement::VarDecl(var_decl) => self.visit_var_decl(var_decl),
            Statement::Assign(assign) => self.visit_assign(assign),
            Statement::FunctionCall(function_call) => self.visit_function_call(function_call),
            Statement::Block(block) => self.visit_block(block),
            Statement::Expr(expr) => self.visit_expr(expr),
        }
    }
    fn visit_print(&mut self, print: &Print) {
        println!("Print");
        self.visit_expr(&print.value);
    }

    fn visit_return(&mut self, return_: &Return) {
        println!("Return");
        if let Some(value) = &return_.value {
            self.visit_expr(value);
        }
    }

    fn visit_if(&mut self, if_: &If) {
        println!("If");
        self.visit_expr(&if_.condition);
        self.visit_block(&if_.then_block);
        if let Some(else_) = &if_.else_block {
            self.visit_block(else_);
        }
    }

    fn visit_while(&mut self, while_: &While) {
        println!("While");
        self.visit_expr(&while_.condition);
        self.visit_block(&while_.body);
    }

    fn visit_var_decl(&mut self, var_decl: &VarDecl) {
        let ident = slice(&self.input, &var_decl.name);
        println!("Var decl: {}", ident);
        self.visit_type(&var_decl.var_type);
        if let Some(value) = &var_decl.value {
            self.visit_expr(value);
        }
    }

    fn visit_assign(&mut self, assign: &Assign) {
        let ident = slice(&self.input, &assign.name);
        println!("Assign: {}", ident);
        self.visit_expr(&assign.value);
    }

    fn visit_function_call(&mut self, function_call: &FunctionCall) {
        let ident = slice(&self.input, &function_call.name);
        println!("Function call: {}", ident);
        for arg in &function_call.args {
            self.visit_expr(arg);
        }
    }
    fn visit_expr(&mut self, _expr: &Expr) {}
    fn visit_bin_op(&mut self, _binary_op: &BinOp) {}
    fn visit_un_op(&mut self, _unary_op: &UnOp) {}
}
