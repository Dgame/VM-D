module VM.Stack;

struct Stack
{
    private int[16] stack;
    private ubyte offset = 0;

    void push(int value)
    {
        this.stack[this.offset++] = value;
    }

    auto pop()
    {
        return this.stack[this.offset--];
    }
}