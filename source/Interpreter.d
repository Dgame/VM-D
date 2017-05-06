module VM.Interpreter;

import std.stdio: writeln;
import VM.Instruction;
import VM.Mode;
import VM.Register;
import VM.OpCode;

struct Interpreter
{
private:
    ubyte[][] opcodes;
    uint pc;
    bool running = true;
    int[Register.max] register;
    void function(ref const OpCode, ref Interpreter)[Instruction] callbacks;

public:
    void append(in OpCode opcode)
    {
        this.opcodes ~= opcode.bits.dup;
    }

    void append(in Instruction instr, void function(ref const OpCode, ref Interpreter) callback)
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

    auto getRegister(in Register reg)
    {
        writeln("Read from Register: ", reg);
        return this.register[reg - 1];
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