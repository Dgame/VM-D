module VM.build;

import VM.OpCode;
import VM.Binary;
import VM.Instruction;
import VM.Register;
import VM.Mode;

auto opcode(in Instruction instr)
{
    return opcode(instr, Mode.None);
}

auto opcode(in Instruction instr, in Mode mode)
{
    return opcode(instr, mode, 0);
}

auto opcode(in Instruction instr, in Mode mode, int value)
{
    return OpCode(instr).put(mode).put(Binary!int(value));
}

auto halt()
{
    return opcode(Instruction.Halt);
}

auto loadv(int value, in Register reg)
{
    return opcode(Instruction.Loadv, Mode.Variable, value).put(reg);
}

auto loadi(int value, in Register reg)
{
    return opcode(Instruction.Loadi, Mode.Immediate, value).put(reg);
}

auto add(in Register r1, in Register r2)
{
    return add(r1, r2, r1);
}

auto add(in Register r1, in Register r2, in Register r3)
{
    return opcode(Instruction.Add, Mode.None).put(r1, r2, r3);
}

auto print(in Register reg)
{
    return opcode(Instruction.Print, Mode.Register).put(reg);
}

auto print(in Mode mode, int value)
{
    return opcode(Instruction.Print, mode, value);
}

auto equal(in Register r1, in Register r2)
{
    return opcode(Instruction.Equal).put(r1, r2);
}

auto not(in Register reg)
{
    return opcode(Instruction.Not).put(reg);
}