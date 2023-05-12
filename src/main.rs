pub mod calculator;
pub mod kaleidoscope;
#[macro_use]
extern crate lalrpop_util;

fn main() {
    println!("Hello, world!");
}

lalrpop_mod!(pub typeling);

#[cfg(test)]
mod tests {

    use crate::{
        calculator::{
            ast::{Calculator, Expr, OpCode, Visitor},
            calculator1, calculator4, calculator6,
        },
        typeling,
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
        let calculator = Calculator::new();
        let res = calculator.visit_expr(&expr);
        assert_eq!(res, 1034);
    }

    #[test]
    fn typeling() {
        typeling::ProgParser::new().parse("22").unwrap();
    }

    #[test]
    fn calculator6() {
        let expr1 = calculator6::ExprParser::new().parse("2147483648");
        let expr2 = calculator6::ExprParser::new().parse("2");
        println!("Expr1: {:?}", expr1);
        println!("Expr2: {:?}", expr2);
        assert!(expr1.is_err());
        assert!(expr2.is_err());
    }
}
