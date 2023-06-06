struct Unit
{
};
struct Tuple
{
    long a;
    bool b;
    long c;
};

struct Struct
{
    long x;
    bool y;
};
union U
{
    Unit u;
    Tuple t;
    Struct s;
};
enum Tag
{
    Unit,
    Tuple,
    Struct
};
struct Enum
{
    Tag tag;
    U inner;
};

int main(int argc, char const *argv[])
{
    Enum e;
    return 0;
}
