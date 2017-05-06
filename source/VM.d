module VM.Interpreter;

import std.stdio: writeln;
import VM.Instruction;
import VM.Mode;
import VM.Register;
import VM.OpCode;

struct Interpreter
{
    ubyte[][] opcodes;
    uint pc;
    bool running = true;
    int[Register.max] register;

    void append(in OpCode opcode)
    {
        this.opcodes ~= opcode.bits.dup;
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

    private void setRegister(in Register reg, int value)
    {
        writeln("Write into Register: ", reg, " = ", value);
        this.register[reg - 1] = value;
    }

    private auto getRegister(in Register reg)
    {
        writeln("Read from Register: ", reg);
        return this.register[reg - 1];
    }

    private void add(in Register r1, in Register r2, in Register r3)
    {
        this.setRegister(r3, this.getRegister(r1) + this.getRegister(r2));
    }

    private void equal(in Register r1, in Register r2)
    {
        this.setRegister(Register.ZX, this.getRegister(r1) == this.getRegister(r2));
    }

    private void not(in Register reg)
    {
        this.setRegister(Register.ZX, !this.getRegister(reg));
    }
    
    void eval(in ubyte[] bytes)
    {
        immutable opcode = OpCode(bytes);
        switch (opcode.instruction)
        {
            case Instruction.Halt:
                writeln("halt");
                running = false;
                break;
            case Instruction.Loadi:
                writeln("loadi");
                this.setRegister(opcode.register[0], opcode.value);
                break;
            case Instruction.Add:
                writeln("add: ", opcode.register);
                this.add(opcode.register[0], opcode.register[1], opcode.register[2]);
                break;
            case Instruction.IsEqual:
                writeln("is_equal: ", opcode.register);
                this.equal(opcode.register[0], opcode.register[1]);
                break;
            case Instruction.IsNot:
                writeln("is_not: ", opcode.register);
                this.not(opcode.register[0]);
                break;
            // case Instruction.Jmp:
            //     this.set(opcode.value);
            //     break;
            // case Instruction.JmpIf:
            //     this.setIf(opcode.value);
            //     break;
            case Instruction.Print:
                writeln("print: ", opcode.mode);
                switch (opcode.mode) {
                    case Mode.Immediate:
                        writeln(opcode.value);
                        break;
                    case Mode.Register:
                        writeln(this.getRegister(opcode.register[0]));
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
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