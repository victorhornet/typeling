#[macro_use]
extern crate lalrpop_util;

pub mod ast;
pub mod visitors;

lalrpop_mod!(pub typeling_lalr, "/typeling.rs");

use lrlex::lrlex_mod;
use lrpar::lrpar_mod;
use std::env;

lrlex_mod!("typeling.l");
lrpar_mod!("typeling.y");

fn main() {
    // let lexerdef = typeling_l::lexerdef();
    // let args: Vec<String> = env::args().collect();
    // let lexer = lexerdef.lexer(&args[1]);
    // println!("{:?}", lexer);
    // let (res, errs) = typeling_y::parse(&lexer);
    // for e in errs {
    //     println!("{}", e.pp(&lexer, &typeling_y::token_epp));
    // }
    // match res {
    //     Some(r) => println!("{r:?}"),
    //     None => eprintln!("Parse failed"),
    // }

    println!("Hello, world!");
}
