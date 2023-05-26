# Typeling

Typeling is a simple programming language written for one of my Bachelor graduation projects. Its main focus are algebraic data types.

## Features

### comments

```typeling
// Single line comment

/*
Multi line comments
*/

```

### variables

```rust
let x : type = value;
```

```rust
let x = 1;
```

### loops

```rust
while condition {
	//body
}

```

### conditionals

### functions

```rust
fn function() {
    let x: something;
    let y: something_else;
    let z: i32 = 0;

    z = 5 + 5;
} 

fn main() {
    function();
}
```

### algebraic data types

```rust
type UnitType; // no keys

type TupleType(i32); // keys are integers starting from 0

type StructType { // keys are strings
    x: i32,
    y: i32,
}

impl StructType {
    fn something() {}
}

type EnumType1
    = UnitType
    | TupleType
    | StructType
    ;

type EnumType2
    = UnitVariant
    | TupleVariant(i32)
    | StructVariant {
        x: i32,
        y: i32,
    }
    ;

alias TypeAlias = i32;

alias TypeAlias2
    = StructType 
    | UnitType
    ;

```
