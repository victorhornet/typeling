use cfgrammar::yacc::YaccKind;
use lrlex::CTLexerBuilder;

fn main() {
    CTLexerBuilder::new()
        .lrpar_config(|ctp| {
            ctp.yacckind(YaccKind::Grmtools)
                .grammar_in_src_dir("language/typeling.y")
                .unwrap()
        })
        .lexer_in_src_dir("language/typeling.l")
        .expect("Initializing LexerBuilder failed")
        .build()
        .expect("Lexer build failed");
}
