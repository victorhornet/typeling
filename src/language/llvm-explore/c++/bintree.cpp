// generate a BinTree algebraic data type
// which is either a Leaf or a Branch (64 bit integer, BinTree, BinTree)
// the Leaf is a unit type
// the Branch has a 64 bit integer value and two BinTree children
// it should be a tagged union

struct Leaf
{
};

struct Branch
{
    long x;
    BinTree *left;
    BinTree *right;
};

struct BinTree
{
    enum class Tag
    {
        Leaf,
        Branch
    };
    Tag tag;
    union
    {
        Leaf leaf;
        Branch branch;
    };
};

int main(int argc, char const *argv[])
{
    BinTree tree;
    return 0;
}
