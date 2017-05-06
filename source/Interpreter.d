module VM.Interpreter;

import std.stdio: writeln;
import VM.Instruction;
import VM.Mode;
import VM.Register;
import VM.OpCode;
import VM.Stack;

alias Callable = void function(ref const OpCode, ref Interpreter);

struct Interpreter
{
private:
    ubyte[OpCode.size][] opcodes;
    uint pc;
    bool running = true;
    int[Register.max] register;
    int[uint] variables;
    uint vindex;
    Stack stack;
    Callable[Instruction] callbacks;

public:
    void append(in OpCode opcode)
    {
        this.opcodes ~= opcode.bits;
    }

    void append(in Instruction instr, Callable callback)
    {
        this.callbacks[instr] = callback;
    }

    void reset()
    {
        this.pc = 0;
    }

    private auto inc()
    {
        return this.pc++;
    }

    private auto dec()
    {
        return this.pc--;
    }

    private auto fetch()
    {
        return this.opcodes[this.inc];
    }

    void stop()
    {
        this.running = false;
    }

    void setRegister(in Register reg, int value)
    {
        writeln("Write into Register: ", reg, " = ", value);
        this.register[reg - 1] = value;
    }

    void setRegister(in Register r1, in Register r2)
    {
        this.setRegister(r1, this.getRegister(r2));
    }

    auto getRegister(in Register reg)
    {
        writeln("Read from Register: ", reg);
        return this.register[reg - 1];
    }

    void setIndex(uint index)
    {
        this.vindex = index;
    }

    void setIndex(in Register reg)
    {
        this.setIndex(this.getRegister(reg));
    }

    auto index() const
    {
        return this.vindex;
    }

    void push(int value)
    {
        this.stack.push(value);
    }

    void push(in Register reg)
    {
        this.push(this.getRegister(reg));
    }

    void pop(in Register reg)
    {
        this.setRegister(reg, this.pop);
    }

    auto pop()
    {
        return this.stack.pop;
    }

    void setVariable(uint index, int value)
    {
        writeln("Write into Variable: ", index, " = ", value);
        this.variables[index] = value;
    }

    void setVariable(uint index, in Register reg)
    {
        this.setVariable(index, this.getRegister(reg));
    }

    auto getVariable(uint index)
    {
        writeln("Read from Variable: ", index);
        return this.variables[index];
    }
    
    void eval(in ubyte[] bytes)
    {
        immutable opcode = OpCode(bytes);
        auto callback = opcode.instruction in this.callbacks;
        if (callback !is null) {
            (*callback)(opcode, this);
        }
    }

    void run()
    {
        while (this.running)
        {
            this.eval(this.fetch());
        }
    }
}