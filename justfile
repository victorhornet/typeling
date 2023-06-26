parse SRC:
    nimbleparse -y grmtools src/language/grammar/typeling.l src/language/grammar/typeling.y {{SRC}} 

rustparse SRC:
    cargo run -q -- {{SRC}} -lyn

run SRC:
    cargo run -q -- {{SRC}} 

test:
    cargo test -q -- --nocapture --color always

dockerbuild:
    docker build . -t victorhornet/typeling   

dockerrun:
    docker run -it victorhornet/typeling sh
