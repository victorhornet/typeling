pub mod ast;
pub mod visitors;

use clap::Parser;
use inkwell::context::Context;
use lrlex::lrlex_mod;
use lrpar::lrpar_mod;
use std::{env, fs, path::Path};
use visitors::{CodeGen, SpanPrinter};

lrlex_mod!("typeling.l");
lrpar_mod!("typeling.y");

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    #[arg(short, long)]
    input: String,

    output: Option<String>,
}

fn main() {
    let lexerdef = typeling_l::lexerdef();
    let args = Args::parse();
    let input = fs::read_to_string(Path::new(&args.input)).expect("Failed to read input");
    let lexer = lexerdef.lexer(&input);
    let (res, errs) = typeling_y::parse(&lexer);
    for e in errs {
        println!("{}", e.pp(&lexer, &typeling_y::token_epp));
    }

    match res {
        Some(r) => {
            if let Ok(file) = r {
                SpanPrinter::new(&input).print(&file);
            }
        }
        None => eprintln!("Parse failed"),
    }

    {
        let context = Context::create();
        let codegen = CodeGen::new(&input, &context);
        println!("{:#?}", codegen);
    }
}
