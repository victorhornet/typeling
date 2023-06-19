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
use std::{env, fs, path::Path, process::ExitCode};
use type_system::TypeSystem;

lrlex_mod!("language/typeling.l");
lrpar_mod!("language/typeling.y");

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub struct Args {
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

    #[arg(long, default_value = "false")]
    no_run: bool,

    output: Option<String>,
}

fn main() -> Result<(), ExitCode> {
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
                    return Ok(());
                }

                let compiler_ctx = CompilerContext::new();
                let llvm_ctx = Context::create();

                match TypeSystem::new(compiler_ctx, &llvm_ctx).run(&lexer, &file) {
                    Ok((compiler_ctx, module)) => {
                        let mut codegen = CodeGen::new(&lexer, &llvm_ctx, module, compiler_ctx);
                        codegen.compile(&file, &args);
                    }
                    Err(type_check_errors) => {
                        for err in type_check_errors {
                            eprintln!("{}", err);
                        }
                        return Ok(());
                    }
                };
            }
        }
        None => eprintln!("Parse failed"),
    };
    Ok(())
}
