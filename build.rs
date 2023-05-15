extern crate lalrpop;

use cfgrammar::yacc::{YaccKind, YaccOriginalActionKind};
use lrlex::CTLexerBuilder;

fn main() {
    CTLexerBuilder::new()
        .lrpar_config(|ctp| {
            ctp.yacckind(YaccKind::Original(YaccOriginalActionKind::NoAction))
                .grammar_in_src_dir("typeling.y")
                .unwrap()
        })
        .lexer_in_src_dir("typeling.l")
        .unwrap()
        .build()
        .unwrap();
}
