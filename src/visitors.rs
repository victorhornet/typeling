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
}
