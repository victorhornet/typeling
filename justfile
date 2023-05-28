parse SRC:
    nimbleparse -y grmtools src/language/typeling.l src/language/typeling.y {{SRC}} | less

rustparse SRC:
    cargo run -q -- -i {{SRC}} -lyn | less

run SRC:
    cargo run -q -- -i {{SRC}} | less