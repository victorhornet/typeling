parse SRC:
    nimbleparse -y grmtools src/language/typeling.l src/language/typeling.y {{SRC}} 

rustparse SRC:
    cargo run -q -- -i {{SRC}} -lyn

run SRC:
    cargo run -q -- -i {{SRC}} 

test:
    cargo test -q -- --nocapture --color always

dockerbuild:
    docker build . -t victorhornet/typeling   

dockerrun:
    docker run -it victorhornet/typeling sh
