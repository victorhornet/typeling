type Tuple(i64,i64)
type Test = A i64 i64 | B Tuple

fn td() -> Tuple {
    return Tuple(0,0);
}

fn sum(x: Test) -> i64 {
    return case x {
        A (a,b) => a + b,
        B (Tuple (a,b)) => a + b,
        _ => 0,
    };
}

fn main() -> i64 {
    x := A (1,2);
    y := B (Tuple(3,4));

    z := sum(x) + sum(y);

    printf("z = %lli\n", z);

    return 0;
}