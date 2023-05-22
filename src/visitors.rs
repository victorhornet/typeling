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
