# Typeling

Typeling is a prototype language for experimenting with type systems. It is a statically typed, imperative language with a C-like syntax. It is designed to be simple and easy to understand, and to be used as an introduction to algebraic data types.

## Installation

### Requirements

- [Rust toolchain](https://rustup.rs/)
- [LLVM (major version 14)](https://llvm.org/)

Optionally, the `LLVM_SYS_140_PREFIX` environment variable should be set to the LLVM installation path.

### Install

To install the `Typeling` compiler, clone the repository and run `cargo install` in the root directory:

```bash
git clone https://github.com/victorhornet/typeling.git
cd typeling
cargo install --path .
```

Optionally, if the build fails because the LLVM installation is not found, the `LLVM_SYS_140_PREFIX` environment variable should be set to the LLVM installation path. For example:

```bash
LLVM_SYS_140_PREFIX=/opt/homebrew/opt/llvm@14 cargo install --path .
```

#### Running with Docker

Alternatively, a Docker image of the compiler is available on [Docker Hub](https://hub.docker.com/r/victorhornet/typeling).

```bash
docker pull victorhornet/typeling
```

or can be built from the `Dockerfile` in the root directory:

```bash
docker build -t victorhornet/typeling .
```

Example alias for the run command:

```bash
alias typeling="docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) victorhornet/typeling typeling"
```

### Usage

Once installed, the compiler can be used with the `typeling` command:

```bash
typeling [OPTIONS] <INPUT_FILE>
```

For more information about the available options, run `typeling --help`.

## Features (WIP)

### Comments

```rust
// Single line comment

/*
    This is a 
    multi-line 
    comment
*/
```

### Primitive data types

The only primitive data type in Typeling is a 64-bit integer (`i64`).

### Variables

Variables are statically typed.

```typeling
x : i64 = 5; // type specified
y := 2;      // type inference 
x = 2;
```

### User-defined types

#### Format

Type definitions have the following format:

```typeling
"type" name = constructor | constructor | ...
```

Alternatively, a shorthand notation can be used for types with only one constructor:

```typeling
"type" constructor
```

which is the same as defining a type with the same name as its constructor.

#### Examples

##### Unit constructors

```typeling
// standard notation
type UnitType1 = UnitType1 

// shorthand notation
type UnitType2
```

##### Tuple constructors

```typeling
// standard notation
type TupleType1 = TupleType1 i64 i64   

// alternative notation
type TupleType2 = TupleType2(i64, i64) 

// shorthand notation
type TupleType3(i64, i64) 
```

##### Struct constructors

```typeling
// standard notation
type StructType1 = StructType1 x:i64 y:i64

// alternative notation
type StructType2 = StructType2 {
    x: i64,
    y: i64,
}

// shorthand notation
type StructType3 {
    x: i64,
    y: i64,
}
```

##### Sum types

```typeling
type EnumType = UnitVariant
              | TupleVariant(i64)
              | StructVariant {
                  x: i64,
                  y: i64,
              }

type List = Node i64 List | Nil
```

### pattern matching

Typeling features a `case` expression which can be used to pattern match on user-defined types.

```typeling
list := Node (1, Node(2, Nil))
case_result := case list {
    Node (x, Node(y, _)) => x + y,
    Node (x, Nil) => x,
    _ => 0,
};
```

### loops

```typeling
while condition {
    //body
}
```

### conditionals

```typeling
if cond {
    //body
} else {
    //body
}
```

### functions

```typeling
fn hello() {
    printf("Hello world!\n");
}

fn ten() -> i64 {
    return 10;
}

fn main() {
    hello();
}
```
