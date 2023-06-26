type List = Nil | Cons i64 List
fn zeros(size: i64) -> List {
    if size == 0 {
        return Nil;
    }
    return Cons(0, zeros(size - 1));
}

fn pprint_list(list: List) {
    printf("[");
    print_list(list);
    printf("]\n");
}

fn print_list(list: List) -> i64 {
    return case list {
        Cons (head, tail) => print_cons(head, tail),
        _ => 0,
    };
}

fn print_cons(head: i64, tail: List) -> i64 {
    is_last := case tail {
        Nil => -1,
        _ => 0,
    };

    
    printf("%lli", head);
    if not is_last {
        printf(", ");
    }
    print_list(tail);
    return 0;
}

fn main() -> i64 {
    pprint_list(zeros(0));
    pprint_list(zeros(1));
    pprint_list(zeros(20));
    return 0;
}