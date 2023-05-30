# Typeling

Typeling is a simple programming language written for one of my Bachelor graduation projects. Its main focus are algebraic data types.

## Features

### Primitive data types

#### integers (i64)
#### floats (f64)
#### booleans
#### strings


### Comments

```rust
// Single line comment

/*
    This is a 
    multi-line 
    comment
*/

```

### Variables

Variables are statically typed.

```python
x : i64 = 5; // type specified
y := 2;      // type inference 

x = 2;
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
fn function() {
    x: bool;
    y: f64;
    z: 64 = 0;

    z = 5 + 5;
}

fn another_function() -> i32 {
    return 10;
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
