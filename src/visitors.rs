use crate::{ast::*, type_system::GADT};

#[allow(unused_variables)]
pub trait Visitor<T> {
    fn visit_file(&mut self, file: &File) -> T {
        unimplemented!()
    }
    fn walk_file(&mut self, file: &File) -> Vec<T> {
        let mut res = Vec::new();
        for item in &file.items {
            res.push(self.visit_item(item));
        }
        res
    }
    fn visit_item(&mut self, item: &Item) -> T {
        match item {
            Item::FunctionDecl(function_decl) => self.visit_function_decl(function_decl),
            Item::TypeDecl(type_decl) => self.visit_type_decl(type_decl),
            Item::AliasDecl(alias_decl) => self.visit_alias_decl(alias_decl),
        }
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> T {
        unimplemented!()
    }
    fn visit_function_sig(&mut self, function_sig: &FunctionSig) -> T {
        unimplemented!()
    }
    fn walk_function_sig(&mut self, function_sig: &FunctionSig) -> (Vec<T>, T) {
        let mut res = Vec::new();
        for param in &function_sig.proto.params {
            res.push(self.visit_param(param));
        }
        (res, self.visit_type(&function_sig.proto.return_type))
    }
    fn visit_param(&mut self, param: &Param) -> T {
        unimplemented!()
    }
    fn visit_type(&mut self, type_: &Type) -> T {
        unimplemented!()
    }
    fn visit_type_decl(&mut self, type_decl: &GADT) -> T {
        unimplemented!()
    }
    fn visit_type_def(&mut self, type_def: &TypeDef) -> T {
        unimplemented!()
    }
    fn visit_struct_field(&mut self, struct_field: &StructField) -> T {
        unimplemented!()
    }
    fn visit_enum_variant(&mut self, enum_variant: &EnumVariant) -> T {
        unimplemented!()
    }
    fn visit_alias_decl(&mut self, alias: &AliasDecl) -> T {
        unimplemented!()
    }
    fn visit_block(&mut self, block: &Block) -> T {
        self.walk_block(block).pop().unwrap()
    }
    fn walk_block(&mut self, block: &Block) -> Vec<T> {
        let mut res = Vec::new();
        for statement in &block.statements {
            res.push(self.visit_statement(statement));
        }
        res
    }
    fn visit_statement(&mut self, statement: &Statement) -> T {
        match statement {
            Statement::Return(return_statement) => self.visit_return(return_statement),
            Statement::Expr(expression_statement) => self.visit_expr(expression_statement),
            Statement::Block(block) => self.visit_block(block),
            Statement::If(if_statement) => self.visit_if(if_statement),
            Statement::While(while_statement) => self.visit_while(while_statement),
            Statement::VarDecl(var_decl) => self.visit_var_decl(var_decl),
            Statement::Assign(assign) => self.visit_assign(assign),
            Statement::Print(print) => self.visit_print(print),
        }
    }
    fn visit_print(&mut self, print: &Print) -> T {
        self.visit_expr(&print.value)
    }
    fn visit_return(&mut self, return_: &Return) -> T {
        if let Some(expr) = &return_.value {
            self.visit_expr(expr)
        } else {
            unimplemented!()
        }
    }
    fn visit_if(&mut self, if_: &If) -> T {
        let res = self.visit_expr(&if_.condition);
        self.visit_block(&if_.then_block);
        if let Some(ref else_block) = if_.else_block {
            self.visit_block(else_block);
        };
        res
    }
    fn visit_while(&mut self, while_: &While) -> T {
        self.visit_expr(&while_.condition);
        self.visit_block(&while_.body)
    }
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> T {
        unimplemented!()
    }
    fn visit_assign(&mut self, assign: &Assign) -> T {
        unimplemented!()
    }

    fn visit_expr(&mut self, expr: &Expr) -> T {
        unimplemented!()
    }
    fn visit_bin_op(&mut self, binary_op: &BinOp) -> T {
        unimplemented!()
    }
    fn visit_un_op(&mut self, unary_op: &UnOp) -> T {
        unimplemented!()
    }
}
