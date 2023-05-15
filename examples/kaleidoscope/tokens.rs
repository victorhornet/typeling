use codespan::ByteIndex;
use lalrpop_util::ParseError;
use void::Void;

#[derive(Copy, Clone, Debug, PartialEq)]
pub enum Token<'input> {
    Identifier(&'input str),
    Number(f64),
    Def,
    Extern,
    OpenParen,
    CloseParen,
    Comma,
}

impl<'input> Token<'input> {
    pub fn as_ident(&self) -> Option<&'input str> {
        match *self {
            Token::Identifier(id) => Some(id),
            _ => None,
        }
    }

    pub fn as_number(&self) -> Option<f64> {
        match *self {
            Token::Number(n) => Some(n),
            _ => None,
        }
    }
}

pub type Error<'input> = ParseError<ByteIndex, Token<'input>, Void>;
pub type Spanned<'input> = Result<(ByteIndex, Token<'input>, ByteIndex), Error<'input>>;

impl<'a> From<i32> for Token<'a> {
    fn from(other: i32) -> Token<'a> {
        Token::Number(other as f64)
    }
}

impl<'a> From<f64> for Token<'a> {
    fn from(other: f64) -> Token<'a> {
        Token::Number(other)
    }
}

impl<'a> From<&'a str> for Token<'a> {
    fn from(other: &'a str) -> Token<'a> {
        Token::Identifier(other)
    }
}
