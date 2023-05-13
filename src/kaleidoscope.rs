lalrpop_mod!(pub grammar, "/kaleidoscope/kaleidoscope.rs");
pub mod ast;
pub mod tokens;
pub mod visitors;

#[cfg(test)]
mod tests {
    use inkwell::context::Context;
    use visitors::{LLVMCodeGen, Visitor};

    use super::*;

    #[test]
    fn it_works() {
        let res1 = grammar::FileParser::new().parse("extern foo()");
        println!("{:?}", res1);
        assert!(res1.is_ok());

        let res2 = grammar::FileParser::new().parse("extern foo(a, b, c)");
    }

    #[test]
    fn codegen_visitor() {
        println!("\n\ncodegen_visitor");
        let res = grammar::FileParser::new().parse("def boo(a b c) boo(1,2,3)");
        println!("{:?}", res);
        assert!(res.is_ok());
        println!("\n");
        let file = res.unwrap();
        let context = Context::create();
        let mut codegen = LLVMCodeGen::new(&context);
        codegen.visit_file(&file);
        println!("\n");
    }
}
