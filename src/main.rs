pub mod ast;
pub mod codegen;
pub mod compiler;
pub mod type_system;
pub mod visitors;

use clap::Parser;
use codegen::CodeGen;
use compiler::CompilerContext;
use inkwell::context::Context;
use lrlex::{lrlex_mod, LexerDef};
use lrpar::{lrpar_mod, Lexeme, Lexer, NonStreamingLexer};
use std::{env, fs, path::Path};
use type_system::TypeSystem;

lrlex_mod!("language/typeling.l");
lrpar_mod!("language/typeling.y");

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub struct Args {
    #[arg(short, long)]
    input: String,

    #[arg(short, default_value = "false")]
    lex: bool,

    #[arg(short, default_value = "false")]
    yacc: bool,

    #[arg(short, long, default_value = "false")]
    no_codegen: bool,

    #[arg(long, default_value = "false")]
    show_ir: bool,

    #[arg(long, default_value = "false")]
    emit_llvm: bool,

    #[arg(long, default_value = "false")]
    no_verify: bool,

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

    match res {
        Some(r) => {
            if let Ok(file) = r {
                if args.yacc {
                    println!("{file:#?}");
                }

                if args.no_codegen {
                    return;
                }

                //define items
                let mut compiler_ctx = CompilerContext::new();

                let mut type_system = TypeSystem::new(&mut compiler_ctx);
                type_system.type_definition_pass(&lexer, &file);
                //.type_check_pass(&lexer, &file);

                let context = Context::create();
                let mut codegen = CodeGen::new(&lexer, &context, compiler_ctx);
                codegen.compile(&file, &args);
            }
        }
        None => eprintln!("Parse failed"),
    }
}
