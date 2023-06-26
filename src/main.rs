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

lrlex_mod!("language/grammar/typeling.l");
lrpar_mod!("language/grammar/typeling.y");

#[derive(Parser, Debug)]
#[command(author, version, about = "Typeling JIT compiler.", long_about = None)]
pub struct Args {
    #[arg(help = "Typeling input file to run")]
    input: String,

    #[arg(
        short = 'l',
        long,
        default_value = "false",
        help = "Display lexer tokens"
    )]
    emit_lex: bool,

    #[arg(
        short = 'y',
        long,
        default_value = "false",
        help = "Display parse tree"
    )]
    emit_yacc: bool,

    #[arg(long, default_value = "false", help = "Output LLVM IR to ./out.ll")]
    emit_llvm: bool,

    #[arg(long, default_value = "false", help = "Show LLVM IR")]
    show_ir: bool,

    #[arg(
        short,
        long,
        default_value = "false",
        help = "Stop before code generation phase"
    )]
    no_codegen: bool,

    #[arg(long, default_value = "false", help = "Don't run LLVM module verifier")]
    no_verify: bool,

    #[arg(long, default_value = "false", help = "Don't run the optimizer")]
    no_opt: bool,

    #[arg(
        long,
        default_value = "false",
        help = "Don't run the JIT execution engine"
    )]
    no_run: bool,
}

fn main() -> Result<(), ExitCode> {
    let lexerdef = typeling_l::lexerdef();
    let args = Args::parse();
    let input = fs::read_to_string(Path::new(&args.input)).expect("Failed to read input");
    let lexer = lexerdef.lexer(&input);
    if args.emit_lex {
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
                if args.emit_yacc {
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
