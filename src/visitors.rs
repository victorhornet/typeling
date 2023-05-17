use crate::ast::*;
pub trait Visitor<T> {
    fn visit_file(&mut self, file: &File) -> T;
    fn visit_item(&mut self, item: &Item) -> T;
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> T;
    fn visit_function_sig(&mut self, function_sig: &FunctionSig) -> T;
    fn visit_param(&mut self, param: &Param) -> T;
    fn visit_type(&mut self, type_: &Type) -> T;
    fn visit_block(&mut self, block: &Block) -> T;
    fn visit_statement(&mut self, statement: &Statement) -> T;
    fn visit_expr(&mut self, expr: &Expr) -> T;
    fn visit_if(&mut self, if_: &If) -> T;
    fn visit_while(&mut self, while_: &While) -> T;
    fn visit_bin_op(&mut self, bin_op: &BinOp) -> T;
    fn visit_un_op(&mut self, un_op: &UnOp) -> T;
    fn visit_struct_decl(&mut self, struct_: &StructDecl) -> T;
    fn visit_enum_decl(&mut self, enum_: &EnumDecl) -> T;
    fn visit_assign(&mut self, assign: &Assign) -> T;
    fn visit_return(&mut self, return_: &Return) -> T;
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> T;
    fn visit_print(&mut self, print: &Print) -> T;
    fn visit_function_call(&mut self, function_call: &FunctionCall) -> T;
}

pub struct AstPrinter;

impl Visitor<()> for AstPrinter {
    fn visit_file(&mut self, file: &File) {
        for item in &file.items {
            self.visit_item(item);
        }
    }
    fn visit_item(&mut self, item: &Item) {
        match item {
            Item::FunctionDecl(function_decl) => self.visit_function_decl(function_decl),
            _ => unimplemented!(),
        }
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) {
        self.visit_function_sig(&function_decl.function_sig);
        self.visit_block(&function_decl.body);
    }
    fn visit_function_sig(&mut self, function_sig: &FunctionSig) {
        self.visit_type(&function_sig.return_type);
        for param in &function_sig.params {
            self.visit_param(param);
        }
    }
    fn visit_param(&mut self, param: &Param) {
        self.visit_type(&param.param_type);
    }
    fn visit_type(&mut self, type_: &Type) {
        match type_ {
            Type::Unit => println!("unit"),
            Type::Int => println!("int"),
            Type::Float => println!("float"),
            Type::Bool => println!("bool"),
            Type::String => println!("string"),
            Type::Ident(ident) => println!("{}", ident),
            Type::Array(type_) => {
                print!("array of ");
                self.visit_type(type_);
            }
            Type::Function(function_sig) => {
                print!("function returning ");
                self.visit_function_sig(function_sig);
            }
        }
    }
    fn visit_block(&mut self, block: &Block) {
        for statement in &block.statements {
            self.visit_statement(statement);
        }
    }
    fn visit_statement(&mut self, statement: &Statement) {
        match statement {
            Statement::Expr(expr) => self.visit_expr(expr),
            Statement::Block(block) => self.visit_block(block),
            Statement::If(if_) => self.visit_if(if_),
            Statement::While(while_) => self.visit_while(while_),
            Statement::VarDecl(var_decl) => self.visit_var_decl(var_decl),
            Statement::Assign(assign) => self.visit_assign(assign),
            Statement::FunctionCall(function_call) => self.visit_function_call(function_call),
            Statement::Print(print) => self.visit_print(print),
            Statement::Return(return_) => self.visit_return(return_),
        }
    }
    fn visit_expr(&mut self, expr: &Expr) {
        match expr {
            Expr::Int(int) => println!("{}", int),
            Expr::Float(float) => println!("{}", float),
            Expr::Bool(bool_) => println!("{}", bool_),
            Expr::String(string) => println!("{}", string),
            Expr::BinOp(lhs, op, rhs) => self.visit_bin_op(op),
            Expr::UnOp(op, expr) => self.visit_un_op(op),
            Expr::FunctionCall(function_call) => self.visit_function_call(function_call),
            Expr::Array(_) => {
                println!("array");
            }
            Expr::Struct(_, _) => {
                println!("struct");
            }
            Expr::Enum(_, _) => {
                println!("enum");
            }
            Expr::Function(_) => {
                println!("function");
            }
            Expr::Var(_) => {
                println!("var");
            }
        }
    }
    fn visit_if(&mut self, if_: &If) {}
    fn visit_while(&mut self, while_: &While) {}
    fn visit_bin_op(&mut self, bin_op: &BinOp) {}
    fn visit_un_op(&mut self, un_op: &UnOp) {}
    fn visit_struct_decl(&mut self, struct_: &StructDecl) {}
    fn visit_enum_decl(&mut self, enum_: &EnumDecl) {}
    fn visit_assign(&mut self, assign: &Assign) {}
    fn visit_return(&mut self, return_: &Return) {}
    fn visit_var_decl(&mut self, var_decl: &VarDecl) {}
    fn visit_function_call(&mut self, function_call: &FunctionCall) {}
    fn visit_print(&mut self, print: &Print) {}
}
