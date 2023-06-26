%%
named_arg_list -> ParseResult<HashMap<String,Expr>>
    : "IDENT" "COLON" expr { init_map($lexer.span_str($1?.span()).to_string(), $3?) }
    | named_arg_list "COMMA" "IDENT" "COLON" expr {
        let mut map = $1?;
        let arg_name = $lexer.span_str($3?.span()).to_string();
        if map.contains_key(&arg_name) {
            return Err(Box::new(ParseError::DuplicateFieldName(arg_name)));
        }
        map.insert(arg_name, $5?);
        Ok(map)
    }
    ;

expr -> ParseResult
    : "IDENT" "LBRACE" named_arg_list "RBRACE" { Ok( Expr::ConstructorCall {name: $1?.span(), args: ConstructorCallArgs::Struct($3?), span: $span}) }
%%