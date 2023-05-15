pub mod ast;

lalrpop_mod!(pub calculator1, "/calculator/calculator1.rs"); // synthesized by LALRPOP
lalrpop_mod!(pub calculator4, "/calculator/calculator4.rs");
lalrpop_mod!(pub calculator6, "/calculator/calculator6.rs");

#[derive(Debug)]
pub enum Calculator6Error {
    InputTooLarge,
    EvenNumber,
}
