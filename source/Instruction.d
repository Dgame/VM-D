module VM.Instruction;

enum Instruction: ubyte
{
    Halt = 0,
    Move,
    Assign,
    Index,
    Push,
    Pop,
    Print,
    Add,
    Sub,
    Mul,
    Div,
    Equal,
    Not,
    Smaller,
    SmallerEqual,
    Jmp,
    JmpIf,
}