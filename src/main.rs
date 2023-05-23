pub mod ast;
pub mod visitors;

use cfgrammar::Span;
use clap::Parser;
use inkwell::context::Context;
use lrlex::{lrlex_mod, LexerDef};
use lrpar::{lrpar_mod, Lexeme, Lexer, NonStreamingLexer};
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
    for r in lexer.iter() {
        match r {
            Ok(l) => {
                let rule = lexerdef.get_rule_by_id(l.tok_id()).name.as_ref();
                println!("{:?} {}", rule, lexer.span_str(l.span()))
            }
            Err(e) => {
                println!("{e:?}");
                continue;
            }
        }
    }
    let (res, errs) = typeling_y::parse(&lexer);
    for e in errs {
        println!("{}", e.pp(&lexer, &typeling_y::token_epp));
    }

    match res {
        Some(r) => {
            if let Ok(file) = r {
                SpanPrinter::new(&input).print(&file);
                let context = Context::create();
                let mut codegen = CodeGen::new(&lexer, &context);
                codegen.compile(&file);
            }
        }
        None => eprintln!("Parse failed"),
    }
}
