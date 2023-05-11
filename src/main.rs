pub mod ast;
#[macro_use]
extern crate lalrpop_util;
lalrpop_mod!(pub calculator1); // synthesized by LALRPOP
lalrpop_mod!(pub calculator4);
lalrpop_mod!(pub typeling);

fn main() {
    println!("Hello, world!");
}

#[cfg(test)]
mod tests {
    use super::{
        ast::{Expr, OpCode},
        calculator1, calculator4, typeling,
    };
    #[test]
    fn calculator1() {
        assert!(calculator1::TermParser::new().parse("22").is_ok());
        assert!(calculator1::TermParser::new().parse("(22)").is_ok());
        assert!(calculator1::TermParser::new().parse("((((22))))").is_ok());
        assert!(calculator1::TermParser::new().parse("((22)").is_err());
    }

    #[test]
    fn calculator4() {
        let parser = calculator4::ExprParser::new();
        let res = parser.parse("1 + 2 * 3").expect("parser should not fail");
        assert_eq!(
            *res,
            Expr::Op(
                Box::new(Expr::Number(1)),
                OpCode::Add,
                Box::new(Expr::Op(
                    Box::new(Expr::Number(2)),
                    OpCode::Mul,
                    Box::new(Expr::Number(3))
                ))
            )
        );
        let expr = parser
            .parse("22 * 44 + 66")
            .expect("parser should not fail");
        assert_eq!(&format!("{:?}", expr), "((22 * 44) + 66)");
    }

    #[test]
    fn typeling() {
        typeling::ProgParser::new().parse("22").unwrap();
    }
}
