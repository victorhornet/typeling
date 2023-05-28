pub mod ast;
pub mod visitors;

use clap::Parser;
use inkwell::context::Context;
use lrlex::{lrlex_mod, LexerDef};
use lrpar::{lrpar_mod, Lexeme, Lexer, NonStreamingLexer};
use std::{env, fs, path::Path};
use visitors::{CodeGen, TypeChecker};

lrlex_mod!("typeling.l");
lrpar_mod!("typeling.y");

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    #[arg(short, long)]
    input: String,

    #[arg(short, default_value = "false")]
    lex: bool,

    #[arg(short, default_value = "false")]
    yacc: bool,

    #[arg(short, long, default_value = "false")]
    no_codegen: bool,

    output: Option<String>,
}

fn main() {
    let lexerdef = typeling_l::lexerdef();
    let args = Args::parse();
    let input = fs::read_to_string(Path::new(&args.input)).expect("Failed to read input");
    let lexer = lexerdef.lexer(&input);
    if args.lex {
        for r in lexer.iter() {
            match r {
                Ok(l) => {
                    let rule = lexerdef.get_rule_by_id(l.tok_id()).name.as_ref();
                    println!("{:?} {}", rule, lexer.span_str(l.span()))
                }
                Err(e) => {
                    println!("LEX Error: {e:?}");
                    continue;
                }
            }
        }
    }
    let (res, errs) = typeling_y::parse(&lexer);

    for e in errs {
        println!("{}", e.pp(&lexer, &typeling_y::token_epp));
    }

    let ast = match res {
        Some(ref r) => {
            if let Ok(file) = r {
                file
            } else {
                panic!("Parser found errors!");
            }
        }
        None => panic!("Parse failed (no result)!"),
    };

    if args.yacc {
        println!("{ast:#?}");
    }

    let mut typechecker = TypeChecker::new();
    typechecker.check(ast).expect("Type checking failed");

    if args.no_codegen {
        return;
    }

    match res {
        Some(r) => {
            if let Ok(file) = r {
                let context = Context::create();
                let mut codegen = CodeGen::new(&lexer, &context);
                codegen.compile(&file);
            }
        }
        None => eprintln!("Parse failed"),
    }
}
