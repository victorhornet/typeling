parse SRC:
    nimbleparse -y grmtools src/typeling.l src/typeling.y {{SRC}}

rustparse SRC:
    cargo run -- -i {{SRC}} -lyn

run SRC:
    cargo run -- -i {{SRC}}