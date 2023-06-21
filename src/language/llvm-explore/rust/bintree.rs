enum BinTree {
    Branch(i64, Box<BinTree>, Box<BinTree>),
    Leaf,
}
