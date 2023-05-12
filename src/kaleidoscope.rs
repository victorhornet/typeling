lalrpop_mod!(pub grammar, "/kaleidoscope/kaleidoscope.rs");
pub mod ast;
pub mod tokens;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let res1 = grammar::FileParser::new().parse("extern foo()");
        println!("{:?}", res1);
        assert!(res1.is_ok());

        let res2 = grammar::FileParser::new().parse("extern foo(a, b, c)");
    }
}
