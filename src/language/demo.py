from __future__ import annotations
from dataclasses import dataclass

@dataclass
class Branch:
    value: int
    left: BTree
    right: BTree

BTree = Branch | None

def insert(x: int, root: BTree) -> BTree:
    match root:
        case None:
            return Branch(x, None, None)
        case Branch(y,left,right):
            return Branch(y, insert(x, left), right) if x < y else Branch(y, left, insert(x, right))

def get_min(root: BTree) -> int:
    match root:
        case Branch (x, None, _):
            return x,
        case Branch (_, left, _):
            return get_min(left),


if __name__ == "__main__":
    x = None
    tree = None
    i = 1000
    while i > 0:
        tree = insert(i, tree)
        i = i - 1
    tree = insert(5, tree)
    tree = insert(3, tree)
    tree = insert(7, tree)
    tree = insert(4, tree)
    tree = insert(6, tree)
    tree = insert(2, tree)
    x = get_min(tree)
    
    print(x)



