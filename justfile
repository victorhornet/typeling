parse SRC:
    nimbleparse -y grmtools src/language/typeling.l src/language/typeling.y {{SRC}}

rustparse SRC:
    cargo run -- -i {{SRC}} -lyn

run SRC:
    cargo run -- -i {{SRC}}