module VM.Instruction;

enum Instruction : ubyte
{
    Halt = 0,
    Loadi,
    Loadv,
    Print,
    Add,
    Sub,
    Mul,
    Div,
    Equal,
    Not,
    Jmp,
    JmpIf,
}